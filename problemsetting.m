function [lu, n, aaa, m] = problemsetting(problem)


switch problem
    case 1
        % lu: define the upper and lower bounds of the variables
        lu = [0 0 0 0 0 0 0 0 0 0 0 0 0;  1 1 1 1 1 1 1 1 1 100 100 100 1];
        % n: define the dimension of the problem
        n = 13; aaa = []; %\\\\-15\
        m=9; % the number of constraint
    case 2
        lu = [zeros(1, 20); 10 * ones(1, 20)];
        n = 20; aaa = []; %\\\-0.803619\
        m=2; % the number of constraint
    case 3
        lu = [zeros(1, 10); ones(1, 10)];
        n = 10; aaa = []; %\\\-1\
        m=1; % the number of constraint
    case 4
        lu = [78 33 27 27 27; 102 45 45 45 45];
        n = 5; aaa = []; %-30665.539\
        m=6; % the number of constraint
    case 5
        lu = [0 0 -0.55 -0.55; 1200 1200 0.55 0.55];
        n = 4; aaa = []; %\\5126.4981\
        m=5; % the number of constraint
    case 6
        lu = [13 0; 100 100];
        n = 2; aaa = []; %\\-6961.81388\
        m=2; % the number of constraint
    case 7
        lu = [-10 * ones(1, 10); 10 * ones(1, 10)];
        n = 10; aaa = []; %\\24.306\
        m=8; % the number of constraint
        Xstar=[2.17199634142692, 2.3636830416034,8.77392573913157, 5.09598443745173, 0.990654756560493, 1.43057392853463, 1.32164415364306,9.82872576524495, 8.2800915887356, 8.3759266477347];
    case 8
        lu = [0 0; 10 10];
        n = 2; aaa = []; %\0.095825\
        m=2; % the number of constraint
    case 9
        lu = [-10 -10 -10 -10 -10 -10 -10; 10 10 10 10 10 10 10];
        n = 7; aaa = []; %\680.6300573\
        m=4; % the number of constraint
    case 10
        lu = [100 1000 1000 10 10 10 10 10; 10000 10000 10000 1000 1000 1000 1000 1000];
        n = 8; aaa = []; %\7049.2480\
        m=6; % the number of constraint
    case 11
        lu = [-1 -1; 1 1];
        n = 2; aaa = []; %\\0.75\
        m=1; % the number of constraint
    case 12
        lu = [0 0 0; 10 10 10];
        n = 3; %\\-1\
        l = 1;
        for i = 1:9
            for j = 1:9
                for k = 1:9
                    aaa(l, :) = [i j k];
                    l = l+1;
                end
            end
        end
        m=1; % the number of constraint
    case 13
        lu = [-2.3 -2.3 -3.2 -3.2 -3.2; 2.3 2.3 3.2 3.2 3.2];
        n = 5; aaa = []; %\0.0539498\
        m=3; % the number of constraint
    case 14
        lu = [zeros(1, 10);  10 * ones(1, 10)];
        n = 10; aaa = []; %\-47.7648884595\
        m=3; % the number of constraint
    case 15
        lu = [zeros(1, 3); 10 * ones(1, 3)];
        n = 3; aaa = []; %\961.7150222899\
        m=2; % the number of constraint
    case 16
        lu = [704.4148 68.6 0 193 25; 906.3855 288.88 134.75 287.0966 84.1988];
        n = 5; aaa = []; %\-1.9051552586\
        m=38; % the number of constraint
    case 17
        lu = [0 0 340 340 -1000 0;  400 1000 420 420 1000 0.5236];
        n = 6; aaa = []; %\8853.5396748064\
        m=4; % the number of constraint
    case 18
        lu = [-10 -10 -10 -10 -10 -10 -10 -10 0;  10 10 10 10 10 10 10 10 20];
        n = 9; aaa = []; %\-0.8660254038\
        m=13; % the number of constraint
    case 19
        lu = [zeros(1, 15);  10 * ones(1, 15)];
        n = 15; aaa = []; %\32.6555929502\
        m=5; % the number of constraint
    case 20
        lu = [zeros(1, 24); 10 * ones(1, 24)];
        n = 24; aaa = []; %\0.2049794002\
        m=14; % the number of constraint
    case 21
        lu = [0 0 0 100 6.3 5.9 4.5; 1000 40 40 300 6.7 6.4 6.25];
        n = 7; aaa = []; %\193.7245100700\
        m=5; % the number of constraint
    case 22
        lu = [0 0 0 0 0 0 0 100 100 100.01 100 100 0 0 0  0.01 0.01 -4.7 -4.7 -4.7 -4.7 -4.7; 20000 10^6 10^6 10^6 4 * 10^7 ...
            4 * 10^7 4 * 10^7 299.99 399.99 300 400 600 500 500 500 300 400 6.25 6.25 6.25 6.25 6.25];
        n = 22; aaa = []; %\236.4309755040\
        m=19; % the number of constraint
    case 23
        lu = [0 0 0 0 0 0 0 0 0.01;  300 300 100 200 100 300 100 200 0.03];
        n = 9; aaa = []; %\-400.0551000000\
        m=4; % the number of constraint
    case 24
        lu = [0 0;  3 4];
        n = 2; aaa = []; %\-5.5080132716\
        m=2; % the number of constraint
end
end