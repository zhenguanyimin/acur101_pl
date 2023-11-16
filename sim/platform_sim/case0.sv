assign top.awmf_sdi_i  = 5'b11111;
initial 
begin 

    bit [31:0] data ;
    $display("-----------------------plat_form sim : case0 ----------------------------\n");
    axil_init();
    // #1000000;
    wait(~top.sys_rst) ;
    read_register(32'h8002_039c,data)              ;
    $display("addr: h8002_039c data : %h ",data)   ;
    set_register (32'h8002_0394,32'h5a5a_5a5a,4'hf) ;
    read_register(32'h8002_0394,data);
    $display("addr: h8002_0394 data : %h ",data)   ;
    read_register(32'h8002_0000,data);
    $display("addr: 0x8002_0000 data : %h ",data)   ;
    
    set_register (32'h8002_0104,32'h0000_0101,4'hf) ;
    read_register(32'h8002_0104,data)               ;
    $display("addr: h8002_0104 data : %h ",data)    ;

    set_register (32'h8002_0100,32'h0000_273a,4'hf) ;
    read_register(32'h8002_0100,data)               ;
    $display("addr: h8002_0100 data : %h ",data)    ;

    set_register (32'h8002_0100,32'h0080_273a,4'hf) ;
    read_register(32'h8002_0100,data)               ;
    $display("addr: h8002_0100 data : %h ",data)    ;
    #10000;
    read_register(32'h8002_0108,data)               ;
    $display("addr: h8002_0108 data : %h ",data)    ;

//      adc_3663_test
    set_register (32'h8002_0200,32'h0000_0602,4'hf) ;
    #3000;
    set_register (32'h8002_0200,32'h00c0_0602,4'hf) ;
    #10000;
    read_register(32'h8002_0204,data)               ;
    $display("addr: h8002_0204 data : %h ",data)    ;

//      chc2442 
    set_register (32'h8002_0210,32'h00eb_23f0,4'hf) ;
    read_register(32'h8002_0204,data)               ;
    $display("addr: h8002_0204 data : %h ",data)    ;
//----------------------awmf0165-test----------------------------

    
    // set_register (32'h8002_0390,32'h0000_2222,4'hf) ;

    // read_register(32'h8002_0390,data)               ;
    // $display("addr: h8002_0390 data : %h ",data)    ;

    set_register (32'h8002_0424,32'h0000_0003,4'hf) ;
    read_register(32'h8002_0424,data)               ;
    $display("addr: h8002_0424 data : %h ",data)    ;

//-----------------------group0---------------------------------
    set_register (32'h8002_0400,32'h1111_1111,4'hf) ;
    read_register(32'h8002_0400,data)               ;
    $display("addr: h8002_0400 data : %h ",data)    ;
    set_register (32'h8002_0400,32'h2222_2222,4'hf) ;
    read_register(32'h8002_0400,data)               ;
    $display("addr: h8002_0400 data : %h ",data)    ;
    set_register (32'h8002_0400,32'h3333_3333,4'hf) ;
    read_register(32'h8002_0400,data)               ;
    $display("addr: h8002_0400 data : %h ",data)    ;
    set_register (32'h8002_0400,32'h4444_4444,4'hf) ;
    read_register(32'h8002_0400,data)               ;
    $display("addr: h8002_0400 data : %h ",data)    ;
    set_register (32'h8002_0400,32'h5555_5555,4'hf) ;
    read_register(32'h8002_0400,data)               ;
    $display("addr: h8002_0400 data : %h ",data)    ;
    set_register (32'h8002_0400,32'h6666_6666,4'hf) ;
    read_register(32'h8002_0400,data)               ;
    $display("addr: h8002_0400 data : %h ",data)    ;
    set_register (32'h8002_0400,32'h7777_7777,4'hf) ;
    read_register(32'h8002_0400,data)               ;
    $display("addr: h8002_0400 data : %h ",data)    ;
    set_register (32'h8002_0400,32'h8888_8888,4'hf) ;
    read_register(32'h8002_0400,data)               ;
    $display("addr: h8002_0400 data : %h ",data)    ;


    #100000000;
    read_register(32'h8002_0404,data)               ;
    $display("addr: h8002_0404 data : %h ",data)    ;
    read_register(32'h8002_0408,data)               ;
    $display("addr: h8002_0408 data : %h ",data)    ;
    read_register(32'h8002_040c,data)               ;
    $display("addr: h8002_040c data : %h ",data)    ;
    read_register(32'h8002_0410,data)               ;
    $display("addr: h8002_0410 data : %h ",data)    ;
    read_register(32'h8002_0414,data)               ;
    $display("addr: h8002_0414 data : %h ",data)    ;
    read_register(32'h8002_0418,data)               ;
    $display("addr: h8002_0418 data : %h ",data)    ;
    read_register(32'h8002_041c,data)               ;
    $display("addr: h8002_041c data : %h ",data)    ;
    read_register(32'h8002_0420,data)               ;
    $display("addr: h8002_0420 data : %h ",data)    ;
//     set_register (32'h8002_0300,32'h1111_1111,4'hf) ;
//     read_register(32'h8002_0300,data)               ;
//     $display("addr: h8002_0300 data : %h ",data)    ;        
//     set_register (32'h8002_0300,32'h2222_2222,4'hf) ;
//     read_register(32'h8002_0300,data)               ;
//     $display("addr: h8002_0300 data : %h ",data)    ; 
//     set_register (32'h8002_0300,32'h3333_3333,4'hf) ;
//     read_register(32'h8002_0300,data)               ;
//     $display("addr: h8002_0300 data : %h ",data)    ; 
//     set_register (32'h8002_0300,32'h4444_4444,4'hf) ;
//     read_register(32'h8002_0300,data)               ;
//     $display("addr: h8002_0300 data : %h ",data)    ;
//     set_register (32'h8002_0300,32'h5555_5555,4'hf) ;
//     read_register(32'h8002_0300,data)               ;
//     $display("addr: h8002_0300 data : %h ",data)    ;
//     set_register (32'h8002_0300,32'h6666_6666,4'hf) ;
//     read_register(32'h8002_0300,data)               ;
//     $display("addr: h8002_0300 data : %h ",data)    ;
//     set_register (32'h8002_0300,32'h7777_7777,4'hf) ;
//     read_register(32'h8002_0300,data)               ;
//     $display("addr: h8002_0300 data : %h ",data)    ;
//     set_register (32'h8002_0300,32'h8888_8888,4'hf) ;
//     read_register(32'h8002_0300,data)               ;
//     $display("addr: h8002_0300 data : %h ",data)    ;
//     set_register (32'h8002_0300,32'h1111_1111,4'hf) ;
//     read_register(32'h8002_0300,data)               ;
//     $display("addr: h8002_0300 data : %h ",data)    ;        
//     set_register (32'h8002_0300,32'h1111_1111,4'hf) ;
//     read_register(32'h8002_0300,data)               ;
//     $display("addr: h8002_0300 data : %h ",data)    ; 
//     set_register (32'h8002_0300,32'h1111_1111,4'hf) ;
//     read_register(32'h8002_0300,data)               ;
//     $display("addr: h8002_0300 data : %h ",data)    ; 
//     set_register (32'h8002_0300,32'h1111_1111,4'hf) ;
//     read_register(32'h8002_0300,data)               ;
//     $display("addr: h8002_0300 data : %h ",data)    ;
//     set_register (32'h8002_0300,32'h1111_1111,4'hf) ;
//     read_register(32'h8002_0300,data)               ;
//     $display("addr: h8002_0300 data : %h ",data)    ;
//     set_register (32'h8002_0300,32'h1111_1111,4'hf) ;
//     read_register(32'h8002_0300,data)               ;
//     $display("addr: h8002_0300 data : %h ",data)    ;
//     set_register (32'h8002_0300,32'h1111_1111,4'hf) ;
//     read_register(32'h8002_0300,data)               ;
//     $display("addr: h8002_0300 data : %h ",data)    ;
//     set_register (32'h8002_0300,32'h1111_1111,4'hf) ;
//     read_register(32'h8002_0300,data)               ;
//     $display("addr: h8002_0300 data : %h ",data)    ;
//     set_register (32'h8002_0300,32'h2222_2222,4'hf) ;
//     read_register(32'h8002_0300,data)               ;
//     $display("addr: h8002_0300 data : %h ",data)    ;        
//     set_register (32'h8002_0300,32'h2222_2222,4'hf) ;
//     read_register(32'h8002_0300,data)               ;
//     $display("addr: h8002_0300 data : %h ",data)    ; 
//     set_register (32'h8002_0300,32'h2222_2222,4'hf) ;
//     read_register(32'h8002_0300,data)               ;
//     $display("addr: h8002_0300 data : %h ",data)    ; 
//     set_register (32'h8002_0300,32'h2222_2222,4'hf) ;
//     read_register(32'h8002_0300,data)               ;
//     $display("addr: h8002_0300 data : %h ",data)    ;
//     set_register (32'h8002_0300,32'h2222_2222,4'hf) ;
//     read_register(32'h8002_0300,data)               ;
//     $display("addr: h8002_0300 data : %h ",data)    ;
//     set_register (32'h8002_0300,32'h2222_2222,4'hf) ;
//     read_register(32'h8002_0300,data)               ;
//     $display("addr: h8002_0300 data : %h ",data)    ;
//     set_register (32'h8002_0300,32'h2222_2222,4'hf) ;
//     read_register(32'h8002_0300,data)               ;
//     $display("addr: h8002_0300 data : %h ",data)    ;
//     set_register (32'h8002_0300,32'h2222_2222,4'hf) ;
//     read_register(32'h8002_0300,data)               ;
//     $display("addr: h8002_0300 data : %h ",data)    ;   
    
    
// //----------------------------group1-----------------------------

//     set_register (32'h8002_0304,32'h1111_1111,4'hf) ;
//     read_register(32'h8002_0304,data)               ;
//     $display("addr: h8002_0304 data : %h ",data)    ;        
//     set_register (32'h8002_0304,32'h2222_2222,4'hf) ;
//     read_register(32'h8002_0304,data)               ;
//     $display("addr: h8002_0304 data : %h ",data)    ; 
//     set_register (32'h8002_0304,32'h3333_3333,4'hf) ;
//     read_register(32'h8002_0304,data)               ;
//     $display("addr: h8002_0304 data : %h ",data)    ; 
//     set_register (32'h8002_0304,32'h4444_4444,4'hf) ;
//     read_register(32'h8002_0304,data)               ;
//     $display("addr: h8002_0304 data : %h ",data)    ;
//     set_register (32'h8002_0304,32'h5555_5555,4'hf) ;
//     read_register(32'h8002_0304,data)               ;
//     $display("addr: h8002_0304 data : %h ",data)    ;
//     set_register (32'h8002_0304,32'h6666_6666,4'hf) ;
//     read_register(32'h8002_0304,data)               ;
//     $display("addr: h8002_0300 data : %h ",data)    ;
//     set_register (32'h8002_0304,32'h7777_7777,4'hf) ;
//     read_register(32'h8002_0304,data)               ;
//     $display("addr: h8002_0304 data : %h ",data)    ;
//     set_register (32'h8002_0304,32'h8888_8888,4'hf) ;
//     read_register(32'h8002_0304,data)               ;
//     $display("addr: h8002_0304 data : %h ",data)    ;
//     set_register (32'h8002_0304,32'h1111_1111,4'hf) ;
//     read_register(32'h8002_0304,data)               ;
//     $display("addr: h8002_0304 data : %h ",data)    ;        
//     set_register (32'h8002_0304,32'h2222_2222,4'hf) ;
//     read_register(32'h8002_0304,data)               ;
//     $display("addr: h8002_0304 data : %h ",data)    ; 
//     set_register (32'h8002_0304,32'h3333_3333,4'hf) ;
//     read_register(32'h8002_0304,data)               ;
//     $display("addr: h8002_0304 data : %h ",data)    ; 
//     set_register (32'h8002_0304,32'h4444_4444,4'hf) ;
//     read_register(32'h8002_0304,data)               ;
//     $display("addr: h8002_0304 data : %h ",data)    ;
//     set_register (32'h8002_0304,32'h5555_5555,4'hf) ;
//     read_register(32'h8002_0304,data)               ;
//     $display("addr: h8002_0304 data : %h ",data)    ;
//     set_register (32'h8002_0304,32'h6666_6666,4'hf) ;
//     read_register(32'h8002_0304,data)               ;
//     $display("addr: h8002_0300 data : %h ",data)    ;
//     set_register (32'h8002_0304,32'h7777_7777,4'hf) ;
//     read_register(32'h8002_0304,data)               ;
//     $display("addr: h8002_0304 data : %h ",data)    ;
//     set_register (32'h8002_0304,32'h8888_8888,4'hf) ;
//     read_register(32'h8002_0304,data)               ;
//     $display("addr: h8002_0304 data : %h ",data)    ;


// //----------------------------group2-----------------------------

//     set_register (32'h8002_0308,32'h1111_1111,4'hf) ;
//     read_register(32'h8002_0308,data)               ;
//     $display("addr: h8002_0308 data : %h ",data)    ;        
//     set_register (32'h8002_0308,32'h2222_2222,4'hf) ;
//     read_register(32'h8002_0308,data)               ;
//     $display("addr: h8002_0308 data : %h ",data)    ; 
//     set_register (32'h8002_0308,32'h3333_3333,4'hf) ;
//     read_register(32'h8002_0308,data)               ;
//     $display("addr: h8002_0308 data : %h ",data)    ; 
//     set_register (32'h8002_0308,32'h4444_4444,4'hf) ;
//     read_register(32'h8002_0308,data)               ;
//     $display("addr: h8002_0308 data : %h ",data)    ;
//     set_register (32'h8002_0308,32'h5555_5555,4'hf) ;
//     read_register(32'h8002_0308,data)               ;
//     $display("addr: h8002_0308 data : %h ",data)    ;
//     set_register (32'h8002_0308,32'h6666_6666,4'hf) ;
//     read_register(32'h8002_0308,data)               ;
//     $display("addr: h8002_0308 data : %h ",data)    ;
//     set_register (32'h8002_0308,32'h7777_7777,4'hf) ;
//     read_register(32'h8002_0308,data)               ;
//     $display("addr: h8002_0308 data : %h ",data)    ;
//     set_register (32'h8002_0308,32'h8888_8888,4'hf) ;
//     read_register(32'h8002_0308,data)               ;
//     $display("addr: h8002_0308 data : %h ",data)    ;

// //----------------------------group3-----------------------------

//     set_register (32'h8002_030c,32'h1111_1111,4'hf) ;
//     read_register(32'h8002_030c,data)               ;
//     $display("addr: h8002_030c data : %h ",data)    ;        
//     set_register (32'h8002_030c,32'h2222_2222,4'hf) ;
//     read_register(32'h8002_030c,data)               ;
//     $display("addr: h8002_030c data : %h ",data)    ; 
//     set_register (32'h8002_030c,32'h3333_3333,4'hf) ;
//     read_register(32'h8002_030c,data)               ;
//     $display("addr: h8002_030c data : %h ",data)    ; 
//     set_register (32'h8002_030c,32'h4444_4444,4'hf) ;
//     read_register(32'h8002_030c,data)               ;
//     $display("addr: h8002_030c data : %h ",data)    ;
//     set_register (32'h8002_030c,32'h5555_5555,4'hf) ;
//     read_register(32'h8002_030c,data)               ;
//     $display("addr: h8002_030c data : %h ",data)    ;
//     set_register (32'h8002_030c,32'h6666_6666,4'hf) ;
//     read_register(32'h8002_030c,data)               ;
//     $display("addr: h8002_030c data : %h ",data)    ;
//     set_register (32'h8002_030c,32'h7777_7777,4'hf) ;
//     read_register(32'h8002_030c,data)               ;
//     $display("addr: h8002_030c data : %h ",data)    ;
//     set_register (32'h8002_030c,32'h8888_8888,4'hf) ;
//     read_register(32'h8002_030c,data)               ;
//     $display("addr: h8002_030c data : %h ",data)    ;
//     set_register (32'h8002_0394,32'h8888_8888,4'hf) ;
//     read_register(32'h8002_030c,data)               ;
//     $display("addr: h8002_030c data : %h ",data)    ;
    
end