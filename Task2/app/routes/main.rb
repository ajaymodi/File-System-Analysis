require 'json'

# Default display 
get "/" do
  erb :index
end

# Route handling for adding files
post "/add_files" do
  puts params
  
  if(File.exist?(params["filepath"]))
  	{ :fullpath => params["filepath"], :filename => filename(params["filepath"]), :size => filesize(params["filepath"]) }.to_json
  else
  	{ :error => "file does not exist"}.to_json
  end
end

# Route for calculating hash functions and storing them into data folder
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
	partition.each do |k,v|
		if(partition[k]["type"][1..2]=="06" || partition[k]["type"][1..2]=="0B")
			partition = calculate_details_for_partition(params["filepath"],partition,k,partition[k]["type"][1..2])
		end
	end
	{ :filename => filename(params["filepath"]),:SHA1 => sha1, :MD5 => md5, :partition => partition}.to_json
  else
  	{ :error => "file does not exist"}.to_json
  end
end

# Calculate the file size of the given file
def filesize(name)
	s = File.size?(name)
	new_s = s
	while(s>1000)
		s = s/1000
		new_s = new_s * 1024 / 1000
	end
	return new_s
end

# Gives the filename out of given fullpath
def filename(name)
	File.basename(name)
end

# Gets the MBR portion of the given Image
def getMBR filename
	`hexdump -e '16/1 "%02x " "\n"' -n 512 #{filename}`
end

# Gets hexdump based on the argument given
def getbytes(filename, offset, no_of_bytes)
	`hexdump -e '#{no_of_bytes}/1 "%02x " "\n"' -n #{no_of_bytes} -s #{offset} #{filename}`
end

# Gets partition details based on the argument given.
def get_partition_details(filepath)
	partition_1 = getbytes(filepath, 446, 16)
	partition_2 = getbytes(filepath, 462, 16)
	partition_3 = getbytes(filepath, 478, 16)
	partition_4 = getbytes(filepath, 494, 16)
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

	h["partition1"]["details"] = {}
	h["partition2"]["details"] = {}
	h["partition3"]["details"] = {}
	h["partition4"]["details"] = {}

	return h
end

# calculates the details of the partition.
def calculate_details_for_partition(filepath,hash,partition_number,partition_type)
	vbr = getbytes(filepath,hash[partition_number]["starting_address"]*512, 512)
	p = Partition.new
	hash[partition_number]["details"]["reserved_area"] = p.get_reserved_area(vbr)
	hash[partition_number]["details"]["sectors_per_cluster"] = p.get_sectors_per_cluster(vbr)
	hash[partition_number]["details"]["no_of_fat"] = p.get_number_of_fat(vbr)
	hash[partition_number]["details"]["size_of_fat"] = p.get_size_of_fat(vbr,partition_type)
	hash[partition_number]["details"]["root_directory"] = p.get_root_directory(vbr)
	return hash
end