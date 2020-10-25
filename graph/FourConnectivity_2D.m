%TODO: Currently doesn't work with non-integer dx, dy, probably because of
%comparison of floats...maybe find some way to incorporate tolerance in
%goal?
function [names,states] = FourConnectivity_2D(state,dx,dy)
    states = {[state(1)+dx,state(2)   ],...
              [state(1)-dx,state(2)   ],...
              [state(1),   state(2)+dy],...
              [state(1),   state(2)-dy]};
    names = cell(1,length(states));
    for i=1:length(states)
        names{i} = ['(' num2str(states{i}(1)) ',' num2str(states{i}(2)) ')'];
    end
end