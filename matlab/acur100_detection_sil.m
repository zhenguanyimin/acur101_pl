clc;
clear
close all

format long 

addpath('functions');
addpath('xfft_v9_1_bitacc_cmodel_nt64');
% filePath=uigetdir;

%% ============================== 1.参数修改（1） ===================================%%
global HIST_THRESHOLD_GUARD  RDM_MAG_PER_HIST_BIN_EXP sp RANGE_BIN_ENABLE
HIST_THRESHOLD_GUARD=3;
RDM_MAG_PER_HIST_BIN_EXP=256;
RANGE_BIN_ENABLE = 512;%%只对前512bin做阈值计算及CFAR处理

cfarFlag = 1;%%是否进行CFAR处理：1是，0否,默认1
pickSpecificBeam = 0;%%是否筛选特定波位点：1是，0否,默认0
scanMode = 1;%%波束扫描范围：1单波位，2其他,默认1
choseRV = 0;%%是否筛选固定距离和速度的检测点：1是，0否,默认0

RDmapPlot = 1;%%是否画RDMAP：1是，0否
RDmapSave = 0;%%是否保存每帧处理结果图：1是，0否
noisePlot = 1;%%是否画底噪：1是，0否
savePicsFlag = 1;%%是否保存每帧处理结果图：1是，0否
detectionPlot = 1;%%是否画选定所有帧的检测输出：1是，0否
choseDrone = 1;%%是否进行（帧号-距离）一次曲线拟合筛选无人机检测点：1是，0否

rangeSegment = [6,30,210,405,636,1290];%%CFAR距离分段，m

% ADCdataPath = 'D:\7.data\20221220_adc\ADC_pingshi_azi10ele0_25m_kongcai_3';
% ADCdataPath = 'D:\7.data\20221220_adc\ADC_pingshi_azi0ele0_25m_kongcai_3';
% dataTitle = '对空方位±10°，俯仰0°扫描-巴车空采';%%数据主题描述
% savePicsPath = 'E:\0.anti-drone\1.MATLABworkspace\6.rdnapFigureSave\1220_adc\ADC_pingshi_azi10ele0_25m_kongcai_3';%%每帧处理结果图保存路径

% ADCdataPath = 'D:\7.data\20221213_adc\ADC_duikong_JL4wangfan_azi20ele5_200m_2mps_1';
% dataTitle = '对空方位±20°，俯仰±5°扫描-无人机200m往返';%%数据主题描述
% savePicsPath = 'E:\0.anti-drone\1.MATLABworkspace\6.rdnapFigureSave\1213_adc\ADC_duikong_JL4wangfan_azi20ele5_200m_2mps_1_sil_master_RvM\rangeBin13_mtd2^6';%%每帧处理结果图保存路径

% ADCdataPath = 'D:\7.data\20230106AM1111_ADCdata';
% dataTitle = '7ev底噪';%%数据主题描述
% savePicsPath = 'E:\0.anti-drone\1.MATLABworkspace\6.rdnapFigureSave\20231106_7evNoise\20230106AM1111_ADCdata';%%每帧处理结果图保存路径


% ADCdataPath = 'D:\7.data\20221126_adc\duikong_JL4_azi0ele0_100-50m_kaojin_2mps';%%
% dataTitle = '雷达对空单波位00-精灵4无人机100-50m靠近-2m/s';%%数据主题描述
% savePicsPath = 'E:\0.anti-drone\1.MATLABworkspace\6.rdnapFigureSave\1126_adc\duikong_JL4_azi0ele0_100-50m_kaojin_2mps_RvM\rangeBin15_mtd2^6';%%每帧处理结果图保存路径
% 
% ADCdataPath = 'Z:\射频测试\反无雷达\20230109雷达采无人机数据（公司旁小山顶）\ADC数据\wureji-daboshu-10mi-500mwangfan-3mps-2';
% % ADCdataPath = 'Z:\射频测试\反无雷达\adcdizao';
% dataTitle = '小山坡精灵4无人机500m往返-3m/s——对空单波位';%%数据主题描述
% savePicsPath = 'E:\0.anti-drone\1.MATLABworkspace\6.rdnapFigureSave\2023\0109_wureji-daboshu-10mi-500mwangfan-3mps';%%每帧处理结果图保存路径


% ADCdataPath = 'D:\ACUR100_ADC\0.adc\20230111\ADC_duikong_autel_Jiaofan_azi0ele0_500m_3mps';
% dataTitle = '小山坡（EV2+角反+锡纸）无人机500m往返-3m/s——对空单波位';%%数据主题描述
% savePicsPath = 'E:\0.anti-drone\1.MATLABworkspace\6.rdnapFigureSave\2023\0111\test_duikong_autel_Jiaofan_azi0ele0_500m_3mps\all_Fram_gap16';%%每帧处理结果图保存路径

