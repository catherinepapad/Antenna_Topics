function [W_MVDR,A,AF_normalized,theta_values] = MVDR_beamformer(theta_array,delta,SNR,signal_power,M,N)
% This function implemets the minimum variance distortionless responce beamformer

%% MVDR implementation
bd = pi;            %beta*d
noise_variance = signal_power / (10^(SNR/10));

R_nn = noise_variance*eye(M);
R_gg = signal_power*eye(N+1); 

a_d = zeros(M,1);
a_i = zeros(M,1);
A = zeros(M,N+1);

for k=0:1:M-1
    a_d(k+1) = exp(1i*bd*k*cos(deg2rad(theta_array(1))));
end

A(:,1) = a_d;

for j=2:1:N+1 
    for k=0:1:M-1
        a_i(k+1) = exp(1i*bd*k*cos(deg2rad(theta_array(j))));
    end 
    A(:,j) = a_i;
end

R_xx = A*R_gg*A' + R_nn;
R_xx_inv = inv(R_xx);

W_MVDR = (R_xx_inv * a_d) / (a_d' * R_xx_inv * a_d);

%% Array Factor
a = [];
theta_values = (0:0.1:180);
cos_theta = cos(deg2rad(theta_values));

for k=0:1:M-1
    a(k+1,:) = exp(1i*bd*k.*cos_theta);
end

AF = abs(W_MVDR' * a);

AF_normalized = normalize(AF,'range');

% figure
% plot(theta_values,AF_normalized)
% xlabel('$\theta^o$','interpreter','latex','FontSize',12)
% ylabel('Normalized $|AF(\theta)|$','interpreter','latex','FontSize',12)
% sgtitle({'Normalized Radiation Pattern';'Without pseudo-interference signals'},'Interpreter', 'latex','FontSize',12)
% txt = ['\theta_0 = ',num2str(theta_array(1)),'^o , \theta_1 = ',num2str(theta_array(2)),'^o , \theta_2 = ',num2str(theta_array(3)),'^o , \theta_3 = ',num2str(theta_array(4)),'^o , \theta_4 = ',num2str(theta_array(5)),'^o , \theta_5 = ',num2str(theta_array(6)),'^o'];
% text(85,0.97,txt)

%% Check Whether to Proceed or Not
if delta <= 6 && SNR > 0
    return
end

%% Pseudo Interferences
[peaks,positions_peaks] = findpeaks(AF_normalized,theta_values);
    
[~,index_sort] = sort(peaks,'descend');
positions_peaks_sorted = positions_peaks(index_sort);

[theta_array_pseudo] = pseudo_interference (theta_array,positions_peaks_sorted,N,M,SNR);

%% MVDR Again 
n = size(theta_array_pseudo,2);
A = zeros(M,n);
R_gg = signal_power*eye(n);

for k=0:1:n-1
    a_d(k+1) = exp(1i*bd*k*cos(deg2rad(theta_array_pseudo(1))));
end

A(:,1) = a_d;

for j=2:1:n 
    for k=0:1:M-1
        a_i(k+1) = exp(1i*bd*k*cos(deg2rad(theta_array_pseudo(j))));
    end 
    A(:,j) = a_i;
end

R_xx = A*R_gg*A' + R_nn;
R_xx_inv = inv(R_xx);

W_MVDR = (R_xx_inv * a_d) / (a_d' * R_xx_inv * a_d);

%% Array Factor Again 
AF = abs(W_MVDR' * a);
AF_normalized = normalize(AF,'range');

% figure
% plot(theta_values,AF_normalized)
% xlabel('$\theta^o$','interpreter','latex','FontSize',12)
% ylabel('Normalized $|AF(\theta)|$','interpreter','latex','FontSize',12)
% sgtitle({'Normalized Radiation Pattern';'With pseudo-interference signals'},'Interpreter', 'latex','FontSize',12)
% txt = ['\theta_0 = ',num2str(theta_array(1)),'^o , \theta_1 = ',num2str(theta_array(2)),'^o , \theta_2 = ',num2str(theta_array(3)),'^o , \theta_3 = ',num2str(theta_array(4)),'^o , \theta_4 = ',num2str(theta_array(5)),'^o , \theta_5 = ',num2str(theta_array(6)),'^o'];
% text(85,0.97,txt)

end