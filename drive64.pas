(* drive64: read a d64 file
* (c)2017 by ir. Marc Dendooven *)

program drive64;

type track = 1..40;
     sector = 0..20;
     buffer = array[0..255] of byte;

var drive: file of byte; 
    SpT: array[1..40] of integer;
    buf: buffer;
    t,dt: integer; //track;
    i,j: integer;
    ds: sector;

    procedure rdBuf(t: track; s: sector; var buf: buffer);
    var i: track;
	sn : integer = 0;
    begin
	for i := 2 to t do sn := sn + SpT[i-1];
	seek(drive, sn+s);
	blockRead(drive,buf,1)
    end;


begin

    writeln('welcome to drive64');
    writeln('(c)2017 by ir. Marc Dendooven');
    writeln('-----------------------------');
    
    for t := 1  to 17 do SpT[t]:=21;
    for t := 18 to 24 do SpT[t]:=19;
    for t := 25 to 30 do SpT[t]:=18;
    for t := 31 to 40 do SpT[t]:=17;
    
    assign(drive,'files/1988-11.d64');
    reset(drive, 256);
    
    rdBuf(18,0,buf);
    writeln('DOS version: ', chr(buf[$02]));
    write('Disk Name: '); for j := $90 to $9F do if buf[j] <> $A0 then write(chr(buf[j])); writeln;
    writeln('DOS type: ', chr(buf[$A5]), chr(buf[$A6]));
    writeln('-----------------------------');
    dt := 18; ds := 1;
    
    while dt <> 0 do 
	begin
	    rdBuf(dt,ds,buf);
	    dt := buf[0]; ds := buf[1]; 
	    
	    for j := 0 to 7 do
		begin
		    for i := j*32+$5 to j*32+$14 do if buf[i] <> $A0 then write(chr(buf[i])); writeln;
		end;
 

(*
	    for j := 0 to 255 do 
		begin 
		    if j mod 8 = 0 then begin writeln; write(hexstr(j,4),': ') end; 
		    write(hexStr(buf[j],2),' ')
		end
*)		
    	end;
    close(drive)
end.
