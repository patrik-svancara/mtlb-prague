function [fit] = LorXYFit(freq,volt,initp)
% LVM fit of two-component SS frequency sweep

% prealloc memory
fit(1:2) = struct('outp',[],'exitflag',0,'fitmsg',"");

% human-readable exitflags
efcodes = [1 2 3 4 0 -1 -2];

ef(1) = "Function converged to a solution x.";
ef(2) = "Change in x was less than the specified tolerance.";
ef(3) = "Change in the residual was less than the specified tolerance.";
ef(4) = "Magnitude of search direction was smaller than the specified tolerance.";
ef(5) = "Number of iterations exceeded options.MaxIterations or number of function evaluations exceeded options.MaxFunctionEvaluations.";
ef(6) = "Output function terminated the algorithm.";
ef(7) = "Problem is infeasible: the bounds lb and ub are inconsistent.";


% function handle
fitfunc = {@LorX @LorY};

% set fitting options
fitopt = optimoptions('lsqcurvefit',...
    'Algorithm','levenberg-marquardt',...
    'MaxIterations',1e3,...
    'FunctionTolerance',1e-8,...
    'Display','off',...
    'SpecifyObjectiveGradient',true);

% do the same for both components
for i = 1:2
    
    if nargin < 3
        
        % generate initial parameter vector
        initp(i,:) = GuessLorFitParams(freq,volt(:,i));
        
    end
    
    % perform the fit
    [fit(i).outp,~,~,fit(i).exitflag,~] = lsqcurvefit(fitfunc{i},initp(i,:),freq,volt(:,i),[],[],fitopt);
    
    % process human-readable exitflag
    fit(i).fitmsg = ef(interp1(efcodes,1:7,fit(i).exitflag));
    
end
    