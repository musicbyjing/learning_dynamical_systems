% Author: Jing Liu
% Supervisor: Prof. Hsiu-Chin Lin, Summer 2020
% Affiliation: McGill University

% Reference: https://www.mathworks.com/help/deeplearning/ug/define-custom-regression-output-layer.html

classdef log_barrier_regression_layer < nnet.layer.RegressionLayer
        
    properties
        X_train
        train_size
        X_val
        val_size
        target
    end
    
    methods
        function layer = log_barrier_regression_layer(X_train, X_val, target)
            layer.X_train = X_train;
            layer.train_size = size(X_train, 2);
            layer.X_val = X_val;
            layer.val_size = size(X_val, 2);
            layer.target = target; % the target point of the trajectory
        end

        function loss = forwardLoss(layer, Y_pred, Y)
            % Return the loss between the predictions Y_pred and the training
            % targets Y.
            %
            % Inputs:
            %         layer - Output layer
            %         Y_pred     – Predictions made by network
            %         Y     – Training targets
            %
            % Output:
            %         loss  - Loss between Y_pred and Y
            
            num_points = size(Y_pred,3);
            if num_points == layer.train_size
                X = layer.X_train;
            elseif num_points == layer.val_size
                X = layer.X_val;
            else
                return;
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % When testing with the command window, initialize:
%           X = rand(2, 229);
%           target = zeros(2, 229);
%           Y_pred = rand(2,1,229);
%           Y = rand(2,1,229);
%           R = size(Y_pred, 1); 
%           S = size(Y_pred, 3);
%           num_points = size(Y_pred,3);
%           for n = 1:num_points 
%               Y_n(1,n) = Y_pred(1,1,n);
%               Y_n(2,n) = Y_pred(2,1,n);
%           end

            % In example 8: 
            % X and target have dims 2 x 229
            % Y_pred and Y have size 2 x 1 x 229;
            %       this is R x N x S, where R is the number of responses, 
            %       N is the number of observations, and S is the sequence length
            % 

            part1 = sum(abs(Y_pred-Y).^2, 3); % size 2 x 1
            part1 = sum(part1, 1); % size 1 x 1

            for n = 1:num_points
                Y_n(1,n) = Y(1,1,n); % Y_n has size 2 x 229
                Y_n(2,n) = Y(2,1,n);
            end
            
            temp = 2*Y_n'*(X-layer.target);
            
            if size(temp(temp>1), 1) > 0
                loss = realmax('single'); % max single in MATLAB
                return;
            end
            
            part2 = sum(sum(-temp + 1)); 
            % Original: 
            % part2 = sum (( -2.* Y_n' * ( x-target))) 
            part2 = real(log(part2));

            loss = part1 - part2;
            return;

        end
        
        function dLdY_pred = backwardLoss(layer, Y_pred, Y)
            % (Optional) Backward propagate the derivative of the loss 
            % function.
            %
            % Inputs:
            %         layer - Output layer
            %         Y_pred     – Predictions made by network
            %         Y     – Training targets
            %
            % Output:
            %         dLdY_pred  - Derivative of the loss with respect to the 
            %                 predictions Y_pred        
            
            num_points = size(Y_pred,3);
            if num_points == layer.train_size
                X = layer.X_train;
            elseif num_points == layer.val_size
                X = layer.X_val;
            else
                return;
            end
            
            for n = 1:num_points 
                Y_n(1,n) = Y_pred(1,1,n);
                Y_n(2,n) = Y_pred(2,1,n);
            end
            
            part1 = 2*(Y_pred-Y); % size 2 x 1 x 229
            
            dLdY_pred = part1;
            
%             % Create the middle dimension--dLdY needs to have the same size as Y_pred
%             bob = ones(2,1,num_points);
%             bob(:,1,:) = part2;
%             part2 = bob;
            
%             dLdY_pred = part1 + part2;
            
        end
    end
end

