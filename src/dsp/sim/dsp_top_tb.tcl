cd D:/repo/sim_lib

#ip
vcom D:/repo/24G.gen/sources_1/ip/*/sim/*.vhd
vlog D:/repo/24G.gen/sources_1/ip/*/sim/*.v
vlog D:/repo/acur101_pl/prj/prj.gen/sources_1/ip/rfft_ram_32x4096/sim/*.v

#tb
vlog D:/repo/acur101_pl/src/dsp/sim/*.sv

#design
vlog D:/repo/acur101_pl/src/dsp/*.sv
vlog D:/repo/acur101_pl/src/dsp/*.v

vsim -voptargs=+acc work.dsp_top_tb -L xpm -L blk_mem_gen_v8_4_4