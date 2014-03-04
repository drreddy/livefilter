class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.text :title
      t.text :director
      t.text :rating
      t.text :runtime
      t.text :year
      t.text :genre
      t.text :link

      t.timestamps
    end
  end
end
