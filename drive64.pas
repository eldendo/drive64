(* drive64: read a d64 file
* (c)2017 by ir. Marc Dendooven *)

program drive64;

type track = 1..40;
     sector = 0..20;
     buffer = array[0..255] of byte;

var drive: file of byte; 
    SpT: array[1..40] of integer;
    buf: buffer;
    t: track;

    procedure rdBuf(t: track; s: sector);
    var i: track;
	sn : integer = 0;
	j: byte;
    begin
	for i := 2 to t do sn := sn + SpT[i-1];
//	rdBuf := sn + s;
	seek(drive, sn+s-1);
	blockRead(drive,buf,1);
	for j := 0 to 255 do 
	    begin 
		if j mod 8 = 0 then begin writeln; write(hexstr(j,4),': ') end; 
		write(hexStr(buf[j],2),' ')
	    end
    end;


begin

    writeln('welcome to drive64');
    writeln('(c)2017 by ir. Marc Dendooven');
    
    for t := 1  to 17 do SpT[t]:=21;
    for t := 18 to 24 do SpT[t]:=19;
    for t := 25 to 30 do SpT[t]:=18;
    for t := 31 to 40 do SpT[t]:=17;
    
    assign(drive,'Fort Apocalypse.d64');
    reset(drive, 256);
    
    rdBuf(18,1);
    
    close(drive)
end.
