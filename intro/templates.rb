require 'sinatra'
require 'sinatra/reloader'

get '/' do
  "llego a la raiz.."
end
  
__END__
@@layout
<html>
  <head>
    <meta charset="UTF-8">
    <title>Ejemplo de Te</title>
</head>
<body>
<%= yield %>
</body>
</html>
