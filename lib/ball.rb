class Ball
  attr_accessor :x, :y, :angle, :game

  def initialize(game)
    @image = Image.new('media/ball.png')
    @game = game
    reset
  end

  def reset
    @x = 200
    @y = 200
    @angle = 45
  end

  def width
    @image.width
  end

  def height
    @image.height
  end

  def paddle
    game.paddle
  end

  def render(container, graphics)
    @image.draw(@x, @y)
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
