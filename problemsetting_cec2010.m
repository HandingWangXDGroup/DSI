function [lu] = problemsetting_cec2010(problem,n)

        switch problem

            case 1
                minVar = zeros(1,n);
                maxVar = 10*ones(1,n);
                lu = [minVar;maxVar];

            case 2

                minVar=-5.12*ones(1,n);
                maxVar=5.12*ones(1,n);
                lu = [minVar;maxVar];
                
            case 3

                minVar=-1000*ones(1,n);
                maxVar=1000*ones(1,n);
                lu = [minVar;maxVar];

            case 4

                minVar=-50*ones(1,n);
                maxVar=50*ones(1,n);
                lu = [minVar;maxVar];

            case 5

                minVar=-600*ones(1,n);
                maxVar=600*ones(1,n);
                lu = [minVar;maxVar];

            case 6

                minVar=-600*ones(1,n);
                maxVar=600*ones(1,n);
                lu = [minVar;maxVar];

            case 7

                minVar=-140*ones(1,n);
                maxVar=140*ones(1,n);
                lu = [minVar;maxVar];

            case 8

                minVar=-140*ones(1,n);
                maxVar=140*ones(1,n);
                lu = [minVar;maxVar];

            case 9

                minVar=-500*ones(1,n);
                maxVar=500*ones(1,n);
                lu = [minVar;maxVar];

            case 10

                minVar=-500*ones(1,n);
                maxVar=500*ones(1,n);
                lu = [minVar;maxVar];

            case 11

                minVar=-100*ones(1,n);
                maxVar=100*ones(1,n);
                lu = [minVar;maxVar];

            case 12

                minVar=-1000*ones(1,n);
                maxVar=1000*ones(1,n);
                lu = [minVar;maxVar];
            case 13

                minVar=-500*ones(1,n);
                maxVar=500*ones(1,n);
                lu = [minVar;maxVar];

            case 14

                minVar=-1000*ones(1,n);
                maxVar=1000*ones(1,n);
                lu = [minVar;maxVar];

            case 15

                minVar=-1000*ones(1,n);
                maxVar=1000*ones(1,n);
                lu = [minVar;maxVar];

            case 16

                minVar=-10*ones(1,n);
                maxVar=10*ones(1,n);
                lu = [minVar;maxVar];

            case 17

                minVar=-10*ones(1,n);
                maxVar=10*ones(1,n);
                lu = [minVar;maxVar];

            case 18

                minVar=-50*ones(1,n);
                maxVar=50*ones(1,n);
                lu = [minVar;maxVar];
        end




end