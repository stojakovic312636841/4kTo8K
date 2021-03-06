close all;
clear all;

tic;
%! ffmpeg -i /media/iqiyi/6CE89A13E899DBA0/SR/bwbj/sample-059.mkv -r 25 -pix_fmt yuv444p /media/iqiyi/6CE89A13E899DBA0/SR/bwbj/gt_1min_444.yuv

run('matconvnet/matlab/vl_setupnn.m');
addpath('util/');

outDir = 'result'; % output directory
data = 'gt';%'Set5';%'myself';     % test data (directory) which is in data folder 
SF = 2;            % test scale factors. can be 2, 3 or 4
%outRoute = fullfile(outDir, data, ['VDSR_x',num2str(SF)]);
outRoute = '/media/iqiyi/6CE89A13E899DBA0/SR/bwbj/';
if ~exist(outRoute, 'dir')
    mkdir(outRoute);
end

fprintf('start\n');

%VDSR(data, SF, 'VDSR.mat', outRoute);
%VDSR_test(data, SF, 'VDSR.mat', outRoute);
YUV_VDSR_test(data, SF, 'VDSR.mat', outRoute);

fprintf('GOOD GAME\n');

! ffmpeg -s 3840x2076 -r 25 -pix_fmt yuv444p  -i /media/iqiyi/6CE89A13E899DBA0/SR/bwbj/output.yuv -r 25 -b 51000k -pix_fmt yuv420p /media/iqiyi/6CE89A13E899DBA0/SR/bwbj/out_1min.mp4

fprintf('HAVE A NICE DAY--> %f\n',toc);
