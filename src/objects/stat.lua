local GameObject = require 'src.objects.object'

---@class GameStat : GameObject
local GameStat = Class('GameStat', GameObject)
GameStat.static.width = 48

function GameStat:initialize(x, y, state, player)
  self.x, self.y = x, y
  self.state = state
  self.player = player
end

function GameStat:update(dt)
end

function GameStat:draw()
  local g = love.graphics
  local h = scene.camera.height
  g.push()
  g.translate(self.x, self.y)
    g.setColor(0, 0, 0)
    g.rectangle("fill", 0, 0, GameStat.width, h)
    g.setColor(1, 1, 1)

    local ChocolateObject = require 'src.objects.chocolate-object'
    g.print("x" .. tostring(self.state.collected[self.player][1]), 24, 6+18*0)
    g.print("x" .. tostring(self.state.collected[self.player][2]), 24, 6+18*1)
    g.print("x" .. tostring(self.state.collected[self.player][3]), 24, 6+18*2)
    ChocolateObject.drawSinglePiece(1, 6, 6+18*0)
    ChocolateObject.drawSinglePiece(2, 6, 6+18*1)
    ChocolateObject.drawSinglePiece(3, 6, 6+18*2)
    local total =
      self.state.collected[self.player][1]
      + self.state.collected[self.player][2]
      + self.state.collected[self.player][3]
    g.print(15-total, 6, 6+18*3)

  g.pop()
end

return GameStat
