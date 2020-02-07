	defb		$64		; garbage			;7b0c	64 

BASIC_120:
; 120 N1=N	
	defw		BASIC_130					; next line address		;7b0d	16 7b 
	defw		120							; line number			;7b0f	78 00 
	defb		"N1",$d5,"N",0				; Basic body			;7b11	4e 31 d5 4e 00

BASIC_130:
; 130 GOSUB1000
	defw		BASIC_140					; next line address		;7b16	20 7b 
	defw		130							; line number			;7b18	82 00 
	defb		$91,"1000",0				; Basic body			;7b1a	91 31 30 30 30 00

BASIC_140:
; 140 SA=N*256+N1
	defw		BASIC_150					; next line address		;7b20	30 7b 
	defw		140							; line number			;7b22	8c 00 
	defb		"SA",$d5,"N",$cf,"256",$cd,"N1",0; Basic Body		;7b24	53 41 d5 4e cf 32 35 36 cd 4e 31 00

BASIC_150:
; 150 PRINT"STAR 1 1A ??????
	defw		BASIC_160					; next line address		;7b30	4d 7b
	defw		150							; line number			;7b32	96 00 
	defb		$b2,$22,"STAR",$09,"1",$09,"1A"	; Basic body		;7b34	b2 22 53 54 41 52 09 31 09 31 41
	defb		$03,$03,$80,$b2,$00,$44,$1f,$8f,$1b,$fc,0,0,0,0 ; corrupted data		;7b3f	03 03 80 b2 00 44 1f 8f 1b fc 00 00 00 00

BASIC_160:
; 160 GOSUB1000
	defw		BASIC_170					; next line address		;7b4d	57 7b 
	defw		160							; line number			;7b4f	a0 00 
	defb		$91,"1000",0				; Basic body			;7b51	91 31 30 30 30 00

BASIC_170:
; 170 N1=N
	defw		BASIC_180					; next line address		;7b57	60 7b 
	defw		170							; line number			;7b59	aa 00 
	defb      "N1",$d5,"N",0  		    ; Basic body            ;7b5b	4e 31 d5 4e 00

BASIC_180:
; 180 GOSUB1000
	defw      BASIC_190			        ; next line addtess     ;7b60	6a 7b 
	defw		180							; line number			;7b62	b4 00 
	defb      $91,"1000",0    	        ; Basic body            ;7b64	91 31 30 30 30 00

BASIC_190:
; 190 TF=N*256+N1
	defw      BASIC_200                   ; next line address		;7b6a	7a 7b 
	defw		190							; line number			;7b6c	be 00 
	defb      "TF",$d5,"N",$cf,"256",$cd,"N1",0   ; Basic body    ;7b6e	54 46 d5 4e cf 32 35 36 cd 4e 31 00

BASIC_200:
; 200 PRINT"NO. OF BYTES TO TRANS :-?"TF
	defw      BASIC_210			        ; next line address     ;7b7a	9d 7b 
	defw      200			                ; line number           ;7b7c	c8 00 
	defb      $b2,$22,"NO. OF BYTES TO TRANS :-?",$22,"TF",0      ;7b7e	b2 22 4e 4f 2e 20 4f 46 20 42 59 54 45 53 20 54 4f 20 54 52 41 4e 53 20 3a 2d 3f 22 54 46 00

BASIC_210:
; 210 GOSUB1000
	defw      BASIC_220			        ; next line address     ;7b9d	a7 7b 
	defw      210                         ; line number   		;7b9f	d2 00
	defb      $91,"1000",0	            ; Basic body            ;7ba1	91 31 30 30 30 00

BASIC_220:
; 220 N1=N
	defw      BASIC_230                   ; nexy line address     ;7ba7	b0 7b
	defw      220                         ; line number		    ;7ba9	dc 00 
	defb      "N1",$d5,"N",0              ; Basic body		    ;7bab	4e 31 d5 4e 00

BASIC_230:	
; 230 GOSUB1000
    defw      BASIC_240                   ; nexy line address     ;7bb0	ba 7b 
	defw      230                         ; line number		    ;7bb2	e6 00 
	defb      $91,"1000",0	            ; Basic body            ;7bb4	91 31 30 30 30 00

BASIC_240:
; 240 EX=N*256+N1
	defw      BASIC_250                   ; nexy line address     ;7bba	ca 7b
	defw      240                         ; line number		    ;7bbc	f0 00
	defb      "EX",$d5,"N",$cf,"256",$cd,"N1",0 ; Basic body		;7bbe	45 58 d5 4e cf 32 35 36 cd 4e 31 00

BASIC_250:
; 250 PRINT"EXECUTION ADRESS :- "EX
	defw      BASIC_255                   ; nexy line address     ;7bca	e8 7b 
	defw      250                         ; line number		    ;7bcc	fa 00 
	defb      $b2,$22,"EXECUTION ADRESS :- ",$22,"EX",0	        ;7bce	b2 22 45 58 45 43 55 54 49 4f 4e 20 41 44 52 45 53 53 20 3a 2d 20 22 45 58 00

BASIC_255:
; 255 PRINT:PRINT"LOADIND DATA"
	defw      BASIC_260                   ; next line address     ;7be8	fe 7b
	defw      255                         ; line number		    ;7bea	ff 00 
	defb      $b2,":"			            ; Basic body            ;7bec	b2 3a
	defb      $b2,$22,"LOADIND DATA",$22,0; Basic body            ;7bee	b2 22 4c 4f 41 44 49 4e 44 20 44 41 54 41 22 00

