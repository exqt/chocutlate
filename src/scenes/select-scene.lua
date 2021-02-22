local Scene = require 'src.scenes.scene'

---@class SelectScene : Scene
local SelectScene = Class('Scene', Scene)

function SelectScene:initialize()
  Scene.initialize(self)

  self.bg = assets.images.bg ---@type Image
  self.bg:setWrap("repeat", "repeat")
  self.bgQuad = love.graphics.newQuad(0, 0, 512, 512, 32, 32)

  local Button = require 'src.objects.button'
  local GameScene = require 'src.scenes.game-scene'
  local buttonBot = Button(0, 0, "VS Bot")
  local button2P = Button(0, 20, "2 Player")
  self:addObject(buttonBot)
  self:addObject(button2P)
  buttonBot.onClick:add(function()
    self:doTransition('out', function()
      scene = GameScene()
      scene:doTransition('in')
    end)
  end)
  button2P.onClick:add(function()
    self:doTransition('out', function()
      scene = GameScene()
      scene:doTransition('in')
    end)
  end)
end

function SelectScene:update(dt)
  Scene.update(self, dt)
end

function SelectScene:draw()
  local g = love.graphics

  self.camera:clear(0.2, 0.2, 0.2)
  self.camera:render(function()
    self.bgQuad:setViewport(10*self.time, 10*self.time, 512, 512)
    g.draw(self.bg, self.bgQuad, -256, -256)
    for i=#self.objects, 1, -1 do
      local obj = self.objects[i]
      obj:draw()
    end
  end)
  --ui
  self.camera:render(function()
    self:drawTransition()
  end, true)

  self.camera:draw()
end

return SelectScene

