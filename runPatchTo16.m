function impred = runPatchTo16( net, imlow, gpu, rf )
%RUNPATCHTO16 Summary of this function goes here
%   Detailed explanation goes here
v = ceil(size(imlow, 1)/2);
h = ceil(size(imlow, 2)/2);

%% 1-->4
imTL = imlow(1:v+rf,   1:h+rf);
imBL = imlow(v-rf+1:end, 1:h+rf); 
imTR = imlow(1:v+rf,   h-rf+1:end);
imBR = imlow(v-rf+1:end, h-rf+1:end);


%% 4->16
if 0
im_4_TL = imTL(1:v+rf,   1:h+rf);
im_4_BL = imTL(v-rf+1:end, 1:h+rf); 
im_4_TR = imTL(1:v+rf,   h-rf+1:end);
im_4_BR = imTL(v-rf+1:end, h-rf+1:end);

if gpu, im_4_TL = gpuArray(im_4_TL); end;
impred_4_TL = runVDSR(net, im_4_TL, gpu);
impred_4_TL = impred_4_TL(1:v, 1:h);

if gpu, im_4_BL = gpuArray(im_4_BL); end;
impred_4_BL = runVDSR(net, im_4_BL, gpu);
impred_4_BL = impred_4_BL(rf+1:end, 1:h);

if gpu, im_4_TR = gpuArray(im_4_TR); end;
impred_4_TR = runVDSR(net, im_4_TR, gpu);
impred_4_TR = impred_4_TR(1:v, rf+1:end);

if gpu, im_4_BR = gpuArray(im_4_BR); end;
impred_4_BR = runVDSR(net, im_4_BR, gpu);
impred_4_BR = impred_4_BR(rf+1:end, rf+1:end);

impredL = cat(1, impred_4_TL, impred_4_BL);
impredR = cat(1, impred_4_TR, impred_4_BR);
impred = cat(2, impredL, impredR);
end

%% 4->64
impredTL = runPatchTo64(net, imTL, gpu, rf);
impredBL = runPatchTo64(net, imBL, gpu, rf);
impredTR = runPatchTo64(net, imTR, gpu, rf);
impredBR = runPatchTo64(net, imBR, gpu, rf);

impredL = cat(1, impredTL, impredBL);
impredR = cat(1, impredTR, impredBR);
impred = cat(2, impredL, impredR);


fprintf('runPatchTo16...\n');
end

