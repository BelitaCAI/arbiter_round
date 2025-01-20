`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/01/20 16:03:23
// Design Name: 
// Module Name: arbiter_round
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


module arbiter_round(
input clk,
input rst_n,
input req0,
input req1,
input req2,
input req3,
output logic [2:0] gnt_id
    );

logic [2:0] gnt_id0,gnt_id1,gnt_id2,gnt_id3;
logic [2:0] gnt_id0_rord,gnt_id1_rord,gnt_id2_rord,gnt_id3_rord;

arbiter_fixed u0_arbiter_fixed(
.req0(req0),
.req1(req1),
.req2(req2),
.req3(req3),
.gnt_id(gnt_id0)
);    

arbiter_fixed u1_arbiter_fixed(
.req0(req1),
.req1(req2),
.req2(req3),
.req3(req0),
.gnt_id(gnt_id1)
);

arbiter_fixed u2_arbiter_fixed(
.req0(req2),
.req1(req3),
.req2(req0),
.req3(req1),
.gnt_id(gnt_id2)
);

arbiter_fixed u3_arbiter_fixed(
.req0(req3),
.req1(req0),
.req2(req1),
.req3(req2),
.gnt_id(gnt_id3)
);

assign gnt_id0_rord = (gnt_id0==0)?'d0:(gnt_id0==1)?'d1:(gnt_id0==2)?'d2:(gnt_id0==3)?'d3:'d4;
assign gnt_id1_rord = (gnt_id1==0)?'d1:(gnt_id1==1)?'d2:(gnt_id1==2)?'d3:(gnt_id1==3)?'d0:'d4;
assign gnt_id2_rord = (gnt_id2==0)?'d2:(gnt_id2==1)?'d3:(gnt_id2==2)?'d0:(gnt_id2==3)?'d1:'d4;
assign gnt_id3_rord = (gnt_id3==0)?'d3:(gnt_id3==1)?'d0:(gnt_id3==2)?'d1:(gnt_id3==3)?'d2:'d4;

logic [1:0] cur_state; // current highest priority
logic [1:0] nxt_state; // next highest priority
always@(*) begin
    case(cur_state)
        2'b00:begin
            if(req0)begin
                gnt_id = 'd0;
                nxt_state = 'd1;
            end
            else if(req1) begin
                gnt_id = 'd1;
                nxt_state = 'd2;
            end
            else if(req2) begin
                gnt_id = 'd2;
                nxt_state = 'd3;
            end
            else if (req3) begin
                gnt_id = 'd3;
                nxt_state = 'd0;
            end
            else begin
                gnt_id = 'd4;
                nxt_state = cur_state;
            end
        end
        2'b01:begin
            if(req1)begin
                gnt_id = 'd1;
                nxt_state = 'd2;
            end
            else if(req2) begin
                gnt_id = 'd2;
                nxt_state = 'd3;
            end
            else if(req3) begin
                gnt_id = 'd3;
                nxt_state = 'd0;
            end
            else if (req0) begin
                gnt_id = 'd0;
                nxt_state = 'd1;
            end
            else begin
                gnt_id = 'd4;
                nxt_state = cur_state;
            end
        end
        2'b10:begin
            if(req2)begin
                gnt_id = 'd2;
                nxt_state = 'd3;
            end
            else if(req3) begin
                gnt_id = 'd3;
                nxt_state = 'd0;
            end
            else if(req0) begin
                gnt_id = 'd0;
                nxt_state = 'd1;
            end
            else if (req1) begin
                gnt_id = 'd1;
                nxt_state = 'd2;
            end
            else begin
                gnt_id = 'd4;
                nxt_state = cur_state;
            end
        end
        2'b11:begin
            if(req3)begin
                gnt_id = 'd3;
                nxt_state = 'd0;
            end
            else if(req0) begin
                gnt_id = 'd0;
                nxt_state = 'd1;
            end
            else if(req1) begin
                gnt_id = 'd1;
                nxt_state = 'd2;
            end
            else if (req2) begin
                gnt_id = 'd2;
                nxt_state = 'd3;
            end
            else begin
                gnt_id = 'd4;
                nxt_state = cur_state;
            end
        end
    endcase
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cur_state <= 0;
        nxt_state <= 0;
    end
    else cur_state <= nxt_state;
end
 
endmodule
