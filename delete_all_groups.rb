require 'HTTParty'

if ARGV.length != 1
  puts 'ERROR: YOU MUST PASS IN THE PUPPET MASTER VCLOUD MACHINE NAME AS THE ONLY ARG'
  exit
end

BASE_URI = ARGV[0]

OPTIONS = {:verify => false}
response = HTTParty.get("https://#{BASE_URI}:4431/node_groups/classifier-api/v1/groups", OPTIONS)
response.each do |group|
  group_id = group['id']
  group_name = group['name']

  next if group_name == 'default'

  puts "deleting ID #{group_id} with name #{group_name}"
  HTTParty.delete("https://#{BASE_URI}:4431/node_groups/classifier-api/v1/groups/#{group_id}", OPTIONS)
end

