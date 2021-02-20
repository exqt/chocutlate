local ChocolateData = require 'chocolate-data'

---@class GameState
local GameState = Class('GameState')

function GameState:initialize()
  self.chocolates = {}
  self.chocolates[ChocolateData()] = true
  self.turn = 1
  self.collected = {
    {0, 0, 0},
    {0, 0, 0}
  }

  self.onCollected = Event()
  self.onCut = Event()
end

function GameState:clone()

end

function GameState:enumerate()
  return coroutine.wrap(function()
    for c in pairs(self.chocolates) do
      coroutine.yield(c)
    end
  end)
end

function GameState:getWinner()
  if self.collected[1][1] >= 8 and self.collected[1][2] >= 8 and self.collected[1][3] >= 8 then
    return 1
  end
  if self.collected[2][1] >= 8 and self.collected[2][2] >= 8 and self.collected[2][3] >= 8 then
    return 2
  end
  return nil
end

---@param chocolate ChocolateData
function GameState:cut(chocolate, orientation, p)
  assert(self.chocolates[chocolate])
  local d1, d2 = chocolate:cut(orientation, p)

  self.onCut(chocolate, orientation, p, d1, d2)

  if d1:isCollectable() then
    self.onCollected(d1)
    local s = d1:sum()
    for i=1, 3 do self.collected[self.turn][i] = self.collected[self.turn][i] + s[i] end
  else
    self.chocolates[d1] = true
  end

  if d2:isCollectable() then
    self.onCollected(d2)
    local s = d2:sum()
    for i=1, 3 do self.collected[self.turn][i] = self.collected[self.turn][i] + s[i] end
  else
    self.chocolates[d2] = true
  end

  self.turn = 3 - self.turn

  return d1, d2
end

return GameState
