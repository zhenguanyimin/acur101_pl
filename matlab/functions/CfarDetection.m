%V0.0  初始版本
function [Target_Para, target_num, PeakTarget_Para] = CfarDetection(rdmapData, peakBitmap, threshold, noiseMag)
global HIST_THRESHOLD_GUARD  RDM_MAG_PER_HIST_BIN_EXP 

rCFARmode = 1;%%距离维CFAR类型：1:CA，2：OS，3：GO
dCFARmode = 1;%%速度维CFAR类型：1:CA，2：GO

%%%%%%%%%%%%%%%CFAR Params%%%%%%%%%%%%%%%
%%1700/256*3.0103,18*256/3.0103
%%2211(25.9991dB，26),2126(24.9996dB,25),2048(24.0824dB,24),1956(23.0006dB,23),1871(22.0011dB,22),1785(20.9898dB,21),1700(19.9903dB,20)
%%1615(18.9908dB,19),1530(17.9912dB,18),1445(16.9917dB,17)，1360(15.9922dB,16)，1275(14.9927dB,15),1190(13.9932dB,14)
%%1105(12.9937dB,13),1020(11.9942dB,12),935(10.9947dB,11),850(9.9951dB,10),765(8.9956dB,9),681(8.0079dB,8)


%%%%%%%%%%%%%%%CFAR Params%%%%%%%%%%%%%%%
% %%%%1017阳台山测试优化-1020测试OK版本
% CFAR_RANGE_THRESHOLD_SEG_1ST = 2048;    %/* cfar range threshold segment 1st, 24 */
% CFAR_RANGE_THRESHOLD_SEG_2ND = 1275;   %/* cfar range threshold segment 2nd, 15 */ 
% CFAR_RANGE_THRESHOLD_SEG_3RD = 1020;    %/* cfar range threshold segment 3rd, 12 */
% CFAR_RANGE_THRESHOLD_SEG_4TH = 935;      %/* cfar range threshold segment 4th, 11 */
% CFAR_RANGE_THRESHOLD_SEG_5TH = 7650;      %/* cfar range threshold segment 5th, 90 */
% CFAR_RANGE_THRESHOLD_SEG_6TH = 7650;      %/* cfar range threshold segment 5th, 90 */
% 
% CFAR_DOPPLER_THRESHOLD_SEG_1ST = 1700;  %/* cfar doppler threshold segment 1st, 20 */
% CFAR_DOPPLER_THRESHOLD_SEG_2ND = 1105; %/* cfar doppler threshold segment 2nd, 13 */
% CFAR_DOPPLER_THRESHOLD_SEG_3RD = 935;  %/* cfar doppler threshold segment 3rd, 11 */
% CFAR_DOPPLER_THRESHOLD_SEG_4TH = 850;  %/* cfar doppler threshold segment 4th, 10 */
% CFAR_DOPPLER_THRESHOLD_SEG_5TH = 9350;    %/* cfar doppler threshold segment 5yh, 110 */
% CFAR_DOPPLER_THRESHOLD_SEG_6TH = 9350;    %/* cfar doppler threshold segment 5yh, 110 */
% 
% CFAR_GLOBAL_THRESHOLD_SEG_1ST = 1275;	%/* cfar global threshold segment 1st, 15 */
% CFAR_GLOBAL_THRESHOLD_SEG_2ND = 1105;	%/* cfar global threshold segment 2nd, 13 */
% CFAR_GLOBAL_THRESHOLD_SEG_3RD = 1020;	%/* cfar global threshold segment 3rd, 12 */
% CFAR_GLOBAL_THRESHOLD_SEG_4TH = 850;		%/* cfar global threshold segment 4th, 10 */
% CFAR_GLOBAL_THRESHOLD_SEG_5TH = 7650;	%/* cfar global threshold segment 5th, 110 */
% CFAR_GLOBAL_THRESHOLD_SEG_6TH = 7650;	%/* cfar global threshold segment 6th, 110 */

% %%%%1021演示版本
% CFAR_RANGE_THRESHOLD_SEG_1ST = 1871;    %/* cfar range threshold segment 1st, 22 */
% CFAR_RANGE_THRESHOLD_SEG_2ND = 1105;   %/* cfar range threshold segment 2nd, 13 */ 
% CFAR_RANGE_THRESHOLD_SEG_3RD = 935;    %/* cfar range threshold segment 3rd, 11 */
% CFAR_RANGE_THRESHOLD_SEG_4TH = 850;      %/* cfar range threshold segment 4th, 10 */
% CFAR_RANGE_THRESHOLD_SEG_5TH = 7650;      %/* cfar range threshold segment 5th, 90 */
% CFAR_RANGE_THRESHOLD_SEG_6TH = 7650;      %/* cfar range threshold segment 5th, 90 */
% 
% CFAR_DOPPLER_THRESHOLD_SEG_1ST = 1615;  %/* cfar doppler threshold segment 1st, 19 */
% CFAR_DOPPLER_THRESHOLD_SEG_2ND = 1020; %/* cfar doppler threshold segment 2nd, 12 */
% CFAR_DOPPLER_THRESHOLD_SEG_3RD = 850;  %/* cfar doppler threshold segment 3rd, 10 */
% CFAR_DOPPLER_THRESHOLD_SEG_4TH = 765;  %/* cfar doppler threshold segment 4th, 9 */
% CFAR_DOPPLER_THRESHOLD_SEG_5TH = 9350;    %/* cfar doppler threshold segment 5yh, 110 */
% CFAR_DOPPLER_THRESHOLD_SEG_6TH = 9350;    %/* cfar doppler threshold segment 5yh, 110 */
% 
% CFAR_GLOBAL_THRESHOLD_SEG_1ST = 1190;	%/* cfar global threshold segment 1st, 14 */
% CFAR_GLOBAL_THRESHOLD_SEG_2ND = 1020;	%/* cfar global threshold segment 2nd, 12 */
% CFAR_GLOBAL_THRESHOLD_SEG_3RD = 935;	%/* cfar global threshold segment 3rd, 11 */
% CFAR_GLOBAL_THRESHOLD_SEG_4TH = 765;		%/* cfar global threshold segment 4th, 9 */
% CFAR_GLOBAL_THRESHOLD_SEG_5TH = 7650;	%/* cfar global threshold segment 5th, 90 */
% CFAR_GLOBAL_THRESHOLD_SEG_6TH = 7650;	%/* cfar global threshold segment 6th, 90 */
% 
% RANGE_CUT_INDEX_1ST          = 2;		 %/* rangeBin cut index 1st, 2*/
% RANGE_CUT_INDEX_2ND         = 10;		%/* rangeBin cut index 2nd, 10*/
% RANGE_CUT_INDEX_3RD          = 40;		%/* rangeBin cut index 3rd, 120,32,38,40*/
% RANGE_CUT_INDEX_4TH          = 54;		%/* rangeBin cut index 4th, 54*/
% RANGE_CUT_INDEX_5TH          = 150;		%/* rangeBin cut index 5th,72,270,150*/
% RANGE_CUT_INDEX_6TH	         = 430;		%/* rangeBin cut index 6th, 430*/

