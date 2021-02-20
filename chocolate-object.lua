local RectObject = require 'rect-object'

---@class ChocolateObject : RectObject
local ChocolateObject = Class('Chocolate', RectObject)

local size = 16
local image = assets.images.chocolate
local piecesQuads = {
  love.graphics.newQuad(     0, 0, size, size, image:getDimensions()),
  love.graphics.newQuad(  size, 0, size, size, image:getDimensions()),
  love.graphics.newQuad(2*size, 0, size, size, image:getDimensions()),
}

---@param chocolateData ChocolateData
function ChocolateObject:initialize(x, y, chocolateData)
  self.data = chocolateData
  self.r, self.c = chocolateData:getDimensions()
  RectObject.initialize(self, x, y, self.c*size, self.r*size)
end

function ChocolateObject:findCutline()
  local mx, my = self.scene:getMousePosition()
  if not self:isPointInside(mx, my) then return end
  local lx, ly = mx - self.x, my - self.y
  for i=1, self.r-1 do
    if math.abs(i*size - ly) <= 3 then
      return 'horizonal', i
    end
  end
  for i=1, self.c-1 do
    if math.abs(i*size - lx) <= 3 then
      return 'vertical', i
    end
  end
end

function ChocolateObject:cut(orientation, p)
  if orientation == 'horizonal' then
    local d1, d2 = self.data:cut(orientation, p)
    local o1 = ChocolateObject(self.x, self.y - 4, d1)
    local o2 = ChocolateObject(self.x, self.y + p*size + 4, d2)
    return o1, o2
  elseif orientation == 'vertical' then
    local d1, d2 = self.data:cut(orientation, p)
    local o1 = ChocolateObject(self.x - 4, self.y, d1)
    local o2 = ChocolateObject(self.x + p*size + 4, self.y, d2)
    return o1, o2
  end
end

function ChocolateObject:update(dt)
  if input:isReleased('mouse1') then
    local cutO, cutI = self:findCutline()
    if cutO then
      local o1, o2 = self:cut(cutO, cutI)
      self.scene:addObject(o1)
      self.scene:addObject(o2)
      self:destroy()
    end
  end
end

function ChocolateObject:draw()
  local g = love.graphics

  for i=1, self.r do
    for j=1, self.c do
      local q = piecesQuads[self.data:get(i, j)]
      local x = self.x + (j-1)*size
      local y = self.y + (i-1)*size
      g.draw(image, q, x, y)
    end
  end

  local cutOrientation, cutIdx = self:findCutline()
  g.setColor(1, 1, 0)
  if cutOrientation == 'horizonal' then
    local px, py, qx, qy = self.x, self.y + cutIdx*size, self.x + self.c*size, self.y + cutIdx*size
    g.rectangle("fill", px-1, py-1, qx-px+2, qy-py+2)
  elseif cutOrientation == 'vertical' then
    local px, py, qx, qy = self.x + cutIdx*size, self.y, self.x + cutIdx*size, self.y + self.r*size
    g.rectangle("fill", px-1, py-1, qx-px+2, qy-py+2)
  end
  g.setColor(1, 1, 1)

end

return ChocolateObject
