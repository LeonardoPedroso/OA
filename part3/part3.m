%% Task 1
% Load raw data
X = csvread("./data/data_opt.csv");

% X = [1 2 3 4 5 6;
%     2 4 6 8 10 12
%     1 3 5 7 9 11];

N = size(X,1);
D = zeros(N);
for m = 1:N
    for n = m+1:N
       D(m,n) = norm(X(m,:)-X(n,:),2);
       D(n,m) = D(m,n);
    end
end

% Find maximum value of distance and repective indices
Dmax = max(max(D));
[mDmax,nDmax] = find(D==Dmax);
fprintf("------------------------ Task 1 ------------------------\n");
fprintf("D(2,3) = %g | D(4,5) = %g.\n", D(2,3),D(4,5));
% fprintf("D(1,2) = %g | D(2,3) = %g.\n", D(1,2),D(2,3));
fprintf("max{D(m,n)} = %g for (m,n) = {(%d,%d),(%d,%d)}.\n",...
    Dmax,mDmax(1),nDmax(1),mDmax(2),nDmax(2))

% Save data
save("./data/distancesTask1.mat",'D','Dmax','nDmax','mDmax','N');

%% Task 3
clear;
clear objectiveF;

compute = true;
if compute
load("./data/distancesTask1.mat",'D','N');
solLM = cell(2,1);
itLM = zeros(2,1);
elapsedTimeLM = zeros(2,1);
costLM = cell(2,1);
normGradLM = cell(2,1);

for k = 2:3 % target dimension
    % Set up parameters
    maxIt = 200;
    lambda0 = 1;
    epsl = k*1e-2;
    y0 = csvread(sprintf("./data/yinit%d.csv",k));
%     y0 = ones(3*k); 
    tic;
    fprintf("----------------------- Task 2/3 -----------------------\n");
    [solLM{k-1,1},itLM(k-1,1),costLM{k-1,1},normGradLM{k-1,1}] =...
        LMAlgorithm(k,lambda0,y0,epsl,maxIt);
    elapsedTimeLM(k-1,1) = toc;
    clear objectiveF;
    if ~isnan(solLM{k-1,1})
        fprintf("Solution found for dataset of task 1 with k = %d using LM algorithm.\n",k);
        fprintf("- Objective function value: %g.\n",costLM{k-1,1}(end,1));
        fprintf("- Elapsed time: %g.\n", elapsedTimeLM(k-1,1));
    else
        fprintf("Solution could not be found for dataset of task 1 with "+...
            "k = %d using\n LM algorithm with the provided stoppin criterion"+...
            " and maximum number of iterations.\n",k);
    end
    
end

% Save data
% %save("./data/solTask3_exp.mat",...
%     'solLM','itLM','elapsedTimeLM','costLM','normGradLM');
% load handel
% sound(y)
else
% Load data
load("./data/distancesTask1.mat",'N');
load("./data/solTask3_exp.mat",...
'solLM','itLM','elapsedTimeLM','costLM','normGradLM'); 
end

if ~compute  
    for k = 2:3
        % k = 2
        figure('units','normalized','outerposition',[0 0 1 1]);
        yyaxis left
        plot(0:itLM(k-1,1),costLM{k-1,1},'LineWidth',3);
        hold on;
        ylabel('$f(y)$','Interpreter','latex');
        set(gca, 'YScale', 'log');
        yyaxis right
        plot(0:itLM(k-1,1),normGradLM{k-1,1},'LineWidth',3);
        ylabel('$||\nabla f (y)||$','Interpreter','latex');
        set(gca,'FontSize',35);
        ax = gca;
        ax.XGrid = 'on';
        ax.YGrid = 'on'; 
        title(sprintf("LM algorithm | Dataset task 1 | k = %d",k));
        set(gca, 'YScale', 'log');
        xlabel('$k$','Interpreter','latex');
        saveas(gcf,sprintf("./data/task3_LM_k_%d.fig",k));
        %close(gcf);
        hold off;
        y = reshape(solLM{k-1},[k,N]);
        figure('units','normalized','outerposition',[0 0 1 1]);
        if k == 2
            scatter(y(1,:),y(2,:),100,'o','b','LineWidth',1,'MarkerFaceColor','flat');
        else
            scatter3(y(1,:),y(2,:),y(3,:),100,'o','b','LineWidth',1,'MarkerFaceColor','flat'); 
        end
        hold on;
        set(gca,'FontSize',35);
        ax = gca;
        ax.XGrid = 'on';
        ax.YGrid = 'on'; 
        title(sprintf("LM algorithm | Dataset task 1 | k = %d",k));
        saveas(gcf,sprintf("./data/task3_lowerDim_k_%d.fig",k));
        %close(gcf);
        hold off;
    end
        
end


%% Task 4

%part3_task4




%% Finish
fprintf("------------------------------------------------------\n");