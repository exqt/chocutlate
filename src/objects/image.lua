local RectObject = require 'src.objects.rect-object'

---@class ImageObject : RectObject
local ImageObject = Class('ImageObject', RectObject)

function ImageObject:initialize(x, y, image)
  self.image = image ---@type Image
  RectObject.initialize(self, x, y, self.image:getDimensions())
  self.onClick = Event()
end

function ImageObject:update(dt)
end

function ImageObject:draw()
  local g = love.graphics
  g.draw(self.image, self.x, self.y)
end

return ImageObject
