function [costF,normG,A,b] = objectiveF(y)
%% objectiveF.m
% Input : y: vector at which the quatities are evaluated 
% Output: costF: cost function value
%         normG: norm of the gradient of the cost function
%         A: matrix A for the application of the LM method (only the entries
%         that do not depend on lambda)
%         b: vetor b for the application of the LM method (only the entries
%         that do not depend on lambda)
%% Initialize cost function dataset
% Load dataset in the first call to this function
persistent b_ N k % do not have to be recomputed between calls 
if isempty(k) ||isempty(b_) || isempty(N)
    % Load data:
    % D: Distance matrix
    % N: Number of data points
    % k: Dimension of the target space
    load("./data/objectiveFData.mat",'D','N','k'); 
    % Compute the portion of b that is constant
    b_ = nonzeros(tril(D,-1)); 
    fprintf("Initializing dataset.\n");
end
%% Compute quantities
costF = 0; % Initialize costF
gradf = zeros(1,N*k); % Initialize gradf
A = zeros((N^2-N)/2+N*k,N*k); % Initialize A
b = [b_;zeros(N*k,1)]; % Compute entries of b that do not depend on lambda
count = 1; % Iteration count
for i = 1:N
   for j = i+1:N
       dy = (y((i-1)*k+1:(i-1)*k+k)-y((j-1)*k+1:(j-1)*k+k))'; % y_{m-n}
       normdy = norm(dy); % ||y_{m-n}||
       faux = normdy-b_(count); % f_{mn} = ||y_{m-n}||-D_{mn}
       gradaux_ = [zeros(1,(i-1)*k) dy zeros(1,k*(j-i-1))...
           -dy zeros(1,(N-j)*k)]/(normdy); % D_y(f{mn}(y))
       costF = costF + faux^2; % f(y) += f_{mn}(y)^2
       % D_y(f(y))(y) += 2*f_{mn}(y)*D_y(f{mn}(y))
       gradf = gradf + 2*faux*gradaux_; 
       A(count,:) = gradaux_; % A(<->) = D_y(f{mn}(y))
       count = count+1; % increment iteration count 
   end
end
normG = norm(gradf); % compute norm of D_y(f(y))(y)
end