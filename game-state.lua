local ChocolateData = require 'chocolate-data'

---@class GameState
local GameState = Class('GameState')

function GameState:initialize(clone)
  if clone then return end
  self.chocolates = {}
  self:add(ChocolateData())
  self.turn = 1
  self.collected = {
    {0, 0, 0},
    {0, 0, 0}
  }
  self.onCollected = Event()
  self.onCut = Event()
end

function GameState:clone()
  local s = GameState(true)
  s.chocolates = {}
  for i, c in ipairs(self.chocolates) do
    s:add(c:clone())
  end
  s.turn = self.turn
  s.collected = {
    {self.collected[1][1], self.collected[1][2], self.collected[1][3]},
    {self.collected[2][1], self.collected[2][2], self.collected[2][3]}
  }
  return s
end

function GameState:add(c)
  table.insert(self.chocolates, c)
end

function GameState:has(c)
  for _, d in ipairs(self.chocolates) do
    if d == c then return true end
  end
  return false
end

function GameState:getAllNextStates()
  return coroutine.wrap(function()
    for i, choco in ipairs(self.chocolates) do
      local r, c = choco:getDimensions()
      for p=1, r-1 do
        local s = self:clone()
        s:cut(s.chocolates[i], 'horizonal', p)
        coroutine.yield(s, i, 'horizonal', p)
      end
      for p=1, c-1 do
        local s = self:clone()
        s:cut(s.chocolates[i], 'vertical', p)
        coroutine.yield(s, i, 'vertical', p)
      end
    end
  end)
end

function GameState:getScore()
  return self.collected[1][1] + self.collected[1][2] + self.collected[1][3] -
        (self.collected[2][1] + self.collected[2][2] + self.collected[2][3])
end

function GameState:getWinner()
  --if self.collected[1][1] >= 8 and self.collected[1][2] >= 8 and self.collected[1][3] >= 8 then
  --  return 1
  --end
  --if self.collected[2][1] >= 8 and self.collected[2][2] >= 8 and self.collected[2][3] >= 8 then
  --  return 2
  --end
  if self.collected[1][1] + self.collected[1][2] + self.collected[1][3] >= 15 then
    return 1
  end
  if self.collected[2][1] + self.collected[2][2] + self.collected[2][3] >= 15 then
    return 2
  end
  return nil
end

---@param chocolate ChocolateData
function GameState:cut(chocolate, orientation, p)
  assert(self:has(chocolate))
  local d1, d2 = chocolate:cut(orientation, p)

  if self.onCut then self.onCut(chocolate, orientation, p, d1, d2) end

  if d1:isCollectable() then
    if self.onCollected then self.onCollected(d1) end
    local s = d1:sum()
    for i=1, 3 do self.collected[self.turn][i] = self.collected[self.turn][i] + s[i] end
  else
    self:add(d1)
  end

  if d2:isCollectable() then
    if self.onCollected then self.onCollected(d2) end
    local s = d2:sum()
    for i=1, 3 do self.collected[self.turn][i] = self.collected[self.turn][i] + s[i] end
  else
    self:add(d2)
  end

  local pos
  for i=1, #self.chocolates do
    if self.chocolates[i] == chocolate then pos = i break end
  end
  assert(pos)
  table.remove(self.chocolates, pos)

  self.turn = 3 - self.turn

  return d1, d2
end

return GameState
