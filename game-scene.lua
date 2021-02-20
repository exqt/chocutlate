local Scene = require 'scene'
local ChocolateObject = require 'chocolate-object'
local ChocolateData = require 'chocolate-data'
local GameState = require 'game-state'

---@class GameScene : Scene
local GameScene = Class('Scene', Scene)

function GameScene:initialize()
  Scene.initialize(self)

  self.state = GameState()
  local chocolateObject = ChocolateObject(0, 0, self.state:enumerate()(), self.state)
  self:addObject(chocolateObject)
  self.camera:setPosition(chocolateObject:getCenterPosition())
end

function GameScene:update(dt)
  Scene.update(self, dt)
end

function GameScene:draw()
  local g = love.graphics

  self.camera:clear(0.2, 0.2, 0.2)
  self.camera:render(function()
    for i=#self.objects, 1, -1 do
      local obj = self.objects[i]
      obj:draw()
    end
  end)
  --ui
  self.camera:render(function()
    local sw, sh = self.camera.width, self.camera.height
    local width = 48
    g.setColor(0, 0, 0)
    g.rectangle("fill", 0, 0, width, sh)
    g.rectangle("fill", sw-width, 0, width, sh)
    g.setColor(1, 1, 1)

    local drawStat = function(player, x, y)
      g.print(self.state.turn == player and "@" or ".", x, 0)
      g.print(self.state.collected[player][1], x, 18)
      ChocolateObject.drawSinglePiece(1, x+16, 18)
      g.print(self.state.collected[player][2], x, 18*2)
      ChocolateObject.drawSinglePiece(2, x+16, 18*2)
      g.print(self.state.collected[player][3], x, 18*3)
      ChocolateObject.drawSinglePiece(3, x+16, 18*3)
    end

    drawStat(1, 4)
    drawStat(2, sw-44)
  end, true)

  self.camera:draw()
end

return GameScene
