require 'global'

local Scene = require 'scene'
local scene = Scene()
local RectObject = require 'rect-object'
scene:addObjecct(RectObject(10, 10, 50, 50))

function love.load()

end

function love.mousepressed(x, y, btn) input:mousepressed(x, y, btn) end
function love.mousereleased(x, y, btn) input:mousereleased(x, y, btn) end

function love.update(dt)
  scene:update(dt)
  input:clear()
end

function love.draw()
  scene:draw()
end
