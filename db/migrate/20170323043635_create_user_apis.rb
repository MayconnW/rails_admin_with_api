class CreateUserApis < ActiveRecord::Migration[5.1]
  def change
    create_table :user_apis do |t|
      t.references :user, foreign_key: true
      t.string :token

      t.timestamps
    end
  end
end
