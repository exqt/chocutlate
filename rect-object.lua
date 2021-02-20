local Object = require 'object'

---@class RectObject : GameObject
local RectObject = Class('RectObject', Object)

function RectObject:initialize(x, y, w, h)
  self.x, self.y = x, y
  self.w, self.h = w, h
end

function RectObject:getCenterPosition()
  return self.x + self.w/2, self.y + self.h/2
end

function RectObject:getDimensions()
  return self.w, self.h
end

function RectObject:update(dt)

end

function RectObject:draw()
  love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

return RectObject
