desc "Automatically discard specimens (labs) that are considered \"expired\" based on groups_source discard_ages"
task automatic_specimen_discard: :environment do
  Lab.available.each do |lab|
    if lab.eligible_line_items.none?
      lab.update_attributes(
        status:         'discarded',
        discard_reason: 'Automatically discarded by the system'
      )
    end
  end
end
