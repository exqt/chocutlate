require 'global'
local ser = require 'lib.bitser'
local ChocolateData = require 'src.core.chocolate-data'
local GameState = require 'src.core.game-state'

explorerd = 0
-- Simple All Search
---@param state GameState
local function MinMax(state, depth)
  explorerd = explorerd + 1
  if depth == 0 then return state:getScore(), {} end
  local winner = state:getWinner()
  if winner then return state:getScore(), {} end

  local action = {}
  if state.turn == 1 then
    local value = -100000
    for s, idx, orientation, pos in state:getAllNextStates() do
      local score = MinMax(s, depth-1)
      if score > value then
        value = score
        action = {idx, orientation, pos}
      end
    end
    return value, action
  else
    local value = 100000
    for s, idx, orientation, pos in state:getAllNextStates() do
      local score = MinMax(s, depth-1)
      if score < value then
        value = score
        action = {idx, orientation, pos}
      end
    end
    return value, action
  end
end

local bstate, depth = ...
local state = ser.loads(bstate)
local score, action = MinMax(state, depth)
love.thread.getChannel("ai"):push(action)
