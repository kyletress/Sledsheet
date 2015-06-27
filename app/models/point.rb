class Point < ActiveRecord::Base
  belongs_to :athlete
  belongs_to :timesheet
  belongs_to :circuit
  belongs_to :season

  validates :athlete, :timesheet, :circuit, :season, :value, presence: true

  def calculate_points_for(circuit, rank)
    case circuit
    when "World Cup" || "World Championship"
      value_for_wc(rank)
    when "Intercontinental Cup" || "Junior World Championship"
      value_for_ic(rank)
    when "North American Cup" || "Europa Cup"
      value_for_ec(rank)
    else
      0
    end
  end

  def value_for_wc(rank)
    case rank
    when 1
      225
    when 2
      210
    when 3
      200
    when 4
      192
    when 5
      184
    when 6
      176
    when 7
      168
    when 8
      160
    when 9
      152
    when 10
      144
    when 11
      136
    when 12
      128
    when 13
      120
    when 14
      112
    when 15
      104
    when 16
      96
    when 17
      88
    when 18
      80
    when 19
      74
    when 20
      68
    when 21
      62
    when 22
      56
    when 23
      50
    when 24
      45
    when 25
      40
    when 26
      36
    when 27
      32
    when 28
      28
    when 29
      24
    when 30
      20
    else
      0
    end
  end

  def value_for_ic(rank)
    case rank
    when 1
      120
    when 2
      110
    when 3
      102
    when 4
      96
    when 5
      92
    when 6
      88
    when 7
      84
    when 8
      80
    when 9
      76
    when 10
      72
    when 11
      68
    when 12
      64
    when 13
      60
    when 14
      56
    when 15
      52
    when 16
      48
    when 17
      44
    when 18
      40
    when 19
      37
    when 20
      34
    when 21
      31
    when 22
      28
    when 23
      25
    when 24
      22
    when 25
      20
    when 26
      18
    when 27
      16
    when 28
      14
    when 29
      12
    when 30
      10
    else
      0
    end
  end

  def value_for_ec(rank)
    case rank
    when 1
      75
    when 2
      65
    when 3
      55
    when 4
      50
    when 5
      45
    when 6
      40
    when 7
      38
    when 8
      36
    when 9
      34
    when 10
      32
    when 11
      30
    when 12
      28
    when 13
      26
    when 14
      24
    when 15
      22
    when 16
      20
    when 17
      18
    when 18
      16
    when 19
      14
    when 20
      12
    when 21
      10
    when 22
      9
    when 23
      8
    when 24
      7
    when 25
      6
    when 26
      5
    when 27
      4
    when 28
      3
    when 29
      2
    when 30
      1
    else
      0
    end
  end

  def half_points(rank)
    case rank
    when 1
      50
    when 2
      38
    when 3
      28
    when 4
      20
    when 5
      13
    when 6
      8
    when 7
      5
    else
      0
    end
  end

end
