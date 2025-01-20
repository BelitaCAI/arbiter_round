`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/01/20 16:01:04
// Design Name: 
// Module Name: aribiter_fixed
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


module arbiter_fixed(
input req0,
input req1,
input req2,
input req3,
output logic [2:0] gnt_id
    );


always@(*)begin
    if (req0) gnt_id = 0;
    else if(req1) gnt_id =1;
    else if (req2) gnt_id = 2;
    else if (req3) gnt_id = 3;
    else gnt_id = 4;
end

endmodule
