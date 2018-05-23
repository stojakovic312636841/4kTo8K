function YUV_VDSR_test( datasetName, SF, model, outRoute )
%YUV_VDSR_TEST Summary of this function goes here
%   Detailed explanation goes here

%% 读取模型
if isempty(model)
    error('no model');
else
    modelPath = ['VDSR model/',model];
    gpu = 2;
end

fprintf('load model...\n');
tic;
model = load(modelPath);
toc;

net = model.net;
net = vl_simplenn_tidy(net);

managableMax = 300000;


%% 读取YUV文件夹
dataDir = '/media/iqiyi/6CE89A13E899DBA0/SR/bwbj/';
f_lst = dir(fullfile(dataDir, '*_444*.yuv'));

fprintf('load dir...\n');
fprintf('sum yuv_file is %d...\n',numel(f_lst));

%% 创建一个YUV大文件
fod = fopen(fullfile(outRoute, 'output.yuv'),'w');


%% 对YUV文件进行处理
for f_iter = 1:numel(f_lst)
    
    %% 读取单一yuv文件
    f_info = f_lst(f_iter);
    if f_info.isdir, continue; end   
    %输出文件名称
    fullfile(dataDir, f_info.name)
    %读取YUV文件
    fid = fopen(fullfile(dataDir, f_info.name),'r');
    
    %图像的高、宽
    row=1038;
    col=1920; 
    %序列的帧数
    frames=25*70;
    
    %% 开始读入YUV数据
    fprintf('read movie...\n');
    
    for frame=1:frames        
        fprintf('read image_%d...\n',frame);
        
        %% 输入的yuv文件为4:4:4
        im_l_y = zeros(row,col); %Y
        for i1 = 1:row 
           im_l_y(i1,:) = fread(fid,col);  %读取数据到矩阵中 
        end

        im_l_cb = zeros(row,col); %cb
        for i2 = 1:row
           im_l_cb(i2,:) = fread(fid,col);  
        end

        im_l_cr = zeros(row,col); %cr
        for i3 = 1:row
           im_l_cr(i3,:) = fread(fid,col);  
        end
        
        %由于输入的yuv文件为4:4:4，所以CbCr要改变大小        
        im = zeros([row, col, 3]);
        im(:, :, 1) = im_l_y;
        im(:, :, 2) = im_l_cb;
        im(:, :, 3) = im_l_cr;      
        
        %Y,cb,cr层变大两倍,SF之后可以和残差相加  
        imlow = single(im)/255;
        imlow = imresize(imlow, SF, 'bicubic'); 
       
        
        %% YUV文件码流变成像素点 
        imlowy = imlow(:,:,1);
        imlowy = max(16.0/255, min(235.0/255, imlowy));
        imlowcb = imlow(:,:,2);
        imlowcr = imlow(:,:,3);
        
        %% 
        tic;
        if size(imlowy,1)*size(imlowy,2) > managableMax  
            fprintf('run in...\n');
            impred = runPatchTo16(net, imlowy, gpu, 0);
            %impred = runPatchTo256(net, imlowy, gpu,0);
        else
            if gpu, imlowy = gpuArray(imlowy); end;
            impred = runVDSR(net, imlowy, gpu);
        end
        toc;

        %% VDSR之后的YUV        
        impredColor = uint8(cat(3,impred',imlowcb',imlowcr')*255);
        
        %验证正确与否
        if 0
            figure(1);
            imshow(ycbcr2rgb(impredColor)); %将YCbCr转换为rgb    
        end
          
        
        %% YUV该合成为大文件yuv444p
        fwrite(fod,impredColor,'uint8');  %输出到文件中
       
        
    end   
    
end

fclose(fod);
fclose(fid);
end