% ADCdataPath = 'R:\路试测试组\ACUR100测试\2023年1月\0113\ADC\ADC_duikong_azi0ele0_EV2_JiaoFan_800mwangfan_3mps';
% dataTitle = '小山坡（EV2+角反+锡纸）无人机800m往返-3m/s——对空单波位';%%数据主题描述
% savePicsPath = 'E:\0.anti-drone\1.MATLABworkspace\6.rdnapFigureSave\2023\0113\ADC_duikong_azi0ele0_EV2_JiaoFan_800mwangfan_3mps\all_Fram_gap16_choseRV';%%每帧处理结果图保存路径

% ADCdataPath = 'Z:\路试测试组\ACUR100测试\2023年1月\0119\ADC\pingshi_danbowei_900m_3mps_1';
% dataTitle = '惠州宝塔山，精灵4无人机900m，3m/s远离，平视单波位ADC—0119新CFAR结果';%%数据主题描述，优化结果，0113实测结果
% savePicsPath = 'E:\0.anti-drone\1.MATLABworkspace\6.rdnapFigureSave\2023\0119ADC\pingshi_danbowei_900m_3mps_1\R_CA26-V_CA46';%%每帧处理结果图保存路径


% ADCdataPath = 'D:\ACUR100_ADC\0.adc\20230111\ADC_duikong_JL4_azi30ele5_500m_4mps_9bit_1';
% dataTitle = '小山坡（精灵4）无人机500m往返-4m/s——对空单波位';%%数据主题描述
% savePicsPath = 'E:\0.anti-drone\1.MATLABworkspace\6.rdnapFigureSave\2023\0111\test_duikong_JL4_azi30ele5_500m_4mps_9bit\all_Fram_gap16';%%每帧处理结果图保存路径

% ADCdataPath = 'R:\射频测试\反无雷达\20230112雷达采模拟器数据\采模拟器ADC数据-模拟器目标200米发射衰减30-1';
% dataTitle = '模拟器目标200米发射衰减30';%%数据主题描述
% savePicsPath = 'E:\0.anti-drone\1.MATLABworkspace\6.rdnapFigureSave\2023\0113\采模拟器ADC数据-模拟器目标200米发射衰减30-1';%%每帧处理结果图保存路径

ADCdataPath = 'E:\work\sw\adc_data';
% ADCdataPath = 'Z:\射频测试\反无雷达\adcdizao';
dataTitle = 'sw';%%数据主题描述
savePicsPath = 'E:\work\sw\matlab\20230110test\20230110test\acur_detection_sil\data_out';%%每帧处理结果图保存路径


%% Resolution ——by hxj
c = 3e8;
f = 24.1e9;%%24GHz,24.1GHz
TD = 265e-6;%%460us,260us
NumSample = 2048;
NumChirp = 32;
T_frame = TD * NumChirp;%%总的TX发波时长
lambda = (c/f);
% BW = 4096/25/205*50*1e6;%%带宽39.961MHz
BW = 50000000;

Rres = c/(2*BW);
Rmax_ideal = Rres * NumSample;%%最大距离

Vres = lambda/(2*T_frame);
VMax = lambda/(4*TD);

%% reading data
inputDataType = 0;      %% 0 - ADC data; 1 - rdmap

%% ============================== 1.参数修改（1）end ================================%%


%% ============================== 2.数据处理 ===================================%%
if inputDataType==1
%     file = dlmread('rdmDummyData_20target.txt');
%     rdm = file(:,1);
%     rdmap_ = reshape(rdm,32,2048);
%     rdmap1=rdmap_';
%     % define range scope of rdmap
%     rdmap=rdmap1(1:2048,:);
    rdmap=rdmapBinRead();
elseif inputDataType==0
%     dirpath=uigetdir('D:\work\ACUR100\test data\20221013zhiyuanlouxia\dat035');
%     dirpath=('D:\work\ACUR100\test data\20221013zhiyuanlouxia\dat035');
    dirpath=(ADCdataPath);
    cd(dirpath);
    namelist = dir('*.dat');
    fileNum=length(namelist);
    frameIDarray=cell(fileNum,1);
    
    TargetAll = cell(1,fileNum);
    PeakTargetAll = cell(1,fileNum);
    TargetList = [];
    PeakTargetList = [];
    FrameIDall = zeros(1,fileNum);
    aziBeamList = zeros(1,fileNum);
    pitchBeamList = zeros(1,fileNum);
    choseTarget = zeros(10,6*fileNum);
    
    Idx = 1;
     
    %% ============================== 1.参数修改（2） ===================================%%
    
%     rBin = 13;
%     frameIdxList = 1240:1:1318;%%1:20:fileNum/2，1:20:fileNum，读取数据帧下标范围！！！！！！！！！！！！！！！！！！！！！！！可修改
%     vBin = 6;

%     rBin = 21;
%     frameIdxList = 2141:1:2231;%%1:20:fileNum/2，1:20:fileNum，读取数据帧下标范围！！！！！！！！！！！！！！！！！！！！！！！可修改
%     vBin = 6;

