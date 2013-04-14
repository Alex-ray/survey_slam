class CreateTables < ActiveRecord::Migration
  def change
    create_table :users do |u|
      u.string :password_hash, :email
      u.timestamps
    end

    create_table :surveys do |s|
      s.string :title
      s.references :user
      s.timestamps
    end

    create_table :questions do |q|
      q.string :text
      q.string :answer
      q.references :survey
      q.timestamps
    end

    create_table :choices do |a|
      a.string :name
      a.references :user, :question
      a.timestamps
    end

    create_table :images do |i|
      i.string :url
      i.references :survey
      i.timestamps
    end
  end
end