% %%%%第二版硬件，20230109测试版本，SNR(*)/3.01*256
% CFAR_RANGE_THRESHOLD_SEG_1ST = 1871;    %/* cfar range threshold segment 1st, 22 */
% CFAR_RANGE_THRESHOLD_SEG_2ND = 1105;    %/* cfar range threshold segment 2nd, 13 */ 
% CFAR_RANGE_THRESHOLD_SEG_3RD = 1020;    %/* cfar range threshold segment 3rd, 12 */
% CFAR_RANGE_THRESHOLD_SEG_4TH = 1020;    %/* cfar range threshold segment 4th, 12 */
% CFAR_RANGE_THRESHOLD_SEG_5TH = 7650;    %/* cfar range threshold segment 5th, 90 */
% CFAR_RANGE_THRESHOLD_SEG_6TH = 7650;    %/* cfar range threshold segment 5th, 90 */
% 
% CFAR_DOPPLER_THRESHOLD_SEG_1ST = 1615;  %/* cfar doppler threshold segment 1st, 19 */
% CFAR_DOPPLER_THRESHOLD_SEG_2ND = 1020;  %/* cfar doppler threshold segment 2nd, 12 */
% CFAR_DOPPLER_THRESHOLD_SEG_3RD = 935;   %/* cfar doppler threshold segment 3rd, 11 */
% CFAR_DOPPLER_THRESHOLD_SEG_4TH = 935;   %/* cfar doppler threshold segment 4th, 11 */
% CFAR_DOPPLER_THRESHOLD_SEG_5TH = 8500;  %/* cfar doppler threshold segment 5yh, 100 */
% CFAR_DOPPLER_THRESHOLD_SEG_6TH = 8500;  %/* cfar doppler threshold segment 5yh, 100 */
% 
% CFAR_GLOBAL_THRESHOLD_SEG_1ST = 1190;	%/* cfar global threshold segment 1st, 14 */
% CFAR_GLOBAL_THRESHOLD_SEG_2ND = 1020;	%/* cfar global threshold segment 2nd, 12 */
% CFAR_GLOBAL_THRESHOLD_SEG_3RD = 1020;	%/* cfar global threshold segment 3rd, 12 */
% CFAR_GLOBAL_THRESHOLD_SEG_4TH = 935;	%/* cfar global threshold segment 4th, 11 */
% CFAR_GLOBAL_THRESHOLD_SEG_5TH = 7650;	%/* cfar global threshold segment 5th, 90 */
% CFAR_GLOBAL_THRESHOLD_SEG_6TH = 7650;	%/* cfar global threshold segment 6th, 90 */
% 
% RANGE_CUT_INDEX_1ST          = 2;		 %/* rangeBin cut index 1st, 2(6m)*/
% RANGE_CUT_INDEX_2ND         = 10;		%/* rangeBin cut index 2nd, 10(30m)*/
% RANGE_CUT_INDEX_3RD          = 50;		%/* rangeBin cut index 3rd, 50(150m)*/
% RANGE_CUT_INDEX_4TH          = 100;		%/* rangeBin cut index 4th, 100(300m)*/
% RANGE_CUT_INDEX_5TH          = 234;		%/* rangeBin cut index 5th,234(702m)*/
% RANGE_CUT_INDEX_6TH	         = 430;		%/* rangeBin cut index 6th, 430*/

% %%%%第二版硬件，中频20230111测试版本，SNR(*)/3.01*256
% CFAR_RANGE_THRESHOLD_SEG_1ST = 1871;    %/* cfar range threshold segment 1st, 22 */
% CFAR_RANGE_THRESHOLD_SEG_2ND = 1105;    %/* cfar range threshold segment 2nd, 13 */ 
% CFAR_RANGE_THRESHOLD_SEG_3RD = 1020;    %/* cfar range threshold segment 3rd, 12 */
% CFAR_RANGE_THRESHOLD_SEG_4TH = 935;    %/* cfar range threshold segment 4th, 11 */
% CFAR_RANGE_THRESHOLD_SEG_5TH = 7650;    %/* cfar range threshold segment 5th, 90 */
% CFAR_RANGE_THRESHOLD_SEG_6TH = 7650;    %/* cfar range threshold segment 5th, 90 */
% 
% CFAR_DOPPLER_THRESHOLD_SEG_1ST = 1615;  %/* cfar doppler threshold segment 1st, 19 */
% CFAR_DOPPLER_THRESHOLD_SEG_2ND = 1020;  %/* cfar doppler threshold segment 2nd, 12 */
% CFAR_DOPPLER_THRESHOLD_SEG_3RD = 935;   %/* cfar doppler threshold segment 3rd, 11 */
% CFAR_DOPPLER_THRESHOLD_SEG_4TH = 935;   %/* cfar doppler threshold segment 4th, 11 */
% CFAR_DOPPLER_THRESHOLD_SEG_5TH = 8500;  %/* cfar doppler threshold segment 5yh, 100 */
% CFAR_DOPPLER_THRESHOLD_SEG_6TH = 8500;  %/* cfar doppler threshold segment 5yh, 100 */
% 
% CFAR_GLOBAL_THRESHOLD_SEG_1ST = 1190;	%/* cfar global threshold segment 1st, 14 */
% CFAR_GLOBAL_THRESHOLD_SEG_2ND = 1020;	%/* cfar global threshold segment 2nd, 12 */
% CFAR_GLOBAL_THRESHOLD_SEG_3RD = 935;	%/* cfar global threshold segment 3rd, 11 */
% CFAR_GLOBAL_THRESHOLD_SEG_4TH = 935;	%/* cfar global threshold segment 4th, 11 */
% CFAR_GLOBAL_THRESHOLD_SEG_5TH = 7650;	%/* cfar global threshold segment 5th, 90 */
% CFAR_GLOBAL_THRESHOLD_SEG_6TH = 7650;	%/* cfar global threshold segment 6th, 90 */
% 
% RANGE_CUT_INDEX_1ST          = 2;		 %/* rangeBin cut index 1st, 2(6m)*/
% RANGE_CUT_INDEX_2ND          = 10;		%/* rangeBin cut index 2nd, 10(30m)*/
% RANGE_CUT_INDEX_3RD          = 100;		%/* rangeBin cut index 3rd, 100(300m)*/
% RANGE_CUT_INDEX_4TH          = 167;		%/* rangeBin cut index 4th, 167(501m)*/
% RANGE_CUT_INDEX_5TH          = 267;		%/* rangeBin cut index 5th,234(702m),267(801m)*/
% RANGE_CUT_INDEX_6TH	         = 430;		%/* rangeBin cut index 6th, 430*/