BASIC_260:
; 260 FOR L=1 TO TF
	defw      BASIC_270                   ; next line address     ;7bfe	0a 7c
	defw      260                         ; line number		    ;7c00	04 01
	defb      $81,"L",$d5,"1",$bd,"TF",0  ; Basic body            ;7c00	81 4c d5 31 bd 54 46 00

BASIC_270:
; 270 GOSUB 1000
	defw      BASIC_280                   ; next line address     ;7c0a	14 7c 
	defw      270                         ; line number		    ;7c0c	0e 01 
	defb      $91,"1000",0	            ; Basic body            ;7c0e	91 31 30 30 30 00

BASIC_280:
; 280 POKE SA,N
	defw      BASIC_290                   ; next line address     ;7c14	1e 7c
	defw      280                         ; line number		    ;7c16	18 01 
	defb      $b1,"SA,N",0		        ; Basic body            ;7c18	b1 53 41 2c 4e 00

BASIC_290:	
; 290 SA = SA + 1
    defw      BASIC_300                   ; next line address     ;7c1e	2a 7c
	defw      290                         ; line number		    ;7c20	22 01
	defb      "SA",$d5,"SA",$cd,"1",0		; Basic body            ;7c22	53 41 d5 53 41 cd 31 00

BASIC_300:
; 300 NEXT
    defw      BASIC_310                   ; next line address     ;7c2a	30 7c 
	defw      300                         ; line number		    ;7c2c	2c 01
	defb      $87,0		                ; Basic body            ;7c2e	87 00

BASIC_310:
; 310 N=INT(EX/256) : N2=EX-N1*256
	defw      BASIC_320                   ; next line address     ;7c30	4e 7c 
	defw      310                         ; line number		    ;7c32	36 01
	defb      "N1",$d5,$d8,"(EX",$d0,"256)",$3a    ; Basic body   ;7c34	4e 31 d5 d8 28 45 58 d0 32 35 36 29 3a
	defb      "N2",$d5,"EX",$ce,"N1",$cf,"256",0  ; Basic body	;7c41	4e 32 d5 45 58 ce 4e 31 cf 32 35 36 00

BASIC_320:
; 320 POKE 30862,N2 : POKE 30863,N1
    defw      BASIC_325                   ; next line address     ;7c4e	66 7c 
	defw      320                         ; line number		    ;7c50	40 01
	defb      $b1,"30862,N2",$3a          ; Basic body		    ;7c52	b1 33 30 38 36 32 2c 4e 32 3a
	defb      $b1,"30863,N1",0		    ; Basic body            ;7c5c	b1 33 30 38 36 33 2c 4e 31 00 
BASIC_325:
; 325 STOP
	defw      BASIC_330                   ; next line address     ;7c66	6c 7c
	defw      325                         ; line number		    ;7c68	45 01 
	defb      $94,0               		; Basic body            ;7c6a	94 00 

BASIC_330:
; 330 X=USR(0)
	defw      BASIC_990                   ; next line address     ;7c6c	77 7c 
	defw      330                         ; line number		    ;7c6e	4a 01 
	defb      "X",$d5,$c1,"(0)",0		    ; Basic body            ;7c70	58 d5 c1 28 30 29 00

BASIC_990:
; 990 STOP
	defw      BASIC_1000                  ; next line address     ;7c77	7d 7c 
	defw      990                         ; line number		    ;7c79	de 03 
	defb      $94,0			            ; Basic body            ;7c7b	94 00 

BASIC_1000:
; 1000 OUT 224,128
	defw      BASIC_1010                  ; next line address     ;7c7d	8a 7c 
	defw      1000                        ; line number		    ;7c7f	e8 03 
	defb      $a0,"224,128",0			    ; Basic body            ;7c81	a0 32 32 34 2c 31 32 38 00 

BASIC_1010:
; 1010 A=INP(224) AND 128
    defw      BASIC_1020                  ; next line address     ;7c8a	9b 7c 
	defw      1010                        ; line number		    ;7c8c	f2 03
	defb      "A",$d5,$db,"(224)",$d2,"128",0    ; Basic body		;7c8e	41 d5 28 32 32 34 29 d2 31 32 38 00

BASIC_1020:
; 1020 IF A=0 THEN 1010
	defw      BASIC_1030                  ; next line address     ;7c9b	a9 7c 
	defw      1020		                ; line number           ;7c9d	fc 03
	defb      $8f,"A",$d5,"0",$ca,"1010",0  ; Basic body			;7c9f	8f 41 d5 30 ca 31 30 31 30 00 

BASIC_1030:
; 1030 N=INP(224) AND 15
	defw      BASIC_1040                  ; next line address     ;7ca9	b9 7c
	defw      1030		                ; line number           ;7cab	06 04 
	defb      "N",$d5,$db,"(224)",$d2,"15",0  ; Basic body		;7cad	4e d5 defb 28 32 32 34 29 d2 31 35 00

BASIC_1040:
; 1040 OUT 224,0
	defw      BASIC_1050                  ; next line address     ;7cb9	c4 7c
	defw      1040		                ; line number           ;7cbb	10 04
	defb      $a0,"224,0",0			    ; Basic body            ;7cbd	a0 32 32 34 2c 30 00 

