ActiveRecord::Schema.define :version => 0 do
  create_table "things", :force => true do |t|
    t.string   "name"
  end
end
