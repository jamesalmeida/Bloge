class CreatePostTable < ActiveRecord::Migration
  def up
  	create_table :posts do |t|
  		t.string :title
  		t.text :body
  		t.datetime :created_at
  		t.integer :user_id
  end
end

  def down
  	drop_table :tweets
  end
end
