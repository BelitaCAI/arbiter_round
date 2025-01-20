`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/01/20 17:52:35
// Design Name: 
// Module Name: arbiter_round_strong
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module arbiter_round_strong(
input clk,
input rst_n,
input req0,
input req1,
input req2,
input req3,
output logic [2:0] gnt_id
    );
logic prir0,prir1,prir2,prir3;
logic gnt_id_fixed;
arbiter_fixed u_arbiter_fixed(
.prir0(req0),
.prir1(req1),
.prir2(req2),
.prir3(req3),
.gnt_id_fixed(gnt_id)
);

logic [7:0]cur_state, nxt_state;
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cur_state <= {2'b00,2'b01,2'b10,2'b11}; // {priority order: req0-> req1-> req2-> req3}
        nxt_state <= {2'b00,2'b01,2'b10,2'b11};
    end
    else cur_state <= cur_state;
end

always@(*) begin
    case(cur_state)
        8'b00xxxxxx:begin
            if(req0) begin
                nxt_state = {nxt_state<<2,2'b00};
            end
        end
        8'b01xxxxxx:begin
            if(req1) begin
                nxt_state={nxt_state<<2,2'b01};
            end
        end
        8'b10xxxxxx:begin
            if(req2) begin
                nxt_state={nxt_state<<2,2'b10};
            end
        end
        8'b11xxxxxx:begin
            if(req3) begin
                nxt_state={nxt_state<<2,2'b11};
            end
        end
        8'bxx00xxxx:begin
            if(req0) nxt_state={nxt_state[7:6],nxt_state[3:0],2'b00};
        end
        8'bxx01xxxx:begin
            if(req1) nxt_state={nxt_state[7:6],nxt_state[3:0],2'b01};
        end
        8'bxx10xxxx:begin
            if(req2) nxt_state={nxt_state[7:6],nxt_state[3:0],2'b10};
        end
        8'bxx11xxxx:begin
            if(req3) nxt_state={nxt_state[7:6],nxt_state[3:0],2'b11};
        end
        8'bxxxx00xx:begin
            if(req0) nxt_state={nxt_state[7:4],nxt_state[1:0],2'b00};
        end
        8'bxxxx01xx:begin
            if(req1) nxt_state={nxt_state[7:4],nxt_state[1:0],2'b01};
        end
        8'bxxxx10xx:begin
            if(req2) nxt_state={nxt_state[7:4],nxt_state[1:0],2'b10};
        end
        8'bxxxx11xx:begin
            if(req3) nxt_state={nxt_state[7:4],nxt_state[1:0],2'b11};
        end
        default: nxt_state =nxt_state;
    endcase
end

assign prir0 = cur_state[7:6];
assign prir1 = cur_state[5:4];
assign prir2 = cur_state[3:2];
assign prir3 = cur_state[1:0];

assign gnt_id = (gnt_id_fixed==0)?cur_state[7:6]:(gnt_id_fixed==1)?cur_state[5:4]:(gnt_id_fixed==2)?cur_state[3:2]:(gnt_id_fixed==3)?cur_state[1:0]:3'd4;

endmodule
