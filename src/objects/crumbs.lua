local GameObject = require 'src.objects.object'

---@class ChocolateCrumbs : GameObject
local ChocolateCrumbs = Class('ChocolateCrumbs', GameObject)

local size = 16
local image = assets.images.chocolate
local piecesQuads = {
  love.graphics.newQuad(     0, 0, size, size, image:getDimensions()),
  love.graphics.newQuad(  size, 0, size, size, image:getDimensions()),
  love.graphics.newQuad(2*size, 0, size, size, image:getDimensions()),
}

function ChocolateCrumbs:initialize(x, y, type)
  local px, py = (type-1)*size, 0
  self.crumbs = {
    {
      x = x, y = y, vx = -math.random(2, 5), vy = -math.random(2, 5),
      quad = love.graphics.newQuad(px + 0, py + 0, 8, 8, image:getDimensions())
    },
    {
      x = x, y = y + 8, vx = -math.random(2, 5), vy = -math.random(2, 5),
      quad = love.graphics.newQuad(px + 0, py + 8, 8, 8, image:getDimensions())
    },
    {
      x = x + 8, y = y, vx = math.random(2, 5), vy = -math.random(2, 5),
      quad = love.graphics.newQuad(px + 8, py + 0, 8, 8, image:getDimensions())
    },
    {
      x = x + 8, y = y + 8, vx = math.random(2, 5), vy = -math.random(2, 5),
      quad = love.graphics.newQuad(px + 8, py + 8, 8, 8, image:getDimensions())
    },
  }
  scene.timer:after(2.0, function() self:destroy() end)
end

function ChocolateCrumbs:update(dt)
  for i, o in ipairs(self.crumbs) do
    o.vy = o.vy + 100 * dt
    o.x = o.x + o.vx*dt
    o.y = o.y + o.vy*dt
  end
end

function ChocolateCrumbs:draw()
  local g = love.graphics
  for i, o in ipairs(self.crumbs) do
    g.draw(image, o.quad, o.x, o.y)
  end
end

return ChocolateCrumbs
