cmd :post, 'file1 file2 ...', 'post new gist' do |fs|
  if fs.size > 0
    begin
      url = @g.create fs
    rescue Gisty::InvalidFileException => e
      puts "Error: invalid file"
    rescue Exception => e
      puts "Error: #{e}"
    else
      id = url.split('/').last
      @g.clone id
      system "open #{url}" if /darwin/ === RUBY_PLATFORM
    end
  end
end
