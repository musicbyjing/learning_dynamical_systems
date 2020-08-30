% Author: Jing Liu
% Supervisor: Prof. Hsiu-Chin Lin, Summer 2020
% Affiliation: McGill University
% 
% This is a modified version of the following:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Demo Script for GMM-based LPV-DS Learning introduced in paper:          %
%  'A Physically-Consistent Bayesian Non-Parametric Mixture Model for     %
%   Dynamical System Learning.'; N. Figueroa and A. Billard; CoRL 2018    %
% With this script you can load 2D toy trajectories or even real-world    %
% trajectories acquired via kinesthetic taching and test the different    %
% GMM fitting approaches.                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2018 Learning Algorithms and Systems Laboratory,          %
% EPFL, Switzerland                                                       %
% Author:  Nadia Figueroa                                                 % 
% email:   nadia.figueroafernandez@epfl.ch                                %
% website: http://lasa.epfl.ch                                            %
%                                                                         %
% This work was supported by the EU project Cogimon H2020-ICT-23-2014.    %
%                                                                         %
% Permission is granted to copy, distribute, and/or modify this program   %
% under the terms of the GNU General Public License, version 2 or any     %
% later version published by the Free Software Foundation.                %
%                                                                         %
% This program is distributed in the hope that it will be useful, but     %
% WITHOUT ANY WARRANTY; without even the implied warranty of              %
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General%
% Public License for more details                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clc;

names = {'Angle','BendedLine','CShape','DoubleBendedLine','GShape',...
    'heee','JShape','JShape_2','Khamesh','Leaf_1',...
    'Leaf_2','Line','LShape','NShape','PShape',...
    'RShape','Saeghe','Sharpc','Sine','Snake',...
    'Spoon','Sshape','Trapezoid','Worm','WShape','Zshape',...
    'Multi_Models_1', 'Multi_Models_2', 'Multi_Models_3','Multi_Models_4'};

c = 0;
fprintf('\nAvailable Models:\n')
for i=1:8
    for j=1:5
        c=c+1;
        if c > 37
            break;
        end
        fprintf('%2u) %-18s',(i-1)*4+j,names{(i-1)*4+j})
    end
    fprintf('\n')
end

%% Step 0 - OPTION 1: Gather user inputs
% 
% Prompt
% s1 = 'Enter the following as numbers separated by spaces: ';
% s2 = '1) Model number (int; see command window);';
% s3 = '2) 0 to use all data, 1 to select an area;';
% s4 = '3) the proportion of the data to be randomly deleted (0-1, float);';
% s5 = '4) 0 to store parameters, 1 to learn using stored parameters;';
% 
% prompt = [s1 newline newline s2 newline newline s3 newline newline s4 newline newline s5];
% ans = inputdlg(prompt);
% user_input = str2num(ans{:})
% model_number = user_input(1);
% select_area = user_input(2);
% prop_to_delete = user_input(3);
% store_params = user_input(4);
% test_set_prop = 0.2;

%% Step 0 - OPTION 2: Hardcoded options (to run this file in a loop)
% Comment out Step 0 OPTION 1 and run `loop_demo` with the
% desired parameters

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Step 1 - OPTION 1 (DATA LOADING): Load CORL-paper Datasets %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REMOVED

%% %%%%%%%%%%%% [Optional] Load pre-learned lpv-DS model from Mat file  %%%%%%%%%%%%%%%%%%%
% REMOVED

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Step 1 - OPTION 2 (DATA LOADING): Load Motions from LASA Handwriting Dataset %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Choose DS LASA Dataset to load

% clear all; close all; clc

% Select one of the motions from the LASA Handwriting Dataset
sub_sample      = 5; % Each trajectory has 1000 samples when set to '1'
nb_trajectories = 7; % Maximum 7, will select randomly if <7
[Data, Data_sh, att, x0_all, ~, dt] = load_LASA_dataset_DS_mod(model_number, names, sub_sample, nb_trajectories);

