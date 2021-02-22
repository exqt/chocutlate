---@class GameObject
---@field scene Scene
---@field parent GameObjectGroup
---@field _dead boolean
local GameObject = Class('GameObject')

function GameObject:initialize()
  self._dead = false
end

function GameObject:update(dt)

end

function GameObject:destroy()
  self._dead = true
end

function GameObject:draw()

end

return GameObject