% %%%%第二版硬件，中频20230111优化版本，SNR(*)/3.01*256
% CFAR_RANGE_THRESHOLD_SEG_1ST = 1871;    %/* cfar range threshold segment 1st, 22 */
% CFAR_RANGE_THRESHOLD_SEG_2ND = 1105;    %/* cfar range threshold segment 2nd, 13 */ 
% CFAR_RANGE_THRESHOLD_SEG_3RD = 1020;    %/* cfar range threshold segment 3rd, 12 */
% CFAR_RANGE_THRESHOLD_SEG_4TH = 935;    %/* cfar range threshold segment 4th, 11 */
% CFAR_RANGE_THRESHOLD_SEG_5TH = 7650;    %/* cfar range threshold segment 5th, 90 */
% CFAR_RANGE_THRESHOLD_SEG_6TH = 7650;    %/* cfar range threshold segment 5th, 90 */
% 
% CFAR_DOPPLER_THRESHOLD_SEG_1ST = 1615;  %/* cfar doppler threshold segment 1st, 19 */
% CFAR_DOPPLER_THRESHOLD_SEG_2ND = 1020;  %/* cfar doppler threshold segment 2nd, 12 */
% CFAR_DOPPLER_THRESHOLD_SEG_3RD = 935;   %/* cfar doppler threshold segment 3rd, 11 */
% CFAR_DOPPLER_THRESHOLD_SEG_4TH = 935;   %/* cfar doppler threshold segment 4th, 11 */
% CFAR_DOPPLER_THRESHOLD_SEG_5TH = 8500;  %/* cfar doppler threshold segment 5yh, 100 */
% CFAR_DOPPLER_THRESHOLD_SEG_6TH = 8500;  %/* cfar doppler threshold segment 5yh, 100 */
% 
% CFAR_GLOBAL_THRESHOLD_SEG_1ST = 1190;	%/* cfar global threshold segment 1st, 14 */
% CFAR_GLOBAL_THRESHOLD_SEG_2ND = 1020;	%/* cfar global threshold segment 2nd, 12 */
% CFAR_GLOBAL_THRESHOLD_SEG_3RD = 935;	%/* cfar global threshold segment 3rd, 11 */
% CFAR_GLOBAL_THRESHOLD_SEG_4TH = 935;	%/* cfar global threshold segment 4th, 11 */
% CFAR_GLOBAL_THRESHOLD_SEG_5TH = 7650;	%/* cfar global threshold segment 5th, 90 */
% CFAR_GLOBAL_THRESHOLD_SEG_6TH = 7650;	%/* cfar global threshold segment 6th, 90 */
% 
% RANGE_CUT_INDEX_1ST          = 2;		 %/* rangeBin cut index 1st, 2(6m)*/
% RANGE_CUT_INDEX_2ND          = 34;		%/* rangeBin cut index 2nd, 10(102m)*/
% RANGE_CUT_INDEX_3RD          = 134;		%/* rangeBin cut index 3rd, 100(300m), 100(402m)*/
% RANGE_CUT_INDEX_4TH          = 200;		%/* rangeBin cut index 4th, 167(501m), 200(600m)*/
% RANGE_CUT_INDEX_5TH          = 267;		%/* rangeBin cut index 5th,234(702m),267(801m)*/
% RANGE_CUT_INDEX_6TH	         = 430;		%/* rangeBin cut index 6th, 430*/

%%%%第二版硬件，中频20230119惠州测试版本，SNR(*)/3.01*256
CFAR_RANGE_THRESHOLD_SEG_1ST = 1871;    %/* cfar range threshold segment 1st, 22 */
CFAR_RANGE_THRESHOLD_SEG_2ND = 1275;    %/* cfar range threshold segment 2nd, 13 */ 
CFAR_RANGE_THRESHOLD_SEG_3RD = 1020;    %/* cfar range threshold segment 3rd, 12 */
CFAR_RANGE_THRESHOLD_SEG_4TH = 935;    %/* cfar range threshold segment 4th, 11 */
CFAR_RANGE_THRESHOLD_SEG_5TH = 7650;    %/* cfar range threshold segment 5th, 90 */
CFAR_RANGE_THRESHOLD_SEG_6TH = 7650;    %/* cfar range threshold segment 5th, 90 */

CFAR_DOPPLER_THRESHOLD_SEG_1ST = 1615;  %/* cfar doppler threshold segment 1st, 19 */
CFAR_DOPPLER_THRESHOLD_SEG_2ND = 1275;  %/* cfar doppler threshold segment 2nd, 12 */
CFAR_DOPPLER_THRESHOLD_SEG_3RD = 1020;   %/* cfar doppler threshold segment 3rd, 11 */
CFAR_DOPPLER_THRESHOLD_SEG_4TH = 935;   %/* cfar doppler threshold segment 4th, 11 */
CFAR_DOPPLER_THRESHOLD_SEG_5TH = 8500;  %/* cfar doppler threshold segment 5yh, 100 */
CFAR_DOPPLER_THRESHOLD_SEG_6TH = 8500;  %/* cfar doppler threshold segment 5yh, 100 */

CFAR_GLOBAL_THRESHOLD_SEG_1ST = 1190;	%/* cfar global threshold segment 1st, 14 */
CFAR_GLOBAL_THRESHOLD_SEG_2ND = 935;	%/* cfar global threshold segment 2nd, 12 */
CFAR_GLOBAL_THRESHOLD_SEG_3RD = 935;	%/* cfar global threshold segment 3rd, 11 */
CFAR_GLOBAL_THRESHOLD_SEG_4TH = 935;	%/* cfar global threshold segment 4th, 11 */
CFAR_GLOBAL_THRESHOLD_SEG_5TH = 7650;	%/* cfar global threshold segment 5th, 90 */
CFAR_GLOBAL_THRESHOLD_SEG_6TH = 7650;	%/* cfar global threshold segment 6th, 90 */

RANGE_CUT_INDEX_1ST          = 2;		%/* rangeBin cut index 1st 2(6m) */
RANGE_CUT_INDEX_2ND          = 10;		%/* rangeBin cut index 2nd 10(30m) */
RANGE_CUT_INDEX_3RD          = 70;		%/* rangeBin cut index 3rd 100(300m),70(210m) */
RANGE_CUT_INDEX_4TH          = 135;		%/* rangeBin cut index 4th 167(501m),135(405m) */
RANGE_CUT_INDEX_5TH          = 300;		%/* rangeBin cut index 5th 267(801m),234(702m),212(636m),300(900m) */
RANGE_CUT_INDEX_6TH	         = 430;		%/* rangeBin cut index 6th 430(1290m) */

CfarParameter.Guard_Range       =   2;                                     %%距离维 保护单元4
CfarParameter.Win_Range         =   6;                                     %%距离维 参考单元4

CfarParameter.Guard_Doppler     =   4;                                     %%速度维 保护单元4
CfarParameter.Win_Doppler       =   6;                                     %%速度维 参考单元4

CfarParameter.Range_Len         =   size(rdmapData,1);                                   %%距离维阈值长度
% CfarParameter.Range_LenEnable         =   RANGE_BIN_ENABLE;                                   %%距离维阈值长度，只对前512bin做底噪计算及CFAR
CfarParameter.Doppler_Len       =   size(rdmapData,2);                                   %%速度维阈值长度
CfarParameter.OS_RANGE          =   150;                                   %%距离维使用OS CFAR的格数

Os_K                            =   0.5;
CfarParameter.osRangeK          =   floor(Os_K*CfarParameter.Win_Range*2); %%OS CFAR选取估计底噪单元格 %%%%%第K大


