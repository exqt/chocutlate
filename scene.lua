---@class Scene
local Scene = Class('Scene')

function Scene:initialize()
  self.objects = {} ---@type GameObject[]
end

function Scene:addObjecct(obj)
  obj.scene = self
  table.insert(self.objects, obj)
end

function Scene:update(dt)
  for i, obj in ipairs(self.objects) do
    obj:update(dt)
  end
end

function Scene:draw()
  for i=#self.objects, 1, -1 do
    local obj = self.objects[i]
    obj:draw()
  end
end

return Scene
