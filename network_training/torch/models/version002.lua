require 'torch'
require 'nn'

if opt.type == 'cuda' then
   require 'cunn'
end

----------------------------------------------------------------------
print(sys.COLORS.red ..  '==> construct CNN')

-- This gets around 68.8% on test starting around epoc 37
--                  87.2% on training
--
-- qlua run.lua -r 0.1 -w 1e-4 -threads 2 -l version002 -s full

local CNN = nn.Sequential()
CNN:add(nn.SpatialConvolution(3, 32, 3, 3, 1, 1, 1, 1))
CNN:add(nn.SpatialBatchNormalization(32))
CNN:add(nn.SpatialDropout(0.2))
CNN:add(nn.ReLU())

CNN:add(nn.SpatialConvolution(32, 64, 3, 3, 1, 1, 1, 1))
CNN:add(nn.SpatialBatchNormalization(64))
CNN:add(nn.SpatialDropout(0.2))
CNN:add(nn.ReLU())

CNN:add(nn.SpatialMaxPooling(2,2,2,2))

CNN:add(nn.SpatialConvolution(64, 64, 3, 3, 1, 1, 1, 1))
CNN:add(nn.SpatialBatchNormalization(64))
CNN:add(nn.SpatialDropout(0.2))
CNN:add(nn.ReLU())

CNN:add(nn.SpatialMaxPooling(2,2,2,2))

CNN:add(nn.SpatialConvolution(64, 64, 3, 3, 1, 1, 1, 1))
CNN:add(nn.SpatialBatchNormalization(64))
CNN:add(nn.SpatialDropout(0.25))
CNN:add(nn.ReLU())

CNN:add(nn.View(64*8*8))

local classifier = nn.Sequential()
classifier:add(nn.Linear(64*8*8, 500))
classifier:add(nn.BatchNormalization(500))
classifier:add(nn.ReLU())
classifier:add(nn.Dropout(0.5))
classifier:add(nn.Linear(500, 10))
classifier:add(nn.LogSoftMax())


local model = nn.Sequential()
model:add(CNN)
model:add(classifier)

-- Loss: NLL
local loss = nn.ClassNLLCriterion()


----------------------------------------------------------------------
print(sys.COLORS.red ..  '==> here is the CNN:')
print(model)

if opt.type == 'cuda' then
   model:cuda()
   loss:cuda()
end

-- return package:
return {
   model = model,
   loss = loss,
}

