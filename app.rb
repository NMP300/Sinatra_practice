# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "securerandom"
require "json"

class Memo
  def find(id: id)
    JSON.parse(File.read("memos/#{id}.json"), symbolize_names: true)
  end

  def create(title: title, body: body)
    contents = { id: RandomSecure.uuid, title: title, body: body }
    File.open("memos/#{id}.json", "w") { |f| f.puts JSON.pretty_generate(contents) }
  end

  def update(title: title, body: body)
    new_contents = { id: params[:id], title: title, body: body }
    File.open("memos/#{new_contents[:id]}.json", "w") { |f| f.puts JSON.pretty_generate(contents) }
  end

  def delete(id: id)
    File.delete("memos/#{id}.json")
  end
end

get "/memos" do
  file_list = Dir.glob("memos/*")
  @memos = file_list.map { |file| JSON.parse(File.read(file), symbolize_names: true) }
  erb :top
end

get "/memos/new" do
  erb :new
end

# 保存
post "/memos/new" do
  Memo.create(title: params[:title], body: params[:body])
end

get "/memos/:id" do
  @memo = Memo.new.find(id: params[:id])
  erb :memo
end

get "/memos/:id/edit" do
  @memo = Memo.new.find(id: params[:id])
  erb :edit
end

# 編集
patch "/memos/:id" do
  memo = Memo.new.find(id: params[:id])
  memo.update(title: params[:title], body: params[:body])
  redirect "/memos"
end

# 削除
delete "/memos/:id" do
  Memo.new.delete(id: params[:id])
  redirect "/memos"
end
