`timescale 1ns / 1ps

module Final(clk, reset, V, A, B, up, down, mid, a, b, c, d, e, f, g);
    input clk;
    input reset;
    input [7:0] A;
    input [7:0] B;
    input up, down, mid;
    output reg [7:0] V;
    output reg a, b, c, d, e, f, g;
    
    reg [31:0] k;
    reg [25:0] result;

    parameter zero = 3'b000;
    parameter one = 3'b001;
    parameter two = 3'b010;
    parameter three = 3'b011;
    parameter four = 3'b100;
    parameter five = 3'b101;
    parameter six = 3'b110;
    parameter seven = 3'b111;

    
    reg[2:0] curState;
    reg[15:0] digit;
    
    always @(posedge clk or negedge reset) begin
        k = k+1;
        if (reset == 0) begin
            k = 0;
        end
        else begin
           if(k %250000 == 0) begin
                k = 0;
                case(curState)
                    zero: curState = one;
                    one: curState = two;
                    two: curState = three;
                    three: curState = four;
                    four: curState = five;
                    five: curState = six;
                    six: curState = seven;
                    seven: curState = zero;
                endcase
            end
        end
    end
    
    always @(curState) begin
        case(curState)
               zero: begin V = 8'b00000001; digit=result%10; end
               one: begin V = 8'b00000010; digit=(result%100)/10; end
               two: begin V = 8'b00000100; digit=(result%1000)/100; end
               three: begin V = 8'b00001000; digit=(result%10000)/1000; end  
               four: begin V = 8'b00010000; digit=(result%100000)/10000; end
               five: begin V = 8'b00100000; digit=(result%1000000)/100000; end
               six: begin V = 8'b01000000; digit=(result%10000000)/1000000; end
              seven: begin V = 8'b10000000; digit=(result%100000000)/10000000; end
            endcase
        
    end
    
    always @(up or down or mid) begin
        if(up == 1) begin
            result = A + B;
        end   
        else if (mid == 1)
            result = A * B;
        else if (down == 1) begin
            if(A>B) result = A-B; else result = 0;
        end
        else
            result = 2076021;
    end
   
    
    always @(digit) begin
        case(digit)
            0: begin a=1; b=1; c=1; d=1; e=1; f=1; g=0; end
            1: begin a=0; b=1; c=1; d=0; e=0; f=0; g=0; end
            2: begin a=1; b=1; c=0; d=1; e=1; f=0; g=1; end
            3: begin a=1; b=1; c=1; d=1; e=0; f=0; g=1; end
            4: begin a=0; b=1; c=1; d=0; e=0; f=1; g=1; end
            5: begin a=1; b=0; c=1; d=1; e=0; f=1; g=1; end
            6: begin a=1; b=0; c=1; d=1; e=1; f=1; g=1; end
            7: begin a=1; b=1; c=1; d=0; e=0; f=0; g=0; end
            8: begin a=1; b=1; c=1; d=1; e=1; f=1; g=1; end
            9: begin a=1; b=1; c=1; d=1; e=0; f=1; g=1; end
            default: begin a=0; b=0; c=0; d=0; e=0; f=0; g=0; end
        endcase
    end
endmodule
