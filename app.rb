# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "securerandom"
require "json"

enable :method_override

get "/new" do
  erb :new
end

post "/new" do
  @id = SecureRandom.uuid
  @memo = { id: @id, title: params[:title], body: params[:body] }
  File.open("memos/#{@id}.json", "w") { |f| f.puts JSON.pretty_generate(@memo) }
  erb :erb
end

def memo_detail(memo)
  @memo = JSON.parse(File.read(memo))
end

@file_list = Dir.glob("/memos/*")

get "/memos/:id" do
  memo_detail("memos/#{params[:id]}.json")
  @title = @memo["title"]
  @body  = @memo["body"]
  erb :memos
end

get "/" do
  @file_list = Dir.glob("memos/*")

  @title_list = @file_list.map do |file|
    memo_detail("#{file}")
    "<a href=memos/#{@memo["id"]}>#{@memo["title"]}</a>"
  end
  erb :top
end

delete "/memos/:id" do
  @id = params[:id]
  File.delete("memos/#{@id}.json")
  redirect to "/"
  erb :memos
end
