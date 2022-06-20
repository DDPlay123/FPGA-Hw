//----------------------------------------------------
//Design Name: 4bit binary adder
//File Name: adder_4bit.v
//Function: 4位元二進制加法器
//----------------------------------------------------
module adder_4bit(S, Cout, A, B, Cin);

output reg [3:0]S;
output reg Cout;
input [3:0]A, B;
input Cin;

always {Cout, S} = A + B + Cin;

endmodule 