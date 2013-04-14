get '/' do
  @user = current_user
  @surveys = Survey.select("DISTINCT title")
  puts @surveys.inspect
  erb :index
end

get '/logout' do
  session[:user_id] = nil
  @user = current_user
  erb :index
end

get '/form/:form_id' do

  survey = Survey.find(params[:form_id])
  new_survey = survey.dup
  new_survey.save

  q = survey.questions.first
  new_q = q.dup
  new_q.save

  new_survey.questions << new_q
  new_survey.save

  q.choices.each do |c|
    new_q.choices << c.dup
    new_q.save
  end

  @survey = new_survey
  @questions = new_survey.questions
  @choices = new_q.choices

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

get '/signup' do
  @user = current_user
  erb :signup
end

get '/login' do
  @user = current_user
  erb :login
end

get '/create_form' do
  @user = current_user
  erb :create_form
end

post '/signup' do
  user = User.create(params[:user])
  sign_in(user)
  if user == nil
    @errors
    erb :signup
  else
    @user = current_user
    @surveys = Survey.select("DISTINCT title")
    erb :index
  end
end

post '/login' do
  user = User.authenticate(params[:user][:email], params[:user][:password])
  sign_in(user)
  if user == nil
    @errors
    erb :login
  else
    @user = current_user
    @surveys = Survey.select("DISTINCT title")
    erb :index
  end
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






