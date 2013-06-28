# Aplicacion super-simple para ilustrar la posible estructura de 
# una app en Sinatra. No se invirtio tiempo en dise~no ni estilos,
# ni bootstrapping it..

 require 'sinatra'
 require 'sinatra/reloader'
 require 'google_drive'

# OJO: debe invocarse desde una consola donde se defina la variables de
#      entorno 'guser' y 'gpwd' con usuario y clave de gmail de la cuenta en uso.
#      Ademas debe ajustar el spreadsheet_key al de su propio archivo

before do
   next unless request.post?  # saltemos esto a menos que sea un POST
   @session = GoogleDrive.login(ENV['guser'], ENV['gpwd'] )
   @ws = @session.spreadsheet_by_key("0AmpQJpOkGteLdGQ3WFFvUy05VElIdHFFM0J0WGU0OWc").worksheets[0]
   @list = @ws.list
   if @list
   	  puts 'Conecto bien el Spreadsheet!'
   else
   	  puts 'Ooops.. parece que no conecto'
   end
end

get '/survey' do
	erb :form
end

post '/survey' do
	contenido = params[:contenido]
	picadera  = params[:picadera]
	local     = params[:local]
	email     = params[:email]

	if ( contenido && picadera && local && email )
        if (@list.push(contenido: contenido, picadera: picadera, 
        	      local: local, email: email) )
        	if @ws.save
            	redirect '/gracias'
            else 
            	halt 'error al grabar'
            end
        else
        	halt 'error al insertar datos'
        end
	else
        halt 'parametros incompletos'
	end
end

get '/gracias' do
   "Gracias por su input!"
end

__END__
@@form
<html>
<head><title>Encuesta</title></head>
<body>
	<h2> Por favor ayudenos a mejorar:</h2>
	<form action="/survey" method="POST">
       <label for="contenido">Contenido (1-5)</label>       <input type='text' name='contenido'></input><br/>
       <label for="picadera">Picadera (1-5)</label>    <input type='text' name='picadera'></input><br/>
       <label for="local">Local (1-5)</label>       <input type='text' name='local'></input><br/>
       <label for="email">Por favor indique su eMail:</label>       <input type='text' name='email'></input><br/>
       <div><input type="submit" value="Grabar"></div>
	</form>
</body>
</html>