% 目标 Range velocity 阈值
gRangeCfarThreshold    = [ CFAR_RANGE_THRESHOLD_SEG_1ST, CFAR_RANGE_THRESHOLD_SEG_2ND, CFAR_RANGE_THRESHOLD_SEG_3RD, CFAR_RANGE_THRESHOLD_SEG_4TH, CFAR_RANGE_THRESHOLD_SEG_5TH, CFAR_RANGE_THRESHOLD_SEG_6TH ];
gDopplerCfarThreshold =  [ CFAR_DOPPLER_THRESHOLD_SEG_1ST, CFAR_DOPPLER_THRESHOLD_SEG_2ND, CFAR_DOPPLER_THRESHOLD_SEG_3RD, CFAR_DOPPLER_THRESHOLD_SEG_4TH, CFAR_DOPPLER_THRESHOLD_SEG_5TH, CFAR_DOPPLER_THRESHOLD_SEG_6TH ];
gGlobalCfarThreshold =  [ CFAR_GLOBAL_THRESHOLD_SEG_1ST, CFAR_GLOBAL_THRESHOLD_SEG_2ND, CFAR_GLOBAL_THRESHOLD_SEG_3RD, CFAR_GLOBAL_THRESHOLD_SEG_4TH, CFAR_GLOBAL_THRESHOLD_SEG_5TH, CFAR_GLOBAL_THRESHOLD_SEG_6TH ];
gRangeBinCutIdx = [ RANGE_CUT_INDEX_1ST, RANGE_CUT_INDEX_2ND, RANGE_CUT_INDEX_3RD, RANGE_CUT_INDEX_4TH, RANGE_CUT_INDEX_5TH, RANGE_CUT_INDEX_6TH ];


nrRangeBins=size(rdmapData,1);
nrDopplerBins=size(rdmapData,2);

ROW_range           =   nrRangeBins;
COL_doppler         =   nrDopplerBins;
target_num          =   0;
Peaktarget_num      =   0;
Target_Para=zeros(5,target_num);
PeakTarget_Para=zeros(4,Peaktarget_num);
% TODO: name of nrRangeBins(not the numbers of range bins)
% BitmapOut_peaksearch=uint32(zeros(nrRangeBins,1));
% matResahpe=reshape(peakBitmap,32,nrRangeBins);  %32*512
% for iCol=1:nrRangeBins 
%     for jRow=1:32
%         if(matResahpe(jRow,iCol)==1)
%             BitmapOut_peaksearch(iCol)= bitset( BitmapOut_peaksearch(iCol),jRow);
%         end
%     end
% end
% BitmapOut_peaksearch_resharp    =   reshape(BitmapOut_peaksearch,1,[]);               %嵌入式不需要  给512*1 转换成1*512行
% inputDetectBitmapSize           =   length(BitmapOut_peaksearch_resharp)/32;          %循环总次数，下面区分动静    16=512/32
BitmapOut_peaksearch_resharp    =   reshape(peakBitmap,1,[]);               %嵌入式不需要  转换成1行*(512*32)列
inputDetectBitmapSize           =   length(BitmapOut_peaksearch_resharp)/32;          %循环总次数，下面区分动静    16=512/32

%%
%%
for  i_BitmapNum=1:inputDetectBitmapSize
    
    i_index     =   i_BitmapNum;
    aux         =   BitmapOut_peaksearch_resharp(32*(i_index-1)+1:32*i_index);
    j_index     =   1;
    aux         =   fliplr(aux);             %高低位互换
    aux_str     =   bin2dec(num2str(aux));   %数组转二进制
    
    
    while (aux_str)
        if (bitget(aux_str,1) && 1)
            
            peakIndex           =   (i_index-1)*32+j_index;
            j_doppler           =   peakIndex / CfarParameter.Range_Len;       
            j_doppler           =   ceil(j_doppler);                            %嵌入式法 0-63
            startIndex_Doppler  =   (j_doppler-1) * CfarParameter.Range_Len;
            i_range             =   peakIndex-startIndex_Doppler;
            
            if i_range>gRangeBinCutIdx(1) && i_range<=gRangeBinCutIdx(2) %%[2,10]bin
                RangeCfarThreshold      =   gRangeCfarThreshold(1);
                DopplerCfarThreshold    =   gDopplerCfarThreshold(1);%%CfarParameter.Range_LenEnable
                GlobalCfarThreshold    =   gGlobalCfarThreshold(1);
                if (rCFARmode == 1)
                    Range_NoiseFloor     =   Range_CACFAR(i_range,CfarParameter.Range_Len,CfarParameter.Win_Range,CfarParameter.Guard_Range,rdmapData(:,j_doppler));
                elseif (rCFARmode == 2)
                    Range_NoiseFloor     =   Range_OSCFAR(i_range,CfarParameter.Range_Len,CfarParameter.Win_Range,CfarParameter.Guard_Range,rdmapData(:,j_doppler),CfarParameter.osRangeK);
                elseif (rCFARmode == 3)
                    Range_NoiseFloor     =   Range_GOCFAR(i_range,CfarParameter.Range_Len,CfarParameter.Win_Range,CfarParameter.Guard_Range,rdmapData(:,j_doppler));
                end

            elseif i_range>gRangeBinCutIdx(6) && i_range<=CfarParameter.Range_Len %%[430,end]bin
                RangeCfarThreshold      =   gRangeCfarThreshold(6);
                DopplerCfarThreshold    =   gDopplerCfarThreshold(6);
                GlobalCfarThreshold    =   gGlobalCfarThreshold(6);
                if (rCFARmode == 1)
                    Range_NoiseFloor     =   Range_CACFAR(i_range,CfarParameter.Range_Len,CfarParameter.Win_Range,CfarParameter.Guard_Range,rdmapData(:,j_doppler));
                elseif (rCFARmode == 2)
                    Range_NoiseFloor     =   Range_OSCFAR(i_range,CfarParameter.Range_Len,CfarParameter.Win_Range,CfarParameter.Guard_Range,rdmapData(:,j_doppler),CfarParameter.osRangeK);
                elseif (rCFARmode == 3)
                    Range_NoiseFloor     =   Range_GOCFAR(i_range,CfarParameter.Range_Len,CfarParameter.Win_Range,CfarParameter.Guard_Range,rdmapData(:,j_doppler));
                end

            elseif i_range>gRangeBinCutIdx(2) && i_range<=gRangeBinCutIdx(3) %%(10, 32]bin
                RangeCfarThreshold      =   gRangeCfarThreshold(2);
                DopplerCfarThreshold    =   gDopplerCfarThreshold(2);
                GlobalCfarThreshold    =   gGlobalCfarThreshold(2);
                if (rCFARmode == 1)
                    Range_NoiseFloor     =   Range_CACFAR(i_range,CfarParameter.Range_Len,CfarParameter.Win_Range,CfarParameter.Guard_Range,rdmapData(:,j_doppler));
                elseif (rCFARmode == 2)
                    Range_NoiseFloor     =   Range_OSCFAR(i_range,CfarParameter.Range_Len,CfarParameter.Win_Range,CfarParameter.Guard_Range,rdmapData(:,j_doppler),CfarParameter.osRangeK);
                elseif (rCFARmode == 3)
                    Range_NoiseFloor     =   Range_GOCFAR(i_range,CfarParameter.Range_Len,CfarParameter.Win_Range,CfarParameter.Guard_Range,rdmapData(:,j_doppler));
                end

            elseif i_range>gRangeBinCutIdx(3) && i_range<=gRangeBinCutIdx(4) %%(32, 54]bin
                RangeCfarThreshold      =   gRangeCfarThreshold(3);
                DopplerCfarThreshold    =   gDopplerCfarThreshold(3);
                GlobalCfarThreshold    =   gGlobalCfarThreshold(3);
                if (rCFARmode == 1)
                    Range_NoiseFloor     =   Range_CACFAR(i_range,CfarParameter.Range_Len,CfarParameter.Win_Range,CfarParameter.Guard_Range,rdmapData(:,j_doppler));
                elseif (rCFARmode == 2)
                    Range_NoiseFloor     =   Range_OSCFAR(i_range,CfarParameter.Range_Len,CfarParameter.Win_Range,CfarParameter.Guard_Range,rdmapData(:,j_doppler),CfarParameter.osRangeK);
                elseif (rCFARmode == 3)
                    Range_NoiseFloor     =   Range_GOCFAR(i_range,CfarParameter.Range_Len,CfarParameter.Win_Range,CfarParameter.Guard_Range,rdmapData(:,j_doppler));
                end
    
            elseif i_range>gRangeBinCutIdx(4) && i_range<=gRangeBinCutIdx(5) %%(54, 72]bin
                RangeCfarThreshold      =   gRangeCfarThreshold(4);
                DopplerCfarThreshold    =   gDopplerCfarThreshold(4);
                GlobalCfarThreshold    =   gGlobalCfarThreshold(4);
                if (rCFARmode == 1)
                    Range_NoiseFloor     =   Range_CACFAR(i_range,CfarParameter.Range_Len,CfarParameter.Win_Range,CfarParameter.Guard_Range,rdmapData(:,j_doppler));
                elseif (rCFARmode == 2)
                    Range_NoiseFloor     =   Range_OSCFAR(i_range,CfarParameter.Range_Len,CfarParameter.Win_Range,CfarParameter.Guard_Range,rdmapData(:,j_doppler),CfarParameter.osRangeK);
                elseif (rCFARmode == 3)
                    Range_NoiseFloor     =   Range_GOCFAR(i_range,CfarParameter.Range_Len,CfarParameter.Win_Range,CfarParameter.Guard_Range,rdmapData(:,j_doppler));
                end

            elseif i_range>gRangeBinCutIdx(5) && i_range<=gRangeBinCutIdx(6)  %%(72, 430]bin
                RangeCfarThreshold      =   gRangeCfarThreshold(5);
                DopplerCfarThreshold    =   gDopplerCfarThreshold(5);
                GlobalCfarThreshold    =   gGlobalCfarThreshold(5);
                if (rCFARmode == 1)
                    Range_NoiseFloor     =   Range_CACFAR(i_range,CfarParameter.Range_Len,CfarParameter.Win_Range,CfarParameter.Guard_Range,rdmapData(:,j_doppler));
                elseif (rCFARmode == 2)
                    Range_NoiseFloor     =   Range_OSCFAR(i_range,CfarParameter.Range_Len,CfarParameter.Win_Range,CfarParameter.Guard_Range,rdmapData(:,j_doppler),CfarParameter.osRangeK);
                elseif (rCFARmode == 3)
                    Range_NoiseFloor     =   Range_GOCFAR(i_range,CfarParameter.Range_Len,CfarParameter.Win_Range,CfarParameter.Guard_Range,rdmapData(:,j_doppler));
                end

            else	  %%[1, 2]bin
                RangeCfarThreshold      =   gRangeCfarThreshold(3);
                DopplerCfarThreshold    =   gDopplerCfarThreshold(3);
                GlobalCfarThreshold    =   gGlobalCfarThreshold(3);
                if (rCFARmode == 1)
                    Range_NoiseFloor     =   Range_CACFAR(i_range,CfarParameter.Range_Len,CfarParameter.Win_Range,CfarParameter.Guard_Range,rdmapData(:,j_doppler));
                elseif (rCFARmode == 2)
                    Range_NoiseFloor     =   Range_OSCFAR(i_range,CfarParameter.Range_Len,CfarParameter.Win_Range,CfarParameter.Guard_Range,rdmapData(:,j_doppler),CfarParameter.osRangeK);
                elseif (rCFARmode == 3)
                    Range_NoiseFloor     =   Range_GOCFAR(i_range,CfarParameter.Range_Len,CfarParameter.Win_Range,CfarParameter.Guard_Range,rdmapData(:,j_doppler));
                end            
            end

            if (dCFARmode == 1)
