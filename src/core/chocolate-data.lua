---@class ChocolateData
local ChocolateData = Class('ChocolateData')

function ChocolateData:initialize(pieces, pr, pc, qr, qc)
  if pieces then
    self.pieces = pieces
    self.pr, self.pc = pr, pc
    self.qr, self.qc = qr, qc
  else
    self.pieces = {}
    self.pr, self.pc = 1, 1
    self.qr, self.qc = 5, 6
    local r, c = self:getDimensions()

    assert(r*c % 6 == 0)

    local pool = {}
    for t=1, 3 do
      for i=1, r*c/3 do table.insert(pool, t) end
    end

    math.randomseed(os.clock())
    for i=2, #pool do
      local j = math.random(1, i)
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
end

function ChocolateData:clone()
  return ChocolateData(self.pieces, self.pr, self.pc, self.qr, self.qc)
end

function ChocolateData:__tostring()
  local ret = ""
  local r, c = self:getDimensions()
  for i=1, r do
    for j=1, c do
      ret = ret .. tostring(self:get(i, j))
    end
    ret = ret .. "\n"
  end
  return ret
end

function ChocolateData:get(r, c)
  return self.pieces[self.pr+r-1][self.pc+c-1]
end

function ChocolateData:sum()
  local ret = {0, 0, 0}
  local r, c = self:getDimensions()
  for i=1, r do
    for j=1, c do
      local t = self:get(i, j)
      ret[t] = ret[t] + 1
    end
  end
  return ret
end

function ChocolateData:cut(orientation, p)
  local r, c = self:getDimensions()
  if orientation == 'horizonal' then
    assert(1 <= p and p < r)
    return
      ChocolateData(self.pieces, self.pr    , self.pc, self.pr + p - 1, self.qc),
      ChocolateData(self.pieces, self.pr + p, self.pc, self.qr        , self.qc)

  elseif orientation == 'vertical' then
    assert(1 <= p and p < c)
    return
      ChocolateData(self.pieces, self.pr, self.pc    , self.qr, self.pc + p - 1),
      ChocolateData(self.pieces, self.pr, self.pc + p, self.qr, self.qc        )
  end
end

function ChocolateData:isCollectable()
  local s = self:sum()
  return s[1] <= 1 and s[2] <= 1 and s[3] <= 1
end

function ChocolateData:getDimensions()
  return self.qr-self.pr+1, self.qc-self.pc+1
end

return ChocolateData
