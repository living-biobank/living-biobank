class MigrateStatusesToSnakeKeys < ActiveRecord::Migration[5.2]
  def change
    SparcRequest.all.each do |sr|
      if sr.status == I18n.t('requests.statuses.complete')
        sr.update_attribute(:status, 'complete')
      elsif sr.status == I18n.t('requests.statuses.in_process')
        sr.update_attribute(:status, 'in_process')
      elsif sr.status == I18n.t('requests.statuses.pending')
        sr.update_attribute(:status, 'pending')
      elsif sr.status == I18n.t('requests.statuses.draft')
        sr.update_attribute(:status, 'draft')
      elsif sr.status == I18n.t('requests.statuses.cancelled')
        sr.update_attribute(:status, 'cancelled')
      end
    end

    Lab.all.each do |lab|
      if lab.status == I18n.t('labs.statuses.available')
        lab.update_attribute(:status, 'available')
      elsif lab.status == I18n.t('labs.statuses.released')
        lab.update_attribute(:status, 'released')
      elsif lab.status == I18n.t('labs.statuses.retrieved')
        lab.update_attribute(:status, 'retrieved')
      elsif lab.status == I18n.t('labs.statuses.discarded')
        lab.update_attribute(:status, 'discarded')
      end
    end
  end
end
