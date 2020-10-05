class AddGroupsSourceToLineItems < ActiveRecord::Migration[5.2]
  def change
    #Create groups_source column in line_items
    add_reference :line_items, :groups_source, index: true, after: :source_id

    #for each line item, get groups_source_id for the source attached to the current line item and push that into the groups_source column
    @line_items = LineItem.all
    @line_items.each do |line_item|
      groups_source = GroupsSource.where(source: line_item.source_id).first
      line_item.update(groups_source: groups_source)
    end

    #drop the source column from line items
    remove_column :line_items, :source_id
  end
end
