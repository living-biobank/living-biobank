class CreateJoinTableGroupsSources < ActiveRecord::Migration[5.2]
  def change
    # Create table
    create_join_table :groups, :sources do |t|
      t.index [:source_id, :group_id]
    end
  
    # Transfer data to new table
    @sources = Source.all
    @sources.each do |source|
      source.groups << Group.find(source.group_id)
    end

    # Remove group column from sources
    remove_column :sources, :group_id
  end
end
