class CreateContents < Sequel::Migration
  def up
    create_table :contents do
      String :hash_url, size: 32
      MediumText :content

      DateTime :created_at
    end

    add_index :contents, :hash_url, unique: true
  end

  def down
    drop_table :contents
  end
end
