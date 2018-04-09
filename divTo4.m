function [ TL, BL, TR, BR ] = divTo4( imlow ,rf )
%DIVTO4 Summary of this function goes here
%   Detailed explanation goes here
v = ceil(size(imlow, 1)/2);
h = ceil(size(imlow, 2)/2);

TL = imlow(1:v+rf,   1:h+rf);
BL = imlow(v-rf+1:end, 1:h+rf); 
TR = imlow(1:v+rf,   h-rf+1:end);
BR = imlow(v-rf+1:end, h-rf+1:end);

end

