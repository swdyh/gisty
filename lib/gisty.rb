require 'pathname'
require 'net/http'
require 'open-uri'
require 'rubygems'
require 'nokogiri'

class Gisty
  VERSION  = '0.0.3'
  GIST_URL = 'http://gist.github.com/'

  def self.extract_ids url
    doc = Nokogiri::HTML open(url)
    doc.css('.file .info a').map { |i| i['href'].sub('/', '') }
  end

  def self.extract url
    doc = Nokogiri::HTML open(url)
    {
      :id => url.split('/').last,
      :author => doc.css('#owner a').inner_text,
      :files => doc.css('.meta .info').map { |i| i.inner_text.strip },
      :clone => doc.css('a[rel="#git-clone"]').inner_text,
    }
  end

  def initialize path, login = nil, token = nil
    @auth = (login && token) ? { :login => login, :token => token } : auth
    @auth_query = "login=#{@auth[:login]}&token=#{@auth[:token]}"
    @dir  = Pathname.pwd.realpath.join path
    FileUtils.mkdir_p @dir unless @dir.exist?
  end

  def page_num
    url = GIST_URL + 'mine?' + @auth_query
    doc = Nokogiri::HTML open(url)
    as = doc.css('.pagination a')
    (as.size < 2) ? 1 : as[as.size - 2].inner_text.to_i
  end

  def page_urls
    Array.new(page_num) { |i| GIST_URL + "mine?page=#{i + 1}&#{@auth_query}" }
  end

  def remote_ids
    page_urls.map { |u| Gisty.extract_ids u }.flatten.uniq.sort
  end

  def clone id
    FileUtils.cd @dir do
      c = "git clone git@gist.github.com:#{id}.git"
      Kernel.system c
    end
  end

  def list
    dirs = Pathname.glob(@dir.to_s + '/*')
    dirs.map do |i|
      [i.basename.to_s,
       Pathname.glob(i.to_s + '/*').map { |i| i.basename.to_s }]
    end
  end

  def local_ids
    dirs = Pathname.glob(@dir.to_s + '/*')
    dirs.map { |i| i.basename.to_s }
  end

  def delete id
    FileUtils.rm_rf @dir.join(id) if @dir.join(id).exist?
  end

  def sync delete = false
    remote = remote_ids
    local  = local_ids

    if delete
      (local - remote).each do |id|
        # puts "delete #{id}"
        delete id
      end
      ids = remote
    else
      ids = (remote + local).uniq
    end

    FileUtils.cd @dir do
      ids.each do |id|
        if File.exist? id
          FileUtils.cd id do
            c = "git pull"
            Kernel.system c
          end
        else
          c = "git clone git@gist.github.com:#{id}.git"
          Kernel.system c
        end
      end
    end
  end

  def auth
    user  = `git config --global github.user`.strip
    token = `git config --global github.token`.strip
    user.empty? ? {} : { :login => user, :token => token }
  end

  def post params
    url = URI.parse('http://gist.github.com/gists')
    req = Net::HTTP.post_form(url, params)
    req['Location']
  end

  def build_params paths
    list = (Array === paths ? paths : [paths]).map { |i| Pathname.new i }
    raise 'file error' if list.any?{ |i| !i.file? }

    params = {}
    list.each_with_index do |i, index|
      params["file_ext[gistfile#{index + 1}]"] = i.extname
      params["file_name[gistfile#{index + 1}]"] = i.basename.to_s
      params["file_contents[gistfile#{index + 1}]"] = IO.read(i)
    end
    params
  end

  def create paths, opt = { :private => false }
    params = build_params paths
    if opt[:private]
      params['private'] = 'on'
    end
    post params.merge(auth)
  end
end
