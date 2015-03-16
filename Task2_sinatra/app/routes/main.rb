#default root
require 'json'
require 'debugger'

get "/" do
  erb :index
end

post "/add_files" do
  puts params
  
  if(File.exist?(params["filepath"]))
  	a = { :fullpath => params["filepath"], :filename => File.basename(params["filepath"]), :size => File.size?(params["filepath"])   }.to_json
  else
  	{ :error => "file does not exist"}.to_json
  end
end
