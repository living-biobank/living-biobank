class AddConditionsToVariables < ActiveRecord::Migration[5.1]
  def change
    add_column :variables, :condition, :string

    Variable.find_by(name: "QI").update_attribute("condition", "irb.blank?")
    Variable.find_by(name: "IRB Approved Research").update_attribute("condition", "irb.present?")
  end
end
