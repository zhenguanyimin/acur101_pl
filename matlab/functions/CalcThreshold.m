function [hististMaxIndex, threshold,noiseMag] = CalcThreshold(histBuff,meanNoiseBuff)
global HIST_THRESHOLD_GUARD  RDM_MAG_PER_HIST_BIN_EXP RANGE_BIN_ENABLE;%%3(3������ȣ�3*3.0103dB),256

% rangeBins = size(histBuff,1);
rangeBins = RANGE_BIN_ENABLE;%%ֻ��ǰ512bin����ֵ��CFAR
histBin = size(histBuff,2);
hististMaxIndex = zeros(rangeBins,1);
threshold = zeros(rangeBins,1);
noiseMag = zeros(rangeBins,1);
noiseIdxList = 3:histBin;%%��ֵ��С������(��1-2��)������������

for i = 1:rangeBins
    [~,iMaxIndex] = max(histBuff(i,noiseIdxList));
    hististMaxIndex(i) = noiseIdxList(iMaxIndex);
    threshold(i) = (hististMaxIndex(i)-1 + HIST_THRESHOLD_GUARD) * RDM_MAG_PER_HIST_BIN_EXP;%%����+9dB�����(10*log10)
    
    if (meanNoiseBuff(i,hististMaxIndex(i)) ~=0)
        noiseMag(i) = meanNoiseBuff(i,hististMaxIndex(i));
    else
        noiseMag(i) = (hististMaxIndex(i)-1) *RDM_MAG_PER_HIST_BIN_EXP;
    end
end

end