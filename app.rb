# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "securerandom"
require "json"

enable :method_override

get "/memos/new" do
  erb :new
end

post "/memos/new" do
  @id = SecureRandom.uuid
  @memo = { id: @id, title: params[:title], body: params[:body] }
  File.open("memos/#{@id}.json", "w") { |f| f.puts JSON.pretty_generate(@memo) }
  erb :new
  redirect "/memos"
end

def memo_detail(memo)
  @memo = JSON.parse(File.read(memo))
end

@file_list = Dir.glob("/memos/*")

get "/memos/:id" do
  memo_detail("memos/#{params[:id]}.json")
  @id    = @memo["id"]
  @title = @memo["title"]
  @body  = @memo["body"]
  erb :memos
end

get "/memos" do
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
  redirect "/memos"
end

get "/memos/:id/edit" do
  memo_detail("memos/#{params[:id]}.json")
  @id    = @memo["id"]
  @title = @memo["title"]
  @body  = @memo["body"]
  erb :edit
end

patch "/memos/:id" do
  @memo = { id: params[:id], title: params[:title], body: params[:body] }
  File.open("memos/#{params[:id]}.json", "w") { |f| f.puts JSON.pretty_generate(@memo) }
  erb :edit
  redirect "/memos/#{params[:id]}"
end