BASIC_1050:
; 1050 A=INP(224) AND 128
	defw      BASIC_1060                  ; next line address     ;7cc4	d5 7c 
	defw      1050		                ; line number           ;7cc6	1a 04 
	defb      "A",$d5,$db,"(224)",$d2,"128",0 ; Basic body		;7cc8	41 d5 defb 28 32 32 34 29 d2 31 32 38 00 

BASIC_1060:
; 1060 IF A=128 THAN 1050
	defw      BASIC_1070                  ; next line address     ;7cd5	e5 7c 
	defw      1060		                ; line number           ;7cd7	24 04 
	defb      $8f,"A",$d5,"128",$ca,"1050",0	; Basic body		;7cd9	8f 41 d5 31 32 38 ca 31 30 35 30 00

BASIC_1070:
; 1070 A=INP(224) AND 15
	defw      BASIC_1080                  ; next line address     ;7ce5	f5 7c 
	defw      1070		                ; line number           ;7ce7	2e 04 
	defb      "A",$d5,$db,"(224)",$d2,"15",0 ; Basic body		    ;7ce9	41 d5 defb 28 32 32 34 29 d2 31 35 00

BASIC_1080:
; 1080 N=N+A*16
    defw      BASIC_1090                  ; next line address     ;7cf5	02 7d 
	defw      1080		                ; line number           ;7cf7	38 04  
	defb      "N",$d5,"N",$cd,"A",$cf,"16",0	; Basic body		;7cf9	4e d5 4e cd 41 cf 31 36 00 

BASIC_1090:
; 1090 RETURN
	defw      BASIC_0004                  ; next line address     ;7d02	08 7d 
	defw      1090		                ; line number           ;7d04	42 04
	defb      $92,0                       ; Basic body			;7d06	92 00 

BASIC_0004:
; 4 A
	defw      0                           ; next line address     ;7d08	00 00 
	defw      4			                ; line number           ;7d0a	04 00 
	defb      "A",0		                ; Basic data	        ;7d0c	41 00 

	nop			;7d0e	00 	. 
	nop			;7d0f	00 	. 
	add a,e			;7d10	83 	. 
	inc b			;7d11	04 	. 
	nop			;7d12	00 	. 
	ld c,(hl)			;7d13	4e 	N 
	nop			;7d14	00 	. 
	nop			;7d15	00 	. 
	ld d,087h		;7d16	16 87 	. . 
	inc b			;7d18	04 	. 
	ld sp,0004eh		;7d19	31 4e 00 	1 N . 
	nop			;7d1c	00 	. 
	ld a,h			;7d1d	7c 	| 
	add a,a			;7d1e	87 	. 
	inc b			;7d1f	04 	. 
	ld b,c			;7d20	41 	A 
	ld d,e			;7d21	53 	S 
	nop			;7d22	00 	. 
	ret pe			;7d23	e8 	. 
	ld a,a			;7d24	7f 	 
	adc a,a			;7d25	8f 	. 
	inc b			;7d26	04 	. 
	ld b,(hl)			;7d27	46 	F 
	ld d,h			;7d28	54 	T 
	nop			;7d29	00 	. 
	nop			;7d2a	00 	. 
	nop			;7d2b	00 	. 
	adc a,c			;7d2c	89 	. 
	inc b			;7d2d	04 	. 
	ld e,b			;7d2e	58 	X 
	ld b,l			;7d2f	45 	E 
	nop			;7d30	00 	. 
	ret pe			;7d31	e8 	. 
	ld a,l			;7d32	7d 	} 
	adc a,a			;7d33	8f 	. 
	inc b			;7d34	04 	. 
	nop			;7d35	00 	. 
	ld c,h			;7d36	4c 	L 
	nop			;7d37	00 	. 
	add a,b			;7d38	80 	. 
	nop			;7d39	00 	. 
	adc a,c			;7d3a	89 	. 
	inc b			;7d3b	04 	. 
	ld (0004eh),a		;7d3c	32 4e 00 	2 N . 
	nop			;7d3f	00 	. 
	ld (hl),h			;7d40	74 	t 
	adc a,b			;7d41	88 	. 
	inc b			;7d42	04 	. 
	ld b,l			;7d43	45 	E 
	ld b,h			;7d44	44 	D 
	nop			;7d45	00 	. 
	nop			;7d46	00 	. 
	nop			;7d47	00 	. 
	nop			;7d48	00 	. 
	ld c,(hl)			;7d49	4e 	N 
	nop			;7d4a	00 	. 
	rst 38h			;7d4b	ff 	. 
	nop			;7d4c	00 	. 
	rst 38h			;7d4d	ff 	. 
	nop			;7d4e	00 	. 
	rst 38h			;7d4f	ff 	. 
	djnz $+1		;7d50	10 ff 	. . 
	nop			;7d52	00 	. 
	rst 38h			;7d53	ff 	. 
	nop			;7d54	00 	. 
	rst 38h			;7d55	ff 	. 
	nop			;7d56	00 	. 
	rst 38h			;7d57	ff 	. 
	nop			;7d58	00 	. 
	rst 38h			;7d59	ff 	. 
	nop			;7d5a	00 	. 
	rst 38h			;7d5b	ff 	. 
	nop			;7d5c	00 	. 
	rst 38h			;7d5d	ff 	. 
	nop			;7d5e	00 	. 
	rst 38h			;7d5f	ff 	. 
	nop			;7d60	00 	. 
	cp a			;7d61	bf 	. 
	nop			;7d62	00 	. 
	rst 38h			;7d63	ff 	. 
	nop			;7d64	00 	. 
	rst 38h			;7d65	ff 	. 
	nop			;7d66	00 	. 
	rst 38h			;7d67	ff 	. 
	jr nz,$+1		;7d68	20 ff 	  . 
	nop			;7d6a	00 	. 
	rst 38h			;7d6b	ff 	. 
	nop			;7d6c	00 	. 
	rst 38h			;7d6d	ff 	. 
	nop			;7d6e	00 	. 
	rst 38h			;7d6f	ff 	. 
	nop			;7d70	00 	. 
	rst 38h			;7d71	ff 	. 
	nop			;7d72	00 	. 
	rst 38h			;7d73	ff 	. 
	nop			;7d74	00 	. 
	rst 38h			;7d75	ff 	. 
	nop			;7d76	00 	. 
	rst 38h			;7d77	ff 	. 
	nop			;7d78	00 	. 
	rst 18h			;7d79	df 	. 
	nop			;7d7a	00 	. 
	rst 38h			;7d7b	ff 	. 
	nop			;7d7c	00 	. 
	rst 38h			;7d7d	ff 	. 
	add a,b			;7d7e	80 	. 
	cp a			;7d7f	bf 	. 
	nop			;7d80	00 	. 
	rst 38h			;7d81	ff 	. 
	nop			;7d82	00 	. 
	rst 38h			;7d83	ff 	. 
	nop			;7d84	00 	. 
	rst 38h			;7d85	ff 	. 
	nop			;7d86	00 	. 
