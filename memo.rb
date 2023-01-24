# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

def conn
  @conn ||= PG.connect(dbname: 'postgres')
end

configure do
  result = conn.exec("SELECT * FROM information_schema.tables WHERE table_name = 'memos'")
  conn.exec('CREATE TABLE memos (id serial, title varchar(255), content text)') if result.values.empty?
end

def load_memos
  conn.exec('SELECT * FROM memos')
end

def memo_creation(title, content)
  conn.exec_params('INSERT INTO memos(title, content) VALUES ($1, $2);', [title, content])
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = load_memos
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  title = params[:title]
  content = params[:content]
  memo_creation(title, content)
  
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
