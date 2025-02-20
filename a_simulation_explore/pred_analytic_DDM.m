function [p_choice_pred,mean_rt_pred,P] = pred_analytic_DDM(theta,coh)

% my own wrapper function for predictions of the analytic DDM 
% given task & parameter

% theta: free parameters; a struct

% coh: the task

% output: putatively, column vectors
    % mean_rt_pred: equivalent to rt_model_c in wrapper_analytic_DDM, I hope...

%% free parameters from wrapper_
% theta.kappa  = theta(1);
% theta.ndt_m  = theta(2); %
% %ndt_s  = theta(3); % may be needed for the likelihood function??
% theta.B0     = theta(4);
% theta.coh0   = theta(5); % very interesting... this one shifts peak-rt too, while y0a goes incorrect?
% theta.y0a    = theta(6); % 
% %theta.ndt_mu_delta = theta(7); % uh what?

%% transformations done in wrapper_analytic_DDM
Bup = theta.B0; %decision boundary
yp = theta.y0a/theta.B0; % value of DV at t=0 (scalar) as a poprtion of Bup [i.e, -1 to +1]
drift = theta.kappa * unique(coh + theta.coh0); % get drift rate for each condition

%% other settings
dt = 0.005; %unit dt 
t  = 0:dt:10; %go up from 0 to... upper time limit?
t = t(:); 

P  = analytic_DDM(drift,t,Bup,yp); %this is the standard model
%mean_rt_pred = P.up.mean_t + theta.ndt_m; %prediction about RT %nope %forgot correct vs incorrect trials

%prediction about RT
ucoh = unique(coh);
mean_rt_pred = P.up.mean_t;
mean_rt_pred(ucoh<0) = P.lo.mean_t(ucoh<0);
mean_rt_pred(ucoh==0) = (P.up.mean_t(ucoh==0)+P.lo.mean_t(ucoh==0))/2;
mean_rt_pred = mean_rt_pred + theta.ndt_m;

p_choice_pred = P.up.p; %prediction about choice probability

end