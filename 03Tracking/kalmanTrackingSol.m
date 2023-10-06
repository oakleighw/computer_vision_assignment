%Contains code for displaying ground truth trajectory, noisy observations trajectory, and computed predicted trajectory from 
%observations. Displays mean error, standard deviation and root mean squared error (command window output).
%Code adapted from Computer Vision Workshop "Tracking 2", School of
%Computer Science, University of Lincoln (2023)
clear;close all;

%read ground truth coordinates
x = readmatrix("x.csv");
y = readmatrix("y.csv");

%read observations
a = readmatrix("a.csv");
b = readmatrix("b.csv");

%plot GT Coords
plot(x, y, 'xb');
hold on;

%plot observations
plot(a, b, '+r');

%concat observation coords
z = [a; b];

%get predictions using kalman filter
[px, py] = kalmanTracking(z);

%plot trajectories graph
plot(px,py,'g');
legend(["Ground Truth", "Observations", "Kalman Predicted"],'Location','southeast');
title("Object Trajectory vs Observed vs Predicted");
xlabel('x');
ylabel('y');
hold off;

obs_errs = []; %observation errors
kal_errs = []; %kalman prediction errors

%%get errors between observations and ground truth coords
%%get errors between predicted and ground truth coords
for i=1:length(x)
    
    %get error (euclidean distance)
    ob_e = sqrt((x(i)-a(i))^2 + (y(i)-b(i))^2);
    k_e = sqrt((x(i)-px(i))^2 + (y(i)-py(i))^2);
    
    kal_errs = [kal_errs; k_e];
    obs_errs = [obs_errs; ob_e];
end

mean_ob = mean(obs_errs); %mean observation error
std_ob = std(obs_errs); %standard deviation obs error
rms_ob = rms(obs_errs); %root mean squared obs error

mean_ke = mean(kal_errs); %kalman mean error
std_ke = std(kal_errs); %standard deviation kal error
rms_ke = rms(kal_errs); %root mean squared kal error



err_type = reshape(["Mean Error", "Standard dev.", "RMSE"],[3,1]);
obs_err = reshape([mean_ob,std_ob,rms_ob],[3,1]);
kal_err = reshape([mean_ke,std_ke,rms_ke],[3,1]);

errorMetrics = table(err_type,obs_err,kal_err);
display(errorMetrics); %show table of errors


function [xp, Pp] = kalmanPredict(x, P, F, Q)
    % Prediction step of Kalman filter.
    % x: state vector
    % P: covariance matrix of x
    % F: matrix of motion model
    % Q: matrix of motion noise
    % Return predicted state vector xp and covariance Pp
    xp = F * x; % predict state
    Pp = F * P * F' + Q; % predict state covariance
end

function [xe, Pe] = kalmanUpdate(x, P, H, R, z)
    % Update step of Kalman filter.
    % x: state vector
    % P: covariance matrix of x
    % H: matrix of observation model
    % R: matrix of observation noise
    % z: observation vector
    % Return estimated state vector xe and covariance Pe
    S = H * P * H' + R; % innovation covariance
    K = P * H' * inv(S); % Kalman gain
    zp = H * x; % predicted observation
    %%%%%%%%% UNCOMMENT FOR VALIDATION GATING %%%%%%%%%%
    gate = (z - zp)' * inv(S) * (z - zp);
    if gate > 1000
    %warning('Observation outside validation gate');
    xe = x;
    Pe = P;
    return
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    xe = x + K * (z - zp); % estimated state
    Pe = P - K * S * K'; % estimated covariance
end


function [px, py] = kalmanTracking(z)
    % Track a target with a Kalman filter
    % z: observation vector
    % Return the estimated state position coordinates (px,py)
    dt = 0.2; % time interval
    N = length(z); % number of samples
    F = [1 dt 0 0; 0 1 0 0; 0 0 1 dt; 0 0 0 1]; % CV motion model
    Q = [0.016 0 0 0; 0 0.36 0 0; 0 0 0.016 0; 0 0 0 0.36]; % motion noise
    H = [1 0 0 0; 0 0 1 0]; % Cartesian observation model
    R = [0.25 0; 0 0.25]; % observation noise
    x = [0 0 0 0]'; % initial state
    P = Q; % initial state covariance
    s = zeros(4,N);
        for i = 1 : N
         [xp, Pp] = kalmanPredict(x, P, F, Q);
         [x, P] = kalmanUpdate(xp, Pp, H, R, z(:,i));
         s(:,i) = x; % save current state
        end
    px = s(1,:); % NOTE: s(2, :) and s(4, :), not considered here,
    py = s(3,:); % contain the velocities on x and y respectively
end

