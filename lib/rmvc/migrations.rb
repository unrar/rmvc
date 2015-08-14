#!/usr/bin/env ruby
require 'colorize'
require 'sqlite3'
module RMVC
# Migration: an object to assist database creation
  class Migration
    # Init (create or open database)
    attr_accessor :dbr
    def initialize(database)
      if File.exists?("./db/" + database + ".db")
        puts "database #{database} already exists. opening...".green
        @dbr = SQLite3::Database.open("./db/" + database + ".db")
      else
        puts "database #{database} not found. creating database...".yellow
        begin
          @dbr = SQLite3::Database.new("./db/" + database + ".db")
          puts "database #{database} successfully created.".green
        rescue
          puts "couldn't create database. aborting...".red
          exit
        end
      end
    end

    # create table
    def create_table(table)
      puts "attempting to create table #{table}..."
      begin
        tt = @dbr.prepare("CREATE TABLE #{table}(id int auto_increment);")
        ee = tt.execute
        puts "table created correctly.".green
      rescue
        puts "error while creating table #{table}".red
        exit
      end
    end

    # drop a table
    def drop_table(table)
      puts "attempting to drop table #{table}..."
      begin
        tt = @dbr.prepare("DROP TABLE #{table};")
        ee = tt.execute
        puts "table created correctly.".green
      rescue
        puts "error while dropping table #{table}".red
      end
    end
    
    # add column
    def add_column(table, cname, type)
      if type.to_s == "text"
        puts "attempting to create text column #{cname} at #{table}..."
        begin
          tt = @dbr.prepare("ALTER TABLE #{table} ADD #{cname} text;")
          ee = tt.execute
          puts "column correctly added!".green
        rescue
          puts "error while adding column #{cname} to #{table}".red
          exit
        end
      elsif type.to_s == "num"
        puts "attempting to create numerical column #{cname} at #{table}..."
        begin
          tt = @dbr.prepare("ALTER TABLE #{table} ADD #{cname} int;")
          ee = tt.execute
          puts "column correctly added!".green
        rescue
          puts "error while adding column #{cname} to #{table}".red
          exit
        end
      else
        puts "attempting to create custom (#{type.to_s}) column #{cname} at #{table}..."
        begin
          tt = @dbr.prepare("ALTER TABLE #{table} ADD #{cname} #{type.to_s};")
          ee = tt.execute
          puts "column correctly added!".green
        rescue
          puts "error while adding column #{cname} to #{table}".red
          exit
        end     
      end
    end 

    # Insert values into table WHERE columns = ["column1", "column2"]
    # AND values = ["value1", "value2"]
    def insert(table, columns, values)
      puts "attempting to insert values into #{table}..."
        begin
          nvalues = []
          values.each do |v|
            if v.is_a? String
              nvalues << "\"" + v + "\"" 
            else
              nvalues << v
            end
          end
          tt = @dbr.prepare("INSERT INTO #{table}(" + columns.join(", ") + ") VALUES(" + nvalues.join(", ") + ");")
          ee = tt.execute
          puts "values correctly added!".green
        rescue
          puts "error while inserting values".red
        end
    end
  end
end