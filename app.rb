# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "securerandom"
require "json"

FILE_ID = SecureRandom.uuid

get "/" do

  @files = Dir.glob("memos/*")

  def show_title(file)
    memo = File.open("#{file}").read
    hash = JSON.parse(memo)
    title = "<a href=memo/#{hash["id"]}>#{hash["title"]}</a>"
  end

  @title_list = @files.map { |f| show_title(f) }


  # memo = open("memos/#{@name}").read
  # hash = JSON.parse(memo)
  # @id  = hash["id"]
  # title = "<a href=memo/#{@id}>#{hash["title"]}</a>"
  # @titles << title
  erb :home
end

get "/new" do
  erb :new
end

post "/new" do
  @memo_id = FILE_ID
  @memo = { id: @memo_id, title: params[:title], body: params[:body] }
  File.open("memos/#{@memo[:id]}.json", "w") { |f| f.puts JSON.pretty_generate(@memo) }
  erb :new
end

get "/edit" do
  erb :edit
end

get "/memo" do
  "show memo "
end
