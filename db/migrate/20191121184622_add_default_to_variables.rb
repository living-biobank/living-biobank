class AddDefaultToVariables < ActiveRecord::Migration[5.1]
  def change
    add_column :variables, :default, :boolean, after: :alternative_text

    Variable.find_by(name: "QI").update_attribute("default", true)
  end
end
