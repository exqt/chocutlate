local Camera = require 'src.camera'
local Timer = require 'lib.timer'
local ObjectGroup = require 'src.objects.object-group'

---@class Scene
local Scene = Class('Scene')

function Scene:initialize()
  self.camera = Camera(self, 0, 0, 16 * 16, 9 * 16, 4)
  self.objects = ObjectGroup()
  self.timer = Timer()
  self.time = 0
  self.transition = nil
end

function Scene:doTransition(inout, fn)
  local onEnd = function()
    if fn then fn() end
    self.transition = nil
  end
  if inout == 'in' then
    self.transition = {type = 'in', value = 0}
    self.timer:tween(1.0, self.transition, {value = 1}, 'linear', onEnd)
  elseif inout == 'out' then
    self.transition = {type = 'out', value = 0}
    self.timer:tween(1.0, self.transition, {value = 1}, 'linear', onEnd)
  end
end

function Scene:getMousePosition()
  local x, y = love.mouse.getPosition()
  return self.camera:convertScreenToScene(x, y)
end

function Scene:update(dt)
  self.timer:update(dt)
  if self.transition then return end
  self.time = self.time + dt
  self.objects:update(dt)
end

function Scene:drawTransition()
  if not self.transition then return end
  local g = love.graphics
  local sw, sh = self.camera.width, self.camera.height
  local n = 6
  local l = sh/n/2
  g.setColor(0, 0, 0)
  if self.transition.type == 'in' then
    local x = sw*(self.transition.value*1.1)
    g.rectangle("fill", x, 0, sw, sh)
    for i=0, n do
      local y = 2*i*l-l
      g.polygon("fill", x, y, x-l, y+l, x, y+2*l)
    end
  elseif self.transition.type == 'out' then
    local x = sw*(self.transition.value*1.1 - 0.1)
    g.rectangle("fill", 0, 0, x, sh)
    for i=0, n do
      local y = 2*i*l-l
      g.polygon("fill", x, y, x+l, y+l, x, y+2*l)
    end
  end
  g.setColor(1, 1, 1)
end

function Scene:draw()
end

return Scene
