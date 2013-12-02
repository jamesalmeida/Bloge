require 'bundler/setup'

require 'sinatra'
require 'haml'
require 'sinatra/activerecord'
require 'rake'
require 'chronic'
require 'bcrypt'
require 'rack-flash'

configure(:development) { set :database, 'sqlite3:///bloge_db.sqlite3' }

require './models'

enable :sessions
use Rack::Flash, :sweep => true
set :sessions => true

helpers do
	def current_user
		if session[:user_id]
			User.find(session[:user_id])
		else
			nil
		end
	end
end

get '/' do
	@posts = Post.all.reverse
	haml :index
end

get '/login' do
	haml :login
end

post '/login' do
	@user = User.authenticate(params['user']['username'], params['user']['password'])
	if @user
		session[:user_id] = @user.id
		flash[:notice] = "Such autentication.  So user."
		redirect "/users/#{current_user.id}"
	else
		flash[:alert] = "Such error.  Many login problem."
		redirect '/register'
	end
end

get '/register' do
	haml :register
end

post '/register' do
	@user = User.new(params['user'])
	if @user.save
		session[:user_id] = @user.id
		flash[:notice] = "Such successful.  Many user.  So new."
		redirect '/'
	else
		flash[:alert] = "Such error.  Many register problem."
		redirect '/register'
	end
end

get '/users/:id' do
	@user = User.find(params[:id])
	haml :profile
end

get '/posts/:id' do
	@post = Post.find(params[:id])
	haml :post
end

get '/new_post' do
	haml :new_post
end

post '/new_post' do
	if current_user
		@post = Post.new(title: params['title'], body: params['body'], created_at: Time.now, user_id: current_user.id)
		if @post.save
			flash[:notice] = "Such blog.  So posted."
		else
			flash[:alert] = "Such error.  Many posting problem."
		end
			redirect "/users/#{current_user.id}"
	end
end

get '/logout' do
	session[:user_id] = nil
	flash[:notice] = "Such logout.  Many session.  So ended."
	redirect '/'
end 	
