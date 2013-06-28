require 'sinatra'
require 'sinatra/reloader'


# OJO el resultado de este programa debe revisarse en el 
#     log de STDOUT en la consola que se inicia. No escribe al browser.

before do
	@histo = []
	@histo << "En before de todos los requests.."
end

before '/hola' do
	@histo << "En before de HOLA.."
end

get '/' do
  @histo << "en Raiz.."
  "" 
end

get '/hola' do 
   @histo << "en hola.."
  "" 
end

after do
	@histo << "En after de todos los requests.."
	p "historico: #{@histo.inspect}"
end
