function [] = plot_performance()

file = fullfile(pwd, 'learning_dynamical_systems', 'data_files', 'graph_data.mat');
load(file, 'graph_data');

graph_data = graph_data.';
graph_data = sortrows(graph_data);
graph_data = graph_data.'; % sort matrix such that dataset size is in ascending order

% For reference: graph_data = 
% [dataset_size; rmse_test; edot_test; mean(dtwd_test); std(dtwd_test);
% rmse_train; edot_train; mean(dtwd_train); std(dtwd_train)]

X = graph_data(1,:);
rmse_test = graph_data(2,:);
edot_test = graph_data(3,:);
mean_dtwd_test = graph_data(4,:);
std_dtwd_test = graph_data(5,:);
rmse_train = graph_data(6,:);
edot_train = graph_data(7,:);
mean_dtwd_train = graph_data(8,:);
std_dtwd_train = graph_data(9,:);

figure
subplot(2,3,1)
plot(X, rmse_test, 'Color', '#0072BD', 'Marker', 'o')
title('Dataset size vs. RMSE, test set')
xlabel('Dataset size')
ylabel('RMSE for test set')

subplot(2,3,2)
plot(X, edot_test, 'Color', '#D95319', 'Marker', 'o')
title('Dataset size vs. e dot, test set')
xlabel('Dataset size')
ylabel('e dot for test set')

subplot(2,3,3)
errorbar(X, mean_dtwd_test, std_dtwd_test, 'Color', '#EDB120', 'Marker', 'o')
title('Dataset size vs. mean DTWD, test set')
xlabel('Dataset size')
ylabel('Mean DTWD for test set')

subplot(2,3,4)
plot(X, rmse_train, 'Color', '#7E2F8E', 'Marker', 'o')
title('Dataset size vs. RMSE, training set')
xlabel('Dataset size')
ylabel('RMSE for training set')

subplot(2,3,5)
plot(X, edot_train, 'Color', '#77AC30', 'Marker', 'o')
title('Dataset size vs. e dot, training set')
xlabel('Dataset size')
ylabel('e dot for training set')

subplot(2,3,6)
errorbar(X, mean_dtwd_train, std_dtwd_train, 'Color', '#4DBEEE', 'Marker', 'o')
title('Dataset size vs. mean DTWD, training set')
xlabel('Dataset size')
ylabel('Mean DTWD for training set')


end