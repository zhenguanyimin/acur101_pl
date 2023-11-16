
function [data] = j_readf(path,num_data,with_im)
%%
%path = "D:\repo\sim_lib\rfft_di.txt";
%num_data = 4096*32;

fid_in = fopen(path,'r');

%%
data = zeros(num_data,1);
%with_im =0;
if (with_im == 1)
    for k = 1:num_data

        [A, COUNT] = fscanf(fid_in,'%s',1);
        im = A(1:4);
        im = hex2dec(im);
        re = A(5:8);
        re = hex2dec(re);
        if (im>=2^15)
           im = im -2^16; 
        end
        if (re>=2^15)
           re = re - 2^16; 
        end
        data(k) = re + 1j*im;
    end
else 
    for k = 1:num_data
        [A, COUNT] = fscanf(fid_in,'%s',1);
        re = A(1:4);
        re = hex2dec(re);
        if (re>=2^15)
           re = re - 2^16; 
        end
        data(k) = re ;
    end
end