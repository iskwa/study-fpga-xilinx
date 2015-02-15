module SEC10(
	input	CLK, RST,
	output	reg	[7:0]	nSEG,
	output	reg			LD0,
	output		[3:0]	nAN
);

/* common terminal */
assign nAN = 4'b1110;

reg [25:0] cnt;
wire en1hz = (cnt==26'd49_999_999);

always @( posedge CLK ) begin
	if ( RST )
		cnt <= 26'b0;
	else if ( en1hz )
		cnt <= 26'b0;
	else
		cnt <= cnt + 26'b1;
end

always @( posedge CLK ) begin
	if ( cnt < 26'd25_000_000 )
		LD0 <= 1'b0;
	else
		LD0 <= 1'b1;
end

reg [3:0] sec;

always @( posedge CLK ) begin
	if ( RST )
		sec <= 4'h0;
	else if ( en1hz )
		if ( sec == 4'h9 )
			sec <= 4'h0;
		else
			sec <= sec + 4'h1;
end

always @* begin
	case ( sec )
		4'h0:	nSEG = 8'b11000000;
		4'h1:	nSEG = 8'b11111001;
		4'h2:	nSEG = 8'b10100100;
		4'h3:	nSEG = 8'b10110000;
        4'h4:   nSEG = 8'b10011001;
        4'h5:   nSEG = 8'b10010010;
        4'h6:   nSEG = 8'b10000010;
        4'h7:   nSEG = 8'b11011000;
        4'h8:   nSEG = 8'b10000000;
        4'h9:   nSEG = 8'b10010000;
		default:nSEG = 8'bxxxxxxxx;
	endcase
end

endmodule
