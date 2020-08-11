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
            
            X = dlarray(layer.X);
            target = dlarray(layer.target);

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % When continuing, use the command window. Initialize:
%             X = zeros(2, 229);
%             target = zeros(2, 229);
%             Y = zeros(2,1,229);
%             T = zeros(2,1,229);

        % For example 8: 
            % X and target have dims 2 x 229
            % Y and T have size 2 x 1 x 229;
            %       this is R x N x S, where R is the number of responses, 
            %       N is the number of observations, and S is the sequence length
          
            R = size(Y, 1); 
            S = size(Y, 3);
            part1 = sum(abs(Y-T).^2, 3) / S; % size R x 1
            part1 = sum(part1, 1) / R; % size 1 x 1
            
            % Don't think it matters which way we sum
            
            part2 = sum((2.*Y.*(X-target)+1), 3) / S; % size R x S
            part2 = log(abs(part2));
            part2 = sum(part2, 2) / S; % size R x 1
            part2 = sum(part2, 1) / R; % size 1 x 1

            loss = part1 - part2;
            
            disp(size(loss))
           
        end
        
%         function dLdY = backwardLoss(layer, Y, T)
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

            % Layer backward loss function goes here.
%         end
    end
end

