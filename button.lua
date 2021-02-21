local RectObject = require 'rect-object'

---@class Button : RectObject
local Button = Class('Button', RectObject)

function Button:initialize(x, y, text)
  local font = love.graphics.getFont()
  local w, h = font:getWidth(text), font:getHeight()

  RectObject.initialize(self, x, y, w, h)
  self.text = text
  self.hover = false

  self.onClick = Event()
end

function Button:update(dt)
  if self:isPointInside(self.scene:getMousePosition()) then
    self.hover = true
    if input:isPressed('mouse1') then
      self.onClick()
    end
  else
    self.hover = false
  end
end

function Button:draw()
  local g = love.graphics
  g.setColor(0, 0, 0)
  g.print(self.text, self.x+1, self.y+1)
  if self.hover then
    g.setColor(1, 1, 1)
  else
    g.setColor(0.8, 0.8, 0.8)
  end
  g.print(self.text, self.x, self.y)
  g.setColor(1, 1, 1)
end

return Button
