PROGRAM PLC_PRG
VAR
	start:BOOL;
	start_:R_TRIG;
	stop:BOOL;
    motor:BOOL;
	sayac:TON;
	sayac_ET:TIME;
	edge_sensor:R_TRIG;
	counter:CTU;
	counter_:REAL;
	reset:BOOL;
	urun_sayisi:WORD;
	urun_sensor:BOOL;
	urun_kabul:BOOL;
	bekliyor:BOOL;
	uretim_devam:BOOL;
	parti_tamam:BOOL;
	urun_sure:ARRAY[0..4] OF TIME;
	urun_sure_1:TIME;
	urun_sure_2:TIME;
	urun_sure_3:TIME;
	urun_sure_4:TIME;
	urun_sure_5:TIME;
	I:INT:=0;
	en_uzun_sure:TIME;
	
	on_saniye_fazla:INT;
	
	lamba1:BOOL;
	lamba2:BOOL;
	lamba3:BOOL;
	lamba4:BOOL;
	lamba5:BOOL;
END_VAR

start_(CLK:=start);
IF start_.Q=TRUE THEN
	motor:=TRUE;	
END_IF	
IF stop THEN
    motor:=FALSE;	
END_IF
	
sayac(IN:=motor,PT:=T#20S);
sayac_ET:=sayac.ET;
IF sayac.Q=TRUE THEN
	urun_kabul:=TRUE;
ELSE
    urun_kabul:=FALSE;	
END_IF
edge_sensor(CLK:=urun_sensor);
 counter(CU:=edge_sensor.Q,RESET:=reset,PV:=5);
 urun_sayisi:=counter.CV;
 
 CASE urun_sayisi OF 
	 0:bekliyor:=TRUE;
	   uretim_devam:=FALSE;
	   parti_tamam:=FALSE;
	   
	 1..4:bekliyor:=FALSE;
	     uretim_devam:=TRUE;
	     parti_tamam:=FALSE;
  
	 5:  bekliyor:=FALSE;
	     uretim_devam:=FALSE;
	     parti_tamam:=TRUE;	 
ELSE		
         bekliyor:=FALSE;
	     uretim_devam:=FALSE;
	     parti_tamam:=FALSE;	  
 END_CASE
IF reset THEN
	FOR I:=0 TO 4 DO
		urun_sure[I]:=T#0S;
	END_FOR
END_IF

IF parti_tamam THEN
	motor:=FALSE;
END_IF
IF edge_sensor.Q=TRUE THEN 
   urun_sure[urun_sayisi-1]:=sayac.ET;
    
END_IF
urun_sure_1:=urun_sure[0];
urun_sure_2:=urun_sure[1];
urun_sure_3:=urun_sure[2];
urun_sure_4:=urun_sure[3];
urun_sure_5:=urun_sure[4];

en_uzun_sure:=T#0S;
FOR I:=0 TO 4 DO 
	IF urun_sure[I]>en_uzun_sure THEN 
		en_uzun_sure:=urun_sure[I];
	END_IF
END_FOR
IF  urun_sure_1>T#10S THEN 
	lamba1:=TRUE;
ELSE
     lamba1:=FALSE;	
END_IF
IF  urun_sure_2>T#10S THEN
	lamba2:=TRUE;
ELSE
     lamba2:=FALSE;		
END_IF
IF  urun_sure_3>T#10S THEN
	lamba3:=TRUE;
ELSE
     lamba3:=FALSE;		
END_IF
IF  urun_sure_4>T#10S THEN
	lamba4:=TRUE;
ELSE
     lamba4:=FALSE;		
END_IF
IF  urun_sure_5>T#10S THEN
	lamba5:=TRUE;
ELSE
     lamba5:=FALSE;		
END_IF
on_saniye_fazla:=0;
FOR I:=0 TO 4 DO 	
	IF urun_sure[I]>T#10S THEN
		on_saniye_fazla:=on_saniye_fazla+1;
	END_IF
END_FOR
