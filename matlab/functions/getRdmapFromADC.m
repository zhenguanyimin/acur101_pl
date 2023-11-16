function [adc_hex,adc_data_deal,rdmap]=getRdmapFromADC(iFlie,dirpath,cfarFlag,file_id,file_id2)
global compare

format long e

MTD_N = 32;
N = 4096;
offset1 = 10;
offset2 = 10;
mtd_data = zeros(MTD_N,N/2);

Rwinid = 1;%加窗类型，0：矩形窗；1：海明窗；2：凯撒窗；3：切比雪夫窗；
Dwinid = 1;%加窗类型，0：矩形窗；1：海明窗；2：凯撒窗；3：切比雪夫窗；

%% range_win
if( Rwinid == 0.)
   win(1:N) = 1.;
   win =win';
else
   if(Rwinid == 1.)
      win = hamming(N);
   else
      if( Rwinid == 2.)
         win = kaiser(N,pi);
      else
         if(Rwinid == 3.)
            win = chebwin(N,60);
         end
      end
   end
end

%% doppler_win
if( Dwinid == 0)
   w_hamm(1:MTD_N) = 1.;
   w_hamm =w_hamm';
else
   if(Dwinid == 1.)
      w_hamm = hamming(MTD_N);
   else
      if( Dwinid == 2.)
         w_hamm = kaiser(MTD_N,pi);
      else
         if(Dwinid == 3.)
            w_hamm = chebwin(MTD_N,80);
         end
      end
   end
end
cd(dirpath);
namelist = dir('*.dat');
N_Flies = length(namelist);

% listfilename=[dirpath,'\target_list.txt'];
% fid = fopen('target_list.txt','w');%保存波形数据
for kFile =iFlie:1:iFlie
    if(namelist(kFile).bytes ~= 262144 )
        continue;
    end 
    file_name=namelist(kFile).name; 
end    
%获取文件路径
% file_name=uigetfile('*.dat');
fileID = fopen(file_name,'r');
rarray = fread(fileID);
 fclose(fileID);
%数据重整
LL=length(rarray);

for mm=1:2:LL
adc_data((mm+1)/2)=rarray(mm+1)*256+rarray(mm);
end 

adc_data=reshape( adc_data(1:N*MTD_N),N,MTD_N  )';
% 
adc_data1 = zeros(size(adc_data)); %%奇偶列互换
adc_data1(:,1:2:end) = adc_data(:,2:2:end); %%奇偶列互换
adc_data1(:,2:2:end) = adc_data(:,1:2:end); %%奇偶列互换
adc_data = adc_data1;

%按照16进制对比数据
adc_hex = cell(MTD_N,N);
for ii= 1:MTD_N
    for jj=1:N
        data_temp=dec2hex(adc_data(ii,jj),4);
        adc_hex{ii,jj}=data_temp;
    end
end 

adc_bin = cell(MTD_N,N);
for ii= 1:MTD_N
    for jj=1:N
        data_temp=dec2bin(adc_data(ii,jj),14);
        adc_bin{ii,jj}=data_temp;
    end
end 

%%% 上板验证测试数据打印
adc_data_fpga= [ zeros(MTD_N,offset1),adc_data(:,offset1-1:N-offset2+2),zeros(MTD_N,offset2-4)] ;%%列对齐，ADC前10后6位为0，中间放入从第9列到倒数第N-8列的ADC数据
creat_h(adc_data_fpga,file_id);


%%emd


for mm=1:2:LL
% if(adc_data((mm+1)/2) >2^13)
%     adc_data((mm+1)/2) = adc_data((mm+1)/2)-2^14;    
% end 
if(adc_data((mm+1)/2) >2^15) %%！！！！！！！！！！！！！！！！！！！！！！！！！！！！！   
    adc_data((mm+1)/2) = adc_data((mm+1)/2)-2^16; %%！！！！！！！！！！！！！！！！！！！！！！！！！！！！！   
end 
 adc_data((mm+1)/2) = adc_data((mm+1)/2);
end 

% adc_data(1,7)=mean(adc_data(1,:));
% adc_data(1,8)=mean(adc_data(1,:));
% adc_avg= mean(mean(adc_data(:,offset+1:N-offset)));
% % adc_avg = 0;
% % adc_data = adc_data -  adc_avg;
  
