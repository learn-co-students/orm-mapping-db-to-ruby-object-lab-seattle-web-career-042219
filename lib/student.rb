require 'pry'

class Student
  attr_accessor :id, :name, :grade

  @@all = []

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2].to_i
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT *
      FROM students
    SQL
    DB[:conn].execute(sql).map do |entry|
      self.new_from_db(entry)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    self.all.find do |student|
      student if student.name == name
    end
  end

  def self.all_students_in_grade_9
    self.all.select do |student|
      student.grade == 9
    end
  end

  def self.students_below_12th_grade
    self.all.select do |student|
      student.grade < 12
    end
  end

  def self.first_X_students_in_grade_10(num)
    array = []
    self.all.each do |student|
      if num > 0
        if student.grade == 10
          array << student
          num -= 1
        end
      end
    end
    array
  end

  def self.all_students_in_grade_X(grade)
    self.all.select do |student|
      student.grade == grade
    end

  end

  def self.first_student_in_grade_10
    self.all.find do |student|
      student.grade == 10
    end
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