%                 Doppler_NoiseFloor    =   Doppler_CACFAR(j_doppler,COL_doppler,CfarParameter.Win_Doppler,CfarParameter.Guard_Doppler,rdmapData(i,:));
                Doppler_NoiseFloor   =   Doppler_CACFAR_NEW(j_doppler,COL_doppler,CfarParameter.Win_Doppler,CfarParameter.Guard_Doppler,rdmapData(i_range,:),1);
            elseif (dCFARmode == 2)   
                Doppler_NoiseFloor   =   Doppler_GOCFAR_NEW(j_doppler,COL_doppler,CfarParameter.Win_Doppler,CfarParameter.Guard_Doppler,rdmapData(i_range,:),1);
            end
             %----------------------------------------------------嵌入式不要-------------------------------------------------------------------
                Peaktarget_num=Peaktarget_num+1;
                PeakTarget_Para(1,Peaktarget_num)   =   i_range;
                PeakTarget_Para(2,Peaktarget_num)   =   j_doppler;
                PeakTarget_Para(3,Peaktarget_num)   =   rdmapData(i_range,j_doppler)/256*3.0103;%%幅值 
                PeakTarget_Para(4,Peaktarget_num)   =   (RangeCfarThreshold+Range_NoiseFloor)/256*3.0103;%%距离维幅值阈值
                PeakTarget_Para(5,Peaktarget_num)   =   (DopplerCfarThreshold+Doppler_NoiseFloor)/256*3.0103;%%速度维幅值阈值 
                PeakTarget_Para(6,Peaktarget_num)   =   (rdmapData(i_range,j_doppler)-Range_NoiseFloor)/256*3.0103;%%距离维信噪比  
                PeakTarget_Para(7,Peaktarget_num)   =   (rdmapData(i_range,j_doppler)-Doppler_NoiseFloor)/256*3.0103;%%速度维信噪比                   
                PeakTarget_Para(8,Peaktarget_num)   =   (rdmapData(i_range,j_doppler)-threshold(i_range)+(HIST_THRESHOLD_GUARD-1)*RDM_MAG_PER_HIST_BIN_EXP)/256*3.0103;%%全局信噪比-直方图底噪               
                PeakTarget_Para(9,Peaktarget_num)   =   (rdmapData(i_range,j_doppler)-noiseMag(i_range))/256*3.0103;%%全局信噪比-均值底噪                  
            %-------------------------------------------------------------------------------------------------------------------------------------------------

%             if ((rdmapData(i_range,j_doppler) > (MagThreshold)) && (rdmapData(i_range,j_doppler) > (RangeCfarThreshold+Range_NoiseFloor)) && ((rdmapData(i_range,j_doppler)  > (DopplerCfarThreshold+Doppler_NoiseFloor))))
            if ((rdmapData(i_range,j_doppler) > (RangeCfarThreshold+Range_NoiseFloor)) && ((rdmapData(i_range,j_doppler) > (DopplerCfarThreshold+Doppler_NoiseFloor))) && ((rdmapData(i_range,j_doppler) > (GlobalCfarThreshold + threshold(i_range)-(HIST_THRESHOLD_GUARD-1)*RDM_MAG_PER_HIST_BIN_EXP))) )

                target_num=target_num+1;
                Target_Para(1,target_num)   =   i_range;
                Target_Para(2,target_num)   =   j_doppler;
                Target_Para(3,target_num)   =   rdmapData(i_range,j_doppler)/256*3.0103;%%幅值                 
                Target_Para(4,target_num)   =   (RangeCfarThreshold+Range_NoiseFloor)/256*3.0103;%%距离维幅值阈值
                Target_Para(5,target_num)   =   (DopplerCfarThreshold+Doppler_NoiseFloor)/256*3.0103;%%速度维幅值阈值 
                Target_Para(6,target_num)   =   (rdmapData(i_range,j_doppler)-Range_NoiseFloor)/256*3.0103;%%距离维信噪比  
                Target_Para(7,target_num)   =   (rdmapData(i_range,j_doppler)-Doppler_NoiseFloor)/256*3.0103;%%速度维信噪比   
                Target_Para(8,target_num)   =   (rdmapData(i_range,j_doppler)-threshold(i_range)+(HIST_THRESHOLD_GUARD-1)*RDM_MAG_PER_HIST_BIN_EXP)/256*3.0103;%%全局信噪比-直方图底噪                
                Target_Para(9,target_num)   =   (rdmapData(i_range,j_doppler)-noiseMag(i_range))/256*3.0103;%%全局信噪比-均值底噪 
                                
