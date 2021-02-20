local RectObject = require 'rect-object'

---@class Chocolate : RectObject
local Chocolate = Class('Chocolate', RectObject)

local size = 16
local image = assets.images.chocolate
local piecesQuads = {
  love.graphics.newQuad(     0, 0, size, size, image:getDimensions()),
  love.graphics.newQuad(  size, 0, size, size, image:getDimensions()),
  love.graphics.newQuad(2*size, 0, size, size, image:getDimensions()),
}

function Chocolate:initialize(x, y, r, c, seed)
  RectObject.initialize(self, x, y, c*size, r*size)
  self.r, self.c = r, c
  self.seed = seed
  self.pieces = {}
  assert(r*c % 3 == 0)
  local pool = {}
  for t=1, 3 do
    for i=1, r*c/3 do table.insert(pool, t) end
  end

  math.randomseed(seed)
  for i=1, #pool do
    local j = math.random(1, #pool)
    pool[i], pool[j] = pool[j], pool[i]
  end

  for i=1, r do
    local row = {}
    for j=1, c do
      table.insert(row, table.remove(pool))
    end
    table.insert(self.pieces, row)
  end
end

function Chocolate:split(orientation, p)

end

function Chocolate:update(dt)

end

function Chocolate:draw()
  for i=1, self.r do
    for j=1, self.c do
      local q = piecesQuads[self.pieces[i][j]]
      local x = (j-1)*size
      local y = (i-1)*size
      love.graphics.draw(image, q, x, y)
    end
  end
end

return Chocolate
