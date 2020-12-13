%% Part 3 - Task 4 extra (part3task4_extra.m)
%% Set parameters
clear;
k = 2; % target dimension

%% Load data
X = csvread("./data/dataProj.csv");
N = size(X,1);
D = zeros(N);
for m = 1:N
    for n = m+1:N
       D(m,n) = norm(X(m,:)-X(n,:),2);
       D(n,m) = D(m,n);
    end
end

%% Compute cMDS solution
Q = -(1/2)*D.^2; % Define Q
H = eye(N,N) - (1/N)*ones(N,N); % Compute centering matrix
B = H*Q*H; % Centered distances
[eigVec,eigVal] = eig(B); % Computeeigen values and eigenvectors
[eigValSorted, inds] = sort(diag(eigVal)); % Sort eigenvalues
inds = flipud(inds);
eigValSorted = flipud(eigValSorted);
eigVec = eigVec(:,inds); % Get corresponding eigenvectors
eigVal = diag(eigValSorted);
Y = eigVec(:,1:k)*diag(sqrt(eigValSorted(1:k)));

%% Plot
figure('units','normalized','outerposition',[0 0 1 1]);
scatter(Y(:,1),Y(:,2),100,'o','b','LineWidth',1,'MarkerFaceColor','flat');
hold on;
set(gca,'FontSize',35);
ax = gca;
ax.XGrid = 'on';
ax.YGrid = 'on'; 
title(sprintf("cMDS | Dataset task 4 | k = %d",k));
saveas(gcf,sprintf("./data/task4_extra_sol.png"));
hold off;
