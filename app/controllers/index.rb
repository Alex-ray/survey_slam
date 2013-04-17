get '/' do
  @user = current_user
  @surveys = unique_surveys
  erb :index
end

get '/login' do
  @user = current_user
  @surveys = unique_surveys
  erb :login
end

get '/signup' do
  @user = current_user
  @surveys = unique_surveys
  erb :signup
end

post '/signup' do
  if user = User.create(params[:user])
    session[:user_id] = user.id
    redirect to '/'
  else
    erb :signup
  end
end

post '/login' do
  if user = User.authenticate(params[:user])
    session[:user_id] = user.id
    redirect to '/'
  else
    erb :login
  end
end

get '/logout' do
  logout
  redirect to '/'
end

get '/form/:form_id' do
  @survey = duplicate_survey(params[:form_id])
  erb :form
end

post '/form/:form_id' do
  answer_questions(params)
  erb :result
end

get '/create_form' do
  @user = current_user
  erb :create_form
end

post '/new_form' do
  @survey = create_survey(params)
  erb :form
end







