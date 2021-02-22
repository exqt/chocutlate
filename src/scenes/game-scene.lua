local Scene = require 'src.scenes.scene'
local ChocolateObject = require 'src.objects.chocolate-object'
local ChocolateData = require 'src.core.chocolate-data'
local GameState = require 'src.core.game-state'
local AI = require 'src.core.ai'

---@class GameScene : Scene
local GameScene = Class('Scene', Scene)

function GameScene:initialize(mode)
  Scene.initialize(self)

  self.state = GameState()
  local chocolateObject = ChocolateObject(0, 0, self.state.chocolates[1], self.state)
  self:addObject(chocolateObject)

  self.camera:setPosition(chocolateObject:getCenterPosition())

  self.bg = assets.images.bg ---@type Image
  self.bg:setWrap("repeat", "repeat")
  self.bgQuad = love.graphics.newQuad(0, 0, 512, 512, 32, 32)
  self.ai = AI(5)

  self.state.onCut:add(function(chocolate, orientation, p, d1, d2)
    self.timer:after(0.3, function()
      if self.state:getWinner() then return end
      if self.state.turn == 2 then
        self.ai:run(self.state)
      end
    end)
  end)
end

function GameScene:reset()
  self:doTransition('out', function()
    scene = GameScene()
    scene:doTransition('in')
  end)
end

function GameScene:update(dt)
  Scene.update(self, dt)

  if self.ai:getCount() == 1 then
    local idx, orientation, p = unpack(self.ai:getResult())
    self.state:cut(self.state.chocolates[idx], orientation, p)
  end

  if input:isPressed('mouse2') then
    local score, action = AI(self.state, 4)
    local idx, orientation, p = unpack(action)
    print(score, idx, orientation)
    self.state:cut(self.state.chocolates[idx], orientation, p)
  end
  if input:isPressed('mouse3') then
    self:reset()
  end
end

function GameScene:draw()
  local g = love.graphics

  self.camera:clear(0.2, 0.2, 0.2)
  self.camera:render(function()
    self.bgQuad:setViewport(10*self.time, 10*self.time, 512, 512)
    g.draw(self.bg, self.bgQuad, -256, -256)
    local drawObjects = function(x, y)
      g.push()
      g.translate(x, y)
      for i=#self.objects, 1, -1 do
        local obj = self.objects[i]
        obj:draw()
      end
      g.pop()
    end
    g.setShader(assets.shaders.shadow)
    drawObjects(2, 2)
    g.setShader()
    drawObjects(0, 0)
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

    self:drawTransition()
  end, true)

  self.camera:draw()
end

return GameScene
