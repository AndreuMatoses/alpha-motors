% Dynamic thrust approximation for Alpha, using a static thrust test
% by Andreu Matoses Gimenez, andreumg@kth.se
% Mthod used based on https://www.flitetest.com/articles/propeller-static-dynamic-thrust-calculation
% for more details, check the thrust_approx.pdf document

clear all;

run data_base.m

%% calculate params

hg = 15*1000; % geometric altitude
R_earth = 6.3781E6; % m
h = R_earth*hg./(R_earth+hg);

[~, ~, P, rho] = atmosisa(h);
[~, ~, P0, rho0] = atmosisa(0);

Vac = [0:1:80]'; % airspeed range, m/s

for i = 1:length(data)
    
    data(i).A =pi*data(i).r^2; %m^2
    data(i).eff = data(i).thrust_g./data(i).power; %[g/W], efficiency
    data(i).throttle = (data(i).throttle100+100)/200; % normalize throttle
    data(i).k2 = 1.5; % experimental correction factor exponent
    
    data(i).Ve = data(i).throttle * data(i).max_RPS * data(i).pitch; % ideal induced flow speed due to porpeller
    
    data(i).k1 = (data(i).thrust ./(rho0 * data(i).A * data(i).Ve.^2)).^(1/data(i).k2) * (data(i).pitch/(2*data(i).r));
    data(i).correction = (data(i).k1*2*data(i).r./data(i).pitch).^data(i).k2;
    
    T_dyn = zeros(length(Vac),length(data(i).throttle));
    % approximated formula
    for j = 1:length(data(i).throttle)
        T_dyn(:,j) = rho * data(i).A * (data(i).Ve(j).^2 - data(i).Ve(j)*Vac) * data(i).correction(j);
    end
    
    data(i).T_dyn = T_dyn;
    
    
end

%% plot results, only thruts of motor
prop_i = 1; % which prop of the data set to plot

figure;
plot(Vac,data(i).T_dyn*(1/g2N))
xlabel('Aircraft speed m/s')
ylabel('dynamic thrust, g')
grid on
title([data(i).name '. Motor Dynamic Thrust at h = ' num2str(hg) ' m'])
% title(['Motor Dynamic Thrust at h = ' num2str(hg) ' m'])
ylim([0,inf])

figure;
plot(data(i).throttle100,data(i).eff,'b')
title('Power to thrust eficiency')
xlabel('Throttle, -100 to 100 format')
ylabel('Thrust per unit power [g/W]')
grid on;

%% Plot aircraft performance predicions
% V3.3T
n_motors = 4;
CD =  0.0314;
S_wing = 1.2; %m^2
D = 0.5* rho * CD * S_wing * Vac.^2;

[max_throttle,max_throttle_idx] = max(data(i).throttle);
prediction_err = 1.5; % tends to underpredict 0 thrust point by 50%.

figure;
T_max = data(i).T_dyn(:,max_throttle_idx)* n_motors; % assuming last entry is for max throttle
plot(Vac,T_max,'b')
hold on;
plot(Vac*prediction_err,T_max,'b--')
plot(Vac, D ,'r')
xlabel('Aircraft speed m/s')
ylabel('Total Force, N')
legend('Aircraft Dyn. Thrust',['+' num2str(-(1-prediction_err)*100) '% error'],'Form drag \propto V^2 ')
grid on
% title([data(i).name '. Thrust (max) vs Drag at h = ' num2str(hg) ' m, ' num2str(n_motors) ' propellers.' ])
title(['Thrust (max) vs Drag at h = ' num2str(hg) ' m, ' num2str(n_motors) ' propellers.' ])
ylim([0,max(T_max)*1.1])


fprintf('Zero thrust speed at max throttle = %g +- %g m/s. \n',data(i).Ve(max_throttle_idx), data(i).Ve(max_throttle_idx)*(prediction_err-1))

