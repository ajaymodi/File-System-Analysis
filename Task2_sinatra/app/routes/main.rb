#default root
require 'json'
require 'debugger'

get "/" do
  erb :index
end

post "/add_files" do
  puts params
  
  if(File.exist?(params["filepath"]))
  	{ :fullpath => params["filepath"], :filename => filename(params["filepath"]), :size => filesize(params["filepath"]) }.to_json
  else
  	{ :error => "file does not exist"}.to_json
  end
end

post "/calculate_files" do
  puts params
  
  if(File.exist?(params["filepath"]))
	hashcomp1 = Hasher.new("-SHA1", params["filepath"])
	hashcomp2 = Hasher.new("-MD5", params["filepath"])
	md5 = ""
	sha1 = ""
	File.open("data/MD5-"+filename(params["filepath"])+".txt", "w") do |value|
		md5 = hashcomp2.hashsum
		value.write(md5)
	end

	File.open("data/SHA1-"+filename(params["filepath"])+".txt", "w") do |value|
		sha1 = hashcomp1.hashsum
		value.write(sha1)
	end

	mbr = getMBR(params["filepath"])
	partition = get_partition_details(params["filepath"])
	
	{ :filename => filename(params["filepath"]),:SHA1 => sha1, :MD5 => md5, :partition => partition }.to_json
  else
  	{ :error => "file does not exist"}.to_json
  end
end

def filesize(name)
	File.size?(name)
end

def filename(name)
	File.basename(name)
end

def getMBR filename
	`hexdump -e '16/1 "%02x " "\n"' -n 512 #{filename}`
end

def getPartition1(filename)
	`hexdump -e '16/1 "%02x " "\n"' -n 16 -s 446 #{filename}`
end

def getPartition2(filename)
	`hexdump -e '16/1 "%02x " "\n"' -n 16 -s 462 #{filename}`
end 

def getPartition3(filename)
	`hexdump -e '16/1 "%02x " "\n"' -n 16 -s 478 #{filename}`
end

def getPartition4(filename)
	`hexdump -e '16/1 "%02x " "\n"' -n 16 -s 494 #{filename}`
end

def get_partition_details(filepath)
	partition_1 = getPartition1(filepath)
	partition_2 = getPartition2(filepath)
	partition_3 = getPartition3(filepath)
	partition_4 = getPartition4(filepath)
	h = {"partition1" => {},"partition2" => {},"partition3" => {},"partition4" => {}}
	p = Partition.new

	h["partition1"]["type"] = p.get_partition_type(partition_1)
	h["partition2"]["type"] = p.get_partition_type(partition_2)
	h["partition3"]["type"] = p.get_partition_type(partition_3)
	h["partition4"]["type"] = p.get_partition_type(partition_4)

	h["partition1"]["starting_address"] = p.get_partition_address(partition_1)
	h["partition2"]["starting_address"] = p.get_partition_address(partition_2)
	h["partition3"]["starting_address"] = p.get_partition_address(partition_3)
	h["partition4"]["starting_address"] = p.get_partition_address(partition_4)

	h["partition1"]["size"] = p.get_partition_size(partition_1)
	h["partition2"]["size"] = p.get_partition_size(partition_2)
	h["partition3"]["size"] = p.get_partition_size(partition_3)
	h["partition4"]["size"] = p.get_partition_size(partition_4)

	return h
end