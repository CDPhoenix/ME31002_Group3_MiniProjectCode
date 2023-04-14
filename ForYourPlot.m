dataset1 = readtable('Triple_light1.csv');
dataset2 = readtable('Double_light1.csv');
dataset3 = readtable('oneLight_oneTight1.csv');


t1 = dataset1.Time;
t2 = dataset2.Time;
t3 = dataset3.Time;

x1 = dataset1.Distance;
x2 = dataset2.Distance;
x3 = dataset3.Distance;

figure(1)
plot(t1,x1);

figure(2)
plot(t2,x2);

figure(3)
plot(t3,x3);

