class CreateTrackMaintainerships < ActiveRecord::Migration[6.1]
  def change
    create_table :track_maintainerships do |t|
      t.belongs_to :user, foreign_key: true, null: false      
      t.boolean :visible, null: false, default: true
      t.column :maintainer_type, :tinyint, null: false
      t.column :maintainer_level, :tinyint, null: false
      t.column :component_type, :tinyint, null: false
      t.column :component_id, :bigint, null: true

      t.timestamps

      t.index %i[user_id component_type], unique: true, name: 'uniq'
    end

    # TODO: import initial maintainers
  end
end
