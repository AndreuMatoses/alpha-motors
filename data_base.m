%% Here you put the data for each propeller tested
% Data Structure

i=0;
in2m = 2.54/100;
g2N  = 1/1000*9.81;

%% Prop. 5 x 4.3 x 3
i = i+1;

data(i).name = 'prop. 5x4.3x3';
data(i).r = 5 * in2m;
data(i).pitch = 4.3 * in2m;
data(i).max_RPS = 28000/60; % rev per second, for throttle 100%. Assumes that RPM is linear with throttle
% in [-100, 100] format
data(i).throttle100 = [-85	-80.2	-75.1	-69.5	-64.7	-60.1	-54.4	-49.8	-40.4	-30.8	-20.1	-10.4	0.8	10.5	20.8	29.6	39.9	49.7	58.8	68.8	78.6	88.6	100];
% W
data(i).power = [3.2	3.2	3.2	3.2	4.1	7.2	11.7	15.9	25.9	39.2	56	76.1	102.6	125.7	147.9	168	200.2	233.6	264.8	307.3	336.6	379.9	392.2];
% from g to Netwons
data(i).thrust_g = [67	80	90	101	115	128	145	160	196	236	288	346	417	482	558	621	709	788	858	928	985	1029 1050]+650;
data(i).thrust = data(i).thrust_g*g2N;

