require "game_object"

class Paddle < GameObject
  def reset
    @x = 200
    @y = 400
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
