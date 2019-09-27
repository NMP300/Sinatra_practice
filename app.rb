# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "securerandom"

FILE_ID = SecureRandom.uuid

get "/" do
  @memo_list = Dir.glob("memos/*")
  
  erb :home
end

get "/new" do
  erb :new
end

post "/new" do
  @memo = params[:memo]
  @file = File.open("memos/#{FILE_ID}.txt", "w") { |f| f.puts "#{@memo}" }
  redirect "/"
  erb :new
end

get "/edit" do
  erb :edit
end

get "/memo" do
  "show memo "
end
