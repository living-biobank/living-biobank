class AddDiscardReasonToLabs < ActiveRecord::Migration[5.2]
  def change
    add_column :labs, :discard_reason, :string, after: :discarded_by
  end
end
