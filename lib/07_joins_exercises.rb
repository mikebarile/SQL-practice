# == Schema Information
#
# Table name: actors
#
#  id          :integer      not null, primary key
#  name        :string
#
# Table name: movies
#
#  id          :integer      not null, primary key
#  title       :string
#  yr          :integer
#  score       :float
#  votes       :integer
#  director_id :integer
#
# Table name: castings
#
#  movie_id    :integer      not null, primary key
#  actor_id    :integer      not null, primary key
#  ord         :integer

require_relative './sqlzoo.rb'

def example_join
  execute(<<-SQL)
    SELECT
      *
    FROM
      movies
    JOIN
      castings ON movies.id = castings.movie_id
    JOIN
      actors ON castings.actor_id = actors.id
    WHERE
      actors.name = 'Sean Connery'
  SQL
end

def ford_films
  # List the films in which 'Harrison Ford' has appeared.
  execute(<<-SQL)
    SELECT m.title
    FROM movies m
    INNER JOIN castings c ON c.movie_id = m.id
    INNER JOIN actors a ON a.id = c.actor_id
    WHERE a.name = 'Harrison Ford'
  SQL
end

def ford_supporting_films
  # List the films where 'Harrison Ford' has appeared - but not in the star
  # role. [Note: the ord field of casting gives the position of the actor. If
  # ord=1 then this actor is in the starring role]
  execute(<<-SQL)
    SELECT m.title
    FROM movies m
    INNER JOIN castings c ON c.movie_id = m.id
    INNER JOIN actors a ON a.id = c.actor_id
    WHERE a.name = 'Harrison Ford' AND c.ord != 1
  SQL
end

def films_and_stars_from_sixty_two
  # List the title and leading star of every 1962 film.
  execute(<<-SQL)
    SELECT m.title, a.name
    FROM movies m
    INNER JOIN castings c ON c.movie_id = m.id
    INNER JOIN actors a ON a.id = c.actor_id
    WHERE m.yr = 1962 AND c.ord = 1
  SQL
end

def travoltas_busiest_years
  # Which were the busiest years for 'John Travolta'? Show the year and the
  # number of movies he made for any year in which he made at least 2 movies.
  execute(<<-SQL)
    SELECT m.yr, count(m.yr)
    FROM movies m
    INNER JOIN castings c ON c.movie_id = m.id
    INNER JOIN actors a ON a.id = c.actor_id
    WHERE a.name = 'John Travolta'
    GROUP BY 1
    HAVING count(m.yr) >= 2
  SQL
end

def andrews_films_and_leads
  # List the film title and the leading actor for all of the films 'Julie
  # Andrews' played in.
  execute(<<-SQL)
    WITH ja as (
      SELECT DISTINCT m.id
      FROM movies m
      INNER JOIN castings c ON c.movie_id = m.id
      INNER JOIN actors a ON a.id = c.actor_id
      WHERE a.name = 'Julie Andrews'
    )
    SELECT m.title, a.name
    FROM movies m
    INNER JOIN castings c ON c.movie_id = m.id
    INNER JOIN actors a ON a.id = c.actor_id
    INNER JOIN ja ON m.id = ja.id
    WHERE c.ord = 1
  SQL
end

def prolific_actors
  # Obtain a list in alphabetical order of actors who've had at least 15
  # starring roles.
  execute(<<-SQL)
    SELECT a.name
    FROM movies m
    INNER JOIN castings c ON c.movie_id = m.id
    INNER JOIN actors a ON a.id = c.actor_id
    WHERE c.ord = 1
    GROUP BY 1
    HAVING count(a.name) >= 15
    ORDER BY 1
  SQL
end

def films_by_cast_size
  # List the films released in the year 1978 ordered by the number of actors
  # in the cast (descending), then by title (ascending).
  execute(<<-SQL)
    SELECT
      m.title
      , count(c.actor_id)
    FROM movies m
    INNER JOIN castings c ON c.movie_id = m.id
    INNER JOIN actors a ON a.id = c.actor_id
    WHERE m.yr = 1978
    GROUP BY 1
    ORDER BY count(c.actor_id) desc, m.title

  SQL
end

def colleagues_of_garfunkel
  # List all the people who have played alongside 'Art Garfunkel'.
  execute(<<-SQL)
    WITH agm as (
      SELECT DISTINCT m.id
      FROM movies m
      INNER JOIN castings c ON c.movie_id = m.id
      INNER JOIN actors a ON a.id = c.actor_id
      WHERE a.name = 'Art Garfunkel'
    )

    SELECT a.name
    FROM movies m
    INNER JOIN castings c ON c.movie_id = m.id
    INNER JOIN actors a ON a.id = c.actor_id
    INNER JOIN agm on agm.id = m.id
    WHERE a.name != 'Art Garfunkel'

  SQL
end
