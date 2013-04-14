class Survey < ActiveRecord::Base
  has_many :questions
  has_many :tokens
  belongs_to :user
end
