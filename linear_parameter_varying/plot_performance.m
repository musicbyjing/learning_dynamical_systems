% Author: Jing Liu
% Supervisor: Prof. Hsiu-Chin Lin, Summer 2020
% Affiliation: McGill University

% This function plots errors as a function of dataset size

function [] = plot_performance()

    suptitle = 'LPV-DS, Varying Dataset Size: LASA 8';

    og_file = 'graph_data_8.mat';
    learned_file = 'graph_data_8from7.mat';

    %% Load original and learned data and sort by ascending dataset size
    file = fullfile(pwd, 'learning_dynamical_systems', 'data_files', og_file);
    temp = load(file, 'graph_data');
    graph_data1 = temp.graph_data;

    file = fullfile(pwd, 'learning_dynamical_systems', 'data_files', learned_file);
    temp = load(file, 'graph_data');
    graph_data2 = temp.graph_data;

    % There's probably a better way to write the below lines, but I need to
    % finish my report first.
    graph_data1 = graph_data1.';
    graph_data1 = sortrows(graph_data1);
    graph_data1 = graph_data1.'; % sort matrix such that dataset size is in ascending order

    graph_data2 = graph_data2.';
    graph_data2 = sortrows(graph_data2);
    graph_data2 = graph_data2.'; % sort matrix such that dataset size is in ascending order

    % For reference: graph_data = 
    % [model_number; dataset_size; rmse_test; edot_test; mean(dtwd_test); std(dtwd_test); ...
    %       rmse; edot; mean(dtwd); std(dtwd); time; length(ds_gmm.Priors)]

    n1 = graph_data1(1,:)';
    X1 = graph_data1(2,:)';
    rmse_test1 = graph_data1(3,:)';
    edot_test1 = graph_data1(4,:)';
    mean_dtwd_test1 = graph_data1(5,:)';
    std_dtwd_test1 = graph_data1(6,:)';
    rmse_train1 = graph_data1(7,:)';
    edot_train1 = graph_data1(8,:)';
    mean_dtwd_train1 = graph_data1(9,:)';
    std_dtwd_train1 = graph_data1(10,:)';
    
    n2 = graph_data2(1,:)';
    X2 = graph_data2(2,:)';
    rmse_test2 = graph_data2(3,:)';
    edot_test2 = graph_data2(4,:)';
    mean_dtwd_test2 = graph_data2(5,:)';
    std_dtwd_test2 = graph_data2(6,:)';
    rmse_train2 = graph_data2(7,:)';
    edot_train2 = graph_data2(8,:)';
    mean_dtwd_train2 = graph_data2(9,:)';
    std_dtwd_train2 = graph_data2(10,:)';

    %% Linear regression function
    function [] = linear_regression(X, Y, color)
        X_ = [ones(length(X),1) X];
        b = X_\Y;
        plot(X, X_*b, 'Color', color, 'LineWidth', 3)
%         text(0.1, 0.9, sprintf('y = %.2dx + %2.d', b(1), b(2)), 'Units','Normalized');
        Rsq = 1 - sum((Y - X_*b).^2)/sum((Y - mean(Y)).^2);
%         text(0.1, 0.8, sprintf('R^2: %.2d',Rsq), 'Units','Normalized');
    end

    %% Draw plots 
    figure
    sgtitle(suptitle)
    
    subplot(2,2,1)
    plot(X1, rmse_test1, 'Color', '#0072BD', 'Marker', 'o'); hold on;
    linear_regression(X1, rmse_test1, '#0072BD')
    plot(X2, rmse_test2, 'Color', '#D95319', 'Marker', 'o')
    linear_regression(X2, rmse_test2, '#D95319')
    f=get(gca,'Children');
    legend([f(2),f(4)],'Saved params','No saved params')
    title('Dataset Size vs. RMSE')
    xlabel('Dataset Size')
    ylabel('RMSE')

    subplot(2,2,2)
    plot(X1, edot_test1, 'Color', '#0072BD', 'Marker', 'o'); hold on;
    linear_regression(X1, edot_test1, '#0072BD')
    plot(X2, edot_test2, 'Color', '#D95319', 'Marker', 'o')
    linear_regression(X2, edot_test2, '#D95319')
    ax = gca;
    ax.YAxis.Exponent = 0; % Get rid of pesky exponent in upper x-axis
    f=get(gca,'Children');
    legend([f(2),f(4)],'Saved params','No saved params')
    title('Dataset Size vs. Cosine Similarity')
    xlabel('Dataset Size')
    ylabel('Cosine Similarity')

    subplot(2,2,[3 4])
    errorbar(X1, mean_dtwd_test1, std_dtwd_test1, 'Color', '#0072BD', 'Marker', 'o'); hold on;
    linear_regression(X1, mean_dtwd_test1, '#0072BD')
    errorbar(X2, mean_dtwd_test2, std_dtwd_test2, 'Color', '#D95319', 'Marker', 'o');
    linear_regression(X2, mean_dtwd_test2, '#D95319')
    f=get(gca,'Children');
    legend([f(2),f(4)],'Saved params','No saved params')
    title('Dataset Size vs. Mean DTWD')
    xlabel('Dataset Size')
    ylabel('Mean DTWD')

end