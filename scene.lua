local Camera = require 'camera'
local Timer = require 'lib.timer'

---@class Scene
local Scene = Class('Scene')

function Scene:initialize()
  self.camera = Camera(self, 16*8, 9*8, 16 * 16, 9 * 16, 4)
  self.objects = {} ---@type GameObject[]
  self.timer = Timer()
  self.time = 0
end

function Scene:addObject(obj)
  obj.scene = self
  table.insert(self.objects, obj)
end

function Scene:getMousePosition()
  local x, y = love.mouse.getPosition()
  return self.camera:convertScreenToScene(x, y)
end

function Scene:update(dt)
  self.time = self.time + dt
  self.timer:update(dt)
  for i, obj in ipairs(self.objects) do
    obj:update(dt)
  end
  table.filterInplace(self.objects, function(o) return not o._dead end)
end

function Scene:draw()
end

return Scene
