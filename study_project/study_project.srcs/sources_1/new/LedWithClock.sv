module LedWithclock(
    input           clk,
    output logic    red,
    output logic    green,
    output logic    blue

);

logic [28:0] counter;


always_ff @(posedge clk) begin
    
    case(counter) 
        29'd150_000_000 : begin 
            red <= ~red;
            
        end 
        29'd300_000_000 : begin
            red <= ~red; 
            blue <= ~blue;
            
        end    
        29'd450_000_000 : begin
            blue <= ~blue;
            green <= ~green;
        end
        29'd530_000_000 : green <= ~green;    
    endcase

    counter <= counter + 1;
end
    
endmodule