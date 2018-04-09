function impred = runPatch( net, imlow, gpu, rf )
%RUNPATCH Summary of this function goes here
%   Detailed explanation goes here
v = ceil(size(imlow, 1)/2);
h = ceil(size(imlow, 2)/2);

%% 1 -> 4
[TL, BL, TR, BR ] = divTo4(imlow, rf);

%% TL 4 -> 16
[TL_TL, TL_BL, TL_TR, TL_BR ] = divTo4(TL, rf);

%% TL 16 -> 64
[TL_TL_TL, TL_TL_BL, TL_TL_TR, TL_TL_BR ] = divTo4(TL_TL, rf);
[TL_BL_TL, TL_BL_BL, TL_BL_TR, TL_BL_BR ] = divTo4(TL_BL, rf);

end

