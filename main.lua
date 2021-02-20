require 'global'

function love.load()
end

function love.mousepressed(x, y, btn) input:mousepressed(x, y, btn) end
function love.mousereleased(x, y, btn) input:mousereleased(x, y, btn) end

function love.update(dt)
  if input:isPressed('mouse1') then
  end

  input:clear()
end

function love.draw()
  local g = love.graphics
end
