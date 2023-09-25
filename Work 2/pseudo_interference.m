function [theta_array_pseudo] = pseudo_interference (theta_array,positions_peaks,N,M,SNR)
% This function adds pseudo interference signals 

theta_array_pseudo = theta_array;

if SNR > 0
    for i=2:1:4  
        theta_array_pseudo = [theta_array_pseudo positions_peaks(i)]; 
    end
else
    for i=2:1:M-N  
        theta_array_pseudo = [theta_array_pseudo positions_peaks(i)]; 
    end
end

