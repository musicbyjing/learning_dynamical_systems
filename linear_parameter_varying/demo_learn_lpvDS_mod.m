%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demo Script for GMM-based LPV-DS Learning introduced in paper:          %
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

%% Step 0 - OPTION 1: Gather user inputs

n = -1; c = 0;
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

% Prompt
s1 = 'Enter the following as numbers separated by spaces: ';
s2 = '1) Model number (int; see command window);';
s3 = '2) 0 to use all data, 1 to select an area;';
s4 = '3) the proportion of the data to be randomly deleted (0-1, float);';
s5 = '4) 0 to store parameters, 1 to learn using stored parameters;';
prompt = [s1 newline newline s2 newline newline s3 newline newline s4 newline newline s5];
ans = inputdlg(prompt);
user_input = str2num(ans{:})

n = user_input(1);
select_area = user_input(2);
prop_to_delete = user_input(3);
store_params = user_input(4);
test_set_prop = 0.2;

%% Step 0 - OPTION 2: Hardcoded options (to run this file in a loop)
% Comment out Step 0 OPTION 1 and run `loop_demo_learn_lpvDS` with the
% desired parameters

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Step 1 - OPTION 1 (DATA LOADING): Load CORL-paper Datasets %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%% Select a Dataset %%%%%%%%%%%%%%%%%%%%%%%%%%
% 1:  Messy Snake Dataset   (2D) *
% 2:  L-shape Dataset       (2D) *
% 3:  A-shape Dataset       (2D) * 
% 4:  S-shape Dataset       (2D) * 
% 5:  Dual-behavior Dataset (2D) *
% 6:  Via-point Dataset     (3D) * 9  trajectories recorded at 100Hz
% 7:  Sink Dataset          (3D) * 11 trajectories recorded at 100Hz
% 8:  CShape bottom         (3D) * 16 trajectories recorded at 100Hz
% 9:  CShape top            (3D) --12 trajectories recorded at 100Hz
% 10: CShape all            (3D) -- x trajectories recorded at 100Hz
% 11: Flat-C for loco-manip (2D) * 3 trajectories recorded at 100Hz (downsampled to 50Hz)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% addpath(genpath(pwd));
% pkg_dir         = './';
% chosen_dataset  = 1; 
% sub_sample      = 1; % '>2' for real 3D Datasets, '1' for 2D toy datasets % originally 5
% nb_trajectories = 0; % For real 3D data only % originally 3
% [Data, Data_sh, att, x0_all, data, dt] = load_dataset_DS(pkg_dir, chosen_dataset, sub_sample, nb_trajectories);
% 
% % Position/Velocity Trajectories
% vel_samples = 50; vel_size = 0.75; 
% [h_data, h_att, h_vel] = plot_reference_trajectories_DS(Data, att, vel_samples, vel_size);
% 
% % Extract Position and Velocities
% M          = size(Data,1)/2;    
% Xi_ref     = Data(1:M,:);
% Xi_dot_ref = Data(M+1:end,:);   

%% %%%%%%%%%%%% [Optional] Load pre-learned lpv-DS model from Mat file  %%%%%%%%%%%%%%%%%%%
% DS_name = '/3D-Sink/3D-Sink_pqlf_2';
% DS_name = '3D-Via-point_pqlf_2';
% matfile = strcat(pkg_dir,'/models/', DS_name,'.mat');
% load(matfile)
% if constr_type == 1
%     ds_lpv = @(x) lpv_ds(x-repmat(att,[1 size(x,2)]), ds_gmm, A_g, b_g);
% else
%     ds_lpv = @(x) lpv_ds(x, ds_gmm, A_k, b_k);
% end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Step 1 - OPTION 2 (DATA LOADING): Load Motions from LASA Handwriting Dataset %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Choose DS LASA Dataset to load

% clear all; close all; clc

% Select one of the motions from the LASA Handwriting Dataset
sub_sample      = 5; % Each trajectory has 1000 samples when set to '1'
nb_trajectories = 7; % Maximum 7, will select randomly if <7
[Data, Data_sh, att, x0_all, ~, dt] = load_LASA_dataset_DS_mod(n, names, sub_sample, nb_trajectories);

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
%%%%%%%%%%%%%%%%%% GMM Estimation Algorithm %%%%%%%%%%%%%%%%%%%%%%
% 0: Physically-Consistent Non-Parametric (Collapsed Gibbs Sampler)
% 1: GMM-EM Model Selection via BIC
% 2: CRP-GMM (Collapsed Gibbs Sampler)
est_options = [];
est_options.type             = 1;   % GMM Estimation Alorithm Type   

