%% Part 3 - Task 1
%% Load dataset from file data_opt.csv 
X = csvread("./data/data_opt.csv");
N = size(X,1); % Get number of datapoints
%% Compute matrix D
D = zeros(N); % Initialize matrix D
for m = 1:N % Four each off-diagonal pair of coordinates
    for n = m+1:N
       D(m,n) = norm(X(m,:)-X(n,:),2); % Compute D_{mn}
       D(n,m) = D(m,n); % D_{nm}=D_{mn}
    end
end
%% Check results
% Find maximum value of distance and repective indices
Dmax = max(max(D));
[mDmax,nDmax] = find(D==Dmax);
% Output results
fprintf("------------------------ Task 1 ------------------------\n");
fprintf("D(2,3) = %g | D(4,5) = %g.\n", D(2,3),D(4,5));
fprintf("max{D(m,n)} = %g for (m,n) = {(%d,%d),(%d,%d)}.\n",...
    Dmax,mDmax(1),nDmax(1),mDmax(2),nDmax(2))
%% Save data
save("./data/distancesTask1.mat",'D','Dmax','nDmax','mDmax','N');