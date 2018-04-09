function impred = runPatchTo64( net, imlow, gpu, rf )
%RUNPATCHTO64 Summary of this function goes here
%   Detailed explanation goes here
v = ceil(size(imlow, 1)/2);
h = ceil(size(imlow, 2)/2);

%% 4->16
im_4_TL = imlow(1:v+rf,   1:h+rf);
im_4_BL = imlow(v-rf+1:end, 1:h+rf); 
im_4_TR = imlow(1:v+rf,   h-rf+1:end);
im_4_BR = imlow(v-rf+1:end, h-rf+1:end);

%% 16 -> 64
impredTL = runPatchTo256(net, im_4_TL, gpu, rf);
impredBL = runPatchTo256(net, im_4_BL, gpu, rf);
impredTR = runPatchTo256(net, im_4_TR, gpu, rf);
impredBR = runPatchTo256(net, im_4_BR, gpu, rf);

impredL = cat(1, impredTL, impredBL);
impredR = cat(1, impredTR, impredBR);
impred = cat(2, impredL, impredR);

fprintf('runPatchTo64...\n');

end

