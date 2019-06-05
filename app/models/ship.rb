# body is an array of `size`
# 0 means that point on body is intact

class Ship
  class Exceptions
    class InvalidType     < StandardError; end
    class PointAlreadyHit < StandardError; end
    class InvalidHitRange < StandardError
      def initialize(ship)
        msg = "point value should be between 0 to #{ship.size - 1}"
        super(msg)
      end
    end
  end
  class Orientation
    LEFT = :left
    RIGHT = :right
    ALL = [LEFT, RIGHT]
  end

  BODY = {normal: 0, hit: 1}
  TYPES = %w(Carrier Battleship Destroyer Cruiser)
  SIZES = {
    'Carrier'    => 5,
    'Battleship' => 4,
    'Destroyer'  => 3,
    'Cruiser'    => 2
  }
  INITIAL_COUNTS = {
    'Carrier'    => 1,
    'Battleship' => 2,
    'Destroyer'  => 2,
    'Cruiser'    => 3
  }

  attr_reader :type, :size, :body, :placed

  def initialize(type)
    check_if_can_initialize(type)
    @type = type
    @size = SIZES[@type]
    @body = []
    @size.times{ @body << BODY[:normal] }
    @placed = false
  end

  def place_on_grid(grid, point)
    check_if_can_place_on_grid(grid, point)
    @grid = grid
    @position = {
      x: point[0],
      y: point[1]
    }
  end

  def hit(point)
    check_if_can_hit
    @body[point] = 1
    self
  end

  def destroyed?
    @body.uniq == [ BODY[:hit] ]
  end

  # def intact?
  #   @body.uniq == [ BODY[:intact] ]
  # end

  def inspect
    "#<Ship (id: #{@id}) #{@body}>"
  end

  private

  def check_if_can_initialize(type)
    raise InvalidTypeError unless TYPES.include?(type)
  end

  def check_if_can_place_on_grid(grid, point)
    raise Exceptions::Ship::InvalidGridType
  end

  def check_if_can_hit
    raise Exceptions::Ship::InvalidPointRange.new(self) unless (0 .. @size-1).include?(point)
    raise Exceptions::Ship::PointAlreadyHit if @body[point] == 1
  end

end
