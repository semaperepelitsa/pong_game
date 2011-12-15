$:.push File.expand_path('../lib', __FILE__)

require 'java'
require 'lwjgl.jar'
require 'slick.jar'

java_import org.newdawn.slick.BasicGame
java_import org.newdawn.slick.GameContainer
java_import org.newdawn.slick.Graphics
java_import org.newdawn.slick.Image
java_import org.newdawn.slick.Input
java_import org.newdawn.slick.SlickException
java_import org.newdawn.slick.AppGameContainer


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

class Paddle
  attr_reader :x, :y, :angle, :game

  def initialize(game)
    @image = Image.new('media/paddle.png')
    @game = game
    reset
  end

  def reset
    @x = 200
    @y = 400
  end

  def width
    @image.width
  end

  def height
    @image.height
  end

  def render(container, graphics)
    @image.draw(@x, @y)
  end

  def update(container, delta)
    input = container.get_input

    if input.is_key_down(Input::KEY_LEFT) and @x > 0
      @x -= 0.3 * delta
    end

    if input.is_key_down(Input::KEY_RIGHT) and @x < container.width - width
      @x += 0.3 * delta
    end
  end

end


class PongGame < BasicGame
  attr_reader :ball, :paddle

  def render(container, graphics)
    @bg.draw(0, 0)
    @ball.render(container, graphics)
    @paddle.render(container, graphics)
    graphics.draw_string("RubyPong (ESC to exit)", 8, container.height - 30)
  end

  def init(container)
    @bg = Image.new('media/bg.png')
    @ball = Ball.new(self)
    @paddle = Paddle.new(self)
  end

  def update(container, delta)
    input = container.get_input
    container.exit if input.is_key_down(Input::KEY_ESCAPE)

    @ball.update(container, delta)
    @paddle.update(container, delta)

    # if @ball_x >= @paddle_x and @ball_x <= (@paddle_x + @paddle.width) and @ball_y.round >= (400 - @ball.height)
    #   @ball_angle = (@ball_angle + 90) % 360
    # end

  end

  def reset
    @ball.reset
    @paddle.reset
  end
end # class

app = AppGameContainer.new(PongGame.new('RubyPong'))
app.set_display_mode(640, 480, false)
app.start
