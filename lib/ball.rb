require "game_object"

class Ball < GameObject
  attr_accessor :angle
  def_delegators :game, :paddle

  def reset
    @x = 200
    @y = 200
    @angle = 45
  end

  def update(container, delta)
    @x += 0.3 * delta * Math.cos(@angle * Math::PI / 180)
    @y -= 0.3 * delta * Math.sin(@angle * Math::PI / 180)

    if (@x > container.width - width) || (@y < 0) || (@x < 0)
      @angle = (@angle + 90) % 360
    end

    if @y > container.height
      game.reset
    end

    if @y + height > paddle.y and
       @x < paddle.x + paddle.width and
       @x + width > paddle.x
      @angle = (@angle + 80 + rand(20) - 10) % 360
    end
  end

end
