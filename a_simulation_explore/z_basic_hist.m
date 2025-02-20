
%% visualise the test_data
load ../data/test_data.mat

% as distribution of reaction times
    % this is more useful for the one-sample version...
hold on
histogram(rt(c==1 & choice),'DisplayName','correctly Right')
histogram(rt(c==0 & choice),'DisplayName','incorrectly Right')
histogram(rt(c==1 & ~choice),'DisplayName','correctly Left')
histogram(rt(c==0 & ~choice),'DisplayName','incorrectly Left')
hold off
legend

%% maybe switch to R to do better plots
dataT = table(coh,choice,c,rt);
writetable(dataT,'../data/test_data.csv');
