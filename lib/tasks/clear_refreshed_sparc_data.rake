namespace :data do
  desc "Clear data for protocols that are deleted by SPARC-d data refreshes"
  task clear_refreshed_sparc_data: :environment do
    if Rails.env.testing?
      SparcRequest.all.each do |sr|
        if sr.protocol.nil?
          Lab.where(line_item: sr.line_items).destroy_all
          Population.where(line_item: sr.line_items).destroy_all
          sr.destroy
        end
      end
    end
  end
end
