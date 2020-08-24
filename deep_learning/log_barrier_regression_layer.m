% Author: Jing Liu
% Supervisor: Prof. Hsiu-Chin Lin, Summer 2020
% Affiliation: McGill University

% Reference: https://www.mathworks.com/help/deeplearning/ug/define-custom-regression-output-layer.html

classdef log_barrier_regression_layer < nnet.layer.RegressionLayer
        
    properties
        X
        target
    end
    
    methods
        function layer = log_barrier_regression_layer(X, target)
            layer.X = X;
            layer.target = target; % the target point of the trajectory
        end

        function loss = forwardLoss(layer, Y, T)
            % Return the loss between the predictions Y and the training
            % targets T.
            %
            % Inputs:
            %         layer - Output layer
            %         Y     – Predictions made by network
            %         T     – Training targets
            %
            % Output:
            %         loss  - Loss between Y and T
            
            X = layer.X;
            target = layer.target;

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % When testing with the command window, initialize:
%           X = rand(2, 229);
%           target = zeros(2, 229);
%           Y = rand(2,1,229);
%           T = rand(2,1,229);
%           R = size(Y, 1); 
%           S = size(Y, 3);
%           num_points = size(Y,3);
%           for n = 1:num_points 
%               y_n(1,n) = Y(1,1,n);
%               y_n(2,n) = Y(2,1,n);
%           end

            % In example 8: 
            % X and target have dims 2 x 229
            % Y and T have size 2 x 1 x 229;
            %       this is R x N x S, where R is the number of responses, 
            %       N is the number of observations, and S is the sequence length
            % 

            part1 = sum(abs(Y-T).^2, 3); % size 2 x 1
            part1 = sum(part1, 1); % size 1 x 1

            num_points = size(Y,3); % 229

            for n = 1:num_points 
                y_n(1,n) = Y(1,1,n); % y_n has size 2 x 229
                y_n(2,n) = Y(2,1,n);
                % Original:
                % y_n(1) = Y(1,1,n);
                % y_n(2) = Y(2,1,n);
                % x_n(n) = X(:,n);
            end

            part2 = sum(sum(-2 * y_n' * (X-target) + 1)); 
            % Original: 
            % part2 = sum (( -2.* y_n' * ( x-target))) 
            part2 = real(log(part2));

            loss = part1 - part2;

        end
        
        function dLdY = backwardLoss(layer, Y, T)
            % (Optional) Backward propagate the derivative of the loss 
            % function.
            %
            % Inputs:
            %         layer - Output layer
            %         Y     – Predictions made by network
            %         T     – Training targets
            %
            % Output:
            %         dLdY  - Derivative of the loss with respect to the 
            %                 predictions Y        
            
            X = layer.X;
            target = layer.target;
            num_points = size(Y,3);
            
            for n = 1:num_points 
                y_n(1,n) = Y(1,1,n);
                y_n(2,n) = Y(2,1,n);
            end
            
            part1 = 2*(Y-T); % size 2 x 1 x 229
            part2 = 2*(X-target) / sum(sum((-2*y_n'*(X-target)+1)));
            
            % Create the middle dimension--dLdY needs to have the same size as Y
            bob = ones(2,1,num_points);
            bob(:,1,:) = part2;
            part2 = bob;
            
            dLdY = part1 + part2;
            
        end
    end
end

