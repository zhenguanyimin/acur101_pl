function [hististMaxIndex, threshold,noiseMag] = CalcThreshold(histBuff,meanNoiseBuff)
global HIST_THRESHOLD_GUARD  RDM_MAG_PER_HIST_BIN_EXP RANGE_BIN_ENABLE;%%3(3格信噪比，3*3.0103dB),256

% rangeBins = size(histBuff,1);
rangeBins = RANGE_BIN_ENABLE;%%只对前512bin做阈值及CFAR
histBin = size(histBuff,2);
hististMaxIndex = zeros(rangeBins,1);
threshold = zeros(rangeBins,1);
noiseMag = zeros(rangeBins,1);
noiseIdxList = 3:histBin;%%幅值较小的区域(第1-2列)不参与底噪计算

for i = 1:rangeBins
    [~,iMaxIndex] = max(histBuff(i,noiseIdxList));
    hististMaxIndex(i) = noiseIdxList(iMaxIndex);
    threshold(i) = (hististMaxIndex(i)-1 + HIST_THRESHOLD_GUARD) * RDM_MAG_PER_HIST_BIN_EXP;%%底噪+9dB信噪比(10*log10)
    
    if (meanNoiseBuff(i,hististMaxIndex(i)) ~=0)
        noiseMag(i) = meanNoiseBuff(i,hististMaxIndex(i));
    else
        noiseMag(i) = (hististMaxIndex(i)-1) *RDM_MAG_PER_HIST_BIN_EXP;
    end
end

end