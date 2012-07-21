class CreateContents < Sequel::Migration
  def up
    create_table :contents do
      integer :id
      text :content
    end
  end

  def down
    drop_table :contents
  end
end
