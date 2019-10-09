# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "securerandom"
require "json"

class Memo
  def initialize
    @contents = {}
  end

  def create(hash)
    File.open("memos/#{hash[:id]}.json", "w") { |f| f.puts JSON.pretty_generate(hash) }
  end

  def delete(file)
    File.delete(file)
  end

  def contents(file)
    @contents = JSON.parse(File.read(file), symbolize_names: true)
  end

  def title_list
    file_list = Dir.glob("memos/*")
    file_list.map do |file|
      contents("#{file}")
      "<a href=memos/#{@contents[:id]}>#{@contents[:title]}</a>"
    end
  end
end

get "/memos" do
  @title_list = Memo.new.title_list.join("<br>")
  erb :top
end

get "/memos/new" do
  erb :new
end

post "/memos/new" do
  id       = SecureRandom.uuid
  contents = { id: id, title: params[:title], body: params[:body] }
  Memo.new.create(contents)
  erb :new
  redirect "/memos"
end

get "/memos/:id" do
  @memo_contents = Memo.new.contents("memos/#{params[:id]}.json")
  erb :memo
end

get "/memos/:id/edit" do
  @memo_contents = Memo.new.contents("memos/#{params[:id]}.json")
  erb :edit
end

patch "/memos/:id" do
  @memo_contents = Memo.new.contents("memos/#{params[:id]}.json")
  new_contents = { id: params[:id], title: params[:title], body: params[:body] }
  Memo.new.create(new_contents)
  erb :edit
  redirect "/memos"
end

delete "/memos/:id" do
  Memo.new.delete("memos/#{params[:id]}.json")
  redirect "/memos"
end

get "/practice" do
  erb :practice
end
