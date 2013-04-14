class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.references :survey
      t.timestamps
    end
  end
end
