require 'rmvc'
  m = RMVC::Migration.new("test")
  #m.create_table("users")
  #m.add_column("users", "name", :text)
  #m.add_column("users", "age", :num)
  m.insert("users", [:name, :age], ["maria", 14])
