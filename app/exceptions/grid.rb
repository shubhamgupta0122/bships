module Exceptions
  module Grid

    class InvalidShipOrientation < StandardError
      def initialize
        msg = "Allowed Orientations => #{Grid::SHIP_ORIENTATIONS}"
        super(msg)
      end
    end

    class InvalidShip < StandardError ; end
    class InvalidCoordinates < StandardError ; end

  end
end