%     rBin = 31;
%     frameIdxList = 3283;%%1:20:fileNum/2，1:20:fileNum，读取数据帧下标范围！！！！！！！！！！！！！！！！！！！！！！！可修改
% %     frameIdxList = 3261:1:3342;%%1:20:fileNum/2，1:20:fileNum，读取数据帧下标范围！！！！！！！！！！！！！！！！！！！！！！！可修改
%     vBin = 6;

%     rBin = 48;
%     frameIdxList = 5081:1:5141;%%1:20:fileNum/2，1:20:fileNum，读取数据帧下标范围！！！！！！！！！！！！！！！！！！！！！！！可修改
%     vBin = 6;

%     rBin = 7;
%     frameIdxList = 2:1:fileNum/2;%%1:20:fileNum/2，1:20:fileNum，读取数据帧下标范围！！！！！！！！！！！！！！！！！！！！！！！可修改    
%     vBin = 32;

%% 全部
    rBin = 177;
%     frameIdxList = 6000:20:8000;%%1:20:fileNum/2，1:20:fileNum，读取数据帧下标范围！！！！！！！！！！！！！！！！！！！！！！！可修改
    frameIdxList = 1:1:3;%%11941:10:12001;9960:10:2*fileNum/3;1:1:fileNum，160:16:fileNum;22000:20:26000,[12325,12348];%%1:20:fileNum/2，1:20:fileNum，读取数据帧下标范围！！！！！！！！！！！！！！！！！！！！！！！可修改
    vBin = 6;

%% 单波位
%     rBin = 11;
%     frameIdxList = 721:1:801;%%1:20:fileNum/2，1:20:fileNum，读取数据帧下标范围！！！！！！！！！！！！！！！！！！！！！！！可修改    
%     vBin = 6;

%     rBin = 15;
%     frameIdxList = 2061:1:2181;%%1:20:fileNum/2，1:20:fileNum，读取数据帧下标范围！！！！！！！！！！！！！！！！！！！！！！！可修改    
%     vBin = 28;


    %% ============================== 1.参数修改（2）end ================================%%
    tic,
    uniqueFrameNum = 1;
    Nts = 1;
    Nps = 1;
    file_id = fopen('E:\work\sw\adc_data_h\adc_test_data_input3.dat','w');
    file_id2 = fopen('E:\work\sw\adc_data_h\rdmap_log2.dat','w');
    fprintf(file_id,'#ifndef _ADC_TEST_DATA_H_\n#define _ADC_TEST_DATA_\n\n char adc_data[256*1024*3]  ={\n');

    for iFlie = frameIdxList
%     for iFlie = 182
        
        [adc_hex,adc_data_deal,rdmap] = getRdmapFromADC(iFlie,dirpath,cfarFlag,file_id,file_id2);               
%         figure(iFlie)
%         set(gcf,'unit','centimeters','position',[20 1 15 25])
%         subplot(211)
%         hold on
%         aziBeam = hex2dec(adc_hex{1,1})-180;
%         pitchBeam = hex2dec(adc_hex{1,2})-180;
        aziBeam = hex2dec(adc_hex{1,2})-180;%%奇偶列互换后
        pitchBeam = hex2dec(adc_hex{1,1})-180;
                
        aziBeamList(iFlie) = aziBeam;
        pitchBeamList(iFlie) = pitchBeam;
        
        if (pickSpecificBeam == 1)
            if aziBeam ~= -23
                continue;
            end
        end
        if (RDmapPlot == 1)
            figure(iFlie)
            set(gcf,'unit','centimeters','position',[20 1 15 25])
            subplot(211)
            hold on
            for iRow = 1:size(adc_data_deal,1)
                plot(adc_data_deal(iRow,:))
            end  
            xlabel('samples');title(['ADC data  azimuth = ',num2str(aziBeam),' pitch = ',num2str(pitchBeam)]);
            subplot(212)
    %         hold on
    %         rdmap=rdmap(1:256,:);
            mesh(rdmap);title([namelist(iFlie,1).name,"RDMAP"])
            
        end
        
        if (cfarFlag == 1)
            % 0. 
            sp.nrRangeBins = size(rdmap,1);
            sp.nrDopplerBins = size(rdmap,2);
            histogram_col = 64;       % rdmap is bits of uint32
            detectObjData.rdmapData = rdmap;
            detectObjData.histBuff = zeros(sp.nrRangeBins,histogram_col);
            detectObjData.hististMaxIndex = zeros(sp.nrRangeBins,1);
            detectObjData.threshold = zeros(sp.nrRangeBins,1);
            detectObjData.peakBitmap = zeros(sp.nrRangeBins,sp.nrDopplerBins);
            % 1. histogram statistic
