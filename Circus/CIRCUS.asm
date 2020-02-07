;***********************************************************************************************
;
; 	Circus  
;   Disect by Casper 08.01.2020
;
;	Verified with SjASMPlus Z80 Cross-Assembler v1.14.3 (https://github.com/z00m128/sjasmplus)
;-----------------------------------------------------------------------------------------------


	MACRO	FNAME 	filename
.beg		defb 	filename
			block 	16-$+.beg
			defb	0
	ENDM


; org 7AD1
;***********************************************************************
; File Header Block
	defb 	"VZF0"                  			; [0000] Magic
	FNAME	"CIRCUS"
	defb	$F0             					; File Type
    defw    $7ae9           					; Destination/Start address

;******* BASIC STARTUP **************************************************

        org     $7ae9

; 10 CLS:A=0
BASIC_10
        defw    BASIC_20        				; next basic line       		; [7ae9] f3 7a
        defw    10              				; basic line number     		; [7aeb] 00 0a        
        defb    $84             				; CLS                   		; [7aed] 84
        defb    ":"             				; instruction end       		; [7aee] 3a
        defb    $41,$d5,$30     				; A=05                  		; [7aef] 41 d5 30
        defb    0               				; End of line           		; [7af2] 00

; 20 PRINT"INPUT":PRINT"J FOR JOYSTICK":PRINT"K FOR KEYBOARD"
BASIC_20
        defw    BASIC_30        				; next basic line       		; [7af3] 24 7b
        defw    20              				; basic line number     		; [7af5] 14 00
        defb    $b2,$22,"INPUT",$22 			; PRINT"INPUT"      			; [7af7] b2 22 49 4e 50 55 54 22 
        defb    $3a             				; instruction end       		; [7aff] 3a
        defb    $b2,$22,"J FOR JOYSTICK",$22 	; PRINT"J FOR JOYSTICK" 		; [7b00] b2 22 4a 20 46 4f 52 20 4a 4f 59 53 54 49 43 4b 22 
        defb    $3a             				; instruction end       		; [7b11] 3a
        defb    $b2,$22,"K FOR KEYBOARD",$22 	; PRINT"K FOR KEYBOARD" 		; [7b12] b2 22 4b 20 46 4f 52 20 4b 45 59 42 4f 41 52 44 22
        defb    0               				; End of line           		; [7b23] 00

; 30 INPUTA$
BASIC_30
        defw    BASIC_40        				; next basic line       		; [7b24] 2c 7b
        defw    30              				; basic line number     		; [7b26] 1e 00
        defb    $89,"A$"        				; INPUTA$               		; [7b28] 89 41 24
        defb    0               				; End of line           		; [7b2b] 00

; 40 IFA$<>"J"ANDA$<>"K"THEN10
BASIC_40
        defw    BASIC_50        				; next basic line       		; [7b2c] 44 7b
        defw    40              				; basic line number     		; [7b2e] 28 00
        defb    $8f,"A$",$d6,$d4,$22,"J",$22    ; IFA$<>"J"    		 			; [7b30] bf 41 24 d6 d4 22 4a 22
        defb    $d2,"A$",$d6,$d4,$22,"K",$22    ; ANDA$<>"K"    				; [7b37] d2 41 24 d6 d4 22 4b 22
        defb    $ca,"10"        				; THEN10                		; [7b40] ca 31 30
        defb    0               				; End of line           		; [7b43] 00

; 50 IFA$="J"THENA=255
BASIC_50
        defw    BASIC_60       	 				; next basic line       		; [7b44] 56 7b
        defw    50              				; basic line number     		; [7b46] 32 00
        defb    $8f,"A$",$d5,$22,"J",$22        ; IFA$="J"      				; [7b48] bf 41 24 d5 22 4a 22
        defb    $ca,"A",$d5,"255"               ; THENA=255     				; [7b4f] ca 41 d5 32 35 35
        defb    0               				; End of line           		; [7b55] 00

; 60 PRINT"PRESS ANY KEY TO START"
BASIC_60
        defw    BASIC_70        				; next basic line       		; [7b56] 74 7b
        defw    60              				; basic line number     		; [7b58] 3c 00
        defb    $b2,$22,"PRESS ANY KEY TO START",$22    						; [7b5a] b2 22 50 52 45 53 53 20 41 4e 59 20 4b 45 59 54 4f 20 53 54 41 52 54 22
        defb    0               				; End of line           		; [7b73] 00

; 70 FORI=1TO800:NEXT
BASIC_70
        defw    BASIC_72        				; next basic line       		; [7b74] 83 7b
        defw    70              				; basic line number     		; [7b76] 46 00
        defb    $81,"I",$d5,"1",$bd,"800" 		; FORI=1TO800 					; [7b78] 81 49 d5 31 bd 38 30 30 
        defb    $3a             				; instruction end       		; [7b80] 3a
        defb    $87             				; NEXT                  		; [7b81] 87
        defb    0               				; End of line           		; [7b82] 00

; 72 A$=INKEY$
BASIC_72
        defw    BASIC_75        				; next basic line       		; [7b83] 8c 7b
        defw    72              				; basic line number     		; [7b85] 48 00
        defb    "A$",$d5,$c9    				; A$=INKEY$             		; [7b87] 41 24 d5 c9
        defb    0               				; End of line           		; [7b8b] 00

; 75 A$=INKEY$:IFA$=""THEN75
BASIC_75
        defw    BASIC_80        				; next bacic line       		; [7b8c] 9f 7b
        defw    75              				; basic line number     		; [7b8e] 41 00
        defb    "A$",$d5,$c9    				; A$=INKEY$             		; [7b90] 41 24 d5 c9 
        defb    $3a             				; instruction end       		; [7b94] 3a
        defb    $8f,"A$",$d5,$22,$22,$ca,"75" 	; IFA$=""THEN75   				; [7b95] 8f 41 24 d5 22 22 ca 37 35
        defb    0               				; end of line           		; [7b9e] 00

; 80 POKE30738,A:POKE30862,208:POKE30863,123:A=USR(X)
; Binary Start adres = 123 * 256 + 208 = ($7b << 8) | $d0 = $7bd0
BASIC_80
        defw    BASIC_END       				; next basic line       		; [7b9f] c9 7b
        defw    80              				; basic line number     		; [7ba1] 00 50
        defb    $B1,"30738,A"   				; POKE30738,A           		; [7ba3] B1 33 30 37 33 38 2c 41
        defb    $3a             				; instruction end       		; [7bab] 3a
        defb    $B1,"30862,208" 				; POKE30862,208         		; [7bac] B1 33 30 38 36 32 2c 32 30 38
        defb    $3a             				; instruction end       		; [7bb6] 3a
        defb    $B1,"30863,123" 				; POKE30863,123         		; [7bb7] B1 33 30 38 36 33 2c 31 32 33
        defb    $3a             				; instruction end       		; [7bc1] 3a
        defb    "A",$d5,$c1,"(X)"  				; A=USR(X)           			; [7bc2] 41 d5 c1 28 58 29
        defb    0               				; end of line           		; [7bc8] 00

BASIC_END
        defw    0               				; next line 0 means end 		; [7bc9] 00 00
        defw    80              				; basic line number     		; [7bcb] 50 00
        defb    0               				; end of line           		; [7bcd] 00

        defb    $00,$00         				; end of code           		; [7bce] 00 00

;******************************************************************************
; SYSTEM VARIABLES
JOY_FIRE_PORT		equ		$20			; (RD) Joystick Fire button
JOY1_PORT			equ		$2e			; (RD) Joystick 1 IO Port 
JOY2_PORT			equ		$2b			; (RD) Joystick 2 IO Port 
KEYB_PORT       	equ     $6800       ; (RD) Keyboard adress start
IOLATCH         	equ     $6800       ; (WR) Hardware IO Latch, (RD) Keyboard all Keys
BIT_VDG_MODE    	equ     00001000b   ; VDG Mode
BIT_SPK_MINUS   	equ     00100000b   ; Speake Pin (-)
BIT_SPK_PLUS   		equ     00000001b   ; Speake Pin (-)
SPEAKER_PINS		equ		BIT_SPK_MINUS|BIT_SPK_PLUS
VRAM            	equ     $7000       ; Video RAM start address
USER_INT_PROC    	equ     $787d  		; 3 bytes - jump vector called by System on interrupt

;******************************************************************************
; GAME VARIABLES
CUR_SCORE       	equ     $7800   	; (word) game score in BCD format
BALOONS_RED_DIR		equ		$7802		; (byte) movement direction for Baloons Red 0 - right, $80 - left
BALOONS_YEL_DIR		equ		$7803		; (byte) movement direction for Ballons Yellow 0 - right, $80 - left
BALOONS_BLU_DIR		equ		$7804		; (byte) movement direction for Baloons Blue 0 - right, $80 - left
BALOONS_DRAW_NEXT	equ		$7805		; (byte) round robin counter for Baloon Group next to be drawn
BALOONS_RED_X_FRAC	equ		$7806		; (byte) position X for Baloons Group Red (fraction of pixel)
BALOONS_YEL_X_FRAC	equ		$7807		; (byte) position X for Baloons Group Yellow (fraction of pixel)
BALOONS_BLU_X_FRAC	equ		$7808		; (byte) position X for Baloons Group Blue (fraction of pixel)
PLAYER_POS_VADR		equ		$7809		; (word) PLAYER screen position as VRAM address
JUMPER_W_VADR		equ		$780b		; (word) JUMPER W(aiting) screen position as VRAM address
JUMPER_VADR			equ		$780d		; (word) JUMPER screen position as VRAM address
PLAYER_X_FRAC		equ		$780f		; (word) position X for PLAYER (fraction of pixel) 16 bit value with next byte
PLAYER_X_INT		equ		$7810		; (byte) position X for PLAYER in integral pixels
JUMPER_W_X_INT		equ		$7811		; (byte) position X for JUMPER W(aiting) in integral pixels
INPUT_FLAG      	equ     $7812   	; (byte) input chosen by user 255 - Joystick. 0 - Keyboard
JUMPER_W_Y_INT		equ		$7813		; (byte) position Y for JUMPER W(aiting) in lines (bottom up)
JUMPER_X_FRAC		equ		$7814		; (word) position X for JUMPER (fraction of pixel) 16 bit value with next byte
JUMPER_X_INT		equ		$7815		; (byte) position X for JUMPER in integral pixels
JUMPER_Y_FRAC		equ		$7816		; (word) position Y for JUMPER (fraction of pixel) 16 bit value with next byte
JUMPER_Y_INT		equ		$7817		; (byte) position Y for JUMPER in integral pixels
GAME_EVENT			equ		$7818		; (byte) game event variable shared with interrupt routines
BALOONS_LEFT		equ		$7819		; (byte) number of Baloons left
BAR_CLEAR_FLAG		equ		$781a		; (byte) set when player unit moved and 1px on left must be cleared
BAR_FLIP_FLAG		equ		$781b		; (byte) player unit bar flipped flag (0 not flipped)
PLAYER_X_VEL		equ		$781c		; (word) 16 bit value to add/sub player pos X when move
WORLD_GRAVITY		equ		$781e		; (word) gravity value used to subtract from Y velocity of Jumper
JUMPER_X_VEL		equ		$7820		; (word) 16 bit value to add/sub Jumper pos X when move
JUMPER_Y_VEL		equ		$7822		; (word) 16 bit value to add/sub Jumper pos Y when move
JUMPER_W_CLR_VADR	equ		$7824		; (word) VRAM address of Jumper W(aiting) used to clear sprite area plus 1 byte on left
JUMPER_W_CLR_X_INT	equ		$7826		; (byte) position X for Jumper W(aiting) in pixels used to clear sprite area plus 1 byte on left
JUMPER_CLR_VADR		equ		$7827		; (word) VRAM address of Jumper used to clear sprite area 
JUMPER_CLR_X_INT	equ		$7829		; (byte) position X for Jumper in pixels used to clear sprite area 
LIFE_COUNTER		equ		$782a		; (byte) player life counter
IOLATCH_SHADOW  	equ     $782b   	; (byte) custom IO Latch shadow register 
SCR_DIRTY_FLAG		equ		$782c		; (byte) set to $80 if screen need cleanup, 0 - cleanup done
PLAYER_DEATH_VADR	equ		$782d		; (word) VRAM address to draw/clear player death
GAME_MODE           equ     $782f   	; (byte) 255 - Demo Mode (computer plays until key pressed), 0 - Runnin Mode  
SPR_BUF_DIGIT 		equ    	$7830   	; 10 bytes buffer for sprites generated for Score digits        
SPR_BUF_BALOONS_RED	equ		$7880		; 128 bytes buffer for Baloons Group Red
SPR_BUF_BALOONS_YEL	equ		$7900		; 128 bytes buffer for Baloons Group Yellow
SPR_BUF_BALOONS_BLU	equ		$7980		; 128 bytes buffer for BAloons Group Blue
RESET_VAR			equ		$7a00		; (byte) reset to 0 on new game (but no more used)
SPR_BUF_PLAYER		equ		$7a01		; 56 bytes buffer for Player Sprite
SPR_BUF_JUMPER_W	equ		$7a39		; 21 bytes buffer for Jumper W(aiting) Sprite
SPR_BUF_JUMPER		equ		$7a4e		; 21 bytes buffer for Jumper Sprite


;******************************************************************************
;
;    M A I N   G A M E
;
;******************************************************************************
START   			org     $7bd0
; -- disable interrupts and set Demo Mode for Game
	di						; disable interrupts                        		;7bd0	f3
	ld sp,$9000				; set StackPointer to max RAM (6kB models)  		;7bd1	31 00 90
	ld a,$ff				; initial value for Game Mode              			;7bd4	3e ff 
	ld (GAME_MODE),a		; set Demo Mode							 			;7bd6	32 2f 78

GAME_INIT:
	call INIT_GAME			; initialize Game									;7bd9	cd 33 7d
	ld hl,VRAM+(20*32)+0	; screen coord (0,20) px [$7280]					;7bdc	21 80 72
	ld ix,SPR_JUMPER_S0		; sprite MAN 2 (12x7)px								;7bdf	dd 21 26 81
	ld b,7					; 7 lines - sprite height							;7be3	06 07  
	ld c,3					; 3 bytes - sprite width (12px)						;7be5	0e 03 
	call DRAW_SPRITE_T		; draw sprite with transparency						;7be7	cd 8c 7f 
	call PLAY_MEL_START		; play intro melody									;7bea	cd 39 89
GAME_NEW:
	ld hl,16				; ~1/25 px - world gravity force					;7bed	21 10 00
	ld (WORLD_GRAVITY),hl	; store value										;7bf0	22 1e 78 
	ld hl,$00a0				; init JUMPER Y velocity (7/16 px)					;7bf3	21 a0 00
	ld (JUMPER_Y_VEL),hl	; store JUMPER Y velocity							;7bf6	22 22 78 
	ld hl,$00a0				; init JUMPER X velocity (7/16 px)					;7bf9	21 ff 00 
	ld (JUMPER_X_VEL),hl	; store JUMPER X velocity 							;7bfc	22 20 78 
; -- initial position for JUMPER
	ld hl,VRAM+(20*32)+0	; screen coord (0,20) px [$7280]					;7bff	21 80 72 
	ld (JUMPER_VADR),hl		; store as current JUMPER VRAM address				;7c02	22 0d 78 
	ld (JUMPER_CLR_VADR),hl	; store VRAM address for clear routines				;7c05	22 27 78 
	ld hl,0					; init pos X (h=0 pixels, l=0 fraction)				;7c08	21 00 00 
	ld (JUMPER_X_FRAC),hl	; store JUMPER initial X position (16 bit)			;7c0b	22 14 78 
	ld hl,$2b00				; init pos Y (h=43 pixels, l=0 fraction)			;7c0e	21 00 2b 
	ld (JUMPER_Y_FRAC),hl	; store JUMPER initial Y position (16 bit)			;7c11	22 16 78
	xor a					; init pos X 										;7c14	af 
	ld (JUMPER_CLR_X_INT),a	; store position X for clear routines				;7c15	32 29 78 

GAME_MAIN_LOOP:
	xor a					; 0 - no events to handle							;7c18	af 
	ld (GAME_EVENT),a		; store to Game Event variable						;7c19	32 18 78
	ei						; enable interrupts									;7c1c	fb 
; -- wait for game event (key/joystick interraction)
GAME_WAIT1:
	ld a,(GAME_EVENT)		; a - game event									;7c1d	3a 18 78 
	or a					; chack if any ocourred								;7c20	b7 
	jr z,GAME_WAIT1			; wait for event 									;7c21	28 fa
; -- a - event to handle 
	di						; disable interrupts								;7c23	f3 
	jp m,BALOON_COLLECTED	; bit 7 = 1 - Baloon Collected							;7c24	fa ab 7c 

; -- bit 7 = 0 - Player Died - schedule Death drawing and wait 
	ld hl,INT_GAME_DEATH	; set interrupt proc (Death variant)				;7c27	21 41 88 
	ld (USER_INT_PROC+1),hl	; set system redirection							;7c2a	22 7e 78
	ei						; enable interrupts									;7c2d	fb 
; -- INT_GAME_DEATH proc clears Game Event variable - wait for next frame
GAME_WAIT2:
	ld a,(GAME_EVENT)		; a - Game Event									;7c2e	3a 18 78 
	or a					; check if already handled							;7c31	b7 
	jr nz,GAME_WAIT2		; wait for screen update							;7c32	20 fa 
; -- disable interrupts, decrement Life Counter and End Game or Start next Play 
	di						; disable interrupts								;7c34	f3 
	call PLAY_SND_HIGH		; play high beep sound								;7c35	cd 2d 87 
	ld a,(LIFE_COUNTER)		; a - number of lives left for player				;7c38	3a 2a 78 
	dec a					; dec counter										;7c3b	3d 
	ld (LIFE_COUNTER),a		; store new value									;7c3c	32 2a 78 
	jp z,GAME_OVER			; jump if End of Game (no lives left)				;7c3f	ca fe 7c 
; -- more Lives left - continue 
	ld a,(GAME_MODE)		; a - Game Mode										;7c42	3a 2f 78
	or a					; check if Demo Mode								;7c45	b7 
	jp nz,DEMO_GAMEPLAY_END	; yes - shorter delay than in game					;7c46	c2 28 7d 
;-- Game Running - longer wait delay [counter dbc = $3ffff]
	ld d,3					; delay high dword value							;7c49	16 03 
G_WAIT_DBC:
	ld bc,$ffff				; delay low dword value								;7c4b	01 ff ff 
G_WAIT_BC:
	dec bc					; dec delay countr									;7c4e	0b 
	ld a,b					; check if 0										;7c4f	78 
	or c					; a = b|c											;7c50	b1 
	jr nz,G_WAIT_BC			; repeat until 0									;7c51	20 fb 
	dec d					; dec delay counter 								;7c53	15 
	jr nz,G_WAIT_DBC		; repeat until 0									;7c54	20 f5 

; -- Continue Game 
GAMEPLAY_START:
; -- reset Player Unit position and Bar state
	xor a					; 0 - player unit bar not flipped (left-up)			;7c56	af 
	ld (BAR_FLIP_FLAG),a	; store current bar state 							;7c57	32 1b 78 
	ld hl,03400h			; player pos X: h=52 pixels, l=fraction				;7c5a	21 00 34 
	ld (PLAYER_X_FRAC),hl	; store initial player position						;7c5d	22 0f 78 
; -- reset Jumper Waiting position
	ld a,69					; Jumper Waiting pos X 								;7c60	3e 45 
	ld (JUMPER_W_X_INT),a	; store initial value								;7c62	32 11 78 
	ld (JUMPER_W_CLR_X_INT),a	; store pos X for clear routines				;7c65	32 26 78 
	ld a,15					; Jumper Waiting pos Y (bottom up)					;7c68	3e 0f 
	ld (JUMPER_W_Y_INT),a	; store initial value								;7c6a	32 13 78 
	ld hl,VRAM+(48*32)+17	; screen coord (68x48) px [$7611]					;7c6d	21 11 76  
	ld (JUMPER_W_VADR),hl	; store current position							;7c70	22 0b 78 
; -- reset Player Unit offscreen buffer content	
	ld hl,SPR_PLAYER_S0		; src - address of original sprite (base version)	;7c73	21 38 80 
	ld de,SPR_BUF_PLAYER	; dst - address of buffer							;7c76	11 01 7a 
	ld bc,56				; cnt - 56 bytes to copy							;7c79	01 38 00 
	ldir					; copy sprite to buffer								;7c7c	ed b0 
; -- reset Jumper Waiting offscreen buffer content
	ld hl,SPR_JUMPER_S1		; src - address of original sprite (1px shifted) 	;7c7e	21 3b 81 
	ld de,SPR_BUF_JUMPER_W	; dst - address of buffer							;7c81	11 39 7a 
	ld bc,21				; cnt - bytes to copy								;7c84	01 15 00 
	ldir					; copy sprite to buffer								;7c87	ed b0 
; -- play double sound	
	call PLAY_SND_HIGH		; play high beep sound								;7c89	cd 2d 87 
	call PLAY_SND_HIGH		; play high beep sound								;7c8c	cd 2d 87 
; -- schedule screen cleanup and wait for frame
	ld hl,INT_CLEANUP		; Game interrupt proc - Cleanup variant				;7c8f	21 b9 88 
	ld (USER_INT_PROC+1),hl	; set system redirection							;7c92	22 7e 78 
; -- set dirty flag and wait
	ld a,$80				; a - screen needs cleanup							;7c95	3e 80 
	ld (SCR_DIRTY_FLAG),a	; set dirty flag									;7c97	32 2c 78 
	ei						; enable interrupts									;7c9a	fb 
WAIT_SCR_READY:
	ld a,(SCR_DIRTY_FLAG)	; a - dirty screen flag								;7c9b	3a 2c 78 
	or a					; is screen ready ?									;7c9e	b7 
	jr nz,WAIT_SCR_READY	; no - wait for interrupt proc done 				;7c9f	20 fa 

; -- Screen is Ready - set INT routine to handle game 	
	di						; disable interrupts while setting					;7ca1	f3 
	ld hl,INT_GAME_MAIN		; hl - interrupt proc (Game Main variant) 			;7ca2	21 ae 82 
	ld (USER_INT_PROC+1),hl	; set system redirection							;7ca5	22 7e 78 
	jp GAME_NEW				; ----- End of Proc --- restart gameplay			;7ca8	c3 ed 7b 


;*****************************************************************************************
; Baloon was collected by Player
BALOON_COLLECTED:
; -- play short beep sound
	call PLAY_SND_HIGH		; play high beep sound								;7cab	cd 2d 87 
; --
	ld hl,$0010				; new JUMPER Y velocity ~1/25 px					;7cae	21 10 00 
	ld (JUMPER_Y_VEL),hl	; store new Y velocity								;7cb1	22 22 78 
	ld hl,INT_BALOON_COLLECTED	; interrupt proc - Baloon Killed variant			;7cb4	21 17 88 
	ld (USER_INT_PROC+1),hl	; set system redirection							;7cb7	22 7e 78 
	ei						; enable interrupts									;7cba	fb 
; -- wait until interrupt proc updaate score, baloons buffer, etc
AK_WAIT:
	ld a,(GAME_EVENT)		; a - Game Event									;7cbb	3a 18 78 
	or a					; check if already handled							;7cbe	b7 
	jr nz,AK_WAIT			; no - wait for event handled						;7cbf	20 fa 
; -- Game is updated - restore main intterrupt routine 
	di						; disable interrupts								;7cc1	f3 
	ld hl,INT_GAME_MAIN		; hl - interrupt proc (Game Main variant)			;7cc2	21 ae 82 
	ld (USER_INT_PROC+1),hl	; set system redirection							;7cc5	22 7e 78 
; -- decrement Baloons counter and check if any left
	ld a,(BALOONS_LEFT)		; a - baloons left									;7cc8	3a 19 78 
	dec a					; decrement counter									;7ccb	3d 
	ld (BALOONS_LEFT),a		; store new value									;7ccc	32 19 78 
	jp nz,GAME_MAIN_LOOP	; if any left continue game							;7ccf	c2 18 7c 

; -- no more Baloons to collect - Player Won - let him continue with any Lives left
; -- wait delay (24 bit value using registers D and BC)
	ld d,4					; d - delay counter 								;7cd2	16 04  
AK_DELAY_BCD:
	ld bc,$0000				; bc - delay counter lower word $10000				;7cd4	01 00 00 
AK_DELAY_BC:
	dec bc					; decrement counter									;7cd7	0b 
	ld a,c					; check if 0										;7cd8	79 
	or b					; a = b|c											;7cd9	b0 
	jr nz,AK_DELAY_BC		; repeat until 0									;7cda	20 fb 
	dec d					; decrement high counter value						;7cdc	15 
	jr nz,AK_DELAY_BCD		; wait until 0										;7cdd	20 f5 

; -- restart screen to initial state
	call INIT_START_SCREEN	; draw screen in startup state						;7cdf	cd 45 7d 

; -- decrement life counter and draw it on screen
	ld a,(LIFE_COUNTER)		; current Life Counter value						;7ce2	3a 2a 78 
	dec a					; dec counter										;7ce5	3d 
	ld d,a					; d - number of lives left							;7ce6	57 
	call SET_LIFE_COUNTER	; redraw life counter icons							;7ce7	cd a9 7d 
	call INIT_SPRITES		; initialize Sprites 								;7cea	cd c6 7d

; -- draw JUMPER on Left Stand	
	ld hl,VRAM+(20*32)+0	; screen coord (0,20)px [$7280]						;7ced	21 80 72 
	ld ix,SPR_JUMPER_S0		; sprite JUMPER (12x7)px (base version)				;7cf0	dd 21 26 81
	ld b,7					; 7 lines - sprite height 							;7cf4	06 07 
	ld c,3					; 3 bytes - sprite width (12px)						;7cf6	0e 03 
	call DRAW_SPRITE_T		; draw sprite with transparency						;7cf8	cd 8c 7f   
	jp GAME_NEW				; start New Game									;7cfb	c3 ed 7b

;********************************************************************************
; Game Over routine
; Called when no more lives left in life counter
GAME_OVER:
; -- short delay ----
	ld bc,48				; delay counter										;7cfe	01 30 00 
GO_DELAY:
	dec bc					; dec delay counter									;7d01	0b 
	ld a,b					; check if 0										;7d02	78 
	or c					; a = b|c											;7d03	b1 
	jr nz,GO_DELAY			; repeat until 0									;7d04	20 fb 

; -- play GameOver Melody 
	call PLAY_MEL_GAME_OVER	; play GameOver Melody								;7d06	cd 49 89 

; -- check if Demo mode and if so than start new Game
	ld a,(GAME_MODE)		; a - Game Mode										;7d09	3a 2f 78 
	or a					; check if Demo Mode								;7d0c	b7 
	jp nz,GAME_INIT			; yes - start new game								;7d0d	c2 d9 7b 

; -- Game Running - wait for key or joystick input
GO_WAIT_FOR_INPUT:
	ld a,(INPUT_FLAG)		; check chosen input device							;7d10	3a 12 78
	or a					; is this Keyboard ? (0 keys, 255 joystick)			;7d13	b7 
	jr z,GO_CHECK_KEYS		; yes - check key pressed							;7d14	28 07 
; -- check joystick input	
	in a,(JOY_FIRE_PORT)	; get joiystick button								;7d16	db 20 
	bit 4,a					; is button pressed ?								;7d18	cb 67 
	jp z,GAME_INIT			; yes - start new game								;7d1a	ca d9 7b 
; -- check key pressed
GO_CHECK_KEYS:
	ld a,(KEYB_PORT)		; read all keys	at once								;7d1d	3a 00 68 
	cpl						; inverse logic (key press sets bit)				;7d20	2f 
	and $3f					; any key pressed ?		 							;7d21	e6 3f 
	jr z,GO_WAIT_FOR_INPUT	; no - wait for input								;7d23	28 eb 
	jp GAME_INIT			; yes - start new game								;7d25	c3 d9 7b 


;****************************************************************************************
; Delay beetween gameplays when the Game is in Demo Mode and continue
DEMO_GAMEPLAY_END:
	ld bc,0ffffh			; delay counter										;7d28	01 ff ff
DEMO_DELAY:
	dec bc					; decrement delay counter							;7d2b	0b 
	ld a,b					; check if 0										;7d2c	78 
	or c					; a = b|c											;7d2d	b1 
	jr nz,DEMO_DELAY		; wait until 0										;7d2e	20 fb 
	jp GAMEPLAY_START		; continune - start new play						;7d30	c3 56 7c

;****************************************************************************************
; Initialize Game Screen, reset Life Counter, reset current Score, initialize Sprites
INIT_GAME:
	call INIT_START_SCREEN	; draw startup state of screen						;7d33	cd 45 7d
	ld d,4					; number of player lives							;7d36	16 04
	call SET_LIFE_COUNTER 	; set and draw life counter (d+1) 					;7d38	cd a9 7d 
	ld hl,0		        	; hl - 0 current player                 			;7d3b	21 00 00
	ld (CUR_SCORE),hl		; save score initial value	        				;7d3e	22 00 78
	call INIT_SPRITES		; initialize sprites at start positions				;7d41	cd c6 7d 
	ret						;------------- End of Proc -----------				;7d44	c9 

;***************************************************************************************
; Screen initialization
; Set VDG Mode 1, clear screen and redraw all at starting positions
INIT_START_SCREEN:
; -- Set VDG Mode 1, Background Green, Reset Speaker
	ld a,BIT_SPK_MINUS | BIT_VDG_MODE ; Speaker Out=1, VDG Mode 1   			;7d45	3e 28
	ld (IOLATCH),a			; set VDG Mode 1 (bg=Green) (128x64)    			;7d47	32 00 68
	ld (IOLATCH_SHADOW),a	; store last written value	in custom shadow reg 	;7d4a	32 2b 78

; -- clear (fill green) screan (first 57 lines) 
    xor a					; value for video data         						;7d4d	af
	ld bc,(57*32)+0         ; counter = 57 lines x 32 bytes (128px)				;7d4e	01 20 07
	ld hl,VRAM				; hl - start of Video RAM               			;7d51	21 00 70
	push hl					; copy hl to de                         			;7d54	e5
	pop de					; de - destination address              			;7d55	d1
	inc de					; de - VRAM+1                           			;7d56	13
	ld (hl),a				; store 0 to first address        					;7d57	77 
	ldir		        	; fill 57 lines with 0 (green bg)       			;7d58	ed b0 

; -- fill (Red) Bottom Floor area (7 remaining lines) with 0xff value 
    cpl						; a = $ff - 4 red pixels             				;7d5a	2f
	ld (hl),a				; store ff to first address       					;7d5b	77 
	ld bc,(7*32)-1			; counter = (7 lines * 32) - 1     					;7d5c	01 df 00 
	ldir		        	; fill 7 lines with $ff (red)           			;7d5f	ed b0 

; -- draw Baloons - 3 series of 7 sprites in 3 areas of screen
    ld hl,VRAM+(1*32)+0     ; screen coord (0,1)px [$7020]						;7d61	21 20 70 
	ld ix,SPR_BALOON_YEL	; sprite (8x4) px - Baloons Yellow Group           	;7d64	dd 21 a8 7f
	call DRAW_BALOON_GROUP	; draw 7 Yellow Baloons at line 1       			;7d68	cd 5c 7e
	ld hl,VRAM+(7*32)+12    ; screen coord (48,7)px [$70ec]         			;7d6b	21 ec 70
	ld ix,SPR_BALOON_BLU 	; sprite (8x4) px -  Baloons Blue Group 	   		;7d6e	dd 21 b0 7f
	call DRAW_BALOON_GROUP	; draw 7 Blue Baloons at line 7						;7d72	cd 5c 7e
	ld hl,VRAM+(13*32)+2    ; screen coord (8,13)px [$71a2]						;7d75	21 a2 71
	ld ix,SPR_BALOON_RED	; sprite (8x4) px - Baloons Red Group      			;7d78	dd 21 b8 7f 
	call DRAW_BALOON_GROUP	; draw 7 Red Baloons at line 13 					;7d7c	cd 5c 7e 

; -- draw left stand
	ld hl,VRAM+(27*32)+0    ; screen coord (0,27)px [$7360]         			;7d7f	21 60 73 
	ld ix,SPR_STAND_LEFT 	; sprite (8x30) px Vertical Stand Left 				;7d82	dd 21 c0 7f 
	ld b,30		        	; 30 lines - sprite height              			;7d86	06 1e
	ld c,2		        	; 2 bytes (8 px) - sprite width         			;7d88	0e 02 
	call DRAW_SPRITE		; draw sprite at (0,27)px	        				;7d8a	cd 71 7f

; -- draw right stand
     ld hl,VRAM+(27*32)+30  ; screen coord (120,27)px [$737e]					;7d8d	21 7e 73 
	ld ix,SPR_STAND_RIGHT 	; sprite (8x30) px Vertical Stand Right  			;7d90	dd 21 fc 7f
	call DRAW_SPRITE		; draw sprite at (120,27)px             			;7d94	cd 71 7f 

; -- draw player unit at starting positions
	ld hl,VRAM+(49*32)+13   ; screen coord (52,49)px [$762d]					;7d97	21 2d 76
	ld (PLAYER_POS_VADR),hl	; store current player screen pos					;7d9a	22 09 78 
	ld b,8		        	; 8 lines - sprite height               			;7d9d	06 08 
	ld c,7		        	; 7 bytes (28px) - sprite width         			;7d9f	0e 07 
	ld ix,SPR_PLAYER_S0		; sprite Player (base version)                    	;7da1	dd 21 38 80 
	call DRAW_SPRITE		; draw sprite	                        			;7da5	cd 71 7f
	ret						;------ End of Proc ----------          			;7da8	c9 	. 

;********************************************************************************************
; Update and Draw Life Counter
; Draws on screen number of men according to number of lives player has.
; IN:  d - number of lives
SET_LIFE_COUNTER:
	ld a,d					; a - number of sprites to draw						;7da9	7a 
	inc a					; inc counter (1 "life" in use)						;7daa	3c 
	ld (LIFE_COUNTER),a		; store current value								;7dab	32 2a 78 
	dec a					; dec counter - (life-1) sprites to draw			;7dae	3d
	ret z					; return if no lives left to draw					;7daf	c8 
; -- more lives left - redraw Life Counter area
	ld hl,VRAM+(57*32)+0 	; screen coord (0,57)px [$7720]						;7db0	21 20 77 
DRAW_LIFE_SPRITE:
	push hl					; save hl - screen address							;7db3	e5 
	ld b,7		        	; 7 lines - sprite height               			;7db4	06 07 
	ld c,2		        	; 2 bytes (8px) - sprite width          			;7db6	0e 02 
	ld ix,SPR_LIFE_ICON		; sprite Life Icon (Man)							;7db8	dd 21 18 81
	call DRAW_SPRITE		; draw sprite 										;7dbc	cd 71 7f
	pop hl					; restore hl - screen address						;7dbf	e1 
	inc hl					; inc address (4px)									;7dc0	23 
	inc hl					; inc address - new coord for sprite				;7dc1	23 
	dec d					; dec number of sprites to draw						;7dc2	15 
	jr nz,DRAW_LIFE_SPRITE	; jump if more to draw								;7dc3	20 ee 
	ret						; ----------- End Of Proc --------					;7dc5	c9 

;****************************************************************************************
; Initialize sprites at starting positions 	
INIT_SPRITES:
; -- draw Score on screen
	call DRAW_CURRENT_SCORE	; draw current score on bottom 						;7dc6	cd 72 7e 

; -- store Baloons Red screen part to offscreen buffer
	ld hl,VRAM+(1*32)+0		; src - screen coord (0,1)px [$7020]				;7dc9	21 20 70 
	ld de,SPR_BUF_BALOONS_RED	; dst - buffer for Baloons Red Group			;7dcc	11 80 78 
	ld bc,128				; cnt - 128 bytes (4 lines) to copy					;7dcf	01 80 00 
	ldir					; store to buffer 									;7dd2	ed b0 

; -- store Baloons Yellow screen part to offscreen buffer
	ld hl,VRAM+(7*32)+0		; src - screen coord (0,7)px [$70e0]				;7dd4	21 e0 70 
	ld de,SPR_BUF_BALOONS_YEL	; dst - buffer for Baloons Yellow				;7dd7	11 00 79 
	ld bc,128				; cnt - 128 bytes (4 lines) to copy					;7dda	01 80 00 
	ldir					; store to buffer									;7ddd	ed b0 

; -- store Baloons Blue screen part to offscreen buffer
	ld hl,VRAM+(13*32)+0    ; src - screen coord (0,13)px [$71a0]				;7ddf	21 a0 71
	ld de,SPR_BUF_BALOONS_BLU	; dst - buffer for Baloons Blue					;7de2	11 80 79 
	ld bc,128				; cnt - 128 bytes (4 lines) to copy					;7de5	01 80 00  
	ldir					; store to buffer									;7de8	ed b0 

; -- store PLAYER Sprite to offscreen buffer
	ld hl,SPR_PLAYER_S0		; src - sprite PLAYER (base version)				;7dea	21 38 80 
	ld de,SPR_BUF_PLAYER	; dst - buffer for current form of sprite			;7ded	11 01 7a
	ld bc,56				; cnt - 56 bytes to copy							;7df0	01 38 00 
	ldir					; store to buffer									;7df3	ed b0 

; -- store JUMPER (Waiting) to offscreen buffer	(1px offset)
	ld hl,SPR_JUMPER_S1		; src - sprite JUMPER (1px shifted version)			;7df5	21 3b 81 
	ld de,SPR_BUF_JUMPER_W	; dst - buffer for current form of sprite			;7df8	11 39 7a 
	ld bc,21				; cnt - 21 bytes to copy							;7dfb	01 15 00 
	ldir					; store to buffer									;7dfe	ed b0 

; -- store JUMPER sprite to offscreen buffer	
	ld hl,SPR_JUMPER_S0		; src - sprite JUMPER (base version)				;7e00	21 26 81
	ld de,SPR_BUF_JUMPER	; dst - buffer for current form of sprite			;7e03	11 4e 7a 
	ld bc,21				; cnt - 21 bytes to copy							;7e06	01 15 00  
	ldir					; store to buffer									;7e09	ed b0  

; -- reset JUMPER Waiting position and draw it on screen
	ld hl,VRAM+(48*32)+17	; screen coord (17x48) px [$7611]					;7e0b	21 11 76 
	ld (JUMPER_W_VADR),hl	; store current VRAM address						;7e0e	22 0b 78  
	ld (JUMPER_W_CLR_VADR),hl; store address used for clear routine 			;7e11	22 24 78 
	ld ix,SPR_JUMPER_S1		; sprite JUMPER (12x7)px (1px shifted version)		;7e14	dd 21 3b 81 
	ld b,7					; 7 lines - sprite height							;7e18	06 07 
	ld c,3					; 3 bytes - sprite width (12px)						;7e1a	0e 03 
	call DRAW_SPRITE_T		; draw sprite with transparency						;7e1c	cd 8c 7f 

; -- reset Baloons Group's variables : BALOONS_RED_DIR, BALOONS_YEL_DIR, BALOONS_BLU_DIR
	xor a					; 0 value - reset									;7e1f	af 
	ld hl,BALOONS_RED_DIR	; address of first variable to clear				;7e20	21 02 78 
	ld b,4					; 4 bytes to clear									;7e23	06 04 
RESET_BALOONS_VARS:
	ld (hl),a				; store 0 value										;7e25	77 
	inc hl					; next variable address								;7e26	23 
	djnz RESET_BALOONS_VARS	; repeat for 4 bytes								;7e27	10 fc 

; -- reset PLAYER movement and position variables	
	ld (BAR_FLIP_FLAG),a	; 0 - player unit bar not flipped (left-up)			;7e29	32 1b 78
	ld hl,$3400				; player pos X: h=52 pixels, l=00 fraction 			;7e2c	21 00 34
	ld (PLAYER_X_FRAC),hl	; store initial player position						;7e2f	22 0f 78 
	ld a,69					; Jumper Waiting pos X in pixels					;7e32	3e 45 
	ld (JUMPER_W_X_INT),a	; store initial value								;7e34	32 11 78 
	ld (JUMPER_W_CLR_X_INT),a	; store pos X for clear routines				;7e37	32 26 78 
	ld a,15					; Jumper Waiting pos Y (bottom up)					;7e3a	3e 0f  
	ld (JUMPER_W_Y_INT),a	; store initial value								;7e3c	32 13 78 
	ld hl,$00ff				; player unit X velocity ($00ff) almost pixel		;7e3f	21 ff 00  
	ld (PLAYER_X_VEL),hl	; store initial value								;7e42	22 1c 78 

;-- clear reset variable (not used)
	xor a					; 0 - reset value									;7e45	af 
	ld (RESET_VAR),a		; store to variable (not used)						;7e46	32 00 7a

; -- reset Baloons Left Counter - number of Baloons left to collect
	ld a,3*7				; 7 Baloons in each of 3 groups/rows = 21 Baloons	;7e49	3e 15 
	ld (BALOONS_LEFT),a		; store as number Baloons to collect				;7e4b	32 19 78 

; --- set custom interrupt handler
	ld a,$c3				; JP opcode byte									;7e4e	3e c3 
	ld (USER_INT_PROC),a	; set INT jump vector								;7e50	32 7d 78 
	ld hl,INT_GAME_MAIN		; hl - interrupt proc (Game Main variant)			;7e53	21 ae 82 
	ld (USER_INT_PROC+1),hl	; set system redirection							;7e56	22 7e 78 
	im 1					; reset Interrupt Mode to 1							;7e59	ed 56 
	ret						; ------------- End of Proc	-------------			;7e5b	c9 


;****************************************************************************
; Copy Sprite to Screen 7 times with 24px gaps
; Every sprite dimension forced to 8x4px (2x4 bytes)
; IN:   ix - sprite data - fixed dimensions 8x4px
;       hl - destination VRAM address
DRAW_BALOON_GROUP:
	ld d,7              	; d - 7 - sprite to draw counter            		 ;7e5c	16 07 
DRAW_NEXT_BALOON:
	push hl					; save hl - left pixel screen address   			;7e5e	e5 
	ld b,4                  ; b - 4 lines - sprite height           			;7e5f	06 04 
	ld c,2		        	; c - 2 bytes (8px) - sprite width      			;7e61	0e 02 
	push ix		        	; save ix - sprite source data address     			;7e63	dd e5 
	call DRAW_SPRITE		; draw sprite	                        			;7e65	cd 71 7f 
	pop ix		        	; restore ix - sprite source data address  			;7e68	dd e1 
	pop hl					; restore hl - destination VRAM address 			;7e6a	e1 
	inc hl					; hl++ - next VRAM address (8px right)  			;7e6b	23 
	inc hl					; hl++ - next VRAM address (8px right)  			;7e6c	23 
	inc hl					; VRAM + 3 - VRAM address (24px offset) 			;7e6d	23 
	dec d					; decrement sprites' counter            			;7e6e	15 
	jr nz,DRAW_NEXT_BALOON	; jump if more Aliens to draw           			;7e6f	20 ed 
	ret						; ------------ End Of Proc  ---------------			;7e71	c9 

;*************************************************************************************
; Convert score from numeric value (BCD format) into decimal digits and then 
; every digit is converted to sprite and draw at the bottom of screen.
; Score is stored in BCD format
DRAW_CURRENT_SCORE:
; -- draw 4th digit on screen at (72,58)px
	ld a,(CUR_SCORE)		; a - 4th and 3rd digits of Score					;7e72	3a 00 78 
	push af					; save a                                			;7e75	f5 
	and $0f		        	; a - 4th digit (BCD)                   			;7e76	e6 0f 
	call DIGIT_TO_SPRITE	; convert digit to sprite and set b,c (sprite dim)	;7e78	cd f1 7e 
	ld hl,VRAM+(58*32)+18   ; screen coord (72,58)px [$7752]					;7e7b	21 52 77 
	ld ix,SPR_BUF_DIGIT		; converted sprite of 4th digit                     ;7e7e	dd 21 30 78 
	call DRAW_SPRITE		; draw 4th digit	          	       				;7e82	cd 71 7f
; -- draw 3rd digit on screen at (64,58)px
	pop af					; restore a - 3rd & 4th digit           			;7e85	f1
	srl a		        	; right shift a 4 times                 			;7e86	cb 3f 
	srl a		                                                				;7e88	cb 3f 
	srl a		                                                				;7e8a	cb 3f 
	srl a		        	; a - 3rd digit on 4 lower bits  	     			;7e8c	cb 3f 
	call DIGIT_TO_SPRITE	; convert digit to sprite and set b,c (sprite dim)	;7e8e	cd f1 7e 
	call SHIFT_SPRITE_1PX	; shift sprite 1 px right							;7e91	cd d7 7e 
	ld hl,VRAM+(58*32)+16   ; screen coord (64,58)px [$7750]					;7e94	21 50 77
	ld ix,SPR_BUF_DIGIT		; converted sprite 									;7e97	dd 21 30 78 
	call DRAW_SPRITE		; draw 3rd digit									;7e9b	cd 71 7f 
; -- draw 2nd digit on screen at (56,58)px
	ld a,(CUR_SCORE+1)		; a - 1st & 2nd digit 								;7e9e	3a 01 78 
	push af					; save a											;7ea1	f5 
	and $0f					; a - 2nd digit (BCD)								;7ea2	e6 0f 
	call DIGIT_TO_SPRITE	; convert digit to sprite and set b,c				;7ea4	cd f1 7e 
	call SHIFT_SPRITE_1PX	; shift sprite 1 px right							;7ea7	cd d7 7e  
	call SHIFT_SPRITE_1PX	; shift sprite 1 px right (2px total)				;7eaa	cd d7 7e 
	ld hl,VRAM+(58*32)+14   ; screen coord (56,58)px [$774e]					;7ead	21 4e 77
	ld ix,SPR_BUF_DIGIT		; converted sprite									;7eb0	dd 21 30 78 
	call DRAW_SPRITE		; draw 2nd digit									;7eb4	cd 71 7f 
; -- draw 1st digit on screen at (56,58)px
	pop af					; restore a - 1st & 2nd digit						;7eb7	f1 
	srl a					; right shift a 4 times 							;7eb8	cb 3f 
	srl a																		;7eba	cb 3f 
	srl a																		;7ebc	cb 3f 
	srl a					; a has 1rd digit on 4 lower bits					;7ebe	cb 3f 
	call DIGIT_TO_SPRITE	; convert digit to sprite and set b,c				;7ec0	cd f1 7e  
	call SHIFT_SPRITE_1PX	; shift sprite 1 px right							;7ec3	cd d7 7e  
	call SHIFT_SPRITE_1PX	; shift sprite 1 px right once more					;7ec6	cd d7 7e 
	call SHIFT_SPRITE_1PX	; shift sprite 1 px right (3px total)				;7ec9	cd d7 7e 
	ld hl,VRAM+(58*32)+12   ; screen coord (48,58)px [$774c]					;7ecc	21 4c 77 
	ld ix,SPR_BUF_DIGIT	; converted sprite										;7ecf	dd 21 30 78 
	call DRAW_SPRITE		; draw 1st digit									;7ed3	cd 71 7f 
	ret						; --------- End of Proc	-------------------			;7ed6	c9 

;**************************************************************************************
; Shift right sprite bits by 2 bits (1px) used to correct screen position of score digits
SHIFT_SPRITE_1PX:
	ld hl,SPR_BUF_DIGIT		; address of digit sprite buffer					;7ed7	21 30 78 
	ld b,5					; 5 lines - sprite height							;7eda	06 05 
S_SHIFT_LINE:
	ld c,2					; shift by 2 bits in byte (1px)						;7edc	0e 02 
S_SHIFT_WORD:
	scf						; set CY flag (to have 7 bit = 1 [Red])				;7ede	37 
	rr (hl)					; rotate right byte in buffer						;7edf	cb 1e 
	inc hl					; next byte in this screen line						;7ee1	23 
	rr (hl)					; rotate right (with bit from prev)					;7ee2	cb 1e 
	dec hl					; back to previous byte								;7ee4	2b 
	dec c					; check if already shfted by 2 bits					;7ee5	0d 
	jr nz,S_SHIFT_WORD		; no - repeat one more time							;7ee6	20 f6 
	inc hl					; inc pointer in buffer	to next line				;7ee8	23 
	inc hl					; ... by 2 bytes (sprite width)						;7ee9	23 
	djnz S_SHIFT_LINE		; repeat for all 5 lines							;7eea	10 f0 
; -- restore b, c to have sprite dimensions
	ld b,5					; 5 lines - sprite height							;7eec	06 05 
	ld c,2					; 2 bytes - sprite width (8px)						;7eee	0e 02 
	ret						; ---------- End of Proc --------					;7ef0	c9 

;*******************************************************************************
; Convert one digit (0..9) to sprite 
; IN:  a - one digit of score to convert to sprite
; OUT: b - sprite height (lines)
;      c - sprite width (in bytes)
;      [SPR_BUF_DIGIT] - sprite to draw in buffer
DIGIT_TO_SPRITE:
	sla a		        	; a = IN * 2                            			;7ef1	cb 27 
	ld b,a					; b = IN * 2                            			;7ef3	47 
	sla a		        	; a = IN * 4                            			;7ef4	cb 27 
	sla a		        	; a = IN * 8                            			;7ef6	cb 27 
	add a,b					; a = IN * 10                           			;7ef8	80
	ld c,a					; c = IN * 10                           			;7ef9	4f 
	ld b,0		        	; bc = IN * 10                          			;7efa	06 00 
	ld hl,TAB_DIGIT_SPRITES	; hl - start of sprites table   					;7efc	21 0d 7f 
	add hl,bc				; hl - address of sprite for this digit				;7eff	09 
	ld bc,10				; every sprite has 10 bytes data        			;7f00	01 0a 00 
	ld de,SPR_BUF_DIGIT  ; buffer for sprite	        						;7f03	11 30 78
	ldir		        	; copy 10 bytes of sprite to buffer     			;7f06	ed b0 
	ld b,5		        	; 5 lines - sprite height               			;7f08	06 05 
	ld c,2  				; 2 bytes (8px) - sprite width          			;7f0a	0e 02 
	ret						; ------- End of Proc ------------------------		;7f0c	c9

;*******************************************************************************************
; Sprites Table for Digits
; Containts 10 sprites form every digit. Every sprite has dimension (8x5)px (2x5)bytes
TAB_DIGIT_SPRITES:
; -- 0 --	
    defb    $55,$7f         ;7f0d	55 7f
	defb    $7f,$7f			;7f0f	7f 7f 
	defb    $7f,$7f         ;7f11	7f 7f  
	defb    $7f,$7f			;7f13	7f 7f 
	defb    $55,$7f			;7f15	55 7f 
; -- 1 --	
    defb    $ff,$7f			;7f17	ff 7f 
	defb    $ff,$7f			;7f19	ff 7f
	defb    $ff,$7f			;7f1b	ff 7f
	defb    $ff,$7f         ;7f1d	ff 7f
	defb    $ff,$7f         ;7f1f	ff 7f
; -- 2 --        
	defb    $55,$7f			;7f21	55 7f
	defb    $ff,$7f         ;7f23	ff 7f
	defb    $55,$7f			;7f25	55 7f
	defb    $7f,$ff			;7f27	7f ff 
	defb    $55,$7f			;7f29	55 7f 
; -- 3 --        
	defb    $55,$7f			;7f2b	55 7f 
	defb    $ff,$7f     	;7f2d	ff 7f 
	defb    $55,$7f			;7f2f	55 7f  
	defb    $ff,$7f			;7f31	ff 7f  
	defb    $55,$7f			;7f33	55 7f 
; -- 4 --        
	defb    $7f,$7f         ;7f35	7f 7f  
	defb    $7f,$7f			;7f37	7f 7f 
	defb    $55,$7f         ;7f39	55 7f
	defb    $ff,$7f         ;7f3b	ff 7f
	defb    $ff,$7f         ;7f3d	ff 7f 
; -- 5 --        
	defb    $55,$7f         ;7f3f	55 7f 
	defb    $7f,$ff         ;7f41	7f ff  
	defb    $55,$7f 		;7f43	55 7f
	defb    $ff,$7f         ;7f45	ff 7f
	defb    $55,$7f         ;7f47	55 7f
; -- 6 --
	defb    $55,$7f         ;7f49	55 7f 
	defb    $7f,$ff         ;7f4b	7f ff 
	defb    $55,$7f         ;7f4d	55 7f 
	defb    $7f,$7f         ;7f4f	7f 7f 
	defb    $55,$7f         ;7f51	55 7f 
; -- 7 --        
	defb    $55,$7f         ;7f53	55 7f 
	defb    $ff,$7f         ;7f55	ff 7f 
	defb    $ff,$7f         ;7f57	ff 7f 
	defb    $ff,$7f 		;7f59	ff 7f 
	defb    $ff,$7f 		;7f5b	ff 7f
; -- 8 --
	defb    $55,$7f         ;7f5d	55 7f 
	defb    $7f,$7f 		;7f5f	7f 7f
	defb    $55,$7f 		;7f61	55 7f 
	defb    $7f,$7f			;7f63	7f 7f 
	defb    $55,$7f         ;7f65	55 7f 
; -- 9 --
	defb    $55,$7f         ;7f67	aa 7f 
	defb    $7f,$7f			;7f69	7f 7f 
	defb    $55,$7f 		;7f6b	aa 7f 
	defb    $ff,$7f			;7f6d	ff 7f 
	defb    $ff,$7f			;7f6f	ff 7f

;*************************************************************************
; Draw sprite to screen 
; IN: ix - source data address
;     hl - destination VRAM address
;     c - sprite width (in bytes)  
;     b - sprite height (in lines)  
DRAW_SPRITE:
	push bc				; save bc                       						;7f71	c5
	push de				; save de                       						;7f72	d5 
	ld e,c				; e - sprite width (in bytes)      						;7f73	59
DS_NEXT_LINE:
	ld c,e				; c - sprite width (in bytes)      						;7f74	4b 
	push hl				; save hl (VRAM of left edge)  							;7f75	e5
DS_NEXT_BYTE:
	ld a,(ix+000h)		; a - sprite byte data          						;7f76	dd 7e 00 
	ld (hl),a			; store to VRAM	                						;7f79	77 
	inc ix		        ; next byte of sprite data         						;7f7a	dd 23 
	inc hl				; next VRAM address in this line						;7f7c	23 
	dec c				; dec bytes counter             						;7f7d	0d
	jr nz,DS_NEXT_BYTE	; jump if more data in this line						;7f7e	20 f6 
	pop hl				; hl - VRAM of left edge		  						;7f80	e1 
	push bc				; temp save bc                  						;7f81	c5 
	ld bc,32            ; bc - 32 bytes per screen line							;7f82	01 20 00 
	add hl,bc			; hl - next line address								;7f85	09
	pop bc				; restore bc -> b - line counter 						;7f86	c1 
	djnz DS_NEXT_LINE	; jump if more lines to copy    						;7f87	10 eb 
	pop de				; restore de                    						;7f89	d1
	pop bc				; restore bc                   							;7f8a	c1
	ret					;-------- End of Proc -----------------------			;7f8b	c9

;*************************************************************************
; Draw sprite to screen with transparency
; IN: ix - source data address
;     hl - destination VRAM address
;     c - sprite width (in bytes)  
;     b - sprite height (in lines)  

DRAW_SPRITE_T:
	push bc				; save bc   											;7f8c	c5 
	push de				; save de 												;7f8d	d5 
	ld e,c				; e - sprite width  (in bytes)							;7f8e	59 
DST_NEXT_LINE:
	ld c,e				; c - sprite width (in bytes)							;7f8f	4b  
	push hl				; save hl (VRAM of left edge) 							;7f90	e5  
DST_NEXT_BYTE:
	ld a,(ix+000h)		; a - sprite byte data 									;7f91	dd 7e 00 
	or (hl)				; aply current screen data								;7f94	b6 
	ld (hl),a			; and save with "or-ed" sprite							;7f95	77 
	inc ix				; next byte of sprite data 								;7f96	dd 23  
	inc hl				; next VRAM address in this line						;7f98	23  
	dec c				; dec bytes counter 									;7f99	0d  
	jr nz,DST_NEXT_BYTE	; jump if more data in this line						;7f9a	20 f5 
	pop hl				; hl - VRAM of left edge								;7f9c	e1 
	push bc				; temp save bc  										;7f9d	c5  
	ld bc,32			; bc - 32 bytes per screen line							;7f9e	01 20 00  
	add hl,bc			; hl - next line address								;7fa1	09  
	pop bc				; restore bc -> b - line counter 						;7fa2	c1  
	djnz DST_NEXT_LINE	; jump if more lines to draw  							;7fa3	10 ea 
	pop de				; restore de  											;7fa5	d1  
	pop bc				; restore bc 											;7fa6	c1  
	ret					;-------- End of Proc ----------------------			;7fa7	c9 

;***********************************************
; Sprite Ballon Yellow (8x4)px (2x4) bytes
SPR_BALOON_YEL:
    defb    $05,$50	        ;7fa8	05 50 			
    defb    $15,$54         ;7faa	15 54           
    defb    $15,$54 		;7fac	15 54           
	defb    $05,$50         ;7fae	05 50           
        
;***********************************************
; Sprite Baloon Blue (8x4)px (2x4) bytes
SPR_BALOON_BLU:
    defb 	$0a,$a0     	;7fb0   0a a0
    defb 	$2a,$a8    		;7fb2	2a a8
	defb 	$2a,$a8    		;7fb4	2a a8 
	defb 	$0a,$a0			;7fb6	0a a0 

;***********************************************
; Sprite Baloon Red (8x4)px (2x4) bytes
SPR_BALOON_RED:        
    defb    $0f,$f0         ;7fb8   0f f0
	defb    $3f,$fc 		;7fba	3f fc
	defb    $3f,$fc         ;7fbc	3f fc
	defb    $0f,$f0			;7fbe	0f f0

;**********************************************
; Sprite Stand Left (8x30)px (2x30) bytes
SPR_STAND_LEFT:
    defb    $aa,$aa         ;7fc0   aa aa
    defb    $aa,$aa         ;7fc2   aa aa
    defb    $80,$20         ;7fc4   80 20
    defb    $80,$20         ;7fc6   80 20
    defb    $aa,$a0         ;7fc8   aa a0
    defb    $80,$20         ;7fca   80 20
    defb    $80,$20         ;7fcc   80 20
    defb    $aa,$a0         ;7fce   aa a0
    defb    $80,$20         ;7fd0   80 20
    defb    $80,$20         ;7fd2   80 20
    defb    $aa,$a0         ;7fd4   aa a0
    defb    $80,$20         ;7fd6   80 20
    defb    $80,$20         ;7fd8   80 20
    defb    $aa,$a0         ;7fda   aa a0
    defb    $80,$20         ;7fdc   80 20
    defb    $80,$20         ;7fde   80 20
    defb    $aa,$a0         ;7fe0   aa a0
    defb    $80,$20         ;7fe2   80 20
    defb    $80,$20         ;7fe4   80 20
    defb    $aa,$a0         ;7fe6   aa a0
    defb    $80,$20         ;7fe8   80 20
    defb    $80,$20         ;7fea   80 20
    defb    $aa,$a0         ;7fec   aa a0
    defb    $80,$20         ;7fee   80 20
    defb    $80,$20         ;7ff0   80 20
    defb    $aa,$a0         ;7ff2   aa a0
    defb    $80,$20         ;7ff4   80 20
    defb    $80,$20         ;7ff6   80 20
    defb    $aa,$a0         ;7ff8   aa a0
    defb    $80,$20         ;7ffa   80 20

;**********************************************
; Sprite Stand Right (8x30)px (2x30) bytes
SPR_STAND_RIGHT:
    defb    $aa,$aa         ;7ffc   aa aa
    defb    $aa,$aa         ;7ffe   aa aa
	defb    $08,$02			;8000	08 02 
	defb    $08,$02			;8002	08 02
	defb    $0a,$aa			;8004	0a aa
	defb    $08,$02			;8006	08 02
	defb    $08,$02			;8008	08 02
	defb    $0a,$aa			;800a	0a aa
	defb    $08,$02			;800c	08 02
	defb    $08,$02			;800e	08 02
	defb    $0a,$aa			;8010	0a aa
	defb    $08,$02			;8012	08 02
	defb    $08,$02			;8014	08 02
	defb    $0a,$aa			;8016	0a aa
	defb    $08,$02			;8018	08 02
	defb    $08,$02			;801a	08 02
	defb    $0a,$aa			;801c	0a aa
	defb    $08,$02			;801e	08 02
	defb    $08,$02			;8020	08 02
	defb    $0a,$aa			;8022	0a aa
	defb    $08,$02			;8024	08 02
	defb    $08,$02			;8026	08 02
	defb    $0a,$aa			;8028	0a aa
	defb    $08,$02			;802a	08 02
	defb    $08,$02			;802c	08 02
	defb    $0a,$aa			;802e	0a aa
	defb    $08,$02			;8030	08 02
	defb    $08,$02			;8032	08 02
	defb    $0a,$aa			;8034	0a aa
	defb    $08,$02			;8036	08 02

;**********************************************************
; Sprite Player Unit 28x8px (7x8)bytes - base variant (not shifted)
SPR_PLAYER_S0:
	defb    $a8,$00,$00,$00,$00,$00,$00     ;8038	a8 00 00 00 00 00 00
    defb    $02,$a0,$00,$00,$00,$00,$00     ;803f	02 a0 00 00 00 00 00 
	defb    $00,$0a,$80,$00,$00,$00,$00		;8046	00 0a 80 00 00 00 00 
	defb    $00,$00,$2a,$00,$00,$00,$00     ;804d	00 00 2a 00 00 00 00 
	defb    $00,$00,$00,$a8,$00,$00,$00		;8054	00 00 00 a8 00 00 00
    defb    $00,$00,$0a,$a2,$a0,$00,$00     ;805b	00 00 0a a2 a0 00 00 
	defb    $00,$00,$aa,$aa,$0a,$80,$00     ;8062	00 00 aa aa 0a 80 00 
    defb    $00,$0a,$aa,$aa,$a0,$2a,$00     ;8069	00 0a aa aa a0 2a 00 

;**********************************************************
; Sprite Player Unit 28x8px (7x8)bytes - variant 1 - shifted 1px right
SPR_PLAYER_S1
	defb 	$2a,$00,$00,$00,$00,$00,$00		;8070	2a 00 00 00 00 00 00
	defb	$00,$a8,$00,$00,$00,$00,$00		;8077	00 a8 00 00 00 00 00
	defb	$00,$02,$a0,$00,$00,$00,$00		;807e	00 02 a0 00 00 00 00
	defb	$00,$00,$0a,$80,$00,$00,$00		;8085	00 00 0a 80 00 00 00 
	defb	$00,$00,$00,$2a,$00,$00,$00		;808c	00 00 00 2a 00 00 00 
	defb	$00,$00,$02,$a8,$a8,$00,$00		;8093	00 00 02 a8 a8 00 00 
	defb	$00,$00,$2a,$aa,$82,$a0,$00		;809a	00 00 2a aa 82 a0 00
	defb	$00,$02,$aa,$aa,$a8,$0a,$80		;80a1	00 02 aa aa a8 0a 80 

;**********************************************************
; Sprite Player Unit 28x8px (7x8)bytes - variant 2 - shifted 2px right
SPR_PLAYER_S2	
	defb	$0a,$80,$00,$00,$00,$00,$00		;80a8	0a 80 00 00 00 00 00 
	defb 	$00,$2a,$00,$00,$00,$00,$00		;80af	00 2a 00 00 00 00 00 
	defb	$00,$00,$a8,$00,$00,$00,$00		;80b6	00 00 a8 00 00 00 00 
	defb	$00,$00,$02,$a0,$00,$00,$00		;80bd	00 00 02 a0 00 00 00
	defb	$00,$00,$00,$0a,$80,$00,$00		;80c4	00 00 00 0a 80 00 00 
	defb	$00,$00,$00,$aa,$2a,$00,$00		;80cb	00 00 00 aa 2a 00 00 
	defb 	$00,$00,$0a,$aa,$a0,$a8,$00		;80d2	00 00 0a aa a0 a8 00 
	defb	$00,$00,$aa,$aa,$aa,$02,$a0		;80d9	00 00 aa aa aa 02 a0
	
;**********************************************************
; Sprite Player Unit 28x8px (7x8)bytes - variant 3 - shifted 3px right
SPR_PLAYER_S3	
	defb	$02,$a0,$00,$00,$00,$00,$00		;80e0	02 a0 00 00 00 00 00 
	defb	$00,$0a,$80,$00,$00,$00,$00		;80e7	00 0a 80 00 00 00 00
	defb	$00,$00,$2a,$00,$00,$00,$00		;80ee	00 00 2a 00 00 00 00 
	defb	$00,$00,$00,$a8,$00,$00,$00		;80f5	00 00 00 a8 00 00 00 
	defb	$00,$00,$00,$02,$a0,$00,$00		;80fc	00 00 00 02 a0 00 00 
	defb	$00,$00,$00,$2a,$8a,$80,$00		;8103	00 00 00 2a 8a 80 00
	defb	$00,$00,$02,$aa,$a8,$2a,$00		;810a	00 00 02 aa a8 2a 00 
	defb	$00,$00,$2a,$aa,$aa,$80,$a8		;8111	00 00 2a aa aa 80 a8 

;***********************************************************
; Sprite Life Icon (Man) (8x7) px (2x7 bytes)
; Used to draw Life Counter 
SPR_LIFE_ICON:
	defb    $f5,$7f         ;8118	5f 7f 
    defb    $f5,$7f         ;811a	f5 7f
	defb    $7d,$f7			;811c	7d f7 
	defb    $d5,$5f         ;811e	d5 5f 
	defb    $f5,$7f			;8120	f5 7f
	defb    $f7,$7f 		;8122	f7 7f 
	defb    $d7,$5f         ;8124	d7 5f

;***********************************************************
; Sprite JUMPER (12x7) px (3x7) bytes - base variant (not shifted) 
SPR_JUMPER_S0:
	defb	$05,$40,$00		;8126	05 40 00 
	defb 	$05,$40,$00		;8129	05 40 00  
	defb	$41,$04,$00		;812c	41 04 00 
	defb	$15,$50,$00		;812f	15 50 00 
	defb	$05,$40,$00		;8132	05 40 00
	defb	$04,$40,$00		;8135	04 40 00 
	defb	$14,$50,$00		;8138	14 50 00 

;*******************************************************************
; Sprite Jumping Man 1 (12x7) px (3x7) bytes - variant shifted 1px right

SPR_JUMPER_S1:
	defb	$01,$50,$00		;813b	01 50 00
	defb	$01,$50,$00		;813e	01 50 00 
	defb 	$10,$41,$00		;8141	10 41 00
	defb	$05,$54,$00		;8144	05 54 00 
	defb	$01,$50,$00		;8147	01 50 00
	defb	$01,$10,$00		;814a	01 10 00 
	defb	$05,$14,$00		;814d	05 14 00

;*******************************************************************
; Sprite Jumping Man (12x7) px (3x7) bytes - variant shifted 2px right
SPR_JUMPER_S2
	defb	$00,$54,$00		;8150	00 54 00 
	defb	$00,$54,$00		;8153	00 54 00
	defb	$04,$10,$40		;8156	04 10 40
	defb	$01,$55,$00		;8159	01 55 00 
	defb	$00,$54,$00		;815c	00 54 00 
	defb	$00,$44,$00		;815f	00 44 00
	defb	$01,$45,$00		;8162	01 45 00 

;*******************************************************************
; Sprite Jumping Man (12x7) px (3x7) bytes - variant shifted 3px right
SPR_JUMPER_S3
	defb	$00,$15,$00		;8165	00 15 00
	defb	$00,$15,$00		;8168	00 15 00 
	defb	$01,$04,$10		;816b	01 04 10
	defb	$00,$55,$40		;816e	00 55 40
	defb	$00,$15,$00		;8171	00 15 00 
	defb	$00,$11,$00		;8174	00 11 00 
	defb	$00,$51,$40		;8177	00 51 40

;***********************************************************
; Sprite Jumping Man Mask (12x7) px (3x7) bytes - base variant
SPR_JUMPER_S0_MASK:
	defb	$f0,$3f,$ff		;817a	f0 3f ff
	defb	$f0,$3f,$ff		;817d	f0 3f ff
	defb	$3c,$f3,$ff		;8180	3c f3 ff
	defb	$c0,$0f,$ff		;8183	c0 0f ff 
	defb	$f0,$3f,$ff		;8186	f0 3f ff 
	defb	$f3,$3f,$ff		;8189	f3 3f ff 
	defb	$c3,$0f,$ff		;818c	c3 0f ff 

;***********************************************************
; Sprite Jumping Man Mask (12x7) px (3x7) bytes - variant shifted 1px right
SPR_JUMPER_S1_MASK:
	defb	$fc,$0f,$ff		;818f	fc 0f ff 
	defb	$fc,$0f,$ff		;8192	fc 0f ff
	defb	$cf,$3c,$ff		;8195	cf 3c ff 
	defb	$f0,$03,$ff		;8198	f0 03 ff 
	defb	$fc,$0f,$ff		;819b	fc 0f ff
	defb	$fc,$cf,$ff		;819e	fc cf ff 
	defb	$f0,$c3,$ff		;81a1	f0 c3 ff 

;***********************************************************
; Sprite Jumping Man Mask (12x7) px (3x7) bytes - variant shifted 2px right
SPR_JUMPER_S2_MASK:
	defb	$ff,$03,$ff		;81a4	ff 03 ff 
	defb	$ff,$03,$ff		;81a7	ff 03 ff
	defb	$f3,$cf,$3f		;81aa	f3 cf 3f
	defb	$fc,$00,$ff		;81ad	fc 00 ff 
	defb	$ff,$03,$ff		;81b0	ff 03 ff 
	defb	$ff,$33,$ff		;81b3	ff 33 ff
	defb	$fc,$30,$ff		;81b6	fc 30 ff 

;***********************************************************
; Sprite Jumping Man Mask (12x7) px (3x7) bytes - variant shifted 3px right
SPR_JUMPER_S3_MASK:
	defb	$ff,$c0,$ff		;81b9	ff c0 ff
	defb	$ff,$c0,$ff		;81bc	ff c0 ff 
	defb	$fc,$f3,$cf		;81bf	fc f3 cf 
	defb	$ff,$00,$3f		;81c2	ff 00 3f 
	defb	$ff,$c0,$ff		;81c5	ff c0 ff 
	defb	$ff,$cc,$ff		;81c8	ff cc ff
	defb	$ff,$0c,$3f		;81cb	ff 0c 3f


;**********************************************************
; Player Unit Sprite 28x8px (7x8)bytes - flipped Bar - base variant
SPR_PLAYER_FB_S0:
	defb	$00,$00,$00,$00,$00,$2a,$00		;81ce	00 00 00 00 00 2a 00
	defb	$00,$00,$00,$00,$0a,$80,$00		;81d5	00 00 00 00 0a 80 00 
	defb	$00,$00,$00,$02,$a0,$00,$00		;81dc	00 00 00 02 a0 00 00 
	defb	$00,$00,$00,$a8,$00,$00,$00		;81e3	00 00 00 a8 00 00 00 
	defb	$00,$00,$2a,$00,$00,$00,$00		;81ea	00 00 2a 00 00 00 00 
	defb	$00,$0a,$8a,$a0,$00,$00,$00		;81f1	00 0a 8a a0 00 00 00 
	defb	$02,$a0,$aa,$aa,$00,$00,$00		;81f8	02 a0 aa aa 00 00 00
	defb	$a8,$0a,$aa,$aa,$a0,$00,$00		;81ff	a8 0a aa aa a0 00 00 

;**********************************************************
; Player Unit Sprite 28x8px (7x8)bytes - flipped Bar - variant 1 - shifted 1px right
SPR_PLAYER_FB_S1:
	defb	$00,$00,$00,$00,$00,$0a,$80		;8206	00 00 00 00 00 0a 80 
	defb	$00,$00,$00,$00,$02,$a0,$00		;820d	00 00 00 00 02 a0 00 
	defb	$00,$00,$00,$00,$a8,$00,$00		;8214	00 00 00 00 a8 00 00 
	defb	$00,$00,$00,$2a,$00,$00,$00		;821b	00 00 00 2a 00 00 00
	defb	$00,$00,$0a,$80,$00,$00,$00		;8222	00 00 0a 80 00 00 00 
	defb	$00,$02,$a2,$a8,$00,$00,$00		;8229	00 02 a2 a8 00 00 00 
	defb	$00,$a8,$2a,$aa,$80,$00,$00		;8230	00 a8 2a aa 80 00 00
	defb	$2a,$02,$aa,$aa,$a8,$00,$00		;8237	2a 02 aa aa a8 00 00 

;**********************************************************
; Player Unit Sprite 28x8px (7x8)bytes - flipped Bar - variant 2 - shifted 2px right
SPR_PLAYER_FB_S2:
	defb	$00,$00,$00,$00,$00,$02,$a0		;823e	00 00 00 00 00 02 a0
	defb	$00,$00,$00,$00,$00,$a8,$00		;8245	00 00 00 00 00 a8 00 
	defb	$00,$00,$00,$00,$2a,$00,$00		;824c	00 00 00 00 2a 00 00
	defb	$00,$00,$00,$0a,$80,$00,$00		;8253	00 00 00 0a 80 00 00 
	defb	$00,$00,$02,$a0,$00,$00,$00		;825a	00 00 02 a0 00 00 00 
	defb	$00,$00,$a8,$aa,$00,$00,$00		;8261	00 00 a8 aa 00 00 00 
	defb	$00,$2a,$0a,$aa,$a0,$00,$00		;8268	00 2a 0a aa a0 00 00 
	defb	$0a,$80,$aa,$aa,$aa,$00,$00		;826f	0a 80 aa aa aa 00 00 

;**********************************************************
; Player Unit Sprite 28x8px (7x8)bytes - flipped Bar - variant 3 - shifted 3px right
SPR_PLAYER_FB_S3:
	defb	$00,$00,$00,$00,$00,$00,$a8		;8276	00 00 00 00 00 00 a8 
	defb	$00,$00,$00,$00,$00,$2a,$00		;827d	00 00 00 00 00 2a 00 
	defb	$00,$00,$00,$00,$0a,$80,$00		;8286	00 00 00 00 0a 80 00 
	defb	$00,$00,$00,$02,$a0,$00,$00		;828b	00 00 00 02 a0 00 00 
	defb 	$00,$00,$00,$a8,$00,$00,$00		;8292	00 00 00 a8 00 00 00
	defb	$00,$00,$2a,$2a,$80,$00,$00		;8299	00 00 2a 2a 80 00 00 
	defb 	$00,$0a,$82,$aa,$a8,$00,$00		;82a0	00 0a 82 aa a8 00 00 
	defb	$02,$a0,$2a,$aa,$aa,$80,$00		;82a7	02 a0 2a aa aa 80 00 

;****************************************************************************
;
; Game interrupt proc - Game Main variant
;
; In Demo Mode just checks if any key/joystick event occured. If so switch to Running and exit. 
; In Running mode or in Demo with no input detected, executes Frame Update routines 
;
;*****************************************************************************
INT_GAME_MAIN:
	push ix					; save ix 											;82ae	dd e5 
	ld a,(GAME_MODE)		; a - Game Mode										;82b0	3a 2f 78 
	or a					; check if Running									;82b3	b7 
	jr z,GIH_FRAME_UPDATE	; yes - continue Frame Update						;82b4	28 2d 

; -- Game in Demo Mode - check key/joystick to stop demo and start Game
	ld a,(INPUT_FLAG)		; input mode Keyboard/Joystick						;82b6	3a 12 78
	or a					; is Keyboard ?										;82b9	b7 
	jr z,GIH_CHECK_KEYS		; yes - check key pressed							;82ba	28 06 

; -- check joystick button
	in a,(JOY_FIRE_PORT)	; read joystick port								;82bc	db 20 
	bit 4,a					; is button pressed ?								;82be	cb 67
	jr z,INT_EXIT_RUN		; yes - set Running and Exit						;82c0	28 08 

; -- check if any key pressed
GIH_CHECK_KEYS:
	ld a,(KEYB_PORT)		; read all keys										;82c2	3a 00 68 
	cpl						; inverse logic (key press sets bit)				;82c5	2f 
	and $3f					; any key pressed ?									;82c6	e6 3f 
	jr z,GIH_FRAME_UPDATE	; no - continue Frame Update						;82c8	28 19
INT_EXIT_RUN:
	xor a					; 0 - Game Mode Running								;82ca	af
	ld (GAME_MODE),a		; turn off Demo Mode								;82cb	32 2f 78 
;-- clean up stack pointer (set by System INT handler)
	pop ix					; restore ix										;82ce	dd e1 
	pop hl					; clean return address								;82d0	e1 
	pop hl					; restore hl										;82d1	e1  
	pop de					; restore de										;82d2	d1  
	pop bc					; restore bc										;82d3	c1  
	pop af					; restore af										;82d4	f1  
	ld hl,GAME_INIT			; GAME_INIT address 								;82d5	21 d9 7b
	push hl					; set as return from INT address					;82d8	e5 
; -- delay
	ld bc,0ffffh			; delay counter										;82d9	01 ff ff 
GTH_DELAY:
	dec bc					; decrement counter									;82dc	0b 
	ld a,b					; check if 0										;82dd	78 
	or c					; a = b|c											;82de	b1 
	jr nz,GTH_DELAY			; repeat until 0									;82df	20 fb 
	reti					; ----------- End of INT Proc -----------			;82e1	ed 4d 

; -- Game Frame Update Routines
GIH_FRAME_UPDATE:
	call CLEAR_JUMPER_SPRITES	; clear both JUMPER sprites on screen			;82e3	cd f9 82 
	call CHECK_BALOON_COLLISION	; check if any collision for JUMPER and BALOON	;82e6	cd 5e 87
	call DRAW_FRAME			; draw sprites at current positions					;82e9	cd 52 83 
	call UPDATE_POSITIONS	; calculate and update new positions for sprites	;82ec	cd ca 83 
INT_EXIT:
	pop ix					; restore ix										82ef	dd e1 
	pop hl					; clean return address								82f1	e1  
	pop hl					; restore hl										82f2	e1 
	pop de					; restore de										82f3	d1 
	pop bc					; restore bc										82f4	c1  
	pop af					; restore af										82f5	f1 
	ei						; enable interrupts									82f6	fb 
	reti					; ----------- End of INT Proc -------------------	82f7	ed 4d 

;***************************************************************************************
; Clear screen areas where were both Jumpers and Player Unit Bar if needed
CLEAR_JUMPER_SPRITES:
; -- clear Player Unit part if needed
	ld a,(BAR_CLEAR_FLAG)	; check flags if 1px need to be clered	 			;82f9	3a 1a 78 
	or a					; need update ?										;82fc	b7 
	jr z,CMS_CLEAR_WAIT_MAN	; 0 - no update needed								;82fd	28 14 

; -- clear 1px left from Player Unit - only 1st and 8th line where bar can be
	ld hl,(PLAYER_POS_VADR)	; player unit VRAM address - first line				;82ff	2a 09 78 
	dec hl					; 1 byte on left									;8302	2b
	ld a,(hl)				; current byte from screen							;8303	7e 
	and %11111100			; clear 4th pixel of this byte						;8304	e6 fc 
	ld (hl),a				; store new value									;8306	77 
	ld de,7*32				; add 7 screen lines - last line of sprite			;8307	11 e0 00 
	add hl,de				; last line of sprite, 1 byte on left				;830a	19 
	ld a,(hl)				; byte from screen									;830b	7e 
	and %11111100			; clear 4th pixel of this byte						;830c	e6 fc
	ld (hl),a				; store new value									;830e	77 
; -- reset update flag
	xor a					; 0 - no updates needed  							;830f	af 
	ld (BAR_CLEAR_FLAG),a	; clear update flag									;8310	32 1a 78 

; -- clear 16px - JUMPER Waiting sprite area plus 1 byte (4px) on left side
CMS_CLEAR_WAIT_MAN:
	ld hl,(JUMPER_W_CLR_VADR); Waiting MAN sprite address						;8313	2a 24 78 
	dec hl					; 1 byte to the left								;8316	2b 
	ld de,28				; 28 bytes per screen line (4 bytes in loop)		;8317	11 1c 00 
	xor a					; clear value - all 4 pixels green (bg)				;831a	af 
	ld b,7					; 7 lines - area height 							;831b	06 07 
CMSW_CLEAR_LINE:
	ld c,4					; 4 bytes - area width (16px)						;831d	0e 04 
CMSW_CLEAR_BYTE:
	ld (hl),a				; clear screen byte									;831f	77 
	inc hl					; next screen address								;8320	23 
	dec c					; decrement bytes counter							;8321	0d 
	jr nz,CMSW_CLEAR_BYTE	; repeat for 4 bytes								;8322	20 fb 
	add hl,de				; next area line 									;8324	19 
	djnz CMSW_CLEAR_LINE	; repeat for all 7 lines							;8325	10 f6 

; -- clear JUMPER sprite area on screen using mask to clear only non-transparent pixels
	ld hl,(JUMPER_CLR_VADR)	; JUMPER sprite address								;8327	2a 27 78 
	ld a,(JUMPER_CLR_X_INT)	; JUMPER position X in pixels						;832a	3a 29 78 
	push hl					; save hl - sprite screen address					;832d	e5
	ld de,21				; 21 bytes of sprite content						;832e	11 15 00 
	and $03					; a - pixel in screen byte index 0..3				;8331	e6 03 
	inc a					; pixel index 1..4	-> shift needed					;8333	3c 
	ld b,a					; b - index in sprite variants table				;8334	47
	ld hl,SPR_JUMPER_S0_MASK-21; sprites table -21 (size of one sprite)			;8335	21 65 81 
; -- find mask with required pixels shifted
CMSJ_NEXT_MASK:
	add hl,de				; add size of sprite in table						;8338	19 
	djnz CMSJ_NEXT_MASK		; repeat b times									;8339	10 fd 
; -- clear area using sprite mask
	ex de,hl				; de - address of sprite mask 						;833b	eb
	pop hl					; hl - sprite screen address						;833c	e1 
	ld b,7					; 7 lines - sprite/area height						;833d	06 07 
CMSJ_CLEAR_LINE:
	ld c,3					; 3 bytes - sprite width (12px)						;833f	0e 03 
CMSJ_CLEAR_BYTE:
	ld a,(de)				; a - mask byte										;8341	1a 
	and (hl)				; apply mask - clear foreground pixels				;8342	a6 
	ld (hl),a				; store back byte									;8343	77 
	inc hl					; next screen byte									;8344	23 
	inc de					; next mask byte									;8345	13 
	dec c					; decrement bytes in line counter					;8346	0d 
	jr nz,CMSJ_CLEAR_BYTE 	; repeat for all 3 bytes							;8347	20 f8 
	push de					; save de											;8349	d5 
	ld de,29				; 29 bytes per line (3 covered in loop)				;834a	11 1d 00 
	add hl,de				; hl - 1st byte in next line 						;834d	19 
	pop de					; restore de										;834e	d1 
	djnz CMSJ_CLEAR_LINE 	; repeat for all 7 lines							;834f	10 ee 
	ret						; --------- End Of Proc ----------------			;8351	c9 


;*******************************************************************************************
; Draws Frame content
; Baloons, Player and Jumpers will be drawn at current positions
DRAW_FRAME:
	ld a,(BALOONS_DRAW_NEXT); get Ballons Group to update						;8352	3a 05 78 
	and $03					; modulo 4 (seq: RED,YEL,BLU,none)					;8355	e6 03 
	jr z,REDRAW_BALOONS_RED	; 0 - Baloons Group Red								;8357	28 0a 	
	cp 1					; check if Ballons Group Yellow						;8359	fe 01 
	jr z,REDRAW_BALOONS_YEL	; yes - redraw Baloons Group Yellow					;835b	28 13
	cp 2					; check if Baloons Group Blue						;835d	fe 02 
	jr z,REDRAW_BALOONS_BLU	; yes - redraw Baloons Group Blue					;835f	28 1c
; -- redraw counter = 3 - skip drawing Baloons	
	jr REDRAW_PLAYER_N_MEN	; continue redraw player and Jumpers				;8361	18 25 

; -- draw Red Baloons screen part 
REDRAW_BALOONS_RED:
	ld hl,SPR_BUF_BALOONS_RED	; src - buffer for Baloons Red (sprite)			;8363	21 80 78
	ld de,VRAM+(1*32)+0		; dst - screen coord (0,1)px [$7020]				;8366	11 20 70  
	ld bc,128				; 128 bytes buffer (4 screen lines)					;8369	01 80 00 
	ldir					; copy buffer to screen 							;836c	ed b0 
	jr REDRAW_PLAYER_N_MEN	; continue redraw player and Jumpers sprites		;836e	18 18 

; -- draw Yellow Baloons screen part 
REDRAW_BALOONS_YEL:
	ld hl,SPR_BUF_BALOONS_YEL	; src - buffer for Baloons Yellow (sprite)		;8370	21 00 79 
	ld de,VRAM+(7*32)+0		; dst - screen coord (0,7)px [$70e0]				;8373	11 e0 70
	ld bc,128				; 128 bytes buffer (4 screen lines)					;8376	01 80 00 
	ldir					; copy buffer to screen								;8379	ed b0 
	jr REDRAW_PLAYER_N_MEN	; continue redraw player and Jumpers sprites		;837b	18 0b 

; -- draw Blue Baloons screen part 
REDRAW_BALOONS_BLU:
	ld hl,SPR_BUF_BALOONS_BLU	; src - buffer for Baloons Blue (sprite)		;837d	21 80 79
	ld de,VRAM+(13*32)+0    ; src - screen coord (0,13)px [$71a0]				;8380	11 a0 71 
	ld bc,128				; 128 bytes buffer (4 screen lines)					;8383	01 80 00  
	ldir					; copy buffer to screen								;8386	ed b0 

; --- continue ... redraw screen - player unit, Jumper W(aiting) and Jumper
REDRAW_PLAYER_N_MEN:
	ld hl,(PLAYER_POS_VADR)	; current player unit position 						;8388	2a 09 78 
	ld ix,SPR_BUF_PLAYER	; sprite from buffer								;838b	dd 21 01 7a 
	ld b,8  				; 8 lines - sprite height               			;838f	06 08 
	ld c,7  				; 7 bytes (28px) - sprite width         			;8391	0e 07 
	call DRAW_SPRITE		; draw player unit sprite	            			;8393	cd 71 7f
; -- draw JUMPER W(aiting) sprite at current position
	ld hl,(JUMPER_W_VADR)	; current position on screen						;8396	2a 0b 78 
	ld ix,SPR_BUF_JUMPER_W	; sprite JUMPER_W from buffer (12x7)px				;8399	dd 21 39 7a
	ld b,7					; 7 lines - sprite height							;839d	06 07  
	ld c,3					; 3 bytes - sprite width (12px)						;839f	0e 03 
	call DRAW_SPRITE_T		; draw sprite with transparency						;83a1	cd 8c 7f   
; -- draw JUMPER sprite at current position
	ld hl,(JUMPER_VADR)		; current position on screen						;83a4	2a 0d 78 
	ld ix,SPR_BUF_JUMPER	; sprite JUMPER from buffer (12x7)px				;83a7	dd 21 4e 7a 
	ld b,7					; 7 lines - sprite height							;83ab	06 07 
	ld c,3					; 3 bytes - sprite width (12px)						;83ad	0e 03  
	call DRAW_SPRITE_T		; draw sprite with transparency						;83af	cd 8c 7f 

; -- redraw Vertical Stand left and right
DRAW_STANDS_LR:
; -- draw Vertical Stand left on screen
	ld hl,VRAM+(27*32)+0    ; screen coord 0,27 [$7360] 						;83b2	21 60 73 
	ld ix,SPR_STAND_LEFT 	; sprite 8x30px Vertical Stand Left   				;83b5	dd 21 c0 7f 
	ld b,30 				; 30 lines - sprite height              			;83b9	06 1e 
	ld c,2  				; 2 bytes (8px) - sprite width          			;83bb	0e 02 
	call DRAW_SPRITE		; draw sprite	                        			;83bd	cd 71 7f
; -- draw Vertical Stand right on screen
	ld hl,VRAM+(27*32)+30   ; screen coord (120,27)px [$737e]					;83c0	21 7e 73
	ld ix,SPR_STAND_RIGHT	; sprite 8x30px Vertical Right Stand (b,c unchanged);83c3	dd 21 fc 7f 
	jp DRAW_SPRITE			; draw sprite and return to caller					;83c7	c3 71 7f 

;*******************************************************************************************
; Update Positions
; Calculate new positions for moving sprites
UPDATE_POSITIONS:
	call UPDATE_PLAYER_POS	; check keys/joystick and move player unit			;83ca	cd 9a 84 
	call UPDATE_JUMPER_POS	; calculate new position for JUMPER					;83cd	cd b4 85 
	ld a,(BALOONS_DRAW_NEXT)	; get last updated Baloons Group				;83d0	3a 05 78 
	inc a					; next group to update 								;83d3	3c 
	ld (BALOONS_DRAW_NEXT),a; store counter										;83d4	32 05 78
	and $03					; modulo 4 (seq RED,YEL,BLU,none)					;83d7	e6 03 
	jr z,UPDATE_BALOONS_RED	; 0 - Baloons Group Red								;83d9	28 09 
	cp 1					; 1 - Baloons Group Yellow							;83db	fe 01 
	jr z,UPDATE_BALOONS_YEL	; yes - update Baloons Group position				;83dd	28 22 
	cp 2					; 2 - Baloons Group Blue							;83df	fe 02 
	jr z,UPDATE_BALOONS_BLU	; yes - update Baloons Group position				;83e1	28 3b 
	ret						; 3 - none of Groups to update 						;83e3	c9 

; --- update Baloons Group Red
UPDATE_BALOONS_RED:
	ld a,(BALOONS_RED_X_FRAC)	; a - Baloons Group position X (px fraction)	;83e4	3a 06 78
	add a,$e0				; add velocity (7/8 px)								;83e7	c6 e0 
	ld (BALOONS_RED_X_FRAC),a	; store new value								;83e9	32 06 78 
	ret nc					; return if pixel pos didn't changed				;83ec	d0 
; -- Carry = 1 means that sprite needs to be moved by 1px  
	ld de,BALOONS_RED_DIR	; move direction flag for this Baloons				;83ed	11 02 78  
	ld a,(de)				; a - direction flag (0 or $80) 					;83f0	1a 
	or a					; check if 0 (right) 								;83f1	b7 
	jp m,UBR_MOVE_LEFT		; no - move 1px left 								;83f2	fa fb 83
; -- moving sprite right must be started from last byte in line
	ld hl,SPR_BUF_BALOONS_RED+31	; last byte of first line 					;83f5	21 9f 78 
	jp MOVE_BALOONS_RIGHT	; move sprite 1px right								;83f8	c3 3b 84 
; -- moving sprite left must be started from first byte in line
UBR_MOVE_LEFT:
	ld hl,SPR_BUF_BALOONS_RED	; first byte of first line 						;83fb	21 80 78 
	jp MOVE_BALOONS_LEFT	; move sprite 1px left								;83fe	c3 6b 84 

; --- update Baloons Group Yellow
UPDATE_BALOONS_YEL:
	ld a,(BALOONS_YEL_X_FRAC)	; Baloons Group position X (px fraction)		;8401	3a 07 78 
	add a,$80				; add velocity (1/2 px)								;8404	c6 80 
	ld (BALOONS_YEL_X_FRAC),a	; store new value								;8406	32 07 78 
	ret nc					; return if pixel pos didn't changed				;8409	d0 
; -- Carry = 1 means that sprite needs to be moved by 1px  
	ld de,BALOONS_YEL_DIR	; move direction flag for this Baloons				;840a	11 03 78  
	ld a,(de)				; a - direction flag (0 or $80) 					;840d	1a 
	or a					; check 0 (right) 									;840e	b7 
	jp m,UBY_MOVE_LEFT		; no - move 1px left 								;840f	fa 18 84 
; -- moving sprite right must be started from last byte in first line
	ld hl,SPR_BUF_BALOONS_YEL+31	; last byte of first line 					;8412	21 1f 79 
	jp MOVE_BALOONS_RIGHT	; move sprite 1px right								;8415	c3 3b 84 
; -- moving sprite left must be started from first byte in first line
UBY_MOVE_LEFT:
	ld hl,SPR_BUF_BALOONS_YEL	; first byte of first line 						;8418	21 00 79 
	jp MOVE_BALOONS_LEFT	; move sprite 1px left								;841b	c3 6b 84 

; --- update Baloons Group Blue
UPDATE_BALOONS_BLU:
	ld a,(BALOONS_BLU_X_FRAC)	; Baloons Group position X (px fraction)		;841e	3a 08 78  
	add a,038h				; add velocity (7/32 px)							;8421	c6 38 
	ld (BALOONS_BLU_X_FRAC),a	; store new value								;8423	32 08 78 
	ret nc					; return if pixel pos didn't changed				;8426	d0 
; -- Carry = 1 means that sprite needs to be moved by 1px  
	ld de,BALOONS_BLU_DIR	; move direction flag for this Baloons				;8427	11 04 78 
	ld a,(de)				; a - direction flag (0 or $80) 					;842a	1a  
	or a					; check 0 (right) 									;842b	b7 
	jp m,UBB_MOVE_LEFT		; no - move 1px left 								;842c	fa 35 84 
; -- moving sprite right must be started from last byte in first line
	ld hl,SPR_BUF_BALOONS_BLU+31	; last byte of first line 					;842f	21 9f 79 
	jp MOVE_BALOONS_RIGHT	; move sprite 1px right								;8432	c3 3b 84 
; -- moving sprite left must be started from first byte in first line
UBB_MOVE_LEFT:
	ld hl,SPR_BUF_BALOONS_BLU	; first byte of first line 						;8435	21 80 79 
	jp MOVE_BALOONS_LEFT		; move sprite 1px left							;8438	c3 6b 84 

;************************************************************************************
; Shift Baloons Group offscreen buffer by 1 pixel right
; IN: de - address of Baloons Group direction variable 
;     hl - points to last byte of first line in Baloons' buffer 
MOVE_BALOONS_RIGHT:
	push de					; save de											;843b	d5 
	ld c,4					; 4 lines - sprite height							;843c	0e 04 
MBR_NEXT_LINE:
	push hl					; save hl - start address in sprite buffer			;843e	e5 
	ld b,31					; 31 bytes to process (1 screen line)				;843f	06 1f 
MBR_NEXT_BYTE:
; -- read 2 bytes of sprite into de	
	ld e,(hl)				; e - byte from buffer (4px)						;8441	5e
	dec hl					; address of previous byte							;8442	2b 
	ld d,(hl)				; d - prev byte (left side)							;8443	56 
	inc hl					; restore hl - address of current byte				;8444	23 
; -- shift right sprite byte by 2 bits (1px) with lowest bits form left byte
	srl d					; shift right 1 bit (left byte)						;8445	cb 3a
	rr e					; shift right 1 bit (this byte) with CY				;8447	cb 1b 
	srl d					; shift right 1 bit (left byte)						;8449	cb 3a 
	rr e					; shift right 1 bit (this byte) with CY				;844b	cb 1b 
; -- store sprite byte
	ld (hl),e				; store shifted value								;844d	73 
	dec hl					; next sprite byte to the left						;844e	2b 
	djnz MBR_NEXT_BYTE		; repeat for 31 bytes								;844f	10 f0 
; -- first byte must be shifted slightly different way
	ld a,(hl)				; first byte in this line							;8451	7e 
	srl a					; shift right 1 bit									;8452	cb 3f 
	srl a					; shift right 1 bit (2 bits total - 1px)			;8454	cb 3f 
	ld (hl),a				; store shifted value								;8456	77 
	pop hl					; restore address of last buffer byte				;8457	e1 
	ld de,32				; 32 bytes per sprite line							;8458	11 20 00
	add hl,de				; hl next sprite line (last byte in line)			;845b	19 
	dec c					; dec line counter									;845c	0d 
	jr nz,MBR_NEXT_LINE		; repeat for all 4 lines							;845d	20 df 
; -- all bytes in sprite buffer are shifted by 2 bits (1px) right
	or a					; clear Carry flag									;845f	b7 
	sbc hl,de				; hl points to first byte in line					;8460	ed 52
	pop de					; de - address of Direction variable				;8462	d1 
	ld a,(hl)				; a - 1st byte in line								;8463	7e 
	and %00001100			; check 3rd pixel is set							;8464	e6 0c 
	ret z					; no - next time we will still shift right			;8466	c8 
; -- 3rd pixel of sprite is set - next time we should shift to the left 
	ld a,$80				; direction flag - to left							;8467	3e 80 
	ld (de),a				; store direction flag								;8469	12
	ret						; ------------ End Of Proc --------------			;846a	c9 

;************************************************************************************
; Shift BAloons Group offscreen buffer by 1 pixel left
; IN: de - address of Baloons Group direction variable 
;     hl - points to first byte of first line in Baloons' buffer 
MOVE_BALOONS_LEFT:
	push de					; save de											;846b	d5  
	ld c,4					; 4 lines - sprite height							;846c	0e 04  
MBL_NEXT_LINE:
	push hl					; save hl - start address in sprite buffer			;846e	e5  
	ld b,31					; 31 bytes to process (1 screen line)				;846f	06 1f  
MBL_NEXT_BYTE:
; -- read 2 bytes of sprite into de	
	ld d,(hl)				; d - byte from buffer (4px);						;8471	56 
	inc hl					; address of next byte								;8472	23  
	ld e,(hl)				; e - next byte (right side)						;8473	5e 
	dec hl					; restore hl - address of current byte				;8474	2b
; -- shift left sprite byte by 2 bits (1px) with highest bits form right byte
	sla e					; shift left 1 bit (right byte)						;8475	cb 23 
	rl d					; shift left 1 bit (this byte) with CY				;8477	cb 12 
	sla e					; shift left 1 bit (right byte)						;8479	cb 23 
	rl d					; shift left 1 bit (this byte) with CY				;847b	cb 12 
; -- store sprite byte
	ld (hl),d				; store shifted value								;847d	72 
	inc hl					; next sprite byte to the right						;847e	23 
	djnz MBL_NEXT_BYTE		; repeat for 31 bytes								;847f	10 f0 
; -- last byte must be shifted slightly different way
	ld a,(hl)				; last byte in this line							;8481	7e 
	sla a					; shift left 1 bit									;8482	cb 27 
	sla a					; shift left 1 bit (2 bits total - 1px)				;8484	cb 27  
	ld (hl),a				; store shifted value								;8486	77 
	pop hl					; restore address of first byte in line				;8487	e1 
	ld de,32				; 32 bytes per sprite line							;8488	11 20 00 
	add hl,de				; hl next sprite line (first byte in line)			;848b	19 
	dec c					; dec line counter									;848c	0d 
	jr nz,MBL_NEXT_LINE		; repeat for all 4 lines							;848d	20 df 
; -- all bytes in sprite buffer are shifted by 2 bits (1px) left
	or a					; clear Carry flag									;848f	b7 
	sbc hl,de				; hl points to first byte of last line				;8490	ed 52 
	pop de					; de - address of Direction variable 				;8492	d1 
	ld a,(hl)				; a - 1st byte in line								;8493	7e
	and %00110000			; check 2nd pixel is set							;8494	e6 30
	ret z					; no - next time we will still shift left 			;8496	c8 
; -- 2nd pixel of sprite is set - next time we should shift to the right 
	xor a					; direction flag - to right							;8497	af 
	ld (de),a				; store direction flag								;8498	12 
	ret						; ------------ End Of Proc ---------------			;8499	c9 

;*****************************************************************************************
; Move Player Unit according to keys/joystick inputs.
; In Demo Mode it skips checking input and moves player scripted way  
UPDATE_PLAYER_POS:
	ld a,(GAME_MODE)		; a - Game Mode										;849a	3a 2f 78 
	or a					; check if Running or Demo Mode						;849d	b7 
	jr nz,DEMO_UPDATE_PLAYER_POS	; Demo - skip input checks					;849e	20 3c 

; ---- check C or B pressed
	ld a,(068fbh)			; read keys: V|Z|C|SHIFT|X|B						;84a0	3a fb 68 
	cpl						; inverse logic										;84a3	2f 
	and %00001001			; mask keys: C or B									;84a4	e6 09 
	jr nz,PLAYER_MOVE_RIGHT	; yes - C or B is pressed							;84a6	20 5b 
; -- check M is pressed
	ld a,(068efh)			; read keys: M|SPACE|,| |.|N						;84a8	3a ef 68 
	bit 5,a					; is M pressed										;84ab	cb 6f 
	jr z,PLAYER_MOVE_RIGHT	; yes - move player unit to the right				;84ad	28 54 
; -- check V or X is pressed
	ld a,(068fbh)			; read keys: V|Z|C|SHIFT|X|B						;84af	3a fb 68 
	cpl						; inverse logic										;84b2	2f 
	and $22					; mask keys: V or X									;84b3	e6 22 
	jp nz,PLAYER_MOVE_LEFT	; V or X is pressed									;84b5	c2 84 85 
; -- check N is pressed
	ld a,(068efh)			; read keys: M|SPACE|,| |.|N 						;84b8	3a ef 68 
	bit 0,a					; is N pressed										;84bb	cb 47 
	jp z,PLAYER_MOVE_LEFT	; yes - move player unit to the left				;84bd	ca 84 85 
; -- if input mode is set to joystick
	ld a,(INPUT_FLAG)		; input Keyboard/Joystick							;84c0	3a 12 78
	or a					; is Joystick input mode							;84c3	b7 
	ret z					; no ------- End of Proc --------------------		;84c4	c8 
; -- check 1st joystick
	in a,(JOY1_PORT)		; read 1st joystick value							;84c5	db 2e 
	bit 2,a					; is Move Left										;84c7	cb 57 
	jp z,PLAYER_MOVE_LEFT	; yes - move plater unit to the left				;84c9	ca 84 85 
	bit 3,a					; is Move Right										;84cc	cb 5f 
	jr z,PLAYER_MOVE_RIGHT	; yes - move player unit to the right				;84ce	28 33 
; -- check 2nd joystick
	in a,(JOY2_PORT)		; read 2nd joystick									;84d0	db 2b 
	bit 2,a					; is Move Left										;84d2	cb 57 
	jp z,PLAYER_MOVE_LEFT	; yes - move player unit to the left				;84d4	ca 84 85 
	bit 3,a					; is Move Right										;84d7	cb 5f 
	jr z,PLAYER_MOVE_RIGHT	; yes - move player unit to the right				;84d9	28 28 
; -- no joystick input 
	ret						; --------- End of Proc	--------------------		;84db	c9 

;******************************************************************************************
; In Demo Mode move player unit to follow JUMPER position
DEMO_UPDATE_PLAYER_POS:
	ld a,(BAR_FLIP_FLAG)	; player unit bar flip flag 	 					;84dc	3a 1b 78 
	or a					; check not flipped (left up)						;84df	b7 
	ld a,(PLAYER_X_INT)		; player X position (in pixels)						;84e0	3a 10 78 
	jr z,DEMO_FOLLOW_LEFT	; bar not flipped 									;84e3	28 10 

DEMO_FOLLOW_RIGHT:
; -- player unit bar is flipped (right-up) - when bar is flipped we need to aim right side of unit 
	add a,22				; add 22px aim JUMPER with right side of unit 		;84e5	c6 16 
	ld b,a					; b - player unit position X in pixels				;84e7	47 	G 
	ld a,(JUMPER_X_INT)		; JUMPER position X in pixels						;84e8	3a 15 78 
	sub b					; check JUMPER position relative to player  		;84eb	90 
	jp p,PLAYER_MOVE_RIGHT	; a > b - move player right							;84ec	f2 03 85 
	add a,3					; check if JUMPER bounces right (pos X > 125)		;84ef	c6 03 
	jp m,PLAYER_MOVE_LEFT	; yes -> bounce - move player left					;84f1	fa 84 85 
	ret						; no move --------- End of Proc ---- 				;84f4	c9 

; -- player unit bar is not flipped (left-up)
DEMO_FOLLOW_LEFT:
	ld b,a					; b - player unit position X in pixels				;84f5	47 
	ld a,(JUMPER_X_INT)		; JUMPER position X in pixels						;84f6	3a 15 78 
	sub b					; check JUMPER position relative to player 			;84f9	90  
	jp m,PLAYER_MOVE_LEFT	; a < b - move player left							;84fa	fa 84 85 
	sub 3					; check if JUMPER bounces left (pos X < 3)			;84fd	d6 03 
	jp p,PLAYER_MOVE_RIGHT	; yes -> bounce - move player right					;84ff	f2 03 85  
	ret						; no move --------- End of Proc ----				;8502	c9  

;************************************************************************************
; Player Move Right
PLAYER_MOVE_RIGHT:
	ld a,(PLAYER_X_INT)		; player X position (in pixels)						;8503	3a 10 78 
	cp 95					; check if already max X position					;8506	fe 5f 
	ret nc					; yes - ------ End of Proc 	--------				;8508	d0 

; -- player unit can be moved right
	ld de,(PLAYER_X_VEL)	; player unit velocity ($00ff) almost pixel			;8509	ed 5b 1c 78 
	ld hl,(PLAYER_X_FRAC)	; current player X position							;850d	2a 0f 78 
	ld b,h					; current player X position in pixels				;8510	44 
	add hl,de				; add velocity factor								;8511	19 

;************************************************************************************
; Redraw player unit on new position after move. No drawing needed if X pixel didn't change
DRAW_MOVED_PLAYER:
	ld (PLAYER_X_FRAC),hl	; store new player X position						;8512	22 0f 78 
	ld a,h					; a - X position in integral pixels					;8515	7c 
	cp b					; is pixel changed?	(CY - which way)				;8516	b8 
	ret z					; no - ------- No need to update ---------			;8517	c8  

; -- player unit moved 1px at least
	push af					; save a - player unit X position in pixels			;8518	f5 
; -- JUMPER W(aiting) needs to be moved along with Player Unit
	ld a,(JUMPER_W_X_INT)	; JUMPER W(aiting) pos X in pixels					;8519	3a 11 78 
	ld (JUMPER_W_CLR_X_INT),a	; store pos X for clear routines				;851c	32 26 78 
	jr c,DMP_LEFT			; jump if move left 								;851f	38 03 
; -- move right
	inc a					; add 1px 											;8521	3c 
	jr DMP_MOVE				; continue											;8522	18 01 
; -- move left 
DMP_LEFT:
	dec a					; sub 1px											;8524	3d 
DMP_MOVE:
	ld (JUMPER_W_X_INT),a	; store new X position								;8525	32 11 78 
; -- update VRAM address for new player position
	pop af					; a - target Palyer Unit X position					;8528	f1 
	srl a					; a = a*2											;8529	cb 3f 
	srl a					; a = a*2 - total a*4 pixels per screen byte 		;852b	cb 3f 
	or $20					; adjust low byte of address to target line			;852d	f6 20 
	ld (PLAYER_POS_VADR),a	; store low byte (high byte won't change)			;852f	32 09 78 

;*****************************************************************************************
; Update Offscreen Buffers for Player and Jumper Waiting (the one standing on player Unit)
; IN: h - new player X position (integral pixels)
UPDATE_OFFSCREEN_BUFFERS:
	ld a,h					; a - player sprite X position (integral pixel)		;8532	7c
	and $03					; pixel X position in byte screen (0..3)			;8533	e6 03 
	ld b,a					; sprite variant depending on pixel shift 			;8535	47
	jr nz,UOB_SKIP			; skip marking player Unit Bar for clear			;8536	20 05 
; -- no shift in byte - we need clear 1px to the left (bar area)
	ld a,$80				; $80 - bar need update 							;8538	3e 80  
	ld (BAR_CLEAR_FLAG),a	; set bar update flag								;853a	32 1a 78
UOB_SKIP:
	inc b					; b - sprite variant (1..4)							;853d	04 
	ld a,(BAR_FLIP_FLAG)	; player unit bar state 							;853e	3a 1b 78 
	or a					; check bar is flipped (left up)					;8541	b7 	
	jr nz,UOB_BAR_IS_FLIPPED; yes - use another sprites (FB variants)			;8542	20 05 
; -- player unit bar is not flipped (left-up) - use base sprites
	ld hl,SPR_PLAYER_S0-56	; sprites base address (offset beacuse b is 1..4)	;8544	21 00 80 
	jr UPDATE_PLAYER_BUF	; continue - update offscreen sprite buffer  		;8547	18 03 

; -- player unit bar is flipped (right-up) - use FB sprites
UOB_BAR_IS_FLIPPED:
	ld hl,SPR_PLAYER_FB_S0-56 ; sprites base address (offset beacuse b is 1..4)	;8549	21 96 81 

;*************************************************************************************
; Update Player Offsceen Buffer
; -- hl is pointing 56 bytes before either base or FB sprites table (4 variants)
; -- b - index in table (1..4) depending on shift position relative to screen byte
UPDATE_PLAYER_BUF:
	ld de,56				; 56 bytes per sprite data							;854c	11 38 00 
UPB_NEXT:
	add hl,de				; add 56 bytes - address of sprite variant			;854f	19 
	djnz UPB_NEXT			; repeat adding b times								;8550	10 fd 
; -- hl - address of sprite data in variant depends on b
	ld de,SPR_BUF_PLAYER	; dst - sprite buffer to store current data			;8552	11 01 7a 
	ld bc,56				; 56 bytes per sprite data							;8555	01 38 00 
	ldir					; copy sprite data to buffer 						;8558	ed b0

; -- calculate new address and determine new variant for JUMPER W(aiting) sprite
	ld hl,(JUMPER_W_VADR)	; current screen position of JUMPER W(aiting)		;855a	2a 0b 78 
	ld (JUMPER_W_CLR_VADR),hl; save for clear routine							;855d	22 24 78
	ld a,(JUMPER_W_X_INT)	; JUMPER W(aiting) position X in pixels				;8560	3a 11 78 
	ld c,a					; save position X									;8563	4f 
	ld a,(JUMPER_W_Y_INT)	; JUMPER W(aiting) Y position (bottom up)			;8564	3a 13 78
	call CALC_VRAM_ADDRESS	; hl - VRAM address of JUMPER W(aiting) sprite		;8567	cd 98 85 
	ld (JUMPER_W_VADR),hl	; store current VRAM address						;856a	22 0b 78 
	ld a,c					; a - JUMPER W position X in pixels					;856d	79 
	and $03					; pixel X position in byte screen (0..3)			;856e	e6 03 
	ld b,a					; b - sprite variant depending on pixel shift		;8570	47  
	inc b					; variant index range 1..4							;8571	04 
; -- b - index in table (1..4) depending on shift position relative to screen byte
	ld hl,SPR_JUMPER_S0-21	; address of sprite data table - offset (21)		;8572	21 11 81 
	ld de,21				; 21 bytes per sprite variant						;8575	11 15 00 
UPB_NEXT_J:
	add hl,de				; add size of sprite data							;8578	19 
	djnz UPB_NEXT_J			; keep adding b times								;8579	10 fd 

;*******************************************************************************************
; Update Jumper Waiting Offsceen Buffer
; -- hl is pointing 21 bytes before either base or FB sprites table (4 variants)
; -- b - index in table (1..4) depending on shift position relative to screen byte
	ld de,SPR_BUF_JUMPER_W	; dst - offscreen buffer for JUMPER W(aiting)		;857b	11 39 7a 
	ld bc,21				; 21 bytes of sprite data							;857e	01 15 00 
	ldir					; copy sprite data to buffer						;8581	ed b0 
	ret						; ------------- End of Proc -------------			;8583	c9 

;*******************************************************************************************
; Player Move Left 
; moves player's unit to the left with boundary checking
; Called if user press key or move joystick left
PLAYER_MOVE_LEFT:
	ld a,(PLAYER_X_INT)		; player X position (in pixels)						;8584	3a 10 78  
	cp 9					; check if already minimum X position				;8587	fe 09 
	ret c					; yes - --------- End of Proc ----------			;8589	d8 
; -- player unit can be moved left	
	ld de,(PLAYER_X_VEL)	; player unit velocity ($00ff) almost pixel			;858a	ed 5b 1c 78 
	ld hl,(PLAYER_X_FRAC)	; player X position (with pixel fraction)			;858e	2a 0f 78 
	ld b,h					; b - X position in whole pixels					;8591	44 
	or a					; clear Carry flag									;8592	b7 
	sbc hl,de				; subtract velocity factor							;8593	ed 52 
	jp DRAW_MOVED_PLAYER	; draw player on new position						;8595	c3 12 85 

;*******************************************************************************************
; Calculate VRAM address from pixel coordinates (Cartesian Plane Coordinates)
; IN: a - Y coord (number lines to bottom of screen)
;     c - X coord (number of pixels from left edge)	
; OUT hl - VRAM address
;     b - X position in pixels
CALC_VRAM_ADDRESS:
	ld e,a					; e - Y coordinate									;8598	5f 
	ld d,0					; de - Y coordinate as 16bit value					;8599	16 00 
; -- multiply Y * 32 bytes per screen line
	ld b,5					; shift counter - (32 = 2^5)						;859b	06 05 
CVA_MUX_2:
	sla e					; e = e * 2											;859d	cb 23 
	rl d					; de = de * 2										;859f	cb 12
	djnz CVA_MUX_2				; repeat 5 times -> de = a * 32					;85a1	10 fa 
; -- de is address offset from last line (in screeen bytes)
	ld hl,VRAM+(63*32)+0	; last line screen coord (0,63)px [$77e0]			;85a3	21 e0 77 
	or a					; clear Carry flagfor substract						;85a6	b7 
	sbc hl,de				; calculate VRAM address where target line starts	;85a7	ed 52 
	ld a,c					; a - X coordinate in pixels						;85a9	79 
	ld b,a					; b - X coordinate in pixels						;85aa	47 
	srl a					; a = X/2											;85ab	cb 3f 
	srl a					; a = X/2 (total X/4 pixels per screen byte)		;85ad	cb 3f 
	ld e,a					; e - X coord in bytes								;85af	5f 
	ld d,0					; de - X offset in screen bytes						;85b0	16 00 
	add hl,de				; calculate final address of requested (X,Y)		;85b2	19 
	ret						; -------------- End of Proc ----------				;85b3	c9 

;*******************************************************************************************
; Update JUMPER Positions
; Calculate new X and Y JUMPER position with Velocity and Gravity factors 
UPDATE_JUMPER_POS:
; -- update X position for clear routines
	ld a,(JUMPER_X_INT)		; JUMPER position X in pixels						;85b4	3a 15 78
	ld (JUMPER_CLR_X_INT),a	; store position X for clear routines				;85b7	32 29 78 

; -- calculate new Y position with Velocity and Gravity
	ld hl,(JUMPER_Y_VEL)	; JUMPER Y velocity 								;85ba	2a 22 78 
	ld de,(WORLD_GRAVITY)	; de - Wrorld Gravity factor						;85bd	ed 5b 1e 78 
	or a					; clear Carry flag for substract					;85c1	b7 
	sbc hl,de				; JUMPER Y velocity with Gravity correction			;85c2	ed 52 
	ld (JUMPER_Y_VEL),hl	; store as new Y velocity							;85c4	22 22 78
	ex de,hl				; de - new Y velocity								;85c7	eb
	ld hl,(JUMPER_Y_FRAC)	; JUMPER position Y (with fractions)				;85c8	2a 16 78 
	add hl,de				; add velocity -> new Y position					;85cb	19 
	ld b,h					; b - JUMPER position Y in pixels					;85cc	44

; -- calculate new X position with Velocity
	ld (JUMPER_Y_FRAC),hl	; store new Y position (with fractions)				;85cd	22 16 78 
	ld hl,(JUMPER_X_FRAC)	; JUMPER position X (with fraction)					;85d0	2a 14 78 
	ld de,(JUMPER_X_VEL)	; JUMPER X velocity									;85d3	ed 5b 20 78
	add hl,de				; add velocity -> new X position					;85d7	19 
	ld (JUMPER_X_FRAC),hl	; store new X position (with fractions)				;85d8	22 14 78
	ld c,h					; c - JUMPER position X in pixels					;85db	4c

; -- update VRAM address for clear routine
	ld hl,(JUMPER_VADR)		; JUMPER screen address 							;85dc	2a 0d 78 
	ld (JUMPER_CLR_VADR),hl; store address for clear routines					;85df	22 27 78 

;************************************************************************************************
; First check collision of two JUMPERs - case when flying Jumper landed on waiting Jumper
; -- b - JUMPER Y position (in pixels), c - JUMPER X position (in pixels) 
	ld a,(JUMPER_W_Y_INT)	; JUMPER W(aiting) position Y (bottom up)			;85e2	3a 13 78 
	sub b					; difference Y pos of both JUMPERs 					;85e5	90 
	call m,NEG_A			; normalize Y difference (make it positive number)	;85e6	fc fb 85 
	cp 7					; check if less than 7 px							;85e9	fe 07  
	jr nc,CHECK_JUMPER_Y	; no - continue checking (Y position)				;85eb	30 11 
; -- Y difference is less than 7
	ld a,(JUMPER_W_X_INT)	; JUMPER W(aiting) position X in pixels				;85ed	3a 11 78 
	sub c					; difference X pos of both JUMPERs					;85f0	91 
	call m,NEG_A			; normalize X difference (make it positive number)	;85f1	fc fb 85 
	cp 7					; check if less than 7								;85f4	fe 07 
	jr nc,CHECK_JUMPER_Y	; no - continue checking (Y position)	 			;85f6	30 06 	0 . 
; -- both X and Y difference is less than 7 px - Jumper landed on another Jumper
	jp JUMPER_IS_DEAD		; set Game Event 1 (Jumper Died) and return			;85f8	c3 65 86

;***********************************************************************************************
; A = A * (-1) Called when A is negative. Technically performs ABS(a)
NEG_A:
	neg						; negate a											;85fb	ed 44
	ret						; ------------------- End of Proc -----------		;85fd	c9 

;***********************************************************************************************
; Next check Y position - case when there is colision of Jumper and Player 
; -- X and Y positions difference beetween both JUMPERs is bigger than 7 px
CHECK_JUMPER_Y:
	ld a,b					; JUMPER position Y in pixels						;85fe	78 
	cp 18					; check if less than 18 px (from bottom)			;85ff	fe 12 
	jr nc,CHECK_JUMPER_Y_13	; no - continue checking 							;8601	30 5d

; -- JUMPER Y position is less than 18px - possible collision with PLAYER
	ld a,(PLAYER_X_INT)		; PLAYER X position (in pixels)						;8603	3a 10 78  
	sub c					; subtract JUMPER X position 						;8606	91 
	ld e,a					; e - positions X difference						;8607	5f
	sub 7					; check if diffrence is less than 7 px				;8608	d6 07 
	jp p,CHECK_JUMPER_Y_13	; no - continue checking 							;860a	f2 60 86

; -- X pos difference beetween PLAYER and JUMPER is less than 7 px and JUMPER Y pos < 18px
; -- 0 < diff < 7px -- JUMPER is on the LEFT but no more than 7 px (JUMPER sprite width) - collision
; -- -23 < diff < 0 -- JUMPER is on the RIGHT, PLAYER is on the lLEFT -- collision
; -- diff < -23 -- JUMPER is on the RIGHT, PLAYER is on the LEFT (too far) -- no collision
	add a,30				; check if X diff is less than (-23)				;860d	c6 1e 
	jp m,CHECK_JUMPER_Y_13	; yes - too far - continue checking					;860f	fa 60 86
; -- collision of PLAYER and JUMPER
	ld a,(BAR_FLIP_FLAG)	; player unit bar state 							;8612	3a 1b 78 
	or a					; check not flipped (left up)						;8615	b7 
	jr nz,PLA_JUM_COLL_BAR_R; bar is flipped (right up)							;8616	20 38 
	jp PLA_JUM_COLL_BAR_L	; bar is not flipper (left up)						;8618	c3 1b 86 

;**************************************************************************************************
; Player and Jumper collision - bar is not flipped (left up)
; -- player unit bar is not flipped (left up)
PLA_JUM_COLL_BAR_L:
; -- exchange positions for 2 Jumpers
	ld a,(JUMPER_W_X_INT)	; JUMPER W(aiting) X position in pixels				;861b	3a 11 78 
	ld (JUMPER_X_INT),a		; store as JUMPER new X position 					;861e	32 15 78
; -- place JUMPER W(aiting) on the left side of Player Unit
	ld a,(PLAYER_X_INT)		; PLAYER X position in pixels						;8621	3a 10 78  
	ld (JUMPER_W_X_INT),a	; store as JUMPER W(aiting) new X position			;8624	32 11 78 
BOUNCE_JUMPERS:
	ld a,18					; startup Y position for JUMPER						;8627	3e 12 
	ld (JUMPER_Y_INT),a		; sore new Y position in lines (bottom up)			;8629	32 17 78
	call FLIP_JUMPER_VEL_Y_56	; invert Y velocity and add 56 (jump up)		;862c	cd 22 87 
	ld a,15					; startup Y position for JUMPER W(aiting) 			;862f	3e 0f 
	ld (JUMPER_W_Y_INT),a	; sore new Y position in lines (bottom up)			;8631	32 13 78
	ld a,(BAR_FLIP_FLAG)	; a - Player unit bar state 						;8634	3a 1b 78  
	xor $01					; flip bar to opposite state						;8637	ee 01 
	ld (BAR_FLIP_FLAG),a	; save new state of bar								;8639	32 1b 78 
	call PLAY_SND_LOW		; play low beep sound								;863c	cd 30 89 
	ld hl,(PLAYER_X_FRAC)	; PLAYER X position (with fraction)					;863f	2a 0f 78 
	call UPDATE_OFFSCREEN_BUFFERS	; update offscreen draw buffers 			;8642	cd 32 85
	ld a,(JUMPER_X_INT)		; JUMPER position X in pixels						;8645	3a 15 78 
	ld c,a					; store to c										;8648	4f 
	ld a,(JUMPER_Y_INT)		; JUMPER position Y in pixels						;8649	3a 17 78 
	ld b,a					; store to b										;864c	47 
	jp UPDATE_JUMPER_SPRITE	; update JUMPER VRAM address and sprite data in buf	;864d	c3 bb 86

;**************************************************************************************************
; Player and Jumper collision - bar is flipped (right up)
; -- player unit bar is flipped (right up)
PLA_JUM_COLL_BAR_R:
; -- exchange positions for 2 Jumpers
	ld a,(JUMPER_W_X_INT)	; JUMPER W(aiting) X position in pixels				;8650	3a 11 78 
	ld (JUMPER_X_INT),a		; store as JUMPER new X position					;8653	32 15 78 
; -- place JUMPER W(aiting) on the right side of Player Unit
	ld a,(PLAYER_X_INT)		; PLAYER X position in pixels						;8656	3a 10 78 
	add a,18				; add 18px - JUMPER must be placed on right side	;8659	c6 12 
	ld (JUMPER_W_X_INT),a	; store as JUMPER W(aiting) new X position			;865b	32 11 78 
; -- 
	jr BOUNCE_JUMPERS		; bounce Jumpers and flip Player Unit Bar 			;865e	18 c7 

;**************************************************************************************************
; Jumper and Floor collision 
; Jumper is Dead if Y position is less or equal to 13
CHECK_JUMPER_Y_13:	
	ld a,b					; JUMPER position Y in pixels					;8660	78 	x 
	cp 13					; check if less than 13 px						;8661	fe 0d 
	jr nc,CHECK_MAX_Y		; no - continue check (max Y position)			;8663	30 07 

;*******************************************************************************************
; JUMPER is Dead
; Landed on Jumper W(aiting) -- X and Y positions difference beetween both JUMPERs is less than 7 px
; Landed on floor - Y position of JUMPER is less than 13 px
JUMPER_IS_DEAD:
	pop hl					; take out return address							;8665	e1 
	ld a,1					; a - Game Event - Player Died						;8666	3e 01 
	ld (GAME_EVENT),a		; store to Game Event variable						;8668	32 18 78 
	ret						; return to parent caller ---------------			;866b	c9 

; IN: a - JUMPER position Y in pixels (bottom up)
CHECK_MAX_Y:
	cp 63					; check if Y >= 63 (maximum)						;866c	fe 3f 
	jr c,CHECK_MIDDLE_X		; no - continue checking							;866e	38 09

; -- set maximum Y position
	ld a,63					; 63 - max Y position								;8670	3e 3f 
	ld b,a					; store to b - JUMPER Y position					;8672	47 
	ld (JUMPER_Y_INT),a		; store as JUMPER position Y in pixels				;8673	32 17 78 
	call FLIP_JUMPER_VEL_Y	; flip Y velocity for JUMPER						;8676	cd fb 86 

; -- b - Y position less than 63 (max)
CHECK_MIDDLE_X:
	ld a,b					; a - JUMPER position Y in pixels					;8679	78 
	cp 43					; check Y position 									;867a	fe 2b 
	jr z,CHECK_MIN_X_43				; Y = 43 ;867c	28 5b 	( [ 
	jr c,CHECK_MIN_X_S		; Y < 43 - Stands constrains horizontal range 		;867e	38 1e 

; -- JUMPER Y position is bigger than 43 (above stands) - bounces from edge of screen
; -- check if JUMPER is at maximum left
	ld a,c					; JUMPER X position in pixels						;8680	79  
	or a					; check if less than 0								;8681	b7 
	jp p,CHECK_MAX_X		; no - skip horizontal bounce - check right max		;8682	f2 8f 86 

; -- JUMPER X position <= 0 so bounce
	xor a					; 0 - minimum X position for JUMPER					;8685	af 
	ld c,a					; replace c with new value							;8686	4f
	ld (JUMPER_X_INT),a		; store as JUMPER new X position X in pixels		;8687	32 15 78
	call FLIP_JUMPER_VEL_X	; invert X velocity value							;868a	cd 09 87
	jr UPDATE_JUMPER_SPRITE	; update VRAM addres and sprite in buffer			;868d	18 2c 

; -- JUMPER X position > 0 (and < 127)
CHECK_MAX_X:
	cp 121					; check if X < 121 (max X position)					;868f	fe 79
	jr c,UPDATE_JUMPER_SPRITE	; yes - update VRAM addres and sprite in buffer	;8691	38 28 

; -- X >= 121 - set max X position and bounce
	ld a,121				; 121 - maximum X position for JUMPER				;8693	3e 79 
	ld c,a					; replace c with new value							;8695	4f 
	ld (JUMPER_X_INT),a		; store as JUMPER new X position in pixels			;8696	32 15 78 
	call FLIP_JUMPER_VEL_X	; invert X velocity value							;8699	cd 09 87 
	jr UPDATE_JUMPER_SPRITE	; update VRAM addres and sprite in buffer			;869c	18 1d 

; -- JUMPER Y position < 43 - bounces from Stands
; -- check if JUMPER is at maximum left
CHECK_MIN_X_S:
	ld a,c					; a - JUMPER X position in pixels					;869e	79 
	cp 8					; check if X < 8 (min X position)					;869f	fe 08 
	jr nc,CHECK_MAX_X_S		; no - check if maximum X							;86a1	30 0b 

; -- X < 8 - set min X position and bounce	
	ld a,8					; 8 - minimum X position for JUMPER 				;86a3	3e 08
	ld c,a					; replace c with new value							;86a5	4f
	ld (JUMPER_X_INT),a		; store as JUMPER new X position in pixels			;86a6	32 15 78 
	call FLIP_JUMPER_VEL_X	; invert X velocity value							;86a9	cd 09 87 
	jr UPDATE_JUMPER_SPRITE	; update VRAM addres and sprite in buffer			;86ac	18 0d 

; -- JUMPER Y position >= 8 - bounces from Stands
; -- check if JUMPER is at maximum right
CHECK_MAX_X_S:
	cp 113					; check if X < 113 (min X position)					;86ae	fe 71 
	jr c,UPDATE_JUMPER_SPRITE	; yes - update VRAM addres and sprite in buffer	;86b0	38 09 

; -- X > 113 - set max X position and bounce	
	ld a,113				; 113 - maximum X position for JUMPER				;86b2	3e 71 
	ld c,a					; replace c with new value							;86b4	4f 
	ld (JUMPER_X_INT),a		; store as JUMPER new X position in pixels			;86b5	32 15 78 
	call FLIP_JUMPER_VEL_X	; invert X velocity value							;86b8	cd 09 87
							; update VRAM addres and sprite in buffer

;*****************************************************************************************************
; Update JUMPER VRAM address and copy to buffer sprite data depend on X position
; IN - b - JUMPER Y position 
;      c - JUMPER X position
UPDATE_JUMPER_SPRITE:
	ld a,b					; JUMPER position Y in pixels						;86bb	78 
	call CALC_VRAM_ADDRESS	; calculate VRAM address (hl) 						;86bc	cd 98 85 
	ld (JUMPER_VADR),hl		; store new JUMPER VRAM address						;86bf	22 0d 78
	ld a,c					; JUMPER position X in pixels						;86c2	79 
	and $03					; pixel X position in byte screen (0..3)			;86c3	e6 03 
	ld b,a					; b - sprite variant depending on pixel shift		;86c5	47 
	inc b					; variant index (1..4)								;86c6	04 
	ld hl,SPR_JUMPER_S0-21	; address of sprite data table - 21 (size of data)	;86c7	21 11 81 
	ld de,21				; 21 bytes per sprite variant						;86ca	11 15 00 
UJS_NEXT:
	add hl,de				; calculate address of sprite data					;86cd	19 
	djnz UJS_NEXT			; repeat adding b times								;86ce	10 fd 
; -- copy sprite data to offscreen buffer
	ld de,SPR_BUF_JUMPER	; offscreen draw buffer address						;86d0	11 4e 7a 
	ld bc,21				; 21 bytes of sprite data to copy					;86d3	01 15 00 
	ldir					; copy to sprite buffer								;86d6	ed b0 
	ret						; ----------- End of Proc ------------------		;86d8	c9 

; -- JUMPER Y position = 43 
CHECK_MIN_X_43:
	ld a,c					; JUMPER X position in pixels						;86d9	79 
	or a					; check if X < 0									;86da	b7 
	jp p,CHECK_MAX_X_43		; no - check maximum X value 						;86db	f2 f3 86 
; -- JUMPER X position > 127 - end of right side of screen
	xor a					; a - reset JUMPER X position						;86de	af 

;*******************************************************************************************
; IN: a - new X position for JUMPER
; -- a - JUMPER X position
JUMPER_BOUNCE_A:
	ld c,a					; replace c with new value							;86df	4f 
	ld (JUMPER_X_INT),a		; store as JUMPER position X in pixels				;86e0	32 15 78 
	call FLIP_JUMPER_VEL_X	; flip X velocity value								;86e3	cd 09 87 
	ld a,c					; a - JUMPER X position								;86e6	79 

; -- a - JUMPER X position 
CHECK_MIN_MAX_X:
	cp 8					; check if X position < 8 (minimum)					;86e7	fe 08 
	call c,FLIP_JUMPER_VEL_Y_16	; yes - flip Y velocity and add 16 (bounce)		;86e9	dc 17 87 
	cp 114					; check if X position >= 114 (maximum)				;86ec	fe 72 
	call nc,FLIP_JUMPER_VEL_Y_16; yes - flip Y velocity and add 16 (bounce)		;86ee	d4 17 87  

; -- JUMPER X position in range (8..113)	
	jr UPDATE_JUMPER_SPRITE	; update VRAM addres and sprite in buffer			;86f1	18 c8 

CHECK_MAX_X_43:
	cp 121					; check if X position < 121 (maximum)				;86f3	fe 79 
	jr c,CHECK_MIN_MAX_X	; check if accelerated bounce needed				;86f5	38 f0

; -- JUMPER X position >= 121 - set maximum and bounce
	ld a,121				; 121 - maximum X position for JUMPER				;86f7	3e 79  
	jr JUMPER_BOUNCE_A		; set new X position and bounce						;86f9	18 e4 

;****************************************************************************************
; Changes sign of Y velocity for JUMPER sprite moves
FLIP_JUMPER_VEL_Y:
	ld de,(JUMPER_Y_VEL)	; JUMPER Y velocity									;86fb	ed 5b 22 78 
	ld hl,0					; 0 to subtract from								;86ff	21 00 00 
	or a					; clear Carry flag									;8702	b7 
	sbc hl,de				; negate velocity 									;8703	ed 52 
	ld (JUMPER_Y_VEL),hl	; store new Y velocity for JUMPER					;8705	22 22 78 
	ret						; ------------- End of Proc --------				;8708	c9 

;****************************************************************************************
; Changes sign of X velocity for JUMPER sprite moves
FLIP_JUMPER_VEL_X:
	ld de,(JUMPER_X_VEL)	; JUMPER X velocity									;8709	ed 5b 20 78 
	ld hl,0					; 0 to subtract from								;870d	21 00 00 
	or a					; clear Carry flag									;8710	b7 
	sbc hl,de				; negate velocity									;8711	ed 52 
	ld (JUMPER_X_VEL),hl	; store new X velocity for Jumping Man				;8713	22 20 78 
	ret						; ------------- End of Proc --------				;8716	c9 

;****************************************************************************************
; Changes sign of Y velocity for JUMPER sprite moves and adds 16 to it
FLIP_JUMPER_VEL_Y_16:
	call FLIP_JUMPER_VEL_Y	; change sing of Y velocity value					;8717	cd fb 86 
	ld de,16				; 16 - delta to add to velocity						;871a	11 10 00 
	add hl,de				; incrase velocity value							;871d	19 
	ld (JUMPER_Y_VEL),hl	; store new velocity								;871e	22 22 78 
	ret						; ------------ End of Proc ----------				;8721	c9 

;****************************************************************************************
; Changes sign of Y velocity for JUMPER sprite moves and adds 56 to it
FLIP_JUMPER_VEL_Y_56:
	call FLIP_JUMPER_VEL_Y	; change sing of Y velocity value					;8722	cd fb 86 
	ld de,56				; 56 - delta to add to velocity						;8725	11 38 00 
	add hl,de				; incrase velocity value							;8728	19 
	ld (JUMPER_Y_VEL),hl	; store new velocity								;8729	22 22 78 
	ret						; ------------ End of Proc ----------				;872c	c9 

;****************************************************************************************
; Plays long high note
PLAY_SND_HIGH:
	ld hl,511				; sound freq (half cycle time)						;872d	21 ff 01 
	ld bc,10				; sound length (cycles to play)						;8730	01 0a 00  

;****************************************************************************************
; Paly Sound Wave
; IN: bc - number of cycles to play (related to sound length)
;     hl - length of half cycle of sound (related to sound frequency)
PLAY_SND_WAVE:
	ld a,(IOLATCH_SHADOW)	; a - current IOLATCH value							;8733	3a 2b 78 
	ld d,a					; d - procedure parameter							;8736	57 
PSW_REPEAT:
	call PLAY_SND_CYCLE		; play 1 cycle of sound								;8737	cd 40 87 
	dec bc					; dec cycles countr									;873a	0b 
	ld a,c					; check if 0										;873b	79 
	or b					; a = b|c											;873c	b0 
	jr nz,PSW_REPEAT		; repeat until 0									;873d	20 f8 
	ret						; --------- End of Proc ------						;873f	c9 


;****************************************************************************************
; Play 1 sound cycle on Speaker
; IN: d - current IOLATCH value from shadow register
;     hl - half cycle length 
PLAY_SND_CYCLE:
	push bc					; save bc											;8740	c5 
; -- set (+) half cycle
	ld a,d					; a - current IOLATCH value							;8741	7a 
	xor SPEAKER_PINS		; invert Speaker Pins								;8742	ee 21 
	ld (IOLATCH),a			; store in hardware register						;8744	32 00 68 
; -- delay 
	push hl					; hl - delay counter - half cycle					;8747	e5 
	pop bc					; bc - value to countdown 							;8748	c1 
PSC_DELAY_1:
	dec bc					; dec delay counter									;8749	0b 
	ld a,c					; check if 0										;874a	79 
	or b					; a = b|c											;874b	b0 
	jr nz,PSC_DELAY_1		; jump until 0										;874c	20 fb 
; -- set (-) half cycle
	ld a,d					; a - oryginal Speaker Pins							;874e	7a 
	ld (IOLATCH),a			; store in hardware register						;874f	32 00 68  
; -- delay	
	push hl					; hl - delay counter - half cycle					;8752	e5 
	pop bc					; bc - value to countdown 							;8753	c1 
PSC_DELAY_2:
	dec bc					; dec delay counter									;8754	0b 
	ld a,c					; check if 0										;8755	79 
	or b					; a = b|c											;8756	b0 
	jr nz,PSC_DELAY_2		; jump until 0										;8757	20 fb 
; -- end of proc
	pop bc					; restore bc 										;8759	c1 
	ret						;----------- End of Proc							;875a	c9 

;************************************************************************************************
; Predefined table with points player can earn for collect Baloon 
TAB_POINTS:
	defb	$10,$30,$50		; Note: values stored in BCD format					;875b	10 30 50 

;************************************************************************************************
; Check if there is collision beetween JUMPER and any BALLON
CHECK_BALOON_COLLISION:
; -- check Y position and return if too small to have collision
	ld a,(JUMPER_Y_INT)		; JUMPER position Y in pixels						;875e	3a 17 78 
	cp 47					; check if Y < 47 									;8761	fe 2f 
	ret c					; yes - no chance for collision with Balloon		;8763	d8 	 
; -- determine sprite mask variant base on pixel in byte shift
	ld a,(JUMPER_X_INT)		; current position X in pixels						;8764	3a 15 78
	and $03					; pixel X position in byte screen (0..3)			;8767	e6 03 
	inc a					; index range (1..4)								;8769	3c 
	ld b,a					; sprite variant index 1..4							;876a	47 
	ld de,21				; 21 bytes per sprite								;876b	11 15 00 
	ld hl,SPR_JUMPER_S0_MASK-21 ; address of table with sprite masks -21		;876e	21 65 81 
CC_ADDOFFSET:
	add hl,de				; add 21 bytes - next sprite mask					;8771	19 
	djnz CC_ADDOFFSET		; calculate sprite mask address from index			;8772	10 fd 
	ex de,hl				; sprite mask address into de						;8774	eb 
; -- check overlap with anything but background
	ld hl,(JUMPER_VADR)		; JUMPER VRAM address								;8775	2a 0d 78 
	ld b,7					; 7 lines - sprite/mask height						;8778	06 07 
CC_CHECK_LINE:
	ld c,3					; 3 bytes - sprite/mask width (12px)				;877a	0e 03 
CC_CHECK_BYTE:
	ld a,(de)				; a - mask byte										;877c	1a 
	cpl						; inverse bits - 1 means foreground pixel			;877d	2f 
	and (hl)				; check overlap on screen							;877e	a6 
	jr nz,COLL_DETECTED		; there is collision with something					;877f	20 0e 
; -- no collision 
	inc hl					; next screen byte									;8781	23 
	inc de					; next mask byte									;8782	13 
	dec c					; decrement bytes in line counter 					;8783	0d 
	jr nz,CC_CHECK_BYTE		; repeat for all 3 bytes in line					;8784	20 f6 
	push de					; save de											;8786	d5 
	ld de,29				; 29 bytes per line (3 covered in loop)				;8787	11 1d 00 
	add hl,de				; addres of first sprite byte in next line			;878a	19 
	pop de					; restore de - next mask byte						;878b	d1 
	djnz CC_CHECK_LINE		; repeat for all 7 lines							;878c	10 ec
	ret						; no collision detected --- End of Proc ---			;878e	c9 

;*********************************************************************************************
; JUMPER Collision detected 
; IN: hl - screen address where collision detected
COLL_DETECTED:
; -- calculate byte offset from left edge of screen
	ld a,l					; a - low byte of collision screen address			;878f	7d
	and $1f					; we're only interested in range (0..31) 			;8790	e6 1f 
	ld c,a					; X coord (in screen bytes)							;8792	4f 
	ld b,0					; bc - X coord 	- byte in this line					;8793	06 00 

; -- check if collision was in Baloons Blue Groups screen area
	ld de,VRAM+(12*32)+0	; screen coord (0,12)px [$7180]						;8795	11 80 71  
	or a					; clear Carry flag									;8798	b7 
	push hl					; save hl - collision screen address				;8799	e5 
	sbc hl,de				; check if collision with Balloon Blue 				;879a	ed 52 
	pop hl					; restore hl - collision screen address				;879c	e1 
	jr c,COLL_CHECK_YEL		; no - check next Balloon Group						;879d	38 37 

; -- Carry = 0 means collision addres > (0,12)px coordinate - only Blue Ballon in this area 
	ld hl,SPR_BUF_BALOONS_BLU+32	; 2nd line in Ballons Blue buffer			;879f	21 a0 79
	call DELETE_BALLOON		; find balloon and remove it from sprite buffer		;87a2	cd f4 87
	ld a,$80				; Balloons Blue Group changed Game Event			;87a5	3e 80 

SET_BAL_CHANGED:
; -- raise Event to handle
	ld (GAME_EVENT),a		; store to Game Event variable						;87a7	32 18 78 

; -- set return address to Interrupt Exit proc 
	pop hl					; take out current return address					;87aa	e1 
	ld hl,INT_EXIT			; hl address of Interrupt Exit routine				;87ab	21 ef 82 
	push hl					; set Exit routine as return address				;87ae	e5 

; -- update cleanup variables for both JUMPER sprites
	ld hl,(JUMPER_W_VADR)	; JUMPER W(aiting) VRAM address						;87af	2a 0b 78 
	ld (JUMPER_W_CLR_VADR),hl	; store address for clear routines				;87b2	22 24 78 
	ld hl,(JUMPER_VADR)		; JUMPER VRAM address								;87b5	2a 0d 78 
	ld (JUMPER_CLR_VADR),hl	; store address for clear routines					;87b8	22 27 78 
	ld a,(JUMPER_W_X_INT)	; JUMPER W(aiting) X position in pixels				;87bb	3a 11 78 
	ld (JUMPER_W_CLR_X_INT),a	; store X position for clear routines			;87be	32 26 78 
	ld a,(JUMPER_X_INT)		; JUMPER X position X in pixels						;87c1	3a 15 78 
	ld (JUMPER_CLR_X_INT),a	; store X position for clear routines				;87c4	32 29 78 

; -- redraw Balloons Group which changed
	ld a,(GAME_EVENT)		; a - Balloons Group changed Game Event				;87c7	3a 18 78 
	and $7f					; mask out bit 7 - range 0..3 						;87ca	e6 7f 
	jp z,REDRAW_BALOONS_BLU ; was $80 - redraw Balloons Blue Group 				;87cc	ca 7d 83 
	dec a					; check if was $81									;87cf	3d 
	jp z,REDRAW_BALOONS_YEL	; was #81 - redraw Balloons Yellow Group 			;87d0	ca 70 83 
	jp REDRAW_BALOONS_RED	; was $82 - redraw Balloons Red Group 				;87d3	c3 63 83 

COLL_CHECK_YEL:
; -- check if collision was in Balloons Yellow Group screen area
	ld de,VRAM+(6*32)+0		; screen coord (0,6)px								;87d6	11 c0 70 
	or a					; clear Carry flag									;87d9	b7 
	push hl					; save hl - collision screen address	 			;87da	e5 
	sbc hl,de				; check if collision with Balloon Yellow			;87db	ed 52
	pop hl					; restore hl - collision screen address				;87dd	e1 
	jr c,COLL_CHECK_RED		; no - must be Balloons Red Group 					;87de	38 0a 

; -- Carry = 0 means collision addres > (0,6)px coordinate - only Yellow Balloons in this area 
	ld hl,SPR_BUF_BALOONS_YEL+32	; 2nd line in Balloons Blue buffer			;87e0	21 20 79 
	call DELETE_BALLOON		; find balloon and remove it from sprite buffer		;87e3	cd f4 87  
	ld a,$81				; Balloons Yellow Group changed Game Event			;87e6	3e 81 
	jr SET_BAL_CHANGED		; store Game Event and continue						;87e8	18 bd 

COLL_CHECK_RED:
	ld hl,SPR_BUF_BALOONS_RED+32	; 2nd line in Balloons Red buffer			;87ea	21 a0 78 
	call DELETE_BALLOON		; find balloon and remove it from sprite buffer		;87ed	cd f4 87 
	ld a,$82				; Balloons Red Group changed Game Event				;87f0	3e 82 
	jr SET_BAL_CHANGED		; store Game Event and continue						;87f2	18 b3 

;*****************************************************************************************
; IN: hl - address of 2nd line in Balloons Group buffer	
;     bc - X coord in screen bytes 
DELETE_BALLOON:
	add hl,bc				; hl - address in buffer of collision point			;87f4	09 
	ld a,c					; a - byte index in line (X coord)					;87f5	79 
	or a					; check if 0										;87f6	b7 
	jr z,CLEAR_BALLOON_AREA	; yes - skip searching for Balloon left edge		;87f7	28 07 
; -- find left edge of collided Balloon sprite
DB_CHECK_NEXT:
	ld a,(hl)				; a - byte of sprite data							;87f9	7e 
	dec hl					; adres of next left byte							;87fa	2b
	and $f0					; check 2 left pixels of byte 						;87fb	e6 f0
	jr nz,DB_CHECK_NEXT		; not empty - check next byte						;87fd	20 fa
	inc hl					; hl - address of left edge of Balloon sprite		;87ff	23 
; -- hl - address of collided Balloon sprite 
CLEAR_BALLOON_AREA:
	ld bc,32				; 32 bytes in sprite line							;8800	01 20 00
	or a					; clear Carry flag for substract					;8803	b7 
	sbc hl,bc				; now hl points to start of sprite first line		;8804	ed 42 
	ld de,29				; 29 bytes per line (3 covered in loop)				;8806	11 1d 00 
	xor a					; 0 - 4 green (background) pixels					;8809	af 
	ld b,4					; 4 lines - sprite height							;880a	06 04 
DB_CLEAR_NEXT_LINE:
	ld c,3					; 3 bytes (12px) sprite width						;880c	0e 03 
DB_CLEAR_NEXT_BYTE:
	ld (hl),a				; clear pixels in buffer							;880e	77
	inc hl					; address of next byte in buffer					;880f	23 
	dec c					; dec byte counter									;8810	0d 
	jr nz,DB_CLEAR_NEXT_BYTE; clear next byte in this line						;8811	20 fb 
	add hl,de				; add 29 bytes - next sprite line 					;8813	19 
	djnz DB_CLEAR_NEXT_LINE	; repeat for 4 lines								;8814	10 f6 
	ret						; ----------- End of Proc -----------				;8816	c9 


;********************************************************************************************
; Game INT Handler	
; Update Game Score after player collected Baloon
INT_BALOON_COLLECTED:
	push ix					; save ix											;8817	dd e5 
; -- determine score points base on which Balloon was Collected
	ld a,(GAME_EVENT)		; a - Balloon Collected Event ($80,$81,$82)			;8819	3a 18 78 
	and $7f					; ignore 7th bit - (index 0..2)						;881c	e6 7f 
	ld c,a					; c - table offset low byte 						;881e	4f 
	ld b,0					; bc - table offset									;881f	06 00 
	ld hl,TAB_POINTS		; hl - address of predefined table (10,30,50)		;8821	21 5b 87 
	add hl,bc				; calculate final addres with points				;8824	09 
	ld a,(hl)				; a - points to add to score (BCD format)			;8825	7e 
; -- add earned Score (BCD format) and draw it
	ld hl,(CUR_SCORE)		; current score value								;8826	2a 00 78
	add a,l					; add points										;8829	85 
	daa						; correction for BCD format							;882a	27 
	ld l,a					; store to l										;882b	6f 
	ld a,0					; 0 value - add only CY flag (if any)				;882c	3e 00 
	adc a,h					; add Carry flag									;882e	8c 
	daa						; correction for BCD format							;882f	27
	ld h,a					; store to h - hl = new score						;8830	67
	ld (CUR_SCORE),hl		; save new score value								;8831	22 00 78 
	call DRAW_CURRENT_SCORE	; draw updated score on screen						;8834	cd 72 7e 
; -- reset Game Events - nothing to handle
	xor a					; 0 - no game events to handle						;8837	af 
	ld (GAME_EVENT),a		; store to Game Event variable						;8838	32 18 78 
	ld bc,$4fff				; delay counter -> 532 461 T -> 148.75 ms 			;883b	01 ff 4f 
	jp INT_EXIT_DELAY		; ------ exit INT proc with Delay ----				;883e	c3 9f 88 

;****************************************************************************
; Game interrupt proc - Player Died variant
; Clears both JUMPER sprites from screen, redraws Player Unit, JUMPER W(aiting) and Death sprite 
INT_GAME_DEATH:
	push ix					; save ix											;8841	dd e5 
; -- clear both Man sprites from screen	
	call CLEAR_JUMPER_SPRITES	; clear JUMPER sprite at old position			;8843	cd f9 82 
; -- draw Player Unit on screen
	ld hl,(PLAYER_POS_VADR)	; PLAYER VRAM address 								;8846	2a 09 78 
	ld ix,SPR_BUF_PLAYER	; PLAYER sprite offscreen buffer					;8849	dd 21 01 7a
	ld b,8					; 8 lines - sprite height							;884d	06 08 
	ld c,7					; 7 bytes - sprite width (28px) 					;884f	0e 07 
	call DRAW_SPRITE		; draw sprite 										;8851	cd 71 7f 
; -- draw JUMPER W(aiting) on screen
	ld hl,(JUMPER_W_VADR)	; JUMPER W(aiting) VRAM address						;8854	2a 0b 78 
	ld ix,SPR_BUF_JUMPER_W	; JUMPER W(aiting) offscreen buffer					;8857	dd 21 39 7a 
	ld b,7					; 7 lines - sprite height							;885b	06 07 
	ld c,3					; 3 bytes - sprite width (12px)						;885d	0e 03 
	call DRAW_SPRITE_T		; draw sprite with transparency						;885f	cd 8c 7f  
; -- calculate Player Death screen position
	ld a,(JUMPER_X_INT)		; JUMPER X position in pixels						;8862	3a 15 78  
	srl a					; a = a *2											;8865	cb 3f 
	srl a					; a = a *2 (total a*4 pikels/byte)					;8867	cb 3f 
	add a,$c0				; low byte of VRAM - line 54 (top-down)				;8869	c6 c0 
	ld l,a					; store in l										;886b	6f 
	ld h,$76				; hl = VRAM address (0,54) + a*4					;886c	26 76 
	push hl					; address VRAM to draw Player Death					;886e	e5
	ld (PLAYER_DEATH_VADR),hl; store new address for PLAYER DEATH sprite		;886f	22 2d 78 
; -- clear pixels of death sprite from screen (leave player unit below)
	ld de,SPR_DEATH_MASK	; Death sprite mask to draw							;8872	11 b0 88 
	ld b,3					; 3 lines - sprite height							;8875	06 03 
IGD_NEXT_LINE:
	ld c,3					; 3 bytes - sprite width (12px)						;8877	0e 03 
IGD_NEXT_BYTE:
	ld a,(de)				; a - mask byte										;8879	1a 
	and (hl)				; apply mask - clear foreground pixels				;887a	a6 
	ld (hl),a				; draw on screen									;887b	77 
	inc hl					; next byte on screen								;887c	23 
	inc de					; next byte from sprite mask						;887d	13 
	dec c					; dec bytes counter									;887e	0d 
	jr nz,IGD_NEXT_BYTE		; repeat for 3 bytes								;887f	20 f8 
	push de					; save de											;8881	d5 
	ld de,29				; 29 bytes per line (3 covered in loop)				;8882	11 1d 00 
	add hl,de				; hl - next line on screen							;8885	19 
	pop de					; restore de										;8886	d1 
	djnz IGD_NEXT_LINE		; repeat for 3 lines								;8887	10 ee 
; -- draw Death sprite on screen	
	pop hl					; address VRAM to draw sprite						;8889	e1 
	ld ix,SPR_DEATH			; Player Death sprite (12x3)px						;888a	dd 21 a7 88 
	ld b,3					; 3 lines - sprite height							;888e	06 03 
	ld c,3					; 3 bytes - sprite width (12px)						;8890	0e 03  
	call DRAW_SPRITE_T		; draw sprite with transparency						;8892	cd 8c 7f
; -- draw left and right stands on screen
	call DRAW_STANDS_LR		; draw both stands (left and right)					;8895	cd b2 83 
; -- clear game events
	xor a					; 0 - no Game Events to handle						;8898	af 
	ld (GAME_EVENT),a		; store to Game Event variable						;8899	32 18 78 
;-- delay 	
	ld bc,511				; delay counter -> 3.7ms 13293T						;889c	01 ff 01 
;**************************************************************
; Delay routine time = (26T * bc) + 7T --> (7263.5 * bc) + 1955.6 ns
; IN: bc - delay counter
INT_EXIT_DELAY:
	dec bc					; dec delay counter	         - 6T					;889f	0b 
	ld a,b					; check bc			         - 4T					;88a0	78 
	or c					; a = b|c			         - 4T					;88a1	b1 
	jr nz,INT_EXIT_DELAY	; repeat until 0 			 - 12T					;88a2	20 fb 
	jp INT_EXIT				; clean stack and exit interrupt handler			;88a4	c3 ef 82 

;***********************************************************
; Player Death Sprite (12x3)px (3x3) bytes
SPR_DEATH:
	defb	$00,$40,$00		;88a7	00 40 00 			
	defb	$40,$45,$40		;88aa	40 45 40			
	defb	$55,$55,$40		;88ad	55 55 40 			

;************************************************************
; Player Death Sprite mask (12x3)px (3x3 bytes)
SPR_DEATH_MASK:
	defb	$ff,$3f,$ff		;88b0	ff 3f ff 			
	defb	$3f,$30,$3f		;88b3	3f 30 3f 			
	defb	$00,$00,$3f		;88b6	00 00 3f

;***********************************************************************************************
; Game Interrupt Proc - Cleanup variant
; Erase from screen Player Unit and Death, area where is last Life Icon. 
; Reset position and draw Player Unit and JUMPER W(aiting). Finally redraw Stands and clear Dirty Flag 
INT_CLEANUP:
	push ix					; save ix											;88b9	dd e5  
; -- erase Player Unit sprite from screen
	ld hl,(PLAYER_POS_VADR)	; current player position on screen					;88bb	2a 09 78 
	xor a					; clear Carry flag and 0 as 4 green pixels			;88be	af 
	ld de,32				; 32 bytes per screen line							;88bf	11 20 00
	sbc hl,de				; address of 1 line above player unit				;88c2	ed 52 
	ld de,25				; 25 bytes as line increment (7 in loop)			;88c4	11 19 00 
	ld b,9					; 9 lines to clear - sprite height					;88c7	06 09 
GIAH_CLR_NEXT_LINE:
	ld c,7					; 7 bytes (28px) to clear - sprite width			;88c9	0e 07
GIAH_CLR_NEXT_BYTE:
	ld (hl),a				; clear (draw green) 4 pixels on screen				;88cb	77 
	inc hl					; next VRAM address									;88cc	23 
	dec c					; decrement byte counter							;88cd	0d 
	jr nz,GIAH_CLR_NEXT_BYTE; repeat for all 7 bytes							;88ce	20 fb  
	add hl,de				; adres of left pixel in next line 					;88d0	19 
	djnz GIAH_CLR_NEXT_LINE	; repeat for all 9 lines							;88d1	10 f6 

; -- erase Player Death sprite from screen 
	ld hl,(PLAYER_DEATH_VADR); Player Death VRAM address 						;88d3	2a 2d 78 
	xor a					; 0 as 4 green pixels								;88d6	af 
	ld de,29				; 29 bytes for line increment (3 in loop)			;88d7	11 1d 00 
	ld b,3					; 3 lines - sprite height							;88da	06 03 
GIAH_CLR_NEXT_LINE2:
	ld c,3					; 3 bytes - sprite width (12px)						;88dc	0e 03 
GTAH_CLR_NEXT_BYTE2:
	ld (hl),a				; clear (draw green) 4 pixels on screen				;88de	77 
	inc hl					; next VRAM address									;88df	23 
	dec c					; decrement byte counter							;88e0	0d 
	jr nz,GTAH_CLR_NEXT_BYTE2	; repeat for all 3 bytes						;88e1	20 fb 
	add hl,de				; address of left pixel in next line				;88e3	19 
	djnz GIAH_CLR_NEXT_LINE2; repeat for all 3 lines							;88e4	10 f6 

; -- reset dirty flag - screen is clean	
	xor a					; 0 - screen is clean								;88e6	af 
	ld (SCR_DIRTY_FLAG),a	; reset dirty flag									;88e7	32 2c 78 

; -- reinitialize Player Unit position and draw on screen	
	ld hl,VRAM+(49*32)+13   ; screen coord (52,49)px [$762d]					;88ea	21 2d 76
	ld (PLAYER_POS_VADR),hl	; store coord as current							;88ed	22 09 78
	ld ix,SPR_BUF_PLAYER	; player unit sprite from buffer 					;88f0	dd 21 01 7a 
	ld b,8					; 8 lines - sprite height							;88f4	06 08 
	ld c,7					; 7 bytes - sprite width (28px)						;88f6	0e 07 
	call DRAW_SPRITE		; draw player sprite								;88f8	cd 71 7f 

; -- draw JUMPER W(aiting) sprite on screen
	ld hl,(JUMPER_W_VADR)	; JUMPER W(aiting) VRAM address						;88fb	2a 0b 78 
	ld ix,SPR_BUF_JUMPER_W	; JUMPER W(aiting) sprite buffer					;88fe	dd 21 39 7a 
	ld b,7					; 7 lines - sprite height							;8902	06 07 
	ld c,3					; 3 bytes - sprite width (12px)						;8904	0e 03 
	call DRAW_SPRITE_T		; draw sprite with transparency						;8906	cd 8c 7f 

; -- clear (draw red) screen area next to Life Icon sprites
	ld a,(LIFE_COUNTER)		; a - life counter									;8909	3a 2a 78 
	dec a					; decrement by 1									;890c	3d 
	sla a					; lives left * 2 bytes width sprite					;890d	cb 27
	ld c,a					; c - X offset on screen for Life Icon to delete	;890f	4f
	ld b,0					; bc - offset on screen								;8910	06 00 
	ld hl,VRAM+(57*32)+0 	; base VRAM address at coord (0,57)px [$7720]		;8912	21 20 77 
	add hl,bc				; VRAM address of area to cleanup					;8915	09 
	ld de,30				; de - 30 bytes per line (2 covered in loop)		;8916	11 1e 00 
	ld a,%11111111			; a - 4 red pixels									;8919	3e ff 
	ld b,7					; 7 lines - sprite height							;891b	06 07 
GIAH_CLR_NEXT_LINE3:
	ld c,2					; 2 bytes (8px) - sprite width						;891d	0e 02 
GTAH_CLR_NEXT_BYTE3:
	ld (hl),a				; draw 4 red pixels									;891f	77 
	inc hl					; next screen byte									;8920	23
	dec c					; decrement bytes counter							;8921	0d 
	jr nz,GTAH_CLR_NEXT_BYTE3	; repeat for all 2 bytes (8px)					;8922	20 fb 
	add hl,de				; address of next screen line						;8924	19 
	djnz GIAH_CLR_NEXT_LINE3; repeat for all 7 lines							;8925	10 f6 

; -- darw left and right Stand on screen
	call DRAW_STANDS_LR		; redraw left and right stands						;8927	cd b2 83 

; -- delay ~150 ms ----
	ld bc,$4fff				; delay counter (532461T) (148.75 ms) 				;892a	01 ff 4f 
	jp INT_EXIT_DELAY		; ------ wait delay and return						;892d	c3 9f 88

;******************************************************************************************
; Play short low note sound
; Played when jumped down. Either on floor on trampoline
PLAY_SND_LOW:
	ld hl,1023				; sound freq (half cycle time)						;8930	21 ff 03  
	ld bc,3					; sound length (cycles to play)						;8933	01 03 00
	jp PLAY_SND_WAVE		; ----- End of proc ----							;8936	c3 33 87

;**************************************************************************************
; Play Start Game Melody
; Plays records contains 2 bytes each - tone byte and duration byte
; Bytes these are indexes to tables with predefined values of duration and frequency (half period time)
; of waves produced.
PLAY_MEL_START:
	ld hl,MELODY_GAME_START	; Game Start Melody data 							;8939	21 0e 8a 
	ld b,19					; 19 notes to play									;893c	06 13 
PLAY_MELODY:
	ld d,(hl)				; d - tone byte										;893e	56
	inc hl					; next address in note definition					;893f	23 
	ld e,(hl)				; e - note duration									;8940	5e 
	dec e					; dec e												;8941	1d 
	inc hl					; hl - address of next note to play					;8942	23 
	call PLAY_SND_NOTE		; play note or pause depending on d,e				;8943	cd 50 89 
	djnz PLAY_MELODY		; repeat for all notes								;8946	10 f6 
	ret						; ---------- End of Proc -------					;8948	c9 

;**************************************************************************************
; Play Game Over Melody
; Just define hl to points to last 9 notes of main melody and use PLAY_MELODY code
PLAY_MEL_GAME_OVER:
	ld hl,MELODY_GAME_OVER	; Game Over Melody									;8949	21 22 8a
	ld b,9					; 9 notes to play									;894c	06 09 
	jr PLAY_MELODY			; play melody and return							;894e	18 ee 

;***************************************************************************************
; Plays one Sound/Note from predefined tables
; IN: e - note length byte (as index from defined table)
;     d - note frequency byte (as index from defined table) - 0 means pause note
PLAY_SND_NOTE:
	push hl					; save hl											;8950	e5 
	push de					; save de											;8951	d5 
	push bc					; save bc											;8952	c5  
; -- determine sound (or pause) length 
	ld a,e					; note length byte (as table index)					;8953	7b 
	dec a					; valid values 0..xx								;8954	3d 
	push af					; save a 											;8955	f5 
; -- determine sound frequency (0 means pause note)
	ld a,d					; note frequency byte (as table index)				;8956	7a 
	or a					; check if pause note to play						;8957	b7 
	jr z,PLAY_PAUSE_NOTE	; yes - play pause note								;8958	28 36 
; -- valid note
	dec a					; valid table index 0..xx							;895a	3d 
	sla a					; a = a * 2	- 16bit freq values						;895b	cb 27 
	ld c,a					; c - offset for current sound/note					;895d	4f 
	xor a					; a - 0 											;895e	af  
	ld b,a					; bc - offset for note freq 						;895f	47 
	pop af					; a - offset for note length  						;8960	f1 
; -- get frequency (half period time) for current note
	ld hl,TAB_SND_FREQ		; table with frequency related values				;8961	21 a8 89 
	add hl,bc				; address of freq for current sound					;8964	09 
	ld e,(hl)				; e - low byte of frequency							;8965	5e 
	inc hl					; points to high byte of data						;8966	23 
	ld d,(hl)				; de - sound frequency								;8967	56 
	push de					; de - sound frequency (half period time)			;8968	d5 
; -- get duration for current note	
	ld hl,TAB_SND_DUR_BASE	; sound length table								;8969	21 e6 89 
	srl c					; bc - offset * 2									;896c	cb 39
	add hl,bc				; address of of current sound length				;896e	09 
	ld e,(hl)				; e - sound length									;896f	5e 
	ld d,0					; de - sound length									;8970	16 00 
; -- calculate sound 
	ld hl,TAB_SND_DUR_MUL	; table with sound length multiplers				;8972	21 05 8a 
	ld c,a					; bc - offset to sound length factor				;8975	4f 
	add hl,bc				; hl - address of sound length factor				;8976	09 
	ld b,(hl)				; b - sound length multiply factor					;8977	46 
; -- calculate sound length -> hl = b * de
	push de					; sound base length									;8978	d5 
	pop hl					; copy de to hl										;8979	e1 
PSN_MULTIPLY:
	add hl,de				; hl = de * b (sound length)						;897a	19 
	djnz PSN_MULTIPLY		; keep adding hl+de (b times)						;897b	10 fd 
	push hl					; copy sound length to bc							;897d	e5
	pop bc					; bc - sound length (cycles to play)				;897e	c1 
	pop hl					; hl - sound freq (half cycle time)					;897f	e1 
;-- play sound (hl freq, bc time)
PSN_PLAY_CYCLE:
	ld a,(IOLATCH_SHADOW)	; a - current IOLATCH value							;8980	3a 2b 78 
	ld d,a					; d - procedure parameter							;8983	57 
	call PLAY_SND_CYCLE		; play 1 cycle of sound								;8984	cd 40 87 
	dec bc					; dec cycle counter									;8987	0b 
	ld a,c					; check if 0										;8988	79 
	or b					; a = b|c											;8989	b0 
	jr nz,PSN_PLAY_CYCLE	; repeat until 0									;898a	20 f4 
PLAY_SND_EXIT:
	pop bc					; restore bc										;898c	c1 
	pop de					; restore de										;898d	d1 
	pop hl					; restore hl										;898e	e1 
	ret						; ---------- End of Proc							;898f	c9 

;***************************************************************************************
; Plays Pause (silent) Sound/Note
; IN: a (on stack) - note duration byte (as index from defined table)
;     bc,de,hl saved on stack
PLAY_PAUSE_NOTE:
	pop af					; a - note length byte (as index)					;8990	f1 
	ld c,a					; c - offset to note length table					;8991	4f 
	xor a					; a = 0												;8992	af 
	ld b,a					; bc - offset to note length table					;8993	47 
	ld hl,TAB_SND_DUR_MUL	; table with sound length multiplers				;8994	21 05 8a
	add hl,bc				; hl - address of sound length factor				;8997	09 
	ld b,(hl)				; b - sound length multiply factor					;8998	46 
	ld hl,01936h			; constant for base length							;8999	21 36 19 
; -- calculate sound length -> hl = b * de
	push hl					; pause base length									;899c	e5 
	pop de					; copy hl to de										;899d	d1 
PPN_MULTIPLY:
	add hl,de				; hl = de * b (pause length)						;899e	19 
	djnz PPN_MULTIPLY		; keep adding hl+de (b times)						;899f	10 fd 
; -- wait calculated delay as if this was note
PPN_FAKE_PLAY:
	dec hl					; dec delay counter									;89a1	2b 
	ld a,l					; check if 0										;89a2	7d 
	or h					; a = h|l											;89a3	b4 
	jr nz,PPN_FAKE_PLAY		; repeat until 0									;89a4	20 fb 
	jr PLAY_SND_EXIT		; jum to proc exit with restore bc,de,hl			;89a6	18 e4 


;***************************************************************************
; Sound Data - sound frequency (half period time) table - 16 bit values
; Bigger value means lower sound note
TAB_SND_FREQ:
	defw	$0272			;89a8	72 02
	defw	$024f			;89aa	4f 02 
	defw	$022e			;89ac	2e 02 
	defw	$020e			;89ae	0e 02 
	defw	$01f1			;89b0	f1 01 
	defw	$01d5			;89b2	d5 01 
	defw	$01b7			;89b4	b7 01
	defw	$019e			;89b6	9e 01 
	defw	$0186			;89b8	86 01
	defw	$0170			;89ba	70 01  
	defw	$015b			;89bc	5b 01 
	defw	$0148			;89be	48 01 
	defw	$0135			;89c0	35 01 
	defw	$0123			;89c2	23 01 
	defw	$0113			;89c4	13 01 
	defw	$0103			;89c6	03 01 
	defw	$00f4			;89c8	f4 00 
	defw	$00e6			;89ca	e6 00 
	defw	$00d9			;89cc	d9 00 
	defw	$00cd			;89ce	cd 00
	defw	$00c1			;89d0	c1 00
	defw	$00b6			;89d2	b6 00
	defw	$00ab			;89d4	ab 00 
	defw	$00a1			;89d6	a1 00 
	defw	$0098			;89d8	98 00 
	defw	$008f			;89da	8f 00 
	defw	$0087			;89dc	87 00
	defw	$007f			;89de	7f 00 
	defw	$0078			;89e0	78 00 
	defw	$0070			;89e2	70 00 
	defw	$006a			;89e4	6a 00

;****************************************************************************************************
; Sound Data - base sound length table 
; This values multiplied by factor (TAB_SND_DUR_MUL) determine time of played notes
; Sound length must be adjusted for every note because higher note wave "plays faster"
TAB_SND_DUR_BASE:
	defb	$0a				;89e6	0a 
	defb	$0b				;89e7	0b 
	defb	$0c				;89e8	0c 
	defb	$0c				;89e9	0c 
	defb	$0d				;89ea	0d 
	defb	$0e				;89eb	0e
	defb	$0f				;89ec	0f 
	defb	$0f				;89ed	0f 
	defb	$10				;89ee	10
	defb	$11				;89ef	11
	defb	$12				;89f0	12 
	defb	$13				;89f1	13 
	defb	$15				;89f2	15 
	defb	$16				;89f3	16
	defb	$17				;89f4	17 
	defb	$19				;89f5	19 
	defb	$1a				;89f6	1a 
	defb	$1c				;89f7	1c 
	defb	$1d				;89f8	1d 
	defb	$1f				;89f9	1f 
	defb	$21				;89fa	21 
	defb	$23				;89fb	23 
	defb	$25				;89fc	25 
	defb	$27				;89fd	27 
	defb	$29				;89fe	29  
	defb	$2c				;89ff	2c
	defb	$2e				;8a00	2e
	defb	$31				;8a01	31 
	defb	$34				;8a02	34 
	defb	$35				;8a03	35 
	defb	$3a				;8a04	3a 

;******************************************************************************************
; Sound Data - sound length multiply factor table
; This values multiplied by base length (from TAB_SND_DUR_BASE) determine time of played notes
TAB_SND_DUR_MUL:	
	defb	$01,$02,$03,$04,$06,$08,$0c,$10,$18		;8a05	01 02 03 04 06 08 0c 10 18 

;******************************************************************************************
; Melody Data - played at Start of Game - 2 x 8 bit value for every note (tone,length)
; 19 Notes
; 1st value - frequency byte, 0 - means pause note
; 2nd value - sound length byte
MELODY_GAME_START:
	defb	$15,$04			;8a0e	15 04
	defb	$1e,$05			;8a10	1e 05 
	defb	$1c,$02			;8a12	1c 02
	defb	$1a,$04			;8a14	1a 04 
	defb	$1c,$04			;8a16	1c 04 
	defb	$1a,$04			;8a18	1a 04
	defb	$17,$04			;8a1a	17 04 
	defb	$15,$04			;8a1c	15 04 
	defb	$12,$07			;8a1e	12 07 
	defb	$00,$04			;8a20	00 04 
;******************************************************************************************
; Melody Data - played at End of Game - 2 x 8 bit value for every note (tone,length)
; 9 Notes
; 1st value - frequency byte, 0 - means pause note
; 2nd value - sound length byte
MELODY_GAME_OVER:
	defb	$15,$04		;8a22	15 04 
	defb	$17,$04		;8a24	17 04 
	defb	$1c,$04		;8a26	1c 04 
	defb	$1a,$04		;8a28	1a 04
	defb	$19,$04		;8a2a	19 04 
	defb	$17,$04		;8a2c	17 04
	defb	$19,$04		;8a2e	19 04 
	defb	$1a,$08		;8a30	1a 08 
	defb	$00			;8a32	00 