adc_data_deal= [ zeros(MTD_N,offset1),adc_data(:,offset1-1:N-offset2+2),zeros(MTD_N,offset2-4)] ;%%列对齐，ADC前10后6位为0，中间放入从第9列到倒数第N-8列的ADC数据
% 
fiel_id_dst = fopen('E:\work\sw\adc_data_h\win_data_input.dat','w');
for i = 1:4096
      if(adc_data_deal(1,i)<0)
        fprintf(fiel_id_dst,'0x%04s\n',((dec2hex(adc_data_deal(1,i)+2^16))));
      else
        fprintf(fiel_id_dst,'0x%04s\n',(dec2hex(adc_data_deal(1,i))));
      end
end   
fclose(fiel_id_dst);
   


%% ===================== 1D FFT ======================%%
% for k=1:MTD_N
%     fft_adc_data(k,:)=fft(adc_data_deal(k,:) .* win',N)*2/N;
% %     fft_adc_data(k,:)=fft(adc_data_deal(k,:) .* win',N);
%     % % % fft_adc_data(k,:)=fftshift(fft(adc_data_deal(k,:)));
% end

%% 1D FFT对齐FPGA
win_or = round(win/max(win)*(2^10-1));
win_or = [win_or(1,1);win_or(1,1);win_or(1:N-2,:)];

fiel_id_dst = fopen('E:\work\sw\adc_data_h\win.dat','w');
for i = 1:4096
        fprintf(fiel_id_dst,'%d,\n',win_or(i));
end   
fclose(fiel_id_dst);


generics.C_NFFT_MAX = 12;
% generics.C_ARCH = 1;
generics.C_ARCH = 3;
generics.C_HAS_NFFT = 0;
generics.C_USE_FLT_PT = 0;
generics.C_INPUT_WIDTH = 16; % Must be 32 if C_USE_FLT_PT = 1
generics.C_TWIDDLE_WIDTH = 16; % Must be 24 or 25 if C_USE_FLT_PT = 1
generics.C_HAS_SCALING = 0; % Set to 0 if C_USE_FLT_PT = 1
generics.C_HAS_BFP = 0; % Set to 0 if C_USE_FLT_PT = 1
generics.C_HAS_ROUNDING = 0; % Set to 0 if C_USE_FLT_PT = 1
samples = 2^generics.C_NFFT_MAX;
% Handle multichannel FFTs if required

%   input = input_raw;

  % Set point size for this transform
  nfft = generics.C_NFFT_MAX;
  % Set up scaling schedule: scaling_sch[1] is the scaling for the first stage
  % Scaling schedule to 1/N: 
  %    2 in each stage for Radix-4/Pipelined, Streaming I/O
  %    1 in each stage for Radix-2/Radix-2 Lite
  if generics.C_ARCH == 1 || generics.C_ARCH == 3
    scaling_sch = ones(1,floor(nfft/2)) * 2;
    if mod(nfft,2) == 1
      scaling_sch = [scaling_sch 1];
    end
  else
    scaling_sch = ones(1,nfft);
  end

  % Set FFT (1) or IFFT (0)
  direction = 1;
  
  % Run the MEX function

  fft_adc_data = zeros(MTD_N,N);
for k=1:MTD_N
   adc_data_tmp1 = adc_data_deal(k,:) .* win_or';%%16bit+10bit = 26bit
   adc_data_tmp2 = floor( adc_data_tmp1./ 2^10);%%floor( adc_data_tmp1./ 2^9),23bit,2^3
   adc_data_tmp3 = fix( adc_data_tmp1./ 2^10);%%floor( adc_data_tmp1./ 2^9),23bit,2^3
   
fiel_id_dst = fopen('E:\work\sw\adc_data_h\fft_data_input.dat','w');
for i = 1:4096
      if(adc_data_tmp2(i)<0)
        fprintf(fiel_id_dst,'%04s\n',lower((dec2hex(adc_data_tmp2(i)+2^16))));
      else
        fprintf(fiel_id_dst,'%04s\n',lower(dec2hex(adc_data_tmp2(i))));
      end
end   
fclose(fiel_id_dst);
   
   %% new add 1 
   ntBP = numerictype(1,16,0);
   x_BP = fi(adc_data_tmp2, 1, 23, 0) ;
   adc_data_tmp2_dec = (1.0 .* quantize(x_BP,ntBP)).';%%16bit
   Idx1 = find(adc_data_tmp2_dec >= 2^15);
   if(Idx1)
       adc_data_tmp2_dec(Idx1) = adc_data_tmp2_dec(Idx1) - 2^16;
   end
   adc_data_tmp2_end = adc_data_tmp2_dec;
   input1 = double(adc_data_tmp2_end)./double(2^15); 
%    adc_data_tmp3=floor(fft(adc_data_tmp2 ,N));

    %% output:2^(12(generics.C_NFFT_MAX)+16(generics.C_INPUT_WIDTH)+1)=2^29=[1][13][15](1Signedness+13IntegerLength+15FractionLength)
   [output, blkexp, overflow] = xfft_v9_1_bitacc_mex(generics, nfft, input1, scaling_sch, direction);
%    output = aut_xfft_v9_1_mex(adc_data_tmp2,generics.C_NFFT_MAX,generics.C_ARCH,generics.C_INPUT_WIDTH,generics.C_TWIDDLE_WIDTH);
%    output = aut_xfft_v9_1_mex(,12,3,16,16);

   adc_data_tmp3 = output.'*2^15;%%Convert 15bit fraction to integer
   tmp1 = floor(adc_data_tmp3./2^8);%%Remove the lower 8bit fraction
%    tmp1 = floor(adc_data_tmp3);
   fft_o1_real = real(tmp1);
   fft_o1_imag = imag(tmp1);
   %    fft_adc_data(k,:) = floor(adc_data_tmp3./2^8);%%2^8
   %% new add 2   
   ntBP = numerictype(1,16,0);%%1st is sign，WordLength 16bit，FractionLength 0bit(EffectiveLength 15bit(last 8bit integer + front 7bit fraction))
   x_BP = fi(tmp1, 1, 16, 0) ;
   fft_adc_data(k,:) = quantize(x_BP,ntBP);
end
fft_adc_data_re_tmp1 =real(fft_adc_data);
fft_adc_data_im_tmp1 =imag(fft_adc_data);

fiel_id_dst = fopen('E:\work\sw\adc_data_h\vfft_re_data_input.dat','w');
for i = 1:4096
    for j = 1:32
        if(fft_adc_data_re_tmp1(j,i) <0)
            fprintf(fiel_id_dst,'%04s\n',lower((dec2hex(fft_adc_data_re_tmp1(j,i)+2^16))));
        else
            fprintf(fiel_id_dst,'%04s\n',lower((dec2hex(fft_adc_data_re_tmp1(j,i)))));
        end
    end
end
fclose(fiel_id_dst);

fiel_id_dst = fopen('E:\work\sw\adc_data_h\vfft_im_data_input.dat','w');
for i = 1:4096
    for j = 1:32
        if(fft_adc_data_im_tmp1(j,i) <0)
            fprintf(fiel_id_dst,'%04s\n',lower((dec2hex(fft_adc_data_im_tmp1(j,i)+2^16))));
        else
            fprintf(fiel_id_dst,'%04s\n',lower((dec2hex(fft_adc_data_im_tmp1(j,i)))));
        end
    end
end
fclose(fiel_id_dst);

for ii=1:MTD_N
    for jj=1:N
        if(real(fft_adc_data(ii,jj))>32767)
        fft_adc_data_r(ii,jj)=real(fft_adc_data(ii,jj))-65536;
        elseif(real(fft_adc_data(ii,jj))<-32768)
        fft_adc_data_r(ii,jj)=real(fft_adc_data(ii,jj))+65536;    
          else 
        fft_adc_data_r(ii,jj)=real(fft_adc_data(ii,jj));     
            end 
       
        if(imag(fft_adc_data(ii,jj))>32767)
        fft_adc_data_i(ii,jj)=imag(fft_adc_data(ii,jj))-65536;
        elseif(imag(fft_adc_data(ii,jj))<-32768)
        fft_adc_data_i(ii,jj)=imag(fft_adc_data(ii,jj))+65536;    
         else 
        fft_adc_data_i(ii,jj)=imag(fft_adc_data(ii,jj));     
        end 
        fft_adc_data(ii,jj)=  fft_adc_data_r(ii,jj) + 1i*fft_adc_data_i(ii,jj);
    end
end 

fft_adc_data_re_tmp2 =real(fft_adc_data);
fft_adc_data_im_tmp2 =real(fft_adc_data);
fft_adc_data_re_index = (fft_adc_data_re_tmp2 == fft_adc_data_re_tmp1 );
fft_adc_data_im_index = (fft_adc_data_im_tmp2 == fft_adc_data_im_tmp1 );
% figure;mesh(abs(fft_adc_data(:,:)),'DisplayName','fft_adc_data');
% xlabel('采样点数');ylabel('chirp数');title('1D FFT结果');


%% ===================== 2D FFT ======================%%
% for k=1:N/2
%     data_tmp = w_hamm.*fft_adc_data(:,k);
%     mtd_data(:,k)=fftshift(fft(data_tmp, MTD_N));
% %     mtd_data(:,k)=fft(data_tmp, MTD_N);
% end 

%% 2D FFT对齐FPGA
w_hamm_or = round(w_hamm*(2^15-1));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generics for this smoke test
generics.C_NFFT_MAX = 5;
generics.C_ARCH = 3;
generics.C_HAS_NFFT = 0;
generics.C_USE_FLT_PT = 0;
generics.C_INPUT_WIDTH = 16; % Must be 32 if C_USE_FLT_PT = 1
generics.C_TWIDDLE_WIDTH = 16; % Must be 24 or 25 if C_USE_FLT_PT = 1
generics.C_HAS_SCALING = 0; % Set to 0 if C_USE_FLT_PT = 1
generics.C_HAS_BFP = 0; % Set to 0 if C_USE_FLT_PT = 1
generics.C_HAS_ROUNDING = 0; % Set to 0 if C_USE_FLT_PT = 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
samples = 2^generics.C_NFFT_MAX;
 nfft = generics.C_NFFT_MAX;
 direction = 1; 
 if generics.C_ARCH == 1 || generics.C_ARCH == 3
    scaling_sch = ones(1,floor(nfft/2)) * 2;
    if mod(nfft,2) == 1
      scaling_sch = [scaling_sch 1];
    end
  else
    scaling_sch = ones(1,nfft);
  end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k=	1:N
    
    data_temp1 = floor(w_hamm_or.*fft_adc_data(:,k));   %% 15bit + 16bit
    data_temp2 = floor(data_temp1/2^16);
  
%     for ii=1:32
%     if(real(data_temp2(ii))<0)
%         data_temp2_r(ii)=real(data_temp2(ii)) + 2^16;
%     else 
%        data_temp2_r(ii)=real(data_temp2(ii)) ;
%     end 
%         if(imag(data_temp2(ii))<0)
%         data_temp2_i(ii)=imag(data_temp2(ii)) + 2^16;
%     else 
%        data_temp2_i(ii)=imag(data_temp2(ii)) ;
%     end 
%     data_temp2_r_hex{ii}=dec2hex( data_temp2_r(ii) ,4 );
%     data_temp2_i_hex{ii}=dec2hex( data_temp2_i(ii)  ,4);
%     end 
%     data_temp2_r_hex = data_temp2_r_hex';
%     data_temp2_i_hex = data_temp2_i_hex';
    input = data_temp2./2^15;
    [output, blkexp, overflow] = xfft_v9_1_bitacc_mex(generics, nfft, input, scaling_sch, direction);
    im_data = floor(imag(output)*2^15);
    re_data = floor(real(output)*2^15);
    mtd_data(:,k)= output.'*2^15;
%     mtd_data(:,k)=floor(fft(data_temp2, MTD_N));
end 

% if (compare == 1)
%     fullpath = mfilename('fullpath');
%     [path,name] = fileparts(fullpath);
%     cd(path);
%     load data_c.mat
%     mtd_data(:,1:2048) = data_c;
% end

% mtd_data_i=floor(imag(mtd_data(:,1:2048))/2^6);
% mtd_data_r=floor(real(mtd_data(:,1:2048))/2^6);

mtd_data_i=floor(imag(mtd_data(:,1:2048))/2^0);
mtd_data_r=floor(real(mtd_data(:,1:2048))/2^0);
rdm_data = mtd_data_r + 1i*mtd_data_i;

if(cfarFlag)
    rdm_data_s2 = mtd_data_i.*mtd_data_i + mtd_data_r.*mtd_data_r +1;
    rdm_data_s2H = rdm_data_s2.';
%     rdm_data_s2H_shift = fftshift(rdm_data_s2H);
    rdmap=floor(log2(rdm_data_s2H)*256);
else
    rdm_dataH = rdm_data.';
    rdmap = db(abs(rdm_dataH));
end


% for i = 1:2048
%     for j = 1:32
%         fprintf(file_id2,'%08s\n',lower(dec2hex(rdmap(i,j))));
%     end
% end   
 rdmap = floor(rdmap/4)*4;
 for i = 1:2048
    for j = 1:32
        fprintf(file_id2,'%08s\n',lower(dec2hex(rdmap(i,j))));
    end
 end  
a=1 ;




end
