require 'sinatra'
require 'sinatra/reloader'

before do
	content_type :txt
end

def show_info
	"request_method: #{request.request_method}\n"+
	"path_info: #{request.path_info}\n"+
	"query_string: #{request.query_string }"
end

get '/' do
	show_info
end