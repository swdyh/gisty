cmd :private_post, 'file1 file2 ...', 'post new private gist' do |fs|
  if fs.size > 0
    begin
      url = @g.create fs, :private => true
    rescue Exception => e
      puts "Error: #{e}"
    else
      system "open #{url}" if /darwin/ === RUBY_PLATFORM
      id = url.split('/').last
      @g.clone id
    end
  end
end
