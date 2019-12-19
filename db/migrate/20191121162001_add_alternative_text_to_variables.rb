class AddAlternativeTextToVariables < ActiveRecord::Migration[5.1]
  def change
    add_column :variables, :alternative_text, :string, after: :name

    Variable.find_by(name: "QI").update_attribute("alternative_text", "No Additional Variables")

    Variable.find_by(name: "IRB Approved Research").update_attribute("alternative_text", "Include Additional Variables")
  end
end
