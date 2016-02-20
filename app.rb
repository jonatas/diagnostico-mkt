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