l7d87h:
	ld a,a			;7d87	7f 	 
	nop			;7d88	00 	. 
	rst 38h			;7d89	ff 	. 
	nop			;7d8a	00 	. 
	rst 38h			;7d8b	ff 	. 
	nop			;7d8c	00 	. 
	rst 38h			;7d8d	ff 	. 
	djnz $+1		;7d8e	10 ff 	. . 
	nop			;7d90	00 	. 
	cp a			;7d91	bf 	. 
	nop			;7d92	00 	. 
	rst 38h			;7d93	ff 	. 
	nop			;7d94	00 	. 
	rst 38h			;7d95	ff 	. 
	nop			;7d96	00 	. 
	xor a			;7d97	af 	. 
	add a,b			;7d98	80 	. 
	rst 38h			;7d99	ff 	. 
	nop			;7d9a	00 	. 
	rst 38h			;7d9b	ff 	. 
	nop			;7d9c	00 	. 
	rst 38h			;7d9d	ff 	. 
	nop			;7d9e	00 	. 
	rst 38h			;7d9f	ff 	. 
	nop			;7da0	00 	. 
	ld a,a			;7da1	7f 	 
	nop			;7da2	00 	. 
	rst 38h			;7da3	ff 	. 
	nop			;7da4	00 	. 
	rst 38h			;7da5	ff 	. 
	nop			;7da6	00 	. 
	rst 28h			;7da7	ef 	. 
	sub b			;7da8	90 	. 
	rst 38h			;7da9	ff 	. 
	nop			;7daa	00 	. 
	rst 38h			;7dab	ff 	. 
	nop			;7dac	00 	. 
	rst 38h			;7dad	ff 	. 
	nop			;7dae	00 	. 
	cp a			;7daf	bf 	. 
	ld d,b			;7db0	50 	P 
	ld a,a			;7db1	7f 	 
	nop			;7db2	00 	. 
	rst 38h			;7db3	ff 	. 
	nop			;7db4	00 	. 
	rst 38h			;7db5	ff 	. 
	nop			;7db6	00 	. 
	rst 38h			;7db7	ff 	. 
	nop			;7db8	00 	. 
	cp a			;7db9	bf 	. 
	nop			;7dba	00 	. 
	rst 38h			;7dbb	ff 	. 
	nop			;7dbc	00 	. 
	rst 38h			;7dbd	ff 	. 
	nop			;7dbe	00 	. 
	rst 38h			;7dbf	ff 	. 
	nop			;7dc0	00 	. 