%                         Indices(i,j)=1;
%                         SNR_Range_Matrix(i,j)=(rdmapData(i,j)-cfarThreshold_Range)*0.0039*3.0103;  
%                         SNR_Doppler_Matrix(i,j)=(rdmapData(i,j)-cfarThreshold_Doppler)*0.0039*3.0103;                 
            end
        end
        j_index=j_index+1;
        aux_str=bitshift(aux_str, -1);
    end 
end

end


%% ==================================== 子函数 ============================================%%
%%%%%%%%%%%%%%%% Range CFAR %%%%%%%%%%%%%%%%%%
function    Range_NoiseFloor_OS = Range_OSCFAR(idx,ROW,CFAR_WINDOW,CFAR_GUARD,RangeData,osRangeK)        
    Range_NoiseFloor_OS=0;
    data_zero=0;
    winsize=CFAR_WINDOW*2;
    value_max = 0;
    max_index=0;
    value_min = 65536;
    min_index=0;
    i_temp=1;
    
  %%  
    if(idx<=CFAR_WINDOW+CFAR_GUARD)                                  %距离维前边缘保护
        if(idx<=CFAR_GUARD+1)                                            %  参考单元不足
            for i=1:winsize                                              %这个可以一个for循环里面存2个点数据，并且比较
                needSortsz(i) = RangeData(idx+CFAR_GUARD+i);
                index_num(i_temp)=idx+CFAR_GUARD+i;                      %记录选取bin格的index
                i_temp=i_temp+1;
                if     needSortsz(i)>value_max                            %比较大小
                        value_max=needSortsz(i);
                        max_index=i;
                elseif needSortsz(i)<value_min
                        value_min=needSortsz(i);
                        min_index=i;
                end
            end
          
        else                                                             %    
            for i=1:winsize                                                                 %这个可以一个for循环里面存2个点数据，并且比较 似乎可以优化，少个判断，有空看
                if     i<=CFAR_GUARD+CFAR_WINDOW+1-idx
                        needSortsz(i) = RangeData(idx+CFAR_GUARD+CFAR_WINDOW+i);
                        index_num(i_temp)=idx+CFAR_GUARD+CFAR_WINDOW+i;                      %记录选取bin格的index
                        i_temp=i_temp+1;
                elseif i<=CFAR_WINDOW
                        needSortsz(i) = RangeData(idx-CFAR_GUARD-CFAR_WINDOW-1+i);
                        index_num(i_temp)=idx-CFAR_GUARD-CFAR_WINDOW-1+i;                    %记录选取bin格的index
                        i_temp=i_temp+1;
                else
                        needSortsz(i) = RangeData(idx+CFAR_GUARD+i-CFAR_WINDOW);
                        index_num(i_temp)=idx+CFAR_GUARD+i-CFAR_WINDOW;                      %记录选取bin格的index
                        i_temp=i_temp+1;
                end    
                if needSortsz(i)>value_max
                    value_max=needSortsz(i);
                    max_index=i;
                elseif needSortsz(i)<value_min
                    value_min=needSortsz(i);
                    min_index=i;
                end
            end
        
        end
        
  %%
    elseif(idx<=ROW && idx>ROW-CFAR_WINDOW-CFAR_GUARD)                     %距离维后边缘保护
       
        if(idx>=ROW-CFAR_GUARD)                                            %  参考单元不足
            for i=1:winsize                                                %这个可以一个for循环里面存2个点数据，并且比较
                needSortsz(i)       = RangeData(idx-CFAR_GUARD-winsize-1+i);
                index_num(i_temp)   = idx-CFAR_GUARD-winsize-1+i;                      %记录选取bin格的index
                i_temp              = i_temp+1;
                if needSortsz(i)>value_max
                    value_max       = needSortsz(i);
                    max_index       = i;
                elseif needSortsz(i)<value_min
                    value_min       = needSortsz(i);
                    min_index       = i;
                end
            end
              
        else                                                             %    
            for i=1:winsize                                                                  %这个可以一个for循环里面存2个点数据，并且比较
                if     i<=ROW-idx-CFAR_GUARD
                        needSortsz(i) = RangeData(idx+CFAR_GUARD+i);
                        index_num(i_temp)=idx+CFAR_GUARD+i;                      %记录选取bin格的index
                        i_temp=i_temp+1;
                else
                        needSortsz(i) = RangeData(idx-CFAR_GUARD-winsize-1+i);
                        index_num(i_temp)=idx-CFAR_GUARD-winsize-1+i;                    %记录选取bin格的index
                        i_temp=i_temp+1;
                end    
                
                if     needSortsz(i)>value_max
                        value_max=needSortsz(i);
                    	max_index=i;
                elseif needSortsz(i)<value_min
                        value_min=needSortsz(i);
                        min_index=i;
                end
            end
            
        end
  %%      
    else                                                                   %非边缘距离点
            for i=1:CFAR_WINDOW                                                %这个可以一个for循环里面存2个点数据，并且比较
                needSortsz(i)              = RangeData(idx-CFAR_GUARD-CFAR_WINDOW-1+i);
                index_num(i)               = idx-CFAR_GUARD-CFAR_WINDOW-1+i;
                needSortsz(i+CFAR_WINDOW)  = RangeData(idx+CFAR_GUARD+i); %记录选取bin格的index
                index_num(i+CFAR_WINDOW)   = idx+CFAR_GUARD+i;                      %记录选取bin格的index
                if needSortsz(i)<=needSortsz(i+CFAR_WINDOW)                
                    if needSortsz(i+CFAR_WINDOW)>value_max
                        value_max=needSortsz(i+CFAR_WINDOW);
                        max_index=i+CFAR_WINDOW;
                    end
                    if needSortsz(i)<value_min
                        value_min=needSortsz(i);
                        min_index=i;
                    end
                else
                    if needSortsz(i)>value_max
                        value_max=needSortsz(i);
                        max_index=i;
                    end
                    if needSortsz(i+CFAR_WINDOW)<value_min
                        value_min=needSortsz(i+CFAR_WINDOW);
                        min_index=i+CFAR_WINDOW;
                    end
                end
            end
            
   %%  
    end
   %% OS排序
