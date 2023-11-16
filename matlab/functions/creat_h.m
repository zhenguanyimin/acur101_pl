function creat_h(adc_data,file_id)
%     fprintf(file_id,'#ifndef _ADC_TEST_DATA_H_\n#define _ADC_TEST_DATA_\n\n char adc_data[256*1024*3]  ={\n');
%     for m = 1:3     
        for i = 1:32
            for j = 1:4096 
                fprintf(file_id,'0x%02s,',dec2hex(mod(adc_data(i,j),256)));
                fprintf(file_id,'0x%02s,',dec2hex(floor(adc_data(i,j)/256)));
            end
            fprintf(file_id,'\n');
%         end
    end
% fclose(file_id);
 
%     for i = 1:size(adc_data)
%         fprintf(fiel_id_dst,'0x%02s,',dec2hex(adc_data(i)));
%         if(mod(i,8)==0)
%             fprintf(fiel_id_dst,'\n');
%         end
%     end

end
% fiel_id_dst = fopen('E:\work\sw\adc_data_h\adc_test_data.dat','w');
% fprintf(fiel_id_dst,'#ifndef _ADC_TEST_DATA_H_\n#define _ADC_TEST_DATA_\n\n char adc_data[256*1024*3]  ={\n');
% 
% fiel_id_src = fopen('E:\work\sw\adc_data\35205.dat');
% adc_data = fread(fiel_id_src);
% for i = 1:size(adc_data)
%     fprintf(fiel_id_dst,'0x%02s,',dec2hex(adc_data(i)));
%     if(mod(i,8)==0)
%         fprintf(fiel_id_dst,'\n');
%     end
% end
% fiel_id_src = fopen('E:\work\sw\adc_data\35206.dat');
% adc_data = fread(fiel_id_src);
% for i = 1:size(adc_data)
%     fprintf(fiel_id_dst,'0x%02s,',dec2hex(adc_data(i)));
%     if(mod(i,8)==0)
%         fprintf(fiel_id_dst,'\n');
%     end
% end
% 
% fiel_id_src = fopen('E:\work\sw\adc_data\35207.dat');
% adc_data = fread(fiel_id_src);
% for i = 1:size(adc_data)
%     if(i == 262144 )
%         fprintf(fiel_id_dst,'0x%02s};\n\n#endif',dec2hex(adc_data(i)));
%     else
%         fprintf(fiel_id_dst,'0x%02s,',dec2hex(adc_data(i)));
%     end
%     if(mod(i,8)==0)
%         fprintf(fiel_id_dst,'\n');
%     end
% end
% fclose(fiel_id_dst);


    


