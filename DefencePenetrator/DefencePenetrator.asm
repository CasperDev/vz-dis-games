;***********************************************************************************************
;
; 	Defence Penetrator 
;   Disect by Casper 18.02.2020
;
;	Verified with SjASMPlus Z80 Cross-Assembler v1.14.3 (https://github.com/z00m128/sjasmplus)
;-----------------------------------------------------------------------------------------------

	MACRO	FNAME 	filename
.beg		defb 	filename
			block 	16-$+.beg
			defb	0
	ENDM

; Relative address 7AD1
;***********************************************************************************************
; File Header Block
	defb 	"VZF0"                  			; [0000] Magic
	FNAME	"DEF PENETRATOR  "
	defb	$F0             					; File Type
    defw    BASIC_START        					; Destination/Basic Start address


;***********************************************************************************************
; SYSTEM CONSTANTS
IOLATCH         	equ     $6800       		; (WR) Hardware IO Latch, (RD) Keyboard all Keys
VDG_GFX_COLORS_0	equ		%00001000 			; GFX MODE, background Green
VDG_GFX_COLORS_1	equ		%00011000 			; GFX MODE, background Buff
VDG_MODE_CSS_MASK	equ		%00011000  			; mask to keep current Gfx settings
BIT_SPK_MINUS   	equ     00100000b   		; Speake Pin (-)
BIT_SPK_PLUS   		equ     00000001b   		; Speake Pin (+)
SPEAKER_PINS		equ		BIT_SPK_MINUS|BIT_SPK_PLUS
VRAM            	equ     $7000       		; Video RAM base address

;************************************************************************
; Keyboard Map              ADRES   |   D5  D4      D3  D2      D1  D0  |
;-----------------------------------|-----------------------------------|
KEYS_ROW_0  		equ     $6ffe   ;   R   Q       E           W   T   |
KEYS_ROW_1  		equ     $6ffd   ;   F   A       D   CTRL    S   G   |
KEYS_ROW_2  		equ     $6ffb   ;   V   Z       C   SHIFT   X   B   |
KEYS_ROW_3  		equ     $6ff7   ;   4   1       3           2   5   |
KEYS_ROW_4  		equ     $6fef   ;   M   SPACE   ,           .   N   |
KEYS_ROW_5  		equ     $6fdf   ;   7   0       8   -       9   6   |
KEYS_ROW_6  		equ     $6fbf   ;   U   P       I   RETURN  O   Y   |
KEYS_ROW_7  		equ     $6f7f   ;   J   ;       K   :       L   H   |

;***********************************************************************************************
;
;  B A S I C   S T A R T  

	org		$7ae9

BASIC_START	

;***********************************************************************************************
; 10 POKE30862,156:POKE30863,134:X=USR(0)
; -- Machine code start at $869c
BASIC_10
	defw	$7b0a								; next BASIC line				;7ae9	0a 7b
	defw	10									; BASIC line number				;7aeb	0a 00 
	defb	$b1,"30862,156"						; POKE 30862,156				;7aed	b1 33 30 38 36 32 2c 31 35 36 	1 5 6 
	defb	$3a									; instruction end				;7af7	3a 
	defb	$b1,"30863,134"						; POKE30863,134					;7af8	b1 33 30 38 36 33 2c 31 33 34 	1 3 4 
	defb	$3a									; instruction end				;7b02	3a 
	defb	"X",$d5,$c1,"(0)"					; X=USR(0)						;7b03	58 d5 c1 28 30 29
	defb	0									; end of line					;7b09	00 

BASIC_END	
	defw	0									; next line 0 means end			;7b0a	00 00 
	defw	255									; BASIC line number				;7b0c	ff 00 	. 
	ld e,a			;7b0e	5f 	_ 
	jr nz,$+1		;7b0f	20 ff 	  . 
	nop			;7b11	00 	. 
	rst 38h			;7b12	ff 	. 
	ld b,b			;7b13	40 	@ 
	rst 38h			;7b14	ff 	. 
	add a,b			;7b15	80 	. 
	rst 38h			;7b16	ff 	. 
	ld (hl),05fh		;7b17	36 5f 	6 _ 
	jr nz,$+1		;7b19	20 ff 	  . 
	nop			;7b1b	00 	. 
	rst 38h			;7b1c	ff 	. 
	ld b,b			;7b1d	40 	@ 
	rst 38h			;7b1e	ff 	. 
	add a,b			;7b1f	80 	. 
	rst 38h			;7b20	ff 	. 
	ld sp,02929h		;7b21	31 29 29 	1 ) ) 
	ld a,(05a8fh)		;7b24	3a 8f 5a 	: . Z 
	sub 033h		;7b27	d6 33 	. 3 
l7b29h:
	ld (05acah),a		;7b29	32 ca 5a 	2 . Z 
	push de			;7b2c	d5 	. 
	ld e,d			;7b2d	5a 	Z 
	call 03436h		;7b2e	cd 36 34 	. 6 4 
	ld a,(02448h)		;7b31	3a 48 24 	: H $ 
l7b34h:
	push de			;7b34	d5 	. 
	ret m			;7b35	f8 	. 
	jr z,$+74		;7b36	28 48 	( H 
l7b38h:
	inc h			;7b38	24 	$ 
	inc l			;7b39	2c 	, 
	ld sp,0cd29h		;7b3a	31 29 cd 	1 ) . 
	rst 30h			;7b3d	f7 	. 
	jr z,l7b9ah		;7b3e	28 5a 	( Z 
	add hl,hl			;7b40	29 	) 
	nop			;7b41	00 	. 
	nop			;7b42	00 	. 
	nop			;7b43	00 	. 
	rst 38h			;7b44	ff 	. 
	nop			;7b45	00 	. 
	ld e,a			;7b46	5f 	_ 
	jr nz,$+1		;7b47	20 ff 	  . 
	nop			;7b49	00 	. 
	rst 38h			;7b4a	ff 	. 
	ld b,b			;7b4b	40 	@ 
	rst 38h			;7b4c	ff 	. 
	add a,b			;7b4d	80 	. 
	rst 38h			;7b4e	ff 	. 
	ld sp,02929h		;7b4f	31 29 29 	1 ) ) 
	ld a,(05a8fh)		;7b52	3a 8f 5a 	: . Z 
	sub 033h		;7b55	d6 33 	. 3 
	ld (05acah),a		;7b57	32 ca 5a 	2 . Z 
	push de			;7b5a	d5 	. 
	ld e,d			;7b5b	5a 	Z 
	call 03436h		;7b5c	cd 36 34 	. 6 4 
	ld a,(02448h)		;7b5f	3a 48 24 	: H $ 
	push de			;7b62	d5 	. 
	ret m			;7b63	f8 	. 
	jr z,$+74		;7b64	28 48 	( H 
	inc h			;7b66	24 	$ 
	inc l			;7b67	2c 	, 
	ld sp,0cd29h		;7b68	31 29 cd 	1 ) . 
	rst 30h			;7b6b	f7 	. 
	jr z,l7bc8h		;7b6c	28 5a 	( Z 
	add hl,hl			;7b6e	29 	) 
	nop			;7b6f	00 	. 
	nop			;7b70	00 	. 
	nop			;7b71	00 	. 
	rst 38h			;7b72	ff 	. 
	nop			;7b73	00 	. 
	ld e,a			;7b74	5f 	_ 
	jr nz,$+1		;7b75	20 ff 	  . 
	nop			;7b77	00 	. 
	rst 38h			;7b78	ff 	. 
	ld b,b			;7b79	40 	@ 
	rst 38h			;7b7a	ff 	. 
	add a,b			;7b7b	80 	. 
	rst 38h			;7b7c	ff 	. 
	inc l			;7b7d	2c 	, 
	ld sp,02929h		;7b7e	31 29 29 	1 ) ) 
	adc a,034h		;7b81	ce 34 	. 4 
	jr c,l7b85h		;7b83	38 00 	8 . 
l7b85h:
	nop			;7b85	00 	. 
	nop			;7b86	00 	. 
	rst 38h			;7b87	ff 	. 
	nop			;7b88	00 	. 
	ld e,a			;7b89	5f 	_ 
	jr nz,$+1		;7b8a	20 ff 	  . 
	nop			;7b8c	00 	. 
	rst 38h			;7b8d	ff 	. 
	ld b,b			;7b8e	40 	@ 
	rst 38h			;7b8f	ff 	. 
	add a,b			;7b90	80 	. 
	rst 38h			;7b91	ff 	. 
	jr nz,$+1		;7b92	20 ff 	  . 
	nop			;7b94	00 	. 
	rst 38h			;7b95	ff 	. 
	ld b,b			;7b96	40 	@ 
	rst 38h			;7b97	ff 	. 
	add a,b			;7b98	80 	. 
	rst 38h			;7b99	ff 	. 
l7b9ah:
	adc a,l			;7b9a	8d 	. 
	inc sp			;7b9b	33 	3 
	jr nc,l7b9eh		;7b9c	30 00 	0 . 
l7b9eh:
	nop			;7b9e	00 	. 
	nop			;7b9f	00 	. 
	rst 38h			;7ba0	ff 	. 
	nop			;7ba1	00 	. 
	ld e,a			;7ba2	5f 	_ 
	jr nz,$+1		;7ba3	20 ff 	  . 
	nop			;7ba5	00 	. 
	rst 38h			;7ba6	ff 	. 
	ld b,b			;7ba7	40 	@ 
	rst 38h			;7ba8	ff 	. 
	add a,b			;7ba9	80 	. 
	rst 38h			;7baa	ff 	. 
	ld b,h			;7bab	44 	D 
	ld b,h			;7bac	44 	D 
	ld (032cah),hl		;7bad	22 ca 32 	" . 2 
	jr nc,l7bb2h		;7bb0	30 00 	0 . 