l7dc1h:
	ld a,a			;7dc1	7f 	 
	nop			;7dc2	00 	. 
	rst 38h			;7dc3	ff 	. 
	nop			;7dc4	00 	. 
	rst 38h			;7dc5	ff 	. 
	nop			;7dc6	00 	. 
	xor a			;7dc7	af 	. 
	add a,b			;7dc8	80 	. 
	xor a			;7dc9	af 	. 
	nop			;7dca	00 	. 
	rst 38h			;7dcb	ff 	. 
	nop			;7dcc	00 	. 
	rst 38h			;7dcd	ff 	. 
	add a,b			;7dce	80 	. 
	rst 38h			;7dcf	ff 	. 
	jr nz,$+1		;7dd0	20 ff 	  . 
	nop			;7dd2	00 	. 
	rst 38h			;7dd3	ff 	. 
	nop			;7dd4	00 	. 
	rst 38h			;7dd5	ff 	. 
	jr nz,l7d87h		;7dd6	20 af 	  . 
	nop			;7dd8	00 	. 
	ld a,a			;7dd9	7f 	 
	nop			;7dda	00 	. 
	rst 38h			;7ddb	ff 	. 
	nop			;7ddc	00 	. 
	rst 38h			;7ddd	ff 	. 
	add a,b			;7dde	80 	. 
	rst 38h			;7ddf	ff 	. 
	djnz l7dc1h		;7de0	10 df 	. . 
	nop			;7de2	00 	. 
	rst 38h			;7de3	ff 	. 
	nop			;7de4	00 	. 
	rst 38h			;7de5	ff 	. 
	nop			;7de6	00 	. 
	rst 38h			;7de7	ff 	. 
	nop			;7de8	00 	. 
	rst 38h			;7de9	ff 	. 
	nop			;7dea	00 	. 
	rst 38h			;7deb	ff 	. 
	nop			;7dec	00 	. 
	rst 38h			;7ded	ff 	. 
	nop			;7dee	00 	. 
	rst 18h			;7def	df 	. 
	nop			;7df0	00 	. 
	rst 38h			;7df1	ff 	. 
	nop			;7df2	00 	. 
	rst 38h			;7df3	ff 	. 
	nop			;7df4	00 	. 
	rst 38h			;7df5	ff 	. 
	nop			;7df6	00 	. 
	ld a,a			;7df7	7f 	 
	nop			;7df8	00 	. 
	rst 38h			;7df9	ff 	. 
	nop			;7dfa	00 	. 
	rst 38h			;7dfb	ff 	. 
	nop			;7dfc	00 	. 
	rst 38h			;7dfd	ff 	. 
	jr nz,$+1		;7dfe	20 ff 	  . 
	nop			;7e00	00 	. 
	rst 38h			;7e01	ff 	. 
	nop			;7e02	00 	. 
	rst 38h			;7e03	ff 	. 
	nop			;7e04	00 	. 
	rst 38h			;7e05	ff 	. 
	nop			;7e06	00 	. 
	rst 38h			;7e07	ff 	. 
	jr nz,$+1		;7e08	20 ff 	  . 
	nop			;7e0a	00 	. 
	rst 38h			;7e0b	ff 	. 
	nop			;7e0c	00 	. 
	rst 38h			;7e0d	ff 	. 
	nop			;7e0e	00 	. 
	rst 38h			;7e0f	ff 	. 
	nop			;7e10	00 	. 
	rst 38h			;7e11	ff 	. 
	nop			;7e12	00 	. 
	rst 38h			;7e13	ff 	. 
	nop			;7e14	00 	. 
	rst 38h			;7e15	ff 	. 
	nop			;7e16	00 	. 
	rst 38h			;7e17	ff 	. 
	nop			;7e18	00 	. 
	rst 38h			;7e19	ff 	. 
	nop			;7e1a	00 	. 
	rst 38h			;7e1b	ff 	. 
	nop			;7e1c	00 	. 
	rst 38h			;7e1d	ff 	. 
	nop			;7e1e	00 	. 
	cp a			;7e1f	bf 	. 
	nop			;7e20	00 	. 
	rst 38h			;7e21	ff 	. 
	nop			;7e22	00 	. 
	rst 38h			;7e23	ff 	. 
	nop			;7e24	00 	. 
	rst 38h			;7e25	ff 	. 
	nop			;7e26	00 	. 
	rst 18h			;7e27	df 	. 
	nop			;7e28	00 	. 
	rst 38h			;7e29	ff 	. 
	nop			;7e2a	00 	. 
	rst 38h			;7e2b	ff 	. 
	nop			;7e2c	00 	. 
	rst 38h			;7e2d	ff 	. 
	ld b,b			;7e2e	40 	@ 
	rst 38h			;7e2f	ff 	. 
	nop			;7e30	00 	. 
	ld a,a			;7e31	7f 	 
	nop			;7e32	00 	. 
	rst 38h			;7e33	ff 	. 
	nop			;7e34	00 	. 
	rst 38h			;7e35	ff 	. 
	nop			;7e36	00 	. 
	rst 38h			;7e37	ff 	. 
	ld b,b			;7e38	40 	@ 
	rst 38h			;7e39	ff 	. 
	nop			;7e3a	00 	. 
	rst 38h			;7e3b	ff 	. 
	nop			;7e3c	00 	. 
	rst 38h			;7e3d	ff 	. 
	add a,b			;7e3e	80 	. 
	rst 28h			;7e3f	ef 	. 
	nop			;7e40	00 	. 
	rst 18h			;7e41	df 	. 
	nop			;7e42	00 	. 
	rst 38h			;7e43	ff 	. 
	nop			;7e44	00 	. 
	rst 38h			;7e45	ff 	. 
	nop			;7e46	00 	. 
	rst 28h			;7e47	ef 	. 
	add a,b			;7e48	80 	. 
	rst 38h			;7e49	ff 	. 
	nop			;7e4a	00 	. 
	rst 38h			;7e4b	ff 	. 
	nop			;7e4c	00 	. 
	rst 38h			;7e4d	ff 	. 
	djnz $+1		;7e4e	10 ff 	. . 
	nop			;7e50	00 	. 
	rst 28h			;7e51	ef 	. 
	nop			;7e52	00 	. 
	rst 38h			;7e53	ff 	. 
	nop			;7e54	00 	. 
	rst 38h			;7e55	ff 	. 
	nop			;7e56	00 	. 
	rst 38h			;7e57	ff 	. 
	nop			;7e58	00 	. 
	rst 38h			;7e59	ff 	. 
	nop			;7e5a	00 	. 
	rst 38h			;7e5b	ff 	. 
	nop			;7e5c	00 	. 
	rst 38h			;7e5d	ff 	. 
	nop			;7e5e	00 	. 
	rst 38h			;7e5f	ff 	. 
	djnz $+1		;7e60	10 ff 	. . 
	nop			;7e62	00 	. 
	rst 38h			;7e63	ff 	. 
	nop			;7e64	00 	. 
	rst 38h			;7e65	ff 	. 
	nop			;7e66	00 	. 
	cp a			;7e67	bf 	. 
	nop			;7e68	00 	. 
	rst 38h			;7e69	ff 	. 
	nop			;7e6a	00 	. 
	rst 38h			;7e6b	ff 	. 
	nop			;7e6c	00 	. 
	rst 38h			;7e6d	ff 	. 
	nop			;7e6e	00 	. 
	rst 38h			;7e6f	ff 	. 
	djnz $+1		;7e70	10 ff 	. . 
	nop			;7e72	00 	. 
	rst 38h			;7e73	ff 	. 
	nop			;7e74	00 	. 
	rst 38h			;7e75	ff 	. 
	add a,b			;7e76	80 	. 