%             detectObjData.histBuff = CalcHistogram(detectObjData.rdmapData,histogram_col);
            [detectObjData.histBuff, meanNoiseBuff] =  CalcHistogram(detectObjData.rdmapData,histogram_col);
            % 2. calculate noise power threshold
%             [detectObjData.hististMaxIndex, detectObjData.threshold]=CalcThreshold(detectObjData.histBuff);
            [detectObjData.hististMaxIndex, detectObjData.threshold,detectObjData.noiseMag] = CalcThreshold(detectObjData.histBuff,meanNoiseBuff);
            % 3. generate bitmap
            [detectObjData.peakBitmap,gPeakNum] = CalcPeakSearchBitmap(detectObjData.rdmapData, detectObjData.threshold);
            % 4. cfar
%             [Target_Para, target_num, PeakTarget_Para] = CfarDetection(detectObjData.rdmapData, detectObjData.peakBitmap);
            [Target_Para, target_num, PeakTarget_Para] = CfarDetection(detectObjData.rdmapData, detectObjData.peakBitmap, detectObjData.threshold, detectObjData.noiseMag);
            % 5.out ——by hxj 
%             dopplerBinList = fftshift(1:sp.nrDopplerBins);
             dopplerBinList = 1:sp.nrDopplerBins;
            for ii = 1:sp.nrDopplerBins
                tmpDopplerBin = dopplerBinList(ii)-1;%%MATLAB下标从1开始
                if (tmpDopplerBin >= sp.nrDopplerBins/2) %%-15~16
                    tmpDopplerBin = tmpDopplerBin - sp.nrDopplerBins;%% + 1
                end
                dopplerBinList(ii) = tmpDopplerBin;%% + 1
            end

            Num = size(Target_Para,2);
            Target = Target_Para;
            Target(1,:) = Target(1,:)*Rres;%%range
            for ii = 1:Num
                dopplerBinIdx = Target(2,ii);
                dopplerBin = dopplerBinList(dopplerBinIdx);
                Target(2,ii) = dopplerBin * Vres;
            end
            TargetAll{iFlie} = Target;
            TargetList(Nts:Nts+Num-1,2:10) = Target.';

            Num1 = size(PeakTarget_Para,2);
            PeakTarget = PeakTarget_Para;
            PeakTarget(1,:) = PeakTarget(1,:)*Rres;%%range
            for ii = 1:Num1
                dopplerBinIdx = PeakTarget(2,ii);
                dopplerBin = dopplerBinList(dopplerBinIdx);
                PeakTarget(2,ii) = dopplerBin * Vres;    
            end
            PeakTargetAll{iFlie} = PeakTarget;
            PeakTargetList(Nps:Nps+Num1-1,2:10) = PeakTarget.';
            
           %% ============================== 3.画图 ===================================%%           
           %% (1)RDmap
            if (RDmapPlot == 1)
                hold on
                % plot targets
                detNum = size(Target_Para,2);
                for iRow = 1:detNum
                    ragneBin = Target_Para(1,iRow);dopplerBin = Target_Para(2,iRow);
                    scatter3(dopplerBin,ragneBin,rdmap(ragneBin,dopplerBin),'o','r');
                end
                % plot peaks
                for iRow = 1:size(PeakTarget_Para,2)
                    ragneBin = PeakTarget_Para(1,iRow);dopplerBin = PeakTarget_Para(2,iRow);
                    scatter3(dopplerBin,ragneBin,rdmap(ragneBin,dopplerBin),'x','k');
                end
                title({[namelist(iFlie,1).name,'  RDMAP ','detNum = ',num2str(detNum)];['azimuth = ', num2str(aziBeam), ' pitch = ',num2str(pitchBeam)]});
               axis([0 32 0 256])
                if(pickSpecificBeam == 1)
                    if(aziBeam == -23)
                        frameIDarray{uniqueFrameNum,1} = namelist(iFlie,1).name;
                        frameIDarray{uniqueFrameNum,2} = detNum;
                        uniqueFrameNum = uniqueFrameNum+1;
                    end
                end
                view([-135,37])
                if(RDmapSave)
%                     cd('D:\work\ACUR100\test data\20221013zhiyuanlouxia\pic')
                    cd(savePicsPath)
