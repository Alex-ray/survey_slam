class User < ActiveRecord::Base
  has_many :surveys
  has_many :choices, :through => :questions

  validates :email, :uniqueness => true

  include BCrypt

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def self.authenticate(args)
    @user = User.find_by_email(args[:email])
    if @user
      return @user if (@user.password == args[:password])
    end
  end
end