l7e77h:
	rst 38h			;7e77	ff 	. 
	nop			;7e78	00 	. 
	rst 38h			;7e79	ff 	. 
	nop			;7e7a	00 	. 
	rst 38h			;7e7b	ff 	. 
	nop			;7e7c	00 	. 
	rst 38h			;7e7d	ff 	. 
	jr nz,$+1		;7e7e	20 ff 	  . 
	nop			;7e80	00 	. 
	ld a,a			;7e81	7f 	 
	nop			;7e82	00 	. 
	rst 38h			;7e83	ff 	. 
	nop			;7e84	00 	. 
	rst 38h			;7e85	ff 	. 
	nop			;7e86	00 	. 
	ld a,a			;7e87	7f 	 
	nop			;7e88	00 	. 
	rst 28h			;7e89	ef 	. 
	nop			;7e8a	00 	. 
	rst 38h			;7e8b	ff 	. 
	nop			;7e8c	00 	. 
	rst 38h			;7e8d	ff 	. 
	sub b			;7e8e	90 	. 
	rst 38h			;7e8f	ff 	. 
	ld b,b			;7e90	40 	@ 
	rst 38h			;7e91	ff 	. 
	nop			;7e92	00 	. 
	rst 38h			;7e93	ff 	. 
	nop			;7e94	00 	. 
	rst 38h			;7e95	ff 	. 
	add a,b			;7e96	80 	. 
	rst 38h			;7e97	ff 	. 
	nop			;7e98	00 	. 
	rst 38h			;7e99	ff 	. 
	nop			;7e9a	00 	. 
	rst 38h			;7e9b	ff 	. 
	nop			;7e9c	00 	. 
	rst 38h			;7e9d	ff 	. 
	add a,b			;7e9e	80 	. 
	rst 38h			;7e9f	ff 	. 
	nop			;7ea0	00 	. 
	ld a,a			;7ea1	7f 	 
	nop			;7ea2	00 	. 
	rst 38h			;7ea3	ff 	. 
	nop			;7ea4	00 	. 
	rst 38h			;7ea5	ff 	. 
	nop			;7ea6	00 	. 
	rst 38h			;7ea7	ff 	. 
	nop			;7ea8	00 	. 
	rst 38h			;7ea9	ff 	. 
	nop			;7eaa	00 	. 
	rst 38h			;7eab	ff 	. 
	nop			;7eac	00 	. 
	rst 38h			;7ead	ff 	. 
	nop			;7eae	00 	. 
	rst 38h			;7eaf	ff 	. 
	ld b,b			;7eb0	40 	@ 
	rst 38h			;7eb1	ff 	. 
	nop			;7eb2	00 	. 
	rst 38h			;7eb3	ff 	. 
	nop			;7eb4	00 	. 
	rst 38h			;7eb5	ff 	. 
	jr nz,l7e77h		;7eb6	20 bf 	  . 
	nop			;7eb8	00 	. 
	rst 8			;7eb9	cf 	. 
	nop			;7eba	00 	. 
	rst 38h			;7ebb	ff 	. 
	nop			;7ebc	00 	. 
	rst 38h			;7ebd	ff 	. 
	nop			;7ebe	00 	. 
	rst 18h			;7ebf	df 	. 
	jr nz,$+1		;7ec0	20 ff 	  . 
	nop			;7ec2	00 	. 
	rst 38h			;7ec3	ff 	. 
	nop			;7ec4	00 	. 
	rst 38h			;7ec5	ff 	. 
	nop			;7ec6	00 	. 
	rst 18h			;7ec7	df 	. 
	nop			;7ec8	00 	. 
	rst 18h			;7ec9	df 	. 
	nop			;7eca	00 	. 
	rst 38h			;7ecb	ff 	. 
	nop			;7ecc	00 	. 
	rst 38h			;7ecd	ff 	. 
	add a,b			;7ece	80 	. 
	rst 38h			;7ecf	ff 	. 
	nop			;7ed0	00 	. 
	rst 38h			;7ed1	ff 	. 
	nop			;7ed2	00 	. 
	rst 38h			;7ed3	ff 	. 
	nop			;7ed4	00 	. 
	rst 38h			;7ed5	ff 	. 
	add a,b			;7ed6	80 	. 
	ld a,a			;7ed7	7f 	 
	add a,b			;7ed8	80 	. 
	rst 38h			;7ed9	ff 	. 
	nop			;7eda	00 	. 
	rst 38h			;7edb	ff 	. 
	nop			;7edc	00 	. 
	rst 38h			;7edd	ff 	. 
	add a,b			;7ede	80 	. 
	rst 38h			;7edf	ff 	. 
	add a,b			;7ee0	80 	. 
	rst 38h			;7ee1	ff 	. 
	nop			;7ee2	00 	. 
	rst 38h			;7ee3	ff 	. 
	nop			;7ee4	00 	. 
	rst 38h			;7ee5	ff 	. 
	nop			;7ee6	00 	. 
	rst 38h			;7ee7	ff 	. 
	ld b,b			;7ee8	40 	@ 
	rst 38h			;7ee9	ff 	. 
	nop			;7eea	00 	. 
	rst 38h			;7eeb	ff 	. 
	nop			;7eec	00 	. 
	rst 38h			;7eed	ff 	. 
	nop			;7eee	00 	. 
	ld l,a			;7eef	6f 	o 
	nop			;7ef0	00 	. 
	cp a			;7ef1	bf 	. 
	nop			;7ef2	00 	. 
	rst 38h			;7ef3	ff 	. 
	ld hl,l7f02h		;7ef4	21 02 7f 	! .  
	ld de,0ce00h		;7ef7	11 00 ce 	. . . 
	ld bc,00100h		;7efa	01 00 01 	. . . 
	ldir		;7efd	ed b0 	. . 
	jp 0ce00h		;7eff	c3 00 ce 	. . . 
