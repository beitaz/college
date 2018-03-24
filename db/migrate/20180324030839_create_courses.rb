class CreateCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
      t.string :title
      t.string :subject
      t.integer :category
      t.integer :grade
      t.integer :teacher
      t.integer :status
      t.boolean :deleted

      t.timestamps
    end
  end
end
