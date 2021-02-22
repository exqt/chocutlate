local Camera = require 'src.camera'
local Timer = require 'lib.timer'

---@class Scene
local Scene = Class('Scene')

function Scene:initialize()
  self.camera = Camera(self, 0, 0, 16 * 16, 9 * 16, 4)
  self.objects = {} ---@type GameObject[]
  self.timer = Timer()
  self.time = 0
  self.transition = nil
end

function Scene:addObject(obj)
  obj.scene = self
  table.insert(self.objects, obj)
end

function Scene:doTransition(inout, fn)
  local onEnd = function()
    if fn then fn() end
    self.transition = nil
  end
  if inout == 'in' then
    self.transition = {type = 'in', value = 0}
    self.timer:tween(1, self.transition, {value = 1}, 'in-quad', onEnd)
  elseif inout == 'out' then
    self.transition = {type = 'out', value = 0}
    self.timer:tween(1, self.transition, {value = 1}, 'out-quad', onEnd)
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
  for i, obj in ipairs(self.objects) do
    obj:update(dt)
  end
  table.filterInplace(self.objects, function(o) return not o._dead end)
end

function Scene:drawTransition()
  if not self.transition then return end
  local g = love.graphics
  local sw, sh = love.graphics.getDimensions()
  g.setColor(0, 0, 0)
  if self.transition.type == 'in' then
    g.rectangle("fill", sw*self.transition.value, 0, sw, sh)
  elseif self.transition.type == 'out' then
    g.rectangle("fill", 0, 0, sw*self.transition.value, sh)
  end
  g.setColor(1, 1, 1)
end

function Scene:draw()
end

return Scene
