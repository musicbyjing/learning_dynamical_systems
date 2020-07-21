function [] = plot_performance()

file = fullfile(pwd, 'learning_dynamical_systems', 'data_files', 'graph_data.mat');
load(file, 'obj');

obj = obj.'
obj = sortrows(obj)
obj = obj.' % sort matrix such that dataset size is in ascending order

X = obj(1,:);
Y1 = obj(2,:); % error
Y2 = obj(3,:); % computation time

figure
subplot(1,2,1)
plot(X, Y1, 'r-o')
title('Dataset size vs. error')
xlabel('Dataset size')
ylabel('Error')

subplot(1,2,2)
plot(X, Y2, 'b-o')
title('Dataset size vs. computation time')
xlabel('Dataset size')
ylabel('computation time')

end