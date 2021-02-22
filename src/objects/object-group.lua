local GameObject = require 'src.objects.object'

---@class GameObjectGroup
---@field parent GameObjectGroup
local GameObjectGroup = Class('GameObjectGroup')

function GameObjectGroup:initialize()
  self.list = {} ---@type GameObject[]
end

function GameObjectGroup:add(o)
  o.group = self
  table.insert(self.list, o)
end

function GameObjectGroup:destory()
  for i, o in ipairs(self.list) do
    o:destory()
  end
end

function GameObjectGroup:update(dt)
  for i, o in ipairs(self.list) do
    o:update(dt)
  end
  table.filterInplace(self.list, function(o) return not o._dead end)
end

function GameObjectGroup:draw()
  for i=#self.list, 1, -1 do
    local o = self.list[i]
    o:draw()
  end
end

return GameObjectGroup
