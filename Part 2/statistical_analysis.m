function [statistics] = statistical_analysis (results_matrix)
% This function calculates statistical measures

statistics = zeros(1,16);

%% Dtheta0
statistics(1) = min(results_matrix(:,7));
statistics(2) = max(results_matrix(:,7));
statistics(3) = mean(results_matrix(:,7));
statistics(4) = std(results_matrix(:,7));

%% Dtheta
Dtheta = [results_matrix(:,8) results_matrix(:,9) results_matrix(:,10) results_matrix(:,11) results_matrix(:,12)];
Dtheta = reshape(Dtheta,[],1);
statistics(5) = min(Dtheta);
statistics(6) = max(Dtheta);
statistics(7) = mean(Dtheta);
statistics(8) = std(Dtheta);

%% SINR
statistics(9) = min(results_matrix(:,13));
statistics(10) = max(results_matrix(:,13));
statistics(11) = mean(results_matrix(:,13));
statistics(12) = std(results_matrix(:,13));

%% SLL
statistics(13) = min(results_matrix(:,14));
statistics(14) = max(results_matrix(:,14));
statistics(15) = mean(results_matrix(:,14));
statistics(16) = std(results_matrix(:,14));
