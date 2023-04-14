

function [F,k,b] = lsqApproximation(Filename,TolFun,TolX,flag)
    % 导入数据
    data = readtable(Filename);
    t = data.Time; % 时间数据

    y = data.Distance; % 实际数据

    y = y*10^-3;
    L = length(y);
    m = 61*10^-3;
    x_0 = y(1);

    k = 0.0;
    b = 0.0;
    F = 0.0;
    % 计算每个频率对应的实际值
    t_delta = zeros(size(t,1)-1,1);
    for i = 2:size(t,1)
        t_delta(i) = t(i)-t(i-1);
    end
    
    t_sample = mean(t_delta);%平均取样时间间隔
    Fs = 1 / (t_sample); % 采样率
    
    f = Fs * (0:(L/2))/L; % 计算每个频率对应的实际值
    params0 = zeros(1,2);
    if flag == 1
        %直接截取频率
        fun = @(params, t) x_0.*exp(-1*params(1)*t/(2*m)).*cos(2*pi*params(2)*t);%定义动力学函数

       
        params0(1) = 1;
        params0(2) = mean(f);%实际频率值的平均数
        
        %params0(2) = 1;
    elseif flag==2
        %根据数学关系求解

        fun = @(params, t) x_0.*exp(-1*params(1)*t/(2*m)).*cos(sqrt(params(2)/m-params(1)^2/(4*m^2))*t);%定义动力学函数
        
        params0(1) = 1;
        params0(2) = 1;%实际频率值的平均数

    end
    
    options = optimoptions(@lsqcurvefit, 'TolFun', TolFun, 'TolX', TolX);
    params = lsqcurvefit(fun, params0, t, y,[],[],options);
    if flag == 1
        F = params(2);
    elseif flag ==2
        k = params(2);
        b = params(1);
    end
end