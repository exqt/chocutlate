require 'global'
local ser = require 'lib.binser'
local ChocolateData = require 'src.core.chocolate-data'
local GameState = require 'src.core.game-state'

local INF = 1000000
local explorerd = 0

---@param state GameState
local function MinMax(state, depth)
  explorerd = explorerd + 1
  if depth == 0 then return state:getScore(), {} end
  local winner = state:getWinner()
  if winner then return state:getScore(), {} end

  local action = {}
  if state.turn == 1 then
    local value = -INF
    for s, idx, orientation, pos in state:getAllNextStates() do
      local score = MinMax(s, depth-1)
      if score > value then
        value = score
        action = {idx, orientation, pos}
      end
    end
    return value, action
  else
    local value = INF
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

---@param state GameState
local function AlphaBeta(state, depth, alpha, beta)
  explorerd = explorerd + 1
  if depth == 0 then return state:getScore(), {} end
  local winner = state:getWinner()
  if winner then return state:getScore(), {} end

  local action = {}
  if state.turn == 1 then
    local value = -INF
    for s, idx, orientation, pos in state:getAllNextStates() do
      local score = AlphaBeta(s, depth-1, alpha, beta)
      if score > value then
        value = score
        action = {idx, orientation, pos}
      end
      alpha = math.max(alpha, value)
      if alpha >= beta then break end
    end
    return value, action
  else
    local value = INF
    for s, idx, orientation, pos in state:getAllNextStates() do
      local score = AlphaBeta(s, depth-1, alpha, beta)
      if score < value then
        value = score
        action = {idx, orientation, pos}
      end
      beta = math.min(beta, value)
      if beta <= alpha then break end
    end
    return value, action
  end
end

local bstate, depth = ...
local results = ser.deserialize(bstate)
local state = results[1]
--local score, action = MinMax(state, depth)
local score, action = AlphaBeta(state, depth, -INF, INF)
love.thread.getChannel("ai"):push(action)
