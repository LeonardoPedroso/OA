function [costF,normG,A,b] = objectiveF(y,k,sel)
% Load dataset in first call
persistent data fmn gradfmn
if isempty(data) || isempty(fmn) || isempty(gradfmn)
    data = load("./data/distancesTask1.mat",'D','N');
    % Setup objetive functions and gradients as function handles
    % Each term
    fmn = @(m,n,y) norm(y((n-1)*k+1:(n-1)*k+k)-y((m-1)*k+1:(m-1)*k+k),2)-data.D(n,m);
    gradfmn = @(m,n,y) (([zeros(k,(m-1)*k),eye(k),zeros(k,(data.N-m)*k)]-...
        [zeros(k,(n-1)*k),eye(k),zeros(k,(data.N-n)*k)])'*...
        ([zeros(k,(m-1)*k),eye(k),zeros(k,(data.N-m)*k)]-...
        [zeros(k,(n-1)*k),eye(k),zeros(k,(data.N-n)*k)])*y);
    fprintf("Initializing dataset.\n");
end
if ~sel
    % Global objective function
    costF = 0;
    gradf = zeros(data.N*k,1);
    A = NaN;
    b = NaN;
else
    % Least squares parameters
    A = zeros((data.N^2-data.N)/2+data.N*k,data.N*k);
    b = zeros((data.N^2-data.N)/2+data.N*k,1);
    costF = NaN;
    normG = NaN;
end

count = 1;
for i = 1:data.N
   for j = i+1:data.N
       faux = fmn(i,j,y);
       gradaux = gradfmn(i,j,y)/(faux+data.D(i,j));
       if ~sel
           costF = costF + faux^2;
           gradf = gradf + 2*faux*gradaux;
       else   
           A(count,:) = gradaux';
           b(count,:) = gradaux'*y-faux;
       end
       count = count+1;
   end
end
if ~sel
    normG = norm(gradf,2);
end
end


% % Save data
% save("./data/gradObjectiveFunction.mat",'fmn','gradfmn','f','gradf');
% 



% h = [X;-ones(1,K)];
% F = @(x) (1/K)*...
%     sum(log(1+exp((h'*x)'))-Y.*(h'*x)');
% gradF = @(x) (1/K)*sum((exp((h'*x)')./...
%     (1+exp((h'*x)'))-Y).*h,2);


