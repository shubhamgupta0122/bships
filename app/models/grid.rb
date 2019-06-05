class Grid
  ROWS = ( 'A'.. 'J' ).to_a # x DOWN
  COLS = (  1 .. 10  ).to_a # y RIGHT

  CELL = {empty: 0, attacked_but_no_ship: 1, has_ship: 2, attacked_ship: 3}

  def initialize
    @grid = []
    @complete = false

    ROWS.size.times do |i|
      # @grid[i] = Array.new(COLS.size, CELL[:empty])
      @grid[i] = []
      COLS.size.times do |j|
        @grid[i][j] = CELL[:empty]
      end
    end

    @ships = self.class.get_all_ships
  end

  # def placed_ships
  #   @ships.select(&:placed)
  # end

  def available_ships
    @ships.reject(&:placed)
  end

  def self.get_all_ships
    ships = []
    Ship::INITIAL_COUNTS.each do |ship_type, count|
      count.times do
        ships << Ship.new(ship_type)
      end
    end
    ships
  end

  def place_ship(ship, point, orientation)
    ship = check_if_can_place_ship?(ship, point, orientation)

    # notify ship of placement
    ship.place!

    # set grid values
    ship.size.times do |i|
      case orientation
      when Ship::Orientation::RIGHT
        grid[ship.x][ship.y + i] = CELL[:has_ship]
      when Ship::Orientation::DOWN
        grid[ship.x + i][ship.y] = CELL[:has_ship]
      end
    end
    print_on_screen
    puts "Placed #{ship} at #{point} #{orientation}"
  end

  def check_if_can_place_ship?(ship, point, orientation)
    x,y = self.class.parse_human_point(point) #raise inside

    ship.set_position(x, y, orientation)

    raise Exceptions::InvalidShipOrientation unless Ship::Orientation::ALL.include?(orientation)
    raise Exceptions::InvalidShip            unless available_ships.include?(ship)
    raise Exceptions::CellNotEmpty           if     overlaps?(ship)

    return ship
  end

  def overlaps? ship
    ship.size.times do |i|
      case orientation
      when Ship::Orientation::RIGHT
        x, y = ship.x, ship.y + 1
      when Ship::Orientation::DOWN
        x, y = ship.x + 1, ship.y
      end
      return true unless cell_empty?(x, y)
    end
    return false
  end

  # def inspect
  #   puts @grid.map(&:to_s)
  # end

  def cell_empty?(x,y)
    raise InvalidCoordinates unless self.class.valid_coordinate?(x,y)
    @grid[x][y] == CELL[:empty]
  end

  # def surrounding_cell_coordinates(x,y)
  #   points = [
  #     [x-1, y-1], [x  , y-1], [x+1, y-1],
  #     [x-1, y  ],           , [x+1, y  ],
  #     [x-1, y+1], [x  , y+1], [x+1, y+1]
  #   ]

  #   points.map do |x,y|
  #     cell_empty?(x,y)
  #   end

  #   return points
  # end

  def print_on_screen
    system('clear')
    ROWS.size.times do |i|
      print '+'
      COLS.size.times do
        print '---+'
      end
      print "\n|"
      COLS.size.times do |j|
        cell = self.class.print_cell(@grid[i][j])
        print " #{cell} |"
      end
      print "\n"
    end

    print '+'
    COLS.size.times do
      print '---+'
    end
    print "\n"
  end

  def self.print_cell(cell)
    case cell
    when CELL[:empty]
      ' '
    when CELL[:has_ship]
      ' '
    when CELL[:attacked_ship]
      '✖︎'
    when CELL[:attacked_but_no_ship]
      '○'
    end
  end

  def self.valid_coordinate?(x,y)
    if (x >= 0) and (x < ROWS.size) and (y >= 0) and (y < COLS.size)
      true
    else
      false
    end
  end

  def self.parse_human_point(point)

  end

end
