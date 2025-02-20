function param_sweep_analytic_DDM(theta_default,coh,par2sweep,vals2try)

% theta_default: struct with all free params as fields
% par2sweep: the name of parameter to sweep, in string
% vals2try: the values to sweep through

% oh okay I may misnamed this (not sweep across space, just try values)

% 
n_pred = size(unique(coh),1);
n_val = length(vals2try);

p_choice_pred = nan(n_pred,n_val);
mean_rt_pred = nan(n_pred,n_val);

theta = theta_default;

% loop through that parameter
P_save = cell(n_val,1);
for i = 1:n_val
    theta.(par2sweep) = vals2try(i);
    [p_choice_pred(:,i),mean_rt_pred(:,i),P_save{i}] = pred_analytic_DDM(theta,coh);
end

figure;
subplot(2,1,1);
ucoh = unique(coh);
plot(ucoh,p_choice_pred); %P.lo.p is 1-P.up.p for the basic model
xlim([min(ucoh),max(ucoh)]);
xlabel('Motion coherence');
ylabel('P rightward choice')
legend(arrayfun(@(k) sprintf('%s = %.3f', par2sweep, k), vals2try, 'UniformOutput', false));
subplot(2,1,2)
plot(ucoh,mean_rt_pred)
xlim([min(ucoh),max(ucoh)]);
xlabel('Motion coherence');
ylabel('rt (s)')
%legend(arrayfun(@(k) sprintf('%s = %.3f', par2sweep, k), vals2try, 'UniformOutput', false));
    
% printing out the default parameters on title
par_names = fieldnames(theta);%get parameter names
par_names(strcmp(par_names,par2sweep))=[];%remove the param in hue
value_labels = cellfun(@(k) sprintf('%s = %.3g', k,theta.(k)), par_names, 'UniformOutput', false);
sgtitle(strjoin(value_labels, ', '),'interpreter','none')



end