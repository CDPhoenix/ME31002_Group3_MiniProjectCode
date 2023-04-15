



dataset1 = readtable('TripleLight.csv');
dataset2 = readtable('DoubleLight.csv');
dataset3 = readtable('oneLight_oneTight.csv');
dataset4 = readtable('Overdamped.csv');

m = 61*10^-3;

Filename1 = 'TripleLight.csv';
Filename2 = 'DoubleLight.csv';
Filename3 = 'oneLight_oneTight.csv';
Filename4 = 'Overdamped.csv';



TolFun = 2.5*1e-3;%instead of default values, 1e-6
TolX = 2.5*1e-3;
flag = 1;

[F1,k1,b1] = lsqApproximation(Filename1,TolFun,TolX,flag);
[F2,k2,b2] = lsqApproximation(Filename2,TolFun,TolX,flag);
[F3,k3,b3] = lsqApproximation(Filename3,TolFun,TolX,flag);

if flag == 1

    [K1,K2,b] = parametersFind(F1,F2,F3,m);

elseif flag == 2

    K1 = k1/3;
    K2 = k3-K1;
    b = (b1+b2+b3)/3;

end



[s1,G1] = SIMULATION(dataset1,K1*3,m,b);
[s2,G2] = SIMULATION(dataset2,K1*2,m,b);
[s3,G3] = SIMULATION(dataset3,K1+K2,m,b);


[K,b1] = lsqApproximationOverdamped(Filename4,K1*2,b);

[s4,G4] = SIMULATION(dataset4,K1*2,m,b1);


function [K1,K2,b] = parametersFind(F1,F2,F3,m)
    K1 = 4*pi^2*m*F1^2 - 4*pi^2*m*F2^2;
    K2 = 4*pi^2*m*(F3^2+F1^2) - 8*pi^2*m*F2^2;
    b1 = sqrt(3*m*K1 - 4*pi^2*m^2*F1^2);
    b2 = sqrt(2*m*K1 - 4*pi^2*m^2*F2^2);
    b3 = sqrt((K1+K2)*m - 4*pi^2*m^2*F3^2);
    b = (b1 + b2 + b3)/3;
    %b = 0.75*b1 + 0.125*b2 + 0.125*b3;
    %b = b1;
end

function [s,G] = SIMULATION(dataset,k,m,b)
    t1 = dataset.Time;
    %t1 = t1-t1(1);
    x1 = dataset.Distance;
    x1 = x1*10^-3;

    x_0 = x1(1);%x1(1);

    if x_0 == 0
        G = tf(1,[m,b,k]);
        [y,t] = impulse(G);
    else

        G = tf([m*x_0,b*x_0],[m,b,k]);

        [y,t] = impulse(G);
    
    end
    s = pole(G);
    x1 = x1*1000;
    y = y*1000;
    x1 = x1(1:round(length(x1)/2));
    t1 = linspace(0,t(end)+1,size(x1,1));
    figure()
    plot(t1,x1);
    hold on
    plot(t,y);
    title('Time Respone');
    grid on
    x0 = 10;
    y0 = 10;
    width=850;
    height=600;
    set(gcf,'position',[x0,y0,width,height])
    xlabel('Time (s)')
    ylabel('Distance (m)')
    legend('Measured Data', 'Simulation Curve')
    


end




