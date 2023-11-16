function [histBuff, meanNoiseBuff] = CalcHistogram(rdmapData,histogram_col)

rangeBins=size(rdmapData,1);
dopplerBins=size(rdmapData,2);
histBuff=zeros(rangeBins,histogram_col);
sumNoiseBuff = zeros(rangeBins,histogram_col);
meanNoiseBuff = zeros(rangeBins,histogram_col);

for i = 1:rangeBins
    for j = 1:dopplerBins
        colHist = floor(rdmapData(i,j)/256) + 1;
%         colHist = floor(rdmapData(i,j)/768) + 1;
%         colHist = floor(rdmapData(i,j)/256/log2(rangeBins/histogram_col)) + 1;
        histBuff(i,colHist) = histBuff(i,colHist) + 1;
        sumNoiseBuff(i,colHist) = sumNoiseBuff(i,colHist) + rdmapData(i,j);
    end
    
    for j = 1:histogram_col
        if (histBuff(i,j) > 0)
            meanNoiseBuff(i,j) = sumNoiseBuff(i,j)/histBuff(i,j);
        end
    end
end

end