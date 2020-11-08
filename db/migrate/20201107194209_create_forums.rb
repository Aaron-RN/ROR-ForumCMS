# frozen_string_literal: true

class CreateForums < ActiveRecord::Migration[6.0]
  def change
    create_table :forums do |t|
      t.string :name
      t.string :subforums, array: true, default: []
      t.boolean :admin_only, default: false
      t.boolean :admin_only_view, default: false

      t.timestamps
    end
  end
end
