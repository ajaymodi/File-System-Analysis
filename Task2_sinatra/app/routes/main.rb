#default root
require 'json'

get "/" do
  erb :index
end

post "/add_files" do
  puts params
  { :fullpath => params["filepath"], :key2 => 'value2' }.to_json
end

get '/example.json' do
  content_type :json
  { :key1 => 'value1', :key2 => 'value2' }.to_json
end