%                     saveas(gcf, namelist(iFlie,1).name(1:end-4), 'png')
                    saveas(gcf, namelist(iFlie,1).name(1:end-4), 'fig')
                end
    %             view(2)
            end
            
            %% (2)noise
            if (noisePlot == 1)
                figure(iFlie+fileNum+7),                
                x=[1:RANGE_BIN_ENABLE]*Rres;plot(x,rdmap(1:RANGE_BIN_ENABLE,4)/256*3.0103,'k-',x,rdmap(1:RANGE_BIN_ENABLE,5)/256*3.0103,'b-',x,rdmap(1:RANGE_BIN_ENABLE,6)/256*3.0103,'g-');hold on;
                plot(Rres.*(1:length(detectObjData.noiseMag)),detectObjData.noiseMag./256.*3.0103,'r-');
                xlabel('距离/m','FontSize',14);ylabel('底噪/dB','FontSize',14);title([dataTitle,'——',namelist(iFlie,1).name(1:end-4),'.dat'],'FontSize',14);%
                h = legend(['(1)V=',num2str(roundn(3*Vres,-2)),'m/s的rdmap幅值曲线'],['(2)V=',num2str(roundn(4*Vres,-2)),'m/s的rdmap幅值曲线'],['(3)V=',num2str(roundn(5*Vres,-2)),'m/s的rdmap幅值曲线'],'(4)直方图底噪');
                set(h,'FontSize',11)
                cd(savePicsPath)
                saveas(gcf, ['noise_',namelist(iFlie,1).name(1:end-4)], 'fig')
                
%                 x=[1:512]*Rres;figure,plot(x,rdmap(1:512,4)/256*3.0103);%%,x,rdmap(:,5),x,rdmap(:,6))
                figure,x=[1:32];plot(x,rdmap(143,:)/256*3.0103);%%,x,rdmap(144,:),x,rdmap(145,:))
                 xlabel('dopplerBin','FontSize',14);ylabel('rdmap幅值曲线/dB','FontSize',14);title([dataTitle,'——',namelist(iFlie,1).name(1:end-4),'.dat'],'FontSize',14);%
                h = legend(['(1)V=',num2str(roundn(143*Rres,-2)),'m的rdmap幅值曲线'],['(2)V=',num2str(roundn(4*Vres,-2)),'m/s的rdmap幅值曲线'],['(3)V=',num2str(roundn(5*Vres,-2)),'m/s的rdmap幅值曲线'],'(4)直方图底噪');
                set(h,'FontSize',11)
                cd(savePicsPath)
                saveas(gcf, ['dopplerMag_',namelist(iFlie,1).name(1:end-4)], 'fig')
            end
            
            %% (3)detection output
             if (detectionPlot == 1)
                str = namelist(iFlie,1).name;
                A = isstrprop(str,'digit');
                B = str(A);
                FrameID = str2num(B);
                FrameIDall(iFlie) = FrameID;
                
                TargetList(Nts:Nts+Num-1,1) = FrameID * ones(Num,1);
                PeakTargetList(Nps:Nps+Num1-1,1) = FrameID * ones(Num1,1);
                Nts = Nts + Num; 
                Nps = Nps + Num1;
                
                figure(fileNum+1),plot(FrameID*ones(1,Num),Target(1,:),'ko'),hold on;
%                 figure(fileNum+5),plot(FrameID,aziBeam,'ko'),hold on;
%                 figure(fileNum+6),plot(FrameID,pitchBeam,'ko'),hold on;
                figure(fileNum+7),plot(FrameID*ones(1,Num),Target(3,:),'ko'),hold on;              
            end
        end
        
    end
 
   fclose(file_id);
   fclose(file_id2); 
    %% 往返曲线拟合筛选
    if (choseDrone == 1)
        idx_useful = [];

        Xw = [10974,19777];%%远离帧号，2点为1条直线
        Yw = [66,294];%%远离距离
        Xf = [118473,130653];%%远离帧号%%靠近帧号，2点为1条直线
        Yf = [354,18];%%靠近距离
        
        Kw1 = (Yw(2)-Yw(1))/(Xw(2)-Xw(1));%%远离曲线1
%         Kw2 = (Yw(4)-Yw(3))/(Xw(4)-Xw(3));%%远离曲线2

        bw1 = Yw(1) - Kw1 * Xw(1);
%         bw2 = Yw(4) - Kw2 * Xw(4);

        %% 无人机目标筛选
        r = find(TargetList(:,2) <= 900);
%         idx_chose = r;%%(1)
        v1 = find(TargetList(r,3) >= 3*Vres);%%2.2
        v2 = find(TargetList(r,3) <= 5*Vres);%%3.67
        v = intersect(v1,v2);
        idx_chose = r(v);%%(2)
%     idx_chose = 1:Num_tmpDetect;%%(3)

        for jj = 1:length(idx_chose)
            idx = idx_chose(jj);

            FrameID = TargetList(idx,1);
            range = TargetList(idx,2);
            tmpYw1 = Kw1 * FrameID + bw1;%%远离曲线1        

            if ((tmpYw1 >= range-Rres)&&(tmpYw1 <= range+Rres))
                idx_useful = [idx_useful,idx];
            end        
        end
    end
    
    if (detectionPlot == 1)
        figure(fileNum+1),
        if (choseDrone)
            plot(TargetList(idx_useful,1),TargetList(idx_useful,2),'r*'),hold on;
        end
        xlabel('帧号/FrameID','FontSize',14);ylabel('距离/m','FontSize',14);title(dataTitle,'FontSize',14);%
        h = legend('(1)ADC回灌SiL的所有检测点','(2)筛选出的无人机目标检测点');
