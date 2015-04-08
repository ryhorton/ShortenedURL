class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.integer :visitor_id, index: true
      t.integer :short_url_id, index: true
      t.timestamp
    end
  end
end
