require 'pathname'
require 'net/http'
require 'net/https'
require 'open-uri'
require 'fileutils'
require 'rubygems'
require 'json'

class Gisty
  VERSION   = '0.2.0'
  GIST_URL  = 'https://gist.github.com/'
  GISTY_URL = 'https://github.com/swdyh/gisty'
  COMMAND_PATH = Pathname.new(File.join(File.dirname(__FILE__), 'commands')).realpath.to_s

  class UnsetAuthInfoException < Exception
  end

  class InvalidFileException < Exception
  end

  class PostFailureException < Exception
  end

  def initialize path, login = nil, token = nil, opt = {}
    if login.class == Hash
      opt = login
    end
    if opt[:access_token] && opt[:access_token].size > 0
      @access_token = opt[:access_token].strip
    else
      raise UnsetAuthInfoException
    end
    @dir = Pathname.pwd.realpath.join path
    FileUtils.mkdir_p @dir unless @dir.exist?
    @ssl_ca = opt[:ssl_ca]
    @ssl_verify = case opt[:ssl_verify]
                  when :none, /none/i, OpenSSL::SSL::VERIFY_NONE
                    OpenSSL::SSL::VERIFY_NONE
                  else
                    OpenSSL::SSL::VERIFY_PEER
                  end
  end

  def all_mygists &block
    r = []
    opt = {}
    limit = 30
    limit.times do
      tmp = mygists opt
      r << tmp[:content]

      if block
        tmp[:content].each {|i| block.call i }
      end

      if tmp[:link][:next]
        opt[:url] = tmp[:link][:next]
      else
        break
      end
    end
    r.flatten
  end

  def mygists opt = {}
    url = opt[:url] || ('https://api.github.com/gists?access_token=%s' % @access_token)
    open_uri_opt = {}
    if @ssl_ca && OpenURI::Options.key?(:ssl_ca_cer)
      open_uri_opt[:ssl_ca_cert] = @ssl_ca
    end
    if @ssl_verify && OpenURI::Options.key?(:ssl_verify_mode)
      open_uri_opt[:ssl_verify_mode] = @ssl_verify
    end
    OpenURI.open_uri(url, open_uri_opt) do |f|
      { :content => JSON.parse(f.read), :link => Gisty.parse_link(f.meta['link']) || {} }
    end
  end

  def self.parse_link link
    return nil if link.nil?
    link.split(', ').inject({}) do |r, i|
      url, rel = i.split '; '
      r[rel.gsub(/^rel=/, '').gsub('"', '').to_sym] = url.gsub(/[<>]/, '').strip
      r
    end
  end

  def remote_ids
    all_mygists.map { |i| i['id'] }.sort
  end

  def clone id
    FileUtils.cd @dir do
      c = "git clone git@gist.github.com:#{id}.git"
      Kernel.system c
    end
  end

  def list
    dirs = local_gist_directories.map do |i|
      [i.basename.to_s, Pathname.glob(i.to_s + '/*').map { |i| i.basename.to_s }]
    end
    re_pub = /^\d+$/
    pub = dirs.select { |i| re_pub.match(i.first) }.sort_by { |i| i.first.to_i }.reverse
    pri = dirs.select { |i| !re_pub.match(i.first) }.sort_by { |i| i.first }
    { :public => pub, :private => pri }
  end

  def local_ids
    local_gist_directories.map {|i| i.basename.to_s }
  end

  def local_gist_directories
    Pathname.glob(@dir.to_s + '/*').select do |i|
      i.directory? && !i.to_s.match(/^_/) && i.basename.to_s != 'commands'
    end
  end

  def delete id
    FileUtils.rm_rf @dir.join(id) if @dir.join(id).exist?
  end

  def sync delete = false
    local = local_ids
    FileUtils.cd @dir do
      r = all_mygists do |gist|
        unless File.exists? gist['id']
          c = "git clone git@gist.github.com:#{gist['id']}.git"
          Kernel.system c
        end
        local -= [gist['id']]
      end

      if local.size > 0 && delete
        local.each do |id|
          print "delete #{id}? [y/n]"
          confirm = $stdin.gets.strip
          if confirm == 'y' || confirm == 'yes'
            puts "delete #{id}"
            delete id
          else
            puts "skip #{id}"
          end
        end
      end
      open('meta.json', 'w') { |f| f.write JSON.pretty_generate(r) }
    end
  end

  def pull_all
    ids = local_ids
    FileUtils.cd @dir do
      ids.each do |id|
        if File.exist? id
          FileUtils.cd id do
            c = "git pull"
            Kernel.system c
          end
        end
      end
    end
  end

  def post params
    url = URI.parse('https://api.github.com/gists')
    req = Net::HTTP::Post.new url.path + '?access_token=' + @access_token
    req.body = params.to_json
    if ENV['https_proxy']
      proxy_uri = URI.parse(ENV['https_proxy'])
      https = Net::HTTP::Proxy(proxy_uri.host, proxy_uri.port).new(url.host, url.port)
    else
      https = Net::HTTP.new(url.host, url.port)
    end
    https.use_ssl = true
    https.verify_mode = @ssl_verify
    https.verify_depth = 5
    if @ssl_ca
      https.ca_file = @ssl_ca
    end
    res = https.start {|http| http.request(req) }
    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      res['Location']
    else
      raise PostFailureException, res.inspect
    end
  end

  def build_params paths
    list = (Array === paths ? paths : [paths]).map { |i| Pathname.new i }
    raise InvalidFileException if list.any?{ |i| !i.file? }

    params = {}
    params['files'] = {}
    list.each_with_index do |i, index|
      params['files'][i.basename.to_s] = { 'content' => IO.read(i) }
    end
    params
  end

  def create paths, opt = { :private => false }
    params = build_params paths
    if opt[:private]
      params['public'] = false
    else
      params['public'] = true
    end
    post params
  end

  # `figlet -f contributed/bdffonts/clb8x8.flf gisty`.gsub('#', 'm')
  AA = <<-EOS
            mm                mm             
                              mm             
  mmmmmm  mmmm      mmmmm   mmmmmm   mm  mm  
 mm   mm    mm     mm         mm     mm  mm  
 mm   mm    mm      mmmm      mm     mm  mm  
  mmmmmm    mm         mm     mm      mmmmm  
      mm  mmmmmm   mmmmm       mmm       mm  
  mmmmm                               mmmm   
  EOS
end
