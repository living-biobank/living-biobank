=begin
  *** MINI DOCUMENTATION ***
  To apply this module to a Rails model, copy this file into "dirty_associations.rb" in the model folder then simply include "DirtyAssociations" at the top of the relevant model file, then for any association you wish to view changes on, add the following code as part of the association declaration:

  after_add: :dirty_create,
  after_remove: :dirty_delete

  As an example, in the case of a User that has many Groups, this will make the instance method "@user.group_records_changed" available to view any additions or removals after saving.  Additionally, @user.saved_changes will return the standard hash as well as information on all added or removed associations for that instance of User.
=end

module DirtyAssociations
  attr_accessor :dirty
  attr_accessor :records_added
  attr_accessor :records_removed
  attr_accessor :changes_hash

  def dirty_create(record)
    self.dirty = true
    self.records_added ||= []
    self.records_added << record.id

    update_changes_hash(record, {added: self.records_added})
  end

  def dirty_delete(record)
    self.dirty = true
    self.records_removed ||= []
    self.records_removed << record.id

    update_changes_hash(record, {removed: self.records_removed})
  end

  def changed?
    dirty || super
  end

  def update_changes_hash(record, current_hash)
    @changes_hash ||= {"#{record.class.name.downcase}".to_sym => {}}
    @changes_hash["#{record.class.name.downcase}".to_sym].merge!(current_hash)

    self.define_singleton_method("#{record.class.name.downcase}_records_changed".to_sym) do 
      puts @changes_hash
      return @changes_hash
    end
  end
  
  def saved_changes
    @temp_hash = Hash.new
    associations = self.class.reflect_on_all_associations.map(&:name).map(&:to_s).map(&:singularize)

    associations.each do |assoc|
      if self.methods.include?("#{assoc}_records_changed".to_sym)
        @temp_hash.merge!(eval("self.#{assoc}_records_changed"))
      end
    end
    
    @temp_hash.merge!(super).symbolize_keys
  end
end