%     h = legend('(1)所有实测检测点','(2)筛选出的杂散检测点');
        set(h,'FontSize',11)
        if(savePicsFlag)
            cd(savePicsPath)
            saveas(gcf, 'FrameID-R', 'fig')
%             saveas(gcf, string(fileNum+1), 'fig')
        end
        
%         figure(fileNum+5),xlabel('帧号/FrameID');ylabel('方位角/°');title(dataTitle);%
%         if(savePicsFlag)
%             cd(savePicsPath)
%             saveas(gcf,  'FrameID-Azimuth', 'fig')
% %             saveas(gcf, string(fileNum+5), 'fig')
%         end
%         
%         figure(fileNum+6),xlabel('帧号/FrameID');ylabel('俯仰角/°');title(dataTitle);%
%         if(savePicsFlag)
%             cd(savePicsPath)
%             saveas(gcf,  'FrameID-Elevation', 'fig')
% %             saveas(gcf, string(fileNum+6), 'fig')
%         end
        
        figure(fileNum+7),
        if (choseDrone)
            plot(TargetList(idx_useful,1),TargetList(idx_useful,4),'r*'),hold on;
        end                
        xlabel('帧号/FrameID','FontSize',14);ylabel('幅值mag/dB','FontSize',14);title(dataTitle,'FontSize',14);%
        h = legend('(1)ADC回灌SiL的所有检测点','(2)筛选出的无人机目标检测点');
%     h = legend('(1)所有实测检测点','(2)筛选出的杂散检测点');
        set(h,'FontSize',11)
        if(savePicsFlag)
            cd(savePicsPath)
            saveas(gcf,  'FrameID-Mag', 'fig')
%             saveas(gcf, string(fileNum+7), 'fig')
        end
        
        fprintf("ADC数据回灌SiL检测处理耗时：%f\n", toc);
        
        figure(fileNum+2),hold on;
        plot(TargetList(:,2),TargetList(:,7),'ko');
        if (choseDrone)
            plot(TargetList(idx_useful,2),TargetList(idx_useful,7),'r*'),hold on;
        end
        
        plot(ones(1,45)+rangeSegment(2),1:45,'g-');hold on; plot(ones(1,45)+rangeSegment(3),1:45,'g-');hold on; plot(ones(1,45)+rangeSegment(4),1:45,'g-');hold on; plot(ones(1,45)+rangeSegment(5),1:45,'g-');hold on;
        xlabel('距离/m','FontSize',14);title('距离维信噪比/dB','FontSize',14);%
        h = legend('(1)ADC回灌SiL的所有检测点','(2)筛选出的无人机目标检测点');
%     h = legend('(1)所有实测检测点','(2)筛选出的杂散检测点');
        set(h,'FontSize',11)
        if(savePicsFlag)
            cd(savePicsPath)
            saveas(gcf,  'R-rSNR', 'fig')
%             saveas(gcf, string(fileNum+2), 'fig')
        end        

        figure(fileNum+3),hold on;
        plot(TargetList(:,2),TargetList(:,8),'ko');
        if (choseDrone)
            plot(TargetList(idx_useful,2),TargetList(idx_useful,8),'r*'),hold on;
        end        
        
        plot(ones(1,45)+rangeSegment(2),1:45,'g-');hold on; plot(ones(1,45)+rangeSegment(3),1:45,'g-');hold on; plot(ones(1,45)+rangeSegment(4),1:45,'g-');hold on; plot(ones(1,45)+rangeSegment(5),1:45,'g-');hold on;
        xlabel('距离/m','FontSize',14);title('速度维信噪比/dB','FontSize',14);%
        h = legend('(1)ADC回灌SiL的所有检测点','(2)筛选出的无人机目标检测点');
%     h = legend('(1)所有实测检测点','(2)筛选出的杂散检测点');
        set(h,'FontSize',11)
        if(savePicsFlag)
            cd(savePicsPath)
            saveas(gcf, 'R-dSNR', 'fig')
%             saveas(gcf, string(fileNum+3), 'fig')
        end

        figure(fileNum+4),hold on;
        plot(TargetList(:,2),TargetList(:,9),'ko');
        if (choseDrone)
             plot(TargetList(idx_useful,2),TargetList(idx_useful,9),'r*'),hold on;
        end        
       
         plot(ones(1,45)+rangeSegment(2),1:45,'g-');hold on; plot(ones(1,45)+rangeSegment(3),1:45,'g-');hold on; plot(ones(1,45)+rangeSegment(4),1:45,'g-');hold on; plot(ones(1,45)+rangeSegment(5),1:45,'g-');hold on;
        xlabel('距离/m','FontSize',14);title('全局信噪比/dB','FontSize',14);%
        h = legend('(1)ADC回灌SiL的所有检测点','(2)筛选出的无人机目标检测点');
