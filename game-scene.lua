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
    g.print(("%s %d, %d, %d"):format(self.state.turn == 1 and "@" or ".", self.state.collected[1][1], self.state.collected[1][2], self.state.collected[1][3]), 0, -18)
    g.print(("%s %d, %d, %d"):format(self.state.turn == 2 and "@" or ".", self.state.collected[2][1], self.state.collected[2][2], self.state.collected[2][3]), 0, 100)
  end)
  self.camera:draw()
end

return GameScene
