helpers do

  def answer_questions(params)
    survey = Survey.find(params[:form_id])

    survey.questions.each do |q|
      q.answer = params[q.text]
      q.save!
    end

    survey.save!
  end

	def current_user
		return nil unless session[:user_id].present?
		@current_user ||= User.find(session[:user_id])
	end

  def unique_surveys
    @surveys ||= Survey.all.uniq{ |s| s.title }
  end

  def logout
    session[:user_id] = nil
    @errors = nil
  end

  def duplicate_survey(survey_id)
    survey = Survey.find(params[:form_id])
    new_survey = survey.dup
    new_survey.save!

    survey.questions.each do |q|
      new_q = q.dup
      new_q.save!
        q.choices.each do |c|
          new_c = c.dup
          c.save!
          new_q.choices << new_c
          new_q.save!
        end
      new_survey.questions << new_q
      new_survey.save!
    end
    new_survey
  end

  def create_survey(params)

    {"survey"=>{"title"=>"dumb survey",
      "questions"=>[{"title"=>"q1", "answers"=>["a1", "a2", "a3"]},
      {"title"=>"q2", "answers"=>["a1", "a2", "a3"]}]}}

    puts params
    survey = Survey.create(title: params[:survey][:title])

    params[:survey][:questions].each do |q|
      question = Question.create(text: q["title"])

        q["answers"].each do |c|
          puts c
          question.choices << Choice.create(name: c)
          question.save!
        end

      survey.questions << question
      survey.save!

    end

    current_user.surveys << survey
    survey
  end

end