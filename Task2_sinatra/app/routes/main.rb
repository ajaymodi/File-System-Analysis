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
	
	File.open("data/MD5-"+filename(params["filepath"])+".txt", "w") do |value|
		value.write(hashcomp2.hashsum)
	end

	File.open("data/SHA1-"+filename(params["filepath"])+".txt", "w") do |value|
		value.write(hashcomp1.hashsum)
	end

	mbr = getMBR(params["filepath"])
	partition_1 = getPartition1(params["filepath"])
	partition_2 = getPartition2(params["filepath"])
	partition_3 = getPartition3(params["filepath"])
	partition_4 = getPartition4(params["filepath"])

	{ :filename => filename(params["filepath"]),:SHA1 => hashcomp1.hashsum, :MD5 => hashcomp2.hashsum,  }.to_json
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

# def printresult(filename, method, sum)
# 	puts "\n" + filename + " ==> "+ method + ": " + sum	
# end

def getMBR filename
	`hexdump -e '16/1 "%02x " "\n"' -n 512 #{filename}`
end

def getPartition1(filename)
	`hexdump -e '16/1 "%02x " "\n"' -n 16 -446 #{filename}`
end

def getPartition2(filename)
	`hexdump -e '16/1 "%02x " "\n"' -n 16 -462 #{filename}`
end

def getPartition3(filename)
	`hexdump -e '16/1 "%02x " "\n"' -n 16 -478 #{filename}`
end

def getPartition4(filename)
	`hexdump -e '16/1 "%02x " "\n"' -n 16 -494 #{filename}`
end