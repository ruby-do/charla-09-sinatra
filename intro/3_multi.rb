require 'sinatra'
require 'sinatra/reloader'
get '/:nombre' do
    "Hola #{params[:nombre]}, mucho gusto!"
end

get '/usuario/:nombre/pais/:pais' do 
 "Bienvenido #{params[:nombre]}; algun dia quisiera visitar  #{params[:pais]}!"
end
