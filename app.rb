# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "securerandom"
require "json"

:method_override

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
    @contents = JSON.parse(File.read(file))
  end

  def id(file)
    contents(file)
    @contents["id"]
  end

  def title(file)
    contents(file)
    @contents["title"]
  end

  def body(file)
    contents(file)
    @contents["body"]
  end

  def title_list
    file_list = Dir.glob("memos/*")
    file_list.map do |file|
      contents("#{file}")
      "<a href=memos/#{@contents["id"]}>#{@contents["title"]}</a>"
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

# 改善点：DRY原則に反している
get "/memos/:id" do
  @memo_id    = Memo.new.id("memos/#{params[:id]}.json")
  @memo_title = Memo.new.title("memos/#{params[:id]}.json")
  @memo_body  = Memo.new.body("memos/#{params[:id]}.json")
  erb :memo
end

# 改善点：DRY原則に反している
get "/memos/:id/edit" do
  @memo_id    = Memo.new.id("memos/#{params[:id]}.json")
  @memo_title = Memo.new.title("memos/#{params[:id]}.json")
  @memo_body  = Memo.new.body("memos/#{params[:id]}.json")
  erb :edit
end

patch "/memos/:id" do
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
