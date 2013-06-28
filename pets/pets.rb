# Aplicacion super-simple para ilustrar la posible estructura de 
# una app en Sinatra. No se invirtio tiempo en dise~no ni estilos,
# ni bootstrapping it..


require 'sinatra'
require 'sinatra/reloader' if development?
require 'dm-core'
require 'dm-validations'
require 'dm-migrations'
require 'pry'

# Conexión a la DB, en este mismo folder:
DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

# Nuestra clase de modelo:
class Pet
	include DataMapper::Resource
	property :id, Serial
	property :kind, String
	property :name, String
	property :breed, String
end


DataMapper.finalize # sanity-check luego de cargar los modelos
DataMapper.auto_upgrade! # Actuliza DDL de la DB, si es necesario

#------  Rutas & handlers ----------
get '/' do 
	@pets = Pet.all 
	erb :index
end

get '/pet/:id' do 
	@pet = Pet.get(params[:id])
  #binding.pry
	erb :show_pet
end
get '/new' do 
	erb :new
end

post '/create' do 
  pet = Pet.new( params )
  pet.id = nil if pet.id.empty?
  if pet.save
     redirect "/pet/#{pet.id}"
  else
     "<pre> No se pudo salvar el registro: #{Rack::Utils.escape_html(pet.inspect)} </pre>"
  end
end

# Marca el fin de programa. Después sólo debe haber templates:
__END__
@@layout
<html>
  <head>
    <meta charset="UTF-8">
    <title>Mascotas</title>
</head>
<body>
<%= yield %>
</body>
</html>

@@index
<h1>Mascotas</h1>
   <table style="border:1px solid black;border-collapse:collapse;">
<% 	
   	if @pets.blank? %>
   		<tr>
      		<td><p>No hay mascotas creadas. </p></td>
   		</tr>
<% 	else 
   		@pets.each_with_index do |pet, index| 
        if index == 0 %>
   	  		<tr style="border:1px solid black;border-collapse:collapse;"> 
   	      	<th>id</th>
   	  			<th>Tipo</th>
   	  			<th>Nombre</th>
   				  <th>Raza</th>
	  		  </tr>
        <% end %>
   	  		<tr> 
   	      	<td><%= pet.id %></td>
   	  			<td><%= pet.kind %></td>
   	  			<td><a href="/pet/<%= pet.id %>"><%= pet.name %></a></td>
   				  <td><%= pet.breed %></td>
	  		  </tr>
<%  	end 
	end %>      
	</table>
	<a href="/new">Agregue una nueva</a>

@@new
<h1>Nueva Mascota:</h1>
<form method="POST" action="/create">
	<%= erb :pet_form %>

@@show_pet
<h1>Mascota: <%= @pet.name %> </h1>
<h2>Tipo: <%= @pet.kind %></h2>
<h2>Raza: <%= @pet.breed %></h2>
<a href="/"> Volver </a>

@@pet_form
                                     <input type='hidden' name='id'></input>
<label for="kind">Tipo</label>       <input type='text' name='kind'></input><br/>
<label for="breed">Nombre</label>    <input type='text' name='name'></input><br/>
<label for="name">Raza</label>       <input type='text' name='breed'></input><br/>
<div><input type="submit" value="Grabar"> <a href="/"> Cancelar </a> </div> 