class AddTeamCodeToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :team_code, :string
  end
end