l7f02h:
	nop			;7f02	00 	. 
	nop			;7f03	00 	. 
	nop			;7f04	00 	. 
	nop			;7f05	00 	. 
	nop			;7f06	00 	. 
	nop			;7f07	00 	. 
	di			;7f08	f3 	. 
	ld sp,0cdf0h		;7f09	31 f0 cd 	1 . . 
	ld a,(06800h)		;7f0c	3a 00 68 	: . h 
	and 0f7h		;7f0f	e6 f7 	. . 
	ld (06800h),a		;7f11	32 00 68 	2 . h 
	ld hl,07000h		;7f14	21 00 70 	! . p 
	ld de,07001h		;7f17	11 01 70 	. . p 
	ld (hl),020h		;7f1a	36 20 	6   
	ld bc,00100h		;7f1c	01 00 01 	. . . 
	ldir		;7f1f	ed b0 	. . 
	ld hl,0cedah		;7f21	21 da ce 	! . . 
	ld de,07000h		;7f24	11 00 70 	. . p 
	call 0cec8h		;7f27	cd c8 ce 	. . . 
	ld hl,07020h		;7f2a	21 20 70 	!   p 
	ld bc,0ce00h		;7f2d	01 00 ce 	. . . 
	ld a,003h		;7f30	3e 03 	> . 
l7f32h:
	push af			;7f32	f5 	. 
	call 0ce77h		;7f33	cd 77 ce 	. w . 
	ld e,a			;7f36	5f 	_ 
	call 0ce77h		;7f37	cd 77 ce 	. w . 
	ld d,a			;7f3a	57 	W 
	call 0cea2h		;7f3b	cd a2 ce 	. . . 
	push hl			;7f3e	e5 	. 
	push bc			;7f3f	c5 	. 
	pop hl			;7f40	e1 	. 
	ld (hl),e			;7f41	73 	s 
	inc hl			;7f42	23 	# 
	ld (hl),d			;7f43	72 	r 
	inc hl			;7f44	23 	# 
	push hl			;7f45	e5 	. 
	pop bc			;7f46	c1 	. 
	pop hl			;7f47	e1 	. 
	ld de,0001ch		;7f48	11 1c 00 	. . . 
	add hl,de			;7f4b	19 	. 
	pop af			;7f4c	f1 	. 
	dec a			;7f4d	3d 	= 
	jr nz,l7f32h		;7f4e	20 e2 	  . 
	call 0ced3h		;7f50	cd d3 ce 	. . . 
	call 0ced3h		;7f53	cd d3 ce 	. . . 
	call 0ced3h		;7f56	cd d3 ce 	. . . 
	call 0ced3h		;7f59	cd d3 ce 	. . . 
	ld hl,(0ce00h)		;7f5c	2a 00 ce 	* . . 
	ld bc,(0ce02h)		;7f5f	ed 4b 02 ce 	. K . . 