% If algo 1 selected:
est_options.maxK             = 10;  % Maximum Gaussians for Type 1
est_options.fixed_K          = 1;  % Fix K and estimate with EM for Type 1; ORIGINALLY []

% If algo 0 or 2 selected:
est_options.samplerIter      = 50;  % Maximum Sampler Iterations
                                    % For type 0: 20-50 iter is sufficient
                                    % For type 2: >100 iter are needed
                                    
est_options.do_plots         = 1;   % Plot Estimation Statistics
est_options.sub_sample       = 5;   % Size of sub-sampling of trajectories
                                    % 1/2 for 2D datasets, >2/3 for real    
% Metric Hyper-parameters
est_options.estimate_l       = 1;   % '0/1' Estimate the lengthscale, if set to 1
est_options.l_sensitivity    = 2;   % lengthscale sensitivity [1-10->>100]
                                    % Default value is set to '2' as in the
                                    % paper, for very messy, close to
                                    % self-intersecting trajectories, we
                                    % recommend a higher value
est_options.length_scale     = [];  % if estimate_l=0 you can define your own
                                    % l, when setting l=0 only
                                    % directionality is taken into account

%% Fit GMM to Trajectory Data

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
dataset_size = size(Xi_ref, 2);
num_to_remove = int16(prop_to_delete * dataset_size);
permutation = randperm(dataset_size);
Xi_ref(:, permutation(1:num_to_remove)) = [];
Xi_dot_ref(:, permutation(1:num_to_remove)) = [];
fprintf('\n\nThe training set size after randomly deleting %d elements is %d x %d.', num_to_remove, size(Xi_ref));
dataset_size = size(Xi_ref, 2);

Data_sh = [Xi_ref Xi_dot_ref];
% Data = Data_sh;

% Fit from scratch or use previously saved parameters
[Priors, Mu, Sigma] = fit_gmm_mod(Xi_ref, Xi_dot_ref, store_params, est_options);

%% Generate GMM data structure for DS learning
clear ds_gmm; 
ds_gmm.Mu = Mu; ds_gmm.Sigma = Sigma; ds_gmm.Priors = Priors;

%% (Recommended!) Step 2.1: Dilate the Covariance matrices that are too thin
% This is recommended to get smoother streamlines/global dynamics
adjusts_C  = 1;
if adjusts_C  == 1 
    if M == 2
%         tot_dilation_factor = 1; rel_dilation_fact = 0.25;
        tot_dilation_factor = 1; rel_dilation_fact = 0.2;
    elseif M == 3
        tot_dilation_factor = 1; rel_dilation_fact = 0.75;        
    end
    Sigma_ = adjust_Covariances(ds_gmm.Priors, ds_gmm.Sigma, tot_dilation_factor, rel_dilation_fact);
    ds_gmm.Sigma = Sigma_;
end   

%%  Visualize Gaussian Components and labels on clustered trajectories 
% Extract Cluster Labels
[~, est_labels] =  my_gmm_cluster(Xi_ref, ds_gmm.Priors, ds_gmm.Mu, ds_gmm.Sigma, 'hard', []); % ~ means disregard that variable (i.e. the first var)

% Visualize Estimated Parameters
[h_gmm]  = visualizeEstimatedGMM(Xi_ref,  ds_gmm.Priors, ds_gmm.Mu, ds_gmm.Sigma, est_labels, est_options);

% return;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%  Step 3 (DS ESTIMATION): ESTIMATE SYSTEM DYNAMICS MATRICES  %%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% DS OPTIMIZATION OPTIONS %%%%%%%%%%%%%%%%%%%%%% 
% Type of constraints/optimization 
constr_type = 2;      % 0:'convex':     A' + A < 0 (Proposed in paper)
                      % 1:'non-convex': A'P + PA < 0 (Sina's Thesis approach - not suitable for 3D)
                      % 2:'non-convex': A'P + PA < -Q given P (Proposed in paper)                                 
init_cvx    = 0;      % 0/1: initialize non-cvx problem with cvx                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if constr_type == 0 || constr_type == 1
    P_opt = eye(M);
else
    % P-matrix learning
