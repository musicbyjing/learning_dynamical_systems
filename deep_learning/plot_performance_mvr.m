function [] = plot_performance_mvr()

file = fullfile(pwd, 'learning_dynamical_systems', 'data_files', 'graph_data.mat');
load(file, 'graph_data');

graph_data = graph_data.';
graph_data = sortrows(graph_data);
graph_data = graph_data.'; % sort matrix such that dataset size is in ascending order

% For reference: graph_data = 
% [dataset_size; rmse_test; edot_test; mean(dtwd_test); std(dtwd_test);
% rmse_train; edot_train; mean(dtwd_train); std(dtwd_train)]

X = graph_data(1,:);
rmse = graph_data(2,:);
edot = graph_data(3,:);

figure
sgtitle('mvr')

subplot(2,1,1)
plot(X, rmse, 'Color', '#0072BD', 'Marker', 'o')
hold on;
title('Dataset size vs. RMSE')
xlabel('Dataset size')
ylabel('RMSE')

subplot(2,1,2)
plot(X, edot, 'Color', '#D95319', 'Marker', 'o')
title('Dataset size vs. e dot')
xlabel('Dataset size')
ylabel('e dot')

end