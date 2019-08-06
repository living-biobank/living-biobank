class SpecimenSourceChange < ActiveRecord::Migration[5.1]
  def change
    add_reference :line_items, :source, index: true, after: :sparc_id
    add_reference :labs, :source, index: true, after: :specimen_date

    LineItem.reset_column_information
    Lab.reset_column_information

    LineItem.all.each do |li|
      if source = Source.find_by(key: li.service_source)
        LineItem.find(id).update_attribute(sourcee: source)
      end
    end

    Lab.all.each do |lab|
      if source = Source.find_by(key: lab.specimen_source)
        Lab.find(id).update_attribute(sourcee: source)
      end
    end

    remove_column :line_items, :service_source
    remove_column :labs, :specimen_source

    LineItem.reset_column_information
    Lab.reset_column_information
  end
end