% min_index
% max_index
index_num;
needSortsz;        
% ——————————— %嵌入式排序—————————————————————————————         
% %           Range_sort1=needSortsz;
% %            for i=1:winsize-osRangeK+1
% %                for j=i+1:winsize
% %                    if Range_sort1(i)<Range_sort1(j)
% %                     min_temp=Range_sort1(i);
% %                     Range_sort1(i)=Range_sort1(j);
% %                     Range_sort1(j)=min_temp;
% %                    end
% % 
% %                end
% %             end
% %             Range_NoiseFloor_OS1 = Range_sort1(winsize-osRangeK+1)
%————————————————————————————————————————————       
%*****************************************************************************
%————————————————————部分排序————————————————————
        max_temp=needSortsz(1);
        needSortsz(1)=needSortsz(max_index);
        needSortsz(max_index)=max_temp;
        if winsize == 2
            Range_NoiseFloor_OS=needSortsz(winsize);
        else
            if min_index == 1
                min_temp=needSortsz(winsize);
                needSortsz(winsize)=needSortsz(max_index);
                needSortsz(max_index)=min_temp; 
            else
                min_temp=needSortsz(winsize);
                needSortsz(winsize)=needSortsz(min_index);
                needSortsz(min_index)=min_temp; 
            end
            for i=2:winsize-osRangeK+1
               for j=i+1:winsize-1
                   if needSortsz(i)<needSortsz(j)
                    min_temp=needSortsz(i);
                    needSortsz(i)=needSortsz(j);
                    needSortsz(j)=min_temp;
                   end

               end
            end
            Range_NoiseFloor_OS=needSortsz(winsize-osRangeK+1);
        end
%————————————————————————————————————————
end


function    Range_NoiseFloor_CA = Range_CACFAR(idx,ROW,CFAR_WINDOW,CFAR_GUARD,RangeData)    
    Range_NoiseFloor_CA=0;
    data_zero=0;
    winsize=CFAR_WINDOW*2;
    i_temp=1;
    data_sum=0;
  %%  
    if(idx<=CFAR_WINDOW+CFAR_GUARD)                                        %距离维前边缘保护
        if(idx<=CFAR_GUARD+1)                                              %  参考单元不足
            for i=1:winsize                                                %这个可以一个for循环里面存2个点数据，并且比较
                if RangeData(idx+CFAR_GUARD+i) ~= 0
                    data_sum = data_sum+RangeData(idx+CFAR_GUARD+i);
                    index_num(i_temp)=idx+CFAR_GUARD+i;                        %记录选取bin格的index
                    i_temp=i_temp+1;
                end
            end
          
        else                                                               %    
            for i=1:winsize                                                                 %这个可以一个for循环里面存2个点数据，并且比较 似乎可以优化，少个判断，有空看
                if     i<=CFAR_GUARD+CFAR_WINDOW+1-idx
                    if RangeData(idx+CFAR_GUARD+CFAR_WINDOW+i) ~= 0
                        data_sum = data_sum+RangeData(idx+CFAR_GUARD+CFAR_WINDOW+i);
                        index_num(i_temp)=idx+CFAR_GUARD+CFAR_WINDOW+i;                      %记录选取bin格的index
                        i_temp=i_temp+1;
                    end
                elseif i<=CFAR_WINDOW
                    if RangeData(idx-CFAR_GUARD-CFAR_WINDOW-1+i)~=0
                        data_sum =  data_sum+RangeData(idx-CFAR_GUARD-CFAR_WINDOW-1+i);
                        index_num(i_temp)=idx-CFAR_GUARD-CFAR_WINDOW-1+i;                    %记录选取bin格的index
                        i_temp=i_temp+1;
                    end
                else
                    if RangeData(idx+CFAR_GUARD-CFAR_WINDOW+i)~=0
                        data_sum = data_sum+RangeData(idx+CFAR_GUARD-CFAR_WINDOW+i);
                        index_num(i_temp)=idx+CFAR_GUARD-CFAR_WINDOW+i;                      %记录选取bin格的index
                        i_temp=i_temp+1;
                    end
                end    
                
            end
        
        end
        
  %%
    elseif(idx<=ROW && idx>ROW-CFAR_WINDOW-CFAR_GUARD)                     %距离维后边缘保护
        if(idx>=ROW-CFAR_GUARD)                                            %  参考单元不足
            for i=1:winsize                                                %这个可以一个for循环里面存2个点数据，并且比较
                if RangeData(idx-CFAR_GUARD-winsize-1+i)~=0
                    data_sum            = data_sum+RangeData(idx-CFAR_GUARD-winsize-1+i);
                    index_num(i_temp)   = idx-CFAR_GUARD-winsize-1+i;                      %记录选取bin格的index
                    i_temp              = i_temp+1;
                end
            end
              
        else                                                             %    
            for i=1:winsize                                                                  %这个可以一个for循环里面存2个点数据，并且比较
                if     i<=ROW-idx-CFAR_GUARD
                    if RangeData(idx+CFAR_GUARD+i)~=0
                        data_sum            =  data_sum+RangeData(idx+CFAR_GUARD+i);
                        index_num(i_temp)   = idx+CFAR_GUARD+i;                              %记录选取bin格的index
                        i_temp=i_temp+1;
                    end
                else
                    if RangeData(idx-CFAR_GUARD-winsize-1+i)~=0
                        data_sum            = data_sum+ RangeData(idx-CFAR_GUARD-winsize-1+i);
                        index_num(i_temp)   =idx-CFAR_GUARD-winsize-1+i;                    %记录选取bin格的index
                        i_temp=i_temp+1;
                    end
                end    
                
                
            end
            
        end
  %%      
    else                                                                           %非边缘距离点
            for i=1:CFAR_WINDOW                                                    %这个可以一个for循环里面存2个点数据，并且比较
                if RangeData(idx-CFAR_GUARD-CFAR_WINDOW-1+i)~=0
                    data_sum                  = data_sum+RangeData(idx-CFAR_GUARD-CFAR_WINDOW-1+i);
                    index_num(i_temp)              = idx-CFAR_GUARD-CFAR_WINDOW-1+i;
                    i_temp=i_temp+1;
                end
                if RangeData(idx+CFAR_GUARD+i)~=0
                    data_sum                  = data_sum+RangeData(idx+CFAR_GUARD+i); %记录选取bin格的index
                    index_num(i_temp)  = idx+CFAR_GUARD+i;                      %记录选取bin格的index
                    i_temp=i_temp+1;
                end
            end
            
   %%  
    end
    index_num;
    Range_NoiseFloor_CA=data_sum/(i_temp-1);
end


