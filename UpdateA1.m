function [A1] = UpdateA1(A,popsize)


pop = A.D;
pop_obj = A.F; % objective value
pop_vlt = A.cV; % CV
pop_G = A.C;  % constraint value

[n_pop, ~] = size(pop);

for i = 1:(n_pop-1)
    for j = 1:(n_pop-i)
        if pop_vlt(j) > pop_vlt(j+1)
            temp_ind = pop(j,:);
            temp_obj = pop_obj(j,:);
            temp_vlt = pop_vlt(j,:);
            temp_G = pop_G(j,:);

            pop(j,:) = pop(j+1,:);
            pop_obj(j,:) = pop_obj(j+1,:);
            pop_vlt(j,:) = pop_vlt(j+1,:);
            pop_G(j,:) = pop_G(j+1,:);

            pop(j+1,:) = temp_ind;
            pop_obj(j+1,:) = temp_obj;
            pop_vlt(j+1,:) = temp_vlt;

            pop_G(j+1,:) = temp_G;
        elseif pop_vlt(j) == pop_vlt(j+1)
            if pop_obj(j) > pop_obj(j+1)
                temp_ind = pop(j,:);
                temp_obj = pop_obj(j,:);
                temp_vlt = pop_vlt(j,:);
                temp_G = pop_G(j,:);


                pop(j,:) = pop(j+1,:);
                pop_obj(j,:) = pop_obj(j+1);
                pop_vlt(j,:) = pop_vlt(j+1,:);
                pop_G(j,:) = pop_G(j+1,:);

                pop(j+1,:) = temp_ind;
                pop_obj(j+1,:) = temp_obj;
                pop_vlt(j+1,:) = temp_vlt;
                pop_G(j+1,:) = temp_G;
            end
        end
    end


end

A1.D = pop(1:popsize,:);
A1.F = pop_obj(1:popsize,:);
A1.cV = pop_vlt(1:popsize,:);
A1.C = pop_G(1:popsize,:);
end