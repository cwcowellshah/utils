# Delete all node groups from a Puppet test instance, using the API. This cannot be undone!

require 'HTTParty'

if ARGV.length != 1
  puts 'ERROR: YOU MUST PASS IN THE PUPPET MASTER VCLOUD MACHINE NAME AS THE ONLY ARG'
  exit 1
end

BASE_URI = ARGV[0]

OPTIONS = {:verify => false}

begin
  response = HTTParty.get("https://#{BASE_URI}:4431/node_groups/classifier-api/v1/groups", OPTIONS)
rescue SocketError => se
  puts "ERROR when contacting instance '#{BASE_URI}' via API. Maybe that's a bad hostname?"
  puts
  exit 1
end

delete_count = 0
response.each do |group|
  group_id = group['id']
  group_name = group['name']

  next if group_name == 'default'

  puts "deleting ID #{group_id} with name #{group_name}"
  HTTParty.delete("https://#{BASE_URI}:4431/node_groups/classifier-api/v1/groups/#{group_id}", OPTIONS)
  delete_count += 1
end
puts "Deleted #{delete-count} groups."
