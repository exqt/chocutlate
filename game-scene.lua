local Scene = require 'scene'
local ChocolateObject = require 'chocolate-object'
local ChocolateData = require 'chocolate-data'
local GameState = require 'game-state'
local AI = require 'ai'

---@class GameScene : Scene
local GameScene = Class('Scene', Scene)

function GameScene:initialize()
  Scene.initialize(self)

  self.state = GameState()
  local chocolateObject = ChocolateObject(0, 0, self.state.chocolates[1], self.state)
  self:addObject(chocolateObject)

  self.camera:setPosition(chocolateObject:getCenterPosition())

  self.state.onCut:add(function(chocolate, orientation, p, d1, d2)
    self.timer:after(0.5, function()
      if self.state:getWinner() then return end
      if self.state.turn == 2 then
        local score, action = AI(self.state, 4)
        local idx, orientation, p = unpack(action)
        print(score, idx, orientation)
        self.state:cut(self.state.chocolates[idx], orientation, p)
      end
    end)
  end)
end

function GameScene:update(dt)
  Scene.update(self, dt)
  if input:isPressed('mouse2') then
    print("!")
    local score, action = AI(self.state, 4)
    local idx, orientation, p = unpack(action)
    print(score, idx, orientation)
    self.state:cut(self.state.chocolates[idx], orientation, p)
  end
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
    local winner = self.state:getWinner()
    if winner then
      g.print(winner, 16, 16)
    end
  end, true)

  self.camera:draw()
end

return GameScene