%     [Vxf] = learn_wsaqf(Data,0,att);
   
    % (Data shifted to the origin)
    % Assuming origin is the attractor (works better generally)
    [Vxf] = learn_wsaqf(Data_sh);
    P_opt = Vxf.P;
end

%%%%%%%%  LPV system sum_{k=1}^{K}\gamma_k(xi)(A_kxi + b_k) %%%%%%%%  
if constr_type == 1
    [A_k, b_k, P_est] = optimize_lpv_ds_from_data_mod(Data_sh, zeros(M,1), constr_type, ds_gmm, P_opt, init_cvx);
    ds_lpv = @(x) lpv_ds(x-repmat(att,[1 size(x,2)]), ds_gmm, A_k, b_k);
else
    [A_k, b_k, P_est] = optimize_lpv_ds_from_data_mod(Xi_ref, Xi_dot_ref, store_params, att, constr_type, ds_gmm, P_opt, init_cvx);
    ds_lpv = @(x) lpv_ds(x, ds_gmm, A_k, b_k);
end

%% %%%%%%%%%%%%    Plot Resulting DS  %%%%%%%%%%%%%%%%%%%
% Fill in plotting options
ds_plot_options = [];
ds_plot_options.sim_traj  = 1;            % To simulate trajectories from x0_all
ds_plot_options.x0_all    = x0_all;       % Intial Points
ds_plot_options.init_type = 'ellipsoid';       % For 3D DS, to initialize streamlines
                                          % 'ellipsoid' or 'cube'  
ds_plot_options.nb_points = 30;           % No of streamlines to plot (3D)
ds_plot_options.plot_vol  = 1;            % Plot volume of initial points (3D)

[hd, hs, hr, x_sim] = visualizeEstimatedDS(Xi_ref, ds_lpv, ds_plot_options);
limits = axis;
switch constr_type
    case 0
        title('GMM-based LPV-DS with QLF', 'Interpreter','LaTex','FontSize',20)
    case 1
        title('GMM-based LPV-DS with P-QLF (v0) ', 'Interpreter','LaTex','FontSize',20)
    case 2
        title('GMM-based LPV-DS with P-QLF', 'Interpreter','LaTex','FontSize',20)
end
% axis fit;
%% %%%%%%%%%%%%   Export DS parameters to Mat/Txt/Yaml files  %%%%%%%%%%%%%%%%%%%
DS_name = '2d-U-Nav';
pkg_dir         = './';
save_lpvDS_to_Mat(DS_name, pkg_dir, ds_gmm, A_k, b_k, att, x0_all, dt, P_est, constr_type, est_options)

%% Save LPV-DS parameters to text files
DS_name = '3D-CShape-top-pqlf-2';
save_lpvDS_to_txt(DS_name, pkg_dir,  ds_gmm, A_k, att)

%% Save LPV-DS parameters to yaml file
DS_name = 'iCub-CshapeRotated-Loco';
% To use the rest of the code you need a matlab yaml convertor
% you can get it from here: http://vision.is.tohoku.ac.jp/~kyamagu/software/yaml/
save_lpvDS_to_Yaml(DS_name, pkg_dir,  ds_gmm, A_k, att, x0_all, dt)

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Step 4 (Evaluation): Compute Metrics and Visualize Velocities %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Compute Errors
% Compute RMSE
rmse = mean(rmse_error(ds_lpv, Xi_ref, Xi_dot_ref));
fprintf('LPV-DS with (O%d), got prediction RMSE on training set: %d \n', constr_type+1, rmse);
rmse_test = mean(rmse_error(ds_lpv, Xi_ref_test, Xi_dot_ref_test));
fprintf('LPV-DS with (O%d), got prediction RMSE on test set: %d \n', constr_type+1, rmse_test);

% Compute e_dot
edot = mean(edot_error(ds_lpv, Xi_ref, Xi_dot_ref));
fprintf('LPV-DS with (O%d), got e_dot on training set: %d \n', constr_type+1, edot);
edot_test = mean(edot_error(ds_lpv, Xi_ref_test, Xi_dot_ref_test));
fprintf('LPV-DS with (O%d), got e_dot on test set: %d \n', constr_type+1, edot_test);

