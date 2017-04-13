function net = new_rnn(InputC, HiddenC, OutputC)

AUC = 1+InputC+HiddenC+OutputC;

% set numbers of units
net.numInputUnits    = InputC;
net.numOutputUnits   = OutputC;
net.numAllUnits      = AUC;

% set neuron masks
net.maskInputUnits   = [0; ones(InputC, 1); zeros(AUC-1-InputC, 1)];
net.maskOutputUnits  = [zeros(AUC-OutputC, 1); ones(OutputC, 1)];
net.indexOutputUnits = find(net.maskOutputUnits);
net.indexInputUnits  = find(net.maskInputUnits);

% set input weights
weight = struct('dest',0,'source',0,'delay',0,'value',0,'const',false,'act',1,'wtype',1);

n=1;
% all neurons weights
for i=(InputC+2:AUC),
    % threshold and input weights
    for j=(1:InputC+1),
        net.weights(n) = weight;
        net.weights(n).dest   = i;
        net.weights(n).source = j;
        n = n+1;
    end;
    % recurrent weights
    for j=(InputC+2:AUC),
        net.weights(n) = weight;
        net.weights(n).dest   = i;
        net.weights(n).source = j;
        net.weights(n).delay  = 1;
        n = n+1;
    end;
end;

% output weights
for i=(AUC-OutputC+1:AUC),
    for j=[InputC+2:AUC-OutputC],
        net.weights(n) = weight;
        net.weights(n).dest   = i;
        net.weights(n).source = j;
        n = n+1;
    end;
end;

% set number of weights
net.numWeights = n-1;

% initialize weight matrices form [-0.25, 0.25]
W_INIT_RNG = 0.5;
for i=(1:net.numWeights),
    net.weights(i).value = rand .* 2 .* W_INIT_RNG - W_INIT_RNG;
end;

% initialize starting activities from [0, 1]
net.maxDelay = max([net.weights.delay]);

net.actInit = rand(AUC-InputC-1, net.maxDelay);

