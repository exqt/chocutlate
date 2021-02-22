local Super = require 'src.objects.rect-object'

---@class ChocolateObject : RectObject
local ChocolateObject = Class('Chocolate', Super)

local size = 16
local image = assets.images.chocolate
local piecesQuads = {
  love.graphics.newQuad(     0, 0, size, size, image:getDimensions()),
  love.graphics.newQuad(  size, 0, size, size, image:getDimensions()),
  love.graphics.newQuad(2*size, 0, size, size, image:getDimensions()),
}

ChocolateObject.static.drawSinglePiece = function(t, x, y)
  love.graphics.draw(image, piecesQuads[t], x, y)
end

function ChocolateObject:initialize(x, y, chocolateData, state)
  self.data = chocolateData ---@type ChocolateData
  self.r, self.c = chocolateData:getDimensions()
  Super.initialize(self, x, y, self.c*size, self.r*size)

  if self.data:isCollectable() then
    self:destroy()
    return
  end

  self.state = state
  self.eTagCut = self.state.onCut:add(self, self.onCut)
end

function ChocolateObject:destroy()
  if self.eTagCut then self.state.onCut:remove(self.eTagCut) end
  Super.destroy(self)
end

function ChocolateObject:findCutline()
  local mx, my = scene:getMousePosition()
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

function ChocolateObject:onCut(chocolateData, orientation, p, d1, d2)
  if self.data ~= chocolateData then return end
  local sound = assets.sounds.cut
  sound:play()

  if orientation == 'horizonal' then
    local o1 = ChocolateObject(self.x, self.y - 4, d1, self.state)
    local o2 = ChocolateObject(self.x, self.y + p*size + 4, d2, self.state)
    self.group:add(o1)
    self.group:add(o2)
    self:destroy()

  elseif orientation == 'vertical' then
    local o1 = ChocolateObject(self.x - 4, self.y, d1, self.state)
    local o2 = ChocolateObject(self.x + p*size + 4, self.y, d2, self.state)
    self.group:add(o1)
    self.group:add(o2)
    self:destroy()
  end
end

function ChocolateObject:update(dt)
  if input:isReleased('mouse1') then
    local cutO, cutI = self:findCutline()
    if cutO then
      self.state:cut(self.data, cutO, cutI)
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