% Compute DTWD between train trajectories and reproductions
if ds_plot_options.sim_traj
    nb_traj       = size(x_sim,3);
    ref_traj_leng = size(Xi_ref,2)/nb_traj;
    dtwd = zeros(1,nb_traj);
    for n=1:nb_traj
        start_id = round(1+(n-1)*ref_traj_leng);
        end_id   = round(n*ref_traj_leng);
        dtwd(1,n) = dtw(x_sim(:,:,n)',Xi_ref(:,start_id:end_id)',20);
    end
    fprintf('LPV-DS got DTWD of reproduced trajectories: %2.4f +/- %2.4f \n', mean(dtwd),std(dtwd));
end

if ds_plot_options.sim_traj
    nb_traj       = size(x_sim,3);
    ref_traj_leng = size(Xi_ref_test,2)/nb_traj;
    dtwd_test = zeros(1,nb_traj);
    for n=1:nb_traj
        start_id = round(1+(n-1)*ref_traj_leng);
        end_id   = round(n*ref_traj_leng);
        dtwd_test(1,n) = dtw(x_sim(:,:,n)',Xi_ref_test(:,start_id:end_id)',20);
    end
    fprintf('LPV-DS got DTWD of reproduced trajectories: %2.4f +/- %2.4f \n', mean(dtwd_test),std(dtwd_test));
end

% Store variables in graph_data.mat if learning from previous data
file = fullfile(pwd, 'learning_dynamical_systems', 'data_files', 'graph_data.mat');
if isfile(file)
    load(file, 'graph_data');
    temp = [dataset_size; rmse_test; edot_test; mean(dtwd_test); std(dtwd_test); ...
        rmse; edot; mean(dtwd); std(dtwd)];
    graph_data = [graph_data temp];
    save(file, 'graph_data');
    fprintf('Dataset size and errors (RMSE, e_dot, DTWD) appended to graph_data.mat.\n')
else
    graph_data = [dataset_size; rmse_test; edot_test; mean(dtwd_test); std(dtwd_test); ...
        rmse; edot; mean(dtwd); std(dtwd)];
    save(file, 'graph_data');
    fprintf('graph_data.mat created. Dataset size and errors (RMSE, e_dot, DTWD) saved.\n')
end

% Compare Velocities from Demonstration vs DS
h_vel = visualizeEstimatedVelocities(Data, ds_lpv);

%% Optional save reference trajectories with computed velocities for C++ class testing
% xd_dot = [];
% % Simulate velocities from same reference trajectory
% for i=1:N
%     xd_dot_ = ds_lpv(Data(1:M,i));    
%     % Record Trajectories
%     xd_dot = [xd_dot xd_dot_];        
% end
% 
% model_dir = strcat(pkg_dir,'/models/',DS_name, '/');
% % Writing Data
% dlmwrite(strcat(model_dir,'Data'), Data, 'newline','unix','Delimiter',' ','precision','%.6f');
% 
% % Writing xi_dot
% dlmwrite(strcat(model_dir,'xi_dot'), xd_dot, 'newline','unix','Delimiter',' ','precision','%.6f');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%     Step 5 (Optional - Stability Check 2D-only): Plot Lyapunov Function and derivative  %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Type of plot
contour = 1; % 0: surf, 1: contour
clear lyap_fun_comb lyap_der 

switch constr_type
    case 0 
        P = eye(2);
        title_string = {'$V(\xi) = (\xi-\xi^*)^T(\xi-\xi^*)$'};
    case 1
        P = P_est;
        title_string = {'$V(\xi) = (\xi-\xi^*)^TP(\xi-\xi^*)$'};
    case 2
        P = P_opt;
        title_string = {'$V(\xi) = (\xi-\xi^*)^TP(\xi-\xi^*)$'};
end

if M == 2
    % Lyapunov function
    lyap_fun = @(x)lyapunov_function_PQLF(x, att, P);
    
    % Derivative of Lyapunov function (gradV*f(x))
    lyap_der = @(x)lyapunov_derivative_PQLF(x, att, P, ds_lpv);
    title_string_der = {'Lyapunov Function Derivative $\dot{V}(\xi)$'};
    
    % Plots
    h_lyap     = plot_lyap_fct(lyap_fun, contour, limits,  title_string, 0);
    [hd] = scatter(Data(1,:),Data(2,:),10,[1 1 0],'filled'); hold on;
    h_lyap_der = plot_lyap_fct(lyap_der, contour, limits,  title_string_der, 1);
    [hd] = scatter(Xi_ref(1,:),Xi_ref(2,:),10,[1 1 0],'filled'); hold on;
else
    clc;
    fprintf(2,'Lyapunov Function Plotting: Not possible for 3D data.\n')    
end