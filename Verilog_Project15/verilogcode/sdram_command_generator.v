module sdram_command_generator(

input wire precharge,
input wire refresh,
input wire load_mode,
input wire read_cmd,
input wire write_cmd,
input wire activate,

output reg cs_n,
output reg ras_n,
output reg cas_n,
output reg we_n
);

always @(*)

begin

    // Default = NOP
    cs_n  = 0;
    ras_n = 1;
    cas_n = 1;
    we_n  = 1;

    if(activate)

    begin

        ras_n = 0;
        cas_n = 1;
        we_n  = 1;

    end

    else if(read_cmd)

    begin

        ras_n = 1;
        cas_n = 0;
        we_n  = 1;

    end


    else if(write_cmd)

    begin

        ras_n = 1;
        cas_n = 0;
        we_n  = 0;

    end

    else if(precharge)

    begin

        ras_n = 0;
        cas_n = 1;
        we_n  = 0;

    end

    else if(refresh)

    begin

        ras_n = 0;
        cas_n = 0;
        we_n  = 1;

    end

    else if(load_mode)

    begin

        ras_n = 0;
        cas_n = 0;
        we_n  = 0;

    end

end
endmodule