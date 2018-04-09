close all;
clear all;

run('matconvnet/matlab/vl_setupnn.m');
addpath('util/');

outDir = 'result'; % output directory
data = 'myself';%'Set5';%'myself';     % test data (directory) which is in data folder 
SF = 2;            % test scale factors. can be 2, 3 or 4
outRoute = fullfile(outDir, data, ['VDSR_x',num2str(SF)]);

if ~exist(outRoute, 'dir')
    mkdir(outRoute);
end

fprintf('start\n');

tic;
%VDSR(data, SF, 'VDSR.mat', outRoute);
VDSR_test(data, SF, 'VDSR.mat', outRoute);
toc;
