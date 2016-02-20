require "sinatra"
require "sinatra/reloader" if development?

get "/" do
  erb :index
end

post "/ver_resultado" do
  @params = params
  erb :resultado
end

get "/app.js" do
  coffee :app
end

get "/css/:file" do
  send_file "css/#{params[:file]}" 
end

get "/js/:file" do
  send_file "js/#{params[:file]}" 
end

get "/img/:file" do
  send_file "img/#{params[:file]}" 
end
