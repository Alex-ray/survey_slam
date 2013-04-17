helpers do

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
    new_survey.save
    choices = []

    survey.questions.each do |q|
      new_q = q.dup
      new_q.save
        q.choices.each do |c|
          choices << c
          new_c = c.dup
          c.save
          new_q.choices << new_c
          new_q.save
        end
      new_survey.questions << new_q
      new_survey.save
    end
    {survey: new_survey, questions: new_survey.questions, choices: choices}
  end

end