l7bb2h:
	cp d			;7bb2	ba 	. 
	ld a,e			;7bb3	7b 	{ 
	and b			;7bb4	a0 	. 
	nop			;7bb5	00 	. 
	adc a,l			;7bb6	8d 	. 
	inc sp			;7bb7	33 	3 
	jr nc,l7bbah		;7bb8	30 00 	0 . 
l7bbah:
	nop			;7bba	00 	. 
	nop			;7bbb	00 	. 
	rst 38h			;7bbc	ff 	. 
	nop			;7bbd	00 	. 
	ld e,a			;7bbe	5f 	_ 
	jr nz,$+1		;7bbf	20 ff 	  . 
	nop			;7bc1	00 	. 
	rst 38h			;7bc2	ff 	. 
	ld b,b			;7bc3	40 	@ 
	rst 38h			;7bc4	ff 	. 
	add a,b			;7bc5	80 	. 
	rst 38h			;7bc6	ff 	. 
	ld b,h			;7bc7	44 	D 
l7bc8h:
	ld b,h			;7bc8	44 	D 
	ld (032cah),hl		;7bc9	22 ca 32 	" . 2 
	jr nc,l7bceh		;7bcc	30 00 	0 . 
l7bceh:
	sub 07bh		;7bce	d6 7b 	. { 
	and b			;7bd0	a0 	. 
	nop			;7bd1	00 	. 
	adc a,l			;7bd2	8d 	. 
	inc sp			;7bd3	33 	3 
	jr nc,l7bd6h		;7bd4	30 00 	0 . 
l7bd6h:
	nop			;7bd6	00 	. 
	nop			;7bd7	00 	. 
	rst 38h			;7bd8	ff 	. 
	nop			;7bd9	00 	. 
	ld e,a			;7bda	5f 	_ 
	jr nz,$+1		;7bdb	20 ff 	  . 
	nop			;7bdd	00 	. 
	rst 38h			;7bde	ff 	. 
	ld b,b			;7bdf	40 	@ 
	rst 38h			;7be0	ff 	. 
	add a,b			;7be1	80 	. 
	rst 38h			;7be2	ff 	. 
	inc sp			;7be3	33 	3 
	jr nc,l7be6h		;7be4	30 00 	0 . 
l7be6h:
	nop			;7be6	00 	. 
	nop			;7be7	00 	. 
	rst 38h			;7be8	ff 	. 
	nop			;7be9	00 	. 
	ld e,a			;7bea	5f 	_ 
	jr nz,$+1		;7beb	20 ff 	  . 
	nop			;7bed	00 	. 
	rst 38h			;7bee	ff 	. 
	ld b,b			;7bef	40 	@ 
	rst 38h			;7bf0	ff 	. 
	add a,b			;7bf1	80 	. 
	rst 38h			;7bf2	ff 	. 
	nop			;7bf3	00 	. 
	call m,0a07bh		;7bf4	fc 7b a0 	. { . 
	nop			;7bf7	00 	. 
	adc a,l			;7bf8	8d 	. 
	inc sp			;7bf9	33 	3 
	jr nc,l7bfch		;7bfa	30 00 	0 . 
l7bfch:
	nop			;7bfc	00 	. 
	nop			;7bfd	00 	. 
	rst 38h			;7bfe	ff 	. 
	nop			;7bff	00 	. 
	ld e,a			;7c00	5f 	_ 
	jr nz,$+1		;7c01	20 ff 	  . 
	nop			;7c03	00 	. 
	rst 38h			;7c04	ff 	. 
	ld b,b			;7c05	40 	@ 
	rst 38h			;7c06	ff 	. 
	add a,b			;7c07	80 	. 
	rst 38h			;7c08	ff 	. 
	inc sp			;7c09	33 	3 
	jr nc,l7c0ch		;7c0a	30 00 	0 . 
l7c0ch:
	nop			;7c0c	00 	. 
	nop			;7c0d	00 	. 
	rst 38h			;7c0e	ff 	. 
	nop			;7c0f	00 	. 
	ld e,a			;7c10	5f 	_ 
	jr nz,$+1		;7c11	20 ff 	  . 
	nop			;7c13	00 	. 
	rst 38h			;7c14	ff 	. 
	ld b,b			;7c15	40 	@ 
	rst 38h			;7c16	ff 	. 
	add a,b			;7c17	80 	. 
	rst 38h			;7c18	ff 	. 
	nop			;7c19	00 	. 
	adc a,l			;7c1a	8d 	. 
	inc sp			;7c1b	33 	3 
	jr nc,l7c1eh		;7c1c	30 00 	0 . 
l7c1eh:
	nop			;7c1e	00 	. 
	nop			;7c1f	00 	. 
	rst 38h			;7c20	ff 	. 
	nop			;7c21	00 	. 
	ld e,a			;7c22	5f 	_ 
	jr nz,$+1		;7c23	20 ff 	  . 
	nop			;7c25	00 	. 
	rst 38h			;7c26	ff 	. 
	ld b,b			;7c27	40 	@ 
	rst 38h			;7c28	ff 	. 
	add a,b			;7c29	80 	. 
	rst 38h			;7c2a	ff 	. 
	nop			;7c2b	00 	. 
	adc a,l			;7c2c	8d 	. 
	inc sp			;7c2d	33 	3 
	jr nc,l7c30h		;7c2e	30 00 	0 . 
l7c30h:
	nop			;7c30	00 	. 
	nop			;7c31	00 	. 
	rst 38h			;7c32	ff 	. 
	nop			;7c33	00 	. 
	ld e,a			;7c34	5f 	_ 
	jr nz,$+1		;7c35	20 ff 	  . 
	nop			;7c37	00 	. 
	rst 38h			;7c38	ff 	. 
	ld b,b			;7c39	40 	@ 
	rst 38h			;7c3a	ff 	. 
	add a,b			;7c3b	80 	. 
	rst 38h			;7c3c	ff 	. 
	ld b,l			;7c3d	45 	E 
	ld a,h			;7c3e	7c 	| 
	and b			;7c3f	a0 	. 
	nop			;7c40	00 	. 
	adc a,l			;7c41	8d 	. 
	inc sp			;7c42	33 	3 
	jr nc,l7c45h		;7c43	30 00 	0 . 
l7c45h:
	nop			;7c45	00 	. 
	nop			;7c46	00 	. 
	rst 38h			;7c47	ff 	. 
	nop			;7c48	00 	. 
	ld e,a			;7c49	5f 	_ 
	jr nz,$+1		;7c4a	20 ff 	  . 
	nop			;7c4c	00 	. 
	rst 38h			;7c4d	ff 	. 
	ld b,b			;7c4e	40 	@ 
	rst 38h			;7c4f	ff 	. 
	add a,b			;7c50	80 	. 
	rst 38h			;7c51	ff 	. 
	adc a,l			;7c52	8d 	. 
	inc sp			;7c53	33 	3 
	jr nc,l7c56h		;7c54	30 00 	0 . 
l7c56h:
	nop			;7c56	00 	. 
	nop			;7c57	00 	. 
	rst 38h			;7c58	ff 	. 
	nop			;7c59	00 	. 
	ld e,a			;7c5a	5f 	_ 
	jr nz,$+1		;7c5b	20 ff 	  . 
	nop			;7c5d	00 	. 
	rst 38h			;7c5e	ff 	. 
	ld b,b			;7c5f	40 	@ 
	rst 38h			;7c60	ff 	. 
	add a,b			;7c61	80 	. 
	rst 38h			;7c62	ff 	. 
	ld (00030h),a		;7c63	32 30 00 	2 0 . 
	ld l,(hl)			;7c66	6e 	n 
	ld a,h			;7c67	7c 	| 
	and b			;7c68	a0 	. 
	nop			;7c69	00 	. 
	adc a,l			;7c6a	8d 	. 
	inc sp			;7c6b	33 	3 
	jr nc,l7c6eh		;7c6c	30 00 	0 . 
l7c6eh:
	nop			;7c6e	00 	. 
	nop			;7c6f	00 	. 
	rst 38h			;7c70	ff 	. 
	nop			;7c71	00 	. 
	ld e,a			;7c72	5f 	_ 
	jr nz,$+1		;7c73	20 ff 	  . 
	nop			;7c75	00 	. 
	rst 38h			;7c76	ff 	. 
	ld b,b			;7c77	40 	@ 
	rst 38h			;7c78	ff 	. 
	add a,b			;7c79	80 	. 
	rst 38h			;7c7a	ff 	. 
	add a,e			;7c7b	83 	. 
	ld a,h			;7c7c	7c 	| 
	and b			;7c7d	a0 	. 
	nop			;7c7e	00 	. 
	adc a,l			;7c7f	8d 	. 
	inc sp			;7c80	33 	3 
	jr nc,l7c83h		;7c81	30 00 	0 . 
l7c83h:
	nop			;7c83	00 	. 
	nop			;7c84	00 	. 
	rst 38h			;7c85	ff 	. 
	nop			;7c86	00 	. 
	ld e,a			;7c87	5f 	_ 
	jr nz,$+1		;7c88	20 ff 	  . 
	nop			;7c8a	00 	. 
	rst 38h			;7c8b	ff 	. 
	ld b,b			;7c8c	40 	@ 
	rst 38h			;7c8d	ff 	. 
	add a,b			;7c8e	80 	. 
	rst 38h			;7c8f	ff 	. 
	sbc a,b			;7c90	98 	. 
	ld a,h			;7c91	7c 	| 
	and b			;7c92	a0 	. 
	nop			;7c93	00 	. 
	adc a,l			;7c94	8d 	. 
	inc sp			;7c95	33 	3 
	jr nc,l7c98h		;7c96	30 00 	0 . 
l7c98h:
	nop			;7c98	00 	. 
	nop			;7c99	00 	. 
	rst 38h			;7c9a	ff 	. 
	nop			;7c9b	00 	. 
	ld e,a			;7c9c	5f 	_ 
	jr nz,$+1		;7c9d	20 ff 	  . 
	nop			;7c9f	00 	. 
	rst 38h			;7ca0	ff 	. 
	ld b,b			;7ca1	40 	@ 
	rst 38h			;7ca2	ff 	. 
	add a,b			;7ca3	80 	. 
	rst 38h			;7ca4	ff 	. 
	push de			;7ca5	d5 	. 
	ld b,c			;7ca6	41 	A 
	ld sp,031ceh		;7ca7	31 ce 31 	1 . 1 
	nop			;7caa	00 	. 
	cp h			;7cab	bc 	. 
	ld a,h			;7cac	7c 	| 
	sub (hl)			;7cad	96 	. 
	nop			;7cae	00 	. 
	adc a,a			;7caf	8f 	. 
	ld c,b			;7cb0	48 	H 
	inc h			;7cb1	24 	$ 
	push de			;7cb2	d5 	. 
	ld (04441h),hl		;7cb3	22 41 44 	" A D 
	ld b,h			;7cb6	44 	D 
	ld (032cah),hl		;7cb7	22 ca 32 	" . 2 
	jr nc,l7cbch		;7cba	30 00 	0 . 
l7cbch:
	call nz,0a07ch		;7cbc	c4 7c a0 	. | . 
	nop			;7cbf	00 	. 
	adc a,l			;7cc0	8d 	. 
	inc sp			;7cc1	33 	3 
	jr nc,l7cc4h		;7cc2	30 00 	0 . 
l7cc4h:
	nop			;7cc4	00 	. 
	nop			;7cc5	00 	. 
	rst 38h			;7cc6	ff 	. 
	nop			;7cc7	00 	. 
	ld e,a			;7cc8	5f 	_ 
	jr nz,$+1		;7cc9	20 ff 	  . 
	nop			;7ccb	00 	. 
	rst 38h			;7ccc	ff 	. 
	ld b,b			;7ccd	40 	@ 
	rst 38h			;7cce	ff 	. 
	add a,b			;7ccf	80 	. 
	rst 38h			;7cd0	ff 	. 
	ld a,(03141h)		;7cd1	3a 41 31 	: A 1 
	push de			;7cd4	d5 	. 
	ld b,c			;7cd5	41 	A 
	ld sp,031ceh		;7cd6	31 ce 31 	1 . 1 
	nop			;7cd9	00 	. 
	ex de,hl			;7cda	eb 	. 
	ld a,h			;7cdb	7c 	| 
	sub (hl)			;7cdc	96 	. 
	nop			;7cdd	00 	. 
	adc a,a			;7cde	8f 	. 
	ld c,b			;7cdf	48 	H 
	inc h			;7ce0	24 	$ 
	push de			;7ce1	d5 	. 
	ld (04441h),hl		;7ce2	22 41 44 	" A D 
	ld b,h			;7ce5	44 	D 
	ld (032cah),hl		;7ce6	22 ca 32 	" . 2 
	jr nc,l7cebh		;7ce9	30 00 	0 . 
l7cebh:
	di			;7ceb	f3 	. 
	ld a,h			;7cec	7c 	| 
	and b			;7ced	a0 	. 
	nop			;7cee	00 	. 
	adc a,l			;7cef	8d 	. 
	inc sp			;7cf0	33 	3 
	jr nc,l7cf3h		;7cf1	30 00 	0 . 
l7cf3h:
	nop			;7cf3	00 	. 
	nop			;7cf4	00 	. 
	rst 38h			;7cf5	ff 	. 
	nop			;7cf6	00 	. 
	ld e,a			;7cf7	5f 	_ 
	jr nz,$+1		;7cf8	20 ff 	  . 
	nop			;7cfa	00 	. 
	rst 38h			;7cfb	ff 	. 
	ld b,b			;7cfc	40 	@ 
	rst 38h			;7cfd	ff 	. 
	add a,b			;7cfe	80 	. 
	rst 38h			;7cff	ff 	. 
	inc b			;7d00	04 	. 
	rst 38h			;7d01	ff 	. 
	nop			;7d02	00 	. 
	rst 38h			;7d03	ff 	. 
	nop			;7d04	00 	. 
	rst 38h			;7d05	ff 	. 
	and b			;7d06	a0 	. 
	ld a,a			;7d07	7f 	 
	jr z,l7d74h		;7d08	28 6a 	( j 
	nop			;7d0a	00 	. 
	rst 38h			;7d0b	ff 	. 
	nop			;7d0c	00 	. 
	rst 38h			;7d0d	ff 	. 
	jr nz,l7d8fh		;7d0e	20 7f 	   
	ld (hl),e			;7d10	73 	s 
	inc hl			;7d11	23 	# 
	nop			;7d12	00 	. 
	rst 38h			;7d13	ff 	. 
	nop			;7d14	00 	. 
	rst 38h			;7d15	ff 	. 
	nop			;7d16	00 	. 
	rst 28h			;7d17	ef 	. 
	or b			;7d18	b0 	. 
	ccf			;7d19	3f 	? 
	nop			;7d1a	00 	. 
	rst 38h			;7d1b	ff 	. 
	nop			;7d1c	00 	. 
	rst 38h			;7d1d	ff 	. 
	djnz $+1		;7d1e	10 ff 	. . 
	ld (de),a			;7d20	12 	. 
	defb 0fdh,000h,0ffh	;illegal sequence		;7d21	fd 00 ff 	. . . 
	nop			;7d24	00 	. 
	rst 38h			;7d25	ff 	. 
	ld b,b			;7d26	40 	@ 
	cp l			;7d27	bd 	. 
	sub b			;7d28	90 	. 
	rst 38h			;7d29	ff 	. 
	nop			;7d2a	00 	. 
l7d2bh:
	rst 38h			;7d2b	ff 	. 
	nop			;7d2c	00 	. 
	rst 38h			;7d2d	ff 	. 
	jr nz,l7d2bh		;7d2e	20 fb 	  . 
	inc d			;7d30	14 	. 
	ld c,l			;7d31	4d 	M 
	nop			;7d32	00 	. 
	rst 38h			;7d33	ff 	. 
	nop			;7d34	00 	. 
	rst 38h			;7d35	ff 	. 
	ld h,d			;7d36	62 	b 
	rst 38h			;7d37	ff 	. 
	jr nz,$+1		;7d38	20 ff 	  . 
	nop			;7d3a	00 	. 
	rst 38h			;7d3b	ff 	. 
	ld b,b			;7d3c	40 	@ 
	rst 38h			;7d3d	ff 	. 
	sub b			;7d3e	90 	. 
	dec hl			;7d3f	2b 	+ 
	ld c,b			;7d40	48 	H 
	rst 38h			;7d41	ff 	. 
	nop			;7d42	00 	. 
	rst 38h			;7d43	ff 	. 
	nop			;7d44	00 	. 
	rst 38h			;7d45	ff 	. 
	ret nz			;7d46	c0 	. 
	rst 38h			;7d47	ff 	. 
	nop			;7d48	00 	. 
	xor l			;7d49	ad 	. 
	nop			;7d4a	00 	. 
	rst 38h			;7d4b	ff 	. 
	nop			;7d4c	00 	. 
	rst 38h			;7d4d	ff 	. 
	ld d,d			;7d4e	52 	R 
	adc a,a			;7d4f	8f 	. 
	sub b			;7d50	90 	. 
	xor a			;7d51	af 	. 
	nop			;7d52	00 	. 
	rst 38h			;7d53	ff 	. 
	nop			;7d54	00 	. 
	rst 38h			;7d55	ff 	. 
	ld bc,020feh		;7d56	01 fe 20 	. .   
	ccf			;7d59	3f 	? 
	nop			;7d5a	00 	. 
	rst 38h			;7d5b	ff 	. 
	nop			;7d5c	00 	. 
	rst 38h			;7d5d	ff 	. 
	djnz $+1		;7d5e	10 ff 	. . 
	ld (hl),d			;7d60	72 	r 
	rst 38h			;7d61	ff 	. 
	nop			;7d62	00 	. 
	rst 38h			;7d63	ff 	. 
	nop			;7d64	00 	. 
	rst 38h			;7d65	ff 	. 
	jr nc,$+129		;7d66	30 7f 	0  
	sub b			;7d68	90 	. 
	xor a			;7d69	af 	. 
	nop			;7d6a	00 	. 
	rst 38h			;7d6b	ff 	. 
	nop			;7d6c	00 	. 
	rst 38h			;7d6d	ff 	. 
	ld h,b			;7d6e	60 	` 
	rst 38h			;7d6f	ff 	. 
	nop			;7d70	00 	. 
	cp 000h		;7d71	fe 00 	. . 
	rst 38h			;7d73	ff 	. 
l7d74h:
	nop			;7d74	00 	. 
	rst 38h			;7d75	ff 	. 
	ld b,b			;7d76	40 	@ 
	cp a			;7d77	bf 	. 
	jr nz,$+1		;7d78	20 ff 	  . 
	nop			;7d7a	00 	. 
	rst 38h			;7d7b	ff 	. 
	nop			;7d7c	00 	. 
	rst 38h			;7d7d	ff 	. 
	jr nz,$+1		;7d7e	20 ff 	  . 
	ld (bc),a			;7d80	02 	. 
	rst 28h			;7d81	ef 	. 
	nop			;7d82	00 	. 
	rst 38h			;7d83	ff 	. 
	nop			;7d84	00 	. 
	rst 38h			;7d85	ff 	. 
	nop			;7d86	00 	. 
	rst 38h			;7d87	ff 	. 
	ld (bc),a			;7d88	02 	. 
	rst 28h			;7d89	ef 	. 
	nop			;7d8a	00 	. 
	rst 38h			;7d8b	ff 	. 
	nop			;7d8c	00 	. 
	rst 38h			;7d8d	ff 	. 
	ld h,b			;7d8e	60 	` 
l7d8fh:
	ex de,hl			;7d8f	eb 	. 
	ret po			;7d90	e0 	. 
	ld a,h			;7d91	7c 	| 
	nop			;7d92	00 	. 
	ei			;7d93	fb 	. 
	nop			;7d94	00 	. 
	rst 38h			;7d95	ff 	. 
	ex af,af'			;7d96	08 	. 
	rst 38h			;7d97	ff 	. 
	sub b			;7d98	90 	. 
	ld a,a			;7d99	7f 	 
	nop			;7d9a	00 	. 
	rst 38h			;7d9b	ff 	. 
	nop			;7d9c	00 	. 
	rst 38h			;7d9d	ff 	. 
	nop			;7d9e	00 	. 
	defb 0fdh,002h,0ffh	;illegal sequence		;7d9f	fd 02 ff 	. . . 
	nop			;7da2	00 	. 
	rst 38h			;7da3	ff 	. 
	nop			;7da4	00 	. 
	rst 38h			;7da5	ff 	. 
	ld b,d			;7da6	42 	B 
	cp a			;7da7	bf 	. 
	ld (bc),a			;7da8	02 	. 
	rst 38h			;7da9	ff 	. 
	nop			;7daa	00 	. 
	rst 38h			;7dab	ff 	. 
	nop			;7dac	00 	. 
	rst 38h			;7dad	ff 	. 
	ld b,h			;7dae	44 	D 
	ld a,a			;7daf	7f 	 
	sub c			;7db0	91 	. 
	cp 000h		;7db1	fe 00 	. . 
	rst 38h			;7db3	ff 	. 
	nop			;7db4	00 	. 
	rst 38h			;7db5	ff 	. 
	nop			;7db6	00 	. 
	ccf			;7db7	3f 	? 
	ret nz			;7db8	c0 	. 
	rst 38h			;7db9	ff 	. 
	nop			;7dba	00 	. 
	rst 38h			;7dbb	ff 	. 
	nop			;7dbc	00 	. 
	rst 38h			;7dbd	ff 	. 
	and b			;7dbe	a0 	. 
l7dbfh:
	rst 38h			;7dbf	ff 	. 
	ld b,d			;7dc0	42 	B 
	cp e			;7dc1	bb 	. 
	nop			;7dc2	00 	. 
	rst 38h			;7dc3	ff 	. 
	nop			;7dc4	00 	. 
	rst 38h			;7dc5	ff 	. 
	ld d,b			;7dc6	50 	P 
l7dc7h:
	xor e			;7dc7	ab 	. 
	djnz l7e49h		;7dc8	10 7f 	.  
	nop			;7dca	00 	. 
	rst 38h			;7dcb	ff 	. 
	nop			;7dcc	00 	. 
	rst 38h			;7dcd	ff 	. 
	jr nc,l7dbfh		;7dce	30 ef 	0 . 
	ld b,b			;7dd0	40 	@ 
	cp a			;7dd1	bf 	. 
	nop			;7dd2	00 	. 
	rst 38h			;7dd3	ff 	. 
	nop			;7dd4	00 	. 
	rst 38h			;7dd5	ff 	. 
	ld (bc),a			;7dd6	02 	. 
	cp a			;7dd7	bf 	. 
	ld (bc),a			;7dd8	02 	. 
	ld l,h			;7dd9	6c 	l 
	nop			;7dda	00 	. 
	rst 38h			;7ddb	ff 	. 
	nop			;7ddc	00 	. 
	rst 38h			;7ddd	ff 	. 
	ld (bc),a			;7dde	02 	. 
	cp e			;7ddf	bb 	. 
	ld c,b			;7de0	48 	H 
	cp l			;7de1	bd 	. 
	nop			;7de2	00 	. 
	rst 38h			;7de3	ff 	. 
	nop			;7de4	00 	. 
	rst 38h			;7de5	ff 	. 
	jr nc,$+65		;7de6	30 3f 	0 ? 
	jp m,000f7h		;7de8	fa f7 00 	. . . 
	rst 38h			;7deb	ff 	. 
	nop			;7dec	00 	. 
	rst 38h			;7ded	ff 	. 
	ld (bc),a			;7dee	02 	. 
	xor a			;7def	af 	. 
	nop			;7df0	00 	. 
	rst 38h			;7df1	ff 	. 
	ld b,e			;7df2	43 	C 
	inc e			;7df3	1c 	. 
	nop			;7df4	00 	. 
	rst 38h			;7df5	ff 	. 
	djnz $+1		;7df6	10 ff 	. . 
	nop			;7df8	00 	. 
	ld e,000h		;7df9	1e 00 	. . 
	rst 38h			;7dfb	ff 	. 
	nop			;7dfc	00 	. 
	rst 38h			;7dfd	ff 	. 
	add a,b			;7dfe	80 	. 
	rst 38h			;7dff	ff 	. 
	adc a,b			;7e00	88 	. 
	ex de,hl			;7e01	eb 	. 
	nop			;7e02	00 	. 
	rst 38h			;7e03	ff 	. 
	nop			;7e04	00 	. 
	rst 38h			;7e05	ff 	. 
	and d			;7e06	a2 	. 
	jp m,0ff04h		;7e07	fa 04 ff 	. . . 
	nop			;7e0a	00 	. 
	rst 38h			;7e0b	ff 	. 
	nop			;7e0c	00 	. 
	cp 060h		;7e0d	fe 60 	. ` 
	push af			;7e0f	f5 	. 
	ld a,h			;7e10	7c 	| 
	ld a,(bc)			;7e11	0a 	. 
	nop			;7e12	00 	. 
	rst 38h			;7e13	ff 	. 
	nop			;7e14	00 	. 
	rst 38h			;7e15	ff 	. 
	ld b,h			;7e16	44 	D 
	ei			;7e17	fb 	. 
	inc (hl)			;7e18	34 	4 
	cp l			;7e19	bd 	. 
	nop			;7e1a	00 	. 
	rst 38h			;7e1b	ff 	. 
	nop			;7e1c	00 	. 
	rst 38h			;7e1d	ff 	. 
	ld (bc),a			;7e1e	02 	. 
	sbc a,a			;7e1f	9f 	. 
	ld (hl),b			;7e20	70 	p 
	rst 38h			;7e21	ff 	. 
	nop			;7e22	00 	. 
	rst 38h			;7e23	ff 	. 
	nop			;7e24	00 	. 
	rst 38h			;7e25	ff 	. 
	jr nc,l7dc7h		;7e26	30 9f 	0 . 
	jr nz,$-63		;7e28	20 bf 	  . 
	nop			;7e2a	00 	. 
	rst 38h			;7e2b	ff 	. 
	nop			;7e2c	00 	. 
	rst 38h			;7e2d	ff 	. 
	nop			;7e2e	00 	. 
	cp 050h		;7e2f	fe 50 	. P 
	cp (hl)			;7e31	be 	. 
	nop			;7e32	00 	. 
	rst 38h			;7e33	ff 	. 
	nop			;7e34	00 	. 
	rst 38h			;7e35	ff 	. 
	add a,d			;7e36	82 	. 
l7e37h:
	cp a			;7e37	bf 	. 
	add a,b			;7e38	80 	. 
	rst 38h			;7e39	ff 	. 
	nop			;7e3a	00 	. 
	rst 38h			;7e3b	ff 	. 
	nop			;7e3c	00 	. 
l7e3dh:
	rst 38h			;7e3d	ff 	. 
	ld b,d			;7e3e	42 	B 
	rst 38h			;7e3f	ff 	. 
	nop			;7e40	00 	. 
	in a,(000h)		;7e41	db 00 	. . 
	rst 38h			;7e43	ff 	. 
	nop			;7e44	00 	. 
	rst 38h			;7e45	ff 	. 
	ret z			;7e46	c8 	. 
	rst 38h			;7e47	ff 	. 
	and b			;7e48	a0 	. 
l7e49h:
	rst 38h			;7e49	ff 	. 
	nop			;7e4a	00 	. 
	rst 38h			;7e4b	ff 	. 
	nop			;7e4c	00 	. 
	rst 38h			;7e4d	ff 	. 
	nop			;7e4e	00 	. 
	defb 0fdh,090h,0dfh	;illegal sequence		;7e4f	fd 90 df 	. . . 
	nop			;7e52	00 	. 
	rst 38h			;7e53	ff 	. 
	nop			;7e54	00 	. 
	rst 38h			;7e55	ff 	. 
	ld b,b			;7e56	40 	@ 
l7e57h:
	rst 38h			;7e57	ff 	. 
	nop			;7e58	00 	. 
	defb 0fdh,000h,0ffh	;illegal sequence		;7e59	fd 00 ff 	. . . 
	nop			;7e5c	00 	. 
	rst 38h			;7e5d	ff 	. 
	jr nz,l7e3dh		;7e5e	20 dd 	  . 
	ld c,b			;7e60	48 	H 
	rst 18h			;7e61	df 	. 
	nop			;7e62	00 	. 
	rst 38h			;7e63	ff 	. 
	nop			;7e64	00 	. 
	rst 38h			;7e65	ff 	. 
	jr nz,$-63		;7e66	20 bf 	  . 
	sub h			;7e68	94 	. 
	defb 0edh;next byte illegal after ed		;7e69	ed 	. 
	nop			;7e6a	00 	. 
	rst 38h			;7e6b	ff 	. 
	nop			;7e6c	00 	. 
l7e6dh:
	rst 38h			;7e6d	ff 	. 
	inc b			;7e6e	04 	. 
	rst 18h			;7e6f	df 	. 
	pop de			;7e70	d1 	. 
	rst 18h			;7e71	df 	. 
	nop			;7e72	00 	. 
	rst 38h			;7e73	ff 	. 
	nop			;7e74	00 	. 
	rst 38h			;7e75	ff 	. 
	jr nz,l7e37h		;7e76	20 bf 	  . 
	ret po			;7e78	e0 	. 
l7e79h:
	cp 000h		;7e79	fe 00 	. . 
	rst 38h			;7e7b	ff 	. 
	nop			;7e7c	00 	. 
	rst 38h			;7e7d	ff 	. 
	djnz l7e6dh		;7e7e	10 ed 	. . 
	nop			;7e80	00 	. 
	rst 30h			;7e81	f7 	. 
	nop			;7e82	00 	. 
	rst 38h			;7e83	ff 	. 
	nop			;7e84	00 	. 
	rst 38h			;7e85	ff 	. 
	ld c,b			;7e86	48 	H 
	cp a			;7e87	bf 	. 
	ld (hl),0fdh		;7e88	36 fd 	6 . 
	nop			;7e8a	00 	. 
	rst 38h			;7e8b	ff 	. 
	nop			;7e8c	00 	. 
	rst 38h			;7e8d	ff 	. 
	inc b			;7e8e	04 	. 
	rst 30h			;7e8f	f7 	. 
	ld h,0b5h		;7e90	26 b5 	& . 
	nop			;7e92	00 	. 
	rst 38h			;7e93	ff 	. 
	nop			;7e94	00 	. 
	rst 38h			;7e95	ff 	. 
	and d			;7e96	a2 	. 
	rst 38h			;7e97	ff 	. 
	jr nz,l7e79h		;7e98	20 df 	  . 
	nop			;7e9a	00 	. 
	rst 38h			;7e9b	ff 	. 
	nop			;7e9c	00 	. 
	rst 38h			;7e9d	ff 	. 
	jr nz,l7e57h		;7e9e	20 b7 	  . 
	ld (de),a			;7ea0	12 	. 
	cp 000h		;7ea1	fe 00 	. . 
	rst 38h			;7ea3	ff 	. 
	nop			;7ea4	00 	. 
	rst 38h			;7ea5	ff 	. 
	djnz $+1		;7ea6	10 ff 	. . 
	xor b			;7ea8	a8 	. 
	cp (hl)			;7ea9	be 	. 
	nop			;7eaa	00 	. 
	rst 38h			;7eab	ff 	. 
	nop			;7eac	00 	. 
	rst 38h			;7ead	ff 	. 
	nop			;7eae	00 	. 
	cp a			;7eaf	bf 	. 
	and c			;7eb0	a1 	. 
	cp a			;7eb1	bf 	. 
	nop			;7eb2	00 	. 
	rst 38h			;7eb3	ff 	. 
	nop			;7eb4	00 	. 
	rst 38h			;7eb5	ff 	. 
	add a,d			;7eb6	82 	. 
	rst 38h			;7eb7	ff 	. 
	ld (de),a			;7eb8	12 	. 
	defb 0fdh,000h,0ffh	;illegal sequence		;7eb9	fd 00 ff 	. . . 
	nop			;7ebc	00 	. 
	rst 38h			;7ebd	ff 	. 
	ld (bc),a			;7ebe	02 	. 
	rst 18h			;7ebf	df 	. 
	inc h			;7ec0	24 	$ 
	rst 38h			;7ec1	ff 	. 
	nop			;7ec2	00 	. 
	rst 38h			;7ec3	ff 	. 
	nop			;7ec4	00 	. 
	rst 38h			;7ec5	ff 	. 
	nop			;7ec6	00 	. 
	rst 20h			;7ec7	e7 	. 
	cp b			;7ec8	b8 	. 
	rst 38h			;7ec9	ff 	. 
	nop			;7eca	00 	. 
	rst 38h			;7ecb	ff 	. 
	nop			;7ecc	00 	. 
	rst 38h			;7ecd	ff 	. 
	ld h,b			;7ece	60 	` 
	ld e,d			;7ecf	5a 	Z 
	nop			;7ed0	00 	. 
	in a,(000h)		;7ed1	db 00 	. . 
	rst 38h			;7ed3	ff 	. 
	nop			;7ed4	00 	. 
	rst 38h			;7ed5	ff 	. 
	nop			;7ed6	00 	. 
	rst 38h			;7ed7	ff 	. 
	sub h			;7ed8	94 	. 
	rst 38h			;7ed9	ff 	. 
	nop			;7eda	00 	. 
	rst 38h			;7edb	ff 	. 
	nop			;7edc	00 	. 
	rst 38h			;7edd	ff 	. 
	add a,b			;7ede	80 	. 
	rst 38h			;7edf	ff 	. 
	ex af,af'			;7ee0	08 	. 
	rst 38h			;7ee1	ff 	. 
	nop			;7ee2	00 	. 
	rst 38h			;7ee3	ff 	. 
	nop			;7ee4	00 	. 
	rst 38h			;7ee5	ff 	. 
	djnz $+1		;7ee6	10 ff 	. . 
	ld b,b			;7ee8	40 	@ 
	defb 0ddh,000h,0ffh	;illegal sequence		;7ee9	dd 00 ff 	. . . 
	nop			;7eec	00 	. 
	rst 38h			;7eed	ff 	. 
	ex af,af'			;7eee	08 	. 
	rst 38h			;7eef	ff 	. 

;***************************************************************************************
; Game CPU Stack Top 
GAME_CPU_STACK:
;***************************************************************************************


	inc b			;7ef0	04 	. 
	call m,0a286h		;7ef1	fc 86 a2 	. . . 
	nop			;7ef4	00 	. 
	rst 38h			;7ef5	ff 	. 
	add a,b			;7ef6	80 	. 
	cp 080h		;7ef7	fe 80 	. . 
	rst 30h			;7ef9	f7 	. 
	nop			;7efa	00 	. 
	rst 38h			;7efb	ff 	. 
	nop			;7efc	00 	. 
	rst 38h			;7efd	ff 	. 
	nop			;7efe	00 	. 
	in a,(0ffh)		;7eff	db ff 	. . 
	ld bc,05a2fh		;7f01	01 2f 5a 	. / Z 
	cpl			;7f04	2f 	/ 
	ld e,c			;7f05	59 	Y 
	cpl			;7f06	2f 	/ 
	ld d,a			;7f07	57 	W 
	cpl			;7f08	2f 	/ 
	ld d,l			;7f09	55 	U 
	cpl			;7f0a	2f 	/ 
	ld d,e			;7f0b	53 	S 
	cpl			;7f0c	2f 	/ 
	ld d,c			;7f0d	51 	Q 
	cpl			;7f0e	2f 	/ 
	ld c,(hl)			;7f0f	4e 	N 
	cpl			;7f10	2f 	/ 
	ld c,h			;7f11	4c 	L 
	cpl			;7f12	2f 	/ 
	ld c,c			;7f13	49 	I 
	cpl			;7f14	2f 	/ 
	ld b,l			;7f15	45 	E 
	cpl			;7f16	2f 	/ 
	ld b,b			;7f17	40 	@ 
	cpl			;7f18	2f 	/ 
	dec a			;7f19	3d 	= 
	cpl			;7f1a	2f 	/ 
	ld a,(0372fh)		;7f1b	3a 2f 37 	: / 7 
	cpl			;7f1e	2f 	/ 
	jr c,l7f50h		;7f1f	38 2f 	8 / 
	dec sp			;7f21	3b 	; 
	cpl			;7f22	2f 	/ 
	ccf			;7f23	3f 	? 
	cpl			;7f24	2f 	/ 
	ccf			;7f25	3f 	? 
	cpl			;7f26	2f 	/ 
	ccf			;7f27	3f 	? 
	cpl			;7f28	2f 	/ 
	ccf			;7f29	3f 	? 
	sbc a,0deh		;7f2a	de de 	. . 
	cpl			;7f2c	2f 	/ 
	ccf			;7f2d	3f 	? 
	cpl			;7f2e	2f 	/ 
	ccf			;7f2f	3f 	? 
	cpl			;7f30	2f 	/ 
	ccf			;7f31	3f 	? 
	cpl			;7f32	2f 	/ 
	ccf			;7f33	3f 	? 
	sbc a,0deh		;7f34	de de 	. . 
	cpl			;7f36	2f 	/ 
	ccf			;7f37	3f 	? 
	cpl			;7f38	2f 	/ 
	ccf			;7f39	3f 	? 
	cpl			;7f3a	2f 	/ 
	ccf			;7f3b	3f 	? 
	cpl			;7f3c	2f 	/ 
	ccf			;7f3d	3f 	? 
	sbc a,0deh		;7f3e	de de 	. . 
	cpl			;7f40	2f 	/ 
	ccf			;7f41	3f 	? 
	cpl			;7f42	2f 	/ 
	ccf			;7f43	3f 	? 
	cpl			;7f44	2f 	/ 
	ccf			;7f45	3f 	? 
	defb 0ddh,0ddh,02fh	;illegal sequence		;7f46	dd dd 2f 	. . / 
	ccf			;7f49	3f 	? 
	cpl			;7f4a	2f 	/ 
	ccf			;7f4b	3f 	? 
	defb 0ddh,0ddh,02fh	;illegal sequence		;7f4c	dd dd 2f 	. . / 
	ccf			;7f4f	3f 	? 
l7f50h:
	cpl			;7f50	2f 	/ 
	ccf			;7f51	3f 	? 
	rst 18h			;7f52	df 	. 
	rst 18h			;7f53	df 	. 
	cpl			;7f54	2f 	/ 
	ccf			;7f55	3f 	? 
	cpl			;7f56	2f 	/ 
	ccf			;7f57	3f 	? 
	cpl			;7f58	2f 	/ 
	dec a			;7f59	3d 	= 
	cpl			;7f5a	2f 	/ 
	dec sp			;7f5b	3b 	; 
	cpl			;7f5c	2f 	/ 
	add hl,sp			;7f5d	39 	9 
	cpl			;7f5e	2f 	/ 
	scf			;7f5f	37 	7 
	cpl			;7f60	2f 	/ 
	add hl,sp			;7f61	39 	9 
	cpl			;7f62	2f 	/ 
	ld b,d			;7f63	42 	B 
	cpl			;7f64	2f 	/ 
	ld b,d			;7f65	42 	B 
	cpl			;7f66	2f 	/ 
	ld b,d			;7f67	42 	B 
	defb 0ddh,0ddh,02fh	;illegal sequence		;7f68	dd dd 2f 	. . / 
	ld b,h			;7f6b	44 	D 
	cpl			;7f6c	2f 	/ 
	ld b,(hl)			;7f6d	46 	F 
	cpl			;7f6e	2f 	/ 
	ld c,b			;7f6f	48 	H 
	cpl			;7f70	2f 	/ 
	ld d,h			;7f71	54 	T 
	cpl			;7f72	2f 	/ 
	ld d,h			;7f73	54 	T 
	cpl			;7f74	2f 	/ 
	ld d,h			;7f75	54 	T 
	defb 0ddh,0ddh,02fh	;illegal sequence		;7f76	dd dd 2f 	. . / 
	ld d,d			;7f79	52 	R 
	cpl			;7f7a	2f 	/ 
	ld d,c			;7f7b	51 	Q 
	cpl			;7f7c	2f 	/ 
	ld d,h			;7f7d	54 	T 
	cpl			;7f7e	2f 	/ 
	ld d,h			;7f7f	54 	T 
	cpl			;7f80	2f 	/ 
	ld d,h			;7f81	54 	T 
	defb 0ddh,0ddh,02fh	;illegal sequence		;7f82	dd dd 2f 	. . / 
	ld d,h			;7f85	54 	T 
	cpl			;7f86	2f 	/ 
	ld d,d			;7f87	52 	R 
	cpl			;7f88	2f 	/ 
	ld d,c			;7f89	51 	Q 
	cpl			;7f8a	2f 	/ 
	ld d,b			;7f8b	50 	P 
	cpl			;7f8c	2f 	/ 
	ld d,d			;7f8d	52 	R 
	cpl			;7f8e	2f 	/ 
	ld d,l			;7f8f	55 	U 
	cpl			;7f90	2f 	/ 
	ld d,l			;7f91	55 	U 
	cpl			;7f92	2f 	/ 
	ld d,l			;7f93	55 	U 
	sbc a,0deh		;7f94	de de 	. . 
	cpl			;7f96	2f 	/ 
	ld d,l			;7f97	55 	U 
	cpl			;7f98	2f 	/ 
	ld d,l			;7f99	55 	U 
	cpl			;7f9a	2f 	/ 
	ld d,l			;7f9b	55 	U 
	sbc a,0deh		;7f9c	de de 	. . 
	cpl			;7f9e	2f 	/ 
	ld d,l			;7f9f	55 	U 
	cpl			;7fa0	2f 	/ 
	ld c,a			;7fa1	4f 	O 
	cpl			;7fa2	2f 	/ 
	ld c,a			;7fa3	4f 	O 
	cpl			;7fa4	2f 	/ 
	ld c,(hl)			;7fa5	4e 	N 
	cpl			;7fa6	2f 	/ 
	ld c,e			;7fa7	4b 	K 
	cpl			;7fa8	2f 	/ 
	ld c,c			;7fa9	49 	I 
	cpl			;7faa	2f 	/ 
	ld c,b			;7fab	48 	H 
	cpl			;7fac	2f 	/ 
	ld c,b			;7fad	48 	H 
	cpl			;7fae	2f 	/ 
	ld b,a			;7faf	47 	G 
	cpl			;7fb0	2f 	/ 
	ld c,e			;7fb1	4b 	K 
	cpl			;7fb2	2f 	/ 
	ld c,e			;7fb3	4b 	K 
	cpl			;7fb4	2f 	/ 
	ld c,e			;7fb5	4b 	K 
	rst 18h			;7fb6	df 	. 
	rst 18h			;7fb7	df 	. 
	cpl			;7fb8	2f 	/ 
	ld c,e			;7fb9	4b 	K 
	cpl			;7fba	2f 	/ 
	ld b,l			;7fbb	45 	E 
	cpl			;7fbc	2f 	/ 
	ccf			;7fbd	3f 	? 
	cpl			;7fbe	2f 	/ 
	dec sp			;7fbf	3b 	; 
	cpl			;7fc0	2f 	/ 
	ld b,c			;7fc1	41 	A 
	cpl			;7fc2	2f 	/ 
	ld b,c			;7fc3	41 	A 
	cpl			;7fc4	2f 	/ 
	ld b,c			;7fc5	41 	A 
	defb 0ddh,0ddh,02fh	;illegal sequence		;7fc6	dd dd 2f 	. . / 
	scf			;7fc9	37 	7 
	cpl			;7fca	2f 	/ 
	ld (hl),02fh		;7fcb	36 2f 	6 / 
	ld a,(03a2fh)		;7fcd	3a 2f 3a 	: / : 
	cpl			;7fd0	2f 	/ 
	ld a,(0dedeh)		;7fd1	3a de de 	: . . 
	cpl			;7fd4	2f 	/ 
	ld a,(03a2fh)		;7fd5	3a 2f 3a 	: / : 
	cpl			;7fd8	2f 	/ 
	ld a,(0dedeh)		;7fd9	3a de de 	: . . 
	cpl			;7fdc	2f 	/ 
	ld a,(03a2fh)		;7fdd	3a 2f 3a 	: / : 
	cpl			;7fe0	2f 	/ 
	ld a,(03a2fh)		;7fe1	3a 2f 3a 	: / : 
	cpl			;7fe4	2f 	/ 
	ld a,(03a2fh)		;7fe5	3a 2f 3a 	: / : 
	rst 18h			;7fe8	df 	. 
	rst 18h			;7fe9	df 	. 
	cpl			;7fea	2f 	/ 
	ld a,(0382fh)		;7feb	3a 2f 38 	: / 8 
	cpl			;7fee	2f 	/ 
	dec (hl)			;7fef	35 	5 
	cpl			;7ff0	2f 	/ 
	dec (hl)			;7ff1	35 	5 
	cpl			;7ff2	2f 	/ 
	scf			;7ff3	37 	7 
	cpl			;7ff4	2f 	/ 
	inc a			;7ff5	3c 	< 
	cpl			;7ff6	2f 	/ 
	inc a			;7ff7	3c 	< 
	cpl			;7ff8	2f 	/ 
	inc a			;7ff9	3c 	< 
	defb 0ddh,0ddh,02fh	;illegal sequence		;7ffa	dd dd 2f 	. . / 
	ld a,02fh		;7ffd	3e 2f 	> / 
	ld b,d			;7fff	42 	B 
	cpl			;8000	2f 	/ 
	ld b,l			;8001	45 	E 
	cpl			;8002	2f 	/ 
	ld c,d			;8003	4a 	J 
	cpl			;8004	2f 	/ 
	ld d,b			;8005	50 	P 
	cpl			;8006	2f 	/ 
	ld d,l			;8007	55 	U 
	cpl			;8008	2f 	/ 
	ld d,l			;8009	55 	U 
	cpl			;800a	2f 	/ 
	ld d,l			;800b	55 	U 
	sbc a,0deh		;800c	de de 	. . 
	cpl			;800e	2f 	/ 
	ld d,l			;800f	55 	U 
	cpl			;8010	2f 	/ 
	ld d,l			;8011	55 	U 
	cpl			;8012	2f 	/ 
	ld d,l			;8013	55 	U 
	sbc a,0deh		;8014	de de 	. . 
	cpl			;8016	2f 	/ 
	ld d,l			;8017	55 	U 
	cpl			;8018	2f 	/ 
	ld d,l			;8019	55 	U 
	cpl			;801a	2f 	/ 
	ld d,l			;801b	55 	U 
	cpl			;801c	2f 	/ 
	ld d,l			;801d	55 	U 
	rst 18h			;801e	df 	. 
	rst 18h			;801f	df 	. 
	cpl			;8020	2f 	/ 
	ld d,l			;8021	55 	U 
	cpl			;8022	2f 	/ 
	ld c,h			;8023	4c 	L 
	cpl			;8024	2f 	/ 
	ld b,(hl)			;8025	46 	F 
	cpl			;8026	2f 	/ 
	ld b,c			;8027	41 	A 
	cpl			;8028	2f 	/ 
	dec sp			;8029	3b 	; 
	cpl			;802a	2f 	/ 
	scf			;802b	37 	7 
	cpl			;802c	2f 	/ 
	dec (hl)			;802d	35 	5 
	cpl			;802e	2f 	/ 
	ld b,b			;802f	40 	@ 
	cpl			;8030	2f 	/ 
	ld b,b			;8031	40 	@ 
	cpl			;8032	2f 	/ 
	ld b,b			;8033	40 	@ 
	defb 0ddh,0ddh,02fh	;illegal sequence		;8034	dd dd 2f 	. . / 
	ld b,b			;8037	40 	@ 
	cpl			;8038	2f 	/ 
	ld b,b			;8039	40 	@ 
	defb 0ddh,0ddh,02fh	;illegal sequence		;803a	dd dd 2f 	. . / 
	ld b,b			;803d	40 	@ 
	cpl			;803e	2f 	/ 
	ld b,b			;803f	40 	@ 
	defb 0ddh,0ddh,02fh	;illegal sequence		;8040	dd dd 2f 	. . / 
	ld b,b			;8043	40 	@ 
	cpl			;8044	2f 	/ 
	ld b,b			;8045	40 	@ 
	defb 0ddh,0ddh,02fh	;illegal sequence		;8046	dd dd 2f 	. . / 
	ld b,b			;8049	40 	@ 
	cpl			;804a	2f 	/ 
	ld b,b			;804b	40 	@ 
	defb 0ddh,0ddh,02fh	;illegal sequence		;804c	dd dd 2f 	. . / 
	ld b,b			;804f	40 	@ 
	cpl			;8050	2f 	/ 
	ld a,02fh		;8051	3e 2f 	> / 
	dec a			;8053	3d 	= 
	cpl			;8054	2f 	/ 
	ccf			;8055	3f 	? 
	cpl			;8056	2f 	/ 
	ld b,e			;8057	43 	C 
	cpl			;8058	2f 	/ 
	ld b,l			;8059	45 	E 
	cpl			;805a	2f 	/ 
	ld b,a			;805b	47 	G 
	cpl			;805c	2f 	/ 
	ld b,a			;805d	47 	G 
	cpl			;805e	2f 	/ 
	ld b,a			;805f	47 	G 
	sbc a,0deh		;8060	de de 	. . 
	cpl			;8062	2f 	/ 
	ld b,a			;8063	47 	G 
	cpl			;8064	2f 	/ 
	ld b,a			;8065	47 	G 
	cpl			;8066	2f 	/ 
	ld b,a			;8067	47 	G 
	rst 18h			;8068	df 	. 
	rst 18h			;8069	df 	. 
	cpl			;806a	2f 	/ 
	ld b,a			;806b	47 	G 
	cpl			;806c	2f 	/ 
	ld b,a			;806d	47 	G 
	cpl			;806e	2f 	/ 
	ld c,c			;806f	49 	I 
	cpl			;8070	2f 	/ 
	ld c,(hl)			;8071	4e 	N 
	cpl			;8072	2f 	/ 
	ld d,(hl)			;8073	56 	V 
	cpl			;8074	2f 	/ 
	ld d,(hl)			;8075	56 	V 
	cpl			;8076	2f 	/ 
	ld d,(hl)			;8077	56 	V 
	rst 38h			;8078	ff 	. 
	ld (bc),a			;8079	02 	. 
	defb 0ddh,0ddh,02fh	;illegal sequence		;807a	dd dd 2f 	. . / 
	ld d,a			;807d	57 	W 
	jr nc,$+89		;807e	30 57 	0 W 
	ld (03557h),a		;8080	32 57 35 	2 W 5 
	ld d,(hl)			;8083	56 	V 
	dec (hl)			;8084	35 	5 
	ld d,l			;8085	55 	U 
	scf			;8086	37 	7 
	ld d,e			;8087	53 	S 
	ld (hl),052h		;8088	36 52 	6 R 
	ld (hl),052h		;808a	36 52 	6 R 
	ld (hl),056h		;808c	36 56 	6 V 
	scf			;808e	37 	7 
	ld d,(hl)			;808f	56 	V 
	jr c,l80e8h		;8090	38 56 	8 V 
	sbc a,0deh		;8092	de de 	. . 
	add hl,sp			;8094	39 	9 
	ld d,(hl)			;8095	56 	V 
	ld a,(03b57h)		;8096	3a 57 3b 	: W ; 
	ld e,c			;8099	59 	Y 
	dec sp			;809a	3b 	; 
	ld e,c			;809b	59 	Y 
	inc a			;809c	3c 	< 
	ld e,c			;809d	59 	Y 
	rst 18h			;809e	df 	. 
	rst 18h			;809f	df 	. 
	inc a			;80a0	3c 	< 
	ld e,c			;80a1	59 	Y 
	inc a			;80a2	3c 	< 
	ld e,c			;80a3	59 	Y 
	dec sp			;80a4	3b 	; 
	ld e,c			;80a5	59 	Y 
	defb 0ddh,0ddh,03bh	;illegal sequence		;80a6	dd dd 3b 	. . ; 
	ld e,c			;80a9	59 	Y 
	ld a,(0dd59h)		;80aa	3a 59 dd 	: Y . 
	defb 0ddh,03ch,059h	;illegal sequence		;80ad	dd 3c 59 	. < Y 
	ld a,059h		;80b0	3e 59 	> Y 
	defb 0ddh,0ddh,03ch	;illegal sequence		;80b2	dd dd 3c 	. . < 
	ld d,a			;80b5	57 	W 
	add hl,sp			;80b6	39 	9 
	ld d,l			;80b7	55 	U 
	add hl,sp			;80b8	39 	9 
	ld d,l			;80b9	55 	U 
	add hl,sp			;80ba	39 	9 
	ld d,e			;80bb	53 	S 
	dec sp			;80bc	3b 	; 
	ld d,e			;80bd	53 	S 
	dec sp			;80be	3b 	; 
	ld d,b			;80bf	50 	P 
	inc a			;80c0	3c 	< 
	ld c,a			;80c1	4f 	O 
	inc a			;80c2	3c 	< 
	ld d,c			;80c3	51 	Q 
	inc a			;80c4	3c 	< 
	ld d,d			;80c5	52 	R 
	dec sp			;80c6	3b 	; 
	ld d,e			;80c7	53 	S 
	dec sp			;80c8	3b 	; 
	ld d,e			;80c9	53 	S 
	ld a,(03a53h)		;80ca	3a 53 3a 	: S : 
	ld d,e			;80cd	53 	S 
	sbc a,0deh		;80ce	de de 	. . 
	add hl,sp			;80d0	39 	9 
	ld d,e			;80d1	53 	S 
	add hl,sp			;80d2	39 	9 
	ld d,e			;80d3	53 	S 
	add hl,sp			;80d4	39 	9 
	ld d,e			;80d5	53 	S 
	sbc a,0deh		;80d6	de de 	. . 
	ld (hl),053h		;80d8	36 53 	6 S 
	ld (hl),051h		;80da	36 51 	6 Q 
	scf			;80dc	37 	7 
	ld d,e			;80dd	53 	S 
	jr c,l8135h		;80de	38 55 	8 U 
	add hl,sp			;80e0	39 	9 
	ld d,d			;80e1	52 	R 
	dec sp			;80e2	3b 	; 
	ld d,h			;80e3	54 	T 
	dec sp			;80e4	3b 	; 
	ld d,l			;80e5	55 	U 
	dec sp			;80e6	3b 	; 
	ld d,l			;80e7	55 	U 
l80e8h:
	dec a			;80e8	3d 	= 
	ld d,l			;80e9	55 	U 
	defb 0ddh,0ddh,03eh	;illegal sequence		;80ea	dd dd 3e 	. . > 
	ld d,l			;80ed	55 	U 
	dec a			;80ee	3d 	= 
	ld d,l			;80ef	55 	U 
	inc a			;80f0	3c 	< 
	ld d,l			;80f1	55 	U 
	rst 18h			;80f2	df 	. 
	rst 18h			;80f3	df 	. 
	dec sp			;80f4	3b 	; 
	ld d,l			;80f5	55 	U 
	jr c,l814bh		;80f6	38 53 	8 S 
	dec (hl)			;80f8	35 	5 
	ld d,(hl)			;80f9	56 	V 
	ld (hl),055h		;80fa	36 55 	6 U 
	dec (hl)			;80fc	35 	5 
	ld d,h			;80fd	54 	T 
	scf			;80fe	37 	7 
	ld d,(hl)			;80ff	56 	V 
	add hl,sp			;8100	39 	9 
	ld e,b			;8101	58 	X 
	add hl,sp			;8102	39 	9 
	ld e,b			;8103	58 	X 
	ld a,(0de58h)		;8104	3a 58 de 	: X . 
	sbc a,03bh		;8107	de 3b 	. ; 
	ld e,b			;8109	58 	X 
	ld a,(03a58h)		;810a	3a 58 3a 	: X : 
	ld e,b			;810d	58 	X 
	sbc a,0deh		;810e	de de 	. . 
	jr c,$+90		;8110	38 58 	8 X 
	scf			;8112	37 	7 
	ld d,a			;8113	57 	W 
	ld (hl),055h		;8114	36 55 	6 U 
	dec (hl)			;8116	35 	5 
	ld d,d			;8117	52 	R 
	dec (hl)			;8118	35 	5 
	ld d,b			;8119	50 	P 
	jr c,$+81		;811a	38 4f 	8 O 
	ld a,(03b52h)		;811c	3a 52 3b 	: R ; 
	ld e,b			;811f	58 	X 
	dec sp			;8120	3b 	; 
	ld e,b			;8121	58 	X 
	inc a			;8122	3c 	< 
	ld e,b			;8123	58 	X 
	defb 0ddh,0ddh,03ch	;illegal sequence		;8124	dd dd 3c 	. . < 
	ld e,b			;8127	58 	X 
	ld a,058h		;8128	3e 58 	> X 
	defb 0ddh,0ddh,03eh	;illegal sequence		;812a	dd dd 3e 	. . > 
	ld e,b			;812d	58 	X 
	ccf			;812e	3f 	? 
	ld e,b			;812f	58 	X 
	rst 18h			;8130	df 	. 
	rst 18h			;8131	df 	. 
	ccf			;8132	3f 	? 
	ld e,b			;8133	58 	X 
	inc a			;8134	3c 	< 
l8135h:
	ld d,(hl)			;8135	56 	V 
	dec sp			;8136	3b 	; 
	ld d,a			;8137	57 	W 
	ld a,(03955h)		;8138	3a 55 39 	: U 9 
	ld d,h			;813b	54 	T 
	ld a,(03b55h)		;813c	3a 55 3b 	: U ; 
	ld d,e			;813f	53 	S 
	ld a,(03752h)		;8140	3a 52 37 	: R 7 
	ld d,e			;8143	53 	S 
	jr c,l819ah		;8144	38 54 	8 T 
	jr c,l819eh		;8146	38 56 	8 V 
	scf			;8148	37 	7 
	ld d,a			;8149	57 	W 
	add hl,sp			;814a	39 	9 
l814bh:
	ld d,a			;814b	57 	W 
	add hl,sp			;814c	39 	9 
	ld d,a			;814d	57 	W 
	defb 0ddh,0ddh,036h	;illegal sequence		;814e	dd dd 36 	. . 6 
	ld d,a			;8151	57 	W 
	ld (hl),057h		;8152	36 57 	6 W 
	defb 0ddh,0ddh,035h	;illegal sequence		;8154	dd dd 35 	. . 5 
	ld d,l			;8157	55 	U 
	jr c,l81ach		;8158	38 52 	8 R 
	add hl,sp			;815a	39 	9 
	ld c,l			;815b	4d 	M 
	ld (hl),050h		;815c	36 50 	6 P 
	ld (hl),053h		;815e	36 53 	6 S 
	ld (hl),056h		;8160	36 56 	6 V 
	inc (hl)			;8162	34 	4 
	ld d,(hl)			;8163	56 	V 
	inc (hl)			;8164	34 	4 
	ld d,(hl)			;8165	56 	V 
	ld (0dd56h),a		;8166	32 56 dd 	2 V . 
	defb 0ddh,032h,056h	;illegal sequence		;8169	dd 32 56 	. 2 V 
	inc (hl)			;816c	34 	4 
	ld d,(hl)			;816d	56 	V 
	ld (0dd56h),a		;816e	32 56 dd 	2 V . 
	inc (ix+056h)		;8171	dd 34 56 	. 4 V 
	ld (03356h),a		;8174	32 56 33 	2 V 3 
	ld d,(hl)			;8177	56 	V 
	rst 18h			;8178	df 	. 
	rst 18h			;8179	df 	. 
	ld (03456h),a		;817a	32 56 34 	2 V 4 
	ld d,(hl)			;817d	56 	V 
	inc sp			;817e	33 	3 
	ld d,d			;817f	52 	R 
	ld (03154h),a		;8180	32 54 31 	2 T 1 
	ld c,a			;8183	4f 	O 
	jr nc,l81d7h		;8184	30 51 	0 Q 
	cpl			;8186	2f 	/ 
	ld d,(hl)			;8187	56 	V 
	cpl			;8188	2f 	/ 
	ld d,(hl)			;8189	56 	V 
	cpl			;818a	2f 	/ 
	ld d,(hl)			;818b	56 	V 
	sbc a,0deh		;818c	de de 	. . 
	cpl			;818e	2f 	/ 
	ld d,(hl)			;818f	56 	V 
	cpl			;8190	2f 	/ 
	ld d,(hl)			;8191	56 	V 
	cpl			;8192	2f 	/ 
	ld d,(hl)			;8193	56 	V 
	cpl			;8194	2f 	/ 
	ld d,(hl)			;8195	56 	V 
	sbc a,0deh		;8196	de de 	. . 
	cpl			;8198	2f 	/ 
	ld d,(hl)			;8199	56 	V 
l819ah:
	cpl			;819a	2f 	/ 
	ld d,h			;819b	54 	T 
	cpl			;819c	2f 	/ 
	ld d,d			;819d	52 	R 
l819eh:
	cpl			;819e	2f 	/ 
	ld d,a			;819f	57 	W 
	cpl			;81a0	2f 	/ 
	ld d,a			;81a1	57 	W 
	cpl			;81a2	2f 	/ 
	ld d,a			;81a3	57 	W 
	sbc a,0deh		;81a4	de de 	. . 
	cpl			;81a6	2f 	/ 
	ld d,a			;81a7	57 	W 
	rst 38h			;81a8	ff 	. 
	inc bc			;81a9	03 	. 
	cpl			;81aa	2f 	/ 
	ld e,b			;81ab	58 	X 
l81ach:
	cpl			;81ac	2f 	/ 
	ld e,c			;81ad	59 	Y 
	cpl			;81ae	2f 	/ 
	ld d,l			;81af	55 	U 
	cpl			;81b0	2f 	/ 
	ld d,e			;81b1	53 	S 
	cpl			;81b2	2f 	/ 
	ld d,d			;81b3	52 	R 
	cpl			;81b4	2f 	/ 
	ld d,e			;81b5	53 	S 
	cpl			;81b6	2f 	/ 
	ld d,c			;81b7	51 	Q 
	cpl			;81b8	2f 	/ 
	ld d,b			;81b9	50 	P 
	cpl			;81ba	2f 	/ 
	ld c,(hl)			;81bb	4e 	N 
	cpl			;81bc	2f 	/ 
	ld c,(hl)			;81bd	4e 	N 
	cpl			;81be	2f 	/ 
	ld c,l			;81bf	4d 	M 
	cpl			;81c0	2f 	/ 
	ld c,l			;81c1	4d 	M 
	cpl			;81c2	2f 	/ 
	ld d,c			;81c3	51 	Q 
	cpl			;81c4	2f 	/ 
	ld d,e			;81c5	53 	S 
	cpl			;81c6	2f 	/ 
	ld d,e			;81c7	53 	S 
	cpl			;81c8	2f 	/ 
	ld d,e			;81c9	53 	S 
	defb 0ddh,0ddh,02fh	;illegal sequence		;81ca	dd dd 2f 	. . / 
	ld d,d			;81cd	52 	R 
	cpl			;81ce	2f 	/ 
	ld d,d			;81cf	52 	R 
	cpl			;81d0	2f 	/ 
	ld d,d			;81d1	52 	R 
	rst 18h			;81d2	df 	. 
	rst 18h			;81d3	df 	. 
	cpl			;81d4	2f 	/ 
	ld d,d			;81d5	52 	R 
	cpl			;81d6	2f 	/ 
l81d7h:
	ld c,l			;81d7	4d 	M 
	cpl			;81d8	2f 	/ 
	ld c,l			;81d9	4d 	M 
	cpl			;81da	2f 	/ 
	ld c,a			;81db	4f 	O 
	cpl			;81dc	2f 	/ 
	ld d,c			;81dd	51 	Q 
	cpl			;81de	2f 	/ 
	ld d,c			;81df	51 	Q 
	cpl			;81e0	2f 	/ 
	ld d,c			;81e1	51 	Q 
	sbc a,0deh		;81e2	de de 	. . 
	cpl			;81e4	2f 	/ 
	ld d,c			;81e5	51 	Q 
	cpl			;81e6	2f 	/ 
	ld c,(hl)			;81e7	4e 	N 
	cpl			;81e8	2f 	/ 
	ld c,a			;81e9	4f 	O 
	cpl			;81ea	2f 	/ 
	ld c,l			;81eb	4d 	M 
	cpl			;81ec	2f 	/ 
	ld c,l			;81ed	4d 	M 
	cpl			;81ee	2f 	/ 
	ld c,l			;81ef	4d 	M 
	cpl			;81f0	2f 	/ 
	ld c,l			;81f1	4d 	M 
	cpl			;81f2	2f 	/ 
	ld c,l			;81f3	4d 	M 
	cpl			;81f4	2f 	/ 
	ld c,a			;81f5	4f 	O 
	cpl			;81f6	2f 	/ 
	ld c,(hl)			;81f7	4e 	N 
	cpl			;81f8	2f 	/ 
	ld c,l			;81f9	4d 	M 
	cpl			;81fa	2f 	/ 
	ld c,(hl)			;81fb	4e 	N 
	cpl			;81fc	2f 	/ 
	ld c,a			;81fd	4f 	O 
	cpl			;81fe	2f 	/ 
	ld d,b			;81ff	50 	P 
	cpl			;8200	2f 	/ 
	ld c,(hl)			;8201	4e 	N 
	cpl			;8202	2f 	/ 
	ld c,(hl)			;8203	4e 	N 
	cpl			;8204	2f 	/ 
	ld c,a			;8205	4f 	O 
	cpl			;8206	2f 	/ 
	ld d,d			;8207	52 	R 
	cpl			;8208	2f 	/ 
	ld d,e			;8209	53 	S 
	cpl			;820a	2f 	/ 
	ld d,e			;820b	53 	S 
	cpl			;820c	2f 	/ 
	ld d,e			;820d	53 	S 
	sbc a,0deh		;820e	de de 	. . 
	cpl			;8210	2f 	/ 
	ld d,e			;8211	53 	S 
	cpl			;8212	2f 	/ 
	ld d,b			;8213	50 	P 
	cpl			;8214	2f 	/ 
	ld c,l			;8215	4d 	M 
	cpl			;8216	2f 	/ 
	ld d,l			;8217	55 	U 
	cpl			;8218	2f 	/ 
	ld d,l			;8219	55 	U 
	cpl			;821a	2f 	/ 
	ld d,l			;821b	55 	U 
	defb 0ddh,0ddh,02fh	;illegal sequence		;821c	dd dd 2f 	. . / 
	ld d,e			;821f	53 	S 
	cpl			;8220	2f 	/ 
	ld d,b			;8221	50 	P 
	cpl			;8222	2f 	/ 
	ld d,l			;8223	55 	U 
	cpl			;8224	2f 	/ 
	ld d,l			;8225	55 	U 
	cpl			;8226	2f 	/ 
	ld d,l			;8227	55 	U 
	sbc a,0deh		;8228	de de 	. . 
	cpl			;822a	2f 	/ 
	ld d,l			;822b	55 	U 
	cpl			;822c	2f 	/ 
	ld d,l			;822d	55 	U 
	cpl			;822e	2f 	/ 
	ld d,l			;822f	55 	U 
	sbc a,0deh		;8230	de de 	. . 
	cpl			;8232	2f 	/ 
	ld d,l			;8233	55 	U 
	cpl			;8234	2f 	/ 
	ld d,l			;8235	55 	U 
	cpl			;8236	2f 	/ 
	ld d,l			;8237	55 	U 
	sbc a,0deh		;8238	de de 	. . 
	cpl			;823a	2f 	/ 
	ld d,l			;823b	55 	U 
	cpl			;823c	2f 	/ 
	ld d,e			;823d	53 	S 
	cpl			;823e	2f 	/ 
	ld d,b			;823f	50 	P 
	cpl			;8240	2f 	/ 
	ld c,a			;8241	4f 	O 
	cpl			;8242	2f 	/ 
	ld c,(hl)			;8243	4e 	N 
	cpl			;8244	2f 	/ 
	ld c,l			;8245	4d 	M 
	cpl			;8246	2f 	/ 
	ld c,a			;8247	4f 	O 
	cpl			;8248	2f 	/ 
	ld c,(hl)			;8249	4e 	N 
	cpl			;824a	2f 	/ 
	ld d,c			;824b	51 	Q 
	cpl			;824c	2f 	/ 
	ld d,c			;824d	51 	Q 
	cpl			;824e	2f 	/ 
	ld d,c			;824f	51 	Q 
	rst 18h			;8250	df 	. 
	rst 18h			;8251	df 	. 
	cpl			;8252	2f 	/ 
	ld d,c			;8253	51 	Q 
	cpl			;8254	2f 	/ 
	ld d,c			;8255	51 	Q 
	cpl			;8256	2f 	/ 
	ld c,(hl)			;8257	4e 	N 
	cpl			;8258	2f 	/ 
	ld c,(hl)			;8259	4e 	N 
	cpl			;825a	2f 	/ 
	ld c,a			;825b	4f 	O 
	cpl			;825c	2f 	/ 
	ld c,a			;825d	4f 	O 
	cpl			;825e	2f 	/ 
	ld c,l			;825f	4d 	M 
	cpl			;8260	2f 	/ 
	ld c,a			;8261	4f 	O 
	cpl			;8262	2f 	/ 
	ld c,a			;8263	4f 	O 
	cpl			;8264	2f 	/ 
	ld c,(hl)			;8265	4e 	N 
	cpl			;8266	2f 	/ 
	ld c,l			;8267	4d 	M 
	cpl			;8268	2f 	/ 
	ld c,h			;8269	4c 	L 
	cpl			;826a	2f 	/ 
	ld d,h			;826b	54 	T 
	cpl			;826c	2f 	/ 
	ld d,h			;826d	54 	T 
	cpl			;826e	2f 	/ 
	ld d,h			;826f	54 	T 
	defb 0ddh,0ddh,02fh	;illegal sequence		;8270	dd dd 2f 	. . / 
	ld d,h			;8273	54 	T 
	cpl			;8274	2f 	/ 
	ld d,h			;8275	54 	T 
	defb 0ddh,0ddh,02fh	;illegal sequence		;8276	dd dd 2f 	. . / 
	ld d,h			;8279	54 	T 
	cpl			;827a	2f 	/ 
	ld d,h			;827b	54 	T 
	sbc a,0deh		;827c	de de 	. . 
	cpl			;827e	2f 	/ 
	ld d,h			;827f	54 	T 
	cpl			;8280	2f 	/ 
	ld d,c			;8281	51 	Q 
	cpl			;8282	2f 	/ 
	ld c,l			;8283	4d 	M 
	cpl			;8284	2f 	/ 
	ld c,(hl)			;8285	4e 	N 
	cpl			;8286	2f 	/ 
	ld c,(hl)			;8287	4e 	N 
	cpl			;8288	2f 	/ 
	ld c,l			;8289	4d 	M 
	cpl			;828a	2f 	/ 
	ld c,h			;828b	4c 	L 
	cpl			;828c	2f 	/ 
	ld c,l			;828d	4d 	M 
	cpl			;828e	2f 	/ 
	ld c,l			;828f	4d 	M 
	cpl			;8290	2f 	/ 
	ld c,(hl)			;8291	4e 	N 
	cpl			;8292	2f 	/ 
	ld c,a			;8293	4f 	O 
	cpl			;8294	2f 	/ 
	ld d,b			;8295	50 	P 
	cpl			;8296	2f 	/ 
	ld d,b			;8297	50 	P 
	cpl			;8298	2f 	/ 
	ld d,b			;8299	50 	P 
	cpl			;829a	2f 	/ 
	ld d,b			;829b	50 	P 
	sbc a,0deh		;829c	de de 	. . 
	cpl			;829e	2f 	/ 
	ld d,b			;829f	50 	P 
	cpl			;82a0	2f 	/ 
	ld d,b			;82a1	50 	P 
	cpl			;82a2	2f 	/ 
	ld c,(hl)			;82a3	4e 	N 
	cpl			;82a4	2f 	/ 
	ld c,l			;82a5	4d 	M 
	cpl			;82a6	2f 	/ 
	ld c,l			;82a7	4d 	M 
	cpl			;82a8	2f 	/ 
	ld c,a			;82a9	4f 	O 
	cpl			;82aa	2f 	/ 
	ld c,a			;82ab	4f 	O 
	cpl			;82ac	2f 	/ 
	ld d,b			;82ad	50 	P 
	cpl			;82ae	2f 	/ 
	ld d,b			;82af	50 	P 
	cpl			;82b0	2f 	/ 
	ld d,b			;82b1	50 	P 
	sbc a,0deh		;82b2	de de 	. . 
	cpl			;82b4	2f 	/ 
	ld d,b			;82b5	50 	P 
	cpl			;82b6	2f 	/ 
	ld d,b			;82b7	50 	P 
	cpl			;82b8	2f 	/ 
	ld d,b			;82b9	50 	P 
	rst 18h			;82ba	df 	. 
	rst 18h			;82bb	df 	. 
	cpl			;82bc	2f 	/ 
	ld d,b			;82bd	50 	P 
	cpl			;82be	2f 	/ 
	ld d,b			;82bf	50 	P 
	cpl			;82c0	2f 	/ 
	ld d,b			;82c1	50 	P 
	defb 0ddh,0ddh,02fh	;illegal sequence		;82c2	dd dd 2f 	. . / 
	ld d,b			;82c5	50 	P 
	cpl			;82c6	2f 	/ 
	ld d,b			;82c7	50 	P 
	cpl			;82c8	2f 	/ 
	ld a,(004ffh)		;82c9	3a ff 04 	: . . 
	cpl			;82cc	2f 	/ 
	ld a,(0422fh)		;82cd	3a 2f 42 	: / B 
	cpl			;82d0	2f 	/ 
	ld b,d			;82d1	42 	B 
	cpl			;82d2	2f 	/ 
	ld b,d			;82d3	42 	B 
	defb 0ddh,0ddh,02fh	;illegal sequence		;82d4	dd dd 2f 	. . / 
	ld a,(0422fh)		;82d7	3a 2f 42 	: / B 
	cpl			;82da	2f 	/ 
	ld b,d			;82db	42 	B 
	cpl			;82dc	2f 	/ 
	ld b,d			;82dd	42 	B 
	defb 0ddh,0ddh,02fh	;illegal sequence		;82de	dd dd 2f 	. . / 
	ld a,(0482fh)		;82e1	3a 2f 48 	: / H 
	cpl			;82e4	2f 	/ 
	ld c,b			;82e5	48 	H 
	cpl			;82e6	2f 	/ 
	ld c,b			;82e7	48 	H 
	defb 0ddh,0ddh,02fh	;illegal sequence		;82e8	dd dd 2f 	. . / 
	ld (hl),02fh		;82eb	36 2f 	6 / 
	ld (hl),02fh		;82ed	36 2f 	6 / 
	ld a,02fh		;82ef	3e 2f 	> / 
	ld a,02fh		;82f1	3e 2f 	> / 
	ld a,0ddh		;82f3	3e dd 	> . 
	defb 0ddh,02fh,035h	;illegal sequence		;82f5	dd 2f 35 	. / 5 
	cpl			;82f8	2f 	/ 
	dec (hl)			;82f9	35 	5 
	cpl			;82fa	2f 	/ 
	dec a			;82fb	3d 	= 
	cpl			;82fc	2f 	/ 
	dec a			;82fd	3d 	= 
	cpl			;82fe	2f 	/ 
	dec a			;82ff	3d 	= 
	defb 0ddh,0ddh,02fh	;illegal sequence		;8300	dd dd 2f 	. . / 
	dec (hl)			;8303	35 	5 
	cpl			;8304	2f 	/ 
	dec (hl)			;8305	35 	5 
	cpl			;8306	2f 	/ 
	dec a			;8307	3d 	= 
	cpl			;8308	2f 	/ 
	dec a			;8309	3d 	= 
	cpl			;830a	2f 	/ 
	dec a			;830b	3d 	= 
	defb 0ddh,0ddh,02fh	;illegal sequence		;830c	dd dd 2f 	. . / 
	ld c,d			;830f	4a 	J 
	cpl			;8310	2f 	/ 
	ld c,d			;8311	4a 	J 
	cpl			;8312	2f 	/ 
	ld c,d			;8313	4a 	J 
	defb 0ddh,0ddh,02fh	;illegal sequence		;8314	dd dd 2f 	. . / 
	ld c,d			;8317	4a 	J 
	cpl			;8318	2f 	/ 
	ld c,d			;8319	4a 	J 
	defb 0ddh,0ddh,02fh	;illegal sequence		;831a	dd dd 2f 	. . / 
	ld c,d			;831d	4a 	J 
	cpl			;831e	2f 	/ 
	ld c,d			;831f	4a 	J 
	cpl			;8320	2f 	/ 
	ld c,d			;8321	4a 	J 
	sbc a,0deh		;8322	de de 	. . 
	cpl			;8324	2f 	/ 
	ld c,d			;8325	4a 	J 
	cpl			;8326	2f 	/ 
	ld c,d			;8327	4a 	J 
	cpl			;8328	2f 	/ 
	ld c,d			;8329	4a 	J 
	sbc a,0deh		;832a	de de 	. . 
	cpl			;832c	2f 	/ 
	ld c,d			;832d	4a 	J 
	cpl			;832e	2f 	/ 
	ld c,d			;832f	4a 	J 
	cpl			;8330	2f 	/ 
	ld c,d			;8331	4a 	J 
	rst 18h			;8332	df 	. 
	rst 18h			;8333	df 	. 
	cpl			;8334	2f 	/ 
	ld c,d			;8335	4a 	J 
	cpl			;8336	2f 	/ 
	ld a,(03a2fh)		;8337	3a 2f 3a 	: / : 
	cpl			;833a	2f 	/ 
	ld c,d			;833b	4a 	J 
	cpl			;833c	2f 	/ 
	ld c,d			;833d	4a 	J 
	cpl			;833e	2f 	/ 
	ld c,d			;833f	4a 	J 
	defb 0ddh,0ddh,02fh	;illegal sequence		;8340	dd dd 2f 	. . / 
	ccf			;8343	3f 	? 
	cpl			;8344	2f 	/ 
	ld c,c			;8345	49 	I 
	cpl			;8346	2f 	/ 
	ld c,c			;8347	49 	I 
	cpl			;8348	2f 	/ 
	ld c,c			;8349	49 	I 
	defb 0ddh,0ddh,02fh	;illegal sequence		;834a	dd dd 2f 	. . / 
	ld a,02fh		;834d	3e 2f 	> / 
	ld c,b			;834f	48 	H 
	cpl			;8350	2f 	/ 
	ld c,b			;8351	48 	H 
	cpl			;8352	2f 	/ 
	ld c,b			;8353	48 	H 
	defb 0ddh,0ddh,02fh	;illegal sequence		;8354	dd dd 2f 	. . / 
	ld a,(0452fh)		;8357	3a 2f 45 	: / E 
	cpl			;835a	2f 	/ 
	ld b,l			;835b	45 	E 
	cpl			;835c	2f 	/ 
	ld b,l			;835d	45 	E 
	defb 0ddh,0ddh,02fh	;illegal sequence		;835e	dd dd 2f 	. . / 
	jr c,$+49		;8361	38 2f 	8 / 
	ld b,e			;8363	43 	C 
	cpl			;8364	2f 	/ 
	ld b,e			;8365	43 	C 
	cpl			;8366	2f 	/ 
	ld b,e			;8367	43 	C 
	defb 0ddh,0ddh,02fh	;illegal sequence		;8368	dd dd 2f 	. . / 
	ld (hl),02fh		;836b	36 2f 	6 / 
	ld b,c			;836d	41 	A 
	cpl			;836e	2f 	/ 
	ld b,c			;836f	41 	A 
	cpl			;8370	2f 	/ 
	ld b,c			;8371	41 	A 
	defb 0ddh,0ddh,02fh	;illegal sequence		;8372	dd dd 2f 	. . / 
	ld b,c			;8375	41 	A 
	cpl			;8376	2f 	/ 
	ld b,c			;8377	41 	A 
	cpl			;8378	2f 	/ 
	ld b,c			;8379	41 	A 
	defb 0ddh,0ddh,02fh	;illegal sequence		;837a	dd dd 2f 	. . / 
	ld (hl),02fh		;837d	36 2f 	6 / 
	ld (hl),02fh		;837f	36 2f 	6 / 
	ld b,b			;8381	40 	@ 
	cpl			;8382	2f 	/ 
	ld b,b			;8383	40 	@ 
	cpl			;8384	2f 	/ 
	ld b,b			;8385	40 	@ 
	defb 0ddh,0ddh,02fh	;illegal sequence		;8386	dd dd 2f 	. . / 
	ld (hl),02fh		;8389	36 2f 	6 / 
	ld b,(hl)			;838b	46 	F 
	cpl			;838c	2f 	/ 
	ld b,(hl)			;838d	46 	F 
	cpl			;838e	2f 	/ 
	ld b,(hl)			;838f	46 	F 
	defb 0ddh,0ddh,02fh	;illegal sequence		;8390	dd dd 2f 	. . / 
	ld a,(04c2fh)		;8393	3a 2f 4c 	: / L 
	cpl			;8396	2f 	/ 
	ld c,h			;8397	4c 	L 
	cpl			;8398	2f 	/ 
	ld c,h			;8399	4c 	L 
	defb 0ddh,0ddh,02fh	;illegal sequence		;839a	dd dd 2f 	. . / 
	ld c,h			;839d	4c 	L 
	cpl			;839e	2f 	/ 
	ld c,h			;839f	4c 	L 
	cpl			;83a0	2f 	/ 
	ld c,h			;83a1	4c 	L 
	rst 18h			;83a2	df 	. 
	rst 18h			;83a3	df 	. 
	cpl			;83a4	2f 	/ 
	ld c,h			;83a5	4c 	L 
	cpl			;83a6	2f 	/ 
	ld c,h			;83a7	4c 	L 
	cpl			;83a8	2f 	/ 
	ld c,h			;83a9	4c 	L 
	cpl			;83aa	2f 	/ 
	ld c,h			;83ab	4c 	L 
	sbc a,0deh		;83ac	de de 	. . 
	cpl			;83ae	2f 	/ 
	ld c,h			;83af	4c 	L 
	cpl			;83b0	2f 	/ 
	ld c,h			;83b1	4c 	L 
	cpl			;83b2	2f 	/ 
	ld c,h			;83b3	4c 	L 
	sbc a,0deh		;83b4	de de 	. . 
	cpl			;83b6	2f 	/ 
	ld c,h			;83b7	4c 	L 
	cpl			;83b8	2f 	/ 
	ld c,h			;83b9	4c 	L 
	inc sp			;83ba	33 	3 
	ld a,(005ffh)		;83bb	3a ff 05 	: . . 
	inc sp			;83be	33 	3 
	ld a,(03a33h)		;83bf	3a 33 3a 	: 3 : 
	inc sp			;83c2	33 	3 
	ld a,(03a33h)		;83c3	3a 33 3a 	: 3 : 
	inc sp			;83c6	33 	3 
	ld a,(03a33h)		;83c7	3a 33 3a 	: 3 : 
	inc sp			;83ca	33 	3 
	ld a,(0dedeh)		;83cb	3a de de 	: . . 
	inc sp			;83ce	33 	3 
	ld a,(03a33h)		;83cf	3a 33 3a 	: 3 : 
	inc sp			;83d2	33 	3 
	ld a,(0dedeh)		;83d3	3a de de 	: . . 
	inc sp			;83d6	33 	3 
	ld a,(03a33h)		;83d7	3a 33 3a 	: 3 : 
	inc sp			;83da	33 	3 
	ld a,(0dedeh)		;83db	3a de de 	: . . 
	inc sp			;83de	33 	3 
	ld a,(03c33h)		;83df	3a 33 3c 	: 3 < 
	dec (hl)			;83e2	35 	5 
	ld a,036h		;83e3	3e 36 	> 6 
	ld a,037h		;83e5	3e 37 	> 7 
	ld d,(hl)			;83e7	56 	V 
	scf			;83e8	37 	7 
	ld d,(hl)			;83e9	56 	V 
	scf			;83ea	37 	7 
	ld d,(hl)			;83eb	56 	V 
	scf			;83ec	37 	7 
	ld d,(hl)			;83ed	56 	V 
	ld c,c			;83ee	49 	I 
	ld d,(hl)			;83ef	56 	V 
	ld c,d			;83f0	4a 	J 
	ld d,(hl)			;83f1	56 	V 
	ld c,e			;83f2	4b 	K 
	ld d,(hl)			;83f3	56 	V 
	ld c,h			;83f4	4c 	L 
	ld d,(hl)			;83f5	56 	V 
	ld c,l			;83f6	4d 	M 
	ld d,(hl)			;83f7	56 	V 
	rst 18h			;83f8	df 	. 
	rst 18h			;83f9	df 	. 
	ld c,(hl)			;83fa	4e 	N 
	ld d,(hl)			;83fb	56 	V 
	ld c,a			;83fc	4f 	O 
	ld d,(hl)			;83fd	56 	V 
	ld d,b			;83fe	50 	P 
	ld d,(hl)			;83ff	56 	V 
	ld c,a			;8400	4f 	O 
	ld d,(hl)			;8401	56 	V 
	ld c,(hl)			;8402	4e 	N 
	ld d,(hl)			;8403	56 	V 
	ld c,l			;8404	4d 	M 
	ld d,(hl)			;8405	56 	V 
	ld c,h			;8406	4c 	L 
	ld d,l			;8407	55 	U 
	ld c,e			;8408	4b 	K 
	ld d,h			;8409	54 	T 
	ld c,d			;840a	4a 	J 
	ld d,h			;840b	54 	T 
	ld c,d			;840c	4a 	J 
	ld d,h			;840d	54 	T 
	ld c,d			;840e	4a 	J 
	ld d,d			;840f	52 	R 
	ld c,d			;8410	4a 	J 
	ld d,c			;8411	51 	Q 
	ld c,d			;8412	4a 	J 
	ld d,c			;8413	51 	Q 
	ld c,d			;8414	4a 	J 
	ld d,c			;8415	51 	Q 
	ld c,d			;8416	4a 	J 
	ld d,c			;8417	51 	Q 
	ld c,d			;8418	4a 	J 
	ld d,c			;8419	51 	Q 
	ld c,d			;841a	4a 	J 
	ld d,c			;841b	51 	Q 
	ld b,(hl)			;841c	46 	F 
	ld d,c			;841d	51 	Q 
	ld b,(hl)			;841e	46 	F 
	ld e,c			;841f	59 	Y 
	ld b,l			;8420	45 	E 
	ld e,c			;8421	59 	Y 
	ld b,h			;8422	44 	D 
	ld e,c			;8423	59 	Y 
	defb 0ddh,0ddh,044h	;illegal sequence		;8424	dd dd 44 	. . D 
	ld c,h			;8427	4c 	L 
	ld b,h			;8428	44 	D 
	ld c,h			;8429	4c 	L 
	ld b,h			;842a	44 	D 
	ld c,d			;842b	4a 	J 
	ld b,h			;842c	44 	D 
	ld c,d			;842d	4a 	J 
	ld b,h			;842e	44 	D 
	ld c,d			;842f	4a 	J 
	ld b,h			;8430	44 	D 
	ld d,h			;8431	54 	T 
	ld b,h			;8432	44 	D 
	ld d,h			;8433	54 	T 
	ld b,h			;8434	44 	D 
	ld d,h			;8435	54 	T 
	sbc a,0deh		;8436	de de 	. . 
	ld a,(03a54h)		;8438	3a 54 3a 	: T : 
	ld d,h			;843b	54 	T 
	ld a,(0df54h)		;843c	3a 54 df 	: T . 
	rst 18h			;843f	df 	. 
	ld a,(03a54h)		;8440	3a 54 3a 	: T : 
	ld b,c			;8443	41 	A 
	ld a,(03a41h)		;8444	3a 41 3a 	: A : 
	ld b,c			;8447	41 	A 
	ld a,(03a41h)		;8448	3a 41 3a 	: A : 
	ld b,c			;844b	41 	A 
	add hl,sp			;844c	39 	9 
	ld b,c			;844d	41 	A 
	inc (hl)			;844e	34 	4 
	ld b,b			;844f	40 	@ 
	inc (hl)			;8450	34 	4 
	ld b,b			;8451	40 	@ 
	inc (hl)			;8452	34 	4 
	ccf			;8453	3f 	? 
	inc (hl)			;8454	34 	4 
	ld a,034h		;8455	3e 34 	> 4 
	dec a			;8457	3d 	= 
	inc (hl)			;8458	34 	4 
	ld a,(03a34h)		;8459	3a 34 3a 	: 4 : 
	inc (hl)			;845c	34 	4 
	ld a,(0dedeh)		;845d	3a de de 	: . . 
	inc (hl)			;8460	34 	4 
	ld a,(03a34h)		;8461	3a 34 3a 	: 4 : 
	inc (hl)			;8464	34 	4 
	ld a,(0dedeh)		;8465	3a de de 	: . . 
	inc (hl)			;8468	34 	4 
	ld a,(03a34h)		;8469	3a 34 3a 	: 4 : 
	inc (hl)			;846c	34 	4 
	ld a,(0dedeh)		;846d	3a de de 	: . . 
	inc (hl)			;8470	34 	4 
	ld a,(03a34h)		;8471	3a 34 3a 	: 4 : 
	inc (hl)			;8474	34 	4 
	ld a,(0dedeh)		;8475	3a de de 	: . . 
	inc (hl)			;8478	34 	4 
	ld a,(03a34h)		;8479	3a 34 3a 	: 4 : 
	inc (hl)			;847c	34 	4 
	ld a,(0dedeh)		;847d	3a de de 	: . . 
	inc (hl)			;8480	34 	4 
	ld a,(03a34h)		;8481	3a 34 3a 	: 4 : 
	inc (hl)			;8484	34 	4 
	ld a,(0dedeh)		;8485	3a de de 	: . . 
	inc (hl)			;8488	34 	4 
	ld d,(hl)			;8489	56 	V 
	inc (hl)			;848a	34 	4 
	ld d,(hl)			;848b	56 	V 
	inc (hl)			;848c	34 	4 
	ld d,(hl)			;848d	56 	V 
	inc (hl)			;848e	34 	4 
	ld d,(hl)			;848f	56 	V 
	defb 0ddh,0ddh,03fh	;illegal sequence		;8490	dd dd 3f 	. . ? 
	ld b,(hl)			;8493	46 	F 
	ccf			;8494	3f 	? 
	ld b,(hl)			;8495	46 	F 
	ccf			;8496	3f 	? 
	ld b,(hl)			;8497	46 	F 
	ccf			;8498	3f 	? 
	ld b,(hl)			;8499	46 	F 
	rst 38h			;849a	ff 	. 
	ld b,03eh		;849b	06 3e 	. > 
	ld b,a			;849d	47 	G 
	dec a			;849e	3d 	= 
	ld c,b			;849f	48 	H 
	inc a			;84a0	3c 	< 
	ld c,c			;84a1	49 	I 
	dec sp			;84a2	3b 	; 
	ld c,d			;84a3	4a 	J 
	ld a,(0394bh)		;84a4	3a 4b 39 	: K 9 
	ld c,h			;84a7	4c 	L 
	jr c,l84f7h		;84a8	38 4d 	8 M 
	scf			;84aa	37 	7 
	ld c,(hl)			;84ab	4e 	N 
	ld (hl),04fh		;84ac	36 4f 	6 O 
	dec (hl)			;84ae	35 	5 
	ld d,b			;84af	50 	P 
	inc (hl)			;84b0	34 	4 
	ld d,c			;84b1	51 	Q 
	inc sp			;84b2	33 	3 
	ld d,d			;84b3	52 	R 
	ld (03153h),a		;84b4	32 53 31 	2 S 1 
	ld d,h			;84b7	54 	T 
	jr nc,l850fh		;84b8	30 55 	0 U 
	cpl			;84ba	2f 	/ 
	ld d,(hl)			;84bb	56 	V 
	cpl			;84bc	2f 	/ 
	ld d,(hl)			;84bd	56 	V 
	cpl			;84be	2f 	/ 
	ld d,d			;84bf	52 	R 
	cpl			;84c0	2f 	/ 
	ld c,(hl)			;84c1	4e 	N 
	cpl			;84c2	2f 	/ 
	ld d,(hl)			;84c3	56 	V 
	cpl			;84c4	2f 	/ 
	ld d,(hl)			;84c5	56 	V 
	cpl			;84c6	2f 	/ 
	ld d,(hl)			;84c7	56 	V 
	defb 0ddh,0ddh,02fh	;illegal sequence		;84c8	dd dd 2f 	. . / 
	ld c,(hl)			;84cb	4e 	N 
	cpl			;84cc	2f 	/ 
	ld d,d			;84cd	52 	R 
	cpl			;84ce	2f 	/ 
	ld d,(hl)			;84cf	56 	V 
	cpl			;84d0	2f 	/ 
	ld d,(hl)			;84d1	56 	V 
	cpl			;84d2	2f 	/ 
	ld d,(hl)			;84d3	56 	V 
	call c,02fdch		;84d4	dc dc 2f 	. . / 
	ld d,(hl)			;84d7	56 	V 
	cpl			;84d8	2f 	/ 
	ld d,d			;84d9	52 	R 
	cpl			;84da	2f 	/ 
	ld c,(hl)			;84db	4e 	N 
	cpl			;84dc	2f 	/ 
	ld d,(hl)			;84dd	56 	V 
	cpl			;84de	2f 	/ 
	ld d,(hl)			;84df	56 	V 
	jr nc,$+88		;84e0	30 56 	0 V 
	defb 0ddh,0ddh,030h	;illegal sequence		;84e2	dd dd 30 	. . 0 
	ld c,(hl)			;84e5	4e 	N 
	jr nc,$853a		;84e6	30 52 	0 R 
	jr nc,$+88		;84e8	30 56 	0 V 
	ld b,h			;84ea	44 	D 
	ld b,(hl)			;84eb	46 	F 
	ld b,h			;84ec	44 	D 
	ld b,(hl)			;84ed	46 	F 
	ld b,h			;84ee	44 	D 
	ld b,(hl)			;84ef	46 	F 
	ld b,h			;84f0	44 	D 
	ld b,(hl)			;84f1	46 	F 
	ld b,h			;84f2	44 	D 
	ld b,(hl)			;84f3	46 	F 
	ld b,h			;84f4	44 	D 
	ld b,(hl)			;84f5	46 	F 
	ld b,h			;84f6	44 	D 
l84f7h:
	ld b,(hl)			;84f7	46 	F 
	ld b,h			;84f8	44 	D 
	ld b,(hl)			;84f9	46 	F 
	ld b,h			;84fa	44 	D 
	ld b,(hl)			;84fb	46 	F 
	ld b,h			;84fc	44 	D 
	ld b,(hl)			;84fd	46 	F 
	ld b,h			;84fe	44 	D 
	ld b,(hl)			;84ff	46 	F 
	ld b,h			;8500	44 	D 
	ld b,(hl)			;8501	46 	F 
	ld b,h			;8502	44 	D 
	ld b,(hl)			;8503	46 	F 
	ld b,h			;8504	44 	D 
	ld b,(hl)			;8505	46 	F 
	ld b,h			;8506	44 	D 
	ld b,(hl)			;8507	46 	F 
	ld b,h			;8508	44 	D 
	ld b,(hl)			;8509	46 	F 
	ld b,h			;850a	44 	D 
	ld b,(hl)			;850b	46 	F 
	ld b,h			;850c	44 	D 
	ld b,(hl)			;850d	46 	F 
	ld b,h			;850e	44 	D 
l850fh:
	ld b,(hl)			;850f	46 	F 
	ld b,h			;8510	44 	D 
	ld b,(hl)			;8511	46 	F 
	ld b,h			;8512	44 	D 
	ld b,(hl)			;8513	46 	F 
	ld b,h			;8514	44 	D 
	ld b,(hl)			;8515	46 	F 
	ld b,h			;8516	44 	D 
	ld b,(hl)			;8517	46 	F 
	ld b,h			;8518	44 	D 
	ld b,(hl)			;8519	46 	F 
	ld b,h			;851a	44 	D 
	ld b,(hl)			;851b	46 	F 
	ld b,h			;851c	44 	D 
	ld b,(hl)			;851d	46 	F 
	ld b,h			;851e	44 	D 
	ld b,(hl)			;851f	46 	F 
	ld b,h			;8520	44 	D 
	ld b,(hl)			;8521	46 	F 
	ld b,h			;8522	44 	D 
	ld b,(hl)			;8523	46 	F 
	ld b,h			;8524	44 	D 
	ld b,(hl)			;8525	46 	F 
	ld b,h			;8526	44 	D 
	ld b,(hl)			;8527	46 	F 
	ld b,h			;8528	44 	D 
	ld b,(hl)			;8529	46 	F 
	ld b,h			;852a	44 	D 
	ld b,(hl)			;852b	46 	F 
	ld b,h			;852c	44 	D 
	ld b,(hl)			;852d	46 	F 
	ld b,h			;852e	44 	D 
	ld b,(hl)			;852f	46 	F 
	ld b,h			;8530	44 	D 
	ld b,(hl)			;8531	46 	F 
	ld b,h			;8532	44 	D 
	ld b,(hl)			;8533	46 	F 
	ld b,h			;8534	44 	D 
	ld b,(hl)			;8535	46 	F 

;***************************************************************************************
; Game Texts.
; Every text is terminated with '$ char and is printed in Gfx Mode 0
;***************************************************************************************
TXT_TITLE:
	db	"* DEFENCE PENETRATOR *$"			;8536	2a 20 44 45 46 45 4e 43 45 20 50 45 4e 45 54 52 41 54 4f 52 20 2a 24
TXT_AUTHOR:
	db	"WRITTEN BY TOM THIEL$" 			;854d	57 52 49 54 54 45 4e 20 42 59 20 54 4f 4d 20 54 48 49 45 4c 24 
TXT_COPYRIGHT:
	db	"COPYRIGHT 1982 - COSMIC SOFTWARE$"	;8562	43 4f 50 59 52 49 47 48 54 20 31 39 38 32 20 2d 20 43 4f 53 4d 49 43 20 53 4f 46 54 57 41 52 45 24 
TXT_PRESSSPACE:
	db	"PRESS <SPACE> TO PLAY!$"			;8583	50 52 45 53 53 20 3c 53 50 41 43 45 3e 20 54 4f 20 50 4c 41 59 21 24 
TXT_GAMEOVER:
	db "* GAME-OVER *$"						;859a	2a 20 47 41 4d 45 2d 4f 56 45 52 20 2a 24 
;***************************************************************************************


l85a8h:
	nop			;85a8	00 	. 
l85a9h:
	nop			;85a9	00 	. 
l85aah:
	nop			;85aa	00 	. 
	ld a,a			;85ab	7f 	 
l85ach:
	nop			;85ac	00 	. 
l85adh:
	nop			;85ad	00 	. 
l85aeh:
	jp c,00087h		;85ae	da 87 00 	. . . 
l85b1h:
	nop			;85b1	00 	. 
l85b2h:
	nop			;85b2	00 	. 
l85b3h:
	nop			;85b3	00 	. 
l85b4h:
	nop			;85b4	00 	. 
l85b5h:
	nop			;85b5	00 	. 
	nop			;85b6	00 	. 
l85b7h:
	nop			;85b7	00 	. 
	nop			;85b8	00 	. 
l85b9h:
	nop			;85b9	00 	. 
l85bah:
	nop			;85ba	00 	. 
	nop			;85bb	00 	. 
l85bch:
	nop			;85bc	00 	. 
l85bdh:
	inc bc			;85bd	03 	. 
	adc a,l			;85be	8d 	. 
l85bfh:
	nop			;85bf	00 	. 
l85c0h:
	nop			;85c0	00 	. 
	nop			;85c1	00 	. 
	nop			;85c2	00 	. 
	nop			;85c3	00 	. 
	nop			;85c4	00 	. 
	nop			;85c5	00 	. 
l85c6h:
	nop			;85c6	00 	. 
	nop			;85c7	00 	. 
	nop			;85c8	00 	. 
	nop			;85c9	00 	. 
	nop			;85ca	00 	. 
	nop			;85cb	00 	. 
	nop			;85cc	00 	. 
	nop			;85cd	00 	. 
l85ceh:
	nop			;85ce	00 	. 
	nop			;85cf	00 	. 
	nop			;85d0	00 	. 
l85d1h:
	nop			;85d1	00 	. 
	nop			;85d2	00 	. 
l85d3h:
	nop			;85d3	00 	. 
	nop			;85d4	00 	. 
	nop			;85d5	00 	. 
	nop			;85d6	00 	. 
	nop			;85d7	00 	. 
	nop			;85d8	00 	. 
	nop			;85d9	00 	. 
	nop			;85da	00 	. 
	nop			;85db	00 	. 
	nop			;85dc	00 	. 
	nop			;85dd	00 	. 
	nop			;85de	00 	. 
	nop			;85df	00 	. 
	nop			;85e0	00 	. 
	nop			;85e1	00 	. 
	nop			;85e2	00 	. 
	nop			;85e3	00 	. 
l85e4h:
	nop			;85e4	00 	. 
l85e5h:
	nop			;85e5	00 	. 
	nop			;85e6	00 	. 
l85e7h:
	nop			;85e7	00 	. 
	nop			;85e8	00 	. 
	nop			;85e9	00 	. 
	nop			;85ea	00 	. 
	nop			;85eb	00 	. 
	nop			;85ec	00 	. 
	nop			;85ed	00 	. 
	nop			;85ee	00 	. 
	nop			;85ef	00 	. 
	nop			;85f0	00 	. 
	nop			;85f1	00 	. 
	nop			;85f2	00 	. 
	nop			;85f3	00 	. 
	nop			;85f4	00 	. 
	nop			;85f5	00 	. 
	nop			;85f6	00 	. 
	nop			;85f7	00 	. 
	nop			;85f8	00 	. 
	nop			;85f9	00 	. 
	nop			;85fa	00 	. 
	nop			;85fb	00 	. 
	nop			;85fc	00 	. 
	nop			;85fd	00 	. 
	nop			;85fe	00 	. 
	nop			;85ff	00 	. 
l8600h:
	nop			;8600	00 	. 
l8601h:
	nop			;8601	00 	. 
	nop			;8602	00 	. 
l8603h:
	nop			;8603	00 	. 
	nop			;8604	00 	. 
	nop			;8605	00 	. 
	nop			;8606	00 	. 
	nop			;8607	00 	. 
	nop			;8608	00 	. 
	nop			;8609	00 	. 
	nop			;860a	00 	. 
	nop			;860b	00 	. 
	nop			;860c	00 	. 
	nop			;860d	00 	. 
	nop			;860e	00 	. 
	nop			;860f	00 	. 
	nop			;8610	00 	. 
	nop			;8611	00 	. 
	nop			;8612	00 	. 
	nop			;8613	00 	. 
	nop			;8614	00 	. 
	nop			;8615	00 	. 
	nop			;8616	00 	. 
	nop			;8617	00 	. 
	nop			;8618	00 	. 
	nop			;8619	00 	. 
	nop			;861a	00 	. 
	nop			;861b	00 	. 
	nop			;861c	00 	. 
	nop			;861d	00 	. 
	nop			;861e	00 	. 
	nop			;861f	00 	. 
	nop			;8620	00 	. 
l8621h:
	nop			;8621	00 	. 
	nop			;8622	00 	. 
	nop			;8623	00 	. 
	nop			;8624	00 	. 
	nop			;8625	00 	. 
	nop			;8626	00 	. 
	nop			;8627	00 	. 
	nop			;8628	00 	. 
	nop			;8629	00 	. 
	nop			;862a	00 	. 
	nop			;862b	00 	. 
	nop			;862c	00 	. 
	nop			;862d	00 	. 
	nop			;862e	00 	. 
	nop			;862f	00 	. 
	nop			;8630	00 	. 
	nop			;8631	00 	. 
	nop			;8632	00 	. 
	nop			;8633	00 	. 
	nop			;8634	00 	. 
	nop			;8635	00 	. 
	nop			;8636	00 	. 
	nop			;8637	00 	. 
	nop			;8638	00 	. 
	nop			;8639	00 	. 
	nop			;863a	00 	. 
	nop			;863b	00 	. 
	nop			;863c	00 	. 
	nop			;863d	00 	. 
	nop			;863e	00 	. 
	nop			;863f	00 	. 
	nop			;8640	00 	. 
	nop			;8641	00 	. 
	nop			;8642	00 	. 
	nop			;8643	00 	. 
	nop			;8644	00 	. 
	nop			;8645	00 	. 
	nop			;8646	00 	. 
l8647h:
	nop			;8647	00 	. 
	nop			;8648	00 	. 
	nop			;8649	00 	. 
	nop			;864a	00 	. 
	nop			;864b	00 	. 
	nop			;864c	00 	. 
	nop			;864d	00 	. 
	nop			;864e	00 	. 
	nop			;864f	00 	. 
	nop			;8650	00 	. 
	nop			;8651	00 	. 
	nop			;8652	00 	. 
	nop			;8653	00 	. 
	nop			;8654	00 	. 
	nop			;8655	00 	. 
	nop			;8656	00 	. 
	nop			;8657	00 	. 
	nop			;8658	00 	. 
	nop			;8659	00 	. 
	nop			;865a	00 	. 
	nop			;865b	00 	. 
	nop			;865c	00 	. 
sub_865dh:
	ld hl,VRAM		;865d	21 00 70 	! . p 
	ld de,VRAM+1		;8660	11 01 70 	. . p 
	ld bc,00258h		;8663	01 58 02 	. X . 
	ld (hl),020h		;8666	36 20 	6   
	ldir		;8668	ed b0 	. . 
	ret			;866a	c9 	. 
sub_866bh:
	ld hl,07800h		;866b	21 00 78 	! . x 
	ld de,07801h		;866e	11 01 78 	. . x 
	ld bc,005dch		;8671	01 dc 05 	. . . 
	ld (hl),000h		;8674	36 00 	6 . 
	ldir		;8676	ed b0 	. . 
	ret			;8678	c9 	. 

;***********************************************************************************************
; Delay
; Delay by decrement value until 0
; IN: bc - deley time value
DELAY_BC:
	dec bc			; decrement bc value										;8679	0b 	. 
	ld a,b			; chack if bc = 0											;867a	78 	x 
	or c			; is bc 0													;867b	b1 	. 
	jr nz,DELAY_BC	; no - keep decrement bc									;867c	20 fb 	  . 
	ret				; ---------------- End of Proc ---------------------------- ;867e	c9 	. 

;***************************************************************************************
; Print text on Screen.
; Given text has to be terminated with '$' char. Procedure convert ASCII chars to Screen chars.
; IN: hl - address of text to display
;     de - VRAM destination address
PRINT_TEXT:
	ld a,(hl)			; a - char to display									;867f	7e 	~ 
	cp $40				; is greater than $40 - need convert to Screen char		;8680	fe 40 	. @ 
	call nc,.ASCII_2_SCREEN	; yes - convert to Screen Char						;8682	d4 8d 86 	. . . 
	cp '$'				; is this text delimiter? 								;8685	fe 24 	. $ 
	ret z				; yes -------------- End of Proc ---------------------- ;8687	c8 	. 
	ld (de),a			; store char to Screen memoey (VRAM)					;8688	12 	. 
	inc de				; de - next char in VRAM (destination)					;8689	13 	. 
	inc hl				; hl - next char to display (source)					;868a	23 	# 
	jr PRINT_TEXT		; print all chars until '$' is found					;868b	18 f2 	. . 
.ASCII_2_SCREEN:
	sub $40				; convert ASCII char to Screen Char						;868d	d6 40 	. @ 
	ret					; ------------------ End of Proc ---------------------- ;868f	c9 	. 


sub_8690h:
	ld hl,07800h		;8690	21 00 78 	! . x 
	ld de,07180h		;8693	11 80 71 	. . q 
	ld bc,00580h		;8696	01 80 05 	. . . 
	ldir		;8699	ed b0 	. . 
	ret			;869b	c9 	. 



;***********************************************************************************************
;
;    M A I N   E N T R Y   P O I N T
;
;***********************************************************************************************
	org $869c

MAIN:
; -- cleanup procedure	
	xor a				; 0 - CASOUT off, SOUND off, GFX MODE 0					;869c	af 
	ld (IOLATCH),a		; reset Gfx and Sound									;869d	32 00 68
; -- clear screen (fill with spaces)
	ld hl,VRAM			; hl - start of Video RAM 								;86a0	21 00 70
	ld de,VRAM+1		; de - destination - start of Video RAM 				;86a3	11 01 70 
	ld bc,512			; 512 bytes of VRAM area (Mode 0)						;86a6	01 00 02
	ld (hl),' '			; store space into first byte							;86a9	36 20 
	ldir				; fill rest of Screen with spaces						;86ab	ed b0 
; -- disable interrupts and reset CPU stack
	di					; disable interrupts									;86ad	f3 
	ld sp,GAME_CPU_STACK; set CPU Stack to custom reserved area					;86ae	31 f0 7e 

; -- Print Welcome screen Texts
	ld de,VRAM+(3*32)+5	; screen coord (5,3)char [$7065]						;86b1	11 65 70
	ld hl,TXT_TITLE		; hl - "DEFENCE PENETRATOR" text						;86b4	21 36 85 
	call PRINT_TEXT		; print text on Screen 									;86b7	cd 7f 86 	.  . 
	ld de,VRAM+(6*32)+6	; screen coord (6,6)char [$70c6]						;86ba	11 c6 70 
	ld hl,TXT_AUTHOR	; hl - "WRITTEN BY TOM THIEL" text						;86bd	21 4d 85 
	call PRINT_TEXT		; print text on Screen 									;86c0	cd 7f 86 	.  . 
	ld de,VRAM+(9*32)+0	; screen coord (0,9)char [$7120]						;86c3	11 20 71 
	ld hl,TXT_COPYRIGHT	; hl - "COPYRIGHT 1982 - COSMIC SOFTWARE" text			;86c6	21 62 85
	call PRINT_TEXT		; print text on Screen 									;86c9	cd 7f 86 	.  . 
	ld de,VRAM+(14*32)+5; screen coord (5,14)char [$71c5]						;86cc	11 c5 71 
	ld hl,TXT_PRESSSPACE; hl - "PRESS <SPACE> TO PLAY!" text					;86cf	21 83 85 
	call PRINT_TEXT		; print text on Screen 									;86d2	cd 7f 86 	.  . 

; -- Draw Welcome screen Frame chars
	ld a,$80			; a - green blank SemiGfx Char 							;86d5	3e 80 	> . 
DRAW_WELCOME_FRAME:
	ld hl,VRAM+(0*32)+0	; screen coord (0,0) [$7000]							;86d7	21 00 70 	! . p 
	ld de,VRAM+1		; next char in 1st line									;86da	11 01 70 	. . p 
	ld bc,31			; 31 chars in line to fill								;86dd	01 1f 00 	. . . 
	ld (hl),a			; store 1rs char										;86e0	77 	w 
	ldir				; fill 1st line on Screen with char from A				;86e1	ed b0 	. . 
	ld hl,VRAM+(15*32)+0; screen coord (0,15) [$71e0]							;86e3	21 e0 71 	! . q 
	ld de,VRAM+(15*32)+1; next char in last line								;86e6	11 e1 71 	. . q 
	ld bc,31			; 31 chars in line to fill								;86e9	01 1f 00 	. . . 
	ld (hl),a			; store 1rs char										;86ec	77 	w 
	ldir				; fill last line on Screen with char from A				;86ed	ed b0 	. . 
	inc a				; a - next SemiChar to draw on Top&Bottom line			;86ef	3c 	< 
	cp $ff				; is less than last char 								;86f0	fe ff 	. . 
	jr c,l86f6h			; yes - skip reset SemiChar - check space Key press 	;86f2	38 02 	8 . 
	ld a,080h			; reset SemiChar to draw next time						;86f4	3e 80 	> . 
l86f6h:
	ld d,a				; d - save SemiChar to draw								;86f6	57 	W 
	ld a,(KEYS_ROW_4)	; a - read Keyboard row 4								;86f7	3a ef 6f 	: . o 
	bit 4,a				; is SPACE kay pressed									;86fa	cb 67 	. g 
	jr z,l8707h			; yes - ;86fc	28 09 	( . 
	ld bc,8500			; bc - delay time										;86fe	01 34 21 	. 4 ! 
	call DELAY_BC		; wait average delay									;8701	cd 79 86 	. y . 
	ld a,d				; a - restore SemiChar to draw							;8704	7a 	z 
	jr DRAW_WELCOME_FRAME	; draw top & bottom lines with next SemiChar		;8705	18 d0 	. . 


l8707h:
	ld a,003h		;8707	3e 03 	> . 
	ld (l85b3h),a		;8709	32 b3 85 	2 . . 
	ld a,001h		;870c	3e 01 	> . 
	ld (l85b4h),a		;870e	32 b4 85 	2 . . 
	ld a,008h		;8711	3e 08 	> . 
	ld (IOLATCH),a		;8713	32 00 68 	2 . h 
	ld (l85a9h),a		;8716	32 a9 85 	2 . . 
	ld hl,00000h		;8719	21 00 00 	! . . 
	ld (l85b5h),hl		;871c	22 b5 85 	" . . 
	call sub_8725h		;871f	cd 25 87 	. % . 
	jp l90aah		;8722	c3 aa 90 	. . . 
sub_8725h:
	ld hl,07282h		;8725	21 82 72 	! . r 
	ld (l85ach),hl		;8728	22 ac 85 	" . . 
	ld a,002h		;872b	3e 02 	> . 
	ld (l85aeh+2),a		;872d	32 b0 85 	2 . . 
	ld hl,l85bfh		;8730	21 bf 85 	! . . 
	ld de,l85c0h		;8733	11 c0 85 	. . . 
	ld bc,00096h		;8736	01 96 00 	. . . 
	ld (hl),000h		;8739	36 00 	6 . 
	ldir		;873b	ed b0 	. . 
	call sub_866bh		;873d	cd 6b 86 	. k . 
	ld hl,07800h		;8740	21 00 78 	! . x 
	ld de,07801h		;8743	11 01 78 	. . x 
	ld bc,00040h		;8746	01 40 00 	. @ . 
	ld (hl),055h		;8749	36 55 	6 U 
	ldir		;874b	ed b0 	. . 
	call sub_8781h		;874d	cd 81 87 	. . . 
	ld (l85aah),ix		;8750	dd 22 aa 85 	. " . . 
	xor a			;8754	af 	. 
	ld (l85a8h),a		;8755	32 a8 85 	2 . . 
	ld a,008h		;8758	3e 08 	> . 
	ld (IOLATCH),a		;875a	32 00 68 	2 . h 
	ld (l85a9h),a		;875d	32 a9 85 	2 . . 
	ld a,014h		;8760	3e 14 	> . 
	ld (l85b9h),a		;8762	32 b9 85 	2 . . 
	ld hl,VRAM		;8765	21 00 70 	! . p 
	ld de,VRAM+1		;8768	11 01 70 	. . p 
	ld bc,00800h		;876b	01 00 08 	. . . 
	ld (hl),000h		;876e	36 00 	6 . 
	ldir		;8770	ed b0 	. . 
	xor a			;8772	af 	. 
	ld (l8e84h),a		;8773	32 84 8e 	2 . . 
	nop			;8776	00 	. 
	nop			;8777	00 	. 
	nop			;8778	00 	. 
	nop			;8779	00 	. 
	nop			;877a	00 	. 
	pop hl			;877b	e1 	. 
	ld sp,GAME_CPU_STACK		;877c	31 f0 7e 	1 . ~ 
	push hl			;877f	e5 	. 
	ret			;8780	c9 	. 
sub_8781h:
	ld ix,07f00h		;8781	dd 21 00 7f 	. ! .  
	ld a,(l85b4h)		;8785	3a b4 85 	: . . 
	ld c,a			;8788	4f 	O 
l8789h:
	ld a,(ix+000h)		;8789	dd 7e 00 	. ~ . 
	cp 0ffh		;878c	fe ff 	. . 
	jr nz,l8796h		;878e	20 06 	  . 
	ld a,(ix+001h)		;8790	dd 7e 01 	. ~ . 
	cp c			;8793	b9 	. 
	jr z,l879ch		;8794	28 06 	( . 
l8796h:
	inc ix		;8796	dd 23 	. # 
	inc ix		;8798	dd 23 	. # 
	jr l8789h		;879a	18 ed 	. . 
l879ch:
	inc ix		;879c	dd 23 	. # 
	inc ix		;879e	dd 23 	. # 
	ret			;87a0	c9 	. 
sub_87a1h:
	ld hl,(l85ach)		;87a1	2a ac 85 	* . . 
	nop			;87a4	00 	. 
	nop			;87a5	00 	. 
	ld de,00020h		;87a6	11 20 00 	.   . 
	add hl,de			;87a9	19 	. 
	ld (hl),00ah		;87aa	36 0a 	6 . 
	inc de			;87ac	13 	. 
	add hl,de			;87ad	19 	. 
	ld (hl),0aah		;87ae	36 aa 	6 . 
	inc hl			;87b0	23 	# 
	ld (hl),0a0h		;87b1	36 a0 	6 . 
	ld de,0001eh		;87b3	11 1e 00 	. . . 
	add hl,de			;87b6	19 	. 
	ld (hl),00ah		;87b7	36 0a 	6 . 
	inc hl			;87b9	23 	# 
	ld (hl),0aah		;87ba	36 aa 	6 . 
	inc hl			;87bc	23 	# 
	ld (hl),0aah		;87bd	36 aa 	6 . 
	ld ix,(l85aeh)		;87bf	dd 2a ae 85 	. * . . 
	ld a,(ix+000h)		;87c3	dd 7e 00 	. ~ . 
	cp 0ceh		;87c6	fe ce 	. . 
	call z,087deh		;87c8	cc de 87 	. . . 
	inc ix		;87cb	dd 23 	. # 
	ld (l85aeh),ix		;87cd	dd 22 ae 85 	. " . . 
	ld hl,(l85ach)		;87d1	2a ac 85 	* . . 
	ld de,00040h		;87d4	11 40 00 	. @ . 
	add hl,de			;87d7	19 	. 
	ld (hl),a			;87d8	77 	w 
l87d9h:
	ret			;87d9	c9 	. 
	ld a,(bc)			;87da	0a 	. 
	ld b,036h		;87db	06 36 	. 6 
	adc a,0ddh		;87dd	ce dd 	. . 
	ld hl,l87d9h		;87df	21 d9 87 	! . . 
	ret			;87e2	c9 	. 
sub_87e3h:
	ld hl,VRAM		;87e3	21 00 70 	! . p 
	ld (l85bah),hl		;87e6	22 ba 85 	" . . 
	ld hl,(l85b5h)		;87e9	2a b5 85 	* . . 
	call sub_888bh		;87ec	cd 8b 88 	. . . 
	ld hl,07100h		;87ef	21 00 71 	! . q 
	ld a,(l85b3h)		;87f2	3a b3 85 	: . . 
	ld b,a			;87f5	47 	G 
l87f6h:
	ld (hl),0c0h		;87f6	36 c0 	6 . 
	push hl			;87f8	e5 	. 
	ld de,00020h		;87f9	11 20 00 	.   . 
	add hl,de			;87fc	19 	. 
	ld (hl),0fch		;87fd	36 fc 	6 . 
	pop hl			;87ff	e1 	. 
	inc hl			;8800	23 	# 
	djnz l87f6h		;8801	10 f3 	. . 
	ld hl,0700ch		;8803	21 0c 70 	! . p 
	ld de,0700dh		;8806	11 0d 70 	. . p 
	ld bc,0000ch		;8809	01 0c 00 	. . . 
	ld (hl),0aah		;880c	36 aa 	6 . 
	ldir		;880e	ed b0 	. . 
	ld hl,070ach		;8810	21 ac 70 	! . p 
	ld de,070adh		;8813	11 ad 70 	. . p 
	ld bc,0000ch		;8816	01 0c 00 	. . . 
	ld (hl),0aah		;8819	36 aa 	6 . 
	ldir		;881b	ed b0 	. . 
	ld ix,0702ch		;881d	dd 21 2c 70 	. ! , p 
	ld b,007h		;8821	06 07 	. . 
	ld c,028h		;8823	0e 28 	. ( 
l8825h:
	ld (ix+000h),c		;8825	dd 71 00 	. q . 
	ld (ix+020h),c		;8828	dd 71 20 	. q   
	ld (ix+040h),c		;882b	dd 71 40 	. q @ 
	ld (ix+060h),c		;882e	dd 71 60 	. q ` 
	inc ix		;8831	dd 23 	. # 
	inc ix		;8833	dd 23 	. # 
	djnz l8825h		;8835	10 ee 	. . 
	ld hl,0704dh		;8837	21 4d 70 	! M p 
	ld c,000h		;883a	0e 00 	. . 
	ld a,(l85b4h)		;883c	3a b4 85 	: . . 
l883fh:
	inc c			;883f	0c 	. 
	cp c			;8840	b9 	. 
	jr z,l8847h		;8841	28 04 	( . 
	inc hl			;8843	23 	# 
	inc hl			;8844	23 	# 
	jr l883fh		;8845	18 f8 	. . 
l8847h:
	ld a,(l85bch)		;8847	3a bc 85 	: . . 
	inc a			;884a	3c 	< 
	ld (l85bch),a		;884b	32 bc 85 	2 . . 
	cp 008h		;884e	fe 08 	. . 
	jr c,l8861h		;8850	38 0f 	8 . 
	cp 010h		;8852	fe 10 	. . 
	call nc,sub_8886h		;8854	d4 86 88 	. . . 
	ld (hl),055h		;8857	36 55 	6 U 
	ld de,00020h		;8859	11 20 00 	.   . 
	add hl,de			;885c	19 	. 
	ld (hl),055h		;885d	36 55 	6 U 
	jr l8869h		;885f	18 08 	. . 
l8861h:
	ld (hl),0ffh		;8861	36 ff 	6 . 
	ld de,00020h		;8863	11 20 00 	.   . 
	add hl,de			;8866	19 	. 
	ld (hl),0ffh		;8867	36 ff 	6 . 
l8869h:
	ld hl,07128h		;8869	21 28 71 	! ( q 
	ld de,07129h		;886c	11 29 71 	. ) q 
	ld bc,00014h		;886f	01 14 00 	. . . 
	ld (hl),0ffh		;8872	36 ff 	6 . 
	ldir		;8874	ed b0 	. . 
	ld a,(l85b9h)		;8876	3a b9 85 	: . . 
	ld c,000h		;8879	0e 00 	. . 
	ld hl,07128h		;887b	21 28 71 	! ( q 
l887eh:
	ld (hl),055h		;887e	36 55 	6 U 
	inc c			;8880	0c 	. 
	inc hl			;8881	23 	# 
	cp c			;8882	b9 	. 
	jr nc,l887eh		;8883	30 f9 	0 . 
	ret			;8885	c9 	. 
sub_8886h:
	xor a			;8886	af 	. 
	ld (l85bch),a		;8887	32 bc 85 	2 . . 
	ret			;888a	c9 	. 
sub_888bh:
	ld iy,l88b2h		;888b	fd 21 b2 88 	. ! . . 
l888fh:
	xor a			;888f	af 	. 
	ld b,(iy+001h)		;8890	fd 46 01 	. F . 
	ld c,(iy+000h)		;8893	fd 4e 00 	. N . 
	or a			;8896	b7 	. 
l8897h:
	sbc hl,bc		;8897	ed 42 	. B 
	jr c,l889eh		;8899	38 03 	8 . 
	inc a			;889b	3c 	< 
	jr l8897h		;889c	18 f9 	. . 
l889eh:
	add hl,bc			;889e	09 	. 
	push hl			;889f	e5 	. 
	push de			;88a0	d5 	. 
	push bc			;88a1	c5 	. 
	call 088bch		;88a2	cd bc 88 	. . . 
	pop bc			;88a5	c1 	. 
	pop de			;88a6	d1 	. 
	pop hl			;88a7	e1 	. 
	ld a,c			;88a8	79 	y 
	cp 001h		;88a9	fe 01 	. . 
	ret z			;88ab	c8 	. 
	inc iy		;88ac	fd 23 	. # 
	inc iy		;88ae	fd 23 	. # 
	jr l888fh		;88b0	18 dd 	. . 
l88b2h:
	djnz $+41		;88b2	10 27 	. ' 
	ret pe			;88b4	e8 	. 
	inc bc			;88b5	03 	. 
	ld h,h			;88b6	64 	d 
	nop			;88b7	00 	. 
	ld a,(bc)			;88b8	0a 	. 
	nop			;88b9	00 	. 
	ld bc,0dd00h		;88ba	01 00 dd 	. . . 
	ld hl,l88e6h		;88bd	21 e6 88 	! . . 
	cp 000h		;88c0	fe 00 	. . 
	jr z,l88cfh		;88c2	28 0b 	( . 
	ld de,00005h		;88c4	11 05 00 	. . . 
	ld c,000h		;88c7	0e 00 	. . 
l88c9h:
	inc c			;88c9	0c 	. 
	add ix,de		;88ca	dd 19 	. . 
	cp c			;88cc	b9 	. 
	jr nz,l88c9h		;88cd	20 fa 	  . 
l88cfh:
	ld de,00020h		;88cf	11 20 00 	.   . 
	ld hl,(l85bah)		;88d2	2a ba 85 	* . . 
	inc hl			;88d5	23 	# 
	ld (l85bah),hl		;88d6	22 ba 85 	" . . 
	dec hl			;88d9	2b 	+ 
	ld b,005h		;88da	06 05 	. . 
l88dch:
	ld c,(ix+000h)		;88dc	dd 4e 00 	. N . 
	ld (hl),c			;88df	71 	q 
	inc ix		;88e0	dd 23 	. # 
	add hl,de			;88e2	19 	. 
	djnz l88dch		;88e3	10 f7 	. . 
	ret			;88e5	c9 	. 
l88e6h:
	call m,0cccch		;88e6	fc cc cc 	. . . 
	call z,030fch		;88e9	cc fc 30 	. . 0 
	jr nc,$+50		;88ec	30 30 	0 0 
	jr nc,$+50		;88ee	30 30 	0 0 
	call m,0fc0ch		;88f0	fc 0c fc 	. . . 
	ret nz			;88f3	c0 	. 
	call m,00cfch		;88f4	fc fc 0c 	. . . 
	inc a			;88f7	3c 	< 
	inc c			;88f8	0c 	. 
	call m,0cccch		;88f9	fc cc cc 	. . . 
	call m,00c0ch		;88fc	fc 0c 0c 	. . . 
	call m,0fcc0h		;88ff	fc c0 fc 	. . . 
	inc c			;8902	0c 	. 
	call m,0c0fch		;8903	fc fc c0 	. . . 
	call m,0fccch		;8906	fc cc fc 	. . . 
	call m,00c0ch		;8909	fc 0c 0c 	. . . 
	inc c			;890c	0c 	. 
	inc c			;890d	0c 	. 
	call m,0fccch		;890e	fc cc fc 	. . . 
	call z,0fcfch		;8911	cc fc fc 	. . . 
	call z,00cfch		;8914	cc fc 0c 	. . . 
	call m,02addh		;8917	fc dd 2a 	. . * 
	xor d			;891a	aa 	. 
	add a,l			;891b	85 	. 
	ld d,(ix+000h)		;891c	dd 56 00 	. V . 
	ld e,(ix+001h)		;891f	dd 5e 01 	. ^ . 
	inc ix		;8922	dd 23 	. # 
	inc ix		;8924	dd 23 	. # 
	ld (l85aah),ix		;8926	dd 22 aa 85 	. " . . 
	ld a,d			;892a	7a 	z 
	cp 0ffh		;892b	fe ff 	. . 
	jp z,l8988h		;892d	ca 88 89 	. . . 
	cp 0c8h		;8930	fe c8 	. . 
	jp nc,l8a24h		;8932	d2 24 8a 	. $ . 
	sub 02ch		;8935	d6 2c 	. , 
	ld d,a			;8937	57 	W 
	ld a,e			;8938	7b 	{ 
	sub 02bh		;8939	d6 2b 	. + 
	ld e,a			;893b	5f 	_ 
	ld hl,0781fh		;893c	21 1f 78 	! . x 
	ld c,000h		;893f	0e 00 	. . 
l8941h:
	inc c			;8941	0c 	. 
	ld a,c			;8942	79 	y 
	cp d			;8943	ba 	. 
	jr c,l894dh		;8944	38 07 	8 . 
	cp e			;8946	bb 	. 
	jr nc,l894dh		;8947	30 04 	0 . 
	ld (hl),000h		;8949	36 00 	6 . 
	jr l894fh		;894b	18 02 	. . 
l894dh:
	ld (hl),055h		;894d	36 55 	6 U 
l894fh:
	push de			;894f	d5 	. 
	ld de,00020h		;8950	11 20 00 	.   . 
	add hl,de			;8953	19 	. 
	pop de			;8954	d1 	. 
	cp 02ch		;8955	fe 2c 	. , 
	ret nc			;8957	d0 	. 
	jr l8941h		;8958	18 e7 	. . 
sub_895ah:
	ld hl,07801h		;895a	21 01 78 	! . x 
	ld de,07800h		;895d	11 00 78 	. . x 
	ld bc,00581h		;8960	01 81 05 	. . . 
	ldir		;8963	ed b0 	. . 
	ret			;8965	c9 	. 
	nop			;8966	00 	. 
	nop			;8967	00 	. 
	nop			;8968	00 	. 
	nop			;8969	00 	. 
	nop			;896a	00 	. 
	nop			;896b	00 	. 
	nop			;896c	00 	. 
	nop			;896d	00 	. 
	nop			;896e	00 	. 
	nop			;896f	00 	. 
	nop			;8970	00 	. 
	nop			;8971	00 	. 
	nop			;8972	00 	. 
	nop			;8973	00 	. 
	nop			;8974	00 	. 
	nop			;8975	00 	. 
	nop			;8976	00 	. 
	nop			;8977	00 	. 
	nop			;8978	00 	. 
	nop			;8979	00 	. 
sub_897ah:
	ld hl,07700h		;897a	21 00 77 	! . w 
	ld de,07701h		;897d	11 01 77 	. . w 
	ld bc,00100h		;8980	01 00 01 	. . . 
	ld (hl),055h		;8983	36 55 	6 U 
	ldir		;8985	ed b0 	. . 
	ret			;8987	c9 	. 
l8988h:
	ld a,e			;8988	7b 	{ 
	ld (l85b4h),a		;8989	32 b4 85 	2 . . 
	ld hl,VRAM		;898c	21 00 70 	! . p 
	ld de,VRAM+1		;898f	11 01 70 	. . p 
	ld bc,00140h		;8992	01 40 01 	. @ . 
	ld (hl),000h		;8995	36 00 	6 . 
	ldir		;8997	ed b0 	. . 
	call sub_8dc4h		;8999	cd c4 8d 	. . . 
	ld a,008h		;899c	3e 08 	> . 
	ld (l85a9h),a		;899e	32 a9 85 	2 . . 
	xor a			;89a1	af 	. 
	ld (l85a8h),a		;89a2	32 a8 85 	2 . . 
	jp 08918h		;89a5	c3 18 89 	. . . 
sub_89a8h:
	ld a,(KEYS_ROW_0)		;89a8	3a fe 6f 	: . o 
	bit 4,a		;89ab	cb 67 	. g 
	jr z,l89e2h		;89ad	28 33 	( 3 
	ld a,(KEYS_ROW_1)		;89af	3a fd 6f 	: . o 
	bit 4,a		;89b2	cb 67 	. g 
	jr z,l89f0h		;89b4	28 3a 	( : 
l89b6h:
	ld a,(KEYS_ROW_5)		;89b6	3a df 6f 	: . o 
	bit 4,a		;89b9	cb 67 	. g 
	jr z,l89fch		;89bb	28 3f 	( ? 
	bit 2,a		;89bd	cb 57 	. W 
	jr z,l8a10h		;89bf	28 4f 	( O 
l89c1h:
	ld a,(KEYS_ROW_4)		;89c1	3a ef 6f 	: . o 
	bit 5,a		;89c4	cb 6f 	. o 
	call sub_8e20h		;89c6	cd 20 8e 	.   . 
	ld a,(KEYS_ROW_5)		;89c9	3a df 6f 	: . o 
	cp 0f5h		;89cc	fe f5 	. . 
	jp z,MAIN		;89ce	ca 9c 86 	. . . 
	ld a,(KEYS_ROW_3)		;89d1	3a f7 6f 	: . o 
	bit 3,a		;89d4	cb 5f 	. _ 
	call z,sub_89dah		;89d6	cc da 89 	. . . 
	ret			;89d9	c9 	. 
sub_89dah:
	ld a,(KEYS_ROW_3)		;89da	3a f7 6f 	: . o 
	bit 5,a		;89dd	cb 6f 	. o 
	jr nz,sub_89dah		;89df	20 f9 	  . 
	ret			;89e1	c9 	. 
l89e2h:
	ld hl,(l85ach)		;89e2	2a ac 85 	* . . 
	ld de,00020h		;89e5	11 20 00 	.   . 
	or a			;89e8	b7 	. 
	sbc hl,de		;89e9	ed 52 	. R 
	ld (l85ach),hl		;89eb	22 ac 85 	" . . 
	jr l89b6h		;89ee	18 c6 	. . 
l89f0h:
	ld hl,(l85ach)		;89f0	2a ac 85 	* . . 
	ld de,00020h		;89f3	11 20 00 	.   . 
	add hl,de			;89f6	19 	. 
	ld (l85ach),hl		;89f7	22 ac 85 	" . . 
	jr l89b6h		;89fa	18 ba 	. . 
l89fch:
	ld a,(l85aeh+2)		;89fc	3a b0 85 	: . . 
	cp 002h		;89ff	fe 02 	. . 
	jr c,l89c1h		;8a01	38 be 	8 . 
	dec a			;8a03	3d 	= 
	ld (l85aeh+2),a		;8a04	32 b0 85 	2 . . 
	ld hl,(l85ach)		;8a07	2a ac 85 	* . . 
	dec hl			;8a0a	2b 	+ 
	ld (l85ach),hl		;8a0b	22 ac 85 	" . . 
	jr l89c1h		;8a0e	18 b1 	. . 
l8a10h:
	ld a,(l85aeh+2)		;8a10	3a b0 85 	: . . 
	cp 014h		;8a13	fe 14 	. . 
	jr nc,l89c1h		;8a15	30 aa 	0 . 
	inc a			;8a17	3c 	< 
	ld (l85aeh+2),a		;8a18	32 b0 85 	2 . . 
	ld hl,(l85ach)		;8a1b	2a ac 85 	* . . 
	inc hl			;8a1e	23 	# 
	ld (l85ach),hl		;8a1f	22 ac 85 	" . . 
	jr l89c1h		;8a22	18 9d 	. . 
l8a24h:
	ex af,af'			;8a24	08 	. 
	call sub_8ab4h		;8a25	cd b4 8a 	. . . 
	ex af,af'			;8a28	08 	. 
	cp 0dfh		;8a29	fe df 	. . 
	jr z,l8a40h		;8a2b	28 13 	( . 
	cp 0deh		;8a2d	fe de 	. . 
	jr z,l8a64h		;8a2f	28 33 	( 3 
	cp 0ddh		;8a31	fe dd 	. . 
	jr z,l8a88h		;8a33	28 53 	( S 
	ld a,01eh		;8a35	3e 1e 	> . 
	ld (l8600h),a		;8a37	32 00 86 	2 . . 
	ld (l8601h),hl		;8a3a	22 01 86 	" . . 
	jp 08918h		;8a3d	c3 18 89 	. . . 
l8a40h:
	ld iy,l8647h		;8a40	fd 21 47 86 	. ! G . 
	ld b,003h		;8a44	06 03 	. . 
l8a46h:
	ld a,(iy+000h)		;8a46	fd 7e 00 	. ~ . 
	cp 000h		;8a49	fe 00 	. . 
	jr nz,l8a5ah		;8a4b	20 0d 	  . 
	ld (iy+000h),01eh		;8a4d	fd 36 00 1e 	. 6 . . 
	ld (iy+001h),l		;8a51	fd 75 01 	. u . 
	ld (iy+002h),h		;8a54	fd 74 02 	. t . 
	jp 08918h		;8a57	c3 18 89 	. . . 
l8a5ah:
	ld de,00003h		;8a5a	11 03 00 	. . . 
	add iy,de		;8a5d	fd 19 	. . 
	djnz l8a46h		;8a5f	10 e5 	. . 
	jp 08918h		;8a61	c3 18 89 	. . . 
l8a64h:
	ld iy,l8621h		;8a64	fd 21 21 86 	. ! ! . 
	ld b,009h		;8a68	06 09 	. . 
l8a6ah:
	ld a,(iy+000h)		;8a6a	fd 7e 00 	. ~ . 
	cp 000h		;8a6d	fe 00 	. . 
	jr nz,l8a7eh		;8a6f	20 0d 	  . 
	ld (iy+000h),01eh		;8a71	fd 36 00 1e 	. 6 . . 
	ld (iy+001h),l		;8a75	fd 75 01 	. u . 
	ld (iy+002h),h		;8a78	fd 74 02 	. t . 
	jp 08918h		;8a7b	c3 18 89 	. . . 
l8a7eh:
	ld de,00003h		;8a7e	11 03 00 	. . . 
	add iy,de		;8a81	fd 19 	. . 
	djnz l8a6ah		;8a83	10 e5 	. . 
	jp 08918h		;8a85	c3 18 89 	. . . 
l8a88h:
	ld iy,l8603h		;8a88	fd 21 03 86 	. ! . . 
	ld b,006h		;8a8c	06 06 	. . 
l8a8eh:
	ld a,(iy+000h)		;8a8e	fd 7e 00 	. ~ . 
	cp 000h		;8a91	fe 00 	. . 
	jr nz,l8aaah		;8a93	20 15 	  . 
	ld (iy+000h),01eh		;8a95	fd 36 00 1e 	. 6 . . 
	ld (iy+001h),l		;8a99	fd 75 01 	. u . 
	ld (iy+002h),h		;8a9c	fd 74 02 	. t . 
	ld a,01dh		;8a9f	3e 1d 	> . 
	call sub_8ac9h		;8aa1	cd c9 8a 	. . . 
	ld (iy+003h),a		;8aa4	fd 77 03 	. w . 
	jp 08918h		;8aa7	c3 18 89 	. . . 
l8aaah:
	ld de,00004h		;8aaa	11 04 00 	. . . 
	add iy,de		;8aad	fd 19 	. . 
	djnz l8a8eh		;8aaf	10 dd 	. . 
	jp 08918h		;8ab1	c3 18 89 	. . . 
sub_8ab4h:
	ld hl,0771eh		;8ab4	21 1e 77 	! . w 
	ld de,00020h		;8ab7	11 20 00 	.   . 
l8abah:
	or a			;8aba	b7 	. 
	sbc hl,de		;8abb	ed 52 	. R 
	ld a,(hl)			;8abd	7e 	~ 
	cp 000h		;8abe	fe 00 	. . 
	jr nz,l8abah		;8ac0	20 f8 	  . 
	sbc hl,de		;8ac2	ed 52 	. R 
	sbc hl,de		;8ac4	ed 52 	. R 
	sbc hl,de		;8ac6	ed 52 	. R 
	ret			;8ac8	c9 	. 
sub_8ac9h:
	ld c,a			;8ac9	4f 	O 
l8acah:
	ld a,r		;8aca	ed 5f 	. _ 
	cp c			;8acc	b9 	. 
	ret c			;8acd	d8 	. 
	rrc a		;8ace	cb 0f 	. . 
	cp c			;8ad0	b9 	. 
	ret c			;8ad1	d8 	. 
	push bc			;8ad2	c5 	. 
	ld b,a			;8ad3	47 	G 
l8ad4h:
	djnz l8ad4h		;8ad4	10 fe 	. . 
	pop bc			;8ad6	c1 	. 
	jr l8acah		;8ad7	18 f1 	. . 
sub_8ad9h:
	ld ix,l8621h		;8ad9	dd 21 21 86 	. ! ! . 
	ld b,009h		;8add	06 09 	. . 
l8adfh:
	push bc			;8adf	c5 	. 
	ld a,(ix+000h)		;8ae0	dd 7e 00 	. ~ . 
	cp 000h		;8ae3	fe 00 	. . 
	jr z,l8afch		;8ae5	28 15 	( . 
	dec (ix+000h)		;8ae7	dd 35 00 	. 5 . 
	ld h,(ix+002h)		;8aea	dd 66 02 	. f . 
	ld l,(ix+001h)		;8aed	dd 6e 01 	. n . 
	dec hl			;8af0	2b 	+ 
	ld (ix+002h),h		;8af1	dd 74 02 	. t . 
	ld (ix+001h),l		;8af4	dd 75 01 	. u . 
	call sub_8b0bh		;8af7	cd 0b 8b 	. . . 
	jr l8b02h		;8afa	18 06 	. . 
l8afch:
	ld bc,15			; bc - delay time 										;8afc	01 0f 00 	. . . 
	call DELAY_BC		; wait short Delay										;8aff	cd 79 86 	. y . 
l8b02h:
	pop bc			;8b02	c1 	. 
	ld de,00003h		;8b03	11 03 00 	. . . 
	add ix,de		;8b06	dd 19 	. . 
	djnz l8adfh		;8b08	10 d5 	. . 
	ret			;8b0a	c9 	. 
sub_8b0bh:
	push hl			;8b0b	e5 	. 
	pop iy		;8b0c	fd e1 	. . 
	ld (iy+000h),02ah		;8b0e	fd 36 00 2a 	. 6 . * 
	ld (iy+001h),0a8h		;8b12	fd 36 01 a8 	. 6 . . 
	ld (iy+020h),025h		;8b16	fd 36 20 25 	. 6   % 
	ld (iy+021h),058h		;8b1a	fd 36 21 58 	. 6 ! X 
	ld (iy+040h),0aah		;8b1e	fd 36 40 aa 	. 6 @ . 
	ld (iy+041h),0aah		;8b22	fd 36 41 aa 	. 6 A . 
	ld (iy+060h),082h		;8b26	fd 36 60 82 	. 6 ` . 
	ld (iy+061h),082h		;8b2a	fd 36 61 82 	. 6 a . 
	ret			;8b2e	c9 	. 
sub_8b2fh:
	ld a,(l8600h)		;8b2f	3a 00 86 	: . . 
	cp 000h		;8b32	fe 00 	. . 
	ret z			;8b34	c8 	. 
	dec a			;8b35	3d 	= 
	ld (l8600h),a		;8b36	32 00 86 	2 . . 
	ld hl,(l8601h)		;8b39	2a 01 86 	* . . 
	dec hl			;8b3c	2b 	+ 
	ld (l8601h),hl		;8b3d	22 01 86 	" . . 
	ld de,00080h		;8b40	11 80 00 	. . . 
	or a			;8b43	b7 	. 
	sbc hl,de		;8b44	ed 52 	. R 
	push hl			;8b46	e5 	. 
	pop ix		;8b47	dd e1 	. . 
	ld (ix+000h),00ah		;8b49	dd 36 00 0a 	. 6 . . 
	ld (ix+001h),0a0h		;8b4d	dd 36 01 a0 	. 6 . . 
	ld (ix+020h),025h		;8b51	dd 36 20 25 	. 6   % 
	ld (ix+021h),058h		;8b55	dd 36 21 58 	. 6 ! X 
	ld (ix+040h),09ah		;8b59	dd 36 40 9a 	. 6 @ . 
	ld (ix+041h),0a6h		;8b5d	dd 36 41 a6 	. 6 A . 
	ld (ix+060h),02ah		;8b61	dd 36 60 2a 	. 6 ` * 
	ld (ix+061h),0a8h		;8b65	dd 36 61 a8 	. 6 a . 
	add hl,de			;8b69	19 	. 
	push hl			;8b6a	e5 	. 
	pop ix		;8b6b	dd e1 	. . 
	ld (ix+000h),00bh		;8b6d	dd 36 00 0b 	. 6 . . 
	ld (ix+001h),0e0h		;8b71	dd 36 01 e0 	. 6 . . 
	ld (ix+020h),00bh		;8b75	dd 36 20 0b 	. 6   . 
	ld (ix+021h),0e0h		;8b79	dd 36 21 e0 	. 6 ! . 
	ld (ix+040h),022h		;8b7d	dd 36 40 22 	. 6 @ " 
	ld (ix+041h),088h		;8b81	dd 36 41 88 	. 6 A . 
	ld (ix+060h),080h		;8b85	dd 36 60 80 	. 6 ` . 
	ld (ix+061h),002h		;8b89	dd 36 61 02 	. 6 a . 
	ret			;8b8d	c9 	. 
sub_8b8eh:
	ld ix,l8647h		;8b8e	dd 21 47 86 	. ! G . 
	ld b,003h		;8b92	06 03 	. . 
l8b94h:
	push bc			;8b94	c5 	. 
	ld a,(ix+000h)		;8b95	dd 7e 00 	. ~ . 
	cp 000h		;8b98	fe 00 	. . 
	jr z,l8bb1h		;8b9a	28 15 	( . 
	dec (ix+000h)		;8b9c	dd 35 00 	. 5 . 
	ld h,(ix+002h)		;8b9f	dd 66 02 	. f . 
	ld l,(ix+001h)		;8ba2	dd 6e 01 	. n . 
	dec hl			;8ba5	2b 	+ 
	ld (ix+001h),l		;8ba6	dd 75 01 	. u . 
	ld (ix+002h),h		;8ba9	dd 74 02 	. t . 
	call sub_8bc0h		;8bac	cd c0 8b 	. . . 
	jr l8bb7h		;8baf	18 06 	. . 
l8bb1h:
	ld bc,15			; bc - delay time 										;8bb1	01 0f 00 	. . . 
	call DELAY_BC		; wait short delay 										;8bb4	cd 79 86 	. y . 
l8bb7h:
	pop bc			;8bb7	c1 	. 
	ld de,00003h		;8bb8	11 03 00 	. . . 
	add ix,de		;8bbb	dd 19 	. . 
	djnz l8b94h		;8bbd	10 d5 	. . 
	ret			;8bbf	c9 	. 
sub_8bc0h:
	push hl			;8bc0	e5 	. 
	pop iy		;8bc1	fd e1 	. . 
	ld (iy+000h),0c5h		;8bc3	fd 36 00 c5 	. 6 . . 
	ld (iy+001h),053h		;8bc7	fd 36 01 53 	. 6 . S 
	ld (iy+040h),0aah		;8bcb	fd 36 40 aa 	. 6 @ . 
	ld (iy+041h),0aah		;8bcf	fd 36 41 aa 	. 6 A . 
	ld (iy+060h),0c3h		;8bd3	fd 36 60 c3 	. 6 ` . 
	ld (iy+061h),0c3h		;8bd7	fd 36 61 c3 	. 6 a . 
	ld (iy+020h),0cch		;8bdb	fd 36 20 cc 	. 6   . 
	ld (iy+021h),033h		;8bdf	fd 36 21 33 	. 6 ! 3 
	ld a,(l85bch)		;8be3	3a bc 85 	: . . 
	cp 008h		;8be6	fe 08 	. . 
	ret c			;8be8	d8 	. 
	ld (iy+020h),0ceh		;8be9	fd 36 20 ce 	. 6   . 
	ld (iy+021h),0b3h		;8bed	fd 36 21 b3 	. 6 ! . 
	ret			;8bf1	c9 	. 
sub_8bf2h:
	ld ix,l8603h		;8bf2	dd 21 03 86 	. ! . . 
	ld b,006h		;8bf6	06 06 	. . 
l8bf8h:
	push bc			;8bf8	c5 	. 
	ld a,(ix+000h)		;8bf9	dd 7e 00 	. ~ . 
	cp 000h		;8bfc	fe 00 	. . 
	jr z,l8c32h		;8bfe	28 32 	( 2 
	dec (ix+000h)		;8c00	dd 35 00 	. 5 . 
	ld h,(ix+002h)		;8c03	dd 66 02 	. f . 
	ld l,(ix+001h)		;8c06	dd 6e 01 	. n . 
	dec hl			;8c09	2b 	+ 
	ld (ix+001h),l		;8c0a	dd 75 01 	. u . 
	ld (ix+002h),h		;8c0d	dd 74 02 	. t . 
	ld de,00080h		;8c10	11 80 00 	. . . 
	or a			;8c13	b7 	. 
	sbc hl,de		;8c14	ed 52 	. R 
	ld (hl),030h		;8c16	36 30 	6 0 
	ld de,00020h		;8c18	11 20 00 	.   . 
	add hl,de			;8c1b	19 	. 
	ld (hl),020h		;8c1c	36 20 	6   
	add hl,de			;8c1e	19 	. 
	ld (hl),020h		;8c1f	36 20 	6   
	add hl,de			;8c21	19 	. 
	ld (hl),0a8h		;8c22	36 a8 	6 . 
	add hl,de			;8c24	19 	. 
	ld (hl),098h		;8c25	36 98 	6 . 
	add hl,de			;8c27	19 	. 
	ld (hl),098h		;8c28	36 98 	6 . 
	add hl,de			;8c2a	19 	. 
	ld (hl),088h		;8c2b	36 88 	6 . 
	add hl,de			;8c2d	19 	. 
	ld (hl),088h		;8c2e	36 88 	6 . 
	jr l8c38h		;8c30	18 06 	. . 
l8c32h:
	ld bc,12			; bc - delay time										;8c32	01 0c 00 	. . . 
	call DELAY_BC		; wait short delay										;8c35	cd 79 86 	. y . 
l8c38h:
	pop bc			;8c38	c1 	. 
	ld de,00004h		;8c39	11 04 00 	. . . 
	add ix,de		;8c3c	dd 19 	. . 
	djnz l8bf8h		;8c3e	10 b8 	. . 
	ret			;8c40	c9 	. 
sub_8c41h:
	ld ix,l8603h		;8c41	dd 21 03 86 	. ! . . 
	ld b,006h		;8c45	06 06 	. . 
l8c47h:
	push bc			;8c47	c5 	. 
	ld a,(ix+000h)		;8c48	dd 7e 00 	. ~ . 
	cp 000h		;8c4b	fe 00 	. . 
	jr z,l8c80h		;8c4d	28 31 	( 1 
	ld a,(ix+000h)		;8c4f	dd 7e 00 	. ~ . 
	cp (ix+003h)		;8c52	dd be 03 	. . . 
	jr nc,l8c69h		;8c55	30 12 	0 . 
	ld h,(ix+002h)		;8c57	dd 66 02 	. f . 
	ld l,(ix+001h)		;8c5a	dd 6e 01 	. n . 
	ld de,00040h		;8c5d	11 40 00 	. @ . 
	or a			;8c60	b7 	. 
	sbc hl,de		;8c61	ed 52 	. R 
	ld (ix+001h),l		;8c63	dd 75 01 	. u . 
	ld (ix+002h),h		;8c66	dd 74 02 	. t . 
l8c69h:
	ld h,(ix+002h)		;8c69	dd 66 02 	. f . 
	ld l,(ix+001h)		;8c6c	dd 6e 01 	. n . 
	ld de,00081h		;8c6f	11 81 00 	. . . 
	or a			;8c72	b7 	. 
	sbc hl,de		;8c73	ed 52 	. R 
	ld a,(hl)			;8c75	7e 	~ 
	cp 000h		;8c76	fe 00 	. . 
	jr z,l8c86h		;8c78	28 0c 	( . 
	ld (ix+000h),000h		;8c7a	dd 36 00 00 	. 6 . . 
	jr l8c86h		;8c7e	18 06 	. . 
l8c80h:
	ld bc,14			; bc - delay time										;8c80	01 0e 00 	. . . 
	call DELAY_BC		; wait short delay										;8c83	cd 79 86 	. y . 
l8c86h:
	pop bc			;8c86	c1 	. 
	ld de,00004h		;8c87	11 04 00 	. . . 
	add ix,de		;8c8a	dd 19 	. . 
	djnz l8c47h		;8c8c	10 b9 	. . 
	ret			;8c8e	c9 	. 
sub_8c8fh:
	ld a,(l85b4h)		;8c8f	3a b4 85 	: . . 
	cp 003h		;8c92	fe 03 	. . 
	ret nz			;8c94	c0 	. 
	ld ix,l85e7h		;8c95	dd 21 e7 85 	. ! . . 
	ld b,006h		;8c99	06 06 	. . 
l8c9bh:
	push bc			;8c9b	c5 	. 
	ld a,(ix+000h)		;8c9c	dd 7e 00 	. ~ . 
	cp 000h		;8c9f	fe 00 	. . 
	jr z,l8cc4h		;8ca1	28 21 	( ! 
	dec (ix+000h)		;8ca3	dd 35 00 	. 5 . 
	ld h,(ix+002h)		;8ca6	dd 66 02 	. f . 
	ld l,(ix+001h)		;8ca9	dd 6e 01 	. n . 
	dec hl			;8cac	2b 	+ 
	ld (ix+001h),l		;8cad	dd 75 01 	. u . 
	ld (ix+002h),h		;8cb0	dd 74 02 	. t . 
	ld (hl),030h		;8cb3	36 30 	6 0 
	ld de,00020h		;8cb5	11 20 00 	.   . 
	add hl,de			;8cb8	19 	. 
	call sub_8cf0h		;8cb9	cd f0 8c 	. . . 
	ld (hl),a			;8cbc	77 	w 
	add hl,de			;8cbd	19 	. 
	ld (hl),a			;8cbe	77 	w 
	add hl,de			;8cbf	19 	. 
	ld (hl),030h		;8cc0	36 30 	6 0 
	jr l8ce7h		;8cc2	18 23 	. # 
l8cc4h:
	ld a,078h		;8cc4	3e 78 	> x 
	call sub_8ac9h		;8cc6	cd c9 8a 	. . . 
	cp 064h		;8cc9	fe 64 	. d 
	jr c,l8ce7h		;8ccb	38 1a 	8 . 
	ld (ix+000h),01dh		;8ccd	dd 36 00 1d 	. 6 . . 
	ld a,01ch		;8cd1	3e 1c 	> . 
	call sub_8ac9h		;8cd3	cd c9 8a 	. . . 
	inc a			;8cd6	3c 	< 
	ld de,00020h		;8cd7	11 20 00 	.   . 
	ld hl,071beh		;8cda	21 be 71 	! . q 
	ld b,a			;8cdd	47 	G 
l8cdeh:
	add hl,de			;8cde	19 	. 
	djnz l8cdeh		;8cdf	10 fd 	. . 
	ld (ix+001h),l		;8ce1	dd 75 01 	. u . 
	ld (ix+002h),h		;8ce4	dd 74 02 	. t . 
l8ce7h:
	pop bc			;8ce7	c1 	. 
	ld de,00003h		;8ce8	11 03 00 	. . . 
	add ix,de		;8ceb	dd 19 	. . 
	djnz l8c9bh		;8ced	10 ac 	. . 
	ret			;8cef	c9 	. 
sub_8cf0h:
	ld iy,(l85bdh)		;8cf0	fd 2a bd 85 	. * . . 
	ld a,(iy+000h)		;8cf4	fd 7e 00 	. ~ . 
	cp 0ffh		;8cf7	fe ff 	. . 
	call z,sub_8d07h		;8cf9	cc 07 8d 	. . . 
	inc iy		;8cfc	fd 23 	. # 
	ld (l85bdh),iy		;8cfe	fd 22 bd 85 	. " . . 
l8d02h:
	ret			;8d02	c9 	. 
	ret p			;8d03	f0 	. 
	call m,0fff3h		;8d04	fc f3 ff 	. . . 
sub_8d07h:
	ld iy,l8d02h		;8d07	fd 21 02 8d 	. ! . . 
	ret			;8d0b	c9 	. 
sub_8d0ch:
	ld hl,l85a8h		;8d0c	21 a8 85 	! . . 
	inc (hl)			;8d0f	34 	4 
	ld a,(hl)			;8d10	7e 	~ 
	cp 005h		;8d11	fe 05 	. . 
	ret c			;8d13	d8 	. 
	ld (hl),000h		;8d14	36 00 	6 . 
	ld hl,(l85b5h)		;8d16	2a b5 85 	* . . 
	inc hl			;8d19	23 	# 
	ld (l85b5h),hl		;8d1a	22 b5 85 	" . . 
	ld a,(l85b9h)		;8d1d	3a b9 85 	: . . 
	cp 006h		;8d20	fe 06 	. . 
	call c,sub_8d2eh		;8d22	dc 2e 8d 	. . . 
	cp 001h		;8d25	fe 01 	. . 
	ret c			;8d27	d8 	. 
	dec a			;8d28	3d 	= 
	ld (l85b9h),a		;8d29	32 b9 85 	2 . . 
	ret			;8d2c	c9 	. 
	ret			;8d2d	c9 	. 
sub_8d2eh:
	ld b,0ffh		;8d2e	06 ff 	. . 
	ld hl,IOLATCH		;8d30	21 00 68 	! . h 
l8d33h:
	ld (hl),009h		;8d33	36 09 	6 . 
	push bc			;8d35	c5 	. 
	ld b,040h		;8d36	06 40 	. @ 
l8d38h:
	djnz l8d38h		;8d38	10 fe 	. . 
	pop bc			;8d3a	c1 	. 
	ld (hl),028h		;8d3b	36 28 	6 ( 
	djnz l8d33h		;8d3d	10 f4 	. . 
	ret			;8d3f	c9 	. 
l8d40h:
	ld a,(l85b2h)		;8d40	3a b2 85 	: . . 
	inc a			;8d43	3c 	< 
	ld (l85b2h),a		;8d44	32 b2 85 	2 . . 
	cp 002h		;8d47	fe 02 	. . 
	ret c			;8d49	d8 	. 
	xor a			;8d4a	af 	. 
	ld (l85b2h),a		;8d4b	32 b2 85 	2 . . 
	ld ix,l85bfh		;8d4e	dd 21 bf 85 	. ! . . 
	ld b,004h		;8d52	06 04 	. . 
l8d54h:
	ld a,(ix+000h)		;8d54	dd 7e 00 	. ~ . 
	cp 000h		;8d57	fe 00 	. . 
	jr nz,l8d79h		;8d59	20 1e 	  . 
	ld (ix+000h),001h		;8d5b	dd 36 00 01 	. 6 . . 
	ld a,(l85aeh+2)		;8d5f	3a b0 85 	: . . 
	add a,003h		;8d62	c6 03 	. . 
	ld (ix+001h),a		;8d64	dd 77 01 	. w . 
	ld hl,(l85ach)		;8d67	2a ac 85 	* . . 
	ld de,00063h		;8d6a	11 63 00 	. c . 
	add hl,de			;8d6d	19 	. 
	ld (ix+003h),h		;8d6e	dd 74 03 	. t . 
	ld (ix+002h),l		;8d71	dd 75 02 	. u . 
	call sub_8dadh		;8d74	cd ad 8d 	. . . 
	jr l8d80h		;8d77	18 07 	. . 
l8d79h:
	ld de,00004h		;8d79	11 04 00 	. . . 
	add ix,de		;8d7c	dd 19 	. . 
	djnz l8d54h		;8d7e	10 d4 	. . 
l8d80h:
	ld ix,l85d3h		;8d80	dd 21 d3 85 	. ! . . 
	ld b,002h		;8d84	06 02 	. . 
l8d86h:
	ld a,(ix+000h)		;8d86	dd 7e 00 	. ~ . 
	cp 000h		;8d89	fe 00 	. . 
	jr nz,l8da5h		;8d8b	20 18 	  . 
	ld (ix+000h),001h		;8d8d	dd 36 00 01 	. 6 . . 
	ld a,(l85aeh+2)		;8d91	3a b0 85 	: . . 
	ld (ix+001h),a		;8d94	dd 77 01 	. w . 
	ld hl,(l85ach)		;8d97	2a ac 85 	* . . 
	ld de,000a3h		;8d9a	11 a3 00 	. . . 
	add hl,de			;8d9d	19 	. 
	ld (ix+003h),h		;8d9e	dd 74 03 	. t . 
	ld (ix+002h),l		;8da1	dd 75 02 	. u . 
	ret			;8da4	c9 	. 
l8da5h:
	ld de,00004h		;8da5	11 04 00 	. . . 
	add ix,de		;8da8	dd 19 	. . 
	djnz l8d86h		;8daa	10 da 	. . 
	ret			;8dac	c9 	. 
sub_8dadh:
	push bc			;8dad	c5 	. 
	ld b,0dch		;8dae	06 dc 	. . 
	ld hl,IOLATCH		;8db0	21 00 68 	! . h 
l8db3h:
	ld (hl),009h		;8db3	36 09 	6 . 
	push bc			;8db5	c5 	. 
	ld b,064h		;8db6	06 64 	. d 
l8db8h:
	djnz l8db8h		;8db8	10 fe 	. . 
	pop bc			;8dba	c1 	. 
	ld (hl),028h		;8dbb	36 28 	6 ( 
	djnz l8db3h		;8dbd	10 f4 	. . 
	call sub_8d2eh		;8dbf	cd 2e 8d 	. . . 
	pop bc			;8dc2	c1 	. 
	ret			;8dc3	c9 	. 
sub_8dc4h:
	push bc			;8dc4	c5 	. 
	call sub_8d2eh		;8dc5	cd 2e 8d 	. . . 
	call sub_8d2eh		;8dc8	cd 2e 8d 	. . . 
	pop bc			;8dcb	c1 	. 
	ret			;8dcc	c9 	. 
sub_8dcdh:
	ld ix,l85bfh		;8dcd	dd 21 bf 85 	. ! . . 
	ld b,004h		;8dd1	06 04 	. . 
l8dd3h:
	push bc			;8dd3	c5 	. 
	ld a,(ix+000h)		;8dd4	dd 7e 00 	. ~ . 
	cp 000h		;8dd7	fe 00 	. . 
	jr z,l8df4h		;8dd9	28 19 	( . 
	inc (ix+001h)		;8ddb	dd 34 01 	. 4 . 
	ld a,(ix+001h)		;8dde	dd 7e 01 	. ~ . 
	cp 01fh		;8de1	fe 1f 	. . 
	jr nc,l8e03h		;8de3	30 1e 	0 . 
	ld h,(ix+003h)		;8de5	dd 66 03 	. f . 
	call sub_8e15h		;8de8	cd 15 8e 	. . . 
	ld a,(hl)			;8deb	7e 	~ 
	cp 000h		;8dec	fe 00 	. . 
	jr nz,l8e09h		;8dee	20 19 	  . 
	ld (hl),033h		;8df0	36 33 	6 3 
	jr l8dfah		;8df2	18 06 	. . 
l8df4h:
	ld bc,20			; bc - delay time										;8df4	01 14 00 	. . . 
	call DELAY_BC		; wait short delay										;8df7	cd 79 86 	. y . 
l8dfah:
	pop bc			;8dfa	c1 	. 
	ld de,00004h		;8dfb	11 04 00 	. . . 
	add ix,de		;8dfe	dd 19 	. . 
	djnz l8dd3h		;8e00	10 d1 	. . 
	ret			;8e02	c9 	. 
l8e03h:
	ld (ix+000h),000h		;8e03	dd 36 00 00 	. 6 . . 
	jr l8dfah		;8e07	18 f1 	. . 
l8e09h:
	ld (hl),0ffh		;8e09	36 ff 	6 . 
	call sub_8e7bh		;8e0b	cd 7b 8e 	. { . 
	call sub_8eb3h		;8e0e	cd b3 8e 	. . . 
	jr l8e03h		;8e11	18 f0 	. . 
	ret			;8e13	c9 	. 
	ret			;8e14	c9 	. 
sub_8e15h:
	ld l,(ix+002h)		;8e15	dd 6e 02 	. n . 
	inc hl			;8e18	23 	# 
	ld (ix+003h),h		;8e19	dd 74 03 	. t . 
	ld (ix+002h),l		;8e1c	dd 75 02 	. u . 
	ret			;8e1f	c9 	. 
sub_8e20h:
	jp z,l8d40h		;8e20	ca 40 8d 	. @ . 
	ld bc,6000		; bc - delay time											;8e23	01 70 17 	. p . 
	jp DELAY_BC		; wait long delay											;8e26	c3 79 86 	. y . 
sub_8e29h:
	ld ix,l85d3h		;8e29	dd 21 d3 85 	. ! . . 
	ld b,002h		;8e2d	06 02 	. . 
l8e2fh:
	push bc			;8e2f	c5 	. 
	ld a,(ix+000h)		;8e30	dd 7e 00 	. ~ . 
	cp 000h		;8e33	fe 00 	. . 
	jr z,l8e5ch		;8e35	28 25 	( % 
	dec (ix+001h)		;8e37	dd 35 01 	. 5 . 
	ld a,(ix+001h)		;8e3a	dd 7e 01 	. ~ . 
	cp 001h		;8e3d	fe 01 	. . 
	jr c,l8e6bh		;8e3f	38 2a 	8 * 
	ld de,00040h		;8e41	11 40 00 	. @ . 
	ld h,(ix+003h)		;8e44	dd 66 03 	. f . 
	ld l,(ix+002h)		;8e47	dd 6e 02 	. n . 
	ld (hl),000h		;8e4a	36 00 	6 . 
	add hl,de			;8e4c	19 	. 
	ld (ix+003h),h		;8e4d	dd 74 03 	. t . 
	ld (ix+002h),l		;8e50	dd 75 02 	. u . 
	ld a,(hl)			;8e53	7e 	~ 
	cp 000h		;8e54	fe 00 	. . 
	jr nz,l8e71h		;8e56	20 19 	  . 
	ld (hl),0ffh		;8e58	36 ff 	6 . 
	jr l8e62h		;8e5a	18 06 	. . 
l8e5ch:
	ld bc,15			; bc - delay time										;8e5c	01 0f 00 	. . . 
	call DELAY_BC		; wait short delay										;8e5f	cd 79 86 	. y . 
l8e62h:
	pop bc			;8e62	c1 	. 
	ld de,00004h		;8e63	11 04 00 	. . . 
	add ix,de		;8e66	dd 19 	. . 
	djnz l8e2fh		;8e68	10 c5 	. . 
	ret			;8e6a	c9 	. 
l8e6bh:
	ld (ix+000h),000h		;8e6b	dd 36 00 00 	. 6 . . 
	jr l8e62h		;8e6f	18 f1 	. . 
l8e71h:
	ld (hl),0ffh		;8e71	36 ff 	6 . 
	call sub_8e7bh		;8e73	cd 7b 8e 	. { . 
	call sub_8eb3h		;8e76	cd b3 8e 	. . . 
	jr l8e6bh		;8e79	18 f0 	. . 
sub_8e7bh:
	ld a,004h		;8e7b	3e 04 	> . 
	ld (l8e84h),a		;8e7d	32 84 8e 	2 . . 
	ld (l8e85h),hl		;8e80	22 85 8e 	" . . 
	ret			;8e83	c9 	. 
l8e84h:
	nop			;8e84	00 	. 
l8e85h:
	nop			;8e85	00 	. 
	nop			;8e86	00 	. 
sub_8e87h:
	ld a,(l8e84h)		;8e87	3a 84 8e 	: . . 
	cp 000h		;8e8a	fe 00 	. . 
	ret z			;8e8c	c8 	. 
	dec a			;8e8d	3d 	= 
	ld (l8e84h),a		;8e8e	32 84 8e 	2 . . 
	ld hl,(l8e85h)		;8e91	2a 85 8e 	* . . 
	dec hl			;8e94	2b 	+ 
	ld (l8e85h),hl		;8e95	22 85 8e 	" . . 
	ld b,004h		;8e98	06 04 	. . 
l8e9ah:
	push bc			;8e9a	c5 	. 
	push hl			;8e9b	e5 	. 
	ld b,003h		;8e9c	06 03 	. . 
l8e9eh:
	push bc			;8e9e	c5 	. 
	ld a,r		;8e9f	ed 5f 	. _ 
	ld e,a			;8ea1	5f 	_ 
	ld a,r		;8ea2	ed 5f 	. _ 
	add a,e			;8ea4	83 	. 
	ld (hl),a			;8ea5	77 	w 
	inc hl			;8ea6	23 	# 
	pop bc			;8ea7	c1 	. 
	djnz l8e9eh		;8ea8	10 f4 	. . 
	pop hl			;8eaa	e1 	. 
	ld de,00020h		;8eab	11 20 00 	.   . 
	add hl,de			;8eae	19 	. 
	pop bc			;8eaf	c1 	. 
	djnz l8e9ah		;8eb0	10 e8 	. . 
	ret			;8eb2	c9 	. 
sub_8eb3h:
	ld iy,l8647h		;8eb3	fd 21 47 86 	. ! G . 
	ld b,003h		;8eb7	06 03 	. . 
l8eb9h:
	ld a,(iy+000h)		;8eb9	fd 7e 00 	. ~ . 
	cp 000h		;8ebc	fe 00 	. . 
	jr z,l8ecch		;8ebe	28 0c 	( . 
	ld h,(iy+002h)		;8ec0	fd 66 02 	. f . 
	ld l,(iy+001h)		;8ec3	fd 6e 01 	. n . 
	call sub_8fc8h		;8ec6	cd c8 8f 	. . . 
	jp nz,l8f2fh		;8ec9	c2 2f 8f 	. / . 
l8ecch:
	ld de,00003h		;8ecc	11 03 00 	. . . 
	add iy,de		;8ecf	fd 19 	. . 
	djnz l8eb9h		;8ed1	10 e6 	. . 
	ld iy,l8603h		;8ed3	fd 21 03 86 	. ! . . 
	ld b,006h		;8ed7	06 06 	. . 
l8ed9h:
	ld a,(iy+000h)		;8ed9	fd 7e 00 	. ~ . 
	cp 000h		;8edc	fe 00 	. . 
	jr z,l8eebh		;8ede	28 0b 	( . 
	ld h,(iy+002h)		;8ee0	fd 66 02 	. f . 
	ld l,(iy+001h)		;8ee3	fd 6e 01 	. n . 
	call sub_8fe2h		;8ee6	cd e2 8f 	. . . 
	jr nz,l8f47h		;8ee9	20 5c 	  \ 
l8eebh:
	ld de,00004h		;8eeb	11 04 00 	. . . 
	add iy,de		;8eee	fd 19 	. . 
	djnz l8ed9h		;8ef0	10 e7 	. . 
	ld iy,l8621h		;8ef2	fd 21 21 86 	. ! ! . 
	ld b,009h		;8ef6	06 09 	. . 
l8ef8h:
	ld a,(iy+000h)		;8ef8	fd 7e 00 	. ~ . 
	cp 000h		;8efb	fe 00 	. . 
	jr z,l8f0ah		;8efd	28 0b 	( . 
	ld h,(iy+002h)		;8eff	fd 66 02 	. f . 
	ld l,(iy+001h)		;8f02	fd 6e 01 	. n . 
	call sub_8fc8h		;8f05	cd c8 8f 	. . . 
	jr nz,l8f56h		;8f08	20 4c 	  L 
l8f0ah:
	ld de,00003h		;8f0a	11 03 00 	. . . 
	add iy,de		;8f0d	fd 19 	. . 
	djnz l8ef8h		;8f0f	10 e7 	. . 
	ld a,(l8600h)		;8f11	3a 00 86 	: . . 
	cp 000h		;8f14	fe 00 	. . 
	jr z,l8f26h		;8f16	28 0e 	( . 
	ld hl,(l8601h)		;8f18	2a 01 86 	* . . 
	ld de,00080h		;8f1b	11 80 00 	. . . 
	or a			;8f1e	b7 	. 
	sbc hl,de		;8f1f	ed 52 	. R 
	call sub_8fc8h		;8f21	cd c8 8f 	. . . 
	jr nz,l8f75h		;8f24	20 4f 	  O 
l8f26h:
	ld a,(l85b4h)		;8f26	3a b4 85 	: . . 
	cp 002h		;8f29	fe 02 	. . 
	ret nz			;8f2b	c0 	. 
	jp l8ff9h		;8f2c	c3 f9 8f 	. . . 
l8f2fh:
	ld a,064h		;8f2f	3e 64 	> d 
	call sub_8ac9h		;8f31	cd c9 8a 	. . . 
	ld e,a			;8f34	5f 	_ 
	ld a,032h		;8f35	3e 32 	> 2 
	add a,e			;8f37	83 	. 
	ld d,000h		;8f38	16 00 	. . 
	ld e,a			;8f3a	5f 	_ 
	ld hl,(l85b5h)		;8f3b	2a b5 85 	* . . 
	add hl,de			;8f3e	19 	. 
	ld (l85b5h),hl		;8f3f	22 b5 85 	" . . 
	ld (iy+000h),000h		;8f42	fd 36 00 00 	. 6 . . 
	ret			;8f46	c9 	. 
l8f47h:
	ld de,00019h		;8f47	11 19 00 	. . . 
	ld hl,(l85b5h)		;8f4a	2a b5 85 	* . . 
	add hl,de			;8f4d	19 	. 
	ld (l85b5h),hl		;8f4e	22 b5 85 	" . . 
	ld (iy+000h),000h		;8f51	fd 36 00 00 	. 6 . . 
	ret			;8f55	c9 	. 
l8f56h:
	ld (iy+000h),000h		;8f56	fd 36 00 00 	. 6 . . 
	ld de,0000ah		;8f5a	11 0a 00 	. . . 
	ld hl,(l85b5h)		;8f5d	2a b5 85 	* . . 
	add hl,de			;8f60	19 	. 
	ld (l85b5h),hl		;8f61	22 b5 85 	" . . 
	ld a,(l85b9h)		;8f64	3a b9 85 	: . . 
	add a,00bh		;8f67	c6 0b 	. . 
	ld (l85b9h),a		;8f69	32 b9 85 	2 . . 
	cp 014h		;8f6c	fe 14 	. . 
	ret c			;8f6e	d8 	. 
	ld a,014h		;8f6f	3e 14 	> . 
	ld (l85b9h),a		;8f71	32 b9 85 	2 . . 
	ret			;8f74	c9 	. 
l8f75h:
	xor a			;8f75	af 	. 
	ld (l8600h),a		;8f76	32 00 86 	2 . . 
	ld hl,(l85b5h)		;8f79	2a b5 85 	* . . 
	ld de,003e8h		;8f7c	11 e8 03 	. . . 
	add hl,de			;8f7f	19 	. 
	ld (l85b5h),hl		;8f80	22 b5 85 	" . . 
	call sub_865dh		;8f83	cd 5d 86 	. ] . 

	xor a				; a - Gfx Mode 0, Sound Off								;8f86	af 	. 
	ld (IOLATCH),a		; reset Gfx Mode 0										;8f87	32 00 68 	2 . h 
	ld hl,TXT_WAVECOMPLETE	; hl - "* WAVE COMPLETE! *" text 					;8f8a	21 b5 8f 	! . . 
	ld de,VRAM+(8*32)+7 ; screen coord (7,8)char [$7107]						;8f8d	11 07 71 	. . q 
	call PRINT_TEXT		; print text on Screen 									;8f90	cd 7f 86 	.  . 
	ld bc,0				; bc - delay time (65536)								;8f93	01 00 00 	. . . 
	call DELAY_BC		; wait very long delay									;8f96	cd 79 86 	. y . 
	ld a,001h		;8f99	3e 01 	> . 
	ld (l85b4h),a		;8f9b	32 b4 85 	2 . . 
	call sub_8725h		;8f9e	cd 25 87 	. % . 
	ld a,(l85b3h)		;8fa1	3a b3 85 	: . . 
	inc a			;8fa4	3c 	< 
	ld (l85b3h),a		;8fa5	32 b3 85 	2 . . 
	cp 006h		;8fa8	fe 06 	. . 
	jp c,l90aah		;8faa	da aa 90 	. . . 
	ld a,006h		;8fad	3e 06 	> . 
	ld (l85b3h),a		;8faf	32 b3 85 	2 . . 
	jp l90aah		;8fb2	c3 aa 90 	. . . 

;***************************************************************************************
; 
TXT_WAVECOMPLETE:
	db	"* WAVE COMPLETE! *$"		;8fb5	2a 20 57 41 56 45 20 43 4f 4d 50 4c 45 54 45 21 20 2a 24

sub_8fc8h:
	push bc			;8fc8	c5 	. 
	ld b,004h		;8fc9	06 04 	. . 
	ld a,0ffh		;8fcb	3e ff 	> . 
l8fcdh:
	cp (hl)			;8fcd	be 	. 
	jr z,l8fddh		;8fce	28 0d 	( . 
	inc hl			;8fd0	23 	# 
	cp (hl)			;8fd1	be 	. 
	jr z,l8fddh		;8fd2	28 09 	( . 
	ld de,0001fh		;8fd4	11 1f 00 	. . . 
	add hl,de			;8fd7	19 	. 
	djnz l8fcdh		;8fd8	10 f3 	. . 
	pop bc			;8fda	c1 	. 
	cp a			;8fdb	bf 	. 
	ret			;8fdc	c9 	. 
l8fddh:
	pop bc			;8fdd	c1 	. 
	xor a			;8fde	af 	. 
	cp 001h		;8fdf	fe 01 	. . 
	ret			;8fe1	c9 	. 
sub_8fe2h:
	push bc			;8fe2	c5 	. 
	ld de,00080h		;8fe3	11 80 00 	. . . 
	or a			;8fe6	b7 	. 
	sbc hl,de		;8fe7	ed 52 	. R 
	ld a,0ffh		;8fe9	3e ff 	> . 
	ld b,008h		;8feb	06 08 	. . 
l8fedh:
	cp (hl)			;8fed	be 	. 
	jr z,l8fddh		;8fee	28 ed 	( . 
	ld de,00020h		;8ff0	11 20 00 	.   . 
	add hl,de			;8ff3	19 	. 
	djnz l8fedh		;8ff4	10 f7 	. . 
	pop bc			;8ff6	c1 	. 
	cp a			;8ff7	bf 	. 
	ret			;8ff8	c9 	. 
l8ff9h:
	ret			;8ff9	c9 	. 
sub_8ffah:
	ld hl,(l85ach)		;8ffa	2a ac 85 	* . . 
	xor a			;8ffd	af 	. 
	ld de,00020h		;8ffe	11 20 00 	.   . 
	add hl,de			;9001	19 	. 
	cp (hl)			;9002	be 	. 
	jr nz,l901eh		;9003	20 19 	  . 
	inc de			;9005	13 	. 
	add hl,de			;9006	19 	. 
	cp (hl)			;9007	be 	. 
	jr nz,l901eh		;9008	20 14 	  . 
	inc hl			;900a	23 	# 
	cp (hl)			;900b	be 	. 
	jr nz,l901eh		;900c	20 10 	  . 
	ld de,0001eh		;900e	11 1e 00 	. . . 
	add hl,de			;9011	19 	. 
	cp (hl)			;9012	be 	. 
	jr nz,l901eh		;9013	20 09 	  . 
	inc hl			;9015	23 	# 
	cp (hl)			;9016	be 	. 
	jr nz,l901eh		;9017	20 05 	  . 
	inc hl			;9019	23 	# 
	cp (hl)			;901a	be 	. 
	jr nz,l901eh		;901b	20 01 	  . 
	ret			;901d	c9 	. 
l901eh:
	ld b,064h		;901e	06 64 	. d 
l9020h:
	push bc			;9020	c5 	. 
	ld bc,00800h		;9021	01 00 08 	. . . 
	ld hl,VRAM		;9024	21 00 70 	! . p 
l9027h:
	ld a,r		;9027	ed 5f 	. _ 
	ld (hl),a			;9029	77 	w 
	inc hl			;902a	23 	# 
	dec bc			;902b	0b 	. 
	ld a,b			;902c	78 	x 
	or c			;902d	b1 	. 
	jr nz,l9027h		;902e	20 f7 	  . 
	pop bc			;9030	c1 	. 
	djnz l9020h		;9031	10 ed 	. . 
	ld a,(l85b3h)		;9033	3a b3 85 	: . . 
	dec a			;9036	3d 	= 
	ld (l85b3h),a		;9037	32 b3 85 	2 . . 
	cp 000h		;903a	fe 00 	. . 
	jr z,l9044h		;903c	28 06 	( . 
	call sub_8725h		;903e	cd 25 87 	. % . 
	jp l90aah		;9041	c3 aa 90 	. . . 
l9044h:
	call sub_865dh		;9044	cd 5d 86 	. ] . 

	xor a				; a - Gfx Mode 0, Sound Off								;9047	af 	. 
	ld (IOLATCH),a		; restore Gfx Mode 0									;9048	32 00 68 	2 . h 
	ld hl,TXT_GAMEOVER	; hl - "* GAME-OVER *" text								;904b	21 9a 85 	! . . 
	ld de,VRAM+(4*32)+9 ; screen coord (9,4) char [$7089]						;904e	11 89 70 	. . p 
	call PRINT_TEXT		; print text on Screen 									;9051	cd 7f 86 	.  . 
	ld hl,TXT_YOURSCORE	; hl - "YOUR SCORE WAS" text 							;9054	21 6f 90 	! o . 
	ld de,VRAM+(8*32)+9 ; screen coord (9,8) char [$7109]						;9057	11 09 71 	. . q 
	call PRINT_TEXT		; print text on Screen 									;905a	cd 7f 86 	.  . 
	call sub_907eh		;905d	cd 7e 90 	. ~ . 
	ld bc,0				; bc - delay time (65536)								;9060	01 00 00 	. . . 
	call DELAY_BC		; wait very long delay									;9063	cd 79 86 	. y . 
	call DELAY_BC		; wait very long delay									;9066	cd 79 86 	. y . 
	call DELAY_BC		; wait very long delay									;9069	cd 79 86 	. y . 
	jp MAIN		;906c	c3 9c 86 	. . . 

;***************************************************************************************
; Score Summary
; Text do display on Screen
TXT_YOURSCORE:
	db	"YOUR SCORE WAS$"		;906f	59 4f 55 52 20 53 43 4f 52 45 20 57 41 53 24

sub_907eh:
	ld hl,(l85b5h)		;907e	2a b5 85 	* . . 
	ld iy,0714dh		;9081	fd 21 4d 71 	. ! M q 
	ld ix,l88b2h		;9085	dd 21 b2 88 	. ! . . 
l9089h:
	xor a			;9089	af 	. 
	ld b,(ix+001h)		;908a	dd 46 01 	. F . 
	ld c,(ix+000h)		;908d	dd 4e 00 	. N . 
	or a			;9090	b7 	. 
l9091h:
	sbc hl,bc		;9091	ed 42 	. B 
	jr c,l9098h		;9093	38 03 	8 . 
	inc a			;9095	3c 	< 
	jr l9091h		;9096	18 f9 	. . 
l9098h:
	add hl,bc			;9098	09 	. 
	add a,030h		;9099	c6 30 	. 0 
	ld (iy+000h),a		;909b	fd 77 00 	. w . 
	inc iy		;909e	fd 23 	. # 
	ld a,c			;90a0	79 	y 
	cp 001h		;90a1	fe 01 	. . 
	ret z			;90a3	c8 	. 
	inc ix		;90a4	dd 23 	. # 
	inc ix		;90a6	dd 23 	. # 
	jr l9089h		;90a8	18 df 	. . 
l90aah:
	call 08918h		;90aa	cd 18 89 	. . . 
	call sub_8c8fh		;90ad	cd 8f 8c 	. . . 
	call sub_8690h		;90b0	cd 90 86 	. . . 
	call sub_8c8fh		;90b3	cd 8f 8c 	. . . 
	call sub_8c41h		;90b6	cd 41 8c 	. A . 
	call sub_8bf2h		;90b9	cd f2 8b 	. . . 
	call sub_8b2fh		;90bc	cd 2f 8b 	. / . 
	call sub_8b8eh		;90bf	cd 8e 8b 	. . . 
	call sub_8ad9h		;90c2	cd d9 8a 	. . . 
	call sub_89a8h		;90c5	cd a8 89 	. . . 
l90c8h:
	call sub_897ah		;90c8	cd 7a 89 	. z . 
	call sub_8ffah		;90cb	cd fa 8f 	. . . 
	call sub_87a1h		;90ce	cd a1 87 	. . . 
	call sub_8dcdh		;90d1	cd cd 8d 	. . . 
	call sub_8dcdh		;90d4	cd cd 8d 	. . . 
	call sub_8e29h		;90d7	cd 29 8e 	. ) . 
	call sub_8d0ch		;90da	cd 0c 8d 	. . . 
	call sub_87e3h		;90dd	cd e3 87 	. . . 
	call sub_895ah		;90e0	cd 5a 89 	. Z . 
	call sub_8e87h		;90e3	cd 87 8e 	. . . 
	ld a,(l85b9h)		;90e6	3a b9 85 	: . . 
	cp 000h		;90e9	fe 00 	. . 
	jr nz,l90f7h		;90eb	20 0a 	  . 
	ld hl,(l85ach)		;90ed	2a ac 85 	* . . 
	ld de,00040h		;90f0	11 40 00 	. @ . 
	add hl,de			;90f3	19 	. 
	ld (l85ach),hl		;90f4	22 ac 85 	" . . 
l90f7h:
	ld bc,14000			; bc - delay time										;90f7	01 b0 36 	. . 6 
	call DELAY_BC		; wait long delay										;90fa	cd 79 86 	. y . 
	ld sp,GAME_CPU_STACK		;90fd	31 f0 7e 	1 . ~ 
	jr l90aah		;9100	18 a8 	. . 
	nop			;9102	00 	. 
	nop			;9103	00 	. 
	nop			;9104	00 	. 
	nop			;9105	00 	. 
	sbc a,e			;9106	9b 	. 
	sub d			;9107	92 	. 
	sub d			;9108	92 	. 
	sub d			;9109	92 	. 
	sub d			;910a	92 	. 
	sub d			;910b	92 	. 
	sub d			;910c	92 	. 
	sub d			;910d	92 	. 
	sub d			;910e	92 	. 
	sub d			;910f	92 	. 
	sub d			;9110	92 	. 
	sub d			;9111	92 	. 
	sub d			;9112	92 	. 
	sub d			;9113	92 	. 
	sub d			;9114	92 	. 
	sub d			;9115	92 	. 
	sub d			;9116	92 	. 
	sub d			;9117	92 	. 
	sub d			;9118	92 	. 
	sub d			;9119	92 	. 
	sub d			;911a	92 	. 
	sub d			;911b	92 	. 
	sub d			;911c	92 	. 
	sub d			;911d	92 	. 
	sub d			;911e	92 	. 
	sub d			;911f	92 	. 
	sub d			;9120	92 	. 
	sub d			;9121	92 	. 
	sub d			;9122	92 	. 
	sub d			;9123	92 	. 
	sub d			;9124	92 	. 
	sub d			;9125	92 	. 
	sub d			;9126	92 	. 
	sub d			;9127	92 	. 
	sub d			;9128	92 	. 
	sub d			;9129	92 	. 
	sub d			;912a	92 	. 
	sub d			;912b	92 	. 
	sub d			;912c	92 	. 
	sub d			;912d	92 	. 
	sub d			;912e	92 	. 
	sub d			;912f	92 	. 
	sub d			;9130	92 	. 
	sub d			;9131	92 	. 
	sub d			;9132	92 	. 
	sub d			;9133	92 	. 
	sub d			;9134	92 	. 
	sub d			;9135	92 	. 
	sub d			;9136	92 	. 
	sub d			;9137	92 	. 
	sub d			;9138	92 	. 
	sub d			;9139	92 	. 
	sub d			;913a	92 	. 
	sub d			;913b	92 	. 
	sub d			;913c	92 	. 
	sub d			;913d	92 	. 
	sub d			;913e	92 	. 
	sub d			;913f	92 	. 
	sub d			;9140	92 	. 
	sub d			;9141	92 	. 
	sub d			;9142	92 	. 
	sub d			;9143	92 	. 
	sub d			;9144	92 	. 
	sub d			;9145	92 	. 
	sub d			;9146	92 	. 
	sbc a,d			;9147	9a 	. 
	sub d			;9148	92 	. 
	sub d			;9149	92 	. 
	sub d			;914a	92 	. 
	sub d			;914b	92 	. 
	sub d			;914c	92 	. 
	sub d			;914d	92 	. 
	sub d			;914e	92 	. 
	sub d			;914f	92 	. 
	sub d			;9150	92 	. 
	sub d			;9151	92 	. 
	sub d			;9152	92 	. 
	sub d			;9153	92 	. 
	sub d			;9154	92 	. 
	sub d			;9155	92 	. 
	sub d			;9156	92 	. 
	sub d			;9157	92 	. 
	sub d			;9158	92 	. 
	sub d			;9159	92 	. 
	sub d			;915a	92 	. 
	sub d			;915b	92 	. 
	sub d			;915c	92 	. 
	sub d			;915d	92 	. 
	sub d			;915e	92 	. 
	sub d			;915f	92 	. 
	sub d			;9160	92 	. 
	sub d			;9161	92 	. 
	sub d			;9162	92 	. 
	jp nc,0d292h		;9163	d2 92 d2 	. . . 
	sub d			;9166	92 	. 
	jp nc,0d292h		;9167	d2 92 d2 	. . . 
	sub d			;916a	92 	. 
	jp nc,0d292h		;916b	d2 92 d2 	. . . 
	sub d			;916e	92 	. 
	jp nc,09292h		;916f	d2 92 92 	. . . 
	sub d			;9172	92 	. 
	sub d			;9173	92 	. 
	sub d			;9174	92 	. 
	sub d			;9175	92 	. 
	sub d			;9176	92 	. 
	sub d			;9177	92 	. 
	sub d			;9178	92 	. 
	sub d			;9179	92 	. 
	sub d			;917a	92 	. 
	sub d			;917b	92 	. 
	sub d			;917c	92 	. 
	sub d			;917d	92 	. 
	sub d			;917e	92 	. 
	sub d			;917f	92 	. 
	ei			;9180	fb 	. 
	ld d,d			;9181	52 	R 
	ld d,d			;9182	52 	R 
	ld (de),a			;9183	12 	. 
	ld d,d			;9184	52 	R 
	ld (de),a			;9185	12 	. 
	in a,(012h)		;9186	db 12 	. . 
	ld d,d			;9188	52 	R 
	ld d,d			;9189	52 	R 
	ld d,d			;918a	52 	R 
	ld (de),a			;918b	12 	. 
	ld d,d			;918c	52 	R 
	ld (de),a			;918d	12 	. 
	ld d,d			;918e	52 	R 
	ld (de),a			;918f	12 	. 
	ld d,d			;9190	52 	R 
	ld d,d			;9191	52 	R 
	ld d,d			;9192	52 	R 
	ld d,d			;9193	52 	R 
	ld d,d			;9194	52 	R 
	ld d,d			;9195	52 	R 
	ld d,d			;9196	52 	R 
	ld d,d			;9197	52 	R 
	ld d,d			;9198	52 	R 
	ld d,d			;9199	52 	R 
	ld d,d			;919a	52 	R 
	ld d,d			;919b	52 	R 
	ld d,d			;919c	52 	R 
	ld d,d			;919d	52 	R 
	ld d,d			;919e	52 	R 
	ld d,d			;919f	52 	R 
	ld d,d			;91a0	52 	R 
	ld d,d			;91a1	52 	R 
	ld d,d			;91a2	52 	R 
	ld (de),a			;91a3	12 	. 
	ld d,d			;91a4	52 	R 
	ld (de),a			;91a5	12 	. 
	ld d,d			;91a6	52 	R 
	ld (de),a			;91a7	12 	. 
	ld d,d			;91a8	52 	R 
	ld d,d			;91a9	52 	R 
	ld d,d			;91aa	52 	R 
	ld (de),a			;91ab	12 	. 
	ld d,d			;91ac	52 	R 
	ld (de),a			;91ad	12 	. 
	ld d,d			;91ae	52 	R 
	ld (de),a			;91af	12 	. 
	ld d,d			;91b0	52 	R 
	ld d,d			;91b1	52 	R 
	ld d,d			;91b2	52 	R 
	ld d,d			;91b3	52 	R 
	ld d,d			;91b4	52 	R 
	ld d,d			;91b5	52 	R 
	ld d,d			;91b6	52 	R 
	ld d,d			;91b7	52 	R 
	ld d,d			;91b8	52 	R 
	ld d,d			;91b9	52 	R 
	ld d,d			;91ba	52 	R 
	ld d,d			;91bb	52 	R 
	ld d,d			;91bc	52 	R 
	ld d,d			;91bd	52 	R 
	ld d,d			;91be	52 	R 
	ld d,d			;91bf	52 	R 
	ld d,d			;91c0	52 	R 
	ld d,d			;91c1	52 	R 
	ld d,d			;91c2	52 	R 
	ld (de),a			;91c3	12 	. 
	ld d,d			;91c4	52 	R 
	ld (de),a			;91c5	12 	. 
	ld d,d			;91c6	52 	R 
	ld (de),a			;91c7	12 	. 
	ld d,d			;91c8	52 	R 
	ld d,d			;91c9	52 	R 
	ld d,d			;91ca	52 	R 
	ld (de),a			;91cb	12 	. 
	ld d,d			;91cc	52 	R 
	ld (de),a			;91cd	12 	. 
	ld d,d			;91ce	52 	R 
	ld (de),a			;91cf	12 	. 
	ld d,d			;91d0	52 	R 
	ld d,d			;91d1	52 	R 
	ld d,d			;91d2	52 	R 
	ld d,d			;91d3	52 	R 
	ld d,d			;91d4	52 	R 
	ld d,d			;91d5	52 	R 
	ld d,d			;91d6	52 	R 
	ld d,d			;91d7	52 	R 
	ld d,d			;91d8	52 	R 
	ld d,d			;91d9	52 	R 
	ld d,d			;91da	52 	R 
	ld d,d			;91db	52 	R 
	ld d,d			;91dc	52 	R 
	ld d,d			;91dd	52 	R 
	ld d,d			;91de	52 	R 
	ld d,d			;91df	52 	R 
	ld d,d			;91e0	52 	R 
	ld d,d			;91e1	52 	R 
	ld d,d			;91e2	52 	R 
	ld d,d			;91e3	52 	R 
	ld d,d			;91e4	52 	R 
	ld d,d			;91e5	52 	R 
	ld d,d			;91e6	52 	R 
	ld (de),a			;91e7	12 	. 
	ld d,d			;91e8	52 	R 
	ld d,d			;91e9	52 	R 
	ld d,d			;91ea	52 	R 
	ld d,d			;91eb	52 	R 
	ld d,d			;91ec	52 	R 
	ld d,d			;91ed	52 	R 
	ld d,d			;91ee	52 	R 
	ld (de),a			;91ef	12 	. 
	ld d,d			;91f0	52 	R 
	ld d,d			;91f1	52 	R 
	ld d,d			;91f2	52 	R 
	ld d,d			;91f3	52 	R 
	ld d,d			;91f4	52 	R 
	ld d,d			;91f5	52 	R 
	ld d,d			;91f6	52 	R 
	ld d,d			;91f7	52 	R 
	ld d,d			;91f8	52 	R 
	ld d,d			;91f9	52 	R 
	ld d,d			;91fa	52 	R 
	ld d,d			;91fb	52 	R 
	ld d,d			;91fc	52 	R 
	ld d,d			;91fd	52 	R 
	ld d,d			;91fe	52 	R 
	ld d,d			;91ff	52 	R 
