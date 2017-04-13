function neto = bptt_start(net, alpha, beta, wsize)


% set epoch persistent parameters 
% (learning and momentum rate, BPTT window size)
net.bptt.alpha = alpha;
net.bptt.beta = beta;
net.bptt.wsize = wsize;

% set weight changes
net.bptt.DLT_W = zeros(1, net.numWeights);

% set persistent activities
net.bptt.saveDelay = net.maxDelay + wsize - 1;
net.bptt.saveAct = zeros(net.numAllUnits, net.bptt.saveDelay);
net.bptt.saveAct(net.numInputUnits+2:net.numAllUnits,end-net.maxDelay+1:end) = net.actInit;

neto = net;


