function [] = plot_performance()

file = fullfile(pwd, 'learning_dynamical_systems', 'data_files', 'graph_data2.mat');
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
subplot(2,2,1)
plot(X, rmse_test, 'Color', '#0072BD', 'Marker', 'o')
hold on;
plot(X, rmse_train, 'Color', '#7E2F8E', 'Marker', 's')
legend('test', 'train')
title('Dataset size vs. RMSE')
xlabel('Dataset size')
ylabel('RMSE')

subplot(2,2,2)
plot(X, edot_test, 'Color', '#D95319', 'Marker', 'o')
hold on;
plot(X, edot_train, 'Color', '#77AC30', 'Marker', 's')
legend('test', 'train')
title('Dataset size vs. e dot')
xlabel('Dataset size')
ylabel('e dot')

subplot(2,2,3)
errorbar(X, mean_dtwd_test, std_dtwd_test, 'Color', '#EDB120', 'Marker', 'o')
hold on;
errorbar(X, mean_dtwd_train, std_dtwd_train, 'Color', '#4DBEEE', 'Marker', 's')
legend('test', 'train')
title('Dataset size vs. mean DTWD')
xlabel('Dataset size')
ylabel('Mean DTWD')

end