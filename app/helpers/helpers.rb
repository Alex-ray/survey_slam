helpers do

	def current_user
		return nil unless session[:user_id].present?
		@current_user ||= User.find(session[:user_id])
	end

  def sign_in(user)
    if user!= nil
      session[:user_id] = user.id
      @errors = nil
      current_user
    else
      session[:user_id] = nil
      @errors = "Username or password not valid"
    end
  end

  def generate_token
    #implement this
  end
end