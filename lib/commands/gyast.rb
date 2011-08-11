if /darwin/ === RUBY_PLATFORM
  cmd :gyast, '', 'post screencapture' do
    now = Time.now.to_i
    file_jpg = "/tmp/#{now}.jpg"
    system "screencapture -i -t jpg \"#{file_jpg}\""
    sleep 2
    unless File.exist? file_jpg
      exit
    end

    begin
      url = @g.create file_jpg
    rescue Gisty::InvalidFileException => e
      puts "Error: invalid file"
    rescue Exception => e
      puts "Error: #{e}"
    else
      id = url.split('/').last
      @g.clone id
      system "open https://gist.github.com/raw/#{id}/#{now}.jpg" if /darwin/ === RUBY_PLATFORM
    end
    File.delete file_jpg
  end
end
