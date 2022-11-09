require 'progress-bar'
require_relative 'connect'
require_relative 'task'

project = 26

puts "\n\nCONNECTOR\n==================================\n"
puts "Connecting..."
auth = Connect.new('ws/int/api/pub/auth/login/v2')
puts auth.authentication
puts "Connected!..."

puts "\n\nTASKS\n=================================="
tasks = []
task = Task.new(project)
task_all = task.all
pg_task = ProgressBar.new task_all.size, 'Starting process...'
pg_task.start
task_all.each do |data|
  data.delete('description')
  tags = task.tags(data['index'])
  data['tags'] = tags
  tasks.push JSON.generate(data, { indent: '', object_nl: '', array_nl: '' })
  pg_task.i += 1
  pg_task.text = "Processing..."
end
pg_task.text = "Finished process!"
pg_task.finish

puts "\n\nSAVE TO DISK\n==================================\n"
puts "Starting save..."
file = "#{project}_demands_#{Time.now.strftime("%Y%m")}.json"
puts "Saving..."
path = File.join(File.dirname(__FILE__), file)
File.open(path, 'w+') do |f|
  f.write tasks
end
puts "Finished save!"






