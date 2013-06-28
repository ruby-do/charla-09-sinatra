require 'sinatra'
require 'sinatra/reloader'

before do
	content_type :txt
end

get %r{/pa.*} do
	pass if request.path == '/pasar'
	"la ruta fue: #{request.path}"
end

get '/pasar' do
	"ya pasamos!"
end

get '/' do
  "llego a la raiz.."
end
  
get '/welcome.html' do
  "esta es la ruta, no la carpeta.. La carpeta est&aacute;tica tiene preferencia sobre la ruta"
end

