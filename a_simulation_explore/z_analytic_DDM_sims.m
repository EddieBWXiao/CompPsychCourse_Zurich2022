%function P = z_analytic_DDM_sims
addpath(genpath('../functions_addtopath'))
load ../data/test_data.mat
%contains coh

%% visualise single fit
dt = 0.005; %unit dt 
t  = 0:dt:10; %go up from 0 to... upper time limit?
t = t(:); 

% free parameters from wrapper_
kappa = 15; % drift rate (without scaling over conditions)
ndt_m = 0.2; %mean of non-decision time
ndt_s = 0; %standard deviation of non-decision times
B0 = 1.2; %bound height
coh0  = 0; % bias (offset to the motion coherence)
y0a = 0; % bias in starting point (before scaling to Bup??)

% transformations done in wrapper_analytic_DDM
Bup = B0; %decision boundary
yp = y0a/B0; % value of DV at t=0 (scalar) as a poprtion of Bup [i.e, -1 to +1]
drift = kappa * unique(coh + coh0); % get drift rate for each condition

P  = analytic_DDM(drift,t,Bup,yp); %this is the standard model
%mean_rt_pred = P.up.mean_t + ndt_m; %prediction about RT
    %NOPE WAIT THERE IS A CAVEAT... for correct vs incorrect trials
ucoh = unique(coh);
mean_rt_pred = P.up.mean_t;
mean_rt_pred(ucoh<0) = P.lo.mean_t(ucoh<0);
mean_rt_pred(ucoh==0) = (P.up.mean_t(ucoh==0)+P.lo.mean_t(ucoh==0))/2;
mean_rt_pred = mean_rt_pred + ndt_m;
    %IMPORTANT: if I don't add this step, the incorrect trials will...
    % ... be mixed into the correct ones,
    % so when I change y0a, the RT will go up & down

p_choice_pred = P.up.p; %prediction about choice probability

%plot!
subplot(2,1,1);
ucoh = unique(coh);
plot(ucoh,p_choice_pred,'k-'); %P.lo.p is 1-P.up.p for the basic model
xlim([min(ucoh),max(ucoh)]);
xlabel('Motion coherence');
ylabel('P rightward choice')

subplot(2,1,2)
plot(ucoh,mean_rt_pred)
xlim([min(ucoh),max(ucoh)]);
xlabel('Motion coherence');
ylabel('rt (no ndt yet)')

sgtitle('check analytic_DDM','interpreter','none')
    
%end

%% parameter sweep: test on kappa
theta_default.kappa = 10; % drift rate (without scaling over conditions)
theta_default.ndt_m = 0.2; %mean of non-decision time
theta_default.ndt_s = 0; %standard deviation of non-decision times
theta_default.B0 = 1.2; %bound height
theta_default.coh0  = 0; % bias (offset to the motion coherence),
theta_default.y0a = 0; % bias in starting point (before scaling to Bup??)

% for kappa
kappa_range = [3,7,10,15];
n_pred = size(unique(coh),1);
n_val = length(kappa_range);
p_choice_pred = nan(n_pred,n_val);
mean_rt_pred = nan(n_pred,n_val);
theta = theta_default;
for i = 1:n_val
    theta.kappa = kappa_range(i);
    [p_choice_pred(:,i),mean_rt_pred(:,i)] = pred_analytic_DDM(theta,coh);
end

subplot(2,1,1);
ucoh = unique(coh);
plot(ucoh,p_choice_pred); %P.lo.p is 1-P.up.p for the basic model
xlim([min(ucoh),max(ucoh)]);
xlabel('Motion coherence');
ylabel('P rightward choice')
legend(arrayfun(@(k) sprintf('kappa = %d', k), kappa_range, 'UniformOutput', false));
subplot(2,1,2)
plot(ucoh,mean_rt_pred)
xlim([min(ucoh),max(ucoh)]);
xlabel('Motion coherence');
ylabel('rt (s)')
legend(arrayfun(@(k) sprintf('kappa = %d', k), kappa_range, 'UniformOutput', false));


%% parameter sweep: for the parameters
param_sweep_analytic_DDM(theta_default,coh,'kappa',[3,7,10,15])
param_sweep_analytic_DDM(theta_default,coh,'ndt_m',[0.1,0.2,0.3,0.4])
param_sweep_analytic_DDM(theta_default,coh,'B0',[0.75,1,1.2,1.5])
param_sweep_analytic_DDM(theta_default,coh,'y0a',[-0.1,0,0.1,0.4])
param_sweep_analytic_DDM(theta_default,coh,'coh0',[-0.1,0,0.05,0.1])
