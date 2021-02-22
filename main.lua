require 'global'

local font = assets.fonts.fixedsys(16)
love.graphics.setFont(font)

local SelectScene = require 'src.scenes.select-scene'
local GameScene = require 'src.scenes.game-scene'
local Camera = require 'src.camera'

function love.load(args)
  for k, v in ipairs(args) do
    if v == "-debug" then
      DEBUG = true
    end
  end

  scene = DEBUG and GameScene('2p') or SelectScene()
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
