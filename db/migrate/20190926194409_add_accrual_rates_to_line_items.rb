class AddAccrualsToLineItems < ActiveRecord::Migration[5.1]
  def change
    add_column :line_items, :one_month_accrual, :float, after: :status
    add_column :line_items, :six_month_accrual, :float, after: :one_month_accrual
    add_column :line_items, :one_year_accrual, :float, after: :six_month_accrual
  end
end