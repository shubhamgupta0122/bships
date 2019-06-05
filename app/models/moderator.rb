class Moderator

  def initialize(num_of_players)
    if num_of_players.is_a?(Integer) and [1,2].include?(num_of_players)
      if num_of_players == 1
        @num_of_players = num_of_players
      else
        raise InvalidNumberOfPlayers # Not yet implemented
      end
    else
      raise InvalidNumberOfPlayers
    end
  end

  def play
    play_one_player_game
  end

  def play_one_player_game
    @grid = Grid.new
    ships = @grid.availaible_ships
    # @grid.availaible_ships.shuffle.each do |ship|
      # pos, orientation = get_random_pos_and_orientation_for(grid)
      # @grid.place_ship(ship, )
    # end
    @grid.place_ship(ships[0], 'A1', Ship::Orientation::RIGHT) #5x
    @grid.place_ship(ships[1], 'B3', Ship::Orientation::DOWN ) #4x
    @grid.place_ship(ships[2], 'H2', Ship::Orientation::RIGHT) #4x
    @grid.place_ship(ships[3], 'C5', Ship::Orientation::RIGHT) #3x
    @grid.place_ship(ships[4], 'D8', Ship::Orientation::RIGHT) #3x
    @grid.place_ship(ships[5], 'B9', Ship::Orientation::RIGHT) #2x
    @grid.place_ship(ships[6], 'E6', Ship::Orientation::RIGHT) #2x
    @grid.place_ship(ships[7], 'I8', Ship::Orientation::RIGHT) #2x

    until @grid.complete?
      print_grid
      player_input = self.class.prompt_player(:point_to_hit)
      exit? player_input
      if self.class.valid_player_input? player_input
        @grid.hit(player_input)
      else
        self.class.warn_bad_input player_input
      end
    end
  end

  def print_grid
    system('clear')
    @grid.print_on_screen
  end

  def exit?(player_input)
    if player_input == 'exit'
      end_game
    end
  end

  def end_game
    if @grid.complete?
      class.print_you_won
    end
    "Thank You for Playing!"
    exit
  end

  def self.prompt_player(prompt)
    if prompt == :point_to_hit
      puts "Enter the point on board to hit"
    end
  end

  def self.valid_player_input?(player_input)
    player_input.match(/([a-jA-J][0-9])/).present?
  end

  def self.war_bad_input(player_input)
    puts "Bad Input : #{player_input}"
    puts "Choose any valid grid point : [#{Grid::ROWS.first}-#{Grid::ROWS.last}][#{Grid::COLS.first}-#{Grid::COLS.last}]"
  end

  def self.print_you_won
    puts "You Won!!"
  end

end
