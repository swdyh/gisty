cmd :private_post, 'file1 file2 ...', 'post new private gist' do |fs|
  if fs.size > 0
    begin
      url = @g.create fs, :private => true
    rescue Exception => e
      puts "Error: #{e}"
    else
      id = url.split('/').last
      html_url = "https://gist.github.com/#{id}"
      puts html_url
      system "open #{html_url}" if /darwin/ === RUBY_PLATFORM
      @g.clone id
    end
  end
end
