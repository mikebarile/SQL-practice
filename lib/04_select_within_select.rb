# == Schema Information
#
# Table name: countries
#
#  name        :string       not null, primary key
#  continent   :string
#  area        :integer
#  population  :integer
#  gdp         :integer

require_relative './sqlzoo.rb'

# A note on subqueries: we can refer to values in the outer SELECT within the
# inner SELECT. We can name the tables so that we can tell the difference
# between the inner and outer versions.

def example_select_with_subquery
  execute(<<-SQL)
    SELECT
      name
    FROM
      countries
    WHERE
      population > (
        SELECT
          population
        FROM
          countries
        WHERE
          name='Romania'
        )
  SQL
end

def larger_than_russia
  # List each country name where the population is larger than 'Russia'.
  execute(<<-SQL)
  SELECT
    name
  FROM
    countries
  WHERE
    population > (
      SELECT
        population
      FROM
        countries
      WHERE
        name='Russia'
      )

  SQL
end

def richer_than_england
  # Show the countries in Europe with a per capita GDP greater than
  # 'United Kingdom'.
  execute(<<-SQL)
  SELECT
    name
  FROM
    countries
  WHERE 1=1
    AND continent = 'Europe'
    AND gdp / population > (
      SELECT
        gdp / population
      FROM
        countries
      WHERE
        name='United Kingdom'
    )

  SQL
end

def neighbors_of_certain_b_countries
  # List the name and continent of countries in the continents containing
  # 'Belize', 'Belgium'.
  execute(<<-SQL)
    WITH continents AS (
      SELECT DISTINCT
        continent
      FROM
        countries
      WHERE
        name IN ('Belize', 'Belgium')
    )

    SELECT
      countries.name, countries.continent
    FROM countries
    JOIN continents ON countries.continent = continents.continent

  SQL
end

def population_constraint
  # Which country has a population that is more than Canada but less than
  # Poland? Show the name and the population.
  execute(<<-SQL)
    WITH canada AS (
      SELECT
        population
      FROM
        countries
      WHERE
        name = 'Canada'
    ),

    poland AS (
      SELECT
        population
      FROM
        countries
      WHERE
        name = 'Poland'
    )

    SELECT countries.name, countries.population
    FROM countries
    JOIN canada ON countries.population > canada.population
    JOIN poland ON countries.population < poland.population
  SQL
end

def sparse_continents
  # Find every country that belongs to a continent where each country's
  # population is less than 25,000,000. Show name, continent and
  # population.
  # Hint: Sometimes rewording the problem can help you see the solution.
  execute(<<-SQL)
    WITH small_continent as (
      SELECT continent
      FROM countries
      GROUP BY 1
      HAVING max(population) < 25000000
    )

    SELECT
      c.name
      , c.continent
      , c.population

    FROM countries c
    JOIN small_continent sc on c.continent = sc.continent

  SQL
end