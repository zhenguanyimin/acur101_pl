clear;
close all;
addpath('xlib');
%% read data in and win
%win
win = load('Hamm_Win.coe');
figure;
plot(win);
%din_fpga
path_din = "D:\repo\sim_lib\dsp_top_di.txt";
num_din = 4096*32;
[i_dsp_top] = j_readf(path_din,num_din,0);
% data_win_fpga
path_din = "D:\repo\sim_lib\win_do.txt";
[o_win_fpga] = j_readf(path_din,num_din,0);
% data_fft_fpga
path_din = "D:\repo\sim_lib\rfft_do.txt";
[o_rfft_fpga] = j_readf(path_din,num_din,1);
% data_r2c_fpga
path_din = "D:\repo\sim_lib\r2c_do.txt";
[o_r2c_fpga] = j_readf(path_din,num_din/2,1);

%% win
i_dsp_top = reshape (i_dsp_top,4096,32);
o_win_matlab = i_dsp_top .* win;
o_win_matlab = floor (o_win_matlab./2^15);

%% fft
C_NFFT_MAX = 12;
C_ARCH = 3;
C_INPUT_WIDTH = 16;
C_TWIDDLE_WIDTH = 16;
o_fft_matlab = zeros (4096,32);
for k = 1:32
    i_fft = o_win_matlab(:,k);
    i_fft = i_fft +0j;
    o_fft_matlab(:,k)  = aut_xfft_v9_1_mex (i_fft, C_NFFT_MAX, C_ARCH, C_INPUT_WIDTH, C_TWIDDLE_WIDTH );
end
o_fft_matlab = floor(o_fft_matlab./2^13);
%% compare fpga & matlab
% cmp win 
o_win_fpga = reshape (o_win_fpga,4096,32);
dif_win = o_win_fpga - o_win_matlab ;
dif_max = max(max(abs(dif_win)));
if (dif_max==0)
    fprintf('module win pass, compare rtl & matlab is ok! : %d \n',dif_max);
else
    fprintf('max dif_win is : %d \n',dif_max);
end
figure;
mesh (abs(dif_win));

% cmp fft
o_rfft_fpga = reshape (o_rfft_fpga,4096,32);
dif_rfft = o_rfft_fpga - o_fft_matlab ;
dif_max = max(max(abs(dif_rfft)));
if (dif_max==0)
    fprintf('module rfft pass, compare rtl & matlab is ok! : %d \n',dif_max);
else
    fprintf('max dif_win is : %d \n',dif_max);
end
figure;
mesh (abs(dif_rfft));

% cmp r2c
o_r2c_fpga = reshape (o_r2c_fpga,32,2048);
o_r2c_matlab  = o_fft_matlab(1:2048,:);
o_r2c_matlab  = o_r2c_matlab.';
dif_r2c = o_r2c_fpga - o_r2c_matlab;
mesh(abs(dif_r2c));




