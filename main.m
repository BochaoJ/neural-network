N = 64;
%% triangle wave
np=64;
T=500;
t=linspace(0,T-1/np,T*np);
x = sawtooth(2*pi*t,0.5);
%% Sine wave:                 
np=32;
T=1000;
t=linspace(0,T-1/np,T*np);
y = sin(2*pi*t);
plot(x,y);
title('y vs. x')
xlabel('x')
ylabel('y')
saveas(gcf,'xy','jpg');
%% simulate rnn
net = new_rnn(2,15,2);
net = bptt_start(net, 0.1, 0.0, 1);
IP=[x' y']';
[Target, ACT] = simu_rnn(net, IP);

%% a)
%% perform bptt training and error calculation
neti = new_rnn(2,15,2);
neti = bptt_start(neti, 0.1, 0.0, 1);
[neto, AO, AR] = bptt_train(neti, IP, Target, 0);
mse1 = zeros(1,50);
for i=1:50
mse1(i) = MSE_cal(AO(1:2,10*N*(i-1)+1:10*N*i), Target(1:2,10*N*(i-1)+1:10*N*i));
end;
plot(1:50,mse1);
title('MSE vs. Trajectories')
xlabel('Trajectories*10')
ylabel('MSE during each 10 trajectories')
saveas(gcf,'MSE_a2','jpg');

% total mse for 500 tarjectories 
MSE_a = MSE_cal(AO(1:2,1:500*N), Target(1:2,1:500*N));
%% choose number of Hidden PEs
MSE_m = zeros(1,100);
for m=1:100
neti = new_rnn(2,m,2);
neti = bptt_start(neti, 0.1, 0.0, 1);
[neto, AO, AR] = bptt_train(neti, IP, Target, 0);
MSE_m(m) = MSE_cal(AO(1:2,1:500*N), Target(1:2,1:500*N));
end;
plot(1:100,MSE_m);
title('MSE vs. Number of PEs in Hidden layer')
xlabel('Number of PEs')
ylabel('MSE')
saveas(gcf,'MSE_PE','jpg');
%% b)
IP100 = IP(1:2,1:100*N);
Target100 = Target(1:2,1:100*N);
neti2 = new_rnn(2,15,2);
neti2 = bptt_start(neti2, 0.1, 0.0, 1);
[neto2, AO2, AR2] = bptt_train(neti2, IP100, Target100, 0);
IP400 = IP(1:2,100*N+1:500*N);
Target400 = Target(1:2,99*N+1:499*N);
[neto3, AO3, AR3] = bptt_train(neto2, IP400, Target400, 0);
AO_d = [AO2 AO3];

mse2 = zeros(1,50);
for i=1:50
mse2(i) = MSE_cal(AO_d(1:2,10*N*(i-1)+1:10*N*i), Target(1:2,10*N*(i-1)+1:10*N*i));
end;
% plot(1:50,mse2);
% title('MSE vs. Trajectories')
% xlabel('Trajectories*10')
% ylabel('MSE during each 10 trajectories')
% saveas(gcf,'MSE_b','jpg');

% total mse for 500 tarjectories 
MSE_b = MSE_cal(AO_d(1:2,1:500*N), Target(1:2,1:500*N));

plot(1:50,mse1,'r',1:50,mse2,'b');
title('MSE vs. Trajectories')
xlabel('Trajectories*10')
ylabel('MSE during each 10 trajectories')
legend('Method (a)','Method (b)','Location','NorthEast');
saveas(gcf,'MSE_ab','jpg');
%% halve the period of sine wave 
%% Sine wave:                 
np=32;
T=1000;
t=linspace(0,T-1/np,T*np);
y2 = sin(4*pi*t);
plot(x,y2)
title('y vs. x')
xlabel('x')
ylabel('y')
saveas(gcf,'xy2','jpg');
%% do a) and b)
%% simulate rnn
net = new_rnn(2,15,2);
net = bptt_start(net, 0.1, 0.0, 1);
IP=[x' y2']';
[Target, ACT] = simu_rnn(net, IP);

%% a)
%% perform bptt training and error calculation
neti = new_rnn(2,15,2);
neti = bptt_start(neti, 0.1, 0.0, 1);
[neto, AO, AR] = bptt_train(neti, IP, Target, 0);
mse1 = zeros(1,50);
for i=1:50
mse1(i) = MSE_cal(AO(1:2,10*N*(i-1)+1:10*N*i), Target(1:2,10*N*(i-1)+1:10*N*i));
end;
plot(1:50,mse1);
title('MSE vs. Trajectories')
xlabel('Trajectories*10')
ylabel('MSE during each 10 trajectories')
saveas(gcf,'MSE_a2','jpg');

% total mse for 500 tarjectories 
MSE_a = MSE_cal(AO(1:2,1:500*N), Target(1:2,1:500*N));

IP100 = IP(1:2,1:100*N);
Target100 = Target(1:2,1:100*N);
neti2 = new_rnn(2,15,2);
neti2 = bptt_start(neti2, 0.1, 0.0, 1);
[neto2, AO2, AR2] = bptt_train(neti2, IP100, Target100, 0);
IP400 = IP(1:2,100*N+1:500*N);
Target400 = Target(1:2,99*N+1:499*N);
[neto3, AO3, AR3] = bptt_train(neto2, IP400, Target400, 0);
AO_d = [AO2 AO3];


mse2 = zeros(1,50);
for i=1:50
mse2(i) = MSE_cal(AO_d(1:2,10*N*(i-1)+1:10*N*i), Target(1:2,10*N*(i-1)+1:10*N*i));
end;
% plot(1:50,mse2);
% title('MSE vs. Trajectories')
% xlabel('Trajectories*10')
% ylabel('MSE during each 10 trajectories')
% saveas(gcf,'MSE_b2','jpg');

% total mse for 500 tarjectories 
MSE_b = MSE_cal(AO_d(1:2,1:500*N), Target(1:2,1:500*N));

plot(1:50,mse1,'r',1:50,mse2,'b');
title('MSE vs. Trajectories')
xlabel('Trajectories*10')
ylabel('MSE during each 10 trajectories')
legend('Method (a)','Method (b)','Location','NorthEast');
saveas(gcf,'MSE_ab2','jpg');



