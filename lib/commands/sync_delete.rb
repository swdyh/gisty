cmd :sync_delete, '', 'sync remote gist. delete local gist if remote gist was deleted'  do
  @g.sync true
  puts '---'
  puts 'sync finished.'
end
