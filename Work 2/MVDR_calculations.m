function [SINR_dB,Dtheta_matrix,SLL_dB] = MVDR_calculations (W_MVDR,A,AF_normalized,theta_values,theta_array,SNR,signal_power,M,N)
% This function calculates SINR, Dtheta and Side Lobe Level

%% SINR
noise_variance = signal_power / (10^(SNR/10));
R_nn = noise_variance*eye(M);
R_gigi = eye(size(A,2)-1); 
    
a_d = A(:,1);
A_i = A(:,2:end);

SINR = (signal_power * W_MVDR' * a_d * a_d' * W_MVDR) / (W_MVDR' * A_i * R_gigi * A_i' * W_MVDR + W_MVDR' * R_nn * W_MVDR);
SINR_dB = real(10*log10(SINR));


%% Dtheta
Dtheta_matrix = zeros(2,N+1);

[peaks,positions_peaks] = findpeaks(AF_normalized,theta_values);
[peaks_sorted,index_sort] = sort(peaks,'descend');
positions_peaks_sorted = positions_peaks(index_sort);

theta0_final = positions_peaks_sorted(1);
Dtheta0 = abs(theta_array(1) - theta0_final);
Dtheta_matrix(1,1) = theta_array(1);
Dtheta_matrix(2,1) = Dtheta0;

[~,positions_mins] = findpeaks(-AF_normalized,theta_values);
index = 2;
sz = size(positions_mins,2);

i = 1;

pos_min_round = positions_mins(i);
pos_min_next = positions_mins(i+1);
   
while(1)
   if pos_min_round < theta_array(index) 
        if pos_min_next < theta_array(index) 
            if i+1<sz
                i = i + 1;
                pos_min_round = positions_mins(i);
                pos_min_next = positions_mins(i+1);
            else
                Dtheta_matrix(1,index) = theta_array(index);
                Dtheta_matrix(2,index) = abs(theta_array(index) - positions_mins(i+1));
                break
            end
        else 
            d1 = abs(theta_array(index) - pos_min_round);
            d2 = abs(theta_array(index) - pos_min_next);
            Dtheta_matrix(1,index) = theta_array(index);
            if d1<d2
                Dtheta_matrix(2,index) = d1;
            else
                Dtheta_matrix(2,index) = d2;
            end
            if index == N+1
                break
            else
                index = index + 1;
            end
        end
   else
        Dtheta_matrix(1,index) = theta_array(index);
        Dtheta_matrix(2,index) = abs(theta_array(index) - pos_min_round);
        if index == N+1
            break
        else
            index = index + 1;
        end
   end
end
   
%% Side Lobe Level
main_lobe = peaks_sorted(1);
max_side_lobe = peaks_sorted(2);

SLL = max_side_lobe / main_lobe;
SLL_dB = 20*log10(SLL);

end