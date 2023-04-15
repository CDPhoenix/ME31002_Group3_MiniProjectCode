%ME31002 MiniProject
%WANG Dapeng Phoenix 20074734d Department of Mechanical Engineering
%THE HONG KONG POLYTECHNIC UNIVERSITY
%Contact: 20074734d@connect.polyu.hk


%data = readtable('2DOF_TripleLightANDoneTight');
%data = readtable('2DOF_OnedampedOneosci');

Filename1 = '2DOF_TripleLightANDoneTight';
Filename2 = 'Test_2.csv';
Filename3 = '2DOF_TWOOverdamped';
Filename4 = 'Test_with_mouse';
Filename5 = 'Test_without_mouse_hardspring';
m1 = 61*10^-3;
m2 = 61*10^-3;
b1 = 1.3 + 16.4;
b2= 1.3+16.4;
k1 = 139;
k2 = 43;
k3 = 43*3;
[G4,s4] = TwoDOF_Simulation(Filename3,m1,m2,k1,k2,k3,b1,b2);

function [G,s] = TwoDOF_Simulation(Filename,m1,m2,k1,k2,k3,b1,b2)
    data = readtable(Filename);

    t = data.Time;
    t = linspace(0,t(end),size(t,1));
    y = data.Distance;
    y = y*10^-3;
    x1 = y(1);
    x2 = -20*10^-3;
    
    G1 = tf([m1*x1,b1*x1],[m1,b1,k1+k2]);
    G2= tf([m2*x2,b2*x2],[m2,b2,k3+k2]);
    G3 = tf(k2,[m1,b1,k1+k2]);
    G4 = tf(k2,[m2,b1,k3+k2]);
    
    G = (G1+G2*G3)/(1-G3*G4);
    s = pole(G);
    [y1,t1] = impulse(G);
    figure()
    plot(t,y)
    hold on
    plot(t1,y1)
    grid on
    x0 = 10;
    y0 = 10;
    width=850;
    height=600;
    set(gcf,'position',[x0,y0,width,height])
    G_1 = (G4*G1+G2)/(1-G3*G4);
    figure()
    impulse(G_1);
    figure()
    pzmap(G_1)

end