function    Range_NoiseFloor_GO = Range_GOCFAR(idx,ROW,CFAR_WINDOW,CFAR_GUARD,RangeData)    
    Range_NoiseFloor_GO = 0;
    iR_temp = 1;
    iL_temp = 1;
    dataRight_sum = 0;
    dataLift_sum = 0;
  %% （1）距离维前边缘保护，左窗参考单元不足，只取右窗
    if(idx <= CFAR_WINDOW + CFAR_GUARD)                                     %距离维前边缘保护，左窗参考单元不足，只取右窗
        for i = 1:CFAR_WINDOW                                                   %这个可以一个for循环里面存2个点数据，并且比较
            IdxR = idx + CFAR_GUARD + i;  
            if RangeData(IdxR) ~= 0
                dataRight_sum = dataRight_sum + RangeData(IdxR);
                indexR_num(iR_temp) = IdxR;                                 %记录左窗选取bin格的index
                iR_temp = iR_temp + 1;
            end
        end  
  %% （2）距离维后边缘保护，右窗参考单元不足，只取左窗         
    elseif((idx > ROW-CFAR_WINDOW-CFAR_GUARD) && (idx <= ROW))              %距离维后边缘保护，右窗参考单元不足，只取左窗                                      
        for i = 1:CFAR_WINDOW                                               %这个可以一个for循环里面存2个点数据，并且比较
             IdxL = idx - CFAR_GUARD - CFAR_WINDOW - 1 + i;
            if RangeData(IdxL)~=0
                dataLift_sum = dataLift_sum + RangeData(IdxL);
                indexL_num(iL_temp) = IdxL;                                 %记录左窗选取bin格的index
                iL_temp = iL_temp+1;
            end
        end
  %% （3）非边缘距离点，左窗+右窗     
    else                                                                                          %非边缘距离点，左窗+右窗
        for i = 1:CFAR_WINDOW                                                   %这个可以一个for循环里面存2个点数据，并且比较
            IdxR = idx + CFAR_GUARD + i;  
            if (RangeData(IdxR) ~= 0)
                dataRight_sum = dataRight_sum + RangeData(IdxR);
                indexR_num(iR_temp) = IdxR;                                 %记录左窗选取bin格的index
                iR_temp = iR_temp + 1;
            end
            
            IdxL = idx - CFAR_GUARD - CFAR_WINDOW - 1 + i;
            if (RangeData(IdxL)~=0)
                dataLift_sum = dataLift_sum + RangeData(IdxL);
                indexL_num(iL_temp) = IdxL;                                 %记录左窗选取bin格的index
                iL_temp = iL_temp+1;
            end
            
        end              
    end
    
   %% （4）取平均，选大
   if ((iL_temp < 2) && (iR_temp >= 2))
       
       Range_NoiseFloor_GO = dataRight_sum / (iR_temp-1);
       
   elseif ((iL_temp >= 2) && (iR_temp < 2))
       
       Range_NoiseFloor_GO = dataLift_sum / (iL_temp-1);
       
   elseif ((iL_temp >= 2) && (iR_temp >= 2))
       
       tmpR = dataRight_sum / (iR_temp-1);
       tmpL = dataLift_sum / (iL_temp-1);
       if (tmpR > tmpL)
           Range_NoiseFloor_GO = tmpR;
       else
           Range_NoiseFloor_GO = tmpL;
       end
       
   end
   
   
end


%%%%%%%%%%%%%%%% Doppler CFAR %%%%%%%%%%%%%%%%%%
function Doppler_NoiseFloor_CA = Doppler_CACFAR_NEW(idx,COL,CFAR_WINDOW,CFAR_GUARD,DopplerData,RemoveMax_Flag)
    Doppler_NoiseFloor_CA   =   0;
    data_zero               =   0;
    winsize                 =   CFAR_WINDOW*2;
    i_temp                  =   1;
    data_sum                =   0;
    value_max               =   0;
    max_index               =   0;
  %%  
   
       for i=1:CFAR_WINDOW
            index_left=idx-CFAR_GUARD-CFAR_WINDOW+i-1;
            index_right=idx+CFAR_GUARD+i;
 %-------------------------------------------------------------------------           
            if(index_left<=0)
                index_left=index_left+COL;
            end
            
            if(index_right>COL)
                index_right=index_right-COL;
            end
 %-------------------------------------------------------------------------           
            if DopplerData(index_left)~=0
                data_sum            = data_sum+ DopplerData(index_left);
                index_num(i_temp)   = index_left;                    %记录选取bin格的index
                i_temp=i_temp+1;
            end   
            if DopplerData(index_right)~=0
                data_sum            = data_sum+ DopplerData(index_right);
                index_num(i_temp)   = index_right;                    %记录选取bin格的index
                i_temp=i_temp+1;
            end
%-----------------------------------------------------------------------          
            if DopplerData(index_left) >= DopplerData(index_right)
                if DopplerData(index_left)  >   value_max
                    value_max   =   DopplerData(index_left);
                    max_index   =   index_left;
                end            
            else
                if DopplerData(index_right)  >   value_max
                    value_max   =   DopplerData(index_right);
                    max_index   =   index_right;
                end           
            end
    
       end
       
       
       if RemoveMax_Flag
        
        Doppler_NoiseFloor_CA      =  (data_sum-value_max)/(i_temp-2);
        
       else
           
        Doppler_NoiseFloor_CA      =  data_sum/(i_temp-1);

       end
 
    index_num;
end


function Doppler_NoiseFloor_GO = Doppler_GOCFAR_NEW(idx,COL,CFAR_WINDOW,CFAR_GUARD,DopplerData,RemoveMax_Flag)
    Doppler_NoiseFloor_CA   =   0;
    iR_temp = 1;
    iL_temp = 1;
    dataRight_sum = 0;
    dataLift_sum = 0;
    valueR_max = 0;
    valueL_max = 0;
    maxR_index = 0;
    maxL_index = 0;
    
  %%  （1）（翻转）左窗+右窗   
   for i = 1:CFAR_WINDOW
        index_left = idx - CFAR_GUARD - CFAR_WINDOW - 1 + i;
        index_right = idx + CFAR_GUARD + i;
%-------------------------------------------------------------------------           
        if (index_left <= 0)
            index_left = index_left + COL;
        end

        if(index_right > COL)
            index_right = index_right - COL;
        end
%-------------------------------------------------------------------------           
        if (DopplerData(index_left) ~= 0)
            dataLift_sum = dataLift_sum + DopplerData(index_left);
            indexL_num(iL_temp) = index_left;                    %记录选取bin格的index
            iL_temp = iL_temp + 1;
        end  
        
        if (DopplerData(index_right) ~= 0)
            dataRight_sum = dataRight_sum + DopplerData(index_right);
            indexR_num(iR_temp) = index_right;                    %记录选取bin格的index
            iR_temp = iR_temp + 1;
        end
%-----------------------------------------------------------------------          
        if (DopplerData(index_left) > valueL_max)
            valueL_max = DopplerData(index_left);
            maxL_index = index_left;
        end            

        if (DopplerData(index_right) > valueR_max)
            valueR_max = DopplerData(index_right);
            maxR_index = index_right;
        end           

   end
       
   %% （2）取平均，选大       
   if ((iL_temp >= 2) && (iR_temp >= 2))
       
       if ((iL_temp >= 3) && (iR_temp >= 3) && (RemoveMax_Flag))
            tmpR = (dataRight_sum - valueR_max) / (iR_temp - 2); 
            tmpL = (dataLift_sum - valueL_max) / (iL_temp - 2);      
       else          
            tmpR = dataRight_sum / (iR_temp - 1);
            tmpL = dataLift_sum / (iL_temp - 1);
       end

       if (tmpR > tmpL)
           Doppler_NoiseFloor_GO = tmpR;
       else
           Doppler_NoiseFloor_GO = tmpL;
       end
       
   end
       
end


function Doppler_NoiseFloor = Doppler_CACFAR(idx,COL,CFAR_WINDOW,CFAR_GUARD,DopplerData)
    result=0;
    Doppler_NoiseFloor=0;
    for i=1:round(CFAR_WINDOW)
        index_left=idx-CFAR_GUARD-CFAR_WINDOW+i-1;
		index_right=idx+CFAR_GUARD+i;
        if(index_left<=0)
            index_left=index_left+COL;
        end
        if(index_right>COL)
            index_right=index_right-COL;
        end
        result=result+DopplerData(index_left);
		result=result+DopplerData(index_right);
    end
    Doppler_NoiseFloor=result/(CFAR_WINDOW*2);
end

