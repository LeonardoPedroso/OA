% NewtonMethod.m
%% Initialization
clear;
clc;
NDataSets = 4;

%% Setup parameters 
epsl = 1e-6; % stopping criterion
alpha_hat = 1; %initialization of alpha_k for the backtracking routine
gamma = 1e-4; % gamma of backtraking routine
beta = 0.5; % beta of backtraking routine
maxIt = [15; 15; 15; 15]; % maximum number of iterations

%% Newton algorithm for each data set
for i = 1:NDataSets
    %% Upload data
    load(sprintf("./data%d.mat",i),'X','Y'); % upload data set
    K = length(Y);
    n = size(X,1);
    
    %% Set up x0 (note that x = [s;r])
    x0 = [-ones(n,1); 0];

    %% Setup objetive function and gradient
    h = [X;-ones(1,K)];
    F = @(x) (1/K)*...
        sum(log(1+exp((h'*x)'))-Y.*(h'*x)');
    gradF = @(x) (1/K)*sum((exp((h'*x)')./...
        (1+exp((h'*x)'))-Y).*h,2);
    hessF = @(x)(1/K)*(h*diag(exp(h'*x)./((1+exp(h'*x)).^2))*h');
    %% Run Newton algorithm
    fprintf("Running Newton algorithm for dataset %d (n = %d | K = %d).\n",...
        i,n,K);
    tic
    [xNA,ItNA,normGradNA,alphakNA] = newtonAlgorithm(F,gradF,hessF,x0,epsl,...
        alpha_hat,gamma,beta,maxIt(i));
    elapsedTimeNA = toc;
    if ~isnan(xNA)
        fprintf("Newton algorithm for dataset %d"+...
        " converged in %d iterations.\n",i,ItNA);
        fprintf("Elapsed time is %f seconds.\n",elapsedTimeNA);
        if i<=2
            fprintf("s = [%g; %g] | r = %g.\n",xNA(1),xNA(2),xNA(3));
        end
    else
        fprintf("Newton algorithm for dataset %d "+... 
            "exceeded the maximum number of iterations.\n",i); 
        fprintf("Elapsed time is %f seconds.\n",elapsedTimeNA);
    end
    
%     testElapsedTime = true;
%     if testElapsedTime
%         NtestsElapsedTime = 10;
%         elapsedTimeNA = 0;
%         fprintf("Getting average elapsed time for %d Newton algorithm routines for dataset %d (n = %d | K = %d).\n",...
%         NtestsElapsedTime,i,n,K);
%         for k = 1:NtestsElapsedTime
%             tic;
%             [out1,out2,out3,out4] = newtonAlgorithm(F,gradF,hessF,x0,epsl,...
%                 alpha_hat,gamma,beta,maxIt(i));
%             aux = toc;
%             fprintf("Elapsed time for test %d is %f seconds.\n",k,elapsedTimeNA);
%             elapsedTimeNA = elapsedTimeNA + aux/NtestsElapsedTime;
%         end
%         save(sprintf("./DATA/NewtonAlgorithm/NAsolDataset%d.mat",i),...
%         'xNA','ItNA','normGradNA','alphakNA','elapsedTimeNA');
%     else    
%         save(sprintf("./DATA/NewtonAlgorithm/NAsolDataset%d.mat",i),...
%         'xNA','ItNA','normGradNA','alphakNA');
%     end

    %% Save data
    save(sprintf("./DATA/NewtonAlgorithm/NAsolDataset%d.mat",i),...
        'xNA','ItNA','normGradNA','alphakNA','elapsedTimeNA');
    
    
    %% Plot result
    plotResults = false;
    if plotResults
    if i<= 2
        figure('units','normalized','outerposition',[0 0 1 1]);
        set(gca,'FontSize',35);
        hold on;
        ax = gca;
        ax.XGrid = 'on';
        ax.YGrid = 'on';
        axis equal;
        for k = 1:K
            if Y(k)
                scatter(X(1,k),X(2,k),200,'o','b','LineWidth',3); 
            else
                scatter(X(1,k),X(2,k),200,'o','r','LineWidth',3); 
            end
        end
        %ylim([-4 8]);
        %xlim([-4 8]);
        title(sprintf("Dataset %d",i));
        ylabel('$x_2$','Interpreter','latex');
        xlabel('$x_1$','Interpreter','latex');
        x1 = (min(X(1,:)):(max(X(1,:)-min(X(1,:))))/100:max(X(1,:)));
        plot(x1,(xNA(3)-xNA(1)*x1)/xNA(2),'--m','LineWidth',4);
        saveas(gcf,sprintf("./DATA/NewtonAlgorithm/NAsolDataset%d.fig",i));
        close(gcf);
        hold off; 
    end
    
    figure('units','normalized','outerposition',[0 0 1 1]);
    plot(1:ItNA+1,normGradNA,'LineWidth',3);
    hold on;
    set(gca,'FontSize',35);
    ax = gca;
    ax.XGrid = 'on';
    ax.YGrid = 'on';
    title(sprintf("Newton Algorithm | Dataset %d",i));
    ylabel('$||\Delta f (s_k,r_k)||$','Interpreter','latex');
    xlabel('$k$','Interpreter','latex');
    set(gca, 'YScale', 'log');
    saveas(gcf,sprintf("./DATA/NewtonAlgorithm/NANormGradDataset%d.fig",i));
    close(gcf);
    hold off;
    
    figure('units','normalized','outerposition',[0 0 1 1]);
    stem(1:ItNA,alphakNA,'LineWidth',3,'MarkerSize',12);
    hold on;
    set(gca,'FontSize',35);
    ax = gca;
    ax.XGrid = 'on';
    ax.YGrid = 'on';
    title(sprintf("Newton Algorithm | Dataset %d",i));
    ylabel('$\alpha_k$','Interpreter','latex');
    xlabel('$k$','Interpreter','latex');
    saveas(gcf,sprintf("./DATA/NewtonAlgorithm/NAalphakDataset%d.fig",i));
    close(gcf);
    hold off; 
    end
    
end
