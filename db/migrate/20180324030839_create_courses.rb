class CreateCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
      t.string :title, null: false, comment: 'Course title'
      t.string :subject, comment: 'Course subject'
      t.integer :category, comment: 'Course category'
      t.integer :grade, comment: 'Course grade'
      t.integer :teacher, null: false, comment: 'Course creator'
      t.integer :quantity, null: false, default: 1, comment: 'Course quantity'
      t.integer :price, null: false, default: 0, comment: 'Course price'
      t.integer :status, default: 0, comment: '0: developing, 1: created, 2: unpublish, 3: published, 4: disabled, 5: full'
      t.boolean :deleted, default: false, comment: 'Delete flag'

      t.timestamps
    end

    add_index :courses, :title, unique: true
  end
end
