class ChangeOneMonthRateToThree < ActiveRecord::Migration[5.1]
  def change
    rename_column :line_items, :one_month_accrual, :three_month_accrual
  end
end
