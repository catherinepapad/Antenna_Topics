%% Setup 
clear
clc
close all

if exist('AoAdev_SINR_SLL.txt' , 'file')
    fclose('all');
    delete AoAdev_SINR_SLL.txt
end
    
%% Input Data
M = 24;             % number of antenna array elements
signal_power = 1;   % power of incoming signals (W)

delta = 8;          % delta parameter (degrees)
SNR = 20;           % signal to noise ratio (dB)


%% Create theta array 
theta_array = create_theta_array (delta);
n = size(theta_array,1);

%% Repeat process for all sets of angles
for k=1:1:n
    %disp(k)
    
    % Run MVDR algorithm 
    theta_array_round = theta_array(k,:);
    N = size(theta_array_round,2) - 1;

    [W_MVDR,A,AF_normalized,theta_values] = MVDR_beamformer(theta_array_round,delta,SNR,signal_power,M,N);
   
    [SINR_dB,Dtheta_matrix,SLL_dB] = MVDR_calculations (W_MVDR,A,AF_normalized,theta_values,theta_array_round,SNR,signal_power,M,N);
    
    % Save data to txt file
    data = zeros(1,(N+1)*2+2); 

    for i=1:1:2
        for j=1:N+1
           data((i-1)*(N+1)+j) = Dtheta_matrix(i,j);
        end
    end
    data(2*(N+1)+1) = SINR_dB;
    data(2*(N+1)+2) = SLL_dB;

    if exist('AoAdev_SINR_SLL.txt' , 'file')
        fileID = fopen('AoAdev_SINR_SLL.txt','a+');
        fprintf(fileID,'\n%i %i %i %i %i %i %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f',data);
    else
        fileID = fopen('AoAdev_SINR_SLL.txt','w');
        fprintf(fileID,'%i %i %i %i %i %i %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f',data);
    end
    
end

fclose(fileID);
results_matrix = importdata('AoAdev_SINR_SLL.txt');
[statistics] = statistical_analysis (results_matrix);
disp(['SNR = ', num2str(SNR), ' , delta = ', num2str(delta), ' , Statistics:'])
disp(statistics)