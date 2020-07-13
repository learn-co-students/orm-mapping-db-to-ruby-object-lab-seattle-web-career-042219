require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new = Student.new
      new.id=row[0]
      new.name=row[1]
      new.grade=row[2]
      new
  end

  def self.all
    sql = <<-SQL
    SELECT * FROM students
    SQL
    all = DB[:conn].execute(sql)
    all.map do |student|
      new_from_db(student)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students
    WHERE students.name = (?)
    SQL
    new = DB[:conn].execute(sql, name).flatten
    self.new_from_db(new)
    # find the student in the database given a name
    # return a new instance of the Student class
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

  def self.all_students_in_grade_9
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade=9
    SQL
    DB[:conn].execute(sql)
  end

def self.first_student_in_grade_10
  sql = <<-SQL
  SELECT * FROM students
  WHERE grade=10 LIMIT 1
  SQL

  new_from_db(DB[:conn].execute(sql).flatten)

end

def self.students_below_12th_grade
  sql = <<-SQL
  SELECT * FROM students
  WHERE grade<12
  SQL
  ar = DB[:conn].execute(sql)
  ar.map do |student|
    new_from_db(student)
  end
end

def self.all_students_in_grade_X(x)
sql = <<-SQL
SELECT * FROM students
WHERE grade=(?)
SQL
DB[:conn].execute(sql, x)
end

def self.first_X_students_in_grade_10(x)
  sql = <<-SQL
  SELECT * FROM students
  WHERE grade=10 LIMIT (?)
  SQL
  DB[:conn].execute(sql, x)
end
end
