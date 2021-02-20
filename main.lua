require 'global'

local Scene = require 'scene'
local Camera = require 'camera'
scene = Scene()
local RectObject = require 'rect-object'
local ChocolateObject = require 'chocolate-object'
local ChocolateData = require 'chocolate-data'
local chocolate = ChocolateObject(0, 0, ChocolateData())
scene:addObject(chocolate)
scene.camera:setPosition(chocolate:getCenterPosition())

function love.load(args)
  for k, v in ipairs(args) do
    if v == "-debug" then
      DEBUG = true
    end
  end
end

function love.mousepressed(x, y, btn) input:mousepressed(x, y, btn) end
function love.mousereleased(x, y, btn) input:mousereleased(x, y, btn) end

function love.update(dt)
  if DEBUG then
    require('lib.lovebird').update()
    require('lib.lurker').update()
  end
  scene:update(dt)
  input:clear()
end

function love.draw()
  scene:draw()
end