%     h = legend('(1)所有实测检测点','(2)筛选出的杂散检测点');
        set(h,'FontSize',11)
        if(savePicsFlag)
            cd(savePicsPath)
            saveas(gcf, 'R-gSNR', 'fig')
%             saveas(gcf, string(fileNum+4), 'fig')
        end 
        
        figure(fileNum+8),hold on;
        plot(TargetList(:,2),TargetList(:,4),'ko');
        if (choseDrone)
             plot(TargetList(idx_useful,2),TargetList(idx_useful,4),'r*'),hold on;
        end         
        
        plot(ones(1,80)+rangeSegment(2),1:80,'g-');hold on; plot(ones(1,80)+rangeSegment(3),1:80,'g-');hold on; plot(ones(1,80)+rangeSegment(4),1:80,'g-');hold on; plot(ones(1,80)+rangeSegment(5),1:80,'g-');hold on;
        xlabel('距离/m','FontSize',14);title('幅值mag/dB','FontSize',14);%
        h = legend('(1)ADC回灌SiL的所有检测点','(2)筛选出的无人机目标检测点');
%     h = legend('(1)所有实测检测点','(2)筛选出的杂散检测点');
        set(h,'FontSize',11)
        if(savePicsFlag)
            cd(savePicsPath)
            saveas(gcf, 'R-mag', 'fig')
%             saveas(gcf, string(fileNum+8), 'fig')
        end 
        
        figure(fileNum+9),hold on;
        plot(TargetList(:,2),TargetList(:,4)-TargetList(:,9)+(HIST_THRESHOLD_GUARD-1)*3.0103,'ko');
        if (choseDrone)
             plot(TargetList(idx_useful,2),TargetList(idx_useful,4)-TargetList(idx_useful,9)+(HIST_THRESHOLD_GUARD-1)*3.0103,'r*'),hold on;
        end         
        
        plot(ones(1,80)+rangeSegment(2),1:80,'g-');hold on; plot(ones(1,80)+rangeSegment(3),1:80,'g-');hold on; plot(ones(1,80)+rangeSegment(4),1:80,'g-');hold on; plot(ones(1,80)+rangeSegment(5),1:80,'g-');hold on;
        xlabel('距离/m','FontSize',14);title('直方图底噪/dB','FontSize',14);%
        h = legend('(1)ADC回灌SiL的所有检测点','(2)筛选出的无人机目标检测点');
%     h = legend('(1)所有实测检测点','(2)筛选出的杂散检测点');
        set(h,'FontSize',11)
        if(savePicsFlag)
            cd(savePicsPath)
            saveas(gcf, 'R-noiseMag', 'fig')
%             saveas(gcf, string(fileNum+8), 'fig')
        end 
        
    end
    
