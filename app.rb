#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new 'leprosorium.db'
	@db.results_as_hash = true
end

before do
	init_db
end

configure do
	init_db
	@db.execute 'CREATE TABLE if not exists Posts 
	(
	id INTEGER PRIMARY KEY AUTOINCREMENT, 
	created_date DATE, 
	content TEXT
	)'
end

get '/' do
	@results = @db.execute 'Select * from Posts order by id desc'
	erb :index
end

get '/new' do
  erb :new
end

post '/new' do
	@content = params[:content]
  		if @content.strip.length <= 0
  			@error = "Введите текст"
  			return erb :new
  		end
  	
  	@db.execute 'insert into Posts (created_date, content) values (datetime(), ?)', [@content]
	erb "Your typed #{@content}"
	
end