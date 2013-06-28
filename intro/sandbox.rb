require 'sinatra'
require 'sinatra/reloader'

get '/index' do
    erb :index
end
