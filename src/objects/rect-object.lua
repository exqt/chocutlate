local Object = require 'src.objects.object'

---@class RectObject : GameObject
local RectObject = Class('RectObject', Object)

function RectObject:initialize(x, y, w, h)
  Object.initialize(self)
  self.x, self.y = x, y
  self.w, self.h = w, h
end

function RectObject:getCenterPosition()
  return self.x + self.w/2, self.y + self.h/2
end

function RectObject:setCenterPosition(x, y)
  self.x, self.y = x - self.w/2, y - self.h/2
end

function RectObject:getDimensions()
  return self.w, self.h
end

function RectObject:isPointInside(x, y)
  return self.x <= x and x < self.x+self.w and self.y <= y and y < self.y+self.h
end

function RectObject:update(dt)

end

function RectObject:draw()
  love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

return RectObject
