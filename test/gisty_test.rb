require File.dirname(__FILE__) + '/test_helper.rb'
require 'test/unit'
require 'pp'
require 'rr'
require 'fakeweb'

fixtures_path = Pathname.new(File.dirname(__FILE__)).join('fixtures').realpath
FakeWeb.allow_net_connect = false
stubs = [
  [
    :get,
    'https://api.github.com/gists?access_token=testaccesstoken',
    'gists_1'
  ],
  [
    :get,
    'https://api.github.com/gists?access_token=testaccesstoken&page=2',
    'gists_2'
  ],
  [
    :get,
    'https://api.github.com/gists?access_token=testaccesstoken&page=3',
    'gists_3'
  ],
  [
    :post,
    'https://api.github.com/gists?access_token=testaccesstoken',
    'gists_post'
  ]
]
stubs.each do |stub|
  head, body = IO.read(fixtures_path.join stub[2]).split("\r\n\r\n")
  h = head.split("\r\n").slice(1..-1).inject({}) { |r, i|
    tmp = i.split(':')
    r[tmp[0]] = tmp.slice(1..-1).join(':')
    r
  }
  h[:body] = body
  FakeWeb.register_uri(stub[0], stub[1], h)
end

class GistyTest < Test::Unit::TestCase
  include RR::Adapters::TestUnit

  def setup
    @gisty_dir = Pathname.new(File.dirname(__FILE__)).join('tmp')
    @gisty = Gisty.new @gisty_dir, :access_token => 'testaccesstoken'
    stub_kernel_system!
  end

  def teardown
    FileUtils.rm_rf @gisty_dir
  end

  def stub_kernel_system!
    stub(Kernel).system do |cmd|
      # puts "* '#{cmd}' *"
      case cmd
      when /^git clone/
        id = cmd.split(/[:.]/)[-2]
        system "mkdir -p #{id}"
        system "touch #{File.join(id, id)}"
      else
      end
    end
  end

  def test_unset_access_token
    assert_raise(Gisty::UnsetAuthInfoException) { Gisty.new @gisty_dir }
    assert_raise(Gisty::UnsetAuthInfoException) { Gisty.new @gisty_dir, :access_token => '' }
  end

  def test_mygists
    myg = @gisty.mygists
    assert_equal 30, myg[:content].size
    assert_not_nil myg[:link][:next]
    assert_not_nil myg[:link][:last]

    myg2 = @gisty.mygists :url => myg[:link][:next]
    assert_equal 30, myg2[:content].size
    assert_not_nil myg2[:link][:prev]
    assert_not_nil myg2[:link][:next]
    assert_not_nil myg2[:link][:last]
  end


  def test_all_mygists
    assert_equal 72, @gisty.all_mygists.size
  end

  def test_all_mygists_with_block
    @gisty.all_mygists { |gist| assert_not_nil gist['id'] }
  end

  def test_list
    FileUtils.mkdir_p @gisty_dir.join('111')
    open(@gisty_dir.join('111').join('test.txt'), 'w') { |f| f.puts 'test' }
    FileUtils.mkdir_p @gisty_dir.join('aaa')
    open(@gisty_dir.join('aaa').join('test.txt'), 'w') { |f| f.puts 'test' }
    FileUtils.mkdir_p @gisty_dir.join('commands')
    open(@gisty_dir.join('commands').join('test.rb'), 'w') { |f| f.puts '#test' }

    list = @gisty.list
    assert_equal 1, list[:public].size
    assert_equal 1, list[:private].size
    assert_equal 2, @gisty.local_gist_directories.size
    assert_equal 2, @gisty.local_ids.size
  end

  def test_sync
    ids = @gisty.remote_ids
    assert !ids.all? { |i| @gisty_dir.join(i).exist? }
    @gisty.sync
    assert ids.all? { |i| @gisty_dir.join(i).exist? }
  end

  # require stdin input y/n
  # def test_sync_delete
  #   id = '12345'
  #   assert !@gisty.remote_ids.include?(id)
  #   @gisty.clone id
  #   assert @gisty_dir.join(id).exist?
  #   @gisty.sync true
  #   assert !@gisty_dir.join(id).exist?
  # end

  def test_delete
    id = '11111'
    pn = @gisty_dir.join id
    @gisty.clone id
    @gisty.delete id
    assert !pn.exist?
  end

  def test_build_params
    path = File.join('test', 'fixtures', 'foo.user.js')
    params = @gisty.build_params path
    assert_equal 'foo.user.js', params['files'].keys[0]
    assert_equal "// foo.user.js\n", params['files']['foo.user.js']['content']
  end

  def test_build_params_multi
    path1 = File.join('test', 'fixtures', 'foo.user.js')
    path2 = File.join('test', 'fixtures', 'bar.user.js')
    params = @gisty.build_params [path1, path2]

    assert_not_nil params['files']['foo.user.js']
    assert_not_nil params['files']['bar.user.js']

    assert_equal "// foo.user.js\n", params['files']['foo.user.js']['content']
    assert_equal "// bar.user.js\n", params['files']['bar.user.js']['content']
  end

  def test_ssl_ca_option_default
    ca = '/ssl_ca_path/cert.pem'
    g = Gisty.new @gisty_dir, :access_token => 'testaccess_token'
    assert_nil g.instance_eval { @ssl_ca }
  end

  def test_set_ssl_ca_option
    ca = '/ssl_ca_path/cert.pem'
    g = Gisty.new @gisty_dir, :access_token => 'testaccess_token', :ssl_ca => ca
    assert_equal ca, g.instance_eval { @ssl_ca }
  end

  def test_ssl_verify_default
    g = Gisty.new @gisty_dir, :access_token => 'testaccess_token'
    assert_equal OpenSSL::SSL::VERIFY_PEER, g.instance_eval { @ssl_verify }
  end

  def test_set_ssl_verify_option
    opt = { :access_token => 'testaccess_token' }

    g = Gisty.new @gisty_dir, opt.merge(:ssl_verify => :none)
    assert_equal OpenSSL::SSL::VERIFY_NONE, g.instance_eval { @ssl_verify }

    g = Gisty.new @gisty_dir, opt.merge(:ssl_verify => 'NONE')
    assert_equal OpenSSL::SSL::VERIFY_NONE, g.instance_eval { @ssl_verify }

    g = Gisty.new @gisty_dir, opt.merge(:ssl_verify => 'None')
    assert_equal OpenSSL::SSL::VERIFY_NONE, g.instance_eval { @ssl_verify }

    g = Gisty.new @gisty_dir, opt.merge(:ssl_verify => OpenSSL::SSL::VERIFY_NONE)
    assert_equal OpenSSL::SSL::VERIFY_NONE, g.instance_eval { @ssl_verify }
  end

  def test_create
    # stub
    path = File.join('test', 'fixtures', 'foo.user.js')
    r = @gisty.create path
    assert_not_nil r
  end
end
