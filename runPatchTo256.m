function impred = runPatchTo256( net, imlow, gpu, rf )
%RUNPATCHTO64 Summary of this function goes here
%   Detailed explanation goes here
v = ceil(size(imlow, 1)/2);
h = ceil(size(imlow, 2)/2);

%% 64->256
im_4_TL = imlow(1:v+rf,   1:h+rf);
im_4_BL = imlow(v-rf+1:end, 1:h+rf); 
im_4_TR = imlow(1:v+rf,   h-rf+1:end);
im_4_BR = imlow(v-rf+1:end, h-rf+1:end);

%% 64->256*4
if gpu, im_4_TL = gpuArray(im_4_TL); end;
impred_4_TL = runPatchVDSR(net, im_4_TL, gpu,rf);
impred_4_TL = impred_4_TL(1:v, 1:h);

if gpu, im_4_BL = gpuArray(im_4_BL); end;
impred_4_BL = runPatchVDSR(net, im_4_BL, gpu,rf);
impred_4_BL = impred_4_BL(rf+1:end, 1:h);

if gpu, im_4_TR = gpuArray(im_4_TR); end;
impred_4_TR = runPatchVDSR(net, im_4_TR, gpu,rf);
impred_4_TR = impred_4_TR(1:v, rf+1:end);

if gpu, im_4_BR = gpuArray(im_4_BR); end;
impred_4_BR = runPatchVDSR(net, im_4_BR, gpu,rf);
impred_4_BR = impred_4_BR(rf+1:end, rf+1:end);

impredL = cat(1, impred_4_TL, impred_4_BL);
impredR = cat(1, impred_4_TR, impred_4_BR);
impred = cat(2, impredL, impredR);


fprintf('runPatchTo256...\n');

end

