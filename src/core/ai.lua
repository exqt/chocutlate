local AI = Class("AI")

function AI:initialize(depth)
  self.depth = depth
  self.thread = love.thread.newThread("src/core/ai-thread.lua")
end

function AI:run(state)
  local state = state:clone()
  local ser = require 'lib.bitser'
  local b = ser.dumps(state)
  self.thread:start(b, self.depth)
end

function AI:getCount()
  return love.thread.getChannel("ai"):getCount()
end

function AI:getResult()
  return love.thread.getChannel("ai"):pop()
end

return AI