if (choseRV == 1)
    Target_use = zeros(12,length(frameIdxList));
    for idx = 1:length(frameIdxList)
        iFlie = frameIdxList(idx);
        if (size(TargetAll{iFlie},2)>0)
            Target = TargetAll{iFlie};
            Ntar = size(Target,2);
            for ii = 1:Ntar
                R = Target(1,ii);
                V = Target(2,ii);
                if ((R > (rBin-1)*Rres) && (R < (rBin+1)*Rres) && (V > (vBin-1)*Vres) && (V < (vBin+1)*Vres))
                    Target_use(1:9,idx) = Target(:,ii);
                    Target_use(10,idx) = FrameIDall(iFlie) ;
                    Target_use(11,idx) = aziBeamList(iFlie);
                    Target_use(12,idx) = pitchBeamList(iFlie);
                end
            end
        end
    end
    
    Target_usePlot = Target_use(:,find(Target_use(1,:)~=0));
    L = size(Target_usePlot,2);
        
    R1 = Target_usePlot(1,1);%%距离
    
    if (scanMode == 2)
        age_trd = -18:4:18;
        F1 = Target_usePlot(10,1);%%第1个帧号
        A1 = Target_usePlot(11,1);%%第1个波位方位角
        E1 = Target_usePlot(12,1);%%第1个波位俯仰角       

        FL =  Target_usePlot(10,L);%%最后一个帧号

        for i_age = 1:length(age_trd)
            if (A1 == age_trd(i_age))
                if (E1 < 0)
                    frame_ge = 2*length(age_trd)-(2*(i_age-1));
                else
                    frame_ge = 2*length(age_trd)-(2*(i_age-1)+1);
                end

            end       
        end

        nn = 1;
        Idx1 = find(Target_usePlot(10,:) < F1 + frame_ge);
        Fu = find(Target_usePlot(12,Idx1) < 0);
        Zheng = find(Target_usePlot(12,Idx1) > 0);    
        Idx_kf{nn} = Idx1(Fu);
        Idx_kz{nn} = Idx1(Zheng);
        figure(nn + 200)
        plot(-18*ones(1,length(10:100)),10:100,'g-');hold on;
        plot(-14*ones(1,length(10:100)),10:100,'g-');hold on;
        plot(-10*ones(1,length(10:100)),10:100,'g-');hold on;
        plot(-6*ones(1,length(10:100)),10:100,'g-');hold on;
        plot(-2*ones(1,length(10:100)),10:100,'g-');hold on;
        plot(2*ones(1,length(10:100)),10:100,'g-');hold on;
        plot(6*ones(1,length(10:100)),10:100,'g-');hold on;
        plot(10*ones(1,length(10:100)),10:100,'g-');hold on;
        plot(14*ones(1,length(10:100)),10:100,'g-');hold on;
        plot(18*ones(1,length(10:100)),10:100,'g-');hold on;
        plot(Target_usePlot(11,Idx1(Fu)),Target_usePlot(3,Idx1(Fu)),'b-*'); hold on;
        plot(Target_usePlot(11,Idx1(Zheng)),Target_usePlot(3,Idx1(Zheng)),'r-o');hold on; 
        xlabel('方位扫描波位角/°');ylabel('幅值mag/dB');title([num2str(R1),'m检测点第',num2str(nn),'轮扫描']);% 

    %     if(savePicsFlag)
        if(1)
            cd(savePicsPath)
            saveas(gcf, string((nn + 200)), 'fig')
        end

        for kk = (F1 + frame_ge):2*length(age_trd):FL
            Idxk = [];
            for n = (length(Idx1)+1):L
                Fn =  Target_usePlot(10,n);%%第n个帧号
                if ((Fn >= kk) && (Fn < kk+2*length(age_trd)))
                    Idxk = [Idxk,n];
                end            
            end   

            nn = nn + 1;
            Fu = find(Target_usePlot(12,Idxk) < 0);
            Zheng = find(Target_usePlot(12,Idxk) > 0);
            Idx_kf{nn} = Idxk(Fu);
            Idx_kz{nn} = Idxk(Zheng);
        end

        ff = 1;
        for f = 2:length(Idx_kf)
            Idxf = Idx_kf{f};
            Idxz = Idx_kz{f};
            Nf = length(Idxf);
            Nz = length(Idxz);
            if ((Nf > 0)||(Nz > 0))
                ff = ff + 1;
                figure(ff + 200)
                plot(-18*ones(1,length(10:100)),10:100,'g-');hold on;    
                plot(-14*ones(1,length(10:100)),10:100,'g-');hold on;     
                plot(-10*ones(1,length(10:100)),10:100,'g-');hold on;      
                plot(-6*ones(1,length(10:100)),10:100,'g-');hold on;      
                plot(-2*ones(1,length(10:100)),10:100,'g-');hold on;      
                plot(2*ones(1,length(10:100)),10:100,'g-');hold on;    
                plot(6*ones(1,length(10:100)),10:100,'g-');hold on;      
                plot(10*ones(1,length(10:100)),10:100,'g-');hold on;      
                plot(14*ones(1,length(10:100)),10:100,'g-');hold on;      
                plot(18*ones(1,length(10:100)),10:100,'g-');hold on;  
                plot(Target_usePlot(11,Idxf),Target_usePlot(3,Idxf),'b-*'); hold on;
                plot(Target_usePlot(11,Idxz),Target_usePlot(3,Idxz),'r-o');hold on;       
                xlabel('方位扫描波位角/°');ylabel('幅值mag/dB');title([num2str(R1),'m检测点第',num2str(ff),'轮扫描']);% 
    %             if(savePicsFlag)
                if(1)
                    cd(savePicsPath)
                    saveas(gcf, string((ff + 200)), 'fig')
                end            
            end                
        end
        
    else
        if (scanMode == 1) %%单波位
            figure(1 + 200)
            plot(Target_usePlot(10,:)-120000,Target_usePlot(3,:),'r-o'); hold on;
            xlabel('帧号/FrameID');ylabel('幅值mag/dB');title([num2str(R1),'m检测点单波位检测幅值变化情况']);%
%             if(savePicsFlag)
            if(1)
                cd(savePicsPath)
                saveas(gcf, string((1 + 200)), 'fig')
            end
        end
    end
    
    
%     figure(fileNum+10),hold on;
%     plot(Target_usePlot(11,:),Target_usePlot(3,:),'ko');           
%     xlabel('方位角/°');title('幅值mag/dB');%
%     if(savePicsFlag)
%         cd(savePicsPath)
%         saveas(gcf, string(fileNum+10), 'fig')
%     end
 
end
    

% x=[1:512]*Rres;figure,plot(x,rdmap(1:512,4)/256*3.0103);%%,x,rdmap(:,5),x,rdmap(:,6))
% x=[1:32];figure,plot(x,rdmap(143,:)/256*3.0103);%%,x,rdmap(144,:),x,rdmap(145,:))
    
    %% ============================== 3.画图end ================================%%
    
end


%% 
