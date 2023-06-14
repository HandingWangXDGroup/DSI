function [lu] = problemsetting_cec2017(problem,n)

  switch problem

        case 1  % each case represents a different benchmark function
          
          % the lower boundary of the tested function
           minVar=-100*ones(1,n);
           
          % the upper boundary of the tested function
           maxVar=100*ones(1,n);
           
        case 2
            
           minVar=-100*ones(1,n);
           maxVar=100*ones(1,n);
           
        case 3

           minVar=-100*ones(1,n);
           maxVar=100*ones(1,n);

        case 4

           minVar=-10*ones(1,n);
           maxVar=10*ones(1,n);

        case 5

           minVar=-10*ones(1,n);
           maxVar=10*ones(1,n);

        case 6

           minVar=-20*ones(1,n);
           maxVar=20*ones(1,n);

        case 7

           minVar=-50*ones(1,n);
           maxVar=50*ones(1,n);

        case 8
            
           minVar=-100*ones(1,n);
           maxVar=100*ones(1,n);
           
        case 9

           minVar=-10*ones(1,n);
           maxVar=10*ones(1,n);

        case 10

           minVar=-100*ones(1,n);
           maxVar=100*ones(1,n);

        case 11

           minVar=-100*ones(1,n);
           maxVar=100*ones(1,n);

        case 12

           minVar=-100*ones(1,n);
           maxVar=100*ones(1,n);
           
        case 13

           minVar=-100*ones(1,n);
           maxVar=100*ones(1,n);

        case 14

           minVar=-100*ones(1,n);
           maxVar=100*ones(1,n);

        case 15

           minVar=-100*ones(1,n);
           maxVar=100*ones(1,n);

        case 16

           minVar=-100*ones(1,n);
           maxVar=100*ones(1,n);

        case 17

           minVar=-100*ones(1,n);
           maxVar=100*ones(1,n);

        case 18

           minVar=-100*ones(1,n);
           maxVar=100*ones(1,n);
                   
        case 19

           minVar=-50*ones(1,n);
           maxVar=50*ones(1,n);
                   
        case 20

           minVar=-100*ones(1,n);
           maxVar=100*ones(1,n);
                   
        case 21

           minVar=-100*ones(1,n);
           maxVar=100*ones(1,n);
                   
        case 22

           minVar=-100*ones(1,n);
           maxVar=100*ones(1,n);
                   
        case 23

           minVar=-100*ones(1,n);
           maxVar=100*ones(1,n);
                   
        case 24

           minVar=-100*ones(1,n);
           maxVar=100*ones(1,n);
                   
        case 25

           minVar=-100*ones(1,n);
           maxVar=100*ones(1,n);
                   
        case 26

           minVar=-100*ones(1,n);
           maxVar=100*ones(1,n);
                   
        case 27

           minVar=-100*ones(1,n);
           maxVar=100*ones(1,n);
                   
        case 28

           minVar=-50*ones(1,n);
           maxVar=50*ones(1,n);
  end
  
  lu = [minVar;maxVar];
end