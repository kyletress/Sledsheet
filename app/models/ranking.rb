class Ranking

  def self.world_rank_for(season_id = Season.current_season.id, athlete)
    athlete_id = athlete.id
    gender = athlete.gender_integer
    conn = ActiveRecord::Base.connection
    result = conn.exec_query("
      SELECT total_points, world_rank, nation_rank FROM (
      SELECT athlete_id, total_points, rank() OVER (order by total_points desc) AS world_rank, rank() OVER (partition by country_code order by total_points desc) AS nation_rank
      FROM (
        SELECT athlete_id, sum(value) AS total_points
        FROM (
          SELECT row_number() OVER (partition by athlete_id ORDER BY value DESC) as r, p.*
          FROM points p where season_id = #{conn.quote(season_id)}) x
          WHERE x.r <= 8 AND x.r <= 1
          GROUP BY athlete_id
          ORDER BY total_points DESC) AS season_points
          INNER JOIN athletes on athlete_id = athletes.id
          WHERE gender = #{conn.quote(gender)}
          ORDER BY total_points DESC
        ) as foo
        WHERE athlete_id = #{conn.quote(athlete_id)}")
      result.first
  end

  def self.full_table(season_id = Season.current_season.id, gender)
    conn = ActiveRecord::Base.connection
    conn.select_all("
      SELECT athlete_id, total_points, rank() OVER (order by total_points desc) AS world_rank, rank() OVER (partition by country_code order by total_points desc) AS nation_rank
      FROM (
        SELECT athlete_id, sum(value) AS total_points
        FROM (
          SELECT row_number() OVER (partition by athlete_id ORDER BY value DESC) as r, p.*
          FROM points p where season_id = #{conn.quote(season_id)}) x
          WHERE x.r <= 8 AND x.r <= 1
          GROUP BY athlete_id
          ORDER BY total_points DESC) AS season_points
          INNER JOIN athletes on athlete_id = athletes.id
          WHERE gender = #{conn.quote(gender)}
          ORDER BY total_points DESC"
      )
  end

  def self.olympic_quotas
    #TODO
  end

end
