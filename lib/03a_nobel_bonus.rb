# == Schema Information
#
# Table name: nobels
#
#  yr          :integer
#  subject     :string
#  winner      :string

require_relative './sqlzoo.rb'

# BONUS PROBLEM: requires sub-queries or joins. Attempt this after completing
# sections 04 and 07.

def physics_no_chemistry
  # In which years was the Physics prize awarded, but no Chemistry prize?
  execute(<<-SQL)
    WITH chem_nobels as (
      SELECT DISTINCT
        yr
      FROM
        nobels
      WHERE
        subject = 'Chemistry'
    )

    SELECT DISTINCT
      phys_nobels.yr
    FROM
      nobels as phys_nobels
    LEFT JOIN chem_nobels
      ON phys_nobels.yr = chem_nobels.yr
    WHERE 1=1
      AND subject = 'Physics'
      AND chem_nobels.yr IS NULL
  SQL
end
