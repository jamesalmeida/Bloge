class CreateUserTable < ActiveRecord::Migration
  def up
  	create_table :users do |t|
  		t.string :fname
  		t.string :lname
  		t.string :email
  		t.string :username
  		t.string :password_hash
  		t.string :password_salt
  		t.datetime :created_at
  end
end

  def down
  	drop_table :users
  end
end
