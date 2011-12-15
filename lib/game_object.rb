require "forwardable"
require "active_support/core_ext/string/inflections"

class GameObject
  extend Forwardable
  attr_accessor :x, :y, :game

  def_delegators :@image, :width, :height

  def initialize(game)
    @image = Image.new("media/#{self.class.to_s.underscore}.png")
    @game = game
    reset
  end

  def reset
  end

  def render(container, graphics)
    @image.draw(@x, @y)
  end
end
