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
  exit 1
end

delete_count = 0
response.each do |group|
  next if group['name'] == 'default'
  puts "deleting ID #{group['id']} with name #{group['name']}"
  HTTParty.delete("https://#{BASE_URI}:4431/node_groups/classifier-api/v1/groups/#{group['id']}", OPTIONS)
  delete_count += 1
end
puts "deleted #{delete-count} groups"
