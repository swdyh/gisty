cmd :list, '', 'show local list' do
  list = @g.list
  puts '- public gist -'
  list[:public].each do |i|
    puts "#{i[0]}: #{i[1].join(' ')}"
  end
  puts '- private gist -'
  list[:private].each do |i|
    puts "#{i[0]}: #{i[1].join(' ')}"
  end
end
