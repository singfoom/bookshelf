class SplitAuthorNameToFirstAndLastName < ActiveRecord::Migration[8.0]
  def change
    add_column :authors, :first_name, :string
    add_column :authors, :last_name, :string
    remove_column :authors, :name, :string
  end
end
