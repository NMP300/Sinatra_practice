# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"

get "/" do
  erb :home
end

post "/new" do
  erb :new
end

get "/edit" do
  erb :edit
end

get "/memos/" do
  "show memos "
end
