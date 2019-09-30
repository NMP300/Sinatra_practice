# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "securerandom"
require "json"

post "/new" do
  @id = SecureRandom.uuid
  @memo = { id: @id, title: params[:title], body: params[:body] }
  File.open("memos/#{@memo[:id]}.json", "w") { |f| f.puts JSON.pretty_generate(@memo) }
  erb :new
end

# FILE_ID = SecureRandom.uuid

# get "/" do
#   @files = Dir.glob("memos/*")

#   def show_title(file)
#     memo = File.open("#{file}").read
#     @hash = JSON.parse(memo)
#     @title = "<a href=show/#{@hash["id"]}>#{@hash["title"]}</a>"
#   end

#   @title_list = @files.map { |f| show_title(f) }.join("<br>")
#   erb :top
# end

# get "/new" do
#   erb :new
# end

# post "/new" do
#   @memo_id = FILE_ID
#   @memo = { id: @memo_id, title: params[:title], body: params[:body] }
#   File.open("memos/#{@memo[:id]}.json", "w") { |f| f.puts JSON.pretty_generate(@memo) }
#   erb :new
# end



# get "/edit" do
#   erb :edit
# end
