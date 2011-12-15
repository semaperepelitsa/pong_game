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

class PongGame < BasicGame
  def render(container, graphics)
    @bg.draw(0, 0)
    @ball.draw(@ball_x, @ball_y)
    @paddle.draw(@paddle_x, @paddle_y)
    graphics.draw_string("RubyPong (ESC to exit)", 8, container.height - 30)
  end

  def init(container)
    @bg = Image.new('media/bg.png')

    @ball = Image.new('media/ball.png')
    @ball_x = 200
    @ball_y = 200
    @ball_angle = 45

    @paddle = Image.new('media/paddle.png')
    @paddle_x = 200
    @paddle_y = 400
  end

  def update(container, delta)
    input = container.get_input
    container.exit if input.is_key_down(Input::KEY_ESCAPE)

    if input.is_key_down(Input::KEY_LEFT) and @paddle_x > 0
      @paddle_x -= 0.3 * delta
    end

    if input.is_key_down(Input::KEY_RIGHT) and @paddle_x < container.width - @paddle.width
      @paddle_x += 0.3 * delta
    end

    @ball_x += 0.3 * delta * Math.cos(@ball_angle * Math::PI / 180)
    @ball_y -= 0.3 * delta * Math.sin(@ball_angle * Math::PI / 180)

    if (@ball_x > container.width - @ball.width) || (@ball_y < 0) || (@ball_x < 0)
      @ball_angle = (@ball_angle + 90) % 360
    end

    if @ball_y > container.height
      @paddle_x = 200
      @ball_x = 200
      @ball_y = 200
      @ball_angle = 45
    end

    if  @ball_y + @ball.height > @paddle_y and
        @ball_x < @paddle_x + @paddle.width and
        @ball_x + @ball.width > @paddle_x
      @ball_angle = (@ball_angle + 80 + rand(20) - 10) % 360
    end

    # if @ball_x >= @paddle_x and @ball_x <= (@paddle_x + @paddle.width) and @ball_y.round >= (400 - @ball.height)
    #   @ball_angle = (@ball_angle + 90) % 360
    # end

  end
end # class

app = AppGameContainer.new(PongGame.new('RubyPong'))
app.set_display_mode(640, 480, false)
app.start
