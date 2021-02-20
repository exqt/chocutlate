local Camera = require 'camera'

---@class Scene
local Scene = Class('Scene')

function Scene:initialize()
  self.camera = Camera(self, 16*8, 9*8, 16 * 16, 9 * 16, 4)
  self.objects = {} ---@type GameObject[]
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
  for i, obj in ipairs(self.objects) do
    obj:update(dt)
  end
end

function Scene:draw()
  self.camera:clear(0.2, 0.2, 0.2)
  self.camera:render(function()
    for i=#self.objects, 1, -1 do
      local obj = self.objects[i]
      obj:draw()
    end
  end)
  self.camera:draw()
end

return Scene
