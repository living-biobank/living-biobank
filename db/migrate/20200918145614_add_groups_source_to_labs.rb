class AddGroupsSourceToLabs < ActiveRecord::Migration[5.2]
  def change
    #Create groups_source column in labs
    unless column_exists? :labs, :groups_source_id
      add_reference :labs, :groups_source, index: true, after: :source_id
    end

    #for each lab with a status of 'released' or 'retrieved', get groups_source_id for the source attached to the current lab and push that into the groups_source column
    @labs = Lab.where(status: "released").or(Lab.where(status: "retrieved"))
    @labs.each do |lab|
      groups_source = GroupsSource.where(source: lab.source_id).first
      lab.update_attribute(:groups_source_id, groups_source.id)
    end
  end
end
