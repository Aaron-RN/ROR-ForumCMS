class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.string :email
      t.integer :admin_level
      t.timestamptz :can_post_date
      t.timestamptz :can_comment_date

      t.timestamps
    end
  end
end