% Position/Velocity Trajectories
vel_samples = 15; vel_size = 0.5; 
[h_data, h_att, h_vel] = plot_reference_trajectories_DS(Data, att, vel_samples, vel_size);

% Extract Position and Velocities
M          = size(Data,1)/2;    
Xi_ref     = Data(1:M,:);
Xi_dot_ref = Data(M+1:end,:);  

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Step 2 (GMM FITTING): Fit GMM to Trajectory Data %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REMOVED

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Step 2: Data Manipulation %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Decide if using all data or just part of it
fprintf('\n\nThe original dataset size is  %d x %d.', size(Xi_ref));
if select_area == 1
% ------- User input version -------
%     fprintf("\nInput the area you want to select data from, one coordinate at a time, in the following order: \n x_min, x_max, y_min, y_max");
%     bounds = zeros(1,4);
%     for j = 1:4
%         bounds(j) = input("\nType a coordinate: ");
%     end
% ------- Hardcoded version -------
    bounds = [22, 30, -10, 20]; % values derived from looking at the biggest cluster in LASA datasets 7 and 8
    selected_data = [];
    selected_data_dot = [];
    for j = 1:numel(Xi_ref)/2
        if Xi_ref(1,j) > bounds(1) && Xi_ref(1,j) < bounds(2) && Xi_ref(2,j) > bounds(3) && Xi_ref(2,j) < bounds(4)
            selected_data = [selected_data Xi_ref(:,j)];
            selected_data_dot = [selected_data_dot Xi_dot_ref(:,j)];
        end
    end
    Xi_ref = selected_data;
    Xi_dot_ref = selected_data_dot;
    fprintf('\n\nThe dataset size after selecting an area is %d x %d.', size(Xi_ref));
end

% Separate a test set from the training data
dataset_size = size(Xi_ref, 2);
test_size = int16(test_set_prop * dataset_size);
rng(1); % Set a seed so that the same test set is chosen each time
permutation = randperm(dataset_size);

Xi_ref_test = Xi_ref(:, permutation(1:test_size)); % test set
Xi_dot_ref_test = Xi_dot_ref(:, permutation(1:test_size)); % test set
Xi_ref = Xi_ref(:, permutation(test_size+1:dataset_size)); % remaining training set
Xi_dot_ref = Xi_dot_ref(:, permutation(test_size+1:dataset_size)); % remaining training set
fprintf('\n\nThe test set size is %d x %d and the training set size is %d x %d.', size(Xi_ref_test), size(Xi_ref)); 

% Randomly delete some of the data
rng('shuffle');
dataset_size = size(Xi_ref, 2);
num_to_remove = int16(prop_to_delete * dataset_size);
permutation = randperm(dataset_size);
Xi_ref(:, permutation(1:num_to_remove)) = [];
Xi_dot_ref(:, permutation(1:num_to_remove)) = [];
fprintf('\n\nThe training set size after randomly deleting %d elements is %d x %d.\n', num_to_remove, size(Xi_ref));
dataset_size = size(Xi_ref, 2);

% Data_sh = [Xi_ref Xi_dot_ref];
% Data = Data_sh;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Step 2.5: Split Modified Dataset %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% test/train split
X_train = Xi_ref;
Y_train = Xi_dot_ref;
X_test = Xi_ref_test;
Y_test = Xi_dot_ref_test;

% train/val split
idx = randperm(size(X_train,2), int16(dataset_size/5));
X_val = X_train(:,idx);
X_train(:,idx) = [];
Y_val = Y_train(:,idx);
Y_train(:,idx) = [];

% In case dataset needs to be exported
% file = fullfile(pwd, 'learning_dynamical_systems', 'data_files', 'dataset_mod.mat');
% save(file, 'X_train', 'Y_train', 'X_test', 'Y_test');
% fprintf('Modified dataset saved to dataset_mod.mat.\n')

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%  Step 3 (DS ESTIMATION): ESTIMATE SYSTEM DYNAMICS MATRICES  %%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Based on:
% https://www.mathworks.com/help/deeplearning/ug/sequence-to-sequence-regression-using-deep-learning.html

