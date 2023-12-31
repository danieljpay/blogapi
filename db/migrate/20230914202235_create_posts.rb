class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :content
      t.boolean :published
      t.references :user

      t.timestamps
    end
  end
end
