module cntrl
(clk,n, a,m, s,k, we,a_mem);
input clk;
output [3:0] n; reg [3:0] n;
output [3:0] a; reg [3:0] a;
output [3:0] m; //reg [3:0] m;
output [2:0] a_mem;
output s, we; reg s ;
output [1:0] k; reg [1:0] k;
always @ (negedge clk)