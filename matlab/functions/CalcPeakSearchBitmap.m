function [peakBitmap,peakNum]=CalcPeakSearchBitmap(rdmapData, threshold)
global  RANGE_BIN_ENABLE

PS_RANGE_START_INDEX=4+1;
peakNum=0;
rangeBins=size(rdmapData,1);
dopplerBins=size(rdmapData,2);
peakBitmap=zeros(rangeBins,dopplerBins);
rangeBinEnable = RANGE_BIN_ENABLE;

for i=PS_RANGE_START_INDEX:rangeBinEnable
    for j=2:dopplerBins-1
        if (rdmapData(i,j) > threshold(i) &&  ...
                rdmapData(i,j) > rdmapData(i,j-1) && rdmapData(i,j)>rdmapData(i,j+1))
            if (i > 1 && i < rangeBinEnable)
                if (rdmapData(i,j) > rdmapData(i-1,j) && rdmapData(i,j) > rdmapData(i+1,j))
                    peakBitmap(i,j) = 1;
                    peakNum = peakNum + 1;
                end
            elseif (i == 1)
                if (rdmapData(i,j) > rdmapData(i+1,j))
                    peakBitmap(i,j) = 1;
                    peakNum = peakNum + 1;
                end
            elseif (i == rangeBinEnable)
                 if (rdmapData(i,j) > rdmapData(i-1,j))
                    peakBitmap(i,j) = 1;
                    peakNum = peakNum + 1;
                end
            end
        end        
    end  
%     if(rdmapData(i,1)>rdmapData(i,dopplerBins)&&rdmapData(i,1)>rdmapData(i,2)&&rdmapData(i,1)>threshold(i))
%         if(i>1&&i<rangeBins)
%             if(rdmapData(i,1)>rdmapData(i-1,1)&&rdmapData(i,1)>rdmapData(i+1,1))
%                 peakBitmap(i,1)=1;
%                 peakNum=peakNum+1;
%             end
%         elseif i==1
%             if(rdmapData(i,1)>rdmapData(i+1,1))
%                 peakBitmap(i,1)=1;
%                 peakNum=peakNum+1;
%             end
%         elseif i==rangeBins
%              if(rdmapData(i,1)>rdmapData(i-1,1))
%                 peakBitmap(i,1)=1;
%                 peakNum=peakNum+1;
%             end
%         end
%     end

%     if(rdmapData(i,dopplerBins)>rdmapData(i,1)&&rdmapData(i,dopplerBins)>rdmapData(i,dopplerBins-1)&&...
%             rdmapData(i,dopplerBins)>threshold(i))
%         if(i>1&&i<rangeBins)
%             if(rdmapData(i,dopplerBins)>rdmapData(i-1,dopplerBins)&&rdmapData(i,dopplerBins)>rdmapData(i+1,dopplerBins))
%                 peakBitmap(i,dopplerBins)=1;
%                 peakNum=peakNum+1;
%             end
%         elseif i==1
%             if(rdmapData(i,dopplerBins)>rdmapData(i+1,dopplerBins))
%                 peakBitmap(i,dopplerBins)=1;
%                 peakNum=peakNum+1;
%             end
%         elseif i==rangeBins
%              if(rdmapData(i,dopplerBins)>rdmapData(i-1,dopplerBins))
%                 peakBitmap(i,dopplerBins)=1;
%                 peakNum=peakNum+1;
%             end
%         end
%     end
end

end