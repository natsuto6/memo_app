# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

FILE_PATH = 'data/memos.json'

def get_memos(file_path)
  File.open(file_path) { |f| JSON.parse(f.read) }
end

def set_memos(file_path, memos)
  File.open(file_path, 'w') { |f| JSON.dump(memos, f) }
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = get_memos(FILE_PATH)
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  memos = get_memos(FILE_PATH)
  id = SecureRandom.uuid
  memos[id] = { 'title' => params[:title], 'content' => params[:content], 'time' => Time.now }
  set_memos(FILE_PATH, memos)

  redirect '/memos'
end

get '/memos/:id' do
  @memos = get_memos(FILE_PATH)
  @title = @memos[params[:id]]['title']
  @content = @memos[params[:id]]['content']
  erb :show
end

delete '/memos/:id' do
  memos = get_memos(FILE_PATH)
  memos.delete(params[:id])
  set_memos(FILE_PATH, memos)

  redirect '/memos'
end

get '/memos/:id/edit' do
  memos = get_memos(FILE_PATH)
  @title = memos[params[:id]]['title']
  @content = memos[params[:id]]['content']
  erb :edit
end

patch '/memos/:id' do
    memos = get_memos(FILE_PATH)
    if memos.key?(params[:id])
      memos[params[:id]] = { 'title' => params[:title], 'content' => params[:content] }
      set_memos(FILE_PATH, memos)
    end

  redirect "/memos/#{params[:id]}"
end
