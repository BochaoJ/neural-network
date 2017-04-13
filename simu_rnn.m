function [OutputACT, ALLACT] = simu_rnn(net, Input)

% get size of input sequence
[pattSize, pattNum] = size(Input);
if pattSize ~= net.numInputUnits; error ('Number of input units and input patterns do not match.'); end;

% calculate starting and stopping step
firstStep = net.maxDelay+1;
lastStep  = net.maxDelay+pattNum;

% prepare activities (threshod + all input, then initial hidden and output)
ALLACT = zeros(net.numAllUnits, lastStep);
ALLACT(1,:) = 1;
ALLACT(2:net.numInputUnits+1,firstStep:lastStep) = Input;
ALLACT(net.numInputUnits+2:net.numAllUnits, 1:net.maxDelay) = net.actInit;

% copy params (Matlab 13 Acceleration)
% add ending destination to unused value -1
numWeights = net.numWeights;
weightsDest   = [net.weights.dest]; weightsDest(end+1) = -1;
weightsSource = [net.weights.source];
weightsDelay  = [net.weights.delay];
weightsValue  = [net.weights.value];

% forward computation
for SI=(firstStep:lastStep),
    % initial settings
    nextdest = weightsDest(1);
    WI = 1;
    while WI<numWeights,
        % next activity and initial destinantion node  
        act = 0;
        dest=nextdest;
        while dest==nextdest,
            % calculation
            act = act + weightsValue(WI) * ALLACT(weightsSource(WI), SI-weightsDelay(WI)); 
            % get next destination node
            WI = WI+1;
            nextdest = weightsDest(WI);
        end;
        % calculate activity
        ALLACT(dest, SI) = 1 ./ (1+exp(-act));
    end;
end;    

% select output activities
OutputACT = ALLACT(net.indexOutputUnits, firstStep:lastStep);
