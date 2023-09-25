function theta_array = create_theta_array (delta)
% This function creates all possible pairs of theta angles for given delta

theta0 = 30;
i = 1;

theta_array = [];

while (i)
    if (theta0+5*delta <= 150)
        theta_array(i,:) =  [theta0 theta0+delta theta0+2*delta theta0+3*delta theta0+4*delta theta0+5*delta];
        theta_array(i+1,:) =  [theta0+delta theta0 theta0+2*delta theta0+3*delta theta0+4*delta theta0+5*delta];
        theta_array(i+2,:) =  [theta0+2*delta theta0 theta0+delta theta0+3*delta theta0+4*delta theta0+5*delta];
        theta_array(i+3,:) =  [theta0+3*delta theta0 theta0+delta theta0+2*delta theta0+4*delta theta0+5*delta];
        theta_array(i+4,:) =  [theta0+4*delta theta0 theta0+delta theta0+2*delta theta0+3*delta theta0+5*delta];
        theta_array(i+5,:) =  [theta0+5*delta theta0 theta0+delta theta0+2*delta theta0+3*delta theta0+4*delta];
        
        theta0 = theta0 + 1;
    else
        break
    end
    
    i = i + 6;
end

end