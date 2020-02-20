;***********************************************************************************************
;
; 	Dawn Patrol 
;   Disect by Casper 18.02.2020
;
;	Verified with SjASMPlus Z80 Cross-Assembler v1.14.3 (https://github.com/z00m128/sjasmplus)
;-----------------------------------------------------------------------------------------------
;***********************************************************************************************

	MACRO	FNAME 	filename
.beg		defb 	filename
			block 	16-$+.beg
			defb	0
	ENDM

; Relative address 7CE8
;***********************************************************************************************
; File Header Block
	defb 	$20,$20,0,0                  		; [0000] Magic
	FNAME	"DAWNPATROL"						; File name
	defb	$F1             					; File Type
    defw    MAIN        						; Destination/Basic Start address

;***********************************************************************************************
; SYSTEM CONSTANTS
IOLATCH         	equ     $6800       		; (WR) Hardware IO Latch, (RD) Keyboard all Keys
VDG_GFX_COLORS_0	equ		%00001000 			; GFX MODE, background Green
VDG_GFX_COLORS_1	equ		%00011000 			; GFX MODE, background Buff
VDG_MODE_CSS_MASK	equ		%00011000  			; mask to keep current Gfx settings
BIT_SPK_MINUS   	equ     00100000b   		; Speake Pin (-)
BIT_SPK_PLUS   		equ     00000001b   		; Speake Pin (+)
SPEAKER_PINS		equ		BIT_SPK_MINUS|BIT_SPK_PLUS
VRAM            	equ     $7000       		; Video RAM GAME_INIT address

;************************************************************************
; Keyboard Map              ADRES   |   D5  D4      D3  D2      D1  D0  |
;-----------------------------------|-----------------------------------|
KEYS_ROW_0  		equ     $68fe   ;   R   Q       E           W   T   |
KEYS_ROW_1  		equ     $68fd   ;   F   A       D   CTRL    S   G   |
KEYS_ROW_2  		equ     $68fb   ;   V   Z       C   SHIFT   X   B   |
KEYS_ROW_4  		equ     $68ef   ;   M   SPACE   ,           .   N   |
KEYS_ROW_6  		equ     $68bf   ;   U   P       I   RETURN  O   Y   |
;-----------------------------------|-----------------------------------|
KEYS_ROW_0F  		equ     $6ffe   ;   R   Q       E           W   T   |
KEYS_ROW_1F  		equ     $6ffd   ;   F   A       D   CTRL    S   G   |
KEYS_ROW_2F  		equ     $6ffb   ;   V   Z       C   SHIFT   X   B   |
KEYS_ROW_4F  		equ     $6fef   ;   M   SPACE   ,           .   N   |
KEYS_ROW_6F  		equ     $6fbf   ;   U   P       I   RETURN  O   Y   |

JOY_PORT_1			equ		$2a		; Joystick 1 Input IO Port address
JOY_PORT_2			equ		$25		; Joystick 1 Input IO Port address

;***********************************************************************************************
; GAME CONSTANTS
JOY_ENABLE			equ		$7800	; 1-joystick enabled, 0-keys only
BASE_SP				equ		$7cf0	; Base Stack Pointer

UP					equ		0		; bit 0 in input bitmask variable
DOWN				equ		1		; bit 1 in input bitmask variable
LEFT				equ		2		; bit 2 in input bitmask variable
RIGHT				equ		3		; bit 3 in input bitmask variable
FIRE				equ		4		; bit 4 in input bitmask variable
ROTATE				equ		5		; bit 5 in input bitmask variable

;***********************************************************************************************
;
;    M A I N   E N T R Y   P O I N T
;
;***********************************************************************************************
	org	$7d00
MAIN	
	jp JMP_GAME_INIT				; jump to GAME_INIT									;7d00	c3 82 8f 


l7d03h:
	jp l7d06h		;7d03	c3 06 7d 	. . } 
l7d06h:
	di			;7d06	f3 	. 
	ld sp,BASE_SP			; reset CPU Stack Pointer to base address			;7d07	31 f0 7c
l7d0ah:
	ld hl,la9c5h		;7d0a	21 c5 a9 	! . . 
	ld de,07801h		;7d0d	11 01 78 	. . x 
	ld bc,00010h		;7d10	01 10 00 	. . . 
	ldir		;7d13	ed b0 	. . 
	ld hl,07812h		;7d15	21 12 78 	! . x 
	ld de,07813h		;7d18	11 13 78 	. . x 
	ld bc,0000ah		;7d1b	01 0a 00 	. . . 
	ld (hl),000h		;7d1e	36 00 	6 . 
	ldir		;7d20	ed b0 	. . 
	ld hl,07817h		;7d22	21 17 78 	! . x 
	ld (hl),004h		;7d25	36 04 	6 . 
	ld a,004h		;7d27	3e 04 	> . 
	ld (07811h),a		;7d29	32 11 78 	2 . x 
	xor a			;7d2c	af 	. 
	ld (0781dh),a		;7d2d	32 1d 78 	2 . x 
l7d30h:
	ld hl,0781eh		;7d30	21 1e 78 	! . x 
	ld de,0781fh		;7d33	11 1f 78 	. . x 
	ld bc,000efh		;7d36	01 ef 00 	. . . 
	ld (hl),000h		;7d39	36 00 	6 . 
	ldir		;7d3b	ed b0 	. . 
	ld hl,0781ah		;7d3d	21 1a 78 	! . x 
	ld a,009h		;7d40	3e 09 	> . 
	ld (hl),a			;7d42	77 	w 
	inc hl			;7d43	23 	# 
	ld (hl),a			;7d44	77 	w 
	inc hl			;7d45	23 	# 
	ld (hl),a			;7d46	77 	w 
	ld hl,0012ch		;7d47	21 2c 01 	! , . 
	ld (07909h),hl		;7d4a	22 09 79 	" . y 
	ld (0790bh),hl		;7d4d	22 0b 79 	" . y 
	ld hl,laa0fh		;7d50	21 0f aa 	! . . 
	ld de,0781fh		;7d53	11 1f 78 	. . x 
	ld bc,00010h		;7d56	01 10 00 	. . . 
	ldir		;7d59	ed b0 	. . 
	ld hl,0ab73h		;7d5b	21 73 ab 	! s . 
	ld (07906h),hl		;7d5e	22 06 79 	" . y 
	ld a,0f2h		;7d61	3e f2 	> . 
	ld (07908h),a		;7d63	32 08 79 	2 . y 
	ld a,001h		;7d66	3e 01 	> . 
	ld (078f9h),a		;7d68	32 f9 78 	2 . x 
	ld (078beh),a		;7d6b	32 be 78 	2 . x 
	ld (078c4h),a		;7d6e	32 c4 78 	2 . x 
	ld (078cah),a		;7d71	32 ca 78 	2 . x 
	ld (078d0h),a		;7d74	32 d0 78 	2 . x 
	ld (078d6h),a		;7d77	32 d6 78 	2 . x 
	ld (07887h),a		;7d7a	32 87 78 	2 . x 
	ld (0788dh),a		;7d7d	32 8d 78 	2 . x 
	ld a,035h		;7d80	3e 35 	> 5 
	ld (07900h),a		;7d82	32 00 79 	2 . y 
	ld a,0f0h		;7d85	3e f0 	> . 
	ld (07905h),a		;7d87	32 05 79 	2 . y 
	xor a			;7d8a	af 	. 
	ld (07901h),a		;7d8b	32 01 79 	2 . y 
	ld hl,0b3d5h		;7d8e	21 d5 b3 	! . . 
	ld (078feh),hl		;7d91	22 fe 78 	" . x 
	ld a,098h		;7d94	3e 98 	> . 
	ld (07902h),a		;7d96	32 02 79 	2 . y 
	xor a			;7d99	af 	. 
	ld (07903h),a		;7d9a	32 03 79 	2 . y 
	ld (07904h),a		;7d9d	32 04 79 	2 . y 
	ld a,096h		;7da0	3e 96 	> . 
	ld (078f7h),a		;7da2	32 f7 78 	2 . x 
	ld (078f8h),a		;7da5	32 f8 78 	2 . x 
	call sub_8ddeh		;7da8	cd de 8d 	. . . 
	ld hl,la9d5h		;7dab	21 d5 a9 	! . . 
	ld de,0789ah		;7dae	11 9a 78 	. . x 
	ld bc,0001ch		;7db1	01 1c 00 	. . . 
	ldir		;7db4	ed b0 	. . 
	ld hl,la9f1h		;7db6	21 f1 a9 	! . . 
	ld de,078d7h		;7db9	11 d7 78 	. . x 
	ld bc,0001eh		;7dbc	01 1e 00 	. . . 
	ldir		;7dbf	ed b0 	. . 
l7dc1h:
	nop			;7dc1	00 	. 
	call sub_7e16h		;7dc2	cd 16 7e 	. . ~ 
	call sub_7e0ch		;7dc5	cd 0c 7e 	. . ~ 
	call sub_7e2ah		;7dc8	cd 2a 7e 	. * ~ 
	call sub_7ef7h		;7dcb	cd f7 7e 	. . ~ 
	call sub_7f4ah		;7dce	cd 4a 7f 	. J  
	call sub_89fch		;7dd1	cd fc 89 	. . . 
	call sub_894eh		;7dd4	cd 4e 89 	. N . 
	call sub_7fc9h		;7dd7	cd c9 7f 	. .  
	call sub_801fh		;7dda	cd 1f 80 	. . . 
	call sub_814dh		;7ddd	cd 4d 81 	. M . 
	call sub_8223h		;7de0	cd 23 82 	. # . 
	call sub_8394h		;7de3	cd 94 83 	. . . 
	call sub_8332h		;7de6	cd 32 83 	. 2 . 
	call sub_83fdh		;7de9	cd fd 83 	. . . 
	call sub_8422h		;7dec	cd 22 84 	. " . 
	call sub_8456h		;7def	cd 56 84 	. V . 
	call sub_85a9h		;7df2	cd a9 85 	. . . 
	call sub_8580h		;7df5	cd 80 85 	. . . 
	call sub_7f37h		;7df8	cd 37 7f 	. 7  
	ld a,(068dfh)		;7dfb	3a df 68 	: . h 
	bit 2,a		;7dfe	cb 57 	. W 
	jr nz,l7dc1h		;7e00	20 bf 	  . 
	ld a,(KEYS_ROW_1)		;7e02	3a fd 68 	: . h 
	bit 2,a		;7e05	cb 57 	. W 
	jp z,l8f7ch		;7e07	ca 7c 8f 	. | . 
	jr l7dc1h		;7e0a	18 b5 	. . 
sub_7e0ch:
	call sub_8f76h		;7e0c	cd 76 8f 	. v . 
	ret z			;7e0f	c8 	. 
	ld a,00ah		;7e10	3e 0a 	> . 
	ld (07b35h),a		;7e12	32 35 7b 	2 5 { 
	ret			;7e15	c9 	. 
sub_7e16h:
	call sub_8f73h		;7e16	cd 73 8f 	. s . 
	ret z			;7e19	c8 	. 
	ld a,001h		;7e1a	3e 01 	> . 
l7e1ch:
	push af			;7e1c	f5 	. 
	call sub_85a3h		;7e1d	cd a3 85 	. . . 
	call sub_85a3h		;7e20	cd a3 85 	. . . 
	call sub_85a3h		;7e23	cd a3 85 	. . . 
	pop af			;7e26	f1 	. 
	jp l8f7fh		;7e27	c3 7f 8f 	.  . 
sub_7e2ah:
	ld hl,0783ch		;7e2a	21 3c 78 	! < x 
	dec (hl)			;7e2d	35 	5 
	ret nz			;7e2e	c0 	. 
	ld (hl),064h		;7e2f	36 64 	6 d 
	ld ix,07801h		;7e31	dd 21 01 78 	. ! . x 
	ld a,004h		;7e35	3e 04 	> . 
l7e37h:
	push af			;7e37	f5 	. 
	call sub_7e72h		;7e38	cd 72 7e 	. r ~ 
	ld bc,00004h		;7e3b	01 04 00 	. . . 
	add ix,bc		;7e3e	dd 09 	. . 
	pop af			;7e40	f1 	. 
	dec a			;7e41	3d 	= 
	jr nz,l7e37h		;7e42	20 f3 	  . 
	ret			;7e44	c9 	. 
sub_7e45h:
	ld a,(ix+002h)		;7e45	dd 7e 02 	. ~ . 
	or a			;7e48	b7 	. 
	jr z,l7e6eh		;7e49	28 23 	( # 
	ld a,(07835h)		;7e4b	3a 35 78 	: 5 x 
	or a			;7e4e	b7 	. 
	ret nz			;7e4f	c0 	. 
	ld a,(07900h)		;7e50	3a 00 79 	: . y 
	cp 035h		;7e53	fe 35 	. 5 
	jr nz,l7e6eh		;7e55	20 17 	  . 
	call sub_83d2h		;7e57	cd d2 83 	. . . 
	ld b,(ix+001h)		;7e5a	dd 46 01 	. F . 
	cp b			;7e5d	b8 	. 
	jr z,l7e6ch		;7e5e	28 0c 	( . 
	inc b			;7e60	04 	. 
	cp b			;7e61	b8 	. 
	jr z,l7e6ch		;7e62	28 08 	( . 
	inc b			;7e64	04 	. 
	cp b			;7e65	b8 	. 
	jr z,l7e6ch		;7e66	28 04 	( . 
	inc b			;7e68	04 	. 
	cp b			;7e69	b8 	. 
	jr nz,l7e6eh		;7e6a	20 02 	  . 
l7e6ch:
	xor a			;7e6c	af 	. 
	ret			;7e6d	c9 	. 
l7e6eh:
	ld a,001h		;7e6e	3e 01 	> . 
	or a			;7e70	b7 	. 
	ret			;7e71	c9 	. 
sub_7e72h:
	bit 0,(ix+003h)		;7e72	dd cb 03 46 	. . . F 
	jr nz,l7e87h		;7e76	20 0f 	  . 
	call sub_7e45h		;7e78	cd 45 7e 	. E ~ 
	ret nz			;7e7b	c0 	. 
	call sub_7eeeh		;7e7c	cd ee 7e 	. . ~ 
	ld (ix+000h),a		;7e7f	dd 77 00 	. w . 
	ld (ix+003h),001h		;7e82	dd 36 03 01 	. 6 . . 
	ret			;7e86	c9 	. 
l7e87h:
	call sub_7e45h		;7e87	cd 45 7e 	. E ~ 
	jr z,l7each		;7e8a	28 20 	(   
	bit 1,(ix+003h)		;7e8c	dd cb 03 4e 	. . . N 
	jr nz,l7e97h		;7e90	20 05 	  . 
	set 1,(ix+003h)		;7e92	dd cb 03 ce 	. . . . 
	ret			;7e96	c9 	. 
l7e97h:
	call sub_7eeeh		;7e97	cd ee 7e 	. . ~ 
	cp (ix+000h)		;7e9a	dd be 00 	. . . 
	jr z,l7ea7h		;7e9d	28 08 	( . 
	res 1,(ix+003h)		;7e9f	dd cb 03 8e 	. . . . 
	inc (ix+000h)		;7ea3	dd 34 00 	. 4 . 
	ret			;7ea6	c9 	. 
l7ea7h:
	ld (ix+003h),000h		;7ea7	dd 36 03 00 	. 6 . . 
	ret			;7eab	c9 	. 
l7each:
	bit 1,(ix+003h)		;7eac	dd cb 03 4e 	. . . N 
	jr z,l7eb7h		;7eb0	28 05 	( . 
	res 1,(ix+003h)		;7eb2	dd cb 03 8e 	. . . . 
	ret			;7eb6	c9 	. 
l7eb7h:
	call sub_83d2h		;7eb7	cd d2 83 	. . . 
	inc a			;7eba	3c 	< 
	inc a			;7ebb	3c 	< 
	cp (ix+000h)		;7ebc	dd be 00 	. . . 
	jr z,l7ec9h		;7ebf	28 08 	( . 
	set 1,(ix+003h)		;7ec1	dd cb 03 ce 	. . . . 
	dec (ix+000h)		;7ec5	dd 35 00 	. 5 . 
	ret			;7ec8	c9 	. 
l7ec9h:
	dec (ix+002h)		;7ec9	dd 35 02 	. 5 . 
	ld (ix+003h),000h		;7ecc	dd 36 03 00 	. 6 . . 
	ld a,(0782fh)		;7ed0	3a 2f 78 	: / x 
	inc a			;7ed3	3c 	< 
	ld (0782fh),a		;7ed4	32 2f 78 	2 / x 
	ld hl,07830h		;7ed7	21 30 78 	! 0 x 
	ld a,(ix+001h)		;7eda	dd 7e 01 	. ~ . 
	cp 01ch		;7edd	fe 1c 	. . 
	jr z,l7eech		;7edf	28 0b 	( . 
	inc hl			;7ee1	23 	# 
	cp 053h		;7ee2	fe 53 	. S 
	jr z,l7eech		;7ee4	28 06 	( . 
	inc hl			;7ee6	23 	# 
	cp 08ah		;7ee7	fe 8a 	. . 
	jr z,l7eech		;7ee9	28 01 	( . 
	inc hl			;7eeb	23 	# 
l7eech:
	inc (hl)			;7eec	34 	4 
	ret			;7eed	c9 	. 
sub_7eeeh:
	ld a,(ix+001h)		;7eee	dd 7e 01 	. ~ . 
	ld b,008h		;7ef1	06 08 	. . 
l7ef3h:
	inc a			;7ef3	3c 	< 
	djnz l7ef3h		;7ef4	10 fd 	. . 
	ret			;7ef6	c9 	. 
sub_7ef7h:
	ld a,(07835h)		;7ef7	3a 35 78 	: 5 x 
	or a			;7efa	b7 	. 
	ret z			;7efb	c8 	. 
	ld hl,07836h		;7efc	21 36 78 	! 6 x 
	dec (hl)			;7eff	35 	5 
	ret nz			;7f00	c0 	. 
	ld (hl),03ch		;7f01	36 3c 	6 < 
	ld a,(07900h)		;7f03	3a 00 79 	: . y 
	cp 035h		;7f06	fe 35 	. 5 
	jr z,l7f10h		;7f08	28 06 	( . 
	call sub_8419h		;7f0a	cd 19 84 	. . . 
	jp l84c1h		;7f0d	c3 c1 84 	. . . 
l7f10h:
	call sub_83d2h		;7f10	cd d2 83 	. . . 
	ld b,a			;7f13	47 	G 
	ld c,006h		;7f14	0e 06 	. . 
	inc b			;7f16	04 	. 
	ld d,080h		;7f17	16 80 	. . 
	call sub_89c3h		;7f19	cd c3 89 	. . . 
	ld hl,07835h		;7f1c	21 35 78 	! 5 x 
	dec (hl)			;7f1f	35 	5 
	ret nz			;7f20	c0 	. 
	ld a,(0782fh)		;7f21	3a 2f 78 	: / x 
	ld hl,0781dh		;7f24	21 1d 78 	! . x 
	add a,(hl)			;7f27	86 	. 
	ld (hl),a			;7f28	77 	w 
	ld a,(07811h)		;7f29	3a 11 78 	: . x 
	dec a			;7f2c	3d 	= 
	ld (07811h),a		;7f2d	32 11 78 	2 . x 
	jp nz,l7d30h		;7f30	c2 30 7d 	. 0 } 
	xor a			;7f33	af 	. 
	jp l7e1ch		;7f34	c3 1c 7e 	. . ~ 
sub_7f37h:
	ld a,(07834h)		;7f37	3a 34 78 	: 4 x 
	dec a			;7f3a	3d 	= 
	ld (07834h),a		;7f3b	32 34 78 	2 4 x 
	ret nz			;7f3e	c0 	. 
	ld a,(0781dh)		;7f3f	3a 1d 78 	: . x 
	cp 050h		;7f42	fe 50 	. P 
	ret nz			;7f44	c0 	. 
	ld a,002h		;7f45	3e 02 	> . 
	jp l7e1ch		;7f47	c3 1c 7e 	. . ~ 
sub_7f4ah:
	ld a,(07838h)		;7f4a	3a 38 78 	: 8 x 
	or a			;7f4d	b7 	. 
	jr z,l7f55h		;7f4e	28 05 	( . 
	dec a			;7f50	3d 	= 
	ld (07838h),a		;7f51	32 38 78 	2 8 x 
	ret			;7f54	c9 	. 
l7f55h:
	call sub_8ef0h		;7f55	cd f0 8e 	. . . 
	bit 4,a		;7f58	cb 67 	. g 
	jr nz,l7f61h		;7f5a	20 05 	  . 
	xor a			;7f5c	af 	. 
	ld (07839h),a		;7f5d	32 39 78 	2 9 x 
	ret			;7f60	c9 	. 
l7f61h:
	ld a,(07839h)		;7f61	3a 39 78 	: 9 x 
	or a			;7f64	b7 	. 
	ret nz			;7f65	c0 	. 
	ld ix,0786ah		;7f66	dd 21 6a 78 	. ! j x 
	ld a,006h		;7f6a	3e 06 	> . 
l7f6ch:
	push af			;7f6c	f5 	. 
	call sub_7f7dh		;7f6d	cd 7d 7f 	. }  
	inc ix		;7f70	dd 23 	. # 
	inc ix		;7f72	dd 23 	. # 
	inc ix		;7f74	dd 23 	. # 
	inc ix		;7f76	dd 23 	. # 
	pop af			;7f78	f1 	. 
	dec a			;7f79	3d 	= 
	jr nz,l7f6ch		;7f7a	20 f0 	  . 
	ret			;7f7c	c9 	. 
sub_7f7dh:
	bit 3,(ix+003h)		;7f7d	dd cb 03 5e 	. . . ^ 
	ret nz			;7f81	c0 	. 
	pop hl			;7f82	e1 	. 
	pop hl			;7f83	e1 	. 
	ld a,(07900h)		;7f84	3a 00 79 	: . y 
	cp 032h		;7f87	fe 32 	. 2 
	ret p			;7f89	f0 	. 
	ld a,014h		;7f8a	3e 14 	> . 
	ld (07838h),a		;7f8c	32 38 78 	2 8 x 
	ld (07839h),a		;7f8f	32 39 78 	2 9 x 
	call sub_83d2h		;7f92	cd d2 83 	. . . 
	dec a			;7f95	3d 	= 
	ld (ix+000h),a		;7f96	dd 77 00 	. w . 
	ld a,(07900h)		;7f99	3a 00 79 	: . y 
	call sub_8093h		;7f9c	cd 93 80 	. . . 
	ld (ix+002h),03ch		;7f9f	dd 36 02 3c 	. 6 . < 
	ld a,(07902h)		;7fa3	3a 02 79 	: . y 
	and 003h		;7fa6	e6 03 	. . 
	or 008h		;7fa8	f6 08 	. . 
	ld (ix+003h),a		;7faa	dd 77 03 	. w . 
	and 003h		;7fad	e6 03 	. . 
	ret z			;7faf	c8 	. 
	cp 001h		;7fb0	fe 01 	. . 
	jr z,l7fc0h		;7fb2	28 0c 	( . 
	ld a,(ix+000h)		;7fb4	dd 7e 00 	. ~ . 
	add a,003h		;7fb7	c6 03 	. . 
	ld (ix+000h),a		;7fb9	dd 77 00 	. w . 
	dec (ix+001h)		;7fbc	dd 35 01 	. 5 . 
	ret			;7fbf	c9 	. 
l7fc0h:
	ld a,(ix+000h)		;7fc0	dd 7e 00 	. ~ . 
	add a,007h		;7fc3	c6 07 	. . 
	ld (ix+000h),a		;7fc5	dd 77 00 	. w . 
	ret			;7fc8	c9 	. 
sub_7fc9h:
	ld hl,0783ah		;7fc9	21 3a 78 	! : x 
	dec (hl)			;7fcc	35 	5 
	ret nz			;7fcd	c0 	. 
	ld (hl),019h		;7fce	36 19 	6 . 
	ld ix,0788eh		;7fd0	dd 21 8e 78 	. ! . x 
	call sub_7fdfh		;7fd4	cd df 7f 	. .  
	ld ix,07894h		;7fd7	dd 21 94 78 	. ! . x 
	call sub_7fdfh		;7fdb	cd df 7f 	. .  
	ret			;7fde	c9 	. 
sub_7fdfh:
	bit 0,(ix+005h)		;7fdf	dd cb 05 46 	. . . F 
	ret z			;7fe3	c8 	. 
	dec (ix+002h)		;7fe4	dd 35 02 	. 5 . 
	jr nz,l7feeh		;7fe7	20 05 	  . 
	ld (ix+005h),000h		;7fe9	dd 36 05 00 	. 6 . . 
	ret			;7fed	c9 	. 
l7feeh:
	bit 0,(ix+004h)		;7fee	dd cb 04 46 	. . . F 
	jr z,l8007h		;7ff2	28 13 	( . 
	bit 0,(ix+003h)		;7ff4	dd cb 03 46 	. . . F 
	jr nz,l7fffh		;7ff8	20 05 	  . 
	set 0,(ix+003h)		;7ffa	dd cb 03 c6 	. . . . 
	ret			;7ffe	c9 	. 
l7fffh:
	res 0,(ix+003h)		;7fff	dd cb 03 86 	. . . . 
	inc (ix+000h)		;8003	dd 34 00 	. 4 . 
	ret			;8006	c9 	. 
l8007h:
	bit 0,(ix+003h)		;8007	dd cb 03 46 	. . . F 
	jr z,l8012h		;800b	28 05 	( . 
	res 0,(ix+003h)		;800d	dd cb 03 86 	. . . . 
	ret			;8011	c9 	. 
l8012h:
	ld a,(ix+000h)		;8012	dd 7e 00 	. ~ . 
	or a			;8015	b7 	. 
	ret z			;8016	c8 	. 
	dec (ix+000h)		;8017	dd 35 00 	. 5 . 
	set 0,(ix+003h)		;801a	dd cb 03 c6 	. . . . 
	ret			;801e	c9 	. 
sub_801fh:
	ld hl,0783dh		;801f	21 3d 78 	! = x 
	dec (hl)			;8022	35 	5 
	ret nz			;8023	c0 	. 
	ld (hl),046h		;8024	36 46 	6 F 
	ld iy,0788eh		;8026	fd 21 8e 78 	. ! . x 
	ld ix,07882h		;802a	dd 21 82 78 	. ! . x 
	call sub_803ch		;802e	cd 3c 80 	. < . 
	ld bc,00006h		;8031	01 06 00 	. . . 
	add ix,bc		;8034	dd 09 	. . 
	add iy,bc		;8036	fd 09 	. . 
	call sub_803ch		;8038	cd 3c 80 	. < . 
	ret			;803b	c9 	. 
sub_803ch:
	ld a,(ix+005h)		;803c	dd 7e 05 	. ~ . 
	bit 7,a		;803f	cb 7f 	.  
	jr nz,l809bh		;8041	20 58 	  X 
	bit 0,(iy+005h)		;8043	fd cb 05 46 	. . . F 
	ret nz			;8047	c0 	. 
	dec a			;8048	3d 	= 
	jr z,l804fh		;8049	28 04 	( . 
	ld (ix+005h),a		;804b	dd 77 05 	. w . 
	ret			;804e	c9 	. 
l804fh:
	ld a,(07900h)		;804f	3a 00 79 	: . y 
	cp 02dh		;8052	fe 2d 	. - 
	ret p			;8054	f0 	. 
	call sub_83d2h		;8055	cd d2 83 	. . . 
	bit 7,a		;8058	cb 7f 	.  
	ret nz			;805a	c0 	. 
	cp 06eh		;805b	fe 6e 	. n 
	ret p			;805d	f0 	. 
	ld b,a			;805e	47 	G 
	ld a,r		;805f	ed 5f 	. _ 
	and 001h		;8061	e6 01 	. . 
	ld c,a			;8063	4f 	O 
	ld a,b			;8064	78 	x 
	sub 010h		;8065	d6 10 	. . 
	bit 0,c		;8067	cb 41 	. A 
	jr nz,l806dh		;8069	20 02 	  . 
	add a,020h		;806b	c6 20 	.   
l806dh:
	ld (ix+000h),a		;806d	dd 77 00 	. w . 
	ld a,c			;8070	79 	y 
	rrca			;8071	0f 	. 
	ld (ix+003h),a		;8072	dd 77 03 	. w . 
	ld (ix+004h),001h		;8075	dd 36 04 01 	. 6 . . 
	ld (ix+002h),034h		;8079	dd 36 02 34 	. 6 . 4 
	ld a,r		;807d	ed 5f 	. _ 
	and 03fh		;807f	e6 3f 	. ? 
	or 08fh		;8081	f6 8f 	. . 
	ld (ix+005h),a		;8083	dd 77 05 	. w . 
	call sub_808ah		;8086	cd 8a 80 	. . . 
	ret			;8089	c9 	. 
sub_808ah:
	ld a,(07900h)		;808a	3a 00 79 	: . y 
	sub 005h		;808d	d6 05 	. . 
	jp p,sub_8093h		;808f	f2 93 80 	. . . 
	xor a			;8092	af 	. 
sub_8093h:
	ld l,a			;8093	6f 	o 
	ld a,035h		;8094	3e 35 	> 5 
	sub l			;8096	95 	. 
	ld (ix+001h),a		;8097	dd 77 01 	. w . 
	ret			;809a	c9 	. 
l809bh:
	call sub_808ah		;809b	cd 8a 80 	. . . 
	cp 00eh		;809e	fe 0e 	. . 
	jp p,l80a7h		;80a0	f2 a7 80 	. . . 
	ld (ix+001h),00eh		;80a3	dd 36 01 0e 	. 6 . . 
l80a7h:
	ld a,(ix+002h)		;80a7	dd 7e 02 	. ~ . 
l80aah:
	dec a			;80aa	3d 	= 
	ld (ix+002h),a		;80ab	dd 77 02 	. w . 
	jr nz,l80b5h		;80ae	20 05 	  . 
	res 7,(ix+005h)		;80b0	dd cb 05 be 	. . . . 
	ret			;80b4	c9 	. 
l80b5h:
	cp 020h		;80b5	fe 20 	.   
	jp m,l80d7h		;80b7	fa d7 80 	. . . 
	cp 030h		;80ba	fe 30 	. 0 
	jr z,l80cch		;80bc	28 0e 	( . 
	cp 02ch		;80be	fe 2c 	. , 
	jr z,l80cch		;80c0	28 0a 	( . 
	cp 028h		;80c2	fe 28 	. ( 
	jr z,l80cch		;80c4	28 06 	( . 
	cp 024h		;80c6	fe 24 	. $ 
	jr z,l80cch		;80c8	28 02 	( . 
	jr l80cfh		;80ca	18 03 	. . 
l80cch:
	inc (ix+004h)		;80cc	dd 34 04 	. 4 . 
l80cfh:
	cp 020h		;80cf	fe 20 	.   
	ret nz			;80d1	c0 	. 
	ld (ix+004h),000h		;80d2	dd 36 04 00 	. 6 . . 
	ret			;80d6	c9 	. 
l80d7h:
	cp 014h		;80d7	fe 14 	. . 
	jp p,l80f1h		;80d9	f2 f1 80 	. . . 
	cp 010h		;80dc	fe 10 	. . 
	jr z,l80edh		;80de	28 0d 	( . 
	cp 00ch		;80e0	fe 0c 	. . 
	jr z,l80edh		;80e2	28 09 	( . 
	cp 008h		;80e4	fe 08 	. . 
	jr z,l80edh		;80e6	28 05 	( . 
	cp 004h		;80e8	fe 04 	. . 
	jr z,l80edh		;80ea	28 01 	( . 
	ret			;80ec	c9 	. 
l80edh:
	dec (ix+004h)		;80ed	dd 35 04 	. 5 . 
	ret			;80f0	c9 	. 
l80f1h:
	jr nz,l8121h		;80f1	20 2e 	  . 
	ld (ix+004h),005h		;80f3	dd 36 04 05 	. 6 . . 
	ld a,(ix+000h)		;80f7	dd 7e 00 	. ~ . 
	inc a			;80fa	3c 	< 
	ld (iy+000h),a		;80fb	fd 77 00 	. w . 
	ld a,(ix+001h)		;80fe	dd 7e 01 	. ~ . 
	ld b,008h		;8101	06 08 	. . 
l8103h:
	dec a			;8103	3d 	= 
	jr z,l8108h		;8104	28 02 	( . 
	djnz l8103h		;8106	10 fb 	. . 
l8108h:
	ld (iy+001h),a		;8108	fd 77 01 	. w . 
	ld (iy+002h),064h		;810b	fd 36 02 64 	. 6 . d 
	ld a,(ix+003h)		;810f	dd 7e 03 	. ~ . 
	rlca			;8112	07 	. 
	and 001h		;8113	e6 01 	. . 
	ld (iy+004h),a		;8115	fd 77 04 	. w . 
	ld (iy+003h),000h		;8118	fd 36 03 00 	. 6 . . 
	ld (iy+005h),001h		;811c	fd 36 05 01 	. 6 . . 
	ret			;8120	c9 	. 
l8121h:
	bit 7,(ix+003h)		;8121	dd cb 03 7e 	. . . ~ 
	jr z,l813ah		;8125	28 13 	( . 
	bit 6,(ix+003h)		;8127	dd cb 03 76 	. . . v 
	jr nz,l8132h		;812b	20 05 	  . 
	set 6,(ix+003h)		;812d	dd cb 03 f6 	. . . . 
	ret			;8131	c9 	. 
l8132h:
	res 6,(ix+003h)		;8132	dd cb 03 b6 	. . . . 
	inc (ix+000h)		;8136	dd 34 00 	. 4 . 
	ret			;8139	c9 	. 
l813ah:
	bit 6,(ix+003h)		;813a	dd cb 03 76 	. . . v 
	jr z,l8145h		;813e	28 05 	( . 
	res 6,(ix+003h)		;8140	dd cb 03 b6 	. . . . 
	ret			;8144	c9 	. 
l8145h:
	set 6,(ix+003h)		;8145	dd cb 03 f6 	. . . . 
	dec (ix+000h)		;8149	dd 35 00 	. 5 . 
	ret			;814c	c9 	. 
sub_814dh:
	ld hl,0783bh		;814d	21 3b 78 	! ; x 
	dec (hl)			;8150	35 	5 
	ret nz			;8151	c0 	. 
	ld (hl),00fh		;8152	36 0f 	6 . 
	ld ix,078b9h		;8154	dd 21 b9 78 	. ! . x 
	ld iy,078d7h		;8158	fd 21 d7 78 	. ! . x 
	ld a,005h		;815c	3e 05 	> . 
l815eh:
	push af			;815e	f5 	. 
	call sub_816eh		;815f	cd 6e 81 	. n . 
	ld bc,00006h		;8162	01 06 00 	. . . 
	add ix,bc		;8165	dd 09 	. . 
	add iy,bc		;8167	fd 09 	. . 
	pop af			;8169	f1 	. 
	dec a			;816a	3d 	= 
	jr nz,l815eh		;816b	20 f1 	  . 
	ret			;816d	c9 	. 
sub_816eh:
	ld a,(ix+005h)		;816e	dd 7e 05 	. ~ . 
	bit 7,a		;8171	cb 7f 	.  
	jr nz,l81bdh		;8173	20 48 	  H 
	ld a,(iy+005h)		;8175	fd 7e 05 	. ~ . 
	or a			;8178	b7 	. 
	ret nz			;8179	c0 	. 
	ld a,(ix+005h)		;817a	dd 7e 05 	. ~ . 
	dec a			;817d	3d 	= 
	ld (ix+005h),a		;817e	dd 77 05 	. w . 
	jr z,l8184h		;8181	28 01 	( . 
	ret			;8183	c9 	. 
l8184h:
	ld a,(iy+004h)		;8184	fd 7e 04 	. ~ . 
	ld b,(iy+000h)		;8187	fd 46 00 	. F . 
	dec b			;818a	05 	. 
	and 001h		;818b	e6 01 	. . 
	jr z,l8196h		;818d	28 07 	( . 
	inc b			;818f	04 	. 
	inc b			;8190	04 	. 
	inc b			;8191	04 	. 
	inc b			;8192	04 	. 
	inc b			;8193	04 	. 
	inc b			;8194	04 	. 
	inc b			;8195	04 	. 
l8196h:
	ld (ix+000h),b		;8196	dd 70 00 	. p . 
	rrca			;8199	0f 	. 
	ld b,a			;819a	47 	G 
	ld a,r		;819b	ed 5f 	. _ 
	and 007h		;819d	e6 07 	. . 
	or 003h		;819f	f6 03 	. . 
	add a,002h		;81a1	c6 02 	. . 
	ld (ix+002h),a		;81a3	dd 77 02 	. w . 
	or b			;81a6	b0 	. 
	ld (ix+003h),a		;81a7	dd 77 03 	. w . 
	ld a,003h		;81aa	3e 03 	> . 
	bit 7,b		;81ac	cb 78 	. x 
	jr z,l81b1h		;81ae	28 01 	( . 
	xor a			;81b0	af 	. 
l81b1h:
	ld (ix+004h),a		;81b1	dd 77 04 	. w . 
	set 7,(ix+005h)		;81b4	dd cb 05 fe 	. . . . 
	ld (ix+001h),001h		;81b8	dd 36 01 01 	. 6 . . 
	ret			;81bc	c9 	. 
l81bdh:
	ld a,(ix+003h)		;81bd	dd 7e 03 	. ~ . 
	bit 7,a		;81c0	cb 7f 	.  
	jr z,l81d8h		;81c2	28 14 	( . 
	ld a,(ix+004h)		;81c4	dd 7e 04 	. ~ . 
	inc a			;81c7	3c 	< 
	ld (ix+004h),a		;81c8	dd 77 04 	. w . 
	cp 004h		;81cb	fe 04 	. . 
	jr nz,l81efh		;81cd	20 20 	    
	inc (ix+000h)		;81cf	dd 34 00 	. 4 . 
	ld (ix+004h),000h		;81d2	dd 36 04 00 	. 6 . . 
	jr l81efh		;81d6	18 17 	. . 
l81d8h:
	ld a,(ix+004h)		;81d8	dd 7e 04 	. ~ . 
	dec a			;81db	3d 	= 
	ld (ix+004h),a		;81dc	dd 77 04 	. w . 
	inc a			;81df	3c 	< 
	jr nz,l81efh		;81e0	20 0d 	  . 
	ld (ix+004h),003h		;81e2	dd 36 04 03 	. 6 . . 
	ld a,(ix+000h)		;81e6	dd 7e 00 	. ~ . 
	or a			;81e9	b7 	. 
	jr z,l81efh		;81ea	28 03 	( . 
	dec (ix+000h)		;81ec	dd 35 00 	. 5 . 
l81efh:
	dec (ix+002h)		;81ef	dd 35 02 	. 5 . 
	ret nz			;81f2	c0 	. 
	ld a,(ix+001h)		;81f3	dd 7e 01 	. ~ . 
	inc a			;81f6	3c 	< 
	ld (ix+001h),a		;81f7	dd 77 01 	. w . 
	cp 009h		;81fa	fe 09 	. . 
	jr z,l8207h		;81fc	28 09 	( . 
	ld a,(ix+003h)		;81fe	dd 7e 03 	. ~ . 
	and 07fh		;8201	e6 7f 	.  
	ld (ix+002h),a		;8203	dd 77 02 	. w . 
	ret			;8206	c9 	. 
l8207h:
	ld a,(ix+000h)		;8207	dd 7e 00 	. ~ . 
	call sub_8cf1h		;820a	cd f1 8c 	. . . 
	jr nz,l8219h		;820d	20 0a 	  . 
	ld c,000h		;820f	0e 00 	. . 
	ld b,(ix+000h)		;8211	dd 46 00 	. F . 
	ld d,000h		;8214	16 00 	. . 
	call sub_89c3h		;8216	cd c3 89 	. . . 
l8219h:
	ld a,r		;8219	ed 5f 	. _ 
	and 01fh		;821b	e6 1f 	. . 
	or 007h		;821d	f6 07 	. . 
	ld (ix+005h),a		;821f	dd 77 05 	. w . 
	ret			;8222	c9 	. 
sub_8223h:
	ld hl,0783fh		;8223	21 3f 78 	! ? x 
	dec (hl)			;8226	35 	5 
	ret nz			;8227	c0 	. 
	ld (hl),03ch		;8228	36 3c 	6 < 
	ld a,004h		;822a	3e 04 	> . 
	ld ix,0789ah		;822c	dd 21 9a 78 	. ! . x 
l8230h:
	push af			;8230	f5 	. 
	call sub_823eh		;8231	cd 3e 82 	. > . 
	ld bc,00007h		;8234	01 07 00 	. . . 
	add ix,bc		;8237	dd 09 	. . 
	pop af			;8239	f1 	. 
	dec a			;823a	3d 	= 
	jr nz,l8230h		;823b	20 f3 	  . 
	ret			;823d	c9 	. 
sub_823eh:
	ld a,(ix+005h)		;823e	dd 7e 05 	. ~ . 
	bit 7,a		;8241	cb 7f 	.  
	jr nz,l82aah		;8243	20 65 	  e 
	or a			;8245	b7 	. 
	jr z,l824dh		;8246	28 05 	( . 
	dec a			;8248	3d 	= 
	ld (ix+005h),a		;8249	dd 77 05 	. w . 
	ret			;824c	c9 	. 
l824dh:
	nop			;824d	00 	. 
	set 7,(ix+003h)		;824e	dd cb 03 fe 	. . . . 
	ld a,(ix+000h)		;8252	dd 7e 00 	. ~ . 
	ld e,a			;8255	5f 	_ 
	ld d,000h		;8256	16 00 	. . 
	call sub_83d2h		;8258	cd d2 83 	. . . 
	ld l,a			;825b	6f 	o 
	ld h,000h		;825c	26 00 	& . 
	push hl			;825e	e5 	. 
	or a			;825f	b7 	. 
	sbc hl,de		;8260	ed 52 	. R 
	pop bc			;8262	c1 	. 
	jp p,l8270h		;8263	f2 70 82 	. p . 
	push bc			;8266	c5 	. 
	pop hl			;8267	e1 	. 
	ex de,hl			;8268	eb 	. 
	or a			;8269	b7 	. 
	sbc hl,de		;826a	ed 52 	. R 
	res 7,(ix+003h)		;826c	dd cb 03 be 	. . . . 
l8270h:
	ld a,l			;8270	7d 	} 
	bit 7,a		;8271	cb 7f 	.  
	jr nz,l82e1h		;8273	20 6c 	  l 
	cp 037h		;8275	fe 37 	. 7 
	jp p,l82e1h		;8277	f2 e1 82 	. . . 
	ld a,(07900h)		;827a	3a 00 79 	: . y 
	cp 032h		;827d	fe 32 	. 2 
	jp p,l82e1h		;827f	f2 e1 82 	. . . 
	ld h,a			;8282	67 	g 
	ld a,035h		;8283	3e 35 	> 5 
	sub h			;8285	94 	. 
	ld h,a			;8286	67 	g 
	ld b,000h		;8287	06 00 	. . 
	ld a,l			;8289	7d 	} 
	or a			;828a	b7 	. 
	jr nz,l8291h		;828b	20 04 	  . 
	ld b,03ch		;828d	06 3c 	. < 
	jr l829bh		;828f	18 0a 	. . 
l8291h:
	ld a,h			;8291	7c 	| 
	sla l		;8292	cb 25 	. % 
l8294h:
	sub l			;8294	95 	. 
	jp m,l829bh		;8295	fa 9b 82 	. . . 
	inc b			;8298	04 	. 
	jr l8294h		;8299	18 f9 	. . 
l829bh:
	ld a,b			;829b	78 	x 
	ld (ix+002h),a		;829c	dd 77 02 	. w . 
	or (ix+003h)		;829f	dd b6 03 	. . . 
	ld (ix+003h),a		;82a2	dd 77 03 	. w . 
	set 7,(ix+005h)		;82a5	dd cb 05 fe 	. . . . 
	ret			;82a9	c9 	. 
l82aah:
	ld a,(ix+001h)		;82aa	dd 7e 01 	. ~ . 
	inc a			;82ad	3c 	< 
	cp 036h		;82ae	fe 36 	. 6 
	jr z,l82d7h		;82b0	28 25 	( % 
	ld (ix+001h),a		;82b2	dd 77 01 	. w . 
	ld a,(ix+002h)		;82b5	dd 7e 02 	. ~ . 
	or a			;82b8	b7 	. 
	jr z,l82cch		;82b9	28 11 	( . 
	dec a			;82bb	3d 	= 
	ld (ix+002h),a		;82bc	dd 77 02 	. w . 
	ret nz			;82bf	c0 	. 
	ld a,(ix+003h)		;82c0	dd 7e 03 	. ~ . 
	and 07fh		;82c3	e6 7f 	.  
	ld (ix+002h),a		;82c5	dd 77 02 	. w . 
	ld b,001h		;82c8	06 01 	. . 
	jr l82ceh		;82ca	18 02 	. . 
l82cch:
	ld b,002h		;82cc	06 02 	. . 
l82ceh:
	ld a,(ix+003h)		;82ce	dd 7e 03 	. ~ . 
	bit 7,a		;82d1	cb 7f 	.  
	jr z,l8314h		;82d3	28 3f 	( ? 
	jr l82feh		;82d5	18 27 	. ' 
l82d7h:
	ld b,(ix+000h)		;82d7	dd 46 00 	. F . 
	ld c,03bh		;82da	0e 3b 	. ; 
	ld d,040h		;82dc	16 40 	. @ 
	call sub_89c3h		;82de	cd c3 89 	. . . 
l82e1h:
	xor a			;82e1	af 	. 
	ld (ix+001h),a		;82e2	dd 77 01 	. w . 
	ld (ix+002h),a		;82e5	dd 77 02 	. w . 
	ld (ix+003h),a		;82e8	dd 77 03 	. w . 
	ld (ix+004h),a		;82eb	dd 77 04 	. w . 
	ld a,(ix+006h)		;82ee	dd 7e 06 	. ~ . 
	ld (ix+000h),a		;82f1	dd 77 00 	. w . 
	ld a,r		;82f4	ed 5f 	. _ 
	and 01fh		;82f6	e6 1f 	. . 
	or 003h		;82f8	f6 03 	. . 
	ld (ix+005h),a		;82fa	dd 77 05 	. w . 
	ret			;82fd	c9 	. 
l82feh:
	ld a,(ix+004h)		;82fe	dd 7e 04 	. ~ . 
	or a			;8301	b7 	. 
	jr nz,l830ah		;8302	20 06 	  . 
	inc a			;8304	3c 	< 
	ld (ix+004h),a		;8305	dd 77 04 	. w . 
	jr l8311h		;8308	18 07 	. . 
l830ah:
	xor a			;830a	af 	. 
	ld (ix+004h),a		;830b	dd 77 04 	. w . 
	inc (ix+000h)		;830e	dd 34 00 	. 4 . 
l8311h:
	djnz l82feh		;8311	10 eb 	. . 
	ret			;8313	c9 	. 
l8314h:
	ld a,(ix+004h)		;8314	dd 7e 04 	. ~ . 
	or a			;8317	b7 	. 
	jr z,l8320h		;8318	28 06 	( . 
	xor a			;831a	af 	. 
	ld (ix+004h),a		;831b	dd 77 04 	. w . 
	jr l832fh		;831e	18 0f 	. . 
l8320h:
	ld a,(ix+000h)		;8320	dd 7e 00 	. ~ . 
	or a			;8323	b7 	. 
	jr z,l832fh		;8324	28 09 	( . 
	dec a			;8326	3d 	= 
	ld (ix+000h),a		;8327	dd 77 00 	. w . 
	ld a,001h		;832a	3e 01 	> . 
	ld (ix+004h),a		;832c	dd 77 04 	. w . 
l832fh:
	djnz l8314h		;832f	10 e3 	. . 
	ret			;8331	c9 	. 
sub_8332h:
	ld hl,078b7h		;8332	21 b7 78 	! . x 
	dec (hl)			;8335	35 	5 
	ret nz			;8336	c0 	. 
	ld (hl),0b4h		;8337	36 b4 	6 . 
	ld ix,078d7h		;8339	dd 21 d7 78 	. ! . x 
	ld a,005h		;833d	3e 05 	> . 
l833fh:
	push af			;833f	f5 	. 
	call sub_834dh		;8340	cd 4d 83 	. M . 
	ld bc,00006h		;8343	01 06 00 	. . . 
	add ix,bc		;8346	dd 09 	. . 
	pop af			;8348	f1 	. 
	dec a			;8349	3d 	= 
	jr nz,l833fh		;834a	20 f3 	  . 
	ret			;834c	c9 	. 
sub_834dh:
	ld a,(ix+005h)		;834d	dd 7e 05 	. ~ . 
	or a			;8350	b7 	. 
	jr z,l8358h		;8351	28 05 	( . 
	dec a			;8353	3d 	= 
	ld (ix+005h),a		;8354	dd 77 05 	. w . 
	ret			;8357	c9 	. 
l8358h:
	ld a,(ix+004h)		;8358	dd 7e 04 	. ~ . 
	and 001h		;835b	e6 01 	. . 
	jr z,l8379h		;835d	28 1a 	( . 
	ld a,(ix+003h)		;835f	dd 7e 03 	. ~ . 
	or a			;8362	b7 	. 
	jr nz,l836ah		;8363	20 05 	  . 
	inc a			;8365	3c 	< 
	ld (ix+003h),a		;8366	dd 77 03 	. w . 
	ret			;8369	c9 	. 
l836ah:
	ld a,(ix+000h)		;836a	dd 7e 00 	. ~ . 
	cp (ix+002h)		;836d	dd be 02 	. . . 
	ret z			;8370	c8 	. 
	inc (ix+000h)		;8371	dd 34 00 	. 4 . 
	xor a			;8374	af 	. 
	ld (ix+003h),a		;8375	dd 77 03 	. w . 
	ret			;8378	c9 	. 
l8379h:
	ld a,(ix+003h)		;8379	dd 7e 03 	. ~ . 
	or a			;837c	b7 	. 
	jr z,l8384h		;837d	28 05 	( . 
	xor a			;837f	af 	. 
	ld (ix+003h),a		;8380	dd 77 03 	. w . 
	ret			;8383	c9 	. 
l8384h:
	ld a,(ix+000h)		;8384	dd 7e 00 	. ~ . 
	cp (ix+001h)		;8387	dd be 01 	. . . 
	ret z			;838a	c8 	. 
	dec (ix+000h)		;838b	dd 35 00 	. 5 . 
	ld a,001h		;838e	3e 01 	> . 
	ld (ix+003h),a		;8390	dd 77 03 	. w . 
	ret			;8393	c9 	. 
sub_8394h:
	ld hl,078b8h		;8394	21 b8 78 	! . x 
	dec (hl)			;8397	35 	5 
	ret nz			;8398	c0 	. 
	ld ix,078d7h		;8399	dd 21 d7 78 	. ! . x 
	ld a,005h		;839d	3e 05 	> . 
l839fh:
	push af			;839f	f5 	. 
	call sub_83adh		;83a0	cd ad 83 	. . . 
	ld bc,00006h		;83a3	01 06 00 	. . . 
	add ix,bc		;83a6	dd 09 	. . 
	pop af			;83a8	f1 	. 
	dec a			;83a9	3d 	= 
	jr nz,l839fh		;83aa	20 f3 	  . 
	ret			;83ac	c9 	. 
sub_83adh:
	ld a,(ix+004h)		;83ad	dd 7e 04 	. ~ . 
	ld b,a			;83b0	47 	G 
	and 001h		;83b1	e6 01 	. . 
	ld c,a			;83b3	4f 	O 
	ld a,b			;83b4	78 	x 
	rrca			;83b5	0f 	. 
	and 01fh		;83b6	e6 1f 	. . 
	dec a			;83b8	3d 	= 
	jr z,l83c1h		;83b9	28 06 	( . 
	rlca			;83bb	07 	. 
	or c			;83bc	b1 	. 
	ld (ix+004h),a		;83bd	dd 77 04 	. w . 
	ret			;83c0	c9 	. 
l83c1h:
	ld a,(ix+000h)		;83c1	dd 7e 00 	. ~ . 
	call sub_83deh		;83c4	cd de 83 	. . . 
	ld a,r		;83c7	ed 5f 	. _ 
	or 003h		;83c9	f6 03 	. . 
	and 01eh		;83cb	e6 1e 	. . 
	or c			;83cd	b1 	. 
	ld (ix+004h),a		;83ce	dd 77 04 	. w . 
	ret			;83d1	c9 	. 
sub_83d2h:
	ld a,(07905h)		;83d2	3a 05 79 	: . y 
	ld b,00ah		;83d5	06 0a 	. . 
l83d7h:
	inc a			;83d7	3c 	< 
	jr z,l83dch		;83d8	28 02 	( . 
	djnz l83d7h		;83da	10 fb 	. . 
l83dch:
	dec a			;83dc	3d 	= 
	ret			;83dd	c9 	. 
sub_83deh:
	ld e,a			;83de	5f 	_ 
	ld d,000h		;83df	16 00 	. . 
	call sub_83d2h		;83e1	cd d2 83 	. . . 
	ld l,a			;83e4	6f 	o 
	ld h,000h		;83e5	26 00 	& . 
	or a			;83e7	b7 	. 
	sbc hl,de		;83e8	ed 52 	. R 
	jp m,l83fah		;83ea	fa fa 83 	. . . 
	jr z,l83f1h		;83ed	28 02 	( . 
	jr l83f7h		;83ef	18 06 	. . 
l83f1h:
	ld a,r		;83f1	ed 5f 	. _ 
	and 001h		;83f3	e6 01 	. . 
	jr z,l83fah		;83f5	28 03 	( . 
l83f7h:
	ld c,001h		;83f7	0e 01 	. . 
	ret			;83f9	c9 	. 
l83fah:
	ld c,000h		;83fa	0e 00 	. . 
	ret			;83fc	c9 	. 
sub_83fdh:
	ld a,(07900h)		;83fd	3a 00 79 	: . y 
	cp 035h		;8400	fe 35 	. 5 
	ret z			;8402	c8 	. 
	ld a,(078fdh)		;8403	3a fd 78 	: . x 
	or a			;8406	b7 	. 
	jr z,l840eh		;8407	28 05 	( . 
	dec a			;8409	3d 	= 
	ld (078fdh),a		;840a	32 fd 78 	2 . x 
	ret			;840d	c9 	. 
l840eh:
	call sub_8ef0h		;840e	cd f0 8e 	. . . 
	bit 5,a		;8411	cb 6f 	. o 
	ret z			;8413	c8 	. 
	ld a,0c8h		;8414	3e c8 	> . 
	ld (078fdh),a		;8416	32 fd 78 	2 . x 
sub_8419h:
	ld a,(07902h)		;8419	3a 02 79 	: . y 
	rrca			;841c	0f 	. 
	rrca			;841d	0f 	. 
	ld (07902h),a		;841e	32 02 79 	2 . y 
	ret			;8421	c9 	. 
sub_8422h:
	ld hl,078fbh		;8422	21 fb 78 	! . x 
	dec (hl)			;8425	35 	5 
	ret nz			;8426	c0 	. 
	ld a,(078f7h)		;8427	3a f7 78 	: . x 
	ld (hl),a			;842a	77 	w 
	call sub_8ef0h		;842b	cd f0 8e 	. . . 
	and 003h		;842e	e6 03 	. . 
	jr z,l849bh		;8430	28 69 	( i 
	ld b,a			;8432	47 	G 
	ld a,(078f5h)		;8433	3a f5 78 	: . x 
	cp b			;8436	b8 	. 
	jr z,l843eh		;8437	28 05 	( . 
	ld a,096h		;8439	3e 96 	> . 
	ld (078f7h),a		;843b	32 f7 78 	2 . x 
l843eh:
	ld a,b			;843e	78 	x 
	ld (078f5h),a		;843f	32 f5 78 	2 . x 
	push af			;8442	f5 	. 
	ld a,(078f7h)		;8443	3a f7 78 	: . x 
	cp 01eh		;8446	fe 1e 	. . 
	jr z,l844fh		;8448	28 05 	( . 
	sub 01eh		;844a	d6 1e 	. . 
	ld (078f7h),a		;844c	32 f7 78 	2 . x 
l844fh:
	pop af			;844f	f1 	. 
l8450h:
	bit 0,a		;8450	cb 47 	. G 
	jr nz,l84abh		;8452	20 57 	  W 
	jr l84c1h		;8454	18 6b 	. k 
sub_8456h:
	ld hl,078fch		;8456	21 fc 78 	! . x 
	dec (hl)			;8459	35 	5 
	ret nz			;845a	c0 	. 
	ld a,(078f8h)		;845b	3a f8 78 	: . x 
	ld (hl),a			;845e	77 	w 
	call sub_8ef0h		;845f	cd f0 8e 	. . . 
	and 00ch		;8462	e6 0c 	. . 
	jr z,l848bh		;8464	28 25 	( % 
	ld b,a			;8466	47 	G 
	ld a,(078f6h)		;8467	3a f6 78 	: . x 
	cp b			;846a	b8 	. 
	jr z,l8472h		;846b	28 05 	( . 
	ld a,096h		;846d	3e 96 	> . 
	ld (078f8h),a		;846f	32 f8 78 	2 . x 
l8472h:
	ld a,b			;8472	78 	x 
	ld (078f6h),a		;8473	32 f6 78 	2 . x 
	push af			;8476	f5 	. 
	ld a,(078f8h)		;8477	3a f8 78 	: . x 
	cp 01eh		;847a	fe 1e 	. . 
	jr z,l8483h		;847c	28 05 	( . 
	sub 01eh		;847e	d6 1e 	. . 
	ld (078f8h),a		;8480	32 f8 78 	2 . x 
l8483h:
	pop af			;8483	f1 	. 
l8484h:
	bit 2,a		;8484	cb 57 	. W 
	jr nz,l84d6h		;8486	20 4e 	  N 
	jp l852bh		;8488	c3 2b 85 	. + . 
l848bh:
	ld a,(078f8h)		;848b	3a f8 78 	: . x 
	cp 096h		;848e	fe 96 	. . 
	ret z			;8490	c8 	. 
	add a,01eh		;8491	c6 1e 	. . 
	ld (078f8h),a		;8493	32 f8 78 	2 . x 
	ld a,(078f6h)		;8496	3a f6 78 	: . x 
	jr l8484h		;8499	18 e9 	. . 
l849bh:
	ld a,(078f7h)		;849b	3a f7 78 	: . x 
	cp 096h		;849e	fe 96 	. . 
	ret z			;84a0	c8 	. 
	add a,01eh		;84a1	c6 1e 	. . 
	ld (078f7h),a		;84a3	32 f7 78 	2 . x 
	ld a,(078f5h)		;84a6	3a f5 78 	: . x 
	jr l8450h		;84a9	18 a5 	. . 
l84abh:
	ld a,(07900h)		;84ab	3a 00 79 	: . y 
	or a			;84ae	b7 	. 
	ret z			;84af	c8 	. 
	dec a			;84b0	3d 	= 
	ld (07900h),a		;84b1	32 00 79 	2 . y 
	ld hl,(078feh)		;84b4	2a fe 78 	* . x 
	ld de,0002ch		;84b7	11 2c 00 	. , . 
	or a			;84ba	b7 	. 
	sbc hl,de		;84bb	ed 52 	. R 
	ld (078feh),hl		;84bd	22 fe 78 	" . x 
	ret			;84c0	c9 	. 
l84c1h:
	ld a,(07900h)		;84c1	3a 00 79 	: . y 
	cp 035h		;84c4	fe 35 	. 5 
	ret z			;84c6	c8 	. 
	inc a			;84c7	3c 	< 
	ld (07900h),a		;84c8	32 00 79 	2 . y 
	ld hl,(078feh)		;84cb	2a fe 78 	* . x 
	ld de,0002ch		;84ce	11 2c 00 	. , . 
	add hl,de			;84d1	19 	. 
	ld (078feh),hl		;84d2	22 fe 78 	" . x 
	ret			;84d5	c9 	. 
l84d6h:
	ld a,(07900h)		;84d6	3a 00 79 	: . y 
	cp 035h		;84d9	fe 35 	. 5 
	ret z			;84db	c8 	. 
	ld a,(07904h)		;84dc	3a 04 79 	: . y 
	or a			;84df	b7 	. 
	jr z,l84e7h		;84e0	28 05 	( . 
	xor a			;84e2	af 	. 
	ld (07904h),a		;84e3	32 04 79 	2 . y 
	ret			;84e6	c9 	. 
l84e7h:
	ld a,(07901h)		;84e7	3a 01 79 	: . y 
	or a			;84ea	b7 	. 
	jr z,l8518h		;84eb	28 2b 	( + 
	dec a			;84ed	3d 	= 
	ld (07901h),a		;84ee	32 01 79 	2 . y 
	ld a,001h		;84f1	3e 01 	> . 
	ld (07904h),a		;84f3	32 04 79 	2 . y 
	ld hl,(078feh)		;84f6	2a fe 78 	* . x 
	dec hl			;84f9	2b 	+ 
	ld (078feh),hl		;84fa	22 fe 78 	" . x 
	call sub_8560h		;84fd	cd 60 85 	. ` . 
l8500h:
	ld a,(07905h)		;8500	3a 05 79 	: . y 
	dec a			;8503	3d 	= 
	ld (07905h),a		;8504	32 05 79 	2 . y 
	call sub_850bh		;8507	cd 0b 85 	. . . 
	ret			;850a	c9 	. 
sub_850bh:
	ld hl,0786ah		;850b	21 6a 78 	! j x 
	ld de,00004h		;850e	11 04 00 	. . . 
	ld b,006h		;8511	06 06 	. . 
l8513h:
	dec (hl)			;8513	35 	5 
	add hl,de			;8514	19 	. 
	djnz l8513h		;8515	10 fc 	. . 
	ret			;8517	c9 	. 
l8518h:
	ld a,(07908h)		;8518	3a 08 79 	: . y 
	cp 006h		;851b	fe 06 	. . 
	ret z			;851d	c8 	. 
	dec a			;851e	3d 	= 
	ld (07908h),a		;851f	32 08 79 	2 . y 
	ld hl,(07906h)		;8522	2a 06 79 	* . y 
	dec hl			;8525	2b 	+ 
	ld (07906h),hl		;8526	22 06 79 	" . y 
	jr l8500h		;8529	18 d5 	. . 
l852bh:
	ld a,(07900h)		;852b	3a 00 79 	: . y 
	cp 035h		;852e	fe 35 	. 5 
	ret z			;8530	c8 	. 
	ld a,(07904h)		;8531	3a 04 79 	: . y 
	or a			;8534	b7 	. 
	jr nz,l853ch		;8535	20 05 	  . 
	inc a			;8537	3c 	< 
	ld (07904h),a		;8538	32 04 79 	2 . y 
	ret			;853b	c9 	. 
l853ch:
	ld a,(07901h)		;853c	3a 01 79 	: . y 
	cp 00ch		;853f	fe 0c 	. . 
	jr z,l856dh		;8541	28 2a 	( * 
	inc a			;8543	3c 	< 
	ld (07901h),a		;8544	32 01 79 	2 . y 
	xor a			;8547	af 	. 
	ld (07904h),a		;8548	32 04 79 	2 . y 
	ld hl,(078feh)		;854b	2a fe 78 	* . x 
	inc hl			;854e	23 	# 
	ld (078feh),hl		;854f	22 fe 78 	" . x 
	call sub_850bh		;8552	cd 0b 85 	. . . 
l8555h:
	ld a,(07905h)		;8555	3a 05 79 	: . y 
	inc a			;8558	3c 	< 
	ld (07905h),a		;8559	32 05 79 	2 . y 
	call sub_8560h		;855c	cd 60 85 	. ` . 
	ret			;855f	c9 	. 
sub_8560h:
	ld hl,0786ah		;8560	21 6a 78 	! j x 
	ld de,00004h		;8563	11 04 00 	. . . 
	ld b,006h		;8566	06 06 	. . 
l8568h:
	inc (hl)			;8568	34 	4 
	add hl,de			;8569	19 	. 
	djnz l8568h		;856a	10 fc 	. . 
	ret			;856c	c9 	. 
l856dh:
	ld a,(07908h)		;856d	3a 08 79 	: . y 
	cp 0f2h		;8570	fe f2 	. . 
	ret z			;8572	c8 	. 
	inc a			;8573	3c 	< 
	ld (07908h),a		;8574	32 08 79 	2 . y 
	ld hl,(07906h)		;8577	2a 06 79 	* . y 
	inc hl			;857a	23 	# 
	ld (07906h),hl		;857b	22 06 79 	" . y 
	jr l8555h		;857e	18 d5 	. . 
sub_8580h:
	ld hl,078fah		;8580	21 fa 78 	! . x 
	dec (hl)			;8583	35 	5 
	ret nz			;8584	c0 	. 
	ld (hl),064h		;8585	36 64 	6 d 
	ld a,(07903h)		;8587	3a 03 79 	: . y 
	xor 001h		;858a	ee 01 	. . 
	ld (07903h),a		;858c	32 03 79 	2 . y 
	ld a,(07885h)		;858f	3a 85 78 	: . x 
	xor 020h		;8592	ee 20 	.   
	ld (07885h),a		;8594	32 85 78 	2 . x 
	ld a,(0788bh)		;8597	3a 8b 78 	: . x 
	xor 020h		;859a	ee 20 	.   
	ld (0788bh),a		;859c	32 8b 78 	2 . x 
	ret			;859f	c9 	. 
	ld bc,0001eh		;85a0	01 1e 00 	. . . 
sub_85a3h:
	dec bc			;85a3	0b 	. 
	ld a,b			;85a4	78 	x 
	or c			;85a5	b1 	. 
	jr nz,sub_85a3h		;85a6	20 fb 	  . 
	ret			;85a8	c9 	. 
sub_85a9h:
	nop			;85a9	00 	. 
	ld hl,078f9h		;85aa	21 f9 78 	! . x 
	dec (hl)			;85ad	35 	5 
	ret nz			;85ae	c0 	. 
	ld (hl),01eh		;85af	36 1e 	6 . 
	call sub_86edh		;85b1	cd ed 86 	. . . 
	call sub_8788h		;85b4	cd 88 87 	. . . 
	call sub_8f70h		;85b7	cd 70 8f 	. p . 
	call sub_8d81h		;85ba	cd 81 8d 	. . . 
	call sub_8c39h		;85bd	cd 39 8c 	. 9 . 
	call sub_8c88h		;85c0	cd 88 8c 	. . . 
	call sub_8c4dh		;85c3	cd 4d 8c 	. M . 
	call sub_8b40h		;85c6	cd 40 8b 	. @ . 
	call sub_8677h		;85c9	cd 77 86 	. w . 
	call sub_8dfeh		;85cc	cd fe 8d 	. . . 
	call sub_8e24h		;85cf	cd 24 8e 	. $ . 
	call sub_8e4bh		;85d2	cd 4b 8e 	. K . 
	call sub_8624h		;85d5	cd 24 86 	. $ . 
	ld a,001h		;85d8	3e 01 	> . 
	ld (l8ba5h),a		;85da	32 a5 8b 	2 . . 
	call sub_8ba6h		;85dd	cd a6 8b 	. . . 
	call sub_8d43h		;85e0	cd 43 8d 	. C . 
	xor a			;85e3	af 	. 
	ld (l8ba5h),a		;85e4	32 a5 8b 	2 . . 
	call sub_8ba6h		;85e7	cd a6 8b 	. . . 
	call sub_8ac3h		;85ea	cd c3 8a 	. . . 
	call sub_8a26h		;85ed	cd 26 8a 	. & . 
	call sub_8715h		;85f0	cd 15 87 	. . . 
	call sub_8db9h		;85f3	cd b9 8d 	. . . 
	call sub_8644h		;85f6	cd 44 86 	. D . 
	call sub_875bh		;85f9	cd 5b 87 	. [ . 
	call sub_8a68h		;85fc	cd 68 8a 	. h . 
	call sub_8d81h		;85ff	cd 81 8d 	. . . 
	call sub_8ccah		;8602	cd ca 8c 	. . . 
	call sub_8c0dh		;8605	cd 0d 8c 	. . . 
	call sub_8b7eh		;8608	cd 7e 8b 	. ~ . 
	call sub_8b16h		;860b	cd 16 8b 	. . . 
	call sub_8707h		;860e	cd 07 87 	. . . 
	call sub_8e74h		;8611	cd 74 8e 	. t . 
	call sub_8e97h		;8614	cd 97 8e 	. . . 
	call sub_8ebbh		;8617	cd bb 8e 	. . . 
	call sub_869eh		;861a	cd 9e 86 	. . . 
	call sub_86c7h		;861d	cd c7 86 	. . . 
	call sub_868ch		;8620	cd 8c 86 	. . . 
	ret			;8623	c9 	. 
sub_8624h:
	call sub_865eh		;8624	cd 5e 86 	. ^ . 
	push hl			;8627	e5 	. 
	ex de,hl			;8628	eb 	. 
	ld hl,la417h		;8629	21 17 a4 	! . . 
	ld b,00eh		;862c	06 0e 	. . 
	ld c,008h		;862e	0e 08 	. . 
	call sub_8da2h		;8630	cd a2 8d 	. . . 
	pop hl			;8633	e1 	. 
	ld de,00008h		;8634	11 08 00 	. . . 
	add hl,de			;8637	19 	. 
	ex de,hl			;8638	eb 	. 
	ld hl,la487h		;8639	21 87 a4 	! . . 
	ld b,00eh		;863c	06 0e 	. . 
	ld c,008h		;863e	0e 08 	. . 
	call sub_8da2h		;8640	cd a2 8d 	. . . 
	ret			;8643	c9 	. 
sub_8644h:
	call sub_865eh		;8644	cd 5e 86 	. ^ . 
	ex de,hl			;8647	eb 	. 
	ld a,010h		;8648	3e 10 	> . 
	ld bc,00008h		;864a	01 08 00 	. . . 
	push af			;864d	f5 	. 
	push bc			;864e	c5 	. 
	push de			;864f	d5 	. 
	call sub_8d8ah		;8650	cd 8a 8d 	. . . 
	pop hl			;8653	e1 	. 
	ld de,00008h		;8654	11 08 00 	. . . 
	add hl,de			;8657	19 	. 
	ex de,hl			;8658	eb 	. 
	pop bc			;8659	c1 	. 
	pop af			;865a	f1 	. 
	jp sub_8d8ah		;865b	c3 8a 8d 	. . . 
sub_865eh:
	ld a,(07908h)		;865e	3a 08 79 	: . y 
	bit 7,a		;8661	cb 7f 	.  
	jr z,l8675h		;8663	28 10 	( . 
	res 7,a		;8665	cb bf 	. . 
	sub 066h		;8667	d6 66 	. f 
	jp m,l8675h		;8669	fa 75 86 	. u . 
	inc a			;866c	3c 	< 
	ld hl,0b30eh		;866d	21 0e b3 	! . . 
l8670h:
	dec a			;8670	3d 	= 
	ret z			;8671	c8 	. 
	dec hl			;8672	2b 	+ 
	jr l8670h		;8673	18 fb 	. . 
l8675h:
	pop af			;8675	f1 	. 
	ret			;8676	c9 	. 
sub_8677h:
	ld a,0f5h		;8677	3e f5 	> . 
	call sub_8cf1h		;8679	cd f1 8c 	. . . 
	ret nz			;867c	c0 	. 
	call sub_8ee1h		;867d	cd e1 8e 	. . . 
	ld de,la4f7h		;8680	11 f7 a4 	. . . 
	ex de,hl			;8683	eb 	. 
	ld b,010h		;8684	06 10 	. . 
	ld c,003h		;8686	0e 03 	. . 
	call sub_8da2h		;8688	cd a2 8d 	. . . 
	ret			;868b	c9 	. 
sub_868ch:
	ld a,0f5h		;868c	3e f5 	> . 
	call sub_8cf1h		;868e	cd f1 8c 	. . . 
	ret nz			;8691	c0 	. 
	call sub_8ee1h		;8692	cd e1 8e 	. . . 
	ld a,010h		;8695	3e 10 	> . 
	ld bc,00003h		;8697	01 03 00 	. . . 
	ex de,hl			;869a	eb 	. 
	jp sub_8d8ah		;869b	c3 8a 8d 	. . . 
sub_869eh:
	ld ix,078d7h		;869e	dd 21 d7 78 	. ! . x 
	ld a,005h		;86a2	3e 05 	> . 
l86a4h:
	push af			;86a4	f5 	. 
	call sub_86b2h		;86a5	cd b2 86 	. . . 
	pop af			;86a8	f1 	. 
	ld bc,00006h		;86a9	01 06 00 	. . . 
	add ix,bc		;86ac	dd 09 	. . 
	dec a			;86ae	3d 	= 
	jr nz,l86a4h		;86af	20 f3 	  . 
	ret			;86b1	c9 	. 
sub_86b2h:
	ld a,(ix+005h)		;86b2	dd 7e 05 	. ~ . 
	or a			;86b5	b7 	. 
	ret nz			;86b6	c0 	. 
	ld a,(ix+000h)		;86b7	dd 7e 00 	. ~ . 
	call sub_8cf1h		;86ba	cd f1 8c 	. . . 
	ret nz			;86bd	c0 	. 
	ex de,hl			;86be	eb 	. 
	ld a,009h		;86bf	3e 09 	> . 
	ld bc,00006h		;86c1	01 06 00 	. . . 
	jp sub_8d8ah		;86c4	c3 8a 8d 	. . . 
sub_86c7h:
	ld a,005h		;86c7	3e 05 	> . 
	ld ix,078b9h		;86c9	dd 21 b9 78 	. ! . x 
l86cdh:
	push af			;86cd	f5 	. 
	call sub_86dbh		;86ce	cd db 86 	. . . 
	pop af			;86d1	f1 	. 
	ld bc,00006h		;86d2	01 06 00 	. . . 
	add ix,bc		;86d5	dd 09 	. . 
	dec a			;86d7	3d 	= 
	jr nz,l86cdh		;86d8	20 f3 	  . 
	ret			;86da	c9 	. 
sub_86dbh:
	bit 7,(ix+005h)		;86db	dd cb 05 7e 	. . . ~ 
	ret z			;86df	c8 	. 
	ld a,(ix+000h)		;86e0	dd 7e 00 	. ~ . 
	call sub_8cf1h		;86e3	cd f1 8c 	. . . 
	ret nz			;86e6	c0 	. 
	call sub_8c7dh		;86e7	cd 7d 8c 	. } . 
	ld (hl),000h		;86ea	36 00 	6 . 
	ret			;86ec	c9 	. 
sub_86edh:
	ld a,(07835h)		;86ed	3a 35 78 	: 5 x 
	or a			;86f0	b7 	. 
	ret nz			;86f1	c0 	. 
	ld a,(07900h)		;86f2	3a 00 79 	: . y 
	cp 035h		;86f5	fe 35 	. 5 
	ret nz			;86f7	c0 	. 
	call sub_83d2h		;86f8	cd d2 83 	. . . 
	bit 7,a		;86fb	cb 7f 	.  
	ret z			;86fd	c8 	. 
	res 7,a		;86fe	cb bf 	. . 
	cp 076h		;8700	fe 76 	. v 
	ret m			;8702	f8 	. 
	call sub_8f79h		;8703	cd 79 8f 	. y . 
	ret			;8706	c9 	. 
sub_8707h:
	ld hl,0aa86h		;8707	21 86 aa 	! . . 
	ld de,0aa87h		;870a	11 87 aa 	. . . 
	ld bc,000d0h		;870d	01 d0 00 	. . . 
	ld (hl),000h		;8710	36 00 	6 . 
	ldir		;8712	ed b0 	. . 
	ret			;8714	c9 	. 
sub_8715h:
	ld ix,07801h		;8715	dd 21 01 78 	. ! . x 
	ld a,004h		;8719	3e 04 	> . 
l871bh:
	push af			;871b	f5 	. 
	call sub_8729h		;871c	cd 29 87 	. ) . 
	pop af			;871f	f1 	. 
	ld bc,00004h		;8720	01 04 00 	. . . 
	add ix,bc		;8723	dd 09 	. . 
	dec a			;8725	3d 	= 
	jr nz,l871bh		;8726	20 f3 	  . 
	ret			;8728	c9 	. 
sub_8729h:
	bit 0,(ix+003h)		;8729	dd cb 03 46 	. . . F 
	ret z			;872d	c8 	. 
	call sub_7e45h		;872e	cd 45 7e 	. E ~ 
	ld hl,la3dfh		;8731	21 df a3 	! . . 
	ld de,0001ch		;8734	11 1c 00 	. . . 
	jr z,l873ah		;8737	28 01 	( . 
	add hl,de			;8739	19 	. 
l873ah:
	ld de,0000eh		;873a	11 0e 00 	. . . 
	bit 1,(ix+003h)		;873d	dd cb 03 4e 	. . . N 
	jr z,l8744h		;8741	28 01 	( . 
	add hl,de			;8743	19 	. 
l8744h:
	push hl			;8744	e5 	. 
	ld a,(ix+000h)		;8745	dd 7e 00 	. ~ . 
	call sub_8cf1h		;8748	cd f1 8c 	. . . 
	pop de			;874b	d1 	. 
	ret nz			;874c	c0 	. 
	ld bc,00058h		;874d	01 58 00 	. X . 
	add hl,bc			;8750	09 	. 
	ex de,hl			;8751	eb 	. 
	ld bc,00002h		;8752	01 02 00 	. . . 
	ld a,007h		;8755	3e 07 	> . 
	call sub_8d91h		;8757	cd 91 8d 	. . . 
	ret			;875a	c9 	. 
sub_875bh:
	ld ix,07801h		;875b	dd 21 01 78 	. ! . x 
	ld a,004h		;875f	3e 04 	> . 
l8761h:
	push af			;8761	f5 	. 
	call sub_876fh		;8762	cd 6f 87 	. o . 
	pop af			;8765	f1 	. 
	ld bc,00004h		;8766	01 04 00 	. . . 
	add ix,bc		;8769	dd 09 	. . 
	dec a			;876b	3d 	= 
	jr nz,l8761h		;876c	20 f3 	  . 
	ret			;876e	c9 	. 
sub_876fh:
	bit 0,(ix+003h)		;876f	dd cb 03 46 	. . . F 
	ret z			;8773	c8 	. 
	ld a,(ix+000h)		;8774	dd 7e 00 	. ~ . 
	call sub_8cf1h		;8777	cd f1 8c 	. . . 
	ret nz			;877a	c0 	. 
	ld bc,00058h		;877b	01 58 00 	. X . 
	add hl,bc			;877e	09 	. 
	ex de,hl			;877f	eb 	. 
	ld a,007h		;8780	3e 07 	> . 
	ld bc,00002h		;8782	01 02 00 	. . . 
	jp sub_8d8ah		;8785	c3 8a 8d 	. . . 
sub_8788h:
	ld ix,0786ah		;8788	dd 21 6a 78 	. ! j x 
	ld a,006h		;878c	3e 06 	> . 
l878eh:
	push af			;878e	f5 	. 
	call sub_879ch		;878f	cd 9c 87 	. . . 
	ld bc,00004h		;8792	01 04 00 	. . . 
	add ix,bc		;8795	dd 09 	. . 
	pop af			;8797	f1 	. 
	dec a			;8798	3d 	= 
	jr nz,l878eh		;8799	20 f3 	  . 
	ret			;879b	c9 	. 
sub_879ch:
	ld a,(ix+003h)		;879c	dd 7e 03 	. ~ . 
	bit 3,a		;879f	cb 5f 	. _ 
	ret z			;87a1	c8 	. 
	call sub_87ach		;87a2	cd ac 87 	. . . 
	call sub_8819h		;87a5	cd 19 88 	. . . 
	call sub_888eh		;87a8	cd 8e 88 	. . . 
	ret			;87ab	c9 	. 
sub_87ach:
	ld a,004h		;87ac	3e 04 	> . 
	ld iy,0789ah		;87ae	fd 21 9a 78 	. ! . x 
l87b2h:
	push af			;87b2	f5 	. 
	call sub_87c0h		;87b3	cd c0 87 	. . . 
	ld bc,00007h		;87b6	01 07 00 	. . . 
	add iy,bc		;87b9	fd 09 	. . 
	pop af			;87bb	f1 	. 
	dec a			;87bc	3d 	= 
	jr nz,l87b2h		;87bd	20 f3 	  . 
	ret			;87bf	c9 	. 
sub_87c0h:
	bit 7,(iy+005h)		;87c0	fd cb 05 7e 	. . . ~ 
	ret z			;87c4	c8 	. 
	ld b,(ix+000h)		;87c5	dd 46 00 	. F . 
	ld a,(iy+000h)		;87c8	fd 7e 00 	. ~ . 
	cp b			;87cb	b8 	. 
	jr z,l87d3h		;87cc	28 05 	( . 
	inc a			;87ce	3c 	< 
	cp b			;87cf	b8 	. 
	jr z,l87d3h		;87d0	28 01 	( . 
	ret			;87d2	c9 	. 
l87d3h:
	ld c,(ix+001h)		;87d3	dd 4e 01 	. N . 
	ld a,(iy+001h)		;87d6	fd 7e 01 	. ~ . 
	add a,008h		;87d9	c6 08 	. . 
	ld b,009h		;87db	06 09 	. . 
l87ddh:
	cp c			;87dd	b9 	. 
	jr z,l87e4h		;87de	28 04 	( . 
	dec a			;87e0	3d 	= 
	djnz l87ddh		;87e1	10 fa 	. . 
	ret			;87e3	c9 	. 
l87e4h:
	ld (ix+003h),000h		;87e4	dd 36 03 00 	. 6 . . 
	ld a,(iy+001h)		;87e8	fd 7e 01 	. ~ . 
	add a,008h		;87eb	c6 08 	. . 
	ld c,a			;87ed	4f 	O 
	ld b,(iy+000h)		;87ee	fd 46 00 	. F . 
	ld d,080h		;87f1	16 80 	. . 
	call sub_89c3h		;87f3	cd c3 89 	. . . 
	ld a,(iy+006h)		;87f6	fd 7e 06 	. ~ . 
	ld (iy+000h),a		;87f9	fd 77 00 	. w . 
	xor a			;87fc	af 	. 
	ld (iy+001h),a		;87fd	fd 77 01 	. w . 
	ld (iy+002h),a		;8800	fd 77 02 	. w . 
	ld (iy+003h),a		;8803	fd 77 03 	. w . 
	ld (iy+004h),a		;8806	fd 77 04 	. w . 
	ld a,r		;8809	ed 5f 	. _ 
	and 03fh		;880b	e6 3f 	. ? 
	or 007h		;880d	f6 07 	. . 
	ld (iy+005h),a		;880f	fd 77 05 	. w . 
	call sub_8f85h		;8812	cd 85 8f 	. . . 
	call sub_8f85h		;8815	cd 85 8f 	. . . 
	ret			;8818	c9 	. 
sub_8819h:
	ld a,005h		;8819	3e 05 	> . 
	ld iy,078d7h		;881b	fd 21 d7 78 	. ! . x 
l881fh:
	push af			;881f	f5 	. 
	call sub_882dh		;8820	cd 2d 88 	. - . 
	ld bc,00006h		;8823	01 06 00 	. . . 
	add iy,bc		;8826	fd 09 	. . 
	pop af			;8828	f1 	. 
	dec a			;8829	3d 	= 
	jr nz,l881fh		;882a	20 f3 	  . 
	ret			;882c	c9 	. 
sub_882dh:
	ld a,(iy+005h)		;882d	fd 7e 05 	. ~ . 
	and 03fh		;8830	e6 3f 	. ? 
	ret nz			;8832	c0 	. 
	ld c,(ix+000h)		;8833	dd 4e 00 	. N . 
	ld a,(iy+000h)		;8836	fd 7e 00 	. ~ . 
	ld b,006h		;8839	06 06 	. . 
l883bh:
	cp c			;883b	b9 	. 
	jr z,l8842h		;883c	28 04 	( . 
	inc a			;883e	3c 	< 
	djnz l883bh		;883f	10 fa 	. . 
	ret			;8841	c9 	. 
l8842h:
	ld a,(ix+001h)		;8842	dd 7e 01 	. ~ . 
	cp 009h		;8845	fe 09 	. . 
	ret p			;8847	f0 	. 
	ld b,(ix+000h)		;8848	dd 46 00 	. F . 
	ld c,(ix+001h)		;884b	dd 4e 01 	. N . 
	ld d,040h		;884e	16 40 	. @ 
	call sub_89c3h		;8850	cd c3 89 	. . . 
	ld (ix+003h),000h		;8853	dd 36 03 00 	. 6 . . 
	ld b,(iy+000h)		;8857	fd 46 00 	. F . 
	ld c,006h		;885a	0e 06 	. . 
	ld d,080h		;885c	16 80 	. . 
	call sub_89c3h		;885e	cd c3 89 	. . . 
	ld a,(iy+001h)		;8861	fd 7e 01 	. ~ . 
	ld b,002h		;8864	06 02 	. . 
	cp 001h		;8866	fe 01 	. . 
	jr z,l887eh		;8868	28 14 	( . 
	ld b,03ch		;886a	06 3c 	. < 
	cp 031h		;886c	fe 31 	. 1 
	jr z,l887eh		;886e	28 0e 	( . 
	ld b,073h		;8870	06 73 	. s 
	cp 068h		;8872	fe 68 	. h 
	jr z,l887eh		;8874	28 08 	( . 
	ld b,0a6h		;8876	06 a6 	. . 
	cp 09bh		;8878	fe 9b 	. . 
	jr z,l887eh		;887a	28 02 	( . 
	ld b,0edh		;887c	06 ed 	. . 
l887eh:
	ld (iy+000h),b		;887e	fd 70 00 	. p . 
	ld a,r		;8881	ed 5f 	. _ 
	and 0c0h		;8883	e6 c0 	. . 
	or 03fh		;8885	f6 3f 	. ? 
	ld (iy+005h),a		;8887	fd 77 05 	. w . 
	call sub_8f85h		;888a	cd 85 8f 	. . . 
	ret			;888d	c9 	. 
sub_888eh:
	ld a,004h		;888e	3e 04 	> . 
	ld iy,0788eh		;8890	fd 21 8e 78 	. ! . x 
l8894h:
	push af			;8894	f5 	. 
	call sub_88a2h		;8895	cd a2 88 	. . . 
	ld bc,00006h		;8898	01 06 00 	. . . 
	add iy,bc		;889b	fd 09 	. . 
	pop af			;889d	f1 	. 
	dec a			;889e	3d 	= 
	jr nz,l8894h		;889f	20 f3 	  . 
	ret			;88a1	c9 	. 
sub_88a2h:
	ld a,(iy+005h)		;88a2	fd 7e 05 	. ~ . 
	or a			;88a5	b7 	. 
	ret z			;88a6	c8 	. 
	ld a,(ix+000h)		;88a7	dd 7e 00 	. ~ . 
	ld c,(iy+000h)		;88aa	fd 4e 00 	. N . 
	cp c			;88ad	b9 	. 
	jr z,l88b7h		;88ae	28 07 	( . 
	inc c			;88b0	0c 	. 
	cp c			;88b1	b9 	. 
	jr z,l88b7h		;88b2	28 03 	( . 
	inc c			;88b4	0c 	. 
	cp c			;88b5	b9 	. 
	ret nz			;88b6	c0 	. 
l88b7h:
	ld a,(iy+001h)		;88b7	fd 7e 01 	. ~ . 
	add a,008h		;88ba	c6 08 	. . 
	ld c,(ix+001h)		;88bc	dd 4e 01 	. N . 
	cp c			;88bf	b9 	. 
	jr z,l88c9h		;88c0	28 07 	( . 
	dec a			;88c2	3d 	= 
	cp c			;88c3	b9 	. 
	jr z,l88c9h		;88c4	28 03 	( . 
	dec a			;88c6	3d 	= 
	cp c			;88c7	b9 	. 
	ret nz			;88c8	c0 	. 
l88c9h:
	add a,003h		;88c9	c6 03 	. . 
	ld b,(iy+000h)		;88cb	fd 46 00 	. F . 
	ld c,a			;88ce	4f 	O 
	ld d,080h		;88cf	16 80 	. . 
	call sub_89c3h		;88d1	cd c3 89 	. . . 
	ld (iy+005h),000h		;88d4	fd 36 05 00 	. 6 . . 
	ld (ix+003h),000h		;88d8	dd 36 03 00 	. 6 . . 
	call sub_8f85h		;88dc	cd 85 8f 	. . . 
	call sub_8f85h		;88df	cd 85 8f 	. . . 
	call sub_8f85h		;88e2	cd 85 8f 	. . . 
	ret			;88e5	c9 	. 
sub_88e6h:
	ld a,(07835h)		;88e6	3a 35 78 	: 5 x 
	or a			;88e9	b7 	. 
	ret nz			;88ea	c0 	. 
	push hl			;88eb	e5 	. 
	push de			;88ec	d5 	. 
	ld b,009h		;88ed	06 09 	. . 
l88efh:
	ld c,006h		;88ef	0e 06 	. . 
l88f1h:
	ld a,(hl)			;88f1	7e 	~ 
	or a			;88f2	b7 	. 
	jr z,l88f9h		;88f3	28 04 	( . 
	ld a,(de)			;88f5	1a 	. 
	or a			;88f6	b7 	. 
	jr nz,l890ah		;88f7	20 11 	  . 
l88f9h:
	inc hl			;88f9	23 	# 
	inc de			;88fa	13 	. 
	dec c			;88fb	0d 	. 
	jr nz,l88f1h		;88fc	20 f3 	  . 
	push hl			;88fe	e5 	. 
	ld hl,00026h		;88ff	21 26 00 	! & . 
	add hl,de			;8902	19 	. 
	ex de,hl			;8903	eb 	. 
	pop hl			;8904	e1 	. 
	djnz l88efh		;8905	10 e8 	. . 
	pop de			;8907	d1 	. 
	pop hl			;8908	e1 	. 
	ret			;8909	c9 	. 
l890ah:
	ld a,00ah		;890a	3e 0a 	> . 
	ld (07835h),a		;890c	32 35 78 	2 5 x 
	call sub_8ccah		;890f	cd ca 8c 	. . . 
	call sub_8b7eh		;8912	cd 7e 8b 	. ~ . 
	ld ix,0789ah		;8915	dd 21 9a 78 	. ! . x 
	ld de,00007h		;8919	11 07 00 	. . . 
	ld b,004h		;891c	06 04 	. . 
l891eh:
	call l82e1h		;891e	cd e1 82 	. . . 
	add ix,de		;8921	dd 19 	. . 
	djnz l891eh		;8923	10 f9 	. . 
	ld hl,078beh		;8925	21 be 78 	! . x 
	ld de,00006h		;8928	11 06 00 	. . . 
	ld b,005h		;892b	06 05 	. . 
l892dh:
	ld (hl),07fh		;892d	36 7f 	6  
	add hl,de			;892f	19 	. 
	djnz l892dh		;8930	10 fb 	. . 
	xor a			;8932	af 	. 
	ld (07893h),a		;8933	32 93 78 	2 . x 
	ld (07899h),a		;8936	32 99 78 	2 . x 
	call sub_83d2h		;8939	cd d2 83 	. . . 
	ld b,a			;893c	47 	G 
	ld a,(07900h)		;893d	3a 00 79 	: . y 
	ld c,a			;8940	4f 	O 
	ld a,03bh		;8941	3e 3b 	> ; 
	sub c			;8943	91 	. 
	ld c,a			;8944	4f 	O 
	inc b			;8945	04 	. 
	ld d,080h		;8946	16 80 	. . 
	call sub_89c3h		;8948	cd c3 89 	. . . 
	pop de			;894b	d1 	. 
	pop hl			;894c	e1 	. 
	ret			;894d	c9 	. 
sub_894eh:
	ld hl,0783eh		;894e	21 3e 78 	! > x 
	dec (hl)			;8951	35 	5 
	ret nz			;8952	c0 	. 
	ld (hl),019h		;8953	36 19 	6 . 
	ld ix,0786ah		;8955	dd 21 6a 78 	. ! j x 
	ld a,006h		;8959	3e 06 	> . 
l895bh:
	push af			;895b	f5 	. 
	call sub_8969h		;895c	cd 69 89 	. i . 
	ld bc,00004h		;895f	01 04 00 	. . . 
	add ix,bc		;8962	dd 09 	. . 
	pop af			;8964	f1 	. 
	dec a			;8965	3d 	= 
	jr nz,l895bh		;8966	20 f3 	  . 
	ret			;8968	c9 	. 
sub_8969h:
	bit 3,(ix+003h)		;8969	dd cb 03 5e 	. . . ^ 
	ret z			;896d	c8 	. 
	ld a,(ix+002h)		;896e	dd 7e 02 	. ~ . 
	dec a			;8971	3d 	= 
	ld (ix+002h),a		;8972	dd 77 02 	. w . 
	jr nz,l8987h		;8975	20 10 	  . 
l8977h:
	ld (ix+003h),000h		;8977	dd 36 03 00 	. 6 . . 
	ld b,(ix+000h)		;897b	dd 46 00 	. F . 
	ld c,(ix+001h)		;897e	dd 4e 01 	. N . 
	ld d,000h		;8981	16 00 	. . 
	call sub_89c3h		;8983	cd c3 89 	. . . 
	ret			;8986	c9 	. 
l8987h:
	ld a,(ix+003h)		;8987	dd 7e 03 	. ~ . 
	and 003h		;898a	e6 03 	. . 
	jr z,l89abh		;898c	28 1d 	( . 
	cp 001h		;898e	fe 01 	. . 
	jr z,l8998h		;8990	28 06 	( . 
	dec (ix+001h)		;8992	dd 35 01 	. 5 . 
	jr z,l8977h		;8995	28 e0 	( . 
	ret			;8997	c9 	. 
l8998h:
	bit 2,(ix+003h)		;8998	dd cb 03 56 	. . . V 
	jr nz,l89a3h		;899c	20 05 	  . 
	set 2,(ix+003h)		;899e	dd cb 03 d6 	. . . . 
	ret			;89a2	c9 	. 
l89a3h:
	res 2,(ix+003h)		;89a3	dd cb 03 96 	. . . . 
	inc (ix+000h)		;89a7	dd 34 00 	. 4 . 
	ret			;89aa	c9 	. 
l89abh:
	bit 2,(ix+003h)		;89ab	dd cb 03 56 	. . . V 
	jr z,l89b6h		;89af	28 05 	( . 
	res 2,(ix+003h)		;89b1	dd cb 03 96 	. . . . 
	ret			;89b5	c9 	. 
l89b6h:
	ld a,(ix+000h)		;89b6	dd 7e 00 	. ~ . 
	or a			;89b9	b7 	. 
	ret z			;89ba	c8 	. 
	dec (ix+000h)		;89bb	dd 35 00 	. 5 . 
	set 2,(ix+003h)		;89be	dd cb 03 d6 	. . . . 
	ret			;89c2	c9 	. 
sub_89c3h:
	nop			;89c3	00 	. 
	ld a,00eh		;89c4	3e 0e 	> . 
	push ix		;89c6	dd e5 	. . 
	ld ix,07840h		;89c8	dd 21 40 78 	. ! @ x 
l89cch:
	push af			;89cc	f5 	. 
	call sub_89ddh		;89cd	cd dd 89 	. . . 
	inc ix		;89d0	dd 23 	. # 
	inc ix		;89d2	dd 23 	. # 
	inc ix		;89d4	dd 23 	. # 
	pop af			;89d6	f1 	. 
	dec a			;89d7	3d 	= 
	jr nz,l89cch		;89d8	20 f2 	  . 
	pop ix		;89da	dd e1 	. . 
	ret			;89dc	c9 	. 
sub_89ddh:
	ld a,(ix+002h)		;89dd	dd 7e 02 	. ~ . 
	or a			;89e0	b7 	. 
	ret nz			;89e1	c0 	. 
	ld (ix+000h),b		;89e2	dd 70 00 	. p . 
	ld (ix+001h),c		;89e5	dd 71 01 	. q . 
	ld a,002h		;89e8	3e 02 	> . 
	or d			;89ea	b2 	. 
	ld (ix+002h),a		;89eb	dd 77 02 	. w . 
	ld a,d			;89ee	7a 	z 
	rlca			;89ef	07 	. 
	rlca			;89f0	07 	. 
	and 003h		;89f1	e6 03 	. . 
	inc a			;89f3	3c 	< 
	call sub_8f41h		;89f4	cd 41 8f 	. A . 
	pop hl			;89f7	e1 	. 
	pop hl			;89f8	e1 	. 
	pop ix		;89f9	dd e1 	. . 
	ret			;89fb	c9 	. 
sub_89fch:
	nop			;89fc	00 	. 
	ld hl,07837h		;89fd	21 37 78 	! 7 x 
	dec (hl)			;8a00	35 	5 
	ret nz			;8a01	c0 	. 
	ld b,00eh		;8a02	06 0e 	. . 
	ld ix,07840h		;8a04	dd 21 40 78 	. ! @ x 
l8a08h:
	ld a,(ix+002h)		;8a08	dd 7e 02 	. ~ . 
	push af			;8a0b	f5 	. 
	and 0c0h		;8a0c	e6 c0 	. . 
	ld c,a			;8a0e	4f 	O 
	pop af			;8a0f	f1 	. 
	and 03fh		;8a10	e6 3f 	. ? 
	jr z,l8a1dh		;8a12	28 09 	( . 
	dec a			;8a14	3d 	= 
	jr nz,l8a19h		;8a15	20 02 	  . 
	ld c,000h		;8a17	0e 00 	. . 
l8a19h:
	or c			;8a19	b1 	. 
	ld (ix+002h),a		;8a1a	dd 77 02 	. w . 
l8a1dh:
	inc ix		;8a1d	dd 23 	. # 
	inc ix		;8a1f	dd 23 	. # 
	inc ix		;8a21	dd 23 	. # 
	djnz l8a08h		;8a23	10 e3 	. . 
	ret			;8a25	c9 	. 
sub_8a26h:
	ld a,00eh		;8a26	3e 0e 	> . 
	ld ix,07840h		;8a28	dd 21 40 78 	. ! @ x 
l8a2ch:
	push af			;8a2c	f5 	. 
	call sub_8a3bh		;8a2d	cd 3b 8a 	. ; . 
	inc ix		;8a30	dd 23 	. # 
	inc ix		;8a32	dd 23 	. # 
	inc ix		;8a34	dd 23 	. # 
	pop af			;8a36	f1 	. 
	dec a			;8a37	3d 	= 
	jr nz,l8a2ch		;8a38	20 f2 	  . 
	ret			;8a3a	c9 	. 
sub_8a3bh:
	ld a,(ix+002h)		;8a3b	dd 7e 02 	. ~ . 
	and 03fh		;8a3e	e6 3f 	. ? 
	ret z			;8a40	c8 	. 
	call sub_8a90h		;8a41	cd 90 8a 	. . . 
	ret nz			;8a44	c0 	. 
	push hl			;8a45	e5 	. 
	ld b,004h		;8a46	06 04 	. . 
	ld c,002h		;8a48	0e 02 	. . 
	ld hl,la993h		;8a4a	21 93 a9 	! . . 
	ld a,(ix+002h)		;8a4d	dd 7e 02 	. ~ . 
	ld de,00008h		;8a50	11 08 00 	. . . 
	rlca			;8a53	07 	. 
	rlca			;8a54	07 	. 
	and 003h		;8a55	e6 03 	. . 
	jr z,l8a63h		;8a57	28 0a 	( . 
	add hl,de			;8a59	19 	. 
	cp 001h		;8a5a	fe 01 	. . 
	jr z,l8a63h		;8a5c	28 05 	( . 
	add hl,de			;8a5e	19 	. 
	ld b,008h		;8a5f	06 08 	. . 
	ld c,004h		;8a61	0e 04 	. . 
l8a63h:
	pop de			;8a63	d1 	. 
	call sub_8da2h		;8a64	cd a2 8d 	. . . 
	ret			;8a67	c9 	. 
sub_8a68h:
	ld a,00eh		;8a68	3e 0e 	> . 
	ld ix,07840h		;8a6a	dd 21 40 78 	. ! @ x 
l8a6eh:
	push af			;8a6e	f5 	. 
	call sub_8a7dh		;8a6f	cd 7d 8a 	. } . 
	inc ix		;8a72	dd 23 	. # 
	inc ix		;8a74	dd 23 	. # 
	inc ix		;8a76	dd 23 	. # 
	pop af			;8a78	f1 	. 
	dec a			;8a79	3d 	= 
	jr nz,l8a6eh		;8a7a	20 f2 	  . 
	ret			;8a7c	c9 	. 
sub_8a7dh:
	ld a,(ix+002h)		;8a7d	dd 7e 02 	. ~ . 
	and 03fh		;8a80	e6 3f 	. ? 
	ret z			;8a82	c8 	. 
	call sub_8a90h		;8a83	cd 90 8a 	. . . 
	ret nz			;8a86	c0 	. 
	ex de,hl			;8a87	eb 	. 
	ld bc,00004h		;8a88	01 04 00 	. . . 
	ld a,008h		;8a8b	3e 08 	> . 
	jp sub_8d8ah		;8a8d	c3 8a 8d 	. . . 
sub_8a90h:
	ld l,(ix+000h)		;8a90	dd 6e 00 	. n . 
	ld h,000h		;8a93	26 00 	& . 
	ld a,(07908h)		;8a95	3a 08 79 	: . y 
	sub 006h		;8a98	d6 06 	. . 
	ld e,a			;8a9a	5f 	_ 
	ld d,000h		;8a9b	16 00 	. . 
	or a			;8a9d	b7 	. 
	sbc hl,de		;8a9e	ed 52 	. R 
	jp m,l8abfh		;8aa0	fa bf 8a 	. . . 
	ex de,hl			;8aa3	eb 	. 
	ld hl,00025h		;8aa4	21 25 00 	! % . 
	or a			;8aa7	b7 	. 
	sbc hl,de		;8aa8	ed 52 	. R 
	jp m,l8abfh		;8aaa	fa bf 8a 	. . . 
	ld hl,0b4a4h		;8aad	21 a4 b4 	! . . 
	add hl,de			;8ab0	19 	. 
	ld de,0002ch		;8ab1	11 2c 00 	. , . 
	ld a,(ix+001h)		;8ab4	dd 7e 01 	. ~ . 
	inc a			;8ab7	3c 	< 
l8ab8h:
	dec a			;8ab8	3d 	= 
	ret z			;8ab9	c8 	. 
	or a			;8aba	b7 	. 
	sbc hl,de		;8abb	ed 52 	. R 
	jr l8ab8h		;8abd	18 f9 	. . 
l8abfh:
	ld a,001h		;8abf	3e 01 	> . 
	or a			;8ac1	b7 	. 
	ret			;8ac2	c9 	. 
sub_8ac3h:
	ld ix,0786ah		;8ac3	dd 21 6a 78 	. ! j x 
	ld a,006h		;8ac7	3e 06 	> . 
l8ac9h:
	push af			;8ac9	f5 	. 
	call sub_8ad7h		;8aca	cd d7 8a 	. . . 
	ld bc,00004h		;8acd	01 04 00 	. . . 
	add ix,bc		;8ad0	dd 09 	. . 
	pop af			;8ad2	f1 	. 
	dec a			;8ad3	3d 	= 
	jr nz,l8ac9h		;8ad4	20 f3 	  . 
	ret			;8ad6	c9 	. 
sub_8ad7h:
	bit 3,(ix+003h)		;8ad7	dd cb 03 5e 	. . . ^ 
	ret z			;8adb	c8 	. 
	ld a,(ix+000h)		;8adc	dd 7e 00 	. ~ . 
	call sub_8cf1h		;8adf	cd f1 8c 	. . . 
	ret nz			;8ae2	c0 	. 
	call sub_8c9ch		;8ae3	cd 9c 8c 	. . . 
	ld de,00160h		;8ae6	11 60 01 	. ` . 
	add hl,de			;8ae9	19 	. 
	ld a,(hl)			;8aea	7e 	~ 
	or a			;8aeb	b7 	. 
	jr nz,l8b06h		;8aec	20 18 	  . 
	ld b,005h		;8aee	06 05 	. . 
	ld a,(ix+003h)		;8af0	dd 7e 03 	. ~ . 
	and 003h		;8af3	e6 03 	. . 
	cp 002h		;8af5	fe 02 	. . 
	ld a,b			;8af7	78 	x 
	jr z,l8b04h		;8af8	28 0a 	( . 
	bit 2,(ix+003h)		;8afa	dd cb 03 56 	. . . V 
	jr nz,l8b04h		;8afe	20 04 	  . 
	rlca			;8b00	07 	. 
	rlca			;8b01	07 	. 
	rlca			;8b02	07 	. 
	rlca			;8b03	07 	. 
l8b04h:
	ld (hl),a			;8b04	77 	w 
	ret			;8b05	c9 	. 
l8b06h:
	ld b,(ix+000h)		;8b06	dd 46 00 	. F . 
	ld c,(ix+001h)		;8b09	dd 4e 01 	. N . 
	ld d,040h		;8b0c	16 40 	. @ 
	call sub_89c3h		;8b0e	cd c3 89 	. . . 
	ld (ix+003h),000h		;8b11	dd 36 03 00 	. 6 . . 
	ret			;8b15	c9 	. 
sub_8b16h:
	ld ix,0786ah		;8b16	dd 21 6a 78 	. ! j x 
	ld a,006h		;8b1a	3e 06 	> . 
l8b1ch:
	push af			;8b1c	f5 	. 
	call sub_8b2ah		;8b1d	cd 2a 8b 	. * . 
	ld bc,00004h		;8b20	01 04 00 	. . . 
	add ix,bc		;8b23	dd 09 	. . 
	pop af			;8b25	f1 	. 
	dec a			;8b26	3d 	= 
	jr nz,l8b1ch		;8b27	20 f3 	  . 
	ret			;8b29	c9 	. 
sub_8b2ah:
	bit 3,(ix+003h)		;8b2a	dd cb 03 5e 	. . . ^ 
	ret z			;8b2e	c8 	. 
	ld a,(ix+000h)		;8b2f	dd 7e 00 	. ~ . 
	call sub_8cf1h		;8b32	cd f1 8c 	. . . 
	ret nz			;8b35	c0 	. 
	call sub_8c9ch		;8b36	cd 9c 8c 	. . . 
	ld de,00160h		;8b39	11 60 01 	. ` . 
	add hl,de			;8b3c	19 	. 
	ld (hl),000h		;8b3d	36 00 	6 . 
	ret			;8b3f	c9 	. 
sub_8b40h:
	ld ix,0788eh		;8b40	dd 21 8e 78 	. ! . x 
	call sub_8b4fh		;8b44	cd 4f 8b 	. O . 
	ld ix,07894h		;8b47	dd 21 94 78 	. ! . x 
	call sub_8b4fh		;8b4b	cd 4f 8b 	. O . 
	ret			;8b4e	c9 	. 
sub_8b4fh:
	bit 0,(ix+005h)		;8b4f	dd cb 05 46 	. . . F 
	ret z			;8b53	c8 	. 
	ld a,(ix+000h)		;8b54	dd 7e 00 	. ~ . 
	call sub_8cf1h		;8b57	cd f1 8c 	. . . 
	ret nz			;8b5a	c0 	. 
	call sub_8c9ch		;8b5b	cd 9c 8c 	. . . 
	ex de,hl			;8b5e	eb 	. 
	ld hl,la963h		;8b5f	21 63 a9 	! c . 
	ld bc,00018h		;8b62	01 18 00 	. . . 
	bit 0,(ix+004h)		;8b65	dd cb 04 46 	. . . F 
	jr z,l8b6ch		;8b69	28 01 	( . 
	add hl,bc			;8b6b	09 	. 
l8b6ch:
	ld bc,0000ch		;8b6c	01 0c 00 	. . . 
	bit 0,(ix+003h)		;8b6f	dd cb 03 46 	. . . F 
	jr z,l8b76h		;8b73	28 01 	( . 
	add hl,bc			;8b75	09 	. 
l8b76h:
	ld b,003h		;8b76	06 03 	. . 
	ld c,004h		;8b78	0e 04 	. . 
	call sub_8da2h		;8b7a	cd a2 8d 	. . . 
	ret			;8b7d	c9 	. 
sub_8b7eh:
	ld ix,0788eh		;8b7e	dd 21 8e 78 	. ! . x 
	call sub_8b8dh		;8b82	cd 8d 8b 	. . . 
	ld ix,07894h		;8b85	dd 21 94 78 	. ! . x 
	call sub_8b8dh		;8b89	cd 8d 8b 	. . . 
	ret			;8b8c	c9 	. 
sub_8b8dh:
	bit 0,(ix+005h)		;8b8d	dd cb 05 46 	. . . F 
	ret z			;8b91	c8 	. 
	ld a,(ix+000h)		;8b92	dd 7e 00 	. ~ . 
	call sub_8cf1h		;8b95	cd f1 8c 	. . . 
	ret nz			;8b98	c0 	. 
	call sub_8c9ch		;8b99	cd 9c 8c 	. . . 
	ex de,hl			;8b9c	eb 	. 
	ld bc,00004h		;8b9d	01 04 00 	. . . 
	ld a,003h		;8ba0	3e 03 	> . 
	jp sub_8d8ah		;8ba2	c3 8a 8d 	. . . 
l8ba5h:
	nop			;8ba5	00 	. 
sub_8ba6h:
	ld ix,07882h		;8ba6	dd 21 82 78 	. ! . x 
	call sub_8bb5h		;8baa	cd b5 8b 	. . . 
	ld ix,07888h		;8bad	dd 21 88 78 	. ! . x 
	call sub_8bb5h		;8bb1	cd b5 8b 	. . . 
	ret			;8bb4	c9 	. 
sub_8bb5h:
	bit 7,(ix+005h)		;8bb5	dd cb 05 7e 	. . . ~ 
	ret z			;8bb9	c8 	. 
	ld a,(ix+004h)		;8bba	dd 7e 04 	. ~ . 
	or a			;8bbd	b7 	. 
	jr nz,l8bf9h		;8bbe	20 39 	  9 
	ld hl,0a6a5h		;8bc0	21 a5 a6 	! . . 
	ld de,000d8h		;8bc3	11 d8 00 	. . . 
	bit 7,(ix+003h)		;8bc6	dd cb 03 7e 	. . . ~ 
	jr z,l8bcdh		;8bca	28 01 	( . 
	add hl,de			;8bcc	19 	. 
l8bcdh:
	ld de,0006ch		;8bcd	11 6c 00 	. l . 
	bit 5,(ix+003h)		;8bd0	dd cb 03 6e 	. . . n 
	jr z,l8bd7h		;8bd4	28 01 	( . 
	add hl,de			;8bd6	19 	. 
l8bd7h:
	ld de,00036h		;8bd7	11 36 00 	. 6 . 
	bit 6,(ix+003h)		;8bda	dd cb 03 76 	. . . v 
	jr z,l8be1h		;8bde	28 01 	( . 
	add hl,de			;8be0	19 	. 
l8be1h:
	push hl			;8be1	e5 	. 
	ld a,(ix+000h)		;8be2	dd 7e 00 	. ~ . 
	call sub_8cf1h		;8be5	cd f1 8c 	. . . 
	jr nz,l8bf7h		;8be8	20 0d 	  . 
	call sub_8c9ch		;8bea	cd 9c 8c 	. . . 
	ex de,hl			;8bed	eb 	. 
	pop hl			;8bee	e1 	. 
	ld b,009h		;8bef	06 09 	. . 
	ld c,006h		;8bf1	0e 06 	. . 
	call sub_8da2h		;8bf3	cd a2 8d 	. . . 
	ret			;8bf6	c9 	. 
l8bf7h:
	pop hl			;8bf7	e1 	. 
	ret			;8bf8	c9 	. 
l8bf9h:
	ld a,(l8ba5h)		;8bf9	3a a5 8b 	: . . 
	or a			;8bfc	b7 	. 
	ret nz			;8bfd	c0 	. 
	ld a,(ix+004h)		;8bfe	dd 7e 04 	. ~ . 
	ld hl,la855h		;8c01	21 55 a8 	! U . 
	ld de,00036h		;8c04	11 36 00 	. 6 . 
l8c07h:
	dec a			;8c07	3d 	= 
	jr z,l8be1h		;8c08	28 d7 	( . 
	add hl,de			;8c0a	19 	. 
	jr l8c07h		;8c0b	18 fa 	. . 
sub_8c0dh:
	ld a,002h		;8c0d	3e 02 	> . 
	ld ix,07882h		;8c0f	dd 21 82 78 	. ! . x 
l8c13h:
	push af			;8c13	f5 	. 
	call sub_8c21h		;8c14	cd 21 8c 	. ! . 
	ld bc,00006h		;8c17	01 06 00 	. . . 
	add ix,bc		;8c1a	dd 09 	. . 
	pop af			;8c1c	f1 	. 
	dec a			;8c1d	3d 	= 
	jr nz,l8c13h		;8c1e	20 f3 	  . 
	ret			;8c20	c9 	. 
sub_8c21h:
	bit 7,(ix+005h)		;8c21	dd cb 05 7e 	. . . ~ 
	ret z			;8c25	c8 	. 
	ld a,(ix+000h)		;8c26	dd 7e 00 	. ~ . 
	call sub_8cf1h		;8c29	cd f1 8c 	. . . 
	ret nz			;8c2c	c0 	. 
	call sub_8c9ch		;8c2d	cd 9c 8c 	. . . 
	ex de,hl			;8c30	eb 	. 
	ld bc,00006h		;8c31	01 06 00 	. . . 
	ld a,009h		;8c34	3e 09 	> . 
	jp sub_8d8ah		;8c36	c3 8a 8d 	. . . 
sub_8c39h:
	ld a,005h		;8c39	3e 05 	> . 
	ld ix,078d7h		;8c3b	dd 21 d7 78 	. ! . x 
l8c3fh:
	push af			;8c3f	f5 	. 
	call sub_8d16h		;8c40	cd 16 8d 	. . . 
	pop af			;8c43	f1 	. 
	ld bc,00006h		;8c44	01 06 00 	. . . 
	add ix,bc		;8c47	dd 09 	. . 
	dec a			;8c49	3d 	= 
	jr nz,l8c3fh		;8c4a	20 f3 	  . 
	ret			;8c4c	c9 	. 
sub_8c4dh:
	ld a,005h		;8c4d	3e 05 	> . 
	ld ix,078b9h		;8c4f	dd 21 b9 78 	. ! . x 
l8c53h:
	push af			;8c53	f5 	. 
	call sub_8c61h		;8c54	cd 61 8c 	. a . 
	ld bc,00006h		;8c57	01 06 00 	. . . 
	add ix,bc		;8c5a	dd 09 	. . 
	pop af			;8c5c	f1 	. 
	dec a			;8c5d	3d 	= 
	jr nz,l8c53h		;8c5e	20 f3 	  . 
	ret			;8c60	c9 	. 
sub_8c61h:
	ld a,(ix+005h)		;8c61	dd 7e 05 	. ~ . 
	bit 7,a		;8c64	cb 7f 	.  
	ret z			;8c66	c8 	. 
	ld a,(ix+000h)		;8c67	dd 7e 00 	. ~ . 
	call sub_8cf1h		;8c6a	cd f1 8c 	. . . 
	ret nz			;8c6d	c0 	. 
	call sub_8c7dh		;8c6e	cd 7d 8c 	. } . 
	ld b,(ix+004h)		;8c71	dd 46 04 	. F . 
	inc b			;8c74	04 	. 
	ld a,003h		;8c75	3e 03 	> . 
l8c77h:
	rrca			;8c77	0f 	. 
	rrca			;8c78	0f 	. 
	djnz l8c77h		;8c79	10 fc 	. . 
	ld (hl),a			;8c7b	77 	w 
	ret			;8c7c	c9 	. 
sub_8c7dh:
	ld a,(ix+001h)		;8c7d	dd 7e 01 	. ~ . 
	ld de,0002ch		;8c80	11 2c 00 	. , . 
l8c83h:
	add hl,de			;8c83	19 	. 
	dec a			;8c84	3d 	= 
	jr nz,l8c83h		;8c85	20 fc 	  . 
	ret			;8c87	c9 	. 
sub_8c88h:
	ld a,004h		;8c88	3e 04 	> . 
	ld ix,0789ah		;8c8a	dd 21 9a 78 	. ! . x 
l8c8eh:
	push af			;8c8e	f5 	. 
	call sub_8caah		;8c8f	cd aa 8c 	. . . 
	ld bc,00007h		;8c92	01 07 00 	. . . 
	add ix,bc		;8c95	dd 09 	. . 
	pop af			;8c97	f1 	. 
	dec a			;8c98	3d 	= 
	jr nz,l8c8eh		;8c99	20 f3 	  . 
	ret			;8c9b	c9 	. 
sub_8c9ch:
	ld a,(ix+001h)		;8c9c	dd 7e 01 	. ~ . 
	ld de,0002ch		;8c9f	11 2c 00 	. , . 
	inc a			;8ca2	3c 	< 
l8ca3h:
	dec a			;8ca3	3d 	= 
	ret z			;8ca4	c8 	. 
	or a			;8ca5	b7 	. 
	sbc hl,de		;8ca6	ed 52 	. R 
	jr l8ca3h		;8ca8	18 f9 	. . 
sub_8caah:
	ld a,(ix+000h)		;8caa	dd 7e 00 	. ~ . 
	call sub_8cf1h		;8cad	cd f1 8c 	. . . 
	ret nz			;8cb0	c0 	. 
	call sub_8c9ch		;8cb1	cd 9c 8c 	. . . 
	ex de,hl			;8cb4	eb 	. 
	ld hl,la66fh		;8cb5	21 6f a6 	! o . 
	ld bc,00012h		;8cb8	01 12 00 	. . . 
	ld a,(ix+004h)		;8cbb	dd 7e 04 	. ~ . 
	or a			;8cbe	b7 	. 
	jr z,l8cc2h		;8cbf	28 01 	( . 
	add hl,bc			;8cc1	09 	. 
l8cc2h:
	ld b,009h		;8cc2	06 09 	. . 
	ld c,002h		;8cc4	0e 02 	. . 
	call sub_8da2h		;8cc6	cd a2 8d 	. . . 
	ret			;8cc9	c9 	. 
sub_8ccah:
	ld a,004h		;8cca	3e 04 	> . 
	ld ix,0789ah		;8ccc	dd 21 9a 78 	. ! . x 
l8cd0h:
	push af			;8cd0	f5 	. 
	call sub_8cdeh		;8cd1	cd de 8c 	. . . 
	ld bc,00007h		;8cd4	01 07 00 	. . . 
	add ix,bc		;8cd7	dd 09 	. . 
	pop af			;8cd9	f1 	. 
	dec a			;8cda	3d 	= 
	jr nz,l8cd0h		;8cdb	20 f3 	  . 
	ret			;8cdd	c9 	. 
sub_8cdeh:
	ld a,(ix+000h)		;8cde	dd 7e 00 	. ~ . 
	call sub_8cf1h		;8ce1	cd f1 8c 	. . . 
	ret nz			;8ce4	c0 	. 
	call sub_8c9ch		;8ce5	cd 9c 8c 	. . . 
	ex de,hl			;8ce8	eb 	. 
	ld bc,00002h		;8ce9	01 02 00 	. . . 
	ld a,009h		;8cec	3e 09 	> . 
	jp sub_8d8ah		;8cee	c3 8a 8d 	. . . 
sub_8cf1h:
	ld l,a			;8cf1	6f 	o 
	ld h,000h		;8cf2	26 00 	& . 
	ld a,(07908h)		;8cf4	3a 08 79 	: . y 
	sub 006h		;8cf7	d6 06 	. . 
	ld e,a			;8cf9	5f 	_ 
	ld d,000h		;8cfa	16 00 	. . 
	or a			;8cfc	b7 	. 
	sbc hl,de		;8cfd	ed 52 	. R 
	jp m,l8d12h		;8cff	fa 12 8d 	. . . 
	ex de,hl			;8d02	eb 	. 
	ld hl,00025h		;8d03	21 25 00 	! % . 
	or a			;8d06	b7 	. 
	sbc hl,de		;8d07	ed 52 	. R 
	jp m,l8d12h		;8d09	fa 12 8d 	. . . 
	ld hl,0b3c8h		;8d0c	21 c8 b3 	! . . 
	add hl,de			;8d0f	19 	. 
	xor a			;8d10	af 	. 
	ret			;8d11	c9 	. 
l8d12h:
	ld a,001h		;8d12	3e 01 	> . 
	or a			;8d14	b7 	. 
	ret			;8d15	c9 	. 
sub_8d16h:
	ld a,(ix+005h)		;8d16	dd 7e 05 	. ~ . 
	or a			;8d19	b7 	. 
	ret nz			;8d1a	c0 	. 
	ld a,(ix+000h)		;8d1b	dd 7e 00 	. ~ . 
	call sub_8cf1h		;8d1e	cd f1 8c 	. . . 
	ret nz			;8d21	c0 	. 
	ex de,hl			;8d22	eb 	. 
	ld hl,la597h		;8d23	21 97 a5 	! . . 
	ld bc,0006ch		;8d26	01 6c 00 	. l . 
	ld a,(ix+004h)		;8d29	dd 7e 04 	. ~ . 
	and 001h		;8d2c	e6 01 	. . 
	jr z,l8d31h		;8d2e	28 01 	( . 
	add hl,bc			;8d30	09 	. 
l8d31h:
	ld bc,00036h		;8d31	01 36 00 	. 6 . 
	ld a,(ix+003h)		;8d34	dd 7e 03 	. ~ . 
	or a			;8d37	b7 	. 
	jr z,l8d3bh		;8d38	28 01 	( . 
	add hl,bc			;8d3a	09 	. 
l8d3bh:
	ld c,006h		;8d3b	0e 06 	. . 
	ld b,009h		;8d3d	06 09 	. . 
	call sub_8da2h		;8d3f	cd a2 8d 	. . . 
	ret			;8d42	c9 	. 
sub_8d43h:
	ld a,(07835h)		;8d43	3a 35 78 	: 5 x 
	or a			;8d46	b7 	. 
	jr z,l8d4ch		;8d47	28 03 	( . 
	cp 00ah		;8d49	fe 0a 	. . 
	ret m			;8d4b	f8 	. 
l8d4ch:
	ld hl,la100h		;8d4c	21 00 a1 	! . . 
	ld a,(07902h)		;8d4f	3a 02 79 	: . y 
	and 003h		;8d52	e6 03 	. . 
	ld de,0006ch		;8d54	11 6c 00 	. l . 
	inc a			;8d57	3c 	< 
l8d58h:
	dec a			;8d58	3d 	= 
	jr z,l8d5eh		;8d59	28 03 	( . 
	add hl,de			;8d5b	19 	. 
	jr l8d58h		;8d5c	18 fa 	. . 
l8d5eh:
	ld de,00144h		;8d5e	11 44 01 	. D . 
	ld a,(07904h)		;8d61	3a 04 79 	: . y 
	or a			;8d64	b7 	. 
	jr z,l8d68h		;8d65	28 01 	( . 
	add hl,de			;8d67	19 	. 
l8d68h:
	ld de,00036h		;8d68	11 36 00 	. 6 . 
	ld a,(07903h)		;8d6b	3a 03 79 	: . y 
	or a			;8d6e	b7 	. 
	jr z,l8d72h		;8d6f	28 01 	( . 
	add hl,de			;8d71	19 	. 
l8d72h:
	ld de,(078feh)		;8d72	ed 5b fe 78 	. [ . x 
	call sub_88e6h		;8d76	cd e6 88 	. . . 
	ld c,006h		;8d79	0e 06 	. . 
	ld b,009h		;8d7b	06 09 	. . 
	call sub_8da2h		;8d7d	cd a2 8d 	. . . 
	ret			;8d80	c9 	. 
sub_8d81h:
	ld de,(078feh)		;8d81	ed 5b fe 78 	. [ . x 
	ld bc,00006h		;8d85	01 06 00 	. . . 
	ld a,009h		;8d88	3e 09 	> . 
sub_8d8ah:
	ld hl,la527h		;8d8a	21 27 a5 	! ' . 
	call sub_8d91h		;8d8d	cd 91 8d 	. . . 
	ret			;8d90	c9 	. 
sub_8d91h:
	push bc			;8d91	c5 	. 
	push de			;8d92	d5 	. 
	ldir		;8d93	ed b0 	. . 
	pop de			;8d95	d1 	. 
	push hl			;8d96	e5 	. 
	ld hl,0002ch		;8d97	21 2c 00 	! , . 
	add hl,de			;8d9a	19 	. 
	ex de,hl			;8d9b	eb 	. 
	pop hl			;8d9c	e1 	. 
	pop bc			;8d9d	c1 	. 
	dec a			;8d9e	3d 	= 
	jr nz,sub_8d91h		;8d9f	20 f0 	  . 
	ret			;8da1	c9 	. 
sub_8da2h:
	push bc			;8da2	c5 	. 
	push de			;8da3	d5 	. 
l8da4h:
	ld a,(de)			;8da4	1a 	. 
	or (hl)			;8da5	b6 	. 
	ld (de),a			;8da6	12 	. 
	inc hl			;8da7	23 	# 
	inc de			;8da8	13 	. 
	dec c			;8da9	0d 	. 
	jr nz,l8da4h		;8daa	20 f8 	  . 
	pop de			;8dac	d1 	. 
	push hl			;8dad	e5 	. 
	ld hl,0002ch		;8dae	21 2c 00 	! , . 
	add hl,de			;8db1	19 	. 
	ex de,hl			;8db2	eb 	. 
	pop hl			;8db3	e1 	. 
	pop bc			;8db4	c1 	. 
	dec b			;8db5	05 	. 
	jr nz,sub_8da2h		;8db6	20 ea 	  . 
	ret			;8db8	c9 	. 
sub_8db9h:
	ld hl,0b55ah		;8db9	21 5a b5 	! Z . 
	ld de,0b55bh		;8dbc	11 5b b5 	. [ . 
	ld bc,0001fh		;8dbf	01 1f 00 	. . . 
	ld (hl),055h		;8dc2	36 55 	6 U 
	ldir		;8dc4	ed b0 	. . 
	ld hl,0aa86h		;8dc6	21 86 aa 	! . . 
	ld de,VRAM				; Video Memory address (0,0)						;8dc9	11 00 70
	ld c,020h		;8dcc	0e 20 	.   
	ld b,040h		;8dce	06 40 	. @ 
l8dd0h:
	push bc			;8dd0	c5 	. 
	ld b,000h		;8dd1	06 00 	. . 
	ldir		;8dd3	ed b0 	. . 
	ld bc,0000ch		;8dd5	01 0c 00 	. . . 
	add hl,bc			;8dd8	09 	. 
	pop bc			;8dd9	c1 	. 
	dec b			;8dda	05 	. 
	jr nz,l8dd0h		;8ddb	20 f3 	  . 
	ret			;8ddd	c9 	. 
sub_8ddeh:
	ld hl,0aa80h		;8dde	21 80 aa 	! . . 
	ld de,0aa81h		;8de1	11 81 aa 	. . . 
	ld bc,00affh		;8de4	01 ff 0a 	. . . 
	ld (hl),000h		;8de7	36 00 	6 . 
	ldir		;8de9	ed b0 	. . 
; -- Clear Screen and set Graphics MODE 1
	ld hl,VRAM				; src - video memory start							;8deb	21 00 70 
	ld de,VRAM+1			; dst - next byte									;8dee	11 01 70 
	ld bc,2047				; ctn - size of video memory in MODE 1 (gfx)		;8df1	01 ff 07
	ld (hl),0				; 4 green (background) pixels						;8df4	36 00
	ldir					; fill VRAM with green pixels						;8df6	ed b0 
; -- set Video Graphics Mode 1, Color Palette 0
	ld a,VDG_GFX_COLORS_0	; VDG Gfx MODE 1 Colors (Green/Yellow/Blue/Red)	 	;8df8	3e 08 
	ld (IOLATCH),a			; store to hardware register						;8dfa	32 00 68 
	ret						; ----------------- End of Proc ---------------		;8dfd	c9 

sub_8dfeh:
	ld ix,0781fh		;8dfe	dd 21 1f 78 	. ! . x 
	call sub_8e0fh		;8e02	cd 0f 8e 	. . . 
	call sub_8e0fh		;8e05	cd 0f 8e 	. . . 
	call sub_8e0fh		;8e08	cd 0f 8e 	. . . 
	call sub_8e0fh		;8e0b	cd 0f 8e 	. . . 
	ret			;8e0e	c9 	. 
sub_8e0fh:
	ld a,(ix+000h)		;8e0f	dd 7e 00 	. ~ . 
	inc ix		;8e12	dd 23 	. # 
	call sub_8cf1h		;8e14	cd f1 8c 	. . . 
	ret nz			;8e17	c0 	. 
	ld de,la693h		;8e18	11 93 a6 	. . . 
	ex de,hl			;8e1b	eb 	. 
	ld b,009h		;8e1c	06 09 	. . 
	ld c,002h		;8e1e	0e 02 	. . 
	call sub_8da2h		;8e20	cd a2 8d 	. . . 
	ret			;8e23	c9 	. 
sub_8e24h:
	ld ix,07823h		;8e24	dd 21 23 78 	. ! # x 
	ld a,008h		;8e28	3e 08 	> . 
l8e2ah:
	push af			;8e2a	f5 	. 
	call sub_8e35h		;8e2b	cd 35 8e 	. 5 . 
	pop af			;8e2e	f1 	. 
	inc ix		;8e2f	dd 23 	. # 
	dec a			;8e31	3d 	= 
	jr nz,l8e2ah		;8e32	20 f6 	  . 
	ret			;8e34	c9 	. 
sub_8e35h:
	ld a,(ix+000h)		;8e35	dd 7e 00 	. ~ . 
	call sub_8cf1h		;8e38	cd f1 8c 	. . . 
	ret nz			;8e3b	c0 	. 
	call sub_8ee1h		;8e3c	cd e1 8e 	. . . 
	ld de,la388h		;8e3f	11 88 a3 	. . . 
	ex de,hl			;8e42	eb 	. 
	ld b,010h		;8e43	06 10 	. . 
	ld c,002h		;8e45	0e 02 	. . 
	call sub_8da2h		;8e47	cd a2 8d 	. . . 
	ret			;8e4a	c9 	. 
sub_8e4bh:
	ld ix,0782bh		;8e4b	dd 21 2b 78 	. ! + x 
	call sub_8e5ch		;8e4f	cd 5c 8e 	. \ . 
	call sub_8e5ch		;8e52	cd 5c 8e 	. \ . 
	call sub_8e5ch		;8e55	cd 5c 8e 	. \ . 
	call sub_8e5ch		;8e58	cd 5c 8e 	. \ . 
	ret			;8e5b	c9 	. 
sub_8e5ch:
	ld a,(ix+000h)		;8e5c	dd 7e 00 	. ~ . 
	inc ix		;8e5f	dd 23 	. # 
	call sub_8cf1h		;8e61	cd f1 8c 	. . . 
	ret nz			;8e64	c0 	. 
	call sub_8ee5h		;8e65	cd e5 8e 	. . . 
	ld de,la3a8h		;8e68	11 a8 a3 	. . . 
	ex de,hl			;8e6b	eb 	. 
	ld b,00bh		;8e6c	06 0b 	. . 
	ld c,005h		;8e6e	0e 05 	. . 
	call sub_8da2h		;8e70	cd a2 8d 	. . . 
	ret			;8e73	c9 	. 
sub_8e74h:
	ld ix,0781fh		;8e74	dd 21 1f 78 	. ! . x 
	call sub_8e85h		;8e78	cd 85 8e 	. . . 
	call sub_8e85h		;8e7b	cd 85 8e 	. . . 
	call sub_8e85h		;8e7e	cd 85 8e 	. . . 
	call sub_8e85h		;8e81	cd 85 8e 	. . . 
	ret			;8e84	c9 	. 
sub_8e85h:
	ld a,(ix+000h)		;8e85	dd 7e 00 	. ~ . 
	inc ix		;8e88	dd 23 	. # 
	call sub_8cf1h		;8e8a	cd f1 8c 	. . . 
	ret nz			;8e8d	c0 	. 
	ex de,hl			;8e8e	eb 	. 
	ld bc,00002h		;8e8f	01 02 00 	. . . 
	ld a,009h		;8e92	3e 09 	> . 
	jp sub_8d8ah		;8e94	c3 8a 8d 	. . . 
sub_8e97h:
	ld ix,07823h		;8e97	dd 21 23 78 	. ! # x 
	ld a,008h		;8e9b	3e 08 	> . 
l8e9dh:
	push af			;8e9d	f5 	. 
	call sub_8ea8h		;8e9e	cd a8 8e 	. . . 
	pop af			;8ea1	f1 	. 
	inc ix		;8ea2	dd 23 	. # 
	dec a			;8ea4	3d 	= 
	jr nz,l8e9dh		;8ea5	20 f6 	  . 
	ret			;8ea7	c9 	. 
sub_8ea8h:
	ld a,(ix+000h)		;8ea8	dd 7e 00 	. ~ . 
	call sub_8cf1h		;8eab	cd f1 8c 	. . . 
	ret nz			;8eae	c0 	. 
	call sub_8ee1h		;8eaf	cd e1 8e 	. . . 
	ex de,hl			;8eb2	eb 	. 
	ld bc,00002h		;8eb3	01 02 00 	. . . 
	ld a,010h		;8eb6	3e 10 	> . 
	jp sub_8d8ah		;8eb8	c3 8a 8d 	. . . 
sub_8ebbh:
	ld ix,0782bh		;8ebb	dd 21 2b 78 	. ! + x 
	call sub_8ecch		;8ebf	cd cc 8e 	. . . 
	call sub_8ecch		;8ec2	cd cc 8e 	. . . 
	call sub_8ecch		;8ec5	cd cc 8e 	. . . 
	call sub_8ecch		;8ec8	cd cc 8e 	. . . 
	ret			;8ecb	c9 	. 
sub_8ecch:
	ld a,(ix+000h)		;8ecc	dd 7e 00 	. ~ . 
	inc ix		;8ecf	dd 23 	. # 
	call sub_8cf1h		;8ed1	cd f1 8c 	. . . 
	ret nz			;8ed4	c0 	. 
	call sub_8ee5h		;8ed5	cd e5 8e 	. . . 
	ex de,hl			;8ed8	eb 	. 
	ld bc,00005h		;8ed9	01 05 00 	. . . 
	ld a,00bh		;8edc	3e 0b 	> . 
	jp sub_8d8ah		;8ede	c3 8a 8d 	. . . 
sub_8ee1h:
	ld b,007h		;8ee1	06 07 	. . 
	jr l8ee7h		;8ee3	18 02 	. . 
sub_8ee5h:
	ld b,002h		;8ee5	06 02 	. . 
l8ee7h:
	ld de,0002ch		;8ee7	11 2c 00 	. , . 
	or a			;8eea	b7 	. 
	sbc hl,de		;8eeb	ed 52 	. R 
	djnz l8ee7h		;8eed	10 f8 	. . 
	ret			;8eef	c9 	. 
sub_8ef0h:
	ld a,(07835h)		;8ef0	3a 35 78 	: 5 x 
	or a			;8ef3	b7 	. 
	jr z,READ_INPUT		;8ef4	28 02 	( . 
	xor a			;8ef6	af 	. 
	ret			;8ef7	c9 	. 


;***********************************************************************************************
; Read keys and joystick (if allowed by player)
; OUT: a - bitmask with input events (keys or joystick) 
;          bit 0 - UP, bit 1 - DOWN, bit 2 - LEFT, bit 3 - RIGHT, bit 4 - FIRE, bit 5 - ROTATE

READ_INPUT:
	ld c,%00000000			; initial empty bitmask - no input detected				;8ef8	0e 00 
TEST_KEY_Q
	ld a,(KEYS_ROW_0F)		; select Keyboard row 0 								;8efa	3a fe 6f 
	bit 4,a					; check if key 'Q' is pressed							;8efd	cb 67 
	jr nz,TEST_KEY_A		; no - check next key									;8eff	20 02 
; -- set bit UP in input bitmask variable
	set UP,c				; set bit for UP key pressed							;8f01	cb c1 
TEST_KEY_A:
	ld a,(KEYS_ROW_1F)		; select Keyboard row 1 								;8f03	3a fd 6f 
	bit 4,a					; check if key 'A' is pressed							;8f06	cb 67 
	jr nz,TEST_KEY_M		; no - check next key									;8f08	20 02 
; -- set bit DOWN in input bitmask variable
	set DOWN,c				; set bit for DOWN key pressed							;8f0a	cb c9
TEST_KEY_M:
	ld a,(KEYS_ROW_4F)		; select Keyboard row 4 								;8f0c	3a ef 6f 
	bit 5,a					; check if key 'M' pressed								;8f0f	cb 6f
	jr nz,TEST_KEY_COMMA	; no - check next key									;8f11	20 02 
; -- set bit LEFT in input bitmask variable
	set LEFT,c				; set bit for LEFT key pressed							;8f13	cb d1
TEST_KEY_COMMA:
	cpl						; invert bits - 1 means key pressed	 					;8f15	2f
	and %00011000			; mask keys ',' (RIGHT) and SPACE (FIRE)				;8f16	e6 18
; -- set bit RIGHT and/or FIRE if key pressed
	or c					; a - bitmask with inputs detected						;8f18	b1 
	ld c,a					; store to local variable								;8f19	4f 
TEST_KEY_Z
	ld a,(KEYS_ROW_2F)		; select Keyboard row 2									;8f1a	3a fb 6f
	cpl						; invert bits - 1 means key pressed						;8f1d	2f 
	and %00010000			; mask on key 'Z' (bit FIRE)							;8f1e	e6 10 
; -- set bit FIRE if key 'Z' is pressed
	or c					; a - all detected keys									;8f20	b1 
	ld a,c					; BUG - seems like should be ld c,a instad				;8f21	79 
TEST_KEY_N
	ld a,(KEYS_ROW_4)		; select Keyboard row 4 								;8f22	3a ef 68 
	bit 0,a					; check if key 'N' pressed								;8f25	cb 47 
	jr nz,l8f2bh			; no - return if any key detected						;8f27	20 02 
; -- set bit ROTATE in input bitmask variable
	set ROTATE,c			; set bit for ROTATE key pressed						;8f29	cb e9 
l8f2bh:
	ld a,c					; a - all detected keys									;8f2b	79 
	or a					; is any key detected?									;8f2c	b7
	ret nz					; yes ------------- End of Proc ----------------------- ;8f2d	c0 
; -- no keys pressed detected - check joystick if enabled 
	ld a,(JOY_ENABLE)		; a - Joystick Enabled Flag								;8f2e	3a 00 78
	or a					; is Joystick enabled? 									;8f31	b7 
	ret z					; no -------------- End of Proc (no input detected) ---	;8f32	c8
; -- check joystick 1 - moves and fire	
	in a,(JOY_PORT_1)		; read Joystick 1										;8f33	db 2a 
	cpl						; invert bits - 1 means joystick move/fire				;8f35	2f
	and %00011111			; mask UP/DOWN/LEFT/RIGHT/FIRE							;8f36	e6 1f 
	ld c,a					; store to local bitmask variable						;8f38	4f 
; -- check joystick 2 - fire as ROTATE
	in a,(JOY_PORT_2)		; read Joystick 2										;8f39	db 25  
	cpl						; invert bits - 1 means joystick move/fire				;8f3b	2f 
	rlca					; shift value so FIRE bit is placed as ROTATE (5) bit	;8f3c	07 
	and %00100000			; mask only ROTATE bit									;8f3d	e6 20 
	or c					; add already detected input bits from Joystick 1 		;8f3f	b1 
	ret						; ----------------- End of Proc (input detected)		;8f40	c9 



sub_8f41h:
	ld bc,02080h		;8f41	01 80 20 	. .   
	dec a			;8f44	3d 	= 
	jr z,l8f56h		;8f45	28 0f 	( . 
	ld bc,03060h		;8f47	01 60 30 	. ` 0 
	dec a			;8f4a	3d 	= 
	jr z,l8f56h		;8f4b	28 09 	( . 
	ld bc,04040h		;8f4d	01 40 40 	. @ @ 
	dec a			;8f50	3d 	= 
	jr z,l8f56h		;8f51	28 03 	( . 
	ld bc,sub_801fh+1		;8f53	01 20 80 	.   . 
l8f56h:
	ld a,028h		;8f56	3e 28 	> ( 
	ld (IOLATCH),a		;8f58	32 00 68 	2 . h 
	call sub_8f6ah		;8f5b	cd 6a 8f 	. j . 
	ld a,009h		;8f5e	3e 09 	> . 
	ld (IOLATCH),a		;8f60	32 00 68 	2 . h 
	call sub_8f6ah		;8f63	cd 6a 8f 	. j . 
	dec c			;8f66	0d 	. 
	jr nz,l8f56h		;8f67	20 ed 	  . 
	ret			;8f69	c9 	. 
sub_8f6ah:
	push bc			;8f6a	c5 	. 
l8f6bh:
	dec b			;8f6b	05 	. 
	jr nz,l8f6bh		;8f6c	20 fd 	  . 
	pop bc			;8f6e	c1 	. 
	ret			;8f6f	c9 	. 


;***********************************************************************************************
;
;    G A M E   J U M P   T A B L E
;
;***********************************************************************************************

sub_8f70h:
	jp l97fch		;8f70	c3 fc 97 	. . . 
sub_8f73h:
	jp l9786h		;8f73	c3 86 97 	. . . 
sub_8f76h:
	jp l97b7h		;8f76	c3 b7 97 	. . . 
sub_8f79h:
	jp l9712h		;8f79	c3 12 97 	. . . 
l8f7ch:
	jp l8fcbh		;8f7c	c3 cb 8f 	. . . 
l8f7fh:
	jp l9056h		;8f7f	c3 56 90 	. V . 
JMP_GAME_INIT:
	jp GAME_INIT			; jump to GAME_INIT routine							;8f82	c3 88 8f 
sub_8f85h:
	jp l9774h		;8f85	c3 74 97 	. t . 


;***********************************************************************************************
;
;    G A M E   I N I T
;
;***********************************************************************************************
GAME_INIT:
	di						; disable interrupts								;8f88	f3 
	ld sp,BASE_SP			; reset CPU Stack Pointer to base address			;8f89	31 f0 7c 
	call sub_944bh		;8f8c	cd 4b 94 	. K . 
	ld hl,TXT_JOYSTICK_Q	; text to display - Joystick Question				;8f8f	21 c5 9a 
	ld de,VRAM				; dst - screen position (0,0)						;8f92	11 00 70 
	call sub_9423h		;8f95	cd 23 94 	. # . 
l8f98h:
	xor a			;8f98	af 	. 
	ld (JOY_ENABLE),a		;8f99	32 00 78 	2 . x 
	ld a,(KEYS_ROW_4)		;8f9c	3a ef 68 	: . h 
	bit 0,a		;8f9f	cb 47 	. G 
	jp z,l8fb1h		;8fa1	ca b1 8f 	. . . 
	ld a,001h		;8fa4	3e 01 	> . 
	ld (JOY_ENABLE),a		;8fa6	32 00 78 	2 . x 
	ld a,(KEYS_ROW_6)		;8fa9	3a bf 68 	: . h 
	bit 0,a		;8fac	cb 47 	. G 
	jp nz,l8f98h		;8fae	c2 98 8f 	. . . 
l8fb1h:
	ld hl,l96e0h		;8fb1	21 e0 96 	! . . 
	ld de,l96e1h		;8fb4	11 e1 96 	. . . 
	ld (hl),000h		;8fb7	36 00 	6 . 
	ld bc,00031h		;8fb9	01 31 00 	. 1 . 
	ldir		;8fbc	ed b0 	. . 
	ld hl,l96aeh		;8fbe	21 ae 96 	! . . 
	ld de,l96afh		;8fc1	11 af 96 	. . . 
	ld bc,00031h		;8fc4	01 31 00 	. 1 . 
	ld (hl),02eh		;8fc7	36 2e 	6 . 
	ldir		;8fc9	ed b0 	. . 
l8fcbh:
	di			;8fcb	f3 	. 
	ld sp,BASE_SP			; reset CPU Stack Pointer to base address			;8fcc	31 f0 7c 
	ld hl,00020h		;8fcf	21 20 00 	!   . 
	ld (l98abh),hl		;8fd2	22 ab 98 	" . . 
	call sub_9446h		;8fd5	cd 46 94 	. F . 
	ld hl,l9581h		;8fd8	21 81 95 	! . . 
	ld de,0aa80h		;8fdb	11 80 aa 	. . . 
	call sub_9423h		;8fde	cd 23 94 	. # . 
	call sub_930eh		;8fe1	cd 0e 93 	. . . 
	call sub_9446h		;8fe4	cd 46 94 	. F . 
	ld hl,l95f7h		;8fe7	21 f7 95 	! . . 
	ld de,0aa80h		;8fea	11 80 aa 	. . . 
	call sub_9423h		;8fed	cd 23 94 	. # . 
	call sub_930eh		;8ff0	cd 0e 93 	. . . 
	call sub_8ff8h		;8ff3	cd f8 8f 	. . . 
	jr l8fcbh		;8ff6	18 d3 	. . 
sub_8ff8h:
	call sub_8fffh		;8ff8	cd ff 8f 	. . . 
	call sub_930eh		;8ffb	cd 0e 93 	. . . 
	ret			;8ffe	c9 	. 
sub_8fffh:
	call sub_9446h		;8fff	cd 46 94 	. F . 
	ld hl,l96aeh		;9002	21 ae 96 	! . . 
	ld de,0aac8h		;9005	11 c8 aa 	. . . 
	ld a,00ah		;9008	3e 0a 	> . 
l900ah:
	push af			;900a	f5 	. 
	ld a,005h		;900b	3e 05 	> . 
l900dh:
	push af			;900d	f5 	. 
	push de			;900e	d5 	. 
	push hl			;900f	e5 	. 
	ld a,(hl)			;9010	7e 	~ 
	call sub_98e9h		;9011	cd e9 98 	. . . 
	pop hl			;9014	e1 	. 
	pop de			;9015	d1 	. 
	inc hl			;9016	23 	# 
	inc de			;9017	13 	. 
	pop af			;9018	f1 	. 
	dec a			;9019	3d 	= 
	jr nz,l900dh		;901a	20 f1 	  . 
	push hl			;901c	e5 	. 
	push de			;901d	d5 	. 
	inc de			;901e	13 	. 
	inc de			;901f	13 	. 
	ld a,03dh		;9020	3e 3d 	> = 
	call sub_98e9h		;9022	cd e9 98 	. . . 
	pop de			;9025	d1 	. 
	ld hl,000bbh		;9026	21 bb 00 	! . . 
	add hl,de			;9029	19 	. 
	ex de,hl			;902a	eb 	. 
	pop hl			;902b	e1 	. 
	pop af			;902c	f1 	. 
	dec a			;902d	3d 	= 
	jr nz,l900ah		;902e	20 da 	  . 
	ld hl,l96e0h		;9030	21 e0 96 	! . . 
	ld de,0aad2h		;9033	11 d2 aa 	. . . 
	ld a,00ah		;9036	3e 0a 	> . 
l9038h:
	push af			;9038	f5 	. 
	ld a,005h		;9039	3e 05 	> . 
l903bh:
	push af			;903b	f5 	. 
	push de			;903c	d5 	. 
	push hl			;903d	e5 	. 
	ld a,(hl)			;903e	7e 	~ 
	call sub_9889h		;903f	cd 89 98 	. . . 
	pop hl			;9042	e1 	. 
	pop de			;9043	d1 	. 
	inc hl			;9044	23 	# 
	inc de			;9045	13 	. 
	pop af			;9046	f1 	. 
	dec a			;9047	3d 	= 
	jr nz,l903bh		;9048	20 f1 	  . 
	push hl			;904a	e5 	. 
	ld hl,000bbh		;904b	21 bb 00 	! . . 
	add hl,de			;904e	19 	. 
	ex de,hl			;904f	eb 	. 
	pop hl			;9050	e1 	. 
	pop af			;9051	f1 	. 
	dec a			;9052	3d 	= 
	jr nz,l9038h		;9053	20 e3 	  . 
	ret			;9055	c9 	. 
l9056h:
	ld hl,l945eh		;9056	21 5e 94 	! ^ . 
	or a			;9059	b7 	. 
	jr z,l9066h		;905a	28 0a 	( . 
	ld hl,l947dh		;905c	21 7d 94 	! } . 
	cp 001h		;905f	fe 01 	. . 
	jr z,l9066h		;9061	28 03 	( . 
	ld hl,l9499h		;9063	21 99 94 	! . . 
l9066h:
	push hl			;9066	e5 	. 
	ld hl,00020h		;9067	21 20 00 	!   . 
	ld (l98abh),hl		;906a	22 ab 98 	" . . 
	call sub_9446h		;906d	cd 46 94 	. F . 
	ld hl,l94b9h		;9070	21 b9 94 	! . . 
	ld de,0aa80h		;9073	11 80 aa 	. . . 
	call sub_9423h		;9076	cd 23 94 	. # . 
	pop hl			;9079	e1 	. 
	call sub_9423h		;907a	cd 23 94 	. # . 
	ld hl,l94d3h		;907d	21 d3 94 	! . . 
	call sub_9423h		;9080	cd 23 94 	. # . 
	ld hl,00015h		;9083	21 15 00 	! . . 
	add hl,de			;9086	19 	. 
	ex de,hl			;9087	eb 	. 
	ld hl,07812h		;9088	21 12 78 	! . x 
	ld a,005h		;908b	3e 05 	> . 
l908dh:
	push af			;908d	f5 	. 
	push hl			;908e	e5 	. 
	push de			;908f	d5 	. 
	ld a,(hl)			;9090	7e 	~ 
	call sub_9889h		;9091	cd 89 98 	. . . 
	pop de			;9094	d1 	. 
	pop hl			;9095	e1 	. 
	pop af			;9096	f1 	. 
	inc hl			;9097	23 	# 
	inc de			;9098	13 	. 
	dec a			;9099	3d 	= 
	jr nz,l908dh		;909a	20 f1 	  . 
	call sub_930eh		;909c	cd 0e 93 	. . . 
	call sub_90dch		;909f	cd dc 90 	. . . 
	jp z,l8fcbh		;90a2	ca cb 8f 	. . . 
	push af			;90a5	f5 	. 
	call sub_8fffh		;90a6	cd ff 8f 	. . . 
	pop af			;90a9	f1 	. 
	ld hl,0aac5h		;90aa	21 c5 aa 	! . . 
	ld de,000c0h		;90ad	11 c0 00 	. . . 
l90b0h:
	dec a			;90b0	3d 	= 
	jr z,l90b6h		;90b1	28 03 	( . 
	add hl,de			;90b3	19 	. 
	jr l90b0h		;90b4	18 fa 	. . 
l90b6h:
	ld de,0001fh		;90b6	11 1f 00 	. . . 
	ld (hl),000h		;90b9	36 00 	6 . 
	inc hl			;90bb	23 	# 
	ld (hl),050h		;90bc	36 50 	6 P 
	add hl,de			;90be	19 	. 
	ld (hl),000h		;90bf	36 00 	6 . 
	inc hl			;90c1	23 	# 
	ld (hl),054h		;90c2	36 54 	6 T 
	add hl,de			;90c4	19 	. 
	ld (hl),055h		;90c5	36 55 	6 U 
	inc hl			;90c7	23 	# 
	ld (hl),055h		;90c8	36 55 	6 U 
	add hl,de			;90ca	19 	. 
	ld (hl),000h		;90cb	36 00 	6 . 
	inc hl			;90cd	23 	# 
	ld (hl),054h		;90ce	36 54 	6 T 
	add hl,de			;90d0	19 	. 
	ld (hl),000h		;90d1	36 00 	6 . 
	inc hl			;90d3	23 	# 
	ld (hl),050h		;90d4	36 50 	6 P 
	call sub_930eh		;90d6	cd 0e 93 	. . . 
	jp l8fcbh		;90d9	c3 cb 8f 	. . . 
sub_90dch:
	ld de,l96e0h		;90dc	11 e0 96 	. . . 
	ld b,00ah		;90df	06 0a 	. . 
	ld c,001h		;90e1	0e 01 	. . 
l90e3h:
	ld hl,07812h		;90e3	21 12 78 	! . x 
	ld a,(de)			;90e6	1a 	. 
	cp (hl)			;90e7	be 	. 
	jp m,l910fh		;90e8	fa 0f 91 	. . . 
	jr z,l90efh		;90eb	28 02 	( . 
	jr l9103h		;90ed	18 14 	. . 
l90efh:
	inc hl			;90ef	23 	# 
	inc de			;90f0	13 	. 
	ld a,(de)			;90f1	1a 	. 
	cp (hl)			;90f2	be 	. 
	jp m,l910eh		;90f3	fa 0e 91 	. . . 
	jr z,l90fah		;90f6	28 02 	( . 
	jr l9104h		;90f8	18 0a 	. . 
l90fah:
	inc hl			;90fa	23 	# 
	inc de			;90fb	13 	. 
	ld a,(de)			;90fc	1a 	. 
	cp (hl)			;90fd	be 	. 
	jp m,l910dh		;90fe	fa 0d 91 	. . . 
	jr l9105h		;9101	18 02 	. . 
l9103h:
	inc de			;9103	13 	. 
l9104h:
	inc de			;9104	13 	. 
l9105h:
	inc de			;9105	13 	. 
	inc de			;9106	13 	. 
	inc de			;9107	13 	. 
	inc c			;9108	0c 	. 
	djnz l90e3h		;9109	10 d8 	. . 
	xor a			;910b	af 	. 
	ret			;910c	c9 	. 
l910dh:
	dec de			;910d	1b 	. 
l910eh:
	dec de			;910e	1b 	. 
l910fh:
	ld a,c			;910f	79 	y 
	push af			;9110	f5 	. 
	push de			;9111	d5 	. 
	cp 00ah		;9112	fe 0a 	. . 
	jr z,l9129h		;9114	28 13 	( . 
	ld b,a			;9116	47 	G 
	ld a,00ah		;9117	3e 0a 	> . 
	sub b			;9119	90 	. 
	ld b,a			;911a	47 	G 
	push bc			;911b	c5 	. 
	ld hl,l9708h		;911c	21 08 97 	! . . 
	call sub_92f6h		;911f	cd f6 92 	. . . 
	pop bc			;9122	c1 	. 
	ld hl,l96d6h		;9123	21 d6 96 	! . . 
	call sub_92f6h		;9126	cd f6 92 	. . . 
l9129h:
	pop de			;9129	d1 	. 
	push de			;912a	d5 	. 
	ld hl,07812h		;912b	21 12 78 	! . x 
	ld bc,00005h		;912e	01 05 00 	. . . 
	ldir		;9131	ed b0 	. . 
	pop hl			;9133	e1 	. 
	ld de,00032h		;9134	11 32 00 	. 2 . 
	or a			;9137	b7 	. 
	sbc hl,de		;9138	ed 52 	. R 
	push hl			;913a	e5 	. 
	call sub_9446h		;913b	cd 46 94 	. F . 
	ld hl,l94eah		;913e	21 ea 94 	! . . 
	ld de,0ab40h		;9141	11 40 ab 	. @ . 
	ld a,005h		;9144	3e 05 	> . 
l9146h:
	push af			;9146	f5 	. 
	call sub_9423h		;9147	cd 23 94 	. # . 
	inc hl			;914a	23 	# 
	push hl			;914b	e5 	. 
	ld hl,00120h		;914c	21 20 01 	!   . 
	add hl,de			;914f	19 	. 
	ex de,hl			;9150	eb 	. 
	pop hl			;9151	e1 	. 
	pop af			;9152	f1 	. 
	dec a			;9153	3d 	= 
	jr nz,l9146h		;9154	20 f0 	  . 
	ld hl,0b0c2h		;9156	21 c2 b0 	! . . 
	ld bc,00006h		;9159	01 06 00 	. . . 
	call sub_92cah		;915c	cd ca 92 	. . . 
	add hl,bc			;915f	09 	. 
	call sub_92cah		;9160	cd ca 92 	. . . 
	add hl,bc			;9163	09 	. 
	call sub_92cah		;9164	cd ca 92 	. . . 
	add hl,bc			;9167	09 	. 
	call sub_92cah		;9168	cd ca 92 	. . . 
	add hl,bc			;916b	09 	. 
	call sub_92cah		;916c	cd ca 92 	. . . 
	call sub_931bh		;916f	cd 1b 93 	. . . 
	ld hl,l920eh		;9172	21 0e 92 	! . . 
	ld (l920ah),hl		;9175	22 0a 92 	" . . 
	ld de,l920fh		;9178	11 0f 92 	. . . 
	ld bc,00004h		;917b	01 04 00 	. . . 
	ld (hl),020h		;917e	36 20 	6   
	ldir		;9180	ed b0 	. . 
	ld hl,07684h		;9182	21 84 76 	! . v 
	ld (l920ch),hl		;9185	22 0c 92 	" . . 
	xor a			;9188	af 	. 
	ld (l9209h),a		;9189	32 09 92 	2 . . 
	ld a,041h		;918c	3e 41 	> A 
	ld (l9208h),a		;918e	32 08 92 	2 . . 
	ld hl,07081h		;9191	21 81 70 	! . p 
	ld bc,00101h		;9194	01 01 01 	. . . 
l9197h:
	call sub_92cah		;9197	cd ca 92 	. . . 
l919ah:
	ld de,06000h		;919a	11 00 60 	. . ` 
	call sub_941dh		;919d	cd 1d 94 	. . . 
l91a0h:
	ld a,(KEYS_ROW_4)		;91a0	3a ef 68 	: . h 
	bit 3,a		;91a3	cb 5f 	. _ 
	jr z,l91bch		;91a5	28 15 	( . 
	bit 5,a		;91a7	cb 6f 	. o 
	jr z,l91c0h		;91a9	28 15 	( . 
	bit 1,a		;91ab	cb 4f 	. O 
	jr z,l91c4h		;91ad	28 15 	( . 
	bit 4,a		;91af	cb 67 	. g 
	jr z,l91c8h		;91b1	28 15 	( . 
	ld a,(KEYS_ROW_6)		;91b3	3a bf 68 	: . h 
	bit 2,a		;91b6	cb 57 	. W 
	jr z,l9213h		;91b8	28 59 	( Y 
	jr l91a0h		;91ba	18 e4 	. . 
l91bch:
	ld a,001h		;91bc	3e 01 	> . 
	jr l91cah		;91be	18 0a 	. . 
l91c0h:
	ld a,01dh		;91c0	3e 1d 	> . 
	jr l91cah		;91c2	18 06 	. . 
l91c4h:
	ld a,018h		;91c4	3e 18 	> . 
	jr l91cah		;91c6	18 02 	. . 
l91c8h:
	ld a,006h		;91c8	3e 06 	> . 
l91cah:
	push af			;91ca	f5 	. 
	call sub_929eh		;91cb	cd 9e 92 	. . . 
	pop af			;91ce	f1 	. 
l91cfh:
	push af			;91cf	f5 	. 
	call sub_91d9h		;91d0	cd d9 91 	. . . 
	pop af			;91d3	f1 	. 
	dec a			;91d4	3d 	= 
	jr nz,l91cfh		;91d5	20 f8 	  . 
	jr l9197h		;91d7	18 be 	. . 
sub_91d9h:
	nop			;91d9	00 	. 
	ld a,(l9208h)		;91da	3a 08 92 	: . . 
	inc a			;91dd	3c 	< 
	ld (l9208h),a		;91de	32 08 92 	2 . . 
	ld a,b			;91e1	78 	x 
	cp 006h		;91e2	fe 06 	. . 
	jr z,l91edh		;91e4	28 07 	( . 
	inc b			;91e6	04 	. 
	inc hl			;91e7	23 	# 
	inc hl			;91e8	23 	# 
	inc hl			;91e9	23 	# 
	inc hl			;91ea	23 	# 
	inc hl			;91eb	23 	# 
	ret			;91ec	c9 	. 
l91edh:
	ld b,001h		;91ed	06 01 	. . 
	ld a,c			;91ef	79 	y 
	cp 005h		;91f0	fe 05 	. . 
	jr z,l91fah		;91f2	28 06 	( . 
	ld de,00107h		;91f4	11 07 01 	. . . 
	add hl,de			;91f7	19 	. 
	inc c			;91f8	0c 	. 
	ret			;91f9	c9 	. 
l91fah:
	ld de,00499h		;91fa	11 99 04 	. . . 
	or a			;91fd	b7 	. 
	sbc hl,de		;91fe	ed 52 	. R 
	ld c,001h		;9200	0e 01 	. . 
	ld a,041h		;9202	3e 41 	> A 
	ld (l9208h),a		;9204	32 08 92 	2 . . 
	ret			;9207	c9 	. 
l9208h:
	nop			;9208	00 	. 
l9209h:
	nop			;9209	00 	. 
l920ah:
	nop			;920a	00 	. 
	nop			;920b	00 	. 
l920ch:
	nop			;920c	00 	. 
	nop			;920d	00 	. 
l920eh:
	nop			;920e	00 	. 
l920fh:
	nop			;920f	00 	. 
	nop			;9210	00 	. 
	nop			;9211	00 	. 
	nop			;9212	00 	. 
l9213h:
	push bc			;9213	c5 	. 
	push hl			;9214	e5 	. 
	ld a,(l9208h)		;9215	3a 08 92 	: . . 
	cp 05bh		;9218	fe 5b 	. [ 
	jr z,l9256h		;921a	28 3a 	( : 
	cp 05ch		;921c	fe 5c 	. \ 
	jr z,l925ah		;921e	28 3a 	( : 
	cp 05dh		;9220	fe 5d 	. ] 
	jr z,l925eh		;9222	28 3a 	( : 
	cp 05eh		;9224	fe 5e 	. ^ 
	jr z,l9290h		;9226	28 68 	( h 
l9228h:
	ld hl,(l920ah)		;9228	2a 0a 92 	* . . 
	ld (hl),a			;922b	77 	w 
	ld de,(l920ch)		;922c	ed 5b 0c 92 	. [ . . 
	call sub_98e9h		;9230	cd e9 98 	. . . 
	ld a,(l9209h)		;9233	3a 09 92 	: . . 
	cp 004h		;9236	fe 04 	. . 
	jr nz,l923fh		;9238	20 05 	  . 
l923ah:
	pop hl			;923a	e1 	. 
	pop bc			;923b	c1 	. 
	jp l919ah		;923c	c3 9a 91 	. . . 
l923fh:
	inc a			;923f	3c 	< 
	ld (l9209h),a		;9240	32 09 92 	2 . . 
	ld hl,(l920ah)		;9243	2a 0a 92 	* . . 
	inc hl			;9246	23 	# 
	ld (l920ah),hl		;9247	22 0a 92 	" . . 
	ld hl,(l920ch)		;924a	2a 0c 92 	* . . 
	ld bc,00006h		;924d	01 06 00 	. . . 
	add hl,bc			;9250	09 	. 
	ld (l920ch),hl		;9251	22 0c 92 	" . . 
	jr l923ah		;9254	18 e4 	. . 
l9256h:
	ld a,02eh		;9256	3e 2e 	> . 
	jr l9228h		;9258	18 ce 	. . 
l925ah:
	ld a,020h		;925a	3e 20 	>   
	jr l9228h		;925c	18 ca 	. . 
l925eh:
	ld a,020h		;925e	3e 20 	>   
	ld de,(l920ch)		;9260	ed 5b 0c 92 	. [ . . 
	push de			;9264	d5 	. 
	call sub_98e9h		;9265	cd e9 98 	. . . 
	ld hl,(l920ah)		;9268	2a 0a 92 	* . . 
	ld (hl),020h		;926b	36 20 	6   
	pop de			;926d	d1 	. 
	ld a,(l9209h)		;926e	3a 09 92 	: . . 
	or a			;9271	b7 	. 
	jr z,l923ah		;9272	28 c6 	( . 
	dec a			;9274	3d 	= 
	ld (l9209h),a		;9275	32 09 92 	2 . . 
	dec hl			;9278	2b 	+ 
	ld (hl),020h		;9279	36 20 	6   
	ld (l920ah),hl		;927b	22 0a 92 	" . . 
	ex de,hl			;927e	eb 	. 
	ld de,00006h		;927f	11 06 00 	. . . 
	or a			;9282	b7 	. 
	sbc hl,de		;9283	ed 52 	. R 
	ld (l920ch),hl		;9285	22 0c 92 	" . . 
	ex de,hl			;9288	eb 	. 
	ld a,020h		;9289	3e 20 	>   
	call sub_98e9h		;928b	cd e9 98 	. . . 
	jr l923ah		;928e	18 aa 	. . 
l9290h:
	pop hl			;9290	e1 	. 
	pop bc			;9291	c1 	. 
	pop de			;9292	d1 	. 
	ld hl,l920eh		;9293	21 0e 92 	! . . 
	ld bc,00005h		;9296	01 05 00 	. . . 
	ldir		;9299	ed b0 	. . 
	pop af			;929b	f1 	. 
	or a			;929c	b7 	. 
	ret			;929d	c9 	. 
sub_929eh:
	push hl			;929e	e5 	. 
	push bc			;929f	c5 	. 
	ld de,0001ch		;92a0	11 1c 00 	. . . 
	call sub_92bah		;92a3	cd ba 92 	. . . 
	ld a,007h		;92a6	3e 07 	> . 
	ld bc,00004h		;92a8	01 04 00 	. . . 
l92abh:
	ld (hl),000h		;92ab	36 00 	6 . 
	add hl,bc			;92ad	09 	. 
	ld (hl),000h		;92ae	36 00 	6 . 
	add hl,de			;92b0	19 	. 
	dec a			;92b1	3d 	= 
	jr nz,l92abh		;92b2	20 f7 	  . 
	call sub_92bah		;92b4	cd ba 92 	. . . 
	pop bc			;92b7	c1 	. 
	pop hl			;92b8	e1 	. 
	ret			;92b9	c9 	. 
sub_92bah:
	ld (hl),000h		;92ba	36 00 	6 . 
	inc hl			;92bc	23 	# 
	ld (hl),000h		;92bd	36 00 	6 . 
	inc hl			;92bf	23 	# 
	ld (hl),000h		;92c0	36 00 	6 . 
	inc hl			;92c2	23 	# 
	ld (hl),000h		;92c3	36 00 	6 . 
	inc hl			;92c5	23 	# 
	ld (hl),000h		;92c6	36 00 	6 . 
	add hl,de			;92c8	19 	. 
	ret			;92c9	c9 	. 
sub_92cah:
	push hl			;92ca	e5 	. 
	push bc			;92cb	c5 	. 
	ld de,0001ch		;92cc	11 1c 00 	. . . 
	call sub_92e6h		;92cf	cd e6 92 	. . . 
	ld bc,00004h		;92d2	01 04 00 	. . . 
	ld a,007h		;92d5	3e 07 	> . 
l92d7h:
	ld (hl),010h		;92d7	36 10 	6 . 
	add hl,bc			;92d9	09 	. 
	ld (hl),010h		;92da	36 10 	6 . 
	add hl,de			;92dc	19 	. 
	dec a			;92dd	3d 	= 
	jr nz,l92d7h		;92de	20 f7 	  . 
	call sub_92e6h		;92e0	cd e6 92 	. . . 
	pop bc			;92e3	c1 	. 
	pop hl			;92e4	e1 	. 
	ret			;92e5	c9 	. 
sub_92e6h:
	ld (hl),015h		;92e6	36 15 	6 . 
	inc hl			;92e8	23 	# 
	ld (hl),055h		;92e9	36 55 	6 U 
	inc hl			;92eb	23 	# 
	ld (hl),055h		;92ec	36 55 	6 U 
	inc hl			;92ee	23 	# 
	ld (hl),055h		;92ef	36 55 	6 U 
	inc hl			;92f1	23 	# 
	ld (hl),050h		;92f2	36 50 	6 P 
	add hl,de			;92f4	19 	. 
	ret			;92f5	c9 	. 
sub_92f6h:
	push bc			;92f6	c5 	. 
	push hl			;92f7	e5 	. 
	push hl			;92f8	e5 	. 
	pop de			;92f9	d1 	. 
	inc de			;92fa	13 	. 
	inc de			;92fb	13 	. 
	inc de			;92fc	13 	. 
	inc de			;92fd	13 	. 
	inc de			;92fe	13 	. 
	ld bc,00005h		;92ff	01 05 00 	. . . 
	ldir		;9302	ed b0 	. . 
	pop hl			;9304	e1 	. 
	dec hl			;9305	2b 	+ 
	dec hl			;9306	2b 	+ 
	dec hl			;9307	2b 	+ 
	dec hl			;9308	2b 	+ 
	dec hl			;9309	2b 	+ 
	pop bc			;930a	c1 	. 
	djnz sub_92f6h		;930b	10 e9 	. . 
	ret			;930d	c9 	. 
sub_930eh:
	call sub_931bh		;930e	cd 1b 93 	. . . 
	call sub_940fh		;9311	cd 0f 94 	. . . 
	call sub_940fh		;9314	cd 0f 94 	. . . 
	call sub_940fh		;9317	cd 0f 94 	. . . 
	ret			;931a	c9 	. 
sub_931bh:
	ld hl,VRAM			; screen coord (0,0)px									;931b	21 00 70 
	ld bc,0401fh		;931e	01 1f 40 	. . @ 
	ld a,010h		;9321	3e 10 	> . 
l9323h:
	push af			;9323	f5 	. 
	push hl			;9324	e5 	. 
	push bc			;9325	c5 	. 
	call sub_93b9h		;9326	cd b9 93 	. . . 
	ld de,02000h		;9329	11 00 20 	. .   
	call sub_941dh		;932c	cd 1d 94 	. . . 
	pop bc			;932f	c1 	. 
	pop hl			;9330	e1 	. 
	pop af			;9331	f1 	. 
	ld de,00041h		;9332	11 41 00 	. A . 
	add hl,de			;9335	19 	. 
	dec b			;9336	05 	. 
	dec b			;9337	05 	. 
	dec b			;9338	05 	. 
	dec b			;9339	05 	. 
	dec c			;933a	0d 	. 
	dec c			;933b	0d 	. 
	dec a			;933c	3d 	= 
	jr nz,l9323h		;933d	20 e4 	  . 
	ld hl,073cfh		;933f	21 cf 73 	! . s 
	ld de,0ae4fh		;9342	11 4f ae 	. O . 
	ld bc,00401h		;9345	01 01 04 	. . . 
	ld a,00fh		;9348	3e 0f 	> . 
l934ah:
	push af			;934a	f5 	. 
	push bc			;934b	c5 	. 
	push de			;934c	d5 	. 
	push hl			;934d	e5 	. 
	call sub_936fh		;934e	cd 6f 93 	. o . 
	ld de,02000h		;9351	11 00 20 	. .   
	call sub_941dh		;9354	cd 1d 94 	. . . 
	pop de			;9357	d1 	. 
	pop hl			;9358	e1 	. 
	ld bc,00041h		;9359	01 41 00 	. A . 
	or a			;935c	b7 	. 
	sbc hl,bc		;935d	ed 42 	. B 
	ex de,hl			;935f	eb 	. 
	or a			;9360	b7 	. 
	sbc hl,bc		;9361	ed 42 	. B 
	pop bc			;9363	c1 	. 
	pop af			;9364	f1 	. 
	inc b			;9365	04 	. 
	inc b			;9366	04 	. 
	inc b			;9367	04 	. 
	inc b			;9368	04 	. 
	inc c			;9369	0c 	. 
	inc c			;936a	0c 	. 
	dec a			;936b	3d 	= 
	jr nz,l934ah		;936c	20 dc 	  . 
	ret			;936e	c9 	. 
sub_936fh:
	call sub_938fh		;936f	cd 8f 93 	. . . 
	call sub_938fh		;9372	cd 8f 93 	. . . 
	push bc			;9375	c5 	. 
	ld a,b			;9376	78 	x 
	dec a			;9377	3d 	= 
	dec a			;9378	3d 	= 
	dec a			;9379	3d 	= 
	dec a			;937a	3d 	= 
	jr z,l9387h		;937b	28 0a 	( . 
	ld b,000h		;937d	06 00 	. . 
l937fh:
	push af			;937f	f5 	. 
	call sub_93a4h		;9380	cd a4 93 	. . . 
	pop af			;9383	f1 	. 
	dec a			;9384	3d 	= 
	jr nz,l937fh		;9385	20 f8 	  . 
l9387h:
	pop bc			;9387	c1 	. 
	call sub_938fh		;9388	cd 8f 93 	. . . 
	call sub_938fh		;938b	cd 8f 93 	. . . 
	ret			;938e	c9 	. 
sub_938fh:
	push bc			;938f	c5 	. 
	push de			;9390	d5 	. 
	push hl			;9391	e5 	. 
	inc c			;9392	0c 	. 
l9393h:
	ld a,(de)			;9393	1a 	. 
	ld (hl),a			;9394	77 	w 
	inc hl			;9395	23 	# 
	inc de			;9396	13 	. 
	dec c			;9397	0d 	. 
	jr nz,l9393h		;9398	20 f9 	  . 
	pop de			;939a	d1 	. 
	pop hl			;939b	e1 	. 
	ld bc,00020h		;939c	01 20 00 	.   . 
	add hl,bc			;939f	09 	. 
	ex de,hl			;93a0	eb 	. 
	add hl,bc			;93a1	09 	. 
	pop bc			;93a2	c1 	. 
	ret			;93a3	c9 	. 
sub_93a4h:
	push bc			;93a4	c5 	. 
	push de			;93a5	d5 	. 
	push hl			;93a6	e5 	. 
	ld a,(de)			;93a7	1a 	. 
	ld (hl),a			;93a8	77 	w 
	add hl,bc			;93a9	09 	. 
	ex de,hl			;93aa	eb 	. 
	add hl,bc			;93ab	09 	. 
	ex de,hl			;93ac	eb 	. 
	ld a,(de)			;93ad	1a 	. 
	ld (hl),a			;93ae	77 	w 
	ld bc,00020h		;93af	01 20 00 	.   . 
	pop de			;93b2	d1 	. 
	pop hl			;93b3	e1 	. 
	add hl,bc			;93b4	09 	. 
	ex de,hl			;93b5	eb 	. 
	add hl,bc			;93b6	09 	. 
	pop bc			;93b7	c1 	. 
	ret			;93b8	c9 	. 
sub_93b9h:
	call sub_93d9h		;93b9	cd d9 93 	. . . 
	call sub_93d9h		;93bc	cd d9 93 	. . . 
	push bc			;93bf	c5 	. 
	ld a,b			;93c0	78 	x 
	dec a			;93c1	3d 	= 
	dec a			;93c2	3d 	= 
	dec a			;93c3	3d 	= 
	dec a			;93c4	3d 	= 
	jr z,l93d1h		;93c5	28 0a 	( . 
	ld b,000h		;93c7	06 00 	. . 
l93c9h:
	push af			;93c9	f5 	. 
	call sub_93ebh		;93ca	cd eb 93 	. . . 
	pop af			;93cd	f1 	. 
	dec a			;93ce	3d 	= 
	jr nz,l93c9h		;93cf	20 f8 	  . 
l93d1h:
	pop bc			;93d1	c1 	. 
	call sub_93d9h		;93d2	cd d9 93 	. . . 
	call sub_93d9h		;93d5	cd d9 93 	. . . 
	ret			;93d8	c9 	. 
sub_93d9h:
	push bc			;93d9	c5 	. 
	push hl			;93da	e5 	. 
	push hl			;93db	e5 	. 
	pop de			;93dc	d1 	. 
	inc de			;93dd	13 	. 
	ld b,000h		;93de	06 00 	. . 
	ld (hl),0ffh		;93e0	36 ff 	6 . 
	ldir		;93e2	ed b0 	. . 
	pop hl			;93e4	e1 	. 
	ld de,00020h		;93e5	11 20 00 	.   . 
	add hl,de			;93e8	19 	. 
	pop bc			;93e9	c1 	. 
	ret			;93ea	c9 	. 
sub_93ebh:
	push bc			;93eb	c5 	. 
	push hl			;93ec	e5 	. 
	ld (hl),0ffh		;93ed	36 ff 	6 . 
	ld b,000h		;93ef	06 00 	. . 
	add hl,bc			;93f1	09 	. 
	ld (hl),0ffh		;93f2	36 ff 	6 . 
	pop hl			;93f4	e1 	. 
	ld de,00020h		;93f5	11 20 00 	.   . 
	add hl,de			;93f8	19 	. 
	pop bc			;93f9	c1 	. 
	ret			;93fa	c9 	. 
sub_93fbh:
	ld a,(KEYS_ROW_6)		;93fb	3a bf 68 	: . h 
	bit 3,a		;93fe	cb 5f 	. _ 
	jp z,l9a4fh		;9400	ca 4f 9a 	. O . 
	bit 4,a		;9403	cb 67 	. g 
	ret nz			;9405	c0 	. 
	ld hl,0002ch		;9406	21 2c 00 	! , . 
	ld (l98abh),hl		;9409	22 ab 98 	" . . 
	jp l7d03h		;940c	c3 03 7d 	. . } 
sub_940fh:
	ld b,014h		;940f	06 14 	. . 
l9411h:
	ld de,04000h		;9411	11 00 40 	. . @ 
	call sub_941dh		;9414	cd 1d 94 	. . . 
	call sub_93fbh		;9417	cd fb 93 	. . . 
	djnz l9411h		;941a	10 f5 	. . 
	ret			;941c	c9 	. 
sub_941dh:
	dec de			;941d	1b 	. 
	ld a,d			;941e	7a 	z 
	or e			;941f	b3 	. 
	jr nz,sub_941dh		;9420	20 fb 	  . 
	ret			;9422	c9 	. 


sub_9423h:
	push de			;9423	d5 	. 
l9424h:
	push hl			;9424	e5 	. 
	push de			;9425	d5 	. 
	ld a,(hl)			;9426	7e 	~ 
	or a			;9427	b7 	. 
	jr z,l9437h		;9428	28 0d 	( . 
	cp 00dh		;942a	fe 0d 	. . 
	jr z,l943bh		;942c	28 0d 	( . 
	call sub_98e9h		;942e	cd e9 98 	. . . 
	pop de			;9431	d1 	. 
	pop hl			;9432	e1 	. 
	inc hl			;9433	23 	# 
	inc de			;9434	13 	. 
	jr l9424h		;9435	18 ed 	. . 
l9437h:
	pop de			;9437	d1 	. 
	pop hl			;9438	e1 	. 
	pop de			;9439	d1 	. 
	ret			;943a	c9 	. 
l943bh:
	pop de			;943b	d1 	. 
	pop de			;943c	d1 	. 
	pop hl			;943d	e1 	. 
	ld bc,000c0h		;943e	01 c0 00 	. . . 
	add hl,bc			;9441	09 	. 
	ex de,hl			;9442	eb 	. 
	inc hl			;9443	23 	# 
	jr sub_9423h		;9444	18 dd 	. . 
sub_9446h:
	ld hl,0aa80h		;9446	21 80 aa 	! . . 
	jr l944eh		;9449	18 03 	. . 
sub_944bh:
	ld hl,VRAM				; screen coord (0,0)								;944b	21 00 70
l944eh:
	ld a,008h		;944e	3e 08 	> . 
	ld (IOLATCH),a		;9450	32 00 68 	2 . h 
	push hl			;9453	e5 	. 
	pop de			;9454	d1 	. 
	inc de			;9455	13 	. 
	ld bc,007ffh		;9456	01 ff 07 	. . . 
	ld (hl),000h		;9459	36 00 	6 . 
	ldir		;945b	ed b0 	. . 
	ret			;945d	c9 	. 


l945eh:
	defb 13										;945e	0d 
	defb "    ALL HELICOPTER DESTROYED",13,0	;945f	20 20 20 20 41 4c 4c 20 48 45 4c 49 43 4f 50 54 45 52 20 44 45 53 54 52 4f 59 45 44 0d 00


l947dh:
	defb 13										;947d	0d 
	defb "      6.00 A.M. - TIME UP",13,0		;947e	20 20 20 20 20 20 36 2e 30 30 20 41 2e 4d 2e 20 2d 20 54 49 4d 45 20 55 50 0d 00

l9499h:
	defb 13										;9499	0d 
	defb "  NO PRISONERS LEFT TO RESCUE",13,0	;949a	20 20 4e 4f 20 50 52 49 53 4f 4e 45 52 53 20 4c 45 46 54 20 54 4f 20 52 45 53 43 55 45 0d 00


l94b9h:
	defb 13										;94b9	0d 
	defb 13										;94ba	0d 
	defb "         MISSION OVER",13				;94bb	20 20 20 20 20 20 20 20 20 4d 49 53 53 49 4f 4e 20 4f 56 45 52 0d 
	defb 13,0									;94d1	0d 00 


l94d3h:
	defb 13										;94d3	0d 
	defb 13										;94d4	0d 
	defb "    YOUR SCORE WAS  ",0				;94d5	20 20 20 20 59 4f 55 52 20 53 43 4f 52 45 20 57 41 53 20 20 00 


l94eah:
	defb "   A    B    C    D    E    F",0		;94ea	20 20 20 41 20 20 20 20 42 20 20 20 20 43 20 20 20 20 44 20 20 20 20 45 20 20 20 20 46 00
	defb "   G    H    I    J    K    L",0		;9508	20 20 20 47 20 20 20 20 48 20 20 20 20 49 20 20 20 20 4a 20 20 20 20 4b 20 20 20 20 4c 00 
	defb "   M    N    O    P    Q    R",0		;9526	20 20 20 4d 20 20 20 20 4e 20 20 20 20 4f 20 20 20 20 50 20 20 20 20 51 20 20 20 20 52 00
	defb "   S    T    U    V    W    X",0		;9544	20 20 20 53 20 20 20 20 54 20 20 20 20 55 20 20 20 20 56 20 20 20 20 57 20 20 20 20 58 00 
	defb "   Y    Z    .   SPC  DEL  END",0		;9562	20 20 20 59 20 20 20 20 5a 20 20 20 20 2e 20 20 20 53 50 43 20 20 44 45 4c 20 20 45 4e 44 00


l9581h:
	defb 13										;9581	0d 
	defb 13										;9582	0d 
	defb "        D    A    W    N",13			;9583	20 20 20 20 20 20 20 20 44 20 20 20 20 41 20 20 20 20 57 20 20 20 20 4e 0d 
	defb 13										;959c	0d 
	defb "   P    A    T    R    O    L",13		;959d	20 20 20 50 20 20 20 20 41 20 20 20 20 54 20 20 20 20 52 20 20 20 20 4f 20 20 20 20 4c 0d
	defb 13										;95bb	0d 
	defb 13										;95bc	0d 
	defb "      PRESS  <P>  TO  PLAY",13		;95bd	20 20 20 20 20 20 50 52 45 53 53 20 20 3c 50 3e 20 20 54 4f 20 20 50 4c 41 59 0d
	defb "    PRESS <I> FOR INSTRUCTIONS",0		;95d8	20 20 20 20 50 52 45 53 53 20 3c 49 3e 20 46 4f 52 20 49 4e 53 54 52 55 43 54 49 4f 4e 53 00


l95f7h:
	defb 13										;95f7	0d 
	defb "    HELICOPTER CONTROL KEYS",13		;95f8	20 20 20 20 48 45 4c 49 43 4f 50 54 45 52 20 43 4f 4e 54 52 4f 4c 20 4b 45 59 53 0d
	defb 13										;9614	0d 
	defb "     Q  =  HELICOPTER UP",13			;9615	20 20 20 20 20 51 20 20 3d 20 20 48 45 4c 49 43 4f 50 54 45 52 20 55 50 0d 
	defb "     A  =  HELICOPTER DOWN",13		;962e	20 20 20 20 20 41 20 20 3d 20 20 48 45 4c 49 43 4f 50 54 45 52 20 44 4f 57 4e 0d
	defb "     M  =  HELICOPTER RIGHT",13		;9649	20 20 20 20 20 4d 20 20 3d 20 20 48 45 4c 49 43 4f 50 54 45 52 20 52 49 47 48 54 0d
	defb "     ,  =  HELICOPTER LEFT",13		;9665	20 20 20 20 20 2c 20 20 3d 20 20 48 45 4c 49 43 4f 50 54 45 52 20 4c 45 46 54 0d
	defb 13										;9680	0d 
	defb "     N  =  ROTATE HELICOPTER",13		;9681	20 20 20 20 20 4e 20 20 3d 20 20 52 4f 54 41 54 45 20 48 45 4c 49 43 4f 50 54 45 52 0d 
	defb "    SPC =  FIRE",0					;969e	20 20 20 20 53 50 43 20 3d 20 20 46 49 52 45 00


l96aeh:
	nop			;96ae	00 	. 
l96afh:
	nop			;96af	00 	. 
	nop			;96b0	00 	. 
	nop			;96b1	00 	. 
l96b2h:
	nop			;96b2	00 	. 
	nop			;96b3	00 	. 
	nop			;96b4	00 	. 
	nop			;96b5	00 	. 
	nop			;96b6	00 	. 
	nop			;96b7	00 	. 
	nop			;96b8	00 	. 
	nop			;96b9	00 	. 
	nop			;96ba	00 	. 
	nop			;96bb	00 	. 
	nop			;96bc	00 	. 
	nop			;96bd	00 	. 
	nop			;96be	00 	. 
	nop			;96bf	00 	. 
l96c0h:
	nop			;96c0	00 	. 
	nop			;96c1	00 	. 
l96c2h:
	nop			;96c2	00 	. 
	nop			;96c3	00 	. 
	nop			;96c4	00 	. 
	nop			;96c5	00 	. 
	nop			;96c6	00 	. 
	nop			;96c7	00 	. 
l96c8h:
	nop			;96c8	00 	. 
l96c9h:
	nop			;96c9	00 	. 
	nop			;96ca	00 	. 
	nop			;96cb	00 	. 
	nop			;96cc	00 	. 
	nop			;96cd	00 	. 
	nop			;96ce	00 	. 
	nop			;96cf	00 	. 
	nop			;96d0	00 	. 
	nop			;96d1	00 	. 
	nop			;96d2	00 	. 
	nop			;96d3	00 	. 
	nop			;96d4	00 	. 
l96d5h:
	nop			;96d5	00 	. 
l96d6h:
	nop			;96d6	00 	. 
	nop			;96d7	00 	. 
	nop			;96d8	00 	. 
	nop			;96d9	00 	. 
	nop			;96da	00 	. 
	nop			;96db	00 	. 
l96dch:
	nop			;96dc	00 	. 
	nop			;96dd	00 	. 
	nop			;96de	00 	. 
	nop			;96df	00 	. 
l96e0h:
	nop			;96e0	00 	. 
l96e1h:
	nop			;96e1	00 	. 
	nop			;96e2	00 	. 
	nop			;96e3	00 	. 
l96e4h:
	nop			;96e4	00 	. 
	nop			;96e5	00 	. 
	nop			;96e6	00 	. 
	nop			;96e7	00 	. 
	nop			;96e8	00 	. 
	nop			;96e9	00 	. 
	nop			;96ea	00 	. 
	nop			;96eb	00 	. 
	nop			;96ec	00 	. 
	nop			;96ed	00 	. 
	nop			;96ee	00 	. 
	nop			;96ef	00 	. 
	nop			;96f0	00 	. 
	nop			;96f1	00 	. 
	nop			;96f2	00 	. 
	nop			;96f3	00 	. 
	nop			;96f4	00 	. 
	nop			;96f5	00 	. 
	nop			;96f6	00 	. 
	nop			;96f7	00 	. 
	nop			;96f8	00 	. 
	nop			;96f9	00 	. 
	nop			;96fa	00 	. 
	nop			;96fb	00 	. 
	nop			;96fc	00 	. 
	nop			;96fd	00 	. 
	nop			;96fe	00 	. 
	nop			;96ff	00 	. 
	nop			;9700	00 	. 
	nop			;9701	00 	. 
	nop			;9702	00 	. 
	nop			;9703	00 	. 
	nop			;9704	00 	. 
	nop			;9705	00 	. 
	nop			;9706	00 	. 
	nop			;9707	00 	. 
l9708h:
	nop			;9708	00 	. 
	nop			;9709	00 	. 
	nop			;970a	00 	. 
	nop			;970b	00 	. 
	nop			;970c	00 	. 
	nop			;970d	00 	. 
	nop			;970e	00 	. 
	nop			;970f	00 	. 
	nop			;9710	00 	. 
	nop			;9711	00 	. 
l9712h:
	ld hl,0781ah		;9712	21 1a 78 	! . x 
	ld a,009h		;9715	3e 09 	> . 
	ld (hl),a			;9717	77 	w 
	inc hl			;9718	23 	# 
	ld (hl),a			;9719	77 	w 
	inc hl			;971a	23 	# 
	ld (hl),a			;971b	77 	w 
	ld a,(07833h)		;971c	3a 33 78 	: 3 x 
	or a			;971f	b7 	. 
	jr z,l9728h		;9720	28 06 	( . 
	ld b,a			;9722	47 	G 
l9723h:
	call sub_9770h		;9723	cd 70 97 	. p . 
	djnz l9723h		;9726	10 fb 	. . 
l9728h:
	ld a,(07832h)		;9728	3a 32 78 	: 2 x 
	or a			;972b	b7 	. 
	jr z,l9734h		;972c	28 06 	( . 
	ld b,a			;972e	47 	G 
l972fh:
	call sub_976dh		;972f	cd 6d 97 	. m . 
	djnz l972fh		;9732	10 fb 	. . 
l9734h:
	ld a,(07831h)		;9734	3a 31 78 	: 1 x 
	or a			;9737	b7 	. 
	jr z,l9740h		;9738	28 06 	( . 
	ld b,a			;973a	47 	G 
l973bh:
	call sub_9764h		;973b	cd 64 97 	. d . 
	djnz l973bh		;973e	10 fb 	. . 
l9740h:
	ld a,(07830h)		;9740	3a 30 78 	: 0 x 
	or a			;9743	b7 	. 
	jr z,l974ch		;9744	28 06 	( . 
	ld b,a			;9746	47 	G 
l9747h:
	call sub_9761h		;9747	cd 61 97 	. a . 
	djnz l9747h		;974a	10 fb 	. . 
l974ch:
	ld hl,0782fh		;974c	21 2f 78 	! / x 
	ld a,(0781dh)		;974f	3a 1d 78 	: . x 
	add a,(hl)			;9752	86 	. 
	ld (0781dh),a		;9753	32 1d 78 	2 . x 
	ld de,07830h		;9756	11 30 78 	. 0 x 
	ld bc,00004h		;9759	01 04 00 	. . . 
	ld (hl),000h		;975c	36 00 	6 . 
	ldir		;975e	ed b0 	. . 
	ret			;9760	c9 	. 
sub_9761h:
	call sub_9779h		;9761	cd 79 97 	. y . 
sub_9764h:
	call l9774h		;9764	cd 74 97 	. t . 
	call l9774h		;9767	cd 74 97 	. t . 
	call l9774h		;976a	cd 74 97 	. t . 
sub_976dh:
	call l9774h		;976d	cd 74 97 	. t . 
sub_9770h:
	call l9774h		;9770	cd 74 97 	. t . 
	ret			;9773	c9 	. 
l9774h:
	ld hl,07814h		;9774	21 14 78 	! . x 
	jr l977ch		;9777	18 03 	. . 
sub_9779h:
	ld hl,07813h		;9779	21 13 78 	! . x 
l977ch:
	ld a,00ah		;977c	3e 0a 	> . 
	inc (hl)			;977e	34 	4 
	cp (hl)			;977f	be 	. 
	ret nz			;9780	c0 	. 
	ld (hl),000h		;9781	36 00 	6 . 
	dec hl			;9783	2b 	+ 
	jr l977ch		;9784	18 f6 	. . 
l9786h:
	ld bc,(07909h)		;9786	ed 4b 09 79 	. K . y 
	dec bc			;978a	0b 	. 
	ld (07909h),bc		;978b	ed 43 09 79 	. C . y 
	ld a,b			;978f	78 	x 
	or c			;9790	b1 	. 
	jr nz,l97fah		;9791	20 67 	  g 
	ld bc,00bb8h		;9793	01 b8 0b 	. . . 
	ld (07909h),bc		;9796	ed 43 09 79 	. C . y 
	ld hl,07819h		;979a	21 19 78 	! . x 
	ld a,00ah		;979d	3e 0a 	> . 
	inc (hl)			;979f	34 	4 
	cp (hl)			;97a0	be 	. 
	jr nz,l97fah		;97a1	20 57 	  W 
	ld (hl),000h		;97a3	36 00 	6 . 
	dec hl			;97a5	2b 	+ 
	ld a,006h		;97a6	3e 06 	> . 
	inc (hl)			;97a8	34 	4 
	cp (hl)			;97a9	be 	. 
	jr nz,l97fah		;97aa	20 4e 	  N 
	ld (hl),000h		;97ac	36 00 	6 . 
	dec hl			;97ae	2b 	+ 
	inc (hl)			;97af	34 	4 
	ld a,006h		;97b0	3e 06 	> . 
	cp (hl)			;97b2	be 	. 
	jr nz,l97fah		;97b3	20 45 	  E 
	jr l97f6h		;97b5	18 3f 	. ? 
l97b7h:
	ld bc,(0790bh)		;97b7	ed 4b 0b 79 	. K . y 
	dec bc			;97bb	0b 	. 
	ld (0790bh),bc		;97bc	ed 43 0b 79 	. C . y 
	ld a,b			;97c0	78 	x 
	or c			;97c1	b1 	. 
	jr nz,l97fah		;97c2	20 36 	  6 
	ld hl,001a3h		;97c4	21 a3 01 	! . . 
	ld bc,00014h		;97c7	01 14 00 	. . . 
	ld a,(0782fh)		;97ca	3a 2f 78 	: / x 
	inc a			;97cd	3c 	< 
l97ceh:
	dec a			;97ce	3d 	= 
	jr z,l97dah		;97cf	28 09 	( . 
	or a			;97d1	b7 	. 
	sbc hl,bc		;97d2	ed 42 	. B 
	jp p,l97ceh		;97d4	f2 ce 97 	. . . 
	ld hl,00005h		;97d7	21 05 00 	! . . 
l97dah:
	ld (0790bh),hl		;97da	22 0b 79 	" . y 
	ld hl,0781ch		;97dd	21 1c 78 	! . x 
	ld a,0ffh		;97e0	3e ff 	> . 
	dec (hl)			;97e2	35 	5 
	cp (hl)			;97e3	be 	. 
	jr nz,l97fah		;97e4	20 14 	  . 
	ld (hl),009h		;97e6	36 09 	6 . 
	dec hl			;97e8	2b 	+ 
	dec (hl)			;97e9	35 	5 
	cp (hl)			;97ea	be 	. 
	jr nz,l97fah		;97eb	20 0d 	  . 
	ld (hl),009h		;97ed	36 09 	6 . 
	dec hl			;97ef	2b 	+ 
	dec (hl)			;97f0	35 	5 
	cp (hl)			;97f1	be 	. 
	jr nz,l97fah		;97f2	20 06 	  . 
	ld (hl),009h		;97f4	36 09 	6 . 
l97f6h:
	ld a,001h		;97f6	3e 01 	> . 
	or a			;97f8	b7 	. 
	ret			;97f9	c9 	. 
l97fah:
	xor a			;97fa	af 	. 
	ret			;97fb	c9 	. 
l97fch:
	ld hl,0b638h		;97fc	21 38 b6 	! 8 . 
	ld de,0b639h		;97ff	11 39 b6 	. 9 . 
	ld bc,0001fh		;9802	01 1f 00 	. . . 
	ld (hl),020h		;9805	36 20 	6   
	ldir		;9807	ed b0 	. . 
	ld a,021h		;9809	3e 21 	> ! 
	ld (0b658h),a		;980b	32 58 b6 	2 X . 
	ld hl,0b638h		;980e	21 38 b6 	! 8 . 
	ld a,(07803h)		;9811	3a 03 78 	: . x 
	call sub_9874h		;9814	cd 74 98 	. t . 
	inc hl			;9817	23 	# 
	ld a,(07807h)		;9818	3a 07 78 	: . x 
	call sub_9874h		;981b	cd 74 98 	. t . 
	inc hl			;981e	23 	# 
	ld a,(0780bh)		;981f	3a 0b 78 	: . x 
	call sub_9874h		;9822	cd 74 98 	. t . 
	inc hl			;9825	23 	# 
	ld a,(0780fh)		;9826	3a 0f 78 	: . x 
	call sub_9874h		;9829	cd 74 98 	. t . 
	inc hl			;982c	23 	# 
	inc hl			;982d	23 	# 
	ld de,0781ah		;982e	11 1a 78 	. . x 
	ex de,hl			;9831	eb 	. 
	ld bc,00003h		;9832	01 03 00 	. . . 
	ldir		;9835	ed b0 	. . 
	inc de			;9837	13 	. 
	inc de			;9838	13 	. 
	ld hl,07812h		;9839	21 12 78 	! . x 
	ld bc,00005h		;983c	01 05 00 	. . . 
	ldir		;983f	ed b0 	. . 
	inc de			;9841	13 	. 
	inc de			;9842	13 	. 
	ld a,(07811h)		;9843	3a 11 78 	: . x 
	ld (de),a			;9846	12 	. 
	inc de			;9847	13 	. 
	inc de			;9848	13 	. 
	inc de			;9849	13 	. 
	ld hl,07817h		;984a	21 17 78 	! . x 
	ld bc,00001h		;984d	01 01 00 	. . . 
	ldir		;9850	ed b0 	. . 
	inc bc			;9852	03 	. 
	inc bc			;9853	03 	. 
	inc de			;9854	13 	. 
	ldir		;9855	ed b0 	. . 
	ld a,014h		;9857	3e 14 	> . 
	ld (0aacfh),a		;9859	32 cf aa 	2 . . 
	ld (0ab27h),a		;985c	32 27 ab 	2 ' . 
	ld hl,0b638h		;985f	21 38 b6 	! 8 . 
	ld de,0aa86h		;9862	11 86 aa 	. . . 
l9865h:
	ld a,(hl)			;9865	7e 	~ 
	cp 021h		;9866	fe 21 	. ! 
	ret z			;9868	c8 	. 
	push hl			;9869	e5 	. 
	cp 020h		;986a	fe 20 	.   
	call nz,sub_9889h		;986c	c4 89 98 	. . . 
	pop hl			;986f	e1 	. 
	inc de			;9870	13 	. 
	inc hl			;9871	23 	# 
	jr l9865h		;9872	18 f1 	. . 
sub_9874h:
	cp 00ah		;9874	fe 0a 	. . 
	jp m,l9885h		;9876	fa 85 98 	. . . 
	ld (hl),001h		;9879	36 01 	6 . 
	sub 00ah		;987b	d6 0a 	. . 
	cp 00ah		;987d	fe 0a 	. . 
	jp m,l9885h		;987f	fa 85 98 	. . . 
	inc (hl)			;9882	34 	4 
	sub 00ah		;9883	d6 0a 	. . 
l9885h:
	inc hl			;9885	23 	# 
	ld (hl),a			;9886	77 	w 
	inc hl			;9887	23 	# 
	ret			;9888	c9 	. 
sub_9889h:
	ld hl,l98adh		;9889	21 ad 98 	! . . 
	push de			;988c	d5 	. 
	ld de,00006h		;988d	11 06 00 	. . . 
	inc a			;9890	3c 	< 
l9891h:
	dec a			;9891	3d 	= 
	jr z,l9897h		;9892	28 03 	( . 
	add hl,de			;9894	19 	. 
	jr l9891h		;9895	18 fa 	. . 
l9897h:
	pop de			;9897	d1 	. 
	push de			;9898	d5 	. 
	ex de,hl			;9899	eb 	. 
	ld bc,(l98abh)		;989a	ed 4b ab 98 	. K . . 
	ld a,005h		;989e	3e 05 	> . 
l98a0h:
	push af			;98a0	f5 	. 
	ld a,(de)			;98a1	1a 	. 
	ld (hl),a			;98a2	77 	w 
	inc de			;98a3	13 	. 
	add hl,bc			;98a4	09 	. 
	pop af			;98a5	f1 	. 
	dec a			;98a6	3d 	= 
	jr nz,l98a0h		;98a7	20 f7 	  . 
	pop de			;98a9	d1 	. 
	ret			;98aa	c9 	. 
l98abh:
	nop			;98ab	00 	. 
	nop			;98ac	00 	. 
l98adh:
	ld d,h			;98ad	54 	T 
	ld b,h			;98ae	44 	D 
	ld b,h			;98af	44 	D 
	ld b,h			;98b0	44 	D 
	ld d,h			;98b1	54 	T 
	nop			;98b2	00 	. 
	djnz $+82		;98b3	10 50 	. P 
	djnz l98c7h		;98b5	10 10 	. . 
	ld d,h			;98b7	54 	T 
	nop			;98b8	00 	. 
	ld d,h			;98b9	54 	T 
	inc b			;98ba	04 	. 
	ld d,h			;98bb	54 	T 
	ld b,b			;98bc	40 	@ 
	ld d,h			;98bd	54 	T 
	nop			;98be	00 	. 
	ld d,h			;98bf	54 	T 
	inc b			;98c0	04 	. 
	inc d			;98c1	14 	. 
	inc b			;98c2	04 	. 
	ld d,h			;98c3	54 	T 
	nop			;98c4	00 	. 
	ld b,b			;98c5	40 	@ 
	ld b,b			;98c6	40 	@ 
l98c7h:
	ld b,h			;98c7	44 	D 
	ld d,h			;98c8	54 	T 
	inc b			;98c9	04 	. 
	nop			;98ca	00 	. 
	ld d,h			;98cb	54 	T 
	ld b,b			;98cc	40 	@ 
	ld d,h			;98cd	54 	T 
	inc b			;98ce	04 	. 
	ld d,h			;98cf	54 	T 
	nop			;98d0	00 	. 
	ld d,h			;98d1	54 	T 
	ld b,b			;98d2	40 	@ 
	ld d,h			;98d3	54 	T 
	ld b,h			;98d4	44 	D 
	ld d,h			;98d5	54 	T 
	nop			;98d6	00 	. 
	ld d,h			;98d7	54 	T 
	inc b			;98d8	04 	. 
	inc b			;98d9	04 	. 
	inc b			;98da	04 	. 
	inc b			;98db	04 	. 
	nop			;98dc	00 	. 
	ld d,h			;98dd	54 	T 
	ld b,h			;98de	44 	D 
	ld d,h			;98df	54 	T 
	ld b,h			;98e0	44 	D 
	ld d,h			;98e1	54 	T 
	nop			;98e2	00 	. 
	ld d,h			;98e3	54 	T 
	ld b,h			;98e4	44 	D 
	ld d,h			;98e5	54 	T 
	inc b			;98e6	04 	. 
	ld d,h			;98e7	54 	T 
	nop			;98e8	00 	. 
sub_98e9h:
	cp 02eh		;98e9	fe 2e 	. . 
	jr z,l9924h		;98eb	28 37 	( 7 
	cp 02ch		;98ed	fe 2c 	. , 
	jr z,l991dh		;98ef	28 2c 	( , 
	cp 03dh		;98f1	fe 3d 	. = 
	jr z,l9916h		;98f3	28 21 	( ! 
	cp 020h		;98f5	fe 20 	.   
	jr z,l992bh		;98f7	28 32 	( 2 
	cp 030h		;98f9	fe 30 	. 0 
	ret m			;98fb	f8 	. 
	cp 03ah		;98fc	fe 3a 	. : 
	jp m,l990eh		;98fe	fa 0e 99 	. . . 
	cp 041h		;9901	fe 41 	. A 
	ret m			;9903	f8 	. 
	cp 05bh		;9904	fe 5b 	. [ 
	ret p			;9906	f0 	. 
	sub 040h		;9907	d6 40 	. @ 
	ld hl,l996ch		;9909	21 6c 99 	! l . 
	jr l9930h		;990c	18 22 	. " 
l990eh:
	ld hl,l98adh		;990e	21 ad 98 	! . . 
	sub 02fh		;9911	d6 2f 	. / 
	jp l9930h		;9913	c3 30 99 	. 0 . 
l9916h:
	ld a,001h		;9916	3e 01 	> . 
	ld hl,l9a08h		;9918	21 08 9a 	! . . 
	jr l9930h		;991b	18 13 	. . 
l991dh:
	ld a,001h		;991d	3e 01 	> . 
	ld hl,l9a14h		;991f	21 14 9a 	! . . 
	jr l9930h		;9922	18 0c 	. . 
l9924h:
	ld a,001h		;9924	3e 01 	> . 
	ld hl,l9a0eh		;9926	21 0e 9a 	! . . 
	jr l9930h		;9929	18 05 	. . 
l992bh:
	ld a,001h		;992b	3e 01 	> . 
	ld hl,l9a1ah		;992d	21 1a 9a 	! . . 
l9930h:
	push de			;9930	d5 	. 
	ld de,00006h		;9931	11 06 00 	. . . 
l9934h:
	dec a			;9934	3d 	= 
	jr z,l993ah		;9935	28 03 	( . 
	add hl,de			;9937	19 	. 
	jr l9934h		;9938	18 fa 	. . 
l993ah:
	pop de			;993a	d1 	. 
	ex de,hl			;993b	eb 	. 
	ld bc,00020h		;993c	01 20 00 	.   . 
	ld a,006h		;993f	3e 06 	> . 
l9941h:
	push af			;9941	f5 	. 
	ld a,(de)			;9942	1a 	. 
	ld (hl),a			;9943	77 	w 
	inc de			;9944	13 	. 
	add hl,bc			;9945	09 	. 
	pop af			;9946	f1 	. 
	dec a			;9947	3d 	= 
	jr nz,l9941h		;9948	20 f7 	  . 
	ret			;994a	c9 	. 
l994bh:
	push de			;994b	d5 	. 
l994ch:
	ld a,(hl)			;994c	7e 	~ 
	or a			;994d	b7 	. 
	jr z,l995fh		;994e	28 0f 	( . 
	cp 00dh		;9950	fe 0d 	. . 
	jr z,l9961h		;9952	28 0d 	( . 
	push hl			;9954	e5 	. 
	push de			;9955	d5 	. 
	call sub_98e9h		;9956	cd e9 98 	. . . 
	pop de			;9959	d1 	. 
	pop hl			;995a	e1 	. 
	inc de			;995b	13 	. 
	inc hl			;995c	23 	# 
	jr l994ch		;995d	18 ed 	. . 
l995fh:
	pop de			;995f	d1 	. 
	ret			;9960	c9 	. 
l9961h:
	pop de			;9961	d1 	. 
	push hl			;9962	e5 	. 
	ld hl,000c0h		;9963	21 c0 00 	! . . 
	add hl,de			;9966	19 	. 
	ex de,hl			;9967	eb 	. 
	pop hl			;9968	e1 	. 
	inc hl			;9969	23 	# 
	jr l994bh		;996a	18 df 	. . 
l996ch:
	djnz l99b2h		;996c	10 44 	. D 
	ld d,h			;996e	54 	T 
	ld b,h			;996f	44 	D 
	ld b,h			;9970	44 	D 
	nop			;9971	00 	. 
	ld d,b			;9972	50 	P 
	ld b,h			;9973	44 	D 
	ld d,b			;9974	50 	P 
	ld b,h			;9975	44 	D 
	ld d,b			;9976	50 	P 
	nop			;9977	00 	. 
	djnz l99beh		;9978	10 44 	. D 
	ld b,b			;997a	40 	@ 
	ld b,h			;997b	44 	D 
	djnz l997eh		;997c	10 00 	. . 
l997eh:
	ld d,b			;997e	50 	P 
	ld b,h			;997f	44 	D 
	ld b,h			;9980	44 	D 
	ld b,h			;9981	44 	D 
	ld d,b			;9982	50 	P 
	nop			;9983	00 	. 
	ld d,h			;9984	54 	T 
	ld b,b			;9985	40 	@ 
	ld d,b			;9986	50 	P 
	ld b,b			;9987	40 	@ 
	ld d,h			;9988	54 	T 
	nop			;9989	00 	. 
	ld d,h			;998a	54 	T 
	ld b,b			;998b	40 	@ 
	ld d,b			;998c	50 	P 
	ld b,b			;998d	40 	@ 
	ld b,b			;998e	40 	@ 
	nop			;998f	00 	. 
	djnz l99d6h		;9990	10 44 	. D 
	ld b,b			;9992	40 	@ 
	inc d			;9993	14 	. 
	inc b			;9994	04 	. 
	nop			;9995	00 	. 
	ld b,h			;9996	44 	D 
	ld b,h			;9997	44 	D 
	ld d,h			;9998	54 	T 
	ld b,h			;9999	44 	D 
	ld b,h			;999a	44 	D 
	nop			;999b	00 	. 
	ld d,h			;999c	54 	T 
	djnz l99afh		;999d	10 10 	. . 
	djnz l99f5h		;999f	10 54 	. T 
	nop			;99a1	00 	. 
	inc b			;99a2	04 	. 
	inc b			;99a3	04 	. 
	inc b			;99a4	04 	. 
	ld b,h			;99a5	44 	D 
	djnz l99a8h		;99a6	10 00 	. . 
l99a8h:
	ld b,h			;99a8	44 	D 
	ld b,h			;99a9	44 	D 
	ld d,b			;99aa	50 	P 
	ld b,h			;99ab	44 	D 
	ld b,h			;99ac	44 	D 
	nop			;99ad	00 	. 
	ld b,b			;99ae	40 	@ 
l99afh:
	ld b,b			;99af	40 	@ 
	ld b,b			;99b0	40 	@ 
	ld b,b			;99b1	40 	@ 
l99b2h:
	ld d,h			;99b2	54 	T 
	nop			;99b3	00 	. 
	ld b,h			;99b4	44 	D 
	ld d,h			;99b5	54 	T 
	ld b,h			;99b6	44 	D 
	ld b,h			;99b7	44 	D 
	ld b,h			;99b8	44 	D 
	nop			;99b9	00 	. 
	ld b,h			;99ba	44 	D 
	ld d,h			;99bb	54 	T 
	ld d,h			;99bc	54 	T 
	ld d,h			;99bd	54 	T 
l99beh:
	ld b,h			;99be	44 	D 
	nop			;99bf	00 	. 
	djnz l9a06h		;99c0	10 44 	. D 
	ld b,h			;99c2	44 	D 
	ld b,h			;99c3	44 	D 
	djnz l99c6h		;99c4	10 00 	. . 
l99c6h:
	ld d,b			;99c6	50 	P 
	ld b,h			;99c7	44 	D 
	ld d,b			;99c8	50 	P 
	ld b,b			;99c9	40 	@ 
	ld b,b			;99ca	40 	@ 
	nop			;99cb	00 	. 
	djnz l9a12h		;99cc	10 44 	. D 
	ld b,h			;99ce	44 	D 
	ld d,h			;99cf	54 	T 
	inc b			;99d0	04 	. 
	nop			;99d1	00 	. 
	ld d,b			;99d2	50 	P 
	ld b,h			;99d3	44 	D 
	ld d,b			;99d4	50 	P 
	ld b,h			;99d5	44 	D 
l99d6h:
	ld b,h			;99d6	44 	D 
	nop			;99d7	00 	. 
	inc d			;99d8	14 	. 
	ld b,b			;99d9	40 	@ 
	djnz $+6		;99da	10 04 	. . 
	ld d,b			;99dc	50 	P 
	nop			;99dd	00 	. 
	ld d,h			;99de	54 	T 
	djnz l99f1h		;99df	10 10 	. . 
	djnz l99f3h		;99e1	10 10 	. . 
	nop			;99e3	00 	. 
	ld b,h			;99e4	44 	D 
	ld b,h			;99e5	44 	D 
	ld b,h			;99e6	44 	D 
	ld b,h			;99e7	44 	D 
	djnz l99eah		;99e8	10 00 	. . 
l99eah:
	ld b,h			;99ea	44 	D 
	ld b,h			;99eb	44 	D 
	ld b,h			;99ec	44 	D 
	djnz $+18		;99ed	10 10 	. . 
	nop			;99ef	00 	. 
	ld b,h			;99f0	44 	D 
l99f1h:
	ld b,h			;99f1	44 	D 
	ld b,h			;99f2	44 	D 
l99f3h:
	ld d,h			;99f3	54 	T 
	ld b,h			;99f4	44 	D 
l99f5h:
	nop			;99f5	00 	. 
	ld b,h			;99f6	44 	D 
	ld b,h			;99f7	44 	D 
	defb $10,$44		;99f8	10 44 	. D 
	ld b,h			;99fa	44 	D 
	nop			;99fb	00 	. 
	ld b,h			;99fc	44 	D 
	ld b,h			;99fd	44 	D 
	djnz l9a10h		;99fe	10 10 	. . 
	djnz l9a02h		;9a00	10 00 	. . 
l9a02h:
	ld d,h			;9a02	54 	T 
	inc b			;9a03	04 	. 
	defb $10,$40		;9a04	10 40 	. @ 
l9a06h:
	ld d,h			;9a06	54 	T 
	nop			;9a07	00 	. 
l9a08h:
	nop			;9a08	00 	. 
	ld d,h			;9a09	54 	T 
	nop			;9a0a	00 	. 
	ld d,h			;9a0b	54 	T 
	nop			;9a0c	00 	. 
	nop			;9a0d	00 	. 
l9a0eh:
	nop			;9a0e	00 	. 
	nop			;9a0f	00 	. 
l9a10h:
	nop			;9a10	00 	. 
	ld d,b			;9a11	50 	P 
l9a12h:
	ld d,b			;9a12	50 	P 
	nop			;9a13	00 	. 
l9a14h:
	nop			;9a14	00 	. 
	nop			;9a15	00 	. 
	nop			;9a16	00 	. 
	ld d,b			;9a17	50 	P 
	djnz l9a1ah		;9a18	10 00 	. . 
l9a1ah:
	nop			;9a1a	00 	. 
	nop			;9a1b	00 	. 
	nop			;9a1c	00 	. 
	nop			;9a1d	00 	. 
	nop			;9a1e	00 	. 
	nop			;9a1f	00 	. 

;***********************************************************************************************
; Clear Screen and set Graphics MODE 0 with default Color Palette
CLEAR_SCREEN_TXT:
; -- fill video memory (first 512 bytes) with inverse SPACE char
	ld hl,VRAM				; src - video memory start								;9a20	21 00 70 
	ld de,VRAM+1			; dst - next byte										;9a23	11 01 70 
	ld bc,511				; ctn - size of video memory in MODE 0 (txt)			;9a26	01 ff 01
	ld (hl),$60				; inverse SPACE char to fill the screen					;9a29	36 60 
	ldir					; fill VRAM with given char (SPACE)						;9a2b	ed b0 
; -- set Video Text Mode 0, Color Palette 0
	xor a					; VDG Txt MODE 0 Colors (Green)							;9a2d	af 
	ld (IOLATCH),a			; store to hardware register							;9a2e	32 00 68
	ret						; ----------------- End of Proc ---------------			;9a31	c9  

;***********************************************************************************************
; Print Text on Screen in Text Mode. Supports CR/LF char (13)
; IN: hl - null terminated text
;     de - destination VRAM address
PRINT_TEXT:
	push de					; save de - VRAM address								;9a32	d5 
.NEXT_CHAR:
	ld a,(hl)				; a - char to display on screen							;9a33	7e 
	or a					; check if 0 - end of text								;9a34	b7 
	jr z,.EXIT				; yes ------------ End of Proc ------------------------ ;9a35	28 0b 
	cp 13					; chack if CR/LF char 									;9a37	fe 0d 
	jr z,.NEXT_LINE			; yes - move destination addres to next line			;9a39	28 09 
	set 6,a					; set INVERSE bit for char								;9a3b	cb f7 
	ld (de),a				; store in VRAM - display char							;9a3d	12 
	inc hl					; hl - next char in source text							;9a3e	23 
	inc de					; de - next VRAM destination address					;9a3f	13 
	jr .NEXT_CHAR			; print next char										;9a40	18 f1 
.EXIT:
	pop de					; restore de - VRAM address								;9a42	d1 
	ret						; ----------------- End of Proc ----------------------- ;9a43	c9 
.NEXT_LINE:
	pop de					; restore de - VRAM address of line begin				;9a44	d1 
	push hl					; save hl - source adrress								;9a45	e5 
	ld hl,32				; 32 bytes per screen line								;9a46	21 20 00 
	add hl,de				; hl - VRAM address of next line						;9a49	19 
	ex de,hl				; de - new destination VRAM address						;9a4a	eb 
	pop hl					; restore hl - source address							;9a4b	e1 
	inc hl					; hl - next char to display (skip CR/LF)				;9a4c	23 
	jr PRINT_TEXT			; print next char										;9a4d	18 e3 


l9a4fh:
	call CLEAR_SCREEN_TXT	; clear screen - Mode 0 (TXT)							;9a4f	cd 20 9a
	ld hl,TXT_MANUAL_PAGE1	; instruction text - Page 1								;9a52	21 d8 9a 
	ld de,VRAM				; dst - screen coord (0,0)								;9a55	11 00 70 
	call PRINT_TEXT			; print Instruction Page 1 on screen					;9a58	cd 32 9a 
	call sub_9aa0h		;9a5b	cd a0 9a 	. . . 
	call CLEAR_SCREEN_TXT	; clear screen - Mode 0 (TXT)							;9a5e	cd 20 9a  
	ld hl,TXT_MANUAL_PAGE2	; instruction text - Page 2								;9a61	21 03 9c 
	ld de,VRAM+(32*1)+0		; dst - screen coord (0,1)								;9a64	11 20 70 
	call PRINT_TEXT			; print Instruction Page 2 on screen					;9a67	cd 32 9a  
	call sub_9aa0h		;9a6a	cd a0 9a 	. . . 
	call CLEAR_SCREEN_TXT	; clear screen - Mode 0 (TXT)							;9a6d	cd 20 9a 
	ld hl,TXT_MANUAL_PAGE3	; instruction text - Page 3								;9a70	21 6e 9d 
	ld de,VRAM+(32*1)+0		; dst - screen coord (0,1)								;9a73	11 20 70 
	call PRINT_TEXT			; print Instruction Page 3 on screen					;9a76	cd 32 9a 
	call sub_9aa0h		;9a79	cd a0 9a 	. . . 
	call CLEAR_SCREEN_TXT	; clear screen - Mode 0 (TXT)							;9a7c	cd 20 9a 
	ld hl,l9eebh		;9a7f	21 eb 9e 	! . . 
	ld de,VRAM+(32*1)+0		; dst - screen coord (0,1)								;9a82	11 20 70
	call PRINT_TEXT		;9a85	cd 32 9a 	. 2 . 
	call sub_9aa0h		;9a88	cd a0 9a 	. . . 
	call CLEAR_SCREEN_TXT	; clear screen - Mode 0 (TXT)							;9a8b	cd 20 9a 
	ld hl,la01eh		;9a8e	21 1e a0 	! . . 
	ld de,VRAM+(32*1)+0		; dst - screen coord (0,1)								;9a91	11 20 70  
	call PRINT_TEXT		;9a94	cd 32 9a 	. 2 . 
	call sub_9aa0h		;9a97	cd a0 9a 	. . . 
	call sub_944bh		;9a9a	cd 4b 94 	. K . 
	jp l8fcbh		;9a9d	c3 cb 8f 	. . . 
sub_9aa0h:
	ld hl,la0dch		;9aa0	21 dc a0 	! . . 
	ld de,071e0h		;9aa3	11 e0 71 	. . q 
	call PRINT_TEXT		;9aa6	cd 32 9a 	. 2 . 
l9aa9h:
	ld a,(KEYS_ROW_2)		;9aa9	3a fb 68 	: . h 
	bit 3,a		;9aac	cb 5f 	. _ 
	jr nz,l9aa9h		;9aae	20 f9 	  . 
l9ab0h:
	ld a,(KEYS_ROW_2)		;9ab0	3a fb 68 	: . h 
	bit 3,a		;9ab3	cb 5f 	. _ 
	jr z,l9ab0h		;9ab5	28 f9 	( . 
	ld de,02000h		;9ab7	11 00 20 	. .   
	call sub_941dh		;9aba	cd 1d 94 	. . . 
	ld a,(KEYS_ROW_2)		;9abd	3a fb 68 	: . h 
	bit 3,a		;9ac0	cb 5f 	. _ 
	jr z,l9ab0h		;9ac2	28 ec 	( . 
	ret			;9ac4	c9 	. 


;***********************************************************************************************
;
;    G A M E   T X T   D A T A
;
;***********************************************************************************************

	;module TXT

;***********************************************************************************************
; Input Settings Question text
TXT_JOYSTICK_Q:
	defb "JOYSTICK    Y OR N",0					;9ac5	4a 4f 59 53 54 49 43 4b 20 20 20 20 59 20 4f 52 20 4e 00



TXT_MANUAL_PAGE1:
	defb 13										;9ad8	0d 
	defb "     D A W N    P A T R O L",13		;9ad9	20 20 20 20 20 44 20 41 20 57 20 4e 20 20 20 20 50 20 41 20 54 20 52 20 4f 20 4c 0d
	defb 13										;9af5	0d 
	defb "YOU HAVE TO RESCUE 80 PRISONERS",13	;9af6	59 4f 55 20 48 41 56 45 20 54 4f 20 52 45 53 43 55 45 20 38 30 20 50 52 49 53 4f 4e 45 52 53 0d
	defb "FROM 4 ENEMY PRISON CAMPS. TO",13		;9b16	46 52 4f 4d 20 34 20 45 4e 45 4d 59 20 50 52 49 53 4f 4e 20 43 41 4d 50 53 2e 20 54 4f 0d 
	defb "RESCUE PRISONERS YOU HAVE TO",13		;9b34	52 45 53 43 55 45 20 50 52 49 53 4f 4e 45 52 53 20 59 4f 55 20 48 41 56 45 20 54 4f 0d 
	defb "LAND IN THE PRISON ENCLOSURE.",13		;9b51	4c 41 4e 44 20 49 4e 20 54 48 45 20 50 52 49 53 4f 4e 20 45 4e 43 4c 4f 53 55 52 45 2e 0d 
	defb "PRISONERS WILL RUN OUT AND GET",13	;9b6f	50 52 49 53 4f 4e 45 52 53 20 57 49 4c 4c 20 52 55 4e 20 4f 55 54 20 41 4e 44 20 47 45 54 0d
	defb "INTO YOUR HELICOPTER ONCE YOU",13		;9b8e	49 4e 54 4f 20 59 4f 55 52 20 48 45 4c 49 43 4f 50 54 45 52 20 4f 4e 43 45 20 59 4f 55 0d
	defb "HAVE LANDED. THE MORE PRISONERS",13	;9bac	48 41 56 45 20 4c 41 4e 44 45 44 2e 20 54 48 45 20 4d 4f 52 45 20 50 52 49 53 4f 4e 45 52 53 0d
	defb "IN YOUR HELICOPTER THE FASTER",13		;9bcc	49 4e 20 59 4f 55 52 20 48 45 4c 49 43 4f 50 54 45 52 20 54 48 45 20 46 41 53 54 45 52 0d
	defb "IT WILL USE UP ITS FUEL.",0			;9bea	49 54 20 57 49 4c 4c 20 55 53 45 20 55 50 20 49 54 53 20 46 55 45 4c 2e 00 	


TXT_MANUAL_PAGE2:
	defb "YOU MUST RETURN BACK TO YOUR",13		;9c03	59 4f 55 20 4d 55 53 54 20 52 45 54 55 52 4e 20 42 41 43 4b 20 54 4f 20 59 4f 55 52 0d 
	defb "BASE BEFORE YOUR FUEL RUNS OUT.",13	;9c20	42 41 53 45 20 42 45 46 4f 52 45 20 59 4f 55 52 20 46 55 45 4c 20 52 55 4e 53 20 4f 55 54 2e 0d 
	defb "YOUR MISSION STARTS AT 4.00 AM",13	;9c40	59 4f 55 52 20 4d 49 53 53 49 4f 4e 20 53 54 41 52 54 53 20 41 54 20 34 2e 30 30 20 41 4d 0d
	defb "AND WILL TERMINATE AT 6.00 AM.",13	;9c5f	41 4e 44 20 57 49 4c 4c 20 54 45 52 4d 49 4e 41 54 45 20 41 54 20 36 2e 30 30 20 41 4d 2e 0d
	defb "YOU HAVE 4 HELICOPTERS AT YOUR",13	;9c7e	59 4f 55 20 48 41 56 45 20 34 20 48 45 4c 49 43 4f 50 54 45 52 53 20 41 54 20 59 4f 55 52 0d 
	defb "DISPOSAL. RESCUED MEN ARE ",13		;9c9d	44 49 53 50 4f 53 41 4c 2e 20 52 45 53 43 55 45 44 20 4d 45 4e 20 41 52 45 20 0d 
	defb "WORTH 100, 200, 500 AND 1500",13		;9cb8	57 4f 52 54 48 20 31 30 30 2c 20 32 30 30 2c 20 35 30 30 20 41 4e 44 20 31 35 30 30 0d 
	defb "POINTS DEPENDING UPON WHETHER",13		;9cd5	50 4f 49 4e 54 53 20 44 45 50 45 4e 44 49 4e 47 20 55 50 4f 4e 20 57 48 45 54 48 45 52 0d 
	defb "THEY ARE IN THE FOURTH OR FIRST",13	;9cf3	54 48 45 59 20 41 52 45 20 49 4e 20 54 48 45 20 46 4f 55 52 54 48 20 4f 52 20 46 49 52 53 54 0d
	defb "CAMP. (FOURTH IS THE CLOSEST)",13		;9d13	43 41 4d 50 2e 20 28 46 4f 55 52 54 48 20 49 53 20 54 48 45 20 43 4c 4f 53 45 53 54 29 0d 
	defb "YOUR HELICOPTER MUST NOT HIT ",13		;9d31	59 4f 55 52 20 48 45 4c 49 43 4f 50 54 45 52 20 4d 55 53 54 20 4e 4f 54 20 48 49 54 20 0d 
	defb "OR BE HIT BY ANY OBSTACLE WITH",0		;9d4f	4f 52 20 42 45 20 48 49 54 20 42 59 20 41 4e 59 20 4f 42 53 54 41 43 4c 45 20 57 49 54 48 00


TXT_MANUAL_PAGE3:
	defb "THE EXCEPTION OF A PLANE COMING",13	;9d6e	54 48 45 20 45 58 43 45 50 54 49 4f 4e 20 4f 46 20 41 20 50 4c 41 4e 45 20 43 4f 4d 49 4e 47 0d
	defb "TOWARDS OR GOING AWAY FROM YOU,",13	;9d8e	54 4f 57 41 52 44 53 20 4f 52 20 47 4f 49 4e 47 20 41 57 41 59 20 46 52 4f 4d 20 59 4f 55 2c 0d
	defb "ANY EXPLOSION OR A PRISONER.",13		;9dae	41 4e 59 20 45 58 50 4c 4f 53 49 4f 4e 20 4f 52 20 41 20 50 52 49 53 4f 4e 45 52 2e 0d 
	defb "IF THE HELICOPTER IS FACING YOU",13	;9dcb	49 46 20 54 48 45 20 48 45 4c 49 43 4f 50 54 45 52 20 49 53 20 46 41 43 49 4e 47 20 59 4f 55 0d 
	defb "THEN IT WILL SHOOT STRAIGHT DOWN",13	;9deb	54 48 45 4e 20 49 54 20 57 49 4c 4c 20 53 48 4f 4f 54 20 53 54 52 41 49 47 48 54 20 44 4f 57 4e 0d 
	defb "ONLY 6 HELICOPTER BULLETS ARE ",13	;9e0c	4f 4e 4c 59 20 36 20 48 45 4c 49 43 4f 50 54 45 52 20 42 55 4c 4c 45 54 53 20 41 52 45 20 0d 
	defb "ALLOWED ON THE SCREEN AT ONE ",13		;9e2b	41 4c 4c 4f 57 45 44 20 4f 4e 20 54 48 45 20 53 43 52 45 45 4e 20 41 54 20 4f 4e 45 20 0d 
	defb "TIME. PLANES CANNOT BE SHOT.",13		;9e49	54 49 4d 45 2e 20 50 4c 41 4e 45 53 20 43 41 4e 4e 4f 54 20 42 45 20 53 48 4f 54 2e 0d 
	defb "YOUR MISSION WILL BE OVER WHEN",13	;9e66	59 4f 55 52 20 4d 49 53 53 49 4f 4e 20 57 49 4c 4c 20 42 45 20 4f 56 45 52 20 57 48 45 4e 0d
	defb "YOU HAVE LOST ALL YOUR",13			;9e85	59 4f 55 20 48 41 56 45 20 4c 4f 53 54 20 41 4c 4c 20 59 4f 55 52 0d
	defb "HELICOPTERS, HAVE RUN OUT OF",13		;9e9c	48 45 4c 49 43 4f 50 54 45 52 53 2c 20 48 41 56 45 20 52 55 4e 20 4f 55 54 20 4f 46 0d 
	defb "TIME OR HAVE RESCUED ALL THE",13		;9eb9	54 49 4d 45 20 4f 52 20 48 41 56 45 20 52 45 53 43 55 45 44 20 41 4c 4c 20 54 48 45 0d 
	defb "REMAINING PRISONERS.",0				;9ed6	52 45 4d 41 49 4e 49 4e 47 20 50 52 49 53 4f 4e 45 52 53 2e 00 	


l9eebh:
	defb "THE TOP LINE OF THE SCREEN",13		;9eeb	54 48 45 20 54 4f 50 20 4c 49 4e 45 20 4f 46 20 54 48 45 20 53 43 52 45 45 4e 0d
	defb "WILL DISPLAY THE FOLLOWING ",13		;9f06	57 49 4c 4c 20 44 49 53 50 4c 41 59 20 54 48 45 20 46 4f 4c 4c 4f 57 49 4e 47 20 0d
	defb "INFORMATION. PRISONERS LEFT",13		;9f22	49 4e 46 4f 52 4d 41 54 49 4f 4e 2e 20 50 52 49 53 4f 4e 45 52 53 20 4c 45 46 54 0d
	defb "IN CAMP ONE, TWO, THREE AND ",13		;9f3e	49 4e 20 43 41 4d 50 20 4f 4e 45 2c 20 54 57 4f 2c 20 54 48 52 45 45 20 41 4e 44 20 0d
	defb "FOUR (FOUR BEING THE CLOSEST)",13		;9f5b	46 4f 55 52 20 28 46 4f 55 52 20 42 45 49 4e 47 20 54 48 45 20 43 4c 4f 53 45 53 54 29 0d
	defb "FUEL LEFT, TOTAL SCORE,",13			;9f79	46 55 45 4c 20 4c 45 46 54 2c 20 54 4f 54 41 4c 20 53 43 4f 52 45 2c 0d
	defb "NUMBER OF HELICOPTERS LEFT",13		;9f91	4e 55 4d 42 45 52 20 4f 46 20 48 45 4c 49 43 4f 50 54 45 52 53 20 4c 45 46 54 0d
	defb "AND PRESENT TIME. AT THE",13			;9fac	41 4e 44 20 50 52 45 53 45 4e 54 20 54 49 4d 45 2e 20 41 54 20 54 48 45 0d
	defb "BEGINNING OF A GAME IT WILL",13		;9fc5	42 45 47 49 4e 4e 49 4e 47 20 4f 46 20 41 20 47 41 4d 45 20 49 54 20 57 49 4c 4c 0d
	defb "SHOW THE FOLLOWING NUMBERS.",13		;9fe1	53 48 4f 57 20 54 48 45 20 46 4f 4c 4c 4f 57 49 4e 47 20 4e 55 4d 42 45 52 53 2e 0d 
	defb "20 20 20 20  999  00000  4  4.00",0	;9ffd	32 30 20 32 30 20 32 30 20 32 30 20 20 39 39 39 20 20 30 30 30 30 30 20 20 34 20 20 34 2e 30 30 00 


la01eh:
	defb "IF YOU GET ONE OF THE TOP TEN",13		;a01e	49 46 20 59 4f 55 20 47 45 54 20 4f 4e 45 20 4f 46 20 54 48 45 20 54 4f 50 20 54 45 4e 0d
	defb "HIGH SCORES YOU CAN PUT YOUR",13		;a03c	48 49 47 48 20 53 43 4f 52 45 53 20 59 4f 55 20 43 41 4e 20 50 55 54 20 59 4f 55 52 0d
	defb "NAME ON THE SCORE BOARD. TO DO",13	;a059	4e 41 4d 45 20 4f 4e 20 54 48 45 20 53 43 4f 52 45 20 42 4f 41 52 44 2e 20 54 4f 20 44 4f 0d
	defb "THIS USE THE ARROW KEYS TO ",13		;a078	54 48 49 53 20 55 53 45 20 54 48 45 20 41 52 52 4f 57 20 4b 45 59 53 20 54 4f 20 0d
	defb "POSITION THE BOX OVER THE CHAR.",13	;a094	50 4f 53 49 54 49 4f 4e 20 54 48 45 20 42 4f 58 20 4f 56 45 52 20 54 48 45 20 43 48 41 52 2e 0d
	defb "OR COMMAND REQUIRED AND PRESS",13		;a0b4	4f 52 20 43 4f 4d 4d 41 4e 44 20 52 45 51 55 49 52 45 44 20 41 4e 44 20 50 52 45 53 53 0d 
	defb "<RETURN>.",0							;a0d2	3c 52 45 54 55 52 4e 3e 2e 00 


la0dch:
	defb "   PRESS  <C>  TO  CONTINUE",0		;a0dc	20 20 20 50 52 45 53 53 20 20 3c 43 3e 20 20 54 4f 20 20 43 4f 4e 54 49 4e 55 45 00

	;endmodule

	nop			;a0f8	00 	. 
	nop			;a0f9	00 	. 
	nop			;a0fa	00 	. 
la0fbh:
	nop			;a0fb	00 	. 
	nop			;a0fc	00 	. 
	nop			;a0fd	00 	. 
la0feh:
	nop			;a0fe	00 	. 
la0ffh:
	nop			;a0ff	00 	. 
la100h:
	xor d			;a100	aa 	. 
	xor d			;a101	aa 	. 
	xor d			;a102	aa 	. 
	xor b			;a103	a8 	. 
	nop			;a104	00 	. 
	nop			;a105	00 	. 
la106h:
	nop			;a106	00 	. 
	ld (bc),a			;a107	02 	. 
	nop			;a108	00 	. 
	nop			;a109	00 	. 
la10ah:
	ld (bc),a			;a10a	02 	. 
	nop			;a10b	00 	. 
	nop			;a10c	00 	. 
	dec d			;a10d	15 	. 
	ld d,b			;a10e	50 	P 
la10fh:
	nop			;a10f	00 	. 
	ld (bc),a			;a110	02 	. 
	nop			;a111	00 	. 
la112h:
	rrca			;a112	0f 	. 
	push de			;a113	d5 	. 
	ld d,l			;a114	55 	U 
	ld d,l			;a115	55 	U 
	ld l,d			;a116	6a 	j 
	and b			;a117	a0 	. 
	ccf			;a118	3f 	? 
	push de			;a119	d5 	. 
	ld d,l			;a11a	55 	U 
	ld d,l			;a11b	55 	U 
	ld d,d			;a11c	52 	R 
la11dh:
	nop			;a11d	00 	. 
	dec d			;a11e	15 	. 
	ld d,l			;a11f	55 	U 
	ld d,l			;a120	55 	U 
	ld d,h			;a121	54 	T 
	ld (bc),a			;a122	02 	. 
	nop			;a123	00 	. 
	ld bc,05555h		;a124	01 55 55 	. U U 
	nop			;a127	00 	. 
	nop			;a128	00 	. 
	nop			;a129	00 	. 
	defb $20,$80		;a12a	20 80 	  . 
	add a,b			;a12c	80 	. 
	nop			;a12d	00 	. 
	nop			;a12e	00 	. 
	nop			;a12f	00 	. 
la130h:
	ld a,(bc)			;a130	0a 	. 
	xor d			;a131	aa 	. 
	xor d			;a132	aa 	. 
	nop			;a133	00 	. 
	nop			;a134	00 	. 
	nop			;a135	00 	. 
	nop			;a136	00 	. 
	ld hl,(000a0h)		;a137	2a a0 00 	* . . 
	nop			;a13a	00 	. 
	nop			;a13b	00 	. 
	nop			;a13c	00 	. 
	ld (bc),a			;a13d	02 	. 
	nop			;a13e	00 	. 
	nop			;a13f	00 	. 
la140h:
	jr nz,la162h		;a140	20 20 	    
	nop			;a142	00 	. 
	dec d			;a143	15 	. 
	ld d,b			;a144	50 	P 
	nop			;a145	00 	. 
	ex af,af'			;a146	08 	. 
	add a,b			;a147	80 	. 
	rrca			;a148	0f 	. 
	push de			;a149	d5 	. 
	ld d,l			;a14a	55 	U 
	ld d,l			;a14b	55 	U 
	ld d,(hl)			;a14c	56 	V 
	nop			;a14d	00 	. 
	ccf			;a14e	3f 	? 
	push de			;a14f	d5 	. 
	ld d,l			;a150	55 	U 
	ld d,l			;a151	55 	U 
	ld e,b			;a152	58 	X 
	add a,b			;a153	80 	. 
	dec d			;a154	15 	. 
	ld d,l			;a155	55 	U 
	ld d,l			;a156	55 	U 
	ld d,h			;a157	54 	T 
	defb $20,$20		;a158	20 20 	    
	ld bc,05555h		;a15a	01 55 55 	. U U 
	nop			;a15d	00 	. 
	nop			;a15e	00 	. 
	nop			;a15f	00 	. 
	defb $20,$80		;a160	20 80 	  . 
la162h:
	add a,b			;a162	80 	. 
	nop			;a163	00 	. 
	nop			;a164	00 	. 
	nop			;a165	00 	. 
	ld a,(bc)			;a166	0a 	. 
	xor d			;a167	aa 	. 
	xor d			;a168	aa 	. 
	nop			;a169	00 	. 
	nop			;a16a	00 	. 
	nop			;a16b	00 	. 
	nop			;a16c	00 	. 
	ld (bc),a			;a16d	02 	. 
	xor d			;a16e	aa 	. 
	xor d			;a16f	aa 	. 
	xor d			;a170	aa 	. 
	and b			;a171	a0 	. 
	ex af,af'			;a172	08 	. 
	nop			;a173	00 	. 
	nop			;a174	00 	. 
	ex af,af'			;a175	08 	. 
	nop			;a176	00 	. 
	nop			;a177	00 	. 
	ex af,af'			;a178	08 	. 
	nop			;a179	00 	. 
la17ah:
	nop			;a17a	00 	. 
	ld d,l			;a17b	55 	U 
	ld b,b			;a17c	40 	@ 
	nop			;a17d	00 	. 
	xor d			;a17e	aa 	. 
	sub l			;a17f	95 	. 
	ld d,l			;a180	55 	U 
	ld d,l			;a181	55 	U 
	ld a,a			;a182	7f 	 
	nop			;a183	00 	. 
	ex af,af'			;a184	08 	. 
	ld d,l			;a185	55 	U 
	ld d,l			;a186	55 	U 
	ld d,l			;a187	55 	U 
	ld a,a			;a188	7f 	 
	ret nz			;a189	c0 	. 
	ex af,af'			;a18a	08 	. 
	ld bc,05555h		;a18b	01 55 55 	. U U 
	ld d,l			;a18e	55 	U 
	ld b,b			;a18f	40 	@ 
	nop			;a190	00 	. 
	nop			;a191	00 	. 
	dec b			;a192	05 	. 
	ld d,l			;a193	55 	U 
	ld d,h			;a194	54 	T 
	nop			;a195	00 	. 
	nop			;a196	00 	. 
	nop			;a197	00 	. 
	nop			;a198	00 	. 
	jr nz,$+34		;a199	20 20 	    
	add a,b			;a19b	80 	. 
	nop			;a19c	00 	. 
	nop			;a19d	00 	. 
	ld a,(bc)			;a19e	0a 	. 
	xor d			;a19f	aa 	. 
	xor d			;a1a0	aa 	. 
	nop			;a1a1	00 	. 
	nop			;a1a2	00 	. 
	nop			;a1a3	00 	. 
	nop			;a1a4	00 	. 
	xor d			;a1a5	aa 	. 
	add a,b			;a1a6	80 	. 
	nop			;a1a7	00 	. 
	add a,b			;a1a8	80 	. 
	add a,b			;a1a9	80 	. 
	nop			;a1aa	00 	. 
	ex af,af'			;a1ab	08 	. 
	nop			;a1ac	00 	. 
	nop			;a1ad	00 	. 
	ld (00000h),hl		;a1ae	22 00 00 	" . . 
	ld d,l			;a1b1	55 	U 
	ld b,b			;a1b2	40 	@ 
	nop			;a1b3	00 	. 
	add hl,bc			;a1b4	09 	. 
	ld d,l			;a1b5	55 	U 
	ld d,l			;a1b6	55 	U 
	ld d,l			;a1b7	55 	U 
	ld a,a			;a1b8	7f 	 
	nop			;a1b9	00 	. 
	ld (05555h),hl		;a1ba	22 55 55 	" U U 
	ld d,l			;a1bd	55 	U 
	ld a,a			;a1be	7f 	 
	ret nz			;a1bf	c0 	. 
	add a,b			;a1c0	80 	. 
	add a,c			;a1c1	81 	. 
	ld d,l			;a1c2	55 	U 
	ld d,l			;a1c3	55 	U 
	ld d,l			;a1c4	55 	U 
	ld b,b			;a1c5	40 	@ 
	nop			;a1c6	00 	. 
	nop			;a1c7	00 	. 
	dec b			;a1c8	05 	. 
	ld d,l			;a1c9	55 	U 
	ld d,h			;a1ca	54 	T 
	nop			;a1cb	00 	. 
	nop			;a1cc	00 	. 
	nop			;a1cd	00 	. 
	nop			;a1ce	00 	. 
	jr nz,la1f1h		;a1cf	20 20 	    
	add a,b			;a1d1	80 	. 
	nop			;a1d2	00 	. 
	nop			;a1d3	00 	. 
	ld a,(bc)			;a1d4	0a 	. 
	xor d			;a1d5	aa 	. 
	xor d			;a1d6	aa 	. 
	nop			;a1d7	00 	. 
	ld (bc),a			;a1d8	02 	. 
	xor d			;a1d9	aa 	. 
	xor d			;a1da	aa 	. 
	xor d			;a1db	aa 	. 
	xor b			;a1dc	a8 	. 
	nop			;a1dd	00 	. 
	nop			;a1de	00 	. 
	nop			;a1df	00 	. 
	ld a,(bc)			;a1e0	0a 	. 
	nop			;a1e1	00 	. 
	nop			;a1e2	00 	. 
	nop			;a1e3	00 	. 
	nop			;a1e4	00 	. 
	nop			;a1e5	00 	. 
	dec d			;a1e6	15 	. 
	ld b,b			;a1e7	40 	@ 
	nop			;a1e8	00 	. 
	nop			;a1e9	00 	. 
	nop			;a1ea	00 	. 
	ld bc,0d47fh		;a1eb	01 7f d4 	.  . 
	nop			;a1ee	00 	. 
	nop			;a1ef	00 	. 
	nop			;a1f0	00 	. 
la1f1h:
	dec b			;a1f1	05 	. 
	rst 38h			;a1f2	ff 	. 
	push af			;a1f3	f5 	. 
	nop			;a1f4	00 	. 
	nop			;a1f5	00 	. 
	nop			;a1f6	00 	. 
	dec b			;a1f7	05 	. 
	rst 38h			;a1f8	ff 	. 
	push af			;a1f9	f5 	. 
	nop			;a1fa	00 	. 
	nop			;a1fb	00 	. 
	nop			;a1fc	00 	. 
	ld bc,05455h		;a1fd	01 55 54 	. U T 
	nop			;a200	00 	. 
	nop			;a201	00 	. 
	nop			;a202	00 	. 
	ld (bc),a			;a203	02 	. 
	dec b			;a204	05 	. 
	ex af,af'			;a205	08 	. 
	nop			;a206	00 	. 
	nop			;a207	00 	. 
	nop			;a208	00 	. 
	ex af,af'			;a209	08 	. 
	nop			;a20a	00 	. 
	ld (bc),a			;a20b	02 	. 
	nop			;a20c	00 	. 
	nop			;a20d	00 	. 
	nop			;a20e	00 	. 
	ld (bc),a			;a20f	02 	. 
	xor d			;a210	aa 	. 
	xor b			;a211	a8 	. 
	nop			;a212	00 	. 
	nop			;a213	00 	. 
	nop			;a214	00 	. 
	nop			;a215	00 	. 
	ld a,(bc)			;a216	0a 	. 
	nop			;a217	00 	. 
	nop			;a218	00 	. 
	nop			;a219	00 	. 
	nop			;a21a	00 	. 
	nop			;a21b	00 	. 
	dec d			;a21c	15 	. 
	ld b,b			;a21d	40 	@ 
	nop			;a21e	00 	. 
	nop			;a21f	00 	. 
	nop			;a220	00 	. 
	ld bc,0d47fh		;a221	01 7f d4 	.  . 
	nop			;a224	00 	. 
	nop			;a225	00 	. 
	nop			;a226	00 	. 
	dec b			;a227	05 	. 
	rst 38h			;a228	ff 	. 
	push af			;a229	f5 	. 
	nop			;a22a	00 	. 
	nop			;a22b	00 	. 
	nop			;a22c	00 	. 
	dec b			;a22d	05 	. 
	rst 38h			;a22e	ff 	. 
	push af			;a22f	f5 	. 
	nop			;a230	00 	. 
	nop			;a231	00 	. 
	nop			;a232	00 	. 
	ld bc,05455h		;a233	01 55 54 	. U T 
	nop			;a236	00 	. 
	nop			;a237	00 	. 
	nop			;a238	00 	. 
	ld (bc),a			;a239	02 	. 
	dec b			;a23a	05 	. 
	ex af,af'			;a23b	08 	. 
	nop			;a23c	00 	. 
	nop			;a23d	00 	. 
	nop			;a23e	00 	. 
	ex af,af'			;a23f	08 	. 
	nop			;a240	00 	. 
	ld (bc),a			;a241	02 	. 
	nop			;a242	00 	. 
	nop			;a243	00 	. 
	ld a,(bc)			;a244	0a 	. 
	xor d			;a245	aa 	. 
	xor d			;a246	aa 	. 
	xor d			;a247	aa 	. 
	add a,b			;a248	80 	. 
	nop			;a249	00 	. 
	nop			;a24a	00 	. 
	nop			;a24b	00 	. 
	jr nz,la24eh		;a24c	20 00 	  . 
la24eh:
	nop			;a24e	00 	. 
	jr nz,la251h		;a24f	20 00 	  . 
la251h:
	ld bc,00055h		;a251	01 55 00 	. U . 
	nop			;a254	00 	. 
	jr nz,la257h		;a255	20 00 	  . 
la257h:
	defb 0fdh,055h,055h	;illegal sequence		;a257	fd 55 55 	. U U 
	ld d,(hl)			;a25a	56 	V 
	xor d			;a25b	aa 	. 
	inc bc			;a25c	03 	. 
	defb 0fdh,055h,055h	;illegal sequence		;a25d	fd 55 55 	. U U 
	ld d,l			;a260	55 	U 
	jr nz,la264h		;a261	20 01 	  . 
	ld d,l			;a263	55 	U 
la264h:
	ld d,l			;a264	55 	U 
	ld d,l			;a265	55 	U 
	ld b,b			;a266	40 	@ 
	jr nz,la269h		;a267	20 00 	  . 
la269h:
	dec d			;a269	15 	. 
	ld d,l			;a26a	55 	U 
	ld d,b			;a26b	50 	P 
	nop			;a26c	00 	. 
	nop			;a26d	00 	. 
	ld (bc),a			;a26e	02 	. 
	ex af,af'			;a26f	08 	. 
	ex af,af'			;a270	08 	. 
	nop			;a271	00 	. 
	nop			;a272	00 	. 
	nop			;a273	00 	. 
	nop			;a274	00 	. 
	xor d			;a275	aa 	. 
	xor d			;a276	aa 	. 
	and b			;a277	a0 	. 
	nop			;a278	00 	. 
	nop			;a279	00 	. 
	nop			;a27a	00 	. 
	ld (bc),a			;a27b	02 	. 
	xor d			;a27c	aa 	. 
	nop			;a27d	00 	. 
	nop			;a27e	00 	. 
	nop			;a27f	00 	. 
	nop			;a280	00 	. 
	nop			;a281	00 	. 
	jr nz,la284h		;a282	20 00 	  . 
la284h:
	ld (bc),a			;a284	02 	. 
	ld (bc),a			;a285	02 	. 
	nop			;a286	00 	. 
	ld bc,00055h		;a287	01 55 00 	. U . 
	nop			;a28a	00 	. 
	adc a,b			;a28b	88 	. 
	nop			;a28c	00 	. 
	defb 0fdh,055h,055h	;illegal sequence		;a28d	fd 55 55 	. U U 
	ld d,l			;a290	55 	U 
	ld h,b			;a291	60 	` 
	inc bc			;a292	03 	. 
	defb 0fdh,055h,055h	;illegal sequence		;a293	fd 55 55 	. U U 
	ld d,l			;a296	55 	U 
	adc a,b			;a297	88 	. 
	ld bc,05555h		;a298	01 55 55 	. U U 
	ld d,l			;a29b	55 	U 
	ld b,d			;a29c	42 	B 
	ld (bc),a			;a29d	02 	. 
	nop			;a29e	00 	. 
	dec d			;a29f	15 	. 
	ld d,l			;a2a0	55 	U 
	ld d,b			;a2a1	50 	P 
	nop			;a2a2	00 	. 
	nop			;a2a3	00 	. 
	ld (bc),a			;a2a4	02 	. 
	ex af,af'			;a2a5	08 	. 
	ex af,af'			;a2a6	08 	. 
	nop			;a2a7	00 	. 
	nop			;a2a8	00 	. 
	nop			;a2a9	00 	. 
	nop			;a2aa	00 	. 
	xor d			;a2ab	aa 	. 
	xor d			;a2ac	aa 	. 
	and b			;a2ad	a0 	. 
	nop			;a2ae	00 	. 
	nop			;a2af	00 	. 
	nop			;a2b0	00 	. 
	nop			;a2b1	00 	. 
	ld hl,(0aaaah)		;a2b2	2a aa aa 	* . . 
	xor d			;a2b5	aa 	. 
	nop			;a2b6	00 	. 
	add a,b			;a2b7	80 	. 
	nop			;a2b8	00 	. 
	nop			;a2b9	00 	. 
	add a,b			;a2ba	80 	. 
	nop			;a2bb	00 	. 
	nop			;a2bc	00 	. 
	add a,b			;a2bd	80 	. 
	nop			;a2be	00 	. 
	dec b			;a2bf	05 	. 
	ld d,h			;a2c0	54 	T 
	nop			;a2c1	00 	. 
	ld a,(bc)			;a2c2	0a 	. 
	xor c			;a2c3	a9 	. 
	ld d,l			;a2c4	55 	U 
	ld d,l			;a2c5	55 	U 
	ld d,a			;a2c6	57 	W 
	ret p			;a2c7	f0 	. 
	nop			;a2c8	00 	. 
	add a,l			;a2c9	85 	. 
	ld d,l			;a2ca	55 	U 
	ld d,l			;a2cb	55 	U 
	ld d,a			;a2cc	57 	W 
	call m,l7fffh+1		;a2cd	fc 00 80 	. . . 
	dec d			;a2d0	15 	. 
	ld d,l			;a2d1	55 	U 
	ld d,l			;a2d2	55 	U 
	ld d,h			;a2d3	54 	T 
	nop			;a2d4	00 	. 
	nop			;a2d5	00 	. 
	nop			;a2d6	00 	. 
	ld d,l			;a2d7	55 	U 
	ld d,l			;a2d8	55 	U 
	ld b,b			;a2d9	40 	@ 
	nop			;a2da	00 	. 
	nop			;a2db	00 	. 
	nop			;a2dc	00 	. 
	ld (bc),a			;a2dd	02 	. 
	ld (bc),a			;a2de	02 	. 
	ex af,af'			;a2df	08 	. 
	nop			;a2e0	00 	. 
	nop			;a2e1	00 	. 
	nop			;a2e2	00 	. 
	xor d			;a2e3	aa 	. 
	xor d			;a2e4	aa 	. 
	and b			;a2e5	a0 	. 
	nop			;a2e6	00 	. 
	nop			;a2e7	00 	. 
	nop			;a2e8	00 	. 
	ld a,(bc)			;a2e9	0a 	. 
	xor b			;a2ea	a8 	. 
	nop			;a2eb	00 	. 
	ex af,af'			;a2ec	08 	. 
	ex af,af'			;a2ed	08 	. 
	nop			;a2ee	00 	. 
	nop			;a2ef	00 	. 
	add a,b			;a2f0	80 	. 
	nop			;a2f1	00 	. 
	ld (bc),a			;a2f2	02 	. 
	jr nz,la2f5h		;a2f3	20 00 	  . 
la2f5h:
	dec b			;a2f5	05 	. 
	ld d,h			;a2f6	54 	T 
	nop			;a2f7	00 	. 
	nop			;a2f8	00 	. 
	sub l			;a2f9	95 	. 
	ld d,l			;a2fa	55 	U 
	ld d,l			;a2fb	55 	U 
	ld d,a			;a2fc	57 	W 
	ret p			;a2fd	f0 	. 
	ld (bc),a			;a2fe	02 	. 
	dec h			;a2ff	25 	% 
	ld d,l			;a300	55 	U 
	ld d,l			;a301	55 	U 
	ld d,a			;a302	57 	W 
	call m,00808h		;a303	fc 08 08 	. . . 
	dec d			;a306	15 	. 
	ld d,l			;a307	55 	U 
	ld d,l			;a308	55 	U 
	ld d,h			;a309	54 	T 
	nop			;a30a	00 	. 
	nop			;a30b	00 	. 
	nop			;a30c	00 	. 
	ld d,l			;a30d	55 	U 
	ld d,l			;a30e	55 	U 
	ld b,b			;a30f	40 	@ 
	nop			;a310	00 	. 
	nop			;a311	00 	. 
	nop			;a312	00 	. 
	ld (bc),a			;a313	02 	. 
	ld (bc),a			;a314	02 	. 
	ex af,af'			;a315	08 	. 
	nop			;a316	00 	. 
	nop			;a317	00 	. 
	nop			;a318	00 	. 
	xor d			;a319	aa 	. 
	xor d			;a31a	aa 	. 
	and b			;a31b	a0 	. 
	nop			;a31c	00 	. 
	ld hl,(0aaaah)		;a31d	2a aa aa 	* . . 
	xor d			;a320	aa 	. 
	add a,b			;a321	80 	. 
	nop			;a322	00 	. 
	nop			;a323	00 	. 
	nop			;a324	00 	. 
	and b			;a325	a0 	. 
	nop			;a326	00 	. 
	nop			;a327	00 	. 
	nop			;a328	00 	. 
	nop			;a329	00 	. 
	ld bc,00054h		;a32a	01 54 00 	. T . 
	nop			;a32d	00 	. 
	nop			;a32e	00 	. 
	nop			;a32f	00 	. 
	rla			;a330	17 	. 
	defb 0fdh,040h,000h	;illegal sequence		;a331	fd 40 00 	. @ . 
	nop			;a334	00 	. 
	nop			;a335	00 	. 
	ld e,a			;a336	5f 	_ 
	rst 38h			;a337	ff 	. 
	ld d,b			;a338	50 	P 
	nop			;a339	00 	. 
	nop			;a33a	00 	. 
	nop			;a33b	00 	. 
	ld e,a			;a33c	5f 	_ 
	rst 38h			;a33d	ff 	. 
	ld d,b			;a33e	50 	P 
	nop			;a33f	00 	. 
	nop			;a340	00 	. 
	nop			;a341	00 	. 
	dec d			;a342	15 	. 
	ld d,l			;a343	55 	U 
	ld b,b			;a344	40 	@ 
	nop			;a345	00 	. 
	nop			;a346	00 	. 
	nop			;a347	00 	. 
	jr nz,$+82		;a348	20 50 	  P 
	add a,b			;a34a	80 	. 
	nop			;a34b	00 	. 
	nop			;a34c	00 	. 
	nop			;a34d	00 	. 
	add a,b			;a34e	80 	. 
	nop			;a34f	00 	. 
	jr nz,la352h		;a350	20 00 	  . 
la352h:
	nop			;a352	00 	. 
	nop			;a353	00 	. 
	ld hl,(l80aah)		;a354	2a aa 80 	* . . 
	nop			;a357	00 	. 
	nop			;a358	00 	. 
	nop			;a359	00 	. 
	nop			;a35a	00 	. 
	and b			;a35b	a0 	. 
	nop			;a35c	00 	. 
	nop			;a35d	00 	. 
	nop			;a35e	00 	. 
	nop			;a35f	00 	. 
	ld bc,00054h		;a360	01 54 00 	. T . 
	nop			;a363	00 	. 
	nop			;a364	00 	. 
	nop			;a365	00 	. 
	rla			;a366	17 	. 
	defb 0fdh,040h,000h	;illegal sequence		;a367	fd 40 00 	. @ . 
	nop			;a36a	00 	. 
	nop			;a36b	00 	. 
	ld e,a			;a36c	5f 	_ 
	rst 38h			;a36d	ff 	. 
	ld d,b			;a36e	50 	P 
	nop			;a36f	00 	. 
	nop			;a370	00 	. 
	nop			;a371	00 	. 
	ld e,a			;a372	5f 	_ 
	rst 38h			;a373	ff 	. 
	ld d,b			;a374	50 	P 
	nop			;a375	00 	. 
	nop			;a376	00 	. 
	nop			;a377	00 	. 
	dec d			;a378	15 	. 
	ld d,l			;a379	55 	U 
	ld b,b			;a37a	40 	@ 
	nop			;a37b	00 	. 
	nop			;a37c	00 	. 
	nop			;a37d	00 	. 
	jr nz,la3d0h		;a37e	20 50 	  P 
	add a,b			;a380	80 	. 
	nop			;a381	00 	. 
	nop			;a382	00 	. 
	nop			;a383	00 	. 
	add a,b			;a384	80 	. 
	nop			;a385	00 	. 
	jr nz,la388h		;a386	20 00 	  . 
la388h:
	ld a,(bc)			;a388	0a 	. 
	and b			;a389	a0 	. 
	ld hl,(0aaa8h)		;a38a	2a a8 aa 	* . . 
	xor d			;a38d	aa 	. 
	djnz la394h		;a38e	10 04 	. . 
	djnz la396h		;a390	10 04 	. . 
	dec d			;a392	15 	. 
	ld d,h			;a393	54 	T 
la394h:
	dec d			;a394	15 	. 
	ld d,h			;a395	54 	T 
la396h:
	inc c			;a396	0c 	. 
	jr nc,la3a5h		;a397	30 0c 	0 . 
	jr nc,la3a7h		;a399	30 0c 	0 . 
	jr nc,$+50		;a39b	30 30 	0 0 
	inc c			;a39d	0c 	. 
	jr nc,la3ach		;a39e	30 0c 	0 . 
	jr nc,la3aeh		;a3a0	30 0c 	0 . 
	ret nz			;a3a2	c0 	. 
	inc bc			;a3a3	03 	. 
	ret nz			;a3a4	c0 	. 
la3a5h:
	inc bc			;a3a5	03 	. 
	ret nz			;a3a6	c0 	. 
la3a7h:
	inc bc			;a3a7	03 	. 
la3a8h:
	nop			;a3a8	00 	. 
	ld a,(bc)			;a3a9	0a 	. 
	xor d			;a3aa	aa 	. 
	and b			;a3ab	a0 	. 
la3ach:
	nop			;a3ac	00 	. 
	nop			;a3ad	00 	. 
la3aeh:
	xor d			;a3ae	aa 	. 
	xor d			;a3af	aa 	. 
	xor d			;a3b0	aa 	. 
	nop			;a3b1	00 	. 
	ld a,(bc)			;a3b2	0a 	. 
	xor d			;a3b3	aa 	. 
	xor d			;a3b4	aa 	. 
	xor d			;a3b5	aa 	. 
	and b			;a3b6	a0 	. 
	xor d			;a3b7	aa 	. 
	xor d			;a3b8	aa 	. 
	xor d			;a3b9	aa 	. 
	xor d			;a3ba	aa 	. 
	xor d			;a3bb	aa 	. 
	jr nc,la3beh		;a3bc	30 00 	0 . 
la3beh:
	nop			;a3be	00 	. 
	nop			;a3bf	00 	. 
	inc c			;a3c0	0c 	. 
	ld sp,00554h		;a3c1	31 54 05 	1 T . 
	ld d,l			;a3c4	55 	U 
	ld c,h			;a3c5	4c 	L 
	ld sp,00454h		;a3c6	31 54 04 	1 T . 
	djnz la417h		;a3c9	10 4c 	. L 
	ld sp,00554h		;a3cb	31 54 05 	1 T . 
	ld d,l			;a3ce	55 	U 
	ld c,h			;a3cf	4c 	L 
la3d0h:
	ld sp,00454h		;a3d0	31 54 04 	1 T . 
	djnz la421h		;a3d3	10 4c 	. L 
	ld sp,00554h		;a3d5	31 54 05 	1 T . 
	ld d,l			;a3d8	55 	U 
	ld c,h			;a3d9	4c 	L 
	ld sp,00054h		;a3da	31 54 00 	1 T . 
	nop			;a3dd	00 	. 
	inc c			;a3de	0c 	. 
la3dfh:
	ex af,af'			;a3df	08 	. 
	nop			;a3e0	00 	. 
	dec d			;a3e1	15 	. 
	nop			;a3e2	00 	. 
	ld b,h			;a3e3	44 	D 
	ld b,b			;a3e4	40 	@ 
	ld c,h			;a3e5	4c 	L 
	ld b,b			;a3e6	40 	@ 
	inc sp			;a3e7	33 	3 
	jr nc,la41ah		;a3e8	30 30 	0 0 
	ret nz			;a3ea	c0 	. 
	jr nc,la3edh		;a3eb	30 00 	0 . 
la3edh:
	nop			;a3ed	00 	. 
	add a,b			;a3ee	80 	. 
	ld de,00450h		;a3ef	11 50 04 	. P . 
	ld b,h			;a3f2	44 	D 
	nop			;a3f3	00 	. 
	pop bc			;a3f4	c1 	. 
	inc bc			;a3f5	03 	. 
	jr nc,la404h		;a3f6	30 0c 	0 . 
	inc c			;a3f8	0c 	. 
	jr nc,la3feh		;a3f9	30 03 	0 . 
	ld (bc),a			;a3fb	02 	. 
	nop			;a3fc	00 	. 
	dec b			;a3fd	05 	. 
la3feh:
	ld b,h			;a3fe	44 	D 
	ld de,04310h		;a3ff	11 10 43 	. . C 
	nop			;a402	00 	. 
	inc c			;a403	0c 	. 
la404h:
	ret nz			;a404	c0 	. 
	jr nc,la437h		;a405	30 30 	0 0 
	ret nz			;a407	c0 	. 
	inc c			;a408	0c 	. 
	nop			;a409	00 	. 
	jr nz,la40ch		;a40a	20 00 	  . 
la40ch:
	ld d,h			;a40c	54 	T 
	ld bc,00111h		;a40d	01 11 01 	. . . 
	ld sp,0cc0ch		;a410	31 0c cc 	1 . . 
	inc bc			;a413	03 	. 
	inc c			;a414	0c 	. 
	nop			;a415	00 	. 
	inc c			;a416	0c 	. 
la417h:
	nop			;a417	00 	. 
	nop			;a418	00 	. 
	nop			;a419	00 	. 
la41ah:
	nop			;a41a	00 	. 
	nop			;a41b	00 	. 
	nop			;a41c	00 	. 
	ld d,l			;a41d	55 	U 
	ld d,l			;a41e	55 	U 
	nop			;a41f	00 	. 
	nop			;a420	00 	. 
la421h:
	nop			;a421	00 	. 
	nop			;a422	00 	. 
	nop			;a423	00 	. 
	dec b			;a424	05 	. 
	ld d,l			;a425	55 	U 
	ld d,l			;a426	55 	U 
	nop			;a427	00 	. 
	rst 38h			;a428	ff 	. 
	rst 38h			;a429	ff 	. 
	rst 38h			;a42a	ff 	. 
	rst 38h			;a42b	ff 	. 
	ld d,l			;a42c	55 	U 
	ld d,l			;a42d	55 	U 
	ld d,l			;a42e	55 	U 
	rrca			;a42f	0f 	. 
	rst 38h			;a430	ff 	. 
	rst 38h			;a431	ff 	. 
	rst 38h			;a432	ff 	. 
	push af			;a433	f5 	. 
	ld d,l			;a434	55 	U 
	ld d,l			;a435	55 	U 
	ld d,l			;a436	55 	U 
la437h:
	rst 38h			;a437	ff 	. 
	rst 38h			;a438	ff 	. 
	rst 38h			;a439	ff 	. 
	rst 38h			;a43a	ff 	. 
	ld d,l			;a43b	55 	U 
	ld d,l			;a43c	55 	U 
	ld d,l			;a43d	55 	U 
	ld d,l			;a43e	55 	U 
	jr nz,la441h		;a43f	20 00 	  . 
la441h:
	nop			;a441	00 	. 
	nop			;a442	00 	. 
	ld hl,(la882h)		;a443	2a 82 a8 	* . . 
	nop			;a446	00 	. 
	jr nz,la449h		;a447	20 00 	  . 
la449h:
	nop			;a449	00 	. 
	nop			;a44a	00 	. 
	ld a,(bc)			;a44b	0a 	. 
	nop			;a44c	00 	. 
	and b			;a44d	a0 	. 
	nop			;a44e	00 	. 
	ld hl,05554h		;a44f	21 54 55 	! T U 
	dec d			;a452	15 	. 
	ld c,d			;a453	4a 	J 
	nop			;a454	00 	. 
	and b			;a455	a0 	. 
	ld d,l			;a456	55 	U 
	ld hl,04104h		;a457	21 04 41 	! . A 
	djnz la4a6h		;a45a	10 4a 	. J 
	nop			;a45c	00 	. 
	and b			;a45d	a0 	. 
	ld b,c			;a45e	41 	A 
	ld hl,04104h		;a45f	21 04 41 	! . A 
	djnz la4aeh		;a462	10 4a 	. J 
	nop			;a464	00 	. 
	and b			;a465	a0 	. 
	ld b,c			;a466	41 	A 
	ld hl,05554h		;a467	21 54 55 	! T U 
	dec d			;a46a	15 	. 
	ld c,d			;a46b	4a 	J 
	nop			;a46c	00 	. 
	and b			;a46d	a0 	. 
	ld b,c			;a46e	41 	A 
	jr nz,la471h		;a46f	20 00 	  . 
la471h:
	nop			;a471	00 	. 
	nop			;a472	00 	. 
	ld a,(bc)			;a473	0a 	. 
	nop			;a474	00 	. 
	and b			;a475	a0 	. 
	ld b,c			;a476	41 	A 
	jr nz,la479h		;a477	20 00 	  . 
la479h:
	nop			;a479	00 	. 
	nop			;a47a	00 	. 
	ld a,(bc)			;a47b	0a 	. 
	nop			;a47c	00 	. 
	and b			;a47d	a0 	. 
	ld b,c			;a47e	41 	A 
	jr nz,la481h		;a47f	20 00 	  . 
la481h:
	nop			;a481	00 	. 
	nop			;a482	00 	. 
	ld hl,(la882h)		;a483	2a 82 a8 	* . . 
	ld d,l			;a486	55 	U 
la487h:
	ld d,l			;a487	55 	U 
	ld d,l			;a488	55 	U 
	nop			;a489	00 	. 
	nop			;a48a	00 	. 
	nop			;a48b	00 	. 
	nop			;a48c	00 	. 
	nop			;a48d	00 	. 
	nop			;a48e	00 	. 
	ld d,l			;a48f	55 	U 
	ld d,l			;a490	55 	U 
	ld d,b			;a491	50 	P 
	nop			;a492	00 	. 
	nop			;a493	00 	. 
	nop			;a494	00 	. 
	nop			;a495	00 	. 
	nop			;a496	00 	. 
	ld d,l			;a497	55 	U 
	ld d,l			;a498	55 	U 
	ld d,l			;a499	55 	U 
	rst 38h			;a49a	ff 	. 
	rst 38h			;a49b	ff 	. 
	rst 38h			;a49c	ff 	. 
	rst 38h			;a49d	ff 	. 
	nop			;a49e	00 	. 
	ld d,l			;a49f	55 	U 
	ld d,l			;a4a0	55 	U 
	ld d,l			;a4a1	55 	U 
	ld e,a			;a4a2	5f 	_ 
	rst 38h			;a4a3	ff 	. 
	rst 38h			;a4a4	ff 	. 
	rst 38h			;a4a5	ff 	. 
la4a6h:
	ret p			;a4a6	f0 	. 
	ld d,l			;a4a7	55 	U 
	ld d,l			;a4a8	55 	U 
	ld d,l			;a4a9	55 	U 
	ld d,l			;a4aa	55 	U 
	rst 38h			;a4ab	ff 	. 
	rst 38h			;a4ac	ff 	. 
	rst 38h			;a4ad	ff 	. 
la4aeh:
	rst 38h			;a4ae	ff 	. 
	nop			;a4af	00 	. 
	ld hl,(la882h)		;a4b0	2a 82 a8 	* . . 
	nop			;a4b3	00 	. 
	nop			;a4b4	00 	. 
	nop			;a4b5	00 	. 
	ex af,af'			;a4b6	08 	. 
	nop			;a4b7	00 	. 
	ld a,(bc)			;a4b8	0a 	. 
	nop			;a4b9	00 	. 
	and b			;a4ba	a0 	. 
	nop			;a4bb	00 	. 
	nop			;a4bc	00 	. 
	nop			;a4bd	00 	. 
	ex af,af'			;a4be	08 	. 
	ld d,l			;a4bf	55 	U 
	ld a,(bc)			;a4c0	0a 	. 
	nop			;a4c1	00 	. 
	and c			;a4c2	a1 	. 
	ld d,h			;a4c3	54 	T 
	ld d,l			;a4c4	55 	U 
	dec d			;a4c5	15 	. 
	ld c,b			;a4c6	48 	H 
	ld b,c			;a4c7	41 	A 
	ld a,(bc)			;a4c8	0a 	. 
	nop			;a4c9	00 	. 
	and c			;a4ca	a1 	. 
	inc b			;a4cb	04 	. 
	ld b,c			;a4cc	41 	A 
	djnz la517h		;a4cd	10 48 	. H 
	ld b,c			;a4cf	41 	A 
	ld a,(bc)			;a4d0	0a 	. 
	nop			;a4d1	00 	. 
	and c			;a4d2	a1 	. 
	inc b			;a4d3	04 	. 
	ld b,c			;a4d4	41 	A 
	djnz la51fh		;a4d5	10 48 	. H 
	ld b,c			;a4d7	41 	A 
	ld a,(bc)			;a4d8	0a 	. 
	nop			;a4d9	00 	. 
	and c			;a4da	a1 	. 
	ld d,h			;a4db	54 	T 
	ld d,l			;a4dc	55 	U 
	dec d			;a4dd	15 	. 
	ld c,b			;a4de	48 	H 
	ld b,c			;a4df	41 	A 
	ld a,(bc)			;a4e0	0a 	. 
	nop			;a4e1	00 	. 
	and b			;a4e2	a0 	. 
	nop			;a4e3	00 	. 
	nop			;a4e4	00 	. 
	nop			;a4e5	00 	. 
	ex af,af'			;a4e6	08 	. 
	ld b,c			;a4e7	41 	A 
	ld a,(bc)			;a4e8	0a 	. 
	nop			;a4e9	00 	. 
	and b			;a4ea	a0 	. 
	nop			;a4eb	00 	. 
	nop			;a4ec	00 	. 
	nop			;a4ed	00 	. 
	ex af,af'			;a4ee	08 	. 
	ld d,l			;a4ef	55 	U 
	ld hl,(la882h)		;a4f0	2a 82 a8 	* . . 
	nop			;a4f3	00 	. 
	nop			;a4f4	00 	. 
	nop			;a4f5	00 	. 
	ex af,af'			;a4f6	08 	. 
la4f7h:
	nop			;a4f7	00 	. 
	djnz la4fah		;a4f8	10 00 	. . 
la4fah:
	nop			;a4fa	00 	. 
	ld b,h			;a4fb	44 	D 
	nop			;a4fc	00 	. 
	nop			;a4fd	00 	. 
	ld b,h			;a4fe	44 	D 
	nop			;a4ff	00 	. 
	nop			;a500	00 	. 
	ld b,h			;a501	44 	D 
	nop			;a502	00 	. 
	ld bc,00045h		;a503	01 45 00 	. E . 
	ld bc,00011h		;a506	01 11 00 	. . . 
	ld bc,00045h		;a509	01 45 00 	. E . 
	inc b			;a50c	04 	. 
	djnz la54fh		;a50d	10 40 	. @ 
	inc b			;a50f	04 	. 
	ld b,h			;a510	44 	D 
	ld b,b			;a511	40 	@ 
	dec b			;a512	05 	. 
	ld bc,01040h		;a513	01 40 10 	. @ . 
	ld b,h			;a516	44 	D 
la517h:
	djnz la529h		;a517	10 10 	. . 
	djnz la52bh		;a519	10 10 	. . 
	djnz la561h		;a51b	10 44 	. D 
	djnz la560h		;a51d	10 41 	. A 
la51fh:
	ld bc,04404h		;a51f	01 04 44 	. . D 
	nop			;a522	00 	. 
	ld b,h			;a523	44 	D 
	ld d,b			;a524	50 	P 
	nop			;a525	00 	. 
	inc d			;a526	14 	. 
la527h:
	nop			;a527	00 	. 
	nop			;a528	00 	. 
la529h:
	nop			;a529	00 	. 
	nop			;a52a	00 	. 
la52bh:
	nop			;a52b	00 	. 
	nop			;a52c	00 	. 
	nop			;a52d	00 	. 
	nop			;a52e	00 	. 
	nop			;a52f	00 	. 
	nop			;a530	00 	. 
	nop			;a531	00 	. 
	nop			;a532	00 	. 
	nop			;a533	00 	. 
	nop			;a534	00 	. 
	nop			;a535	00 	. 
	nop			;a536	00 	. 
	nop			;a537	00 	. 
	nop			;a538	00 	. 
	nop			;a539	00 	. 
	nop			;a53a	00 	. 
	nop			;a53b	00 	. 
	nop			;a53c	00 	. 
	nop			;a53d	00 	. 
	nop			;a53e	00 	. 
	nop			;a53f	00 	. 
	nop			;a540	00 	. 
	nop			;a541	00 	. 
	nop			;a542	00 	. 
	nop			;a543	00 	. 
	nop			;a544	00 	. 
	nop			;a545	00 	. 
	nop			;a546	00 	. 
	nop			;a547	00 	. 
	nop			;a548	00 	. 
	nop			;a549	00 	. 
	nop			;a54a	00 	. 
	nop			;a54b	00 	. 
	nop			;a54c	00 	. 
	nop			;a54d	00 	. 
	nop			;a54e	00 	. 
la54fh:
	nop			;a54f	00 	. 
	nop			;a550	00 	. 
	nop			;a551	00 	. 
	nop			;a552	00 	. 
	nop			;a553	00 	. 
	nop			;a554	00 	. 
	nop			;a555	00 	. 
	nop			;a556	00 	. 
	nop			;a557	00 	. 
	nop			;a558	00 	. 
	nop			;a559	00 	. 
	nop			;a55a	00 	. 
	nop			;a55b	00 	. 
	nop			;a55c	00 	. 
	nop			;a55d	00 	. 
	nop			;a55e	00 	. 
	nop			;a55f	00 	. 
la560h:
	nop			;a560	00 	. 
la561h:
	nop			;a561	00 	. 
	nop			;a562	00 	. 
	nop			;a563	00 	. 
	nop			;a564	00 	. 
	nop			;a565	00 	. 
	nop			;a566	00 	. 
	nop			;a567	00 	. 
	nop			;a568	00 	. 
	nop			;a569	00 	. 
	nop			;a56a	00 	. 
	nop			;a56b	00 	. 
	nop			;a56c	00 	. 
	nop			;a56d	00 	. 
	nop			;a56e	00 	. 
	nop			;a56f	00 	. 
	nop			;a570	00 	. 
	nop			;a571	00 	. 
	nop			;a572	00 	. 
	nop			;a573	00 	. 
	nop			;a574	00 	. 
	nop			;a575	00 	. 
	nop			;a576	00 	. 
	nop			;a577	00 	. 
	nop			;a578	00 	. 
	nop			;a579	00 	. 
	nop			;a57a	00 	. 
	nop			;a57b	00 	. 
	nop			;a57c	00 	. 
	nop			;a57d	00 	. 
	nop			;a57e	00 	. 
	nop			;a57f	00 	. 
	nop			;a580	00 	. 
	nop			;a581	00 	. 
	nop			;a582	00 	. 
	nop			;a583	00 	. 
	nop			;a584	00 	. 
	nop			;a585	00 	. 
	nop			;a586	00 	. 
	nop			;a587	00 	. 
	nop			;a588	00 	. 
	nop			;a589	00 	. 
	nop			;a58a	00 	. 
	nop			;a58b	00 	. 
	nop			;a58c	00 	. 
	nop			;a58d	00 	. 
	nop			;a58e	00 	. 
	nop			;a58f	00 	. 
	nop			;a590	00 	. 
	nop			;a591	00 	. 
	nop			;a592	00 	. 
	nop			;a593	00 	. 
	nop			;a594	00 	. 
	nop			;a595	00 	. 
	nop			;a596	00 	. 
la597h:
	call m,0ff00h		;a597	fc 00 ff 	. . . 
	ret p			;a59a	f0 	. 
	nop			;a59b	00 	. 
	nop			;a59c	00 	. 
	rst 8			;a59d	cf 	. 
	rst 38h			;a59e	ff 	. 
	rst 38h			;a59f	ff 	. 
	rst 38h			;a5a0	ff 	. 
	ret nz			;a5a1	c0 	. 
	nop			;a5a2	00 	. 
	call m,0ff00h		;a5a3	fc 00 ff 	. . . 
	rst 38h			;a5a6	ff 	. 
	ret nz			;a5a7	c0 	. 
	nop			;a5a8	00 	. 
	nop			;a5a9	00 	. 
	nop			;a5aa	00 	. 
	inc bc			;a5ab	03 	. 
	ret p			;a5ac	f0 	. 
	nop			;a5ad	00 	. 
	nop			;a5ae	00 	. 
	nop			;a5af	00 	. 
	ld a,(bc)			;a5b0	0a 	. 
	xor d			;a5b1	aa 	. 
	xor d			;a5b2	aa 	. 
	xor d			;a5b3	aa 	. 
	nop			;a5b4	00 	. 
	nop			;a5b5	00 	. 
	ld hl,(0aaaah)		;a5b6	2a aa aa 	* . . 
	xor d			;a5b9	aa 	. 
	nop			;a5ba	00 	. 
	nop			;a5bb	00 	. 
	add a,c			;a5bc	81 	. 
	ld d,l			;a5bd	55 	U 
	ld d,l			;a5be	55 	U 
	ld d,b			;a5bf	50 	P 
	add a,b			;a5c0	80 	. 
	ld (bc),a			;a5c1	02 	. 
	rlca			;a5c2	07 	. 
	inc sp			;a5c3	33 	3 
	inc sp			;a5c4	33 	3 
	inc (hl)			;a5c5	34 	4 
	jr nz,la5c8h		;a5c6	20 00 	  . 
la5c8h:
	ld bc,05555h		;a5c8	01 55 55 	. U U 
	ld d,b			;a5cb	50 	P 
	nop			;a5cc	00 	. 
	rrca			;a5cd	0f 	. 
	ret nz			;a5ce	c0 	. 
	rrca			;a5cf	0f 	. 
	rst 38h			;a5d0	ff 	. 
	nop			;a5d1	00 	. 
	nop			;a5d2	00 	. 
	inc c			;a5d3	0c 	. 
	rst 38h			;a5d4	ff 	. 
	rst 38h			;a5d5	ff 	. 
	rst 38h			;a5d6	ff 	. 
	call m,00f00h		;a5d7	fc 00 0f 	. . . 
	ret nz			;a5da	c0 	. 
	rrca			;a5db	0f 	. 
	rst 38h			;a5dc	ff 	. 
	call m,00000h		;a5dd	fc 00 00 	. . . 
	nop			;a5e0	00 	. 
	nop			;a5e1	00 	. 
	ccf			;a5e2	3f 	? 
	nop			;a5e3	00 	. 
	nop			;a5e4	00 	. 
	nop			;a5e5	00 	. 
	nop			;a5e6	00 	. 
	xor d			;a5e7	aa 	. 
	xor d			;a5e8	aa 	. 
	xor d			;a5e9	aa 	. 
	and b			;a5ea	a0 	. 
	nop			;a5eb	00 	. 
	ld (bc),a			;a5ec	02 	. 
	xor d			;a5ed	aa 	. 
	xor d			;a5ee	aa 	. 
	xor d			;a5ef	aa 	. 
	and b			;a5f0	a0 	. 
	nop			;a5f1	00 	. 
	ex af,af'			;a5f2	08 	. 
	dec d			;a5f3	15 	. 
	ld d,l			;a5f4	55 	U 
	ld d,l			;a5f5	55 	U 
	ex af,af'			;a5f6	08 	. 
	nop			;a5f7	00 	. 
	jr nz,la66dh		;a5f8	20 73 	  s 
	inc sp			;a5fa	33 	3 
	inc sp			;a5fb	33 	3 
	ld b,d			;a5fc	42 	B 
	nop			;a5fd	00 	. 
	nop			;a5fe	00 	. 
	dec d			;a5ff	15 	. 
	ld d,l			;a600	55 	U 
	ld d,l			;a601	55 	U 
	nop			;a602	00 	. 
	nop			;a603	00 	. 
	nop			;a604	00 	. 
	rst 38h			;a605	ff 	. 
	ret p			;a606	f0 	. 
	inc bc			;a607	03 	. 
	ret p			;a608	f0 	. 
	nop			;a609	00 	. 
	ccf			;a60a	3f 	? 
	rst 38h			;a60b	ff 	. 
	rst 38h			;a60c	ff 	. 
	rst 38h			;a60d	ff 	. 
	jr nc,la610h		;a60e	30 00 	0 . 
la610h:
	ccf			;a610	3f 	? 
	rst 38h			;a611	ff 	. 
	ret p			;a612	f0 	. 
	inc bc			;a613	03 	. 
	ret p			;a614	f0 	. 
	nop			;a615	00 	. 
	nop			;a616	00 	. 
	call m,00000h		;a617	fc 00 00 	. . . 
	nop			;a61a	00 	. 
	ld a,(bc)			;a61b	0a 	. 
	xor d			;a61c	aa 	. 
	xor d			;a61d	aa 	. 
	xor d			;a61e	aa 	. 
	nop			;a61f	00 	. 
	nop			;a620	00 	. 
	ld a,(bc)			;a621	0a 	. 
	xor d			;a622	aa 	. 
	xor d			;a623	aa 	. 
	xor d			;a624	aa 	. 
	add a,b			;a625	80 	. 
	nop			;a626	00 	. 
la627h:
	jr nz,la67eh		;a627	20 55 	  U 
	ld d,l			;a629	55 	U 
	ld d,h			;a62a	54 	T 
	jr nz,la62dh		;a62b	20 00 	  . 
la62dh:
	add a,c			;a62d	81 	. 
	call z,0cdcch		;a62e	cc cc cd 	. . . 
	ex af,af'			;a631	08 	. 
	nop			;a632	00 	. 
	nop			;a633	00 	. 
	ld d,l			;a634	55 	U 
	ld d,l			;a635	55 	U 
	ld d,h			;a636	54 	T 
	nop			;a637	00 	. 
	nop			;a638	00 	. 
	nop			;a639	00 	. 
	nop			;a63a	00 	. 
	rrca			;a63b	0f 	. 
	rst 38h			;a63c	ff 	. 
	nop			;a63d	00 	. 
	ccf			;a63e	3f 	? 
	nop			;a63f	00 	. 
	inc bc			;a640	03 	. 
	rst 38h			;a641	ff 	. 
	rst 38h			;a642	ff 	. 
	rst 38h			;a643	ff 	. 
	di			;a644	f3 	. 
	nop			;a645	00 	. 
	inc bc			;a646	03 	. 
	rst 38h			;a647	ff 	. 
	rst 38h			;a648	ff 	. 
	nop			;a649	00 	. 
	ccf			;a64a	3f 	? 
	nop			;a64b	00 	. 
	nop			;a64c	00 	. 
	rrca			;a64d	0f 	. 
	ret nz			;a64e	c0 	. 
	nop			;a64f	00 	. 
	nop			;a650	00 	. 
	nop			;a651	00 	. 
	xor d			;a652	aa 	. 
	xor d			;a653	aa 	. 
	xor d			;a654	aa 	. 
	and b			;a655	a0 	. 
	nop			;a656	00 	. 
	nop			;a657	00 	. 
	xor d			;a658	aa 	. 
	xor d			;a659	aa 	. 
	xor d			;a65a	aa 	. 
	xor b			;a65b	a8 	. 
	nop			;a65c	00 	. 
	ld (bc),a			;a65d	02 	. 
	dec b			;a65e	05 	. 
	ld d,l			;a65f	55 	U 
	ld d,l			;a660	55 	U 
	ld b,d			;a661	42 	B 
	nop			;a662	00 	. 
	ex af,af'			;a663	08 	. 
	inc e			;a664	1c 	. 
	call z,0d0cch		;a665	cc cc d0 	. . . 
	add a,b			;a668	80 	. 
	nop			;a669	00 	. 
	dec b			;a66a	05 	. 
	ld d,l			;a66b	55 	U 
	ld d,l			;a66c	55 	U 
la66dh:
	ld b,b			;a66d	40 	@ 
	nop			;a66e	00 	. 
la66fh:
	dec b			;a66f	05 	. 
	nop			;a670	00 	. 
	dec b			;a671	05 	. 
	nop			;a672	00 	. 
	dec (hl)			;a673	35 	5 
	ret nz			;a674	c0 	. 
	push af			;a675	f5 	. 
	ret p			;a676	f0 	. 
	dec b			;a677	05 	. 
	nop			;a678	00 	. 
	dec b			;a679	05 	. 
	nop			;a67a	00 	. 
	dec h			;a67b	25 	% 
	add a,b			;a67c	80 	. 
	and b			;a67d	a0 	. 
la67eh:
	and b			;a67e	a0 	. 
	add a,b			;a67f	80 	. 
	jr nz,la682h		;a680	20 00 	  . 
la682h:
	ld d,b			;a682	50 	P 
	nop			;a683	00 	. 
	ld d,b			;a684	50 	P 
	inc bc			;a685	03 	. 
	ld e,h			;a686	5c 	\ 
	rrca			;a687	0f 	. 
	ld e,a			;a688	5f 	_ 
	nop			;a689	00 	. 
	ld d,b			;a68a	50 	P 
	nop			;a68b	00 	. 
	ld d,b			;a68c	50 	P 
	ld (bc),a			;a68d	02 	. 
	ld e,b			;a68e	58 	X 
	ld a,(bc)			;a68f	0a 	. 
	ld a,(bc)			;a690	0a 	. 
	ex af,af'			;a691	08 	. 
	ld (bc),a			;a692	02 	. 
la693h:
	dec d			;a693	15 	. 
	ld d,b			;a694	50 	P 
	jr la627h		;a695	18 90 	. . 
	ld (de),a			;a697	12 	. 
	djnz la6b2h		;a698	10 18 	. . 
	sub l			;a69a	95 	. 
	ld (de),a			;a69b	12 	. 
	djnz la6b6h		;a69c	10 18 	. . 
	sub b			;a69e	90 	. 
	ld (de),a			;a69f	12 	. 
	djnz la6e1h		;a6a0	10 3f 	. ? 
	ret p			;a6a2	f0 	. 
	rst 38h			;a6a3	ff 	. 
	call m,00000h		;a6a4	fc 00 00 	. . . 
	nop			;a6a7	00 	. 
	nop			;a6a8	00 	. 
	ld bc,0c050h		;a6a9	01 50 c0 	. P . 
	rrca			;a6ac	0f 	. 
	rst 38h			;a6ad	ff 	. 
	nop			;a6ae	00 	. 
	dec b			;a6af	05 	. 
	ld d,b			;a6b0	50 	P 
	push bc			;a6b1	c5 	. 
la6b2h:
	ld d,a			;a6b2	57 	W 
	defb 0fdh,055h,055h	;illegal sequence		;a6b3	fd 55 55 	. U U 
la6b6h:
	ld d,b			;a6b6	50 	P 
	push de			;a6b7	d5 	. 
	ld d,l			;a6b8	55 	U 
	ld d,l			;a6b9	55 	U 
	ld d,l			;a6ba	55 	U 
	ld l,d			;a6bb	6a 	j 
	sub b			;a6bc	90 	. 
	sub 0aah		;a6bd	d6 aa 	. . 
	xor d			;a6bf	aa 	. 
	and l			;a6c0	a5 	. 
	ld d,l			;a6c1	55 	U 
	ld d,b			;a6c2	50 	P 
	push bc			;a6c3	c5 	. 
	ld d,l			;a6c4	55 	U 
	ld d,l			;a6c5	55 	U 
	ld d,l			;a6c6	55 	U 
	nop			;a6c7	00 	. 
	nop			;a6c8	00 	. 
	ret nz			;a6c9	c0 	. 
	inc c			;a6ca	0c 	. 
	nop			;a6cb	00 	. 
	inc c			;a6cc	0c 	. 
	djnz la6cfh		;a6cd	10 00 	. . 
la6cfh:
	nop			;a6cf	00 	. 
	xor d			;a6d0	aa 	. 
	xor d			;a6d1	aa 	. 
	xor d			;a6d2	aa 	. 
	ld d,b			;a6d3	50 	P 
	nop			;a6d4	00 	. 
	nop			;a6d5	00 	. 
	nop			;a6d6	00 	. 
	nop			;a6d7	00 	. 
	nop			;a6d8	00 	. 
	djnz la6dbh		;a6d9	10 00 	. . 
la6dbh:
	nop			;a6db	00 	. 
	nop			;a6dc	00 	. 
	nop			;a6dd	00 	. 
	nop			;a6de	00 	. 
	nop			;a6df	00 	. 
	dec d			;a6e0	15 	. 
la6e1h:
	inc c			;a6e1	0c 	. 
	nop			;a6e2	00 	. 
	rst 38h			;a6e3	ff 	. 
	ret p			;a6e4	f0 	. 
	nop			;a6e5	00 	. 
	ld d,l			;a6e6	55 	U 
	inc c			;a6e7	0c 	. 
	ld d,l			;a6e8	55 	U 
	ld a,a			;a6e9	7f 	 
	push de			;a6ea	d5 	. 
	ld d,l			;a6eb	55 	U 
	ld d,l			;a6ec	55 	U 
	dec c			;a6ed	0d 	. 
	ld d,l			;a6ee	55 	U 
	ld d,l			;a6ef	55 	U 
	ld d,l			;a6f0	55 	U 
	ld d,(hl)			;a6f1	56 	V 
	xor c			;a6f2	a9 	. 
	dec c			;a6f3	0d 	. 
	ld l,d			;a6f4	6a 	j 
	xor d			;a6f5	aa 	. 
	xor d			;a6f6	aa 	. 
	ld d,l			;a6f7	55 	U 
	ld d,l			;a6f8	55 	U 
	inc c			;a6f9	0c 	. 
	ld d,l			;a6fa	55 	U 
	ld d,l			;a6fb	55 	U 
	ld d,l			;a6fc	55 	U 
	ld d,b			;a6fd	50 	P 
	nop			;a6fe	00 	. 
	inc c			;a6ff	0c 	. 
	nop			;a700	00 	. 
	ret nz			;a701	c0 	. 
	nop			;a702	00 	. 
	pop bc			;a703	c1 	. 
	nop			;a704	00 	. 
	nop			;a705	00 	. 
	ld a,(bc)			;a706	0a 	. 
	xor d			;a707	aa 	. 
	xor d			;a708	aa 	. 
	and l			;a709	a5 	. 
	nop			;a70a	00 	. 
	nop			;a70b	00 	. 
	nop			;a70c	00 	. 
	nop			;a70d	00 	. 
	nop			;a70e	00 	. 
	ld bc,00000h		;a70f	01 00 00 	. . . 
	nop			;a712	00 	. 
	nop			;a713	00 	. 
	nop			;a714	00 	. 
	ld bc,00050h		;a715	01 50 00 	. P . 
	rrca			;a718	0f 	. 
	rst 38h			;a719	ff 	. 
	nop			;a71a	00 	. 
	dec b			;a71b	05 	. 
	ld d,b			;a71c	50 	P 
	dec b			;a71d	05 	. 
	ld d,a			;a71e	57 	W 
	defb 0fdh,055h,055h	;illegal sequence		;a71f	fd 55 55 	. U U 
	ld d,b			;a722	50 	P 
	push de			;a723	d5 	. 
	ld d,l			;a724	55 	U 
	ld d,l			;a725	55 	U 
	ld d,l			;a726	55 	U 
	ld l,d			;a727	6a 	j 
	sub b			;a728	90 	. 
	sub 0aah		;a729	d6 aa 	. . 
	xor d			;a72b	aa 	. 
	and l			;a72c	a5 	. 
	ld d,l			;a72d	55 	U 
	ld d,b			;a72e	50 	P 
	dec b			;a72f	05 	. 
	ld d,l			;a730	55 	U 
	ld d,l			;a731	55 	U 
	ld d,l			;a732	55 	U 
	nop			;a733	00 	. 
	nop			;a734	00 	. 
	nop			;a735	00 	. 
	inc c			;a736	0c 	. 
	nop			;a737	00 	. 
	inc c			;a738	0c 	. 
	djnz la73bh		;a739	10 00 	. . 
la73bh:
	nop			;a73b	00 	. 
	xor d			;a73c	aa 	. 
	xor d			;a73d	aa 	. 
	xor d			;a73e	aa 	. 
	ld d,b			;a73f	50 	P 
	nop			;a740	00 	. 
	nop			;a741	00 	. 
	nop			;a742	00 	. 
	nop			;a743	00 	. 
	nop			;a744	00 	. 
	djnz la747h		;a745	10 00 	. . 
la747h:
	nop			;a747	00 	. 
	nop			;a748	00 	. 
	nop			;a749	00 	. 
	nop			;a74a	00 	. 
	nop			;a74b	00 	. 
	dec d			;a74c	15 	. 
	nop			;a74d	00 	. 
	nop			;a74e	00 	. 
	rst 38h			;a74f	ff 	. 
	ret p			;a750	f0 	. 
	nop			;a751	00 	. 
	ld d,l			;a752	55 	U 
	nop			;a753	00 	. 
	ld d,l			;a754	55 	U 
	ld a,a			;a755	7f 	 
	push de			;a756	d5 	. 
	ld d,l			;a757	55 	U 
	ld d,l			;a758	55 	U 
	dec c			;a759	0d 	. 
	ld d,l			;a75a	55 	U 
	ld d,l			;a75b	55 	U 
	ld d,l			;a75c	55 	U 
	ld d,(hl)			;a75d	56 	V 
	xor c			;a75e	a9 	. 
	dec c			;a75f	0d 	. 
	ld l,d			;a760	6a 	j 
	xor d			;a761	aa 	. 
	xor d			;a762	aa 	. 
	ld d,l			;a763	55 	U 
	ld d,l			;a764	55 	U 
	nop			;a765	00 	. 
	ld d,l			;a766	55 	U 
	ld d,l			;a767	55 	U 
	ld d,l			;a768	55 	U 
	ld d,b			;a769	50 	P 
	nop			;a76a	00 	. 
	nop			;a76b	00 	. 
	nop			;a76c	00 	. 
	ret nz			;a76d	c0 	. 
	nop			;a76e	00 	. 
	pop bc			;a76f	c1 	. 
	nop			;a770	00 	. 
	nop			;a771	00 	. 
	ld a,(bc)			;a772	0a 	. 
	xor d			;a773	aa 	. 
	xor d			;a774	aa 	. 
	and l			;a775	a5 	. 
	nop			;a776	00 	. 
	nop			;a777	00 	. 
	nop			;a778	00 	. 
	nop			;a779	00 	. 
	nop			;a77a	00 	. 
	ld bc,05400h		;a77b	01 00 54 	. . T 
	nop			;a77e	00 	. 
	nop			;a77f	00 	. 
	nop			;a780	00 	. 
	nop			;a781	00 	. 
	nop			;a782	00 	. 
	ld d,l			;a783	55 	U 
	nop			;a784	00 	. 
	rrca			;a785	0f 	. 
	rst 38h			;a786	ff 	. 
	nop			;a787	00 	. 
	jr nc,la7dfh		;a788	30 55 	0 U 
	ld d,l			;a78a	55 	U 
	ld d,a			;a78b	57 	W 
	defb 0fdh,055h,030h	;illegal sequence		;a78c	fd 55 30 	. U 0 
	ld l,d			;a78f	6a 	j 
	sub l			;a790	95 	. 
	ld d,l			;a791	55 	U 
	ld d,l			;a792	55 	U 
	ld d,l			;a793	55 	U 
	ld (hl),b			;a794	70 	p 
	ld d,l			;a795	55 	U 
	ld d,l			;a796	55 	U 
	xor d			;a797	aa 	. 
	xor d			;a798	aa 	. 
	xor c			;a799	a9 	. 
	ld (hl),b			;a79a	70 	p 
	nop			;a79b	00 	. 
	dec b			;a79c	05 	. 
	ld d,l			;a79d	55 	U 
	ld d,l			;a79e	55 	U 
	ld d,l			;a79f	55 	U 
	jr nc,la7a2h		;a7a0	30 00 	0 . 
la7a2h:
	ld b,e			;a7a2	43 	C 
	nop			;a7a3	00 	. 
	inc bc			;a7a4	03 	. 
	nop			;a7a5	00 	. 
	jr nc,la7a8h		;a7a6	30 00 	0 . 
la7a8h:
	ld e,d			;a7a8	5a 	Z 
	xor d			;a7a9	aa 	. 
	xor d			;a7aa	aa 	. 
	and b			;a7ab	a0 	. 
	nop			;a7ac	00 	. 
	nop			;a7ad	00 	. 
	ld b,b			;a7ae	40 	@ 
	nop			;a7af	00 	. 
	nop			;a7b0	00 	. 
	nop			;a7b1	00 	. 
	nop			;a7b2	00 	. 
	dec b			;a7b3	05 	. 
	ld b,b			;a7b4	40 	@ 
	nop			;a7b5	00 	. 
	nop			;a7b6	00 	. 
	nop			;a7b7	00 	. 
	nop			;a7b8	00 	. 
	dec b			;a7b9	05 	. 
	ld d,b			;a7ba	50 	P 
	nop			;a7bb	00 	. 
	rst 38h			;a7bc	ff 	. 
	ret p			;a7bd	f0 	. 
	inc bc			;a7be	03 	. 
	dec b			;a7bf	05 	. 
	ld d,l			;a7c0	55 	U 
	ld d,l			;a7c1	55 	U 
	ld a,a			;a7c2	7f 	 
	push de			;a7c3	d5 	. 
	ld d,e			;a7c4	53 	S 
	ld b,0a9h		;a7c5	06 a9 	. . 
	ld d,l			;a7c7	55 	U 
	ld d,l			;a7c8	55 	U 
	ld d,l			;a7c9	55 	U 
	ld d,a			;a7ca	57 	W 
	dec b			;a7cb	05 	. 
	ld d,l			;a7cc	55 	U 
	ld e,d			;a7cd	5a 	Z 
	xor d			;a7ce	aa 	. 
	xor d			;a7cf	aa 	. 
	sub a			;a7d0	97 	. 
	nop			;a7d1	00 	. 
	nop			;a7d2	00 	. 
	ld d,l			;a7d3	55 	U 
	ld d,l			;a7d4	55 	U 
	ld d,l			;a7d5	55 	U 
	ld d,e			;a7d6	53 	S 
	nop			;a7d7	00 	. 
	inc b			;a7d8	04 	. 
	jr nc,la7dbh		;a7d9	30 00 	0 . 
la7dbh:
	jr nc,la7e0h		;a7db	30 03 	0 . 
	nop			;a7dd	00 	. 
	dec b			;a7de	05 	. 
la7dfh:
	xor d			;a7df	aa 	. 
la7e0h:
	xor d			;a7e0	aa 	. 
	xor d			;a7e1	aa 	. 
	nop			;a7e2	00 	. 
	nop			;a7e3	00 	. 
	inc b			;a7e4	04 	. 
	nop			;a7e5	00 	. 
	nop			;a7e6	00 	. 
	nop			;a7e7	00 	. 
	nop			;a7e8	00 	. 
	ld d,h			;a7e9	54 	T 
	nop			;a7ea	00 	. 
	nop			;a7eb	00 	. 
	nop			;a7ec	00 	. 
	nop			;a7ed	00 	. 
	nop			;a7ee	00 	. 
	ld d,l			;a7ef	55 	U 
	nop			;a7f0	00 	. 
	rrca			;a7f1	0f 	. 
	rst 38h			;a7f2	ff 	. 
	nop			;a7f3	00 	. 
	nop			;a7f4	00 	. 
	ld d,l			;a7f5	55 	U 
	ld d,l			;a7f6	55 	U 
	ld d,a			;a7f7	57 	W 
	defb 0fdh,055h,000h	;illegal sequence		;a7f8	fd 55 00 	. U . 
	ld l,d			;a7fb	6a 	j 
	sub l			;a7fc	95 	. 
	ld d,l			;a7fd	55 	U 
	ld d,l			;a7fe	55 	U 
	ld d,l			;a7ff	55 	U 
	ld (hl),b			;a800	70 	p 
	ld d,l			;a801	55 	U 
	ld d,l			;a802	55 	U 
	xor d			;a803	aa 	. 
	xor d			;a804	aa 	. 
	xor c			;a805	a9 	. 
	ld (hl),b			;a806	70 	p 
	nop			;a807	00 	. 
	dec b			;a808	05 	. 
	ld d,l			;a809	55 	U 
	ld d,l			;a80a	55 	U 
	ld d,l			;a80b	55 	U 
	nop			;a80c	00 	. 
	nop			;a80d	00 	. 
	ld b,e			;a80e	43 	C 
	nop			;a80f	00 	. 
	inc bc			;a810	03 	. 
	nop			;a811	00 	. 
	nop			;a812	00 	. 
	nop			;a813	00 	. 
	ld e,d			;a814	5a 	Z 
	xor d			;a815	aa 	. 
	xor d			;a816	aa 	. 
	and b			;a817	a0 	. 
	nop			;a818	00 	. 
	nop			;a819	00 	. 
	ld b,b			;a81a	40 	@ 
	nop			;a81b	00 	. 
	nop			;a81c	00 	. 
	nop			;a81d	00 	. 
	nop			;a81e	00 	. 
	dec b			;a81f	05 	. 
	ld b,b			;a820	40 	@ 
	nop			;a821	00 	. 
	nop			;a822	00 	. 
	nop			;a823	00 	. 
	nop			;a824	00 	. 
	dec b			;a825	05 	. 
	ld d,b			;a826	50 	P 
	nop			;a827	00 	. 
	rst 38h			;a828	ff 	. 
	ret p			;a829	f0 	. 
	nop			;a82a	00 	. 
	dec b			;a82b	05 	. 
	ld d,l			;a82c	55 	U 
	ld d,l			;a82d	55 	U 
	ld a,a			;a82e	7f 	 
	push de			;a82f	d5 	. 
	ld d,b			;a830	50 	P 
	ld b,0a9h		;a831	06 a9 	. . 
	ld d,l			;a833	55 	U 
	ld d,l			;a834	55 	U 
	ld d,l			;a835	55 	U 
	ld d,a			;a836	57 	W 
	dec b			;a837	05 	. 
	ld d,l			;a838	55 	U 
	ld e,d			;a839	5a 	Z 
	xor d			;a83a	aa 	. 
	xor d			;a83b	aa 	. 
	sub a			;a83c	97 	. 
	nop			;a83d	00 	. 
	nop			;a83e	00 	. 
	ld d,l			;a83f	55 	U 
	ld d,l			;a840	55 	U 
	ld d,l			;a841	55 	U 
	ld d,b			;a842	50 	P 
	nop			;a843	00 	. 
	inc b			;a844	04 	. 
	jr nc,la847h		;a845	30 00 	0 . 
la847h:
	jr nc,la849h		;a847	30 00 	0 . 
la849h:
	nop			;a849	00 	. 
	dec b			;a84a	05 	. 
	xor d			;a84b	aa 	. 
	xor d			;a84c	aa 	. 
	xor d			;a84d	aa 	. 
	nop			;a84e	00 	. 
	nop			;a84f	00 	. 
	inc b			;a850	04 	. 
	nop			;a851	00 	. 
	nop			;a852	00 	. 
	nop			;a853	00 	. 
	nop			;a854	00 	. 
la855h:
	nop			;a855	00 	. 
	nop			;a856	00 	. 
	nop			;a857	00 	. 
	nop			;a858	00 	. 
	nop			;a859	00 	. 
	nop			;a85a	00 	. 
	nop			;a85b	00 	. 
	nop			;a85c	00 	. 
	nop			;a85d	00 	. 
	nop			;a85e	00 	. 
	nop			;a85f	00 	. 
	nop			;a860	00 	. 
	nop			;a861	00 	. 
	nop			;a862	00 	. 
	nop			;a863	00 	. 
	nop			;a864	00 	. 
	nop			;a865	00 	. 
	nop			;a866	00 	. 
	nop			;a867	00 	. 
	nop			;a868	00 	. 
	ld bc,00000h		;a869	01 00 00 	. . . 
	nop			;a86c	00 	. 
	nop			;a86d	00 	. 
	nop			;a86e	00 	. 
	dec b			;a86f	05 	. 
	ld b,b			;a870	40 	@ 
	nop			;a871	00 	. 
	nop			;a872	00 	. 
	nop			;a873	00 	. 
	nop			;a874	00 	. 
	ld bc,00000h		;a875	01 00 00 	. . . 
	nop			;a878	00 	. 
	nop			;a879	00 	. 
	nop			;a87a	00 	. 
	nop			;a87b	00 	. 
	nop			;a87c	00 	. 
	nop			;a87d	00 	. 
	nop			;a87e	00 	. 
	nop			;a87f	00 	. 
	nop			;a880	00 	. 
	nop			;a881	00 	. 
la882h:
	nop			;a882	00 	. 
	nop			;a883	00 	. 
	nop			;a884	00 	. 
	nop			;a885	00 	. 
	nop			;a886	00 	. 
	nop			;a887	00 	. 
	nop			;a888	00 	. 
	nop			;a889	00 	. 
	nop			;a88a	00 	. 
	nop			;a88b	00 	. 
	nop			;a88c	00 	. 
	nop			;a88d	00 	. 
	nop			;a88e	00 	. 
	nop			;a88f	00 	. 
	nop			;a890	00 	. 
	nop			;a891	00 	. 
	nop			;a892	00 	. 
	nop			;a893	00 	. 
	nop			;a894	00 	. 
	nop			;a895	00 	. 
	nop			;a896	00 	. 
	nop			;a897	00 	. 
	nop			;a898	00 	. 
	nop			;a899	00 	. 
	nop			;a89a	00 	. 
	nop			;a89b	00 	. 
	nop			;a89c	00 	. 
	nop			;a89d	00 	. 
	nop			;a89e	00 	. 
	ld bc,00000h		;a89f	01 00 00 	. . . 
	nop			;a8a2	00 	. 
	nop			;a8a3	00 	. 
	nop			;a8a4	00 	. 
	ld d,l			;a8a5	55 	U 
	ld d,h			;a8a6	54 	T 
	nop			;a8a7	00 	. 
	nop			;a8a8	00 	. 
	nop			;a8a9	00 	. 
	nop			;a8aa	00 	. 
	ld bc,00000h		;a8ab	01 00 00 	. . . 
	nop			;a8ae	00 	. 
	nop			;a8af	00 	. 
	nop			;a8b0	00 	. 
	nop			;a8b1	00 	. 
	nop			;a8b2	00 	. 
	nop			;a8b3	00 	. 
	nop			;a8b4	00 	. 
	nop			;a8b5	00 	. 
	nop			;a8b6	00 	. 
	nop			;a8b7	00 	. 
	nop			;a8b8	00 	. 
	nop			;a8b9	00 	. 
	nop			;a8ba	00 	. 
	nop			;a8bb	00 	. 
	nop			;a8bc	00 	. 
	nop			;a8bd	00 	. 
	nop			;a8be	00 	. 
	nop			;a8bf	00 	. 
	nop			;a8c0	00 	. 
	nop			;a8c1	00 	. 
	nop			;a8c2	00 	. 
	nop			;a8c3	00 	. 
	nop			;a8c4	00 	. 
	nop			;a8c5	00 	. 
	nop			;a8c6	00 	. 
	nop			;a8c7	00 	. 
	nop			;a8c8	00 	. 
	nop			;a8c9	00 	. 
	nop			;a8ca	00 	. 
	nop			;a8cb	00 	. 
	nop			;a8cc	00 	. 
	nop			;a8cd	00 	. 
	nop			;a8ce	00 	. 
	nop			;a8cf	00 	. 
	nop			;a8d0	00 	. 
	nop			;a8d1	00 	. 
	nop			;a8d2	00 	. 
	nop			;a8d3	00 	. 
	nop			;a8d4	00 	. 
	dec b			;a8d5	05 	. 
	nop			;a8d6	00 	. 
	nop			;a8d7	00 	. 
	nop			;a8d8	00 	. 
	nop			;a8d9	00 	. 
	dec b			;a8da	05 	. 
	ld d,l			;a8db	55 	U 
	ld d,l			;a8dc	55 	U 
	nop			;a8dd	00 	. 
	nop			;a8de	00 	. 
	nop			;a8df	00 	. 
	nop			;a8e0	00 	. 
	dec b			;a8e1	05 	. 
	nop			;a8e2	00 	. 
	nop			;a8e3	00 	. 
	nop			;a8e4	00 	. 
	nop			;a8e5	00 	. 
	nop			;a8e6	00 	. 
	nop			;a8e7	00 	. 
	nop			;a8e8	00 	. 
	nop			;a8e9	00 	. 
	nop			;a8ea	00 	. 
	nop			;a8eb	00 	. 
	nop			;a8ec	00 	. 
	nop			;a8ed	00 	. 
	nop			;a8ee	00 	. 
	nop			;a8ef	00 	. 
	nop			;a8f0	00 	. 
	nop			;a8f1	00 	. 
	nop			;a8f2	00 	. 
	nop			;a8f3	00 	. 
	nop			;a8f4	00 	. 
	nop			;a8f5	00 	. 
	nop			;a8f6	00 	. 
	nop			;a8f7	00 	. 
	nop			;a8f8	00 	. 
	nop			;a8f9	00 	. 
	nop			;a8fa	00 	. 
	nop			;a8fb	00 	. 
	nop			;a8fc	00 	. 
	nop			;a8fd	00 	. 
	nop			;a8fe	00 	. 
	nop			;a8ff	00 	. 
	nop			;a900	00 	. 
	nop			;a901	00 	. 
	nop			;a902	00 	. 
	nop			;a903	00 	. 
	nop			;a904	00 	. 
	inc bc			;a905	03 	. 
	nop			;a906	00 	. 
	nop			;a907	00 	. 
	nop			;a908	00 	. 
	nop			;a909	00 	. 
	nop			;a90a	00 	. 
	dec b			;a90b	05 	. 
	ld b,b			;a90c	40 	@ 
	nop			;a90d	00 	. 
	nop			;a90e	00 	. 
	ld bc,05555h		;a90f	01 55 55 	. U U 
la912h:
	ld d,l			;a912	55 	U 
	ld d,l			;a913	55 	U 
	nop			;a914	00 	. 
	nop			;a915	00 	. 
	nop			;a916	00 	. 
	dec b			;a917	05 	. 
	ld b,b			;a918	40 	@ 
	nop			;a919	00 	. 
	nop			;a91a	00 	. 
	nop			;a91b	00 	. 
	nop			;a91c	00 	. 
	ld (bc),a			;a91d	02 	. 
	nop			;a91e	00 	. 
	nop			;a91f	00 	. 
	nop			;a920	00 	. 
	nop			;a921	00 	. 
	nop			;a922	00 	. 
	nop			;a923	00 	. 
	nop			;a924	00 	. 
	nop			;a925	00 	. 
	nop			;a926	00 	. 
	nop			;a927	00 	. 
	nop			;a928	00 	. 
	nop			;a929	00 	. 
	nop			;a92a	00 	. 
	nop			;a92b	00 	. 
	nop			;a92c	00 	. 
	nop			;a92d	00 	. 
	nop			;a92e	00 	. 
	nop			;a92f	00 	. 
	nop			;a930	00 	. 
	nop			;a931	00 	. 
	nop			;a932	00 	. 
	nop			;a933	00 	. 
	nop			;a934	00 	. 
	rrca			;a935	0f 	. 
	ret nz			;a936	c0 	. 
	nop			;a937	00 	. 
	nop			;a938	00 	. 
	nop			;a939	00 	. 
	nop			;a93a	00 	. 
	rla			;a93b	17 	. 
	ld d,b			;a93c	50 	P 
	nop			;a93d	00 	. 
	nop			;a93e	00 	. 
	nop			;a93f	00 	. 
	nop			;a940	00 	. 
	ld d,l			;a941	55 	U 
	ld d,h			;a942	54 	T 
	nop			;a943	00 	. 
	nop			;a944	00 	. 
	ld d,l			;a945	55 	U 
	ld d,l			;a946	55 	U 
	ld d,l			;a947	55 	U 
	ld d,l			;a948	55 	U 
	ld d,l			;a949	55 	U 
	ld d,h			;a94a	54 	T 
	nop			;a94b	00 	. 
	nop			;a94c	00 	. 
	ld d,l			;a94d	55 	U 
	ld d,h			;a94e	54 	T 
	nop			;a94f	00 	. 
	nop			;a950	00 	. 
	nop			;a951	00 	. 
	nop			;a952	00 	. 
	dec d			;a953	15 	. 
	ld d,b			;a954	50 	P 
	nop			;a955	00 	. 
	nop			;a956	00 	. 
	nop			;a957	00 	. 
	nop			;a958	00 	. 
	ld (bc),a			;a959	02 	. 
	nop			;a95a	00 	. 
	nop			;a95b	00 	. 
	nop			;a95c	00 	. 
	nop			;a95d	00 	. 
	nop			;a95e	00 	. 
	ld a,(bc)			;a95f	0a 	. 
	add a,b			;a960	80 	. 
	nop			;a961	00 	. 
	nop			;a962	00 	. 
la963h:
	nop			;a963	00 	. 
	nop			;a964	00 	. 
	nop			;a965	00 	. 
	djnz la912h		;a966	10 aa 	. . 
	xor d			;a968	aa 	. 
	xor d			;a969	aa 	. 
	ld d,b			;a96a	50 	P 
	nop			;a96b	00 	. 
	nop			;a96c	00 	. 
	nop			;a96d	00 	. 
	djnz la970h		;a96e	10 00 	. . 
la970h:
	nop			;a970	00 	. 
	nop			;a971	00 	. 
	ld bc,0aa0ah		;a972	01 0a aa 	. . . 
	xor d			;a975	aa 	. 
	and l			;a976	a5 	. 
	nop			;a977	00 	. 
	nop			;a978	00 	. 
	nop			;a979	00 	. 
	ld bc,00040h		;a97a	01 40 00 	. @ . 
	nop			;a97d	00 	. 
	nop			;a97e	00 	. 
	ld e,d			;a97f	5a 	Z 
	xor d			;a980	aa 	. 
	xor d			;a981	aa 	. 
	and b			;a982	a0 	. 
	ld b,b			;a983	40 	@ 
	nop			;a984	00 	. 
	nop			;a985	00 	. 
	nop			;a986	00 	. 
	inc b			;a987	04 	. 
	nop			;a988	00 	. 
	nop			;a989	00 	. 
	nop			;a98a	00 	. 
	dec b			;a98b	05 	. 
	xor d			;a98c	aa 	. 
	xor d			;a98d	aa 	. 
	xor d			;a98e	aa 	. 
	inc b			;a98f	04 	. 
	nop			;a990	00 	. 
	nop			;a991	00 	. 
	nop			;a992	00 	. 
	org $a993
la993h:
	ld b,d			;a993	42 	B 
	add a,c			;a994	81 	. 
	ld (de),a			;a995	12 	. 
	add a,h			;a996	84 	. 
	ld b,090h		;a997	06 90 	. . 
	and e			;a999	a3 	. 
	jp z,01047h		;a99a	ca 47 10 	. G . 
	dec de			;a99d	1b 	. 
	add a,h			;a99e	84 	. 
	rst 38h			;a99f	ff 	. 
	rst 38h			;a9a0	ff 	. 
	ld b,d			;a9a1	42 	B 
	call po,0d111h		;a9a2	e4 11 d1 	. . . 
	dec b			;a9a5	05 	. 
	add a,l			;a9a6	85 	. 
	ld d,d			;a9a7	52 	R 
	nop			;a9a8	00 	. 
	djnz la9cbh		;a9a9	10 20 	.   
	ex af,af'			;a9ab	08 	. 
	ld b,b			;a9ac	40 	@ 
	ld b,c			;a9ad	41 	A 
	add hl,bc			;a9ae	09 	. 
	inc h			;a9af	24 	$ 
	inc d			;a9b0	14 	. 
	xor d			;a9b1	aa 	. 
	xor e			;a9b2	ab 	. 
	rst 38h			;a9b3	ff 	. 
	rst 38h			;a9b4	ff 	. 
	rst 38h			;a9b5	ff 	. 
	rst 38h			;a9b6	ff 	. 
	jp pe,010aah		;a9b7	ea aa 10 	. . . 
	ex af,af'			;a9ba	08 	. 
	ld h,b			;a9bb	60 	` 
	inc d			;a9bc	14 	. 
	ld b,c			;a9bd	41 	A 
	inc h			;a9be	24 	$ 
	jr laa01h		;a9bf	18 40 	. @ 
	inc d			;a9c1	14 	. 
	add a,c			;a9c2	81 	. 
	ld b,d			;a9c3	42 	B 
	nop			;a9c4	00 	. 

la9c5h:
	nop			;a9c5	00 	. 
	inc e			;a9c6	1c 	. 
	inc d			;a9c7	14 	. 
	nop			;a9c8	00 	. 
	nop			;a9c9	00 	. 
	ld d,e			;a9ca	53 	S 
la9cbh:
	inc d			;a9cb	14 	. 
	nop			;a9cc	00 	. 
	nop			;a9cd	00 	. 
	adc a,d			;a9ce	8a 	. 
	inc d			;a9cf	14 	. 
	nop			;a9d0	00 	. 
	nop			;a9d1	00 	. 
	pop bc			;a9d2	c1 	. 
	inc d			;a9d3	14 	. 
	nop			;a9d4	00 	. 
la9d5h:
	jr la9d7h		;a9d5	18 00 	. . 
la9d7h:
	nop			;a9d7	00 	. 
	nop			;a9d8	00 	. 
	nop			;a9d9	00 	. 
	nop			;a9da	00 	. 
	jr laa0ch		;a9db	18 2f 	. / 
	nop			;a9dd	00 	. 
	nop			;a9de	00 	. 
	nop			;a9df	00 	. 
	nop			;a9e0	00 	. 
	nop			;a9e1	00 	. 
	cpl			;a9e2	2f 	/ 
	ld c,a			;a9e3	4f 	O 
	nop			;a9e4	00 	. 
	nop			;a9e5	00 	. 
	nop			;a9e6	00 	. 
	nop			;a9e7	00 	. 
	nop			;a9e8	00 	. 
	ld c,a			;a9e9	4f 	O 
	ld h,(hl)			;a9ea	66 	f 
	nop			;a9eb	00 	. 
	nop			;a9ec	00 	. 
	nop			;a9ed	00 	. 
	nop			;a9ee	00 	. 
	nop			;a9ef	00 	. 
	ld h,(hl)			;a9f0	66 	f 
la9f1h:
	ld bc,01001h		;a9f1	01 01 10 	. . . 
	nop			;a9f4	00 	. 
	ld (bc),a			;a9f5	02 	. 
	nop			;a9f6	00 	. 
	ld sp,04731h		;a9f7	31 31 47 	1 1 G 
	nop			;a9fa	00 	. 
	ld (bc),a			;a9fb	02 	. 
	nop			;a9fc	00 	. 
	ld l,b			;a9fd	68 	h 
	ld l,b			;a9fe	68 	h 
	ld a,l			;a9ff	7d 	} 
	nop			;aa00	00 	. 
laa01h:
	ld (bc),a			;aa01	02 	. 
	nop			;aa02	00 	. 
	sbc a,e			;aa03	9b 	. 
	sbc a,e			;aa04	9b 	. 
	or h			;aa05	b4 	. 
	nop			;aa06	00 	. 
	ld (bc),a			;aa07	02 	. 
	nop			;aa08	00 	. 
	jp nc,0eed2h		;aa09	d2 d2 ee 	. . . 
laa0ch:
	nop			;aa0c	00 	. 
	ld (bc),a			;aa0d	02 	. 
	nop			;aa0e	00 	. 
laa0fh:
	ld d,02dh		;aa0f	16 2d 	. - 
	ld c,l			;aa11	4d 	M 
	ld h,h			;aa12	64 	d 
	ld a,(de)			;aa13	1a 	. 
	ld hl,(06151h)		;aa14	2a 51 61 	* Q a 
	adc a,b			;aa17	88 	. 
	sbc a,b			;aa18	98 	. 
	cp a			;aa19	bf 	. 
	rst 8			;aa1a	cf 	. 
	inc h			;aa1b	24 	$ 
	ld e,e			;aa1c	5b 	[ 
	sub d			;aa1d	92 	. 
	ret			;aa1e	c9 	. 
	rst 38h			;aa1f	ff 	. 