l7f63h:
	call 0ce77h		;7f63	cd 77 ce 	. w . 
	ld (hl),a			;7f66	77 	w 
	inc hl			;7f67	23 	# 
	dec bc			;7f68	0b 	. 
	ld a,b			;7f69	78 	x 
	or c			;7f6a	b1 	. 
	jr nz,l7f63h		;7f6b	20 f6 	  . 
	ld a,(06800h)		;7f6d	3a 00 68 	: . h 
	or 008h		;7f70	f6 08 	. . 
	ld (06800h),a		;7f72	32 00 68 	2 . h 
	ld hl,(0ce04h)		;7f75	2a 04 ce 	* . . 
	jp (hl)			;7f78	e9 	. 
	nop			;7f79	00 	. 
	ld a,080h		;7f7a	3e 80 	> . 
	out (0e0h),a		;7f7c	d3 e0 	. . 
l7f7eh:
	in a,(0e0h)		;7f7e	defb e0 	. . 
	bit 7,a		;7f80	cb 7f 	.  
	jr z,l7f7eh		;7f82	28 fa 	( . 
	in a,(0e0h)		;7f84	defb e0 	. . 
	bit 7,a		;7f86	cb 7f 	.  
	jp z,0ce7ch		;7f88	ca 7c ce 	. | . 
	and 00fh		;7f8b	e6 0f 	. . 
	ld d,a			;7f8d	57 	W 
	out (0e0h),a		;7f8e	d3 e0 	. . 
l7f90h:
	in a,(0e0h)		;7f90	defb e0 	. . 
	bit 7,a		;7f92	cb 7f 	.  
	jr nz,l7f90h		;7f94	20 fa 	  . 
	in a,(0e0h)		;7f96	defb e0 	. . 
	bit 7,a		;7f98	cb 7f 	.  
	jr nz,l7f90h		;7f9a	20 f4 	  . 
	rlca			;7f9c	07 	. 
	rlca			;7f9d	07 	. 
	rlca			;7f9e	07 	. 
	rlca			;7f9f	07 	. 
	and 0f0h		;7fa0	e6 f0 	. . 
	or d			;7fa2	b2 	. 
	ret			;7fa3	c9 	. 
	ld a,d			;7fa4	7a 	z 
	call 0ceabh		;7fa5	cd ab ce 	. . . 
	ld a,e			;7fa8	7b 	{ 
	call 0ceabh		;7fa9	cd ab ce 	. . . 
	ret			;7fac	c9 	. 
	push af			;7fad	f5 	. 
	rrca			;7fae	0f 	. 
	rrca			;7faf	0f 	. 
	rrca			;7fb0	0f 	. 
	rrca			;7fb1	0f 	. 
	and 00fh		;7fb2	e6 0f 	. . 
	call 0cebch		;7fb4	cd bc ce 	. . . 
	pop af			;7fb7	f1 	. 
	and 00fh		;7fb8	e6 0f 	. . 
	call 0cebch		;7fba	cd bc ce 	. . . 
	ret			;7fbd	c9 	. 
	cp 00ah		;7fbe	fe 0a 	. . 
	jp m,0cec3h		;7fc0	fa c3 ce 	. . . 
	add a,007h		;7fc3	c6 07 	. . 
	add a,030h		;7fc5	c6 30 	. 0 
	ld (hl),a			;7fc7	77 	w 
	inc hl			;7fc8	23 	# 
	ret			;7fc9	c9 	. 
	ld a,(hl)			;7fca	7e 	~ 
	or a			;7fcb	b7 	. 
	ret z			;7fcc	c8 	. 
	sub 040h		;7fcd	d6 40 	. @ 
	ld (de),a			;7fcf	12 	. 
	inc hl			;7fd0	23 	# 
	inc de			;7fd1	13 	. 
	jp 0cec8h		;7fd2	c3 c8 ce 	. . . 
	dec bc			;7fd5	0b 	. 
	ld a,b			;7fd6	78 	x 
	or c			;7fd7	b1 	. 
	jp nz,0ced3h		;7fd8	c2 d3 ce 	. . . 
	ret			;7fdb	c9 	. 
	ld d,h			;7fdc	54 	T 
	ld d,d			;7fdd	52 	R 
	ld b,c			;7fde	41 	A 
	ld c,(hl)			;7fdf	4e 	N 
	ld d,e			;7fe0	53 	S 
	ld b,(hl)			;7fe1	46 	F 
	ld b,l			;7fe2	45 	E 
	ld d,d			;7fe3	52 	R 
	ld d,d			;7fe4	52 	R 
	ld c,c			;7fe5	49 	I 
	ld c,(hl)			;7fe6	4e 	N 
	ld b,a			;7fe7	47 	G 
	defb " D"		;7fe8	20 44 	  D 
	ld b,c			;7fea	41 	A 
	ld d,h			;7feb	54 	T 
	ld b,c			;7fec	41 	A 
	nop			;7fed	00 	. 
	inc l			;7fee	2c 	, 
	ld b,d			;7fef	42 	B 
	ld c,h			;7ff0	4c 	L 
	ld b,c			;7ff1	41 	A 
	ld c,(hl)			;7ff2	4e 	N 
	ld c,e			;7ff3	4b 	K 
	nop			;7ff4	00 	. 
	rst 38h			;7ff5	ff 	. 
	nop			;7ff6	00 	. 
l7ff7h:
	rlca			;7ff7	07 	. 
	nop			;7ff8	00 	. 
	ld c,(hl)			;7ff9	4e 	N 
	jr nz,l7ff7h		;7ffa	20 fb 	  . 
	nop			;7ffc	00 	. 
	defb 0fdh,000h,007h	;illegal sequence		;7ffd	fd 00 07 	. . . 