numFeatures = 2;
numHiddenUnits = 125;
numResponses = 2;

layers = [ ...
    sequenceInputLayer(numFeatures)
    flattenLayer
    lstmLayer(numHiddenUnits,'OutputMode','sequence')
    fullyConnectedLayer(numResponses)
    log_barrier_regression_layer(X_train, X_val, [0;0])];

% The built-in `regressionLayer` uses the half-MSE loss
% The custom `log_barrier_regression_layer` uses a log barrier + MSE loss

maxEpochs = 500;
miniBatchSize = 20;

options = trainingOptions('adam', ...
    'ExecutionEnvironment','cpu', ...
    'MaxEpochs',maxEpochs, ...
    'ValidationData',{X_val,Y_val}, ...
    'MiniBatchSize',miniBatchSize, ...
    'GradientThreshold',1, ...
    'Verbose',true, ...
    'Plots','training-progress');

% Load NN from file or train NN
% file = fullfile(pwd, 'learning_dynamical_systems', 'deep_learning', 'models', 'net.mat');
% if isfile(file)
%     net = load(file, 'net').net;
% else
    net = trainNetwork(X_train, Y_train, layers, options);
%     save(file, 'net');
% end

% FIGURE OUT ACCURACY

limits = axis;
axlim = limits + [-0.015 0.015 -0.015 0.015]; % taken from visualizeEstimatedDs
ax_x = linspace(axlim(1), axlim(2),200); % taken from plot_ds_model
ax_y = linspace(axlim(3), axlim(4),200);
[x_tmp, y_tmp]=meshgrid(ax_x, ax_y);
x=[x_tmp(:), y_tmp(:)]';

Y_pred = predict(net, x); % prediction on all space, necessary for DS plot

%% %%%%%%%%%%%%    Plot Resulting DS  %%%%%%%%%%%%%%%%%%%
% Fill in plotting options
ds_plot_options = [];
ds_plot_options.sim_traj  = 0;            % To simulate trajectories from x0_all
ds_plot_options.x0_all    = x0_all;       % Intial Points
ds_plot_options.init_type = 'ellipsoid';       % For 3D DS, to initialize streamlines
                                          % 'ellipsoid' or 'cube'  
ds_plot_options.nb_points = 30;           % No of streamlines to plot (3D)
ds_plot_options.plot_vol  = 1;            % Plot volume of initial points (3D)

[hd, hs, hr, x_sim] = visualizeEstimatedDS_mod('dl', [], Xi_ref, Y_pred, ds_plot_options);
limits = axis;
title(sprintf('Series Neural Network, LASA %d', model_number));

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Step 4 (Evaluation): Compute Metrics and Visualize Velocities %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Compute Errors
% Compute RMSE

Y_pred = predict(net, X_test); % prediction on the test set
[rmse, edot] = get_errors_dl(Y_test, Y_pred);

fprintf('dl, got prediction RMSE on test set: %d \n', rmse);
fprintf('dl, got prediction edot on test set: %d \n', edot);

% Store variables in graph_data.mat
file = fullfile(pwd, 'learning_dynamical_systems', 'data_files', 'graph_data.mat');
if isfile(file)
    load(file, 'graph_data');
    temp = [dataset_size; rmse; edot];
    graph_data = [graph_data temp];
    save(file, 'graph_data');
    fprintf('Dataset size and errors (RMSE, edot) appended to graph_data.mat.\n')
else
    graph_data = [dataset_size; rmse; edot];
    save(file, 'graph_data');
    fprintf('graph_data.mat created. Dataset size and errors (RMSE, edot) saved.\n')
end

return;

% Compare Velocities from Demonstration vs DS
% REMOVED

%% Optional save reference trajectories with computed velocities for C++ class testing
% REMOVED

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%     Step 5 (Optional - Stability Check 2D-only): Plot Lyapunov Function and derivative  %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REMOVED