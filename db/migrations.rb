migration "create Content table" do
  database.create_table :content do
    primary_key :id
    text :content
  end
end
