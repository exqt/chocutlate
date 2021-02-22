local RectObject = require 'src.objects.rect-object'

---@class TextObject : RectObject
local TextObject = Class('TextObject', RectObject)

function TextObject:initialize(x, y, text, clickable)
  local font = love.graphics.getFont()
  local w, h = font:getWidth(text), font:getHeight()

  RectObject.initialize(self, x, y, w, h)
  self.clickable = clickable
  self.text = text
  self.hover = false
  self.onClick = Event()
end

function TextObject:update(dt)
  if self.clickable then
    if self:isPointInside(scene:getMousePosition()) then
      self.hover = true
      if input:isPressed('mouse1') then
        self.onClick()
      end
    else
      self.hover = false
    end
  end
end

function TextObject:draw()
  local g = love.graphics
  if self.hover or not self.clickable then
    g.setColor(1, 1, 1)
  else
    g.setColor(0.8, 0.8, 0.8)
  end
  g.print(self.text, self.x, self.y)
  g.setColor(1, 1, 1)
end

return TextObject
