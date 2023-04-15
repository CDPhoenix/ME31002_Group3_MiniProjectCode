%ME31002 MiniProject
%WANG Dapeng Phoenix 20074734d Department of Mechanical Engineering
%THE HONG KONG POLYTECHNIC UNIVERSITY
%Contact: 20074734d@connect.polyu.hk


function [k, b] = lsqApproximationOverdamped(filename,k,b1)
    % 导入数据
    data = readtable(filename);
    t = data.Time; % 时间数据
    x = data.Distance; % 实际数据
    window_size = 50; % 窗口大小
    x = smooth(x, window_size); % 应用平滑函数window_size = 10; % 窗口大小
    temp2 = min(x);
    x = x-min(x);%Let all the data above 0
    x = x*10^-3+temp2*10^-3;

    x_0 = x(1);
    m = 0.061;
    


    fun = @(p, t)0.5*x_0*(1+p(1)/p(2)).*exp(-1*p(1).*t+p(2).*t) + 0.5*x_0*(1-p(1)/p(2)).*exp(-1*p(1).*t-p(2).*t);
    %exp(sqrt(params(1)^2-a^2))-exp(-1*sqrt(params(1)^2-a^2))
    
    % 初始猜测参数
    params0 = zeros(1,1);
    params0(1) = sqrt((0.1*k/m)^2+(k/m));
    params0(2) = 0.1*k/m;
    
    % 设置最小二乘选项
    options = optimoptions(@lsqcurvefit, 'TolFun', 0.0025, 'TolX', 0.0025);

    % 运行最小二乘算法
    params_fit = lsqcurvefit(fun, params0, t, x, [],[], options);

    % 计算弹性系数和阻尼系数
    k = (params_fit(1)^2-params_fit(2)^2)*m;
    b = params_fit(1)*m*2;

    % 画出拟合曲线和原始数据
    %t_fit = linspace(0, max(t), 1000)';
    %x_fit = fun(params_fit, t_fit);
    %plot(t, x, 'o', t_fit, x_fit, '-')
    %xlabel('Time (s)')
    %ylabel('Distance (m)')
    %legend('Measured Data', 'Fitted Curve')
    b = b-b1;
end
