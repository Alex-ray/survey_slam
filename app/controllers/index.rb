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
  survey = duplicate_survey(params[:form_id])
  @survey = survey[:survey]
  @questions = survey[:questions]
  @choices = survey[:choices]
  erb :form
end

post '/form/:form_id' do
  survey = Survey.find(params[:form_id])
  questions = survey.questions
  questions.each do |q|
    q.answer = params[q.text]
    q.save!
  end
  survey.save!
  erb :result
end


get '/create_form' do
  @user = current_user
  erb :create_form
end

post '/new_form' do
  questions = []
  questions << params[:survey][:question][:answers][0]
  questions << params[:survey][:question][:answers][1]
  questions << params[:survey][:question][:answers][2]

  user = current_user

  survey = Survey.create(title: params[:survey][:title])
  q = Question.create(text: params[:survey][:question][:title])

  questions.each do |s|
    q.choices << Choice.create(name: s)
  end

  survey.questions << q
  user.surveys << survey

  @survey = user.surveys.last()
  @questions = survey.questions
  @choices = q.choices

  erb :form
end







