;***********************************************************************************************
;
; 	Ghost Hunter aka PAC 
;   Disect by Casper 08.01.2020
;
;	Verified with SjASMPlus Z80 Cross-Assembler v1.14.3 (https://github.com/z00m128/sjasmplus)
;-----------------------------------------------------------------------------------------------
;
;   Structure (used only at startup - overriden later):
;      	7ae9	BASIC_START - Basic Program with USR(0)
;      	7b0c	Basic garbage data. Used latter as Collision Map 
;
;       --------------------------------------------------------
;
; 	Structure
;      	7800	CMAP - Collision Map - keeps track of Game Objects positions
;		
;		8000	Main Entry Point. Jump to Game Init routine
;      	8003 	Game Global Variables
;       8034	Sound generation routines
;		806f	IOLATCH Shadow variable (usual system variable is not used)
;		8070	Game Score maitenance routines
; 		80d5	Game Init. Sets Input preferences (using Joystick or Keys only)
; 
;		80fa	Game Start. Initialize Game and wait for user to start.
;		8132	Game Level Init. Initialize Game Global Variables and Collision Map for this Level
;		8187	Game Level Start. Draws screen, resets data for Player, Ghosts and Heart (Bonus)

;		81fc	Main Game Loop. Indefinitelly calls update/draw subroutines 

;		821a	Game Loop Subroutine - Update Heart. 
;		827e	Init Heart Properties. Initialize Heart related timers and flag.
;		8291	Game Over Screen
;		82ad	Print Text related helper routines. Also clear screen proc (text mode).
;		8329	Text Data. Texts data to print on screen (text mode)
;		83ea	Draw Ghosts helper routines.
; 		8403	Random (not really) generate function.
;		840a	Game Loop Subroutine - Update screen colors when Player chases Ghosts
;		844d	Game Loop Subroutine - Update Ghosts (except Red 2) moves and check collision with Player.
;		844d	Game Loop Subroutine - Update Ghost Red 2 moves and check collision with Player.
;		84eb	Local variables for Update Ghosts routines.
;		84ef	Subroutines for Update Ghosts (drawing and move logic)
;		8678	Collision Map helper routines.	
;		86a6	Subroutines for Update Ghosts (drawing and move logic) cont.
;		86dc	Kill Player routine - end of Game or just decrement Life Counter and start over.
;		8731	Flash Screen routine. Inverts all pixels on screen.
;		875d	Delay helper procedure.
;		8764	Game Loop Subroutine - Update Player moves, check input and collision with Dots, 
;				Power Pills, Heart and also Ghosts if game is in Chase Mode.
;		8815	Test Kill Ghost. Test collision beetween Player and Ghost (only in Chase Mode) 
;		883a	Kill Ghost. Reward Player and respawn killed Ghost with random delay (Freeze)
;		88e3	Test Eat Dot, Power Pill or Heart.
;		88fd	Eat Power Pill. Reward Player and play Sound
;		891a	Eat Dot. Reward Player and Speed Up Ghost Red 2 in certain cases
;		8949	Eat Heart. Reward Player and reinitialize Heart properties
;		8975	Update Player routines - (cont.) 
;		8a22	Game Loop Subroutine - Draw Freezed Ghost (with decrement freeze timer)
;		8a5d	Game Loop Subroutine - Draw Dots and Pills. Also check if Level is Completed (no Dots left). 
;		8ae2	Level Up entry point. 
;		8aec	Local variables for above routines.
;		8aee	Draw Level Screen including clear screen and set Graphics Mode
;
;		8af5	Collision Map - Fill Passages base on data in Screen Data Blocks
;		8b52	Collision Map - Fill Dots and Pills base on data in Screen Data Blocks
;		8bc5	Draw Maze Walls base on data in Screen Data Blocks (with clear screen first)
;		8bc8	Draw Maze Walls base on data in Screen Data Blocks
;
;		8c2b	Update Show Walls Flag base on current Level
;		8c34	Clear Screen Gfx Mode 
;
;		8c4a	Data for Levels 1-5. Tweeked parameters for every Game Level 
;		8c5f	Screen Data Block - Horizontal Lines
;		8cf0	Screen Data Block - Vertical Lines
; 		8d41	Screen Data Block - Dots
;		8d87	Screen Data Block - Power Pills
;		8d91	Screen Data Block - Passages (Walls)
;
;		8ec9	Sprite Data - Player
;		8ef1	Sprite Data - Empty 
;		8ef9	Not Used
; 		8efa	Sprite Data - Player (cont)
;		8f0a	Sprite Data - Ghosts	
;		8f3a	Sprite Data - Heart (Bonus)	
;		
;		8f42	Input Functions
;		8f7c	Joystick Enabled Flag
;		
;***********************************************************************************************

	MACRO	FNAME 	filename
.beg		defb 	filename
			block 	16-$+.beg
			defb	0
	ENDM

	STRUCT 	TProps
DIR			defb	0				; current move direction: UP (1), RIGHT (2), DOWN (3), LEFT (4) 
SHF			defb	0				; current sprite variant: 0 - regular, 1 - shifted 2px right 
	ENDS

	STRUCT 	TGhost
VADR		defw	0				; VRAM address of sprite
PROPS		TProps	0,0				; Properties - Move Direction and Sprite Shift Flag
FREEZE		defb	0				; Ghost Freeze Timer
	ENDS

	STRUCT	TPlayer
SADR		defw	0				; adres of current used Sprite
VADR		defw	0				; VRAM address of sprite
PROPS		TProps	0,0				; Properties - Move Direction and Sprite Shift Flag
ANIM		defb	0				; use animated sprite flag
	ENDS

; Relative address 7AD1
;***********************************************************************************************
; File Header Block
	defb 	"VZFO"                  			; [0000] Magic
	FNAME	"PAC"
	defb	$F0             					; File Type
    defw    BASIC_START        					; Destination/Basic Start address

;***********************************************************************************************
;
;  B A S I C   S T A R T  

	org		$7ae9

BASIC_START	

;***********************************************************************************************

; 10 POKE30862,0:POKE30863,128:X=USR(0)
BASIC_10
	defw	BASIC_END							; next basic line				;7ae9	08 7b 
	defw	10									; basic line number				;7aeb	0a 00 
	defb	$b1,"30862,0"						; POKE30862,0					;7aed	b1 33 30 38 36 32 2c 30
	defb	$3a									; instruction end				;7af5	3a 
	defb	$b1,"30863,128"						; POKE30863,128					;7af6	b1 33 30 38 36 33 2c 31 32 38 
	defb	$3a									; instruction end				;7b00	3a 
	defb	"X",$d5,$c1,"(0)"					; X=USR(0)						;7b01	58 d5 c1 28 30 29 
	defb	0									; end of line					;7b07	00 

BASIC_END
	defw	0									; next line 0 means end 		;7b08	00 00 
	defw	10									; basic line number				;7b0a	0a 00 


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


;***********************************************************************************************
; GAME CONSTANTS
CMAP_ADR			equ		$7800				; 2kb Buffer for Collision Map


;***********************************************************************************************
; Garbage (BASIC) Data
; This area is used as part of Collision Map latter after Game initialization
;
	org		$7b0c
;---------------------------------------------------------------------------------------------
	
	include "basic_garbage.asm"
	

;***********************************************************************************************
;
;    M A I N  E N T R Y   P O I N T
;
;***********************************************************************************************
MAIN				org		$8000
	jp GAME_INIT					; jump to GAME_INIT							;8000	c3 d5 80 



;***********************************************************************************************
;
;    G A M E    V A R I A B L E S
;
;***********************************************************************************************
LEVEL				defb	0		; current Level								;8003	00
MEN_LIVES:			defb	0		; Live Counter								;8004	00 

;***********************************************************************************************
; Game State Data - 46 bytes 8005 - 8033 
GAME_STATE			defb	0		; Not Used variable							;8005	00 
DOTS_EATEN			defb	0		; Dots Eaten Counter						;8006	00 

;***********************************************************************************************
; Level DataSet
; These 4 bytes are set for every Level at start. Contains initial values for Game Loop Timers.
; Every Level has different values to incrase difficulty of Game with higher Level. 
; - The smaller the Update Timer value, the more often the Ghosts position is updated and thus they move faster.
; - Chase Mode Time defines duration of time when Chase Mode is active after Player Eat Power Pill. 
; - SpeedUp value decrases Ghost Red 2 (A) Update Timer when Player Eat 25,50 and 75th Dot making
;   gameplay even more difficult by incrase this Ghost moves.
; All values are given as the number of Game Loop iterations.
LEVEL_DATASET:
LEVEL_GH_UPD_TIMER	defb	0		; Ghosts Update Timer init value  			;8007	00 
LEVEL_GA_UPD_TIMER  defb	0		; Ghost Red A Update Timer init value		;8008	00 
LEVEL_CMODE_TIME	defb	0		; Ghost Chase Timer init value 				;8009	00 
LEVEL_GA_SPEEDUP	defb	0		; Ghost Red A Speedup Value  				;800a	00 

;***********************************************************************************************
; Player Sprite current Properties
; Keeps current data for Player Sprite to draw it properly.
; - Sprite Address points to current Sprite Variant to be use. 
;   There are 6 variants of Player Sprite to ensure proper display while Player is moving (2px step)
; - VRAM Address is current Player position on screen as byte addres
; - Properties contains 2 values: current moving direction and flag to mark use of shifted Sprite
;   when Player position is 2px right from base for this VRAM address
; - Animate Flag toggles every Player Update iteration. When is set we draw Alternate Sprite to show animation.  
PLAYER_SADR			defw	SPR.PLAYER_U	; address of current Sprite Variant	;800b	d9 8e 
PLAYER_VADR			defw	$0000	; VRAM address of sprite					;800d	00 00
PLAYER_PROPS		defw	0		; Move direction, Sprite Shifted Flag		;800f	00 00
PLAYER_ANIM			defb	0		; 0 - use valid variant, 1 - use Alt Sprite ;8011	00

;***********************************************************************************************
; Game Loop Timers
; Timers are counters which value is decremented in every Game Loop iteration.
; When the Timer value reaches 0 then corresponding Update or Draw routine is performed.
; Ghosts Update Timers will be reinitialized to value from Level Data, Draw Timers 
; are not initialized so when reaches 0 it wrap to value 256. Player Update Timer  
; is initialized to value 188 or 170 depending on direction Player moves (horizontal/vartical).
; This way Ghosts' speed is controlled 
PLAYER_UPD_TIMER	defb	0	; Player Update Timer - reset to 188 or 170 by code 	;8012	00 
GHOSTS_UPD_TIMER	defb	0	; Ghosts Update Timer - reset to LEVEL_GH_UPD_TIMER 	;8013	00 
CMODE_DRAW_TIMER	defb	0	; Chase Mode Update Timer (Screen Flash) reset to 256	;8014	00  
DOTS_DRAW_TIMER		defb	0	; Dots and Pills Redraw Timer - reset to 256			;8015	00 
GHOSTS_DRAW_TIMER	defb	0	; Ghosts Redraw Timer - reset to 256					;8016	00 
GHOSTA_UPD_TIMER	defb	0	; Ghost Red 2 (A) Update Timer - reset to LEVEL_GH_UPD_TIMER  ;8017	00 	. 

;***********************************************************************************************
; Ghosts Sprite current Properties
; Similar to Player Sprite Properties these data contains current values for every Ghost.
; It doesn't include Sprite Address because Ghosts use the same sprite no matter which
; direction they move.  
GHOST_B1		TGhost 0, 0, 0 	; Ghost Blue 1 [VRAM address,Properties,Freeze Timer]	;8018	00 00 00 00 00
GHOST_B2		TGhost 0, 0, 0 	; Ghost Blue 2 [VRAM address,Properties,Freeze Timer]	;801d	00 00 00 00 00
GHOST_R1		TGhost 0, 0, 0 	; Ghost Red 1 [VRAM address,Properties,Freeze Timer]	;8022	00 00 00 00 00
GHOST_R2		TGhost 0, 0, 0 	; Ghost Red 2 [VRAM address,Properties,Freeze Timer]	;8027	00 00 00 00 00

;***********************************************************************************************
; Chase Mode Timer
; Nonzero value means that Chase Mode is active - Player can chase and Kill Ghost and Ghost
; can't kill Player. This value is decremented every 256th interation of Game Loop.
CMODE_ON_TIMER		defb	0	; counting down time when Ghost Chase Mode is active 	;802c	00  
HEART_UPD_TIMER		defb	0	; Heart Update Timer - reset to 256						;802d	00 
HEART_SHOW_TIMER	defb	0	; counter down - initialized with random value			;802e	00 
HEART_ON_TIMER		defb	0	; count down time when Heart is active on screen	 	;802f	00 
SHOW_WALLS_FLAG		defb	0	; 0 - Maze Walls are hidden, nonzero - Walls are Drawn	;8030	00 
HEARTS_PER_LEVEL	defb	0	; Number of times Heart will spawn in this Game Level	;8031	00 

;***********************************************************************************************
; Dummy Data
					defb	0,0	; Not used												;8032	00 
;-----------------------------------------------------------------------------------------------



;================================================================================================
;================================================================================================
;================================================================================================
;
;   Sound Routines Module 
;   -------------------
;	Routines for predefined Sounds played by Th Game
;
	MODULE	SND
;
;
;***********************************************************************************************
; Play Predefined Sound
; Multiple entry points for 4 Sounds used in Game
PLAY_LowShort:
	ld bc,$0020				; Sound params: b=256, c=32 (low/short)				;8034	01 20 00
	jp PLAY_WAVE			; Play Sound										;8037	c3 4c 80
PLAY_HighShort:
	ld bc,$3040				; Sound params: b=48, c=64 	(high/short)			;803a	01 40 30  
	jp PLAY_WAVE			; Play Sound										;803d	c3 4c 80 	
PLAY_MiddleLong:
	ld bc,$4000				; Sound params: b=64, c=256 (middle/long)			;8040	01 00 40 
	jp PLAY_WAVE			; Play Sound										;8043	c3 4c 80 	 
PLAY_LowLong:
	ld bc,$0080				; Sound params: b=256, c=128 (low/long)				;8046	01 80 00  
	jp PLAY_WAVE			; Play Sound										;8049	c3 4c 80  

;***********************************************************************************************
; Play Sound Wave
; IN: b - half period time (0 = 256) 
;     c - number of cycles to play (0 = 256)
PLAY_WAVE:
	ld a,(IOLATCH_SHADOW)	; a - current hardware IOLATCH value				;804c	3a 6f 80 
.NEXT_CYCLE:
	and VDG_MODE_CSS_MASK	; reset all bits but VDG MODE and Colors			;804f	e6 18 
	or BIT_SPK_MINUS		; set Speaker Out to 0-1							;8051	f6 20 
	ld (IOLATCH),a			; send to hardware speaker 							;8053	32 00 68
	call DELAY_B			; wait delay according to value in b				;8056	cd 68 80 
	and VDG_MODE_CSS_MASK	; reset all bits but VDG MODE and Colors			;8059	e6 18  
	or BIT_SPK_PLUS			; set Speaker Out to 1-0							;805b	f6 01 
	ld (IOLATCH),a			; send to hardware speaker 							;805d	32 00 68
	call DELAY_B			; wait delay according to value in b				;8060	cd 68 80  
	dec c					; decrement cycle counter							;8063	0d 
	jp nz,.NEXT_CYCLE		; repeat c times									;8064	c2 4f 80
	ret						; ---------- End of Proc --------------				;8067	c9 

;***********************************************************************************************
; Delay 
; IN: b - delay value/counter
DELAY_B:
	push bc					; save bc											;8068	c5 
.WAIT:
	dec b					; decrement delay counter							;8069	05 
	jp nz,.WAIT				; repeat b times									;806a	c2 69 80 
	pop bc					; restore bc										;806d	c1 
	ret						; ------------- End of Proc -----------				;806e	c9 


	ENDMODULE 		; ================ End SND module ==========================================





;***********************************************************************************************
; Game Variable
IOLATCH_SHADOW	
	defb	0		; shadow variable to store value last written 				;806f	00 


;***********************************************************************************************
; Add value to Score
; Multiple entry points for values: 1, 10, 100, 1000, 10000
;-----------------------------------------------------------------------------------------------
; Increment Score value by 1 (not used)
SCORE_ADD_1
	ld a,(TXT_SCORE_DIGITS+4)	; 5th digit placeholder in Score text			;8070	3a cb 83 
	inc a						; add 1 										;8073	3c 
	cp $3a						; check if was "9" before increment				;8074	fe 3a 
	jp z,SCORE_ADD_1_OV			; yes - set to "0" and increment higher digit	;8076	ca 7d 80 
; -- digit value didn't exceeded '9'
	ld (TXT_SCORE_DIGITS+4),a	; store new 5th digit							;8079	32 cb 83  
	ret							; ------------- End of Proc --------------		;807c	c9 
; -- digit overflow - set to '0' 	
SCORE_ADD_1_OV:
	ld a,"0"					; set digit as "0"								;807d	3e 30 
	ld (TXT_SCORE_DIGITS+4),a	; store new 5th digit							;807f	32 cb 83  
;-----------------------------------------------------------------------------------------------
; Increment Score value by 10 
SCORE_ADD_10:
	ld a,(TXT_SCORE_DIGITS+3)	; 4th digit placeholder in Score text			;8082	3a ca 83  
	inc a						; add 1 (add 10 to Score in total)				;8085	3c
	cp $3a						; check if digit was "9" before increment		;8086	fe 3a 
	jp z,SCORE_ADD_10_OV		; yes - set to "0" and increment higher digit	;8088	ca 8f 80 
; -- digit value didn't exceeded '9'
	ld (TXT_SCORE_DIGITS+3),a	; store new 4th digit 							;808b	32 ca 83 
	ret							; ------------- End of Proc --------------		;808e	c9  
; -- digit overflow - set to '0' 	
SCORE_ADD_10_OV:
	ld a,"0"					; set digit as "0"								;808f	3e 30  
	ld (TXT_SCORE_DIGITS+3),a	; store new 4th digit							;8091	32 ca 83  
;-----------------------------------------------------------------------------------------------
; Increment Score value by 100 
SCORE_ADD_100:
	ld a,(TXT_SCORE_DIGITS+2)	; 3rd digit placeholder in Score text			;8094	3a c9 83  
	inc a						; add 1 (add 100 to Score in total)				;8097	3c 
	cp $3a						; check if digit was "9" before increment		;8098	fe 3a  
	jp z,SCORE_ADD_100_OV		; yes - set to "0" and increment higher digit	;809a	ca a1 80 	 
; -- digit value didn't exceeded '9'
	ld (TXT_SCORE_DIGITS+2),a	; store new 3rd digit 							;809d	32 c9 83 
	ret							; ------------- End of Proc --------------		;80a0	c9 
; -- digit overflow - set to '0' 	
SCORE_ADD_100_OV:
	ld a,"0"					; set digit as "0"								;80a1	3e 30  
	ld (TXT_SCORE_DIGITS+2),a	; set new 3rd digit 							;80a3	32 c9 83  
;-----------------------------------------------------------------------------------------------
; Increment Score value by 1000 (not used) 
SCORE_ADD_1000:
	ld a,(TXT_SCORE_DIGITS+1)	; 2nd digit placeholder in Score text			;80a6	3a c8 83  
	inc a						; add 1 (add 1000 to Score in total)			;80a9	3c 
	cp $3a						; check if digit was "9" before increment		;80aa	fe 3a 
	jp z,SCORE_ADD_1000_OV		; yes - set to "0" and increment higher digit	;80ac	ca b3 80  
; -- digit value didn't exceeded '9'
	ld (TXT_SCORE_DIGITS+1),a	; store new 2nd digit 							;80af	32 c8 83 
	ret							; ------------- End of Proc --------------		;80b2	c9  
; -- digit overflow - set to '0' 	
SCORE_ADD_1000_OV:
	ld a,"0"					; set digit as "0"								;80b3	3e 30  
	ld (TXT_SCORE_DIGITS+1),a	; store new 2nd digit 							;80b5	32 c8 83 
;-----------------------------------------------------------------------------------------------
; Increment Score value by 10000 (not used) 
SCORE_ADD_10000
	ld a,(TXT_SCORE_DIGITS)		; 1st digit placeholder in Score text			;80b8	3a c7 83 
	inc a						; add 1 (add 10000 to Score in total)			;80bb	3c 
	cp $3a						; check if digit was "9" before increment		;80bc	fe 3a 
	jp z,SCORE_ADD_10000_OV		; yes - set to "0" and overflow total to 00000	;80be	ca cf 80 
; -- digit value didn't exceeded '9'
	ld (TXT_SCORE_DIGITS),a		; store new 1st digit							;80c1	32 c7 83  
	ld a,(MEN_LIVES)			; Life Counter									;80c4	3a 04 80 
	cp 9						; check if Player has 9 lives already			;80c7	fe 09 
	ret p						; yes ---------- End of Proc --------------		;80c9	f0 
; -- Player has less than 9 lives
	inc a						; give Player 1 more Life						;80ca	3c 
	ld (MEN_LIVES),a			; store new value								;80cb	32 04 80 
	ret							; ------------- End of Proc --------------		;80ce	c9 
; -- digit overflow - set to '0' 	
SCORE_ADD_10000_OV:
	ld a,"0"					; set digit as "0"								;80cf	3e 30 
	ld (TXT_SCORE_DIGITS),a		; store new 1st digit 							;80d1	32 c7 83 
	ret							; ------------- End of Proc --------------		;80d4	c9  


;***********************************************************************************************
;
;   S E T   G A M E   I N P U T 
;
;***********************************************************************************************
; Ask user about using Joystick, check keys for answer and store Input Flag
GAME_INIT:
; -- display Joystick Question
	call CLEAR_SCREEN			; reset Screen to MODE 0 (text) and clear		;80d5	cd f6 82 
	ld hl,TXT_JOYSTICK_Q		; question about Yoistick						;80d8	21 29 83 
	ld de,VRAM+0				; screen text coord (0,0) [$7000]				;80db	11 00 70 
	call PRINT_TEXT				; Print Text data on screen						;80de	cd 08 83 
; -- set default value - no Joystick as default
	xor a						; 0 - no joystick, only keyboard				;80e1	af
	ld (INPUT.JOY_ENABLE),a		; store as default value						;80e2	32 7c 8f 
; -- check key pressed - wait for N or Y
.WAIT_FOR_KEY:
	ld a,(INPUT.KEYS_ROW_4)		; select Keyboard row 4 						;80e5	3a ef 6f 
	bit 0,a						; check if key 'N' pressed						;80e8	cb 47 
	jp z,GAME_START				; yes - Start the Game - flag already set		;80ea	ca fa 80
	ld a,(INPUT.KEYS_ROW_6)		; select Keyboard row 6							;80ed	3a bf 6f 
	bit 0,a						; check if key 'Y' pressed						;80f0	cb 47 
	jp nz,.WAIT_FOR_KEY			; no - wait for 'Y' or 'N' key					;80f2	c2 e5 80
; -- key 'Y' pressed - set Input Flag to Joystick
	ld a,1						; 1 - use joystick								;80f5	3e 01 
	ld (INPUT.JOY_ENABLE),a		; store settings value							;80f7	32 7c 8f 



;***********************************************************************************************
;
;   M A I N   G A M E   S T A R T
;
;***********************************************************************************************
GAME_START:
	di							; disable interrupts							;80fa	f3 
	ld sp,$8ffe					; set Stack Pointer - safe value for 6kB		;80fb	31 fe 8f 
; -- display Game Tiltle 
	call CLEAR_SCREEN			; reset Screen to MODE 0 (text) and clear		;80fe	cd f6 82 
	ld hl,TXT_GAME_TITLE		; Game Title text - VZ GHOST HUNTER				;8101	21 65 83 
	ld de,VRAM+(1*32)+0			; screen text coord (0,1) [$7020]				;8104	11 20 70 
	call PRINT_TEXT				; Print Text data on screen						;8107	cd 08 83 
; -- display Help screen with keys mappings
	ld hl,TXT_HELP_SCREEN		; Help Screen text								;810a	21 85 83 
	ld de,VRAM+(4*32)+10		; screen text coord (4,4) [$708a]				;810d	11 8a 70 
	call PRINT_TEXT				; Print Text data on screen						;8110	cd 08 83 
.WAIT_FOR_S_KEY:
	ld a,(INPUT.KEYS_ROW_1)		; select Keyboard row 1							;8113	3a fd 6f 
	bit 1,a						; check if key 'S' pressed						;8116	cb 4f 
	jp nz,.WAIT_FOR_S_KEY		; no - wait for Start key						;8118	c2 13 81 

; -- key 'S' pressed - start game
	ld a,3						; give Pleyer 3 lives on start 					;811b	3e 03 
	ld (MEN_LIVES),a			; store to Life Counter							;811d	32 04 80 
	ld a,1						; 1st Frame to play								;8120	3e 01 
	ld (LEVEL),a				; store as current Frame						;8122	32 03 80 
; -- set Score text to "00000"
	ld hl,TXT_SCORE_DIGITS		; 1st digit placeholder in Score text			;8125	21 c7 83
	ld de,TXT_SCORE_DIGITS+1	; 2nd digit placeholder in Score text			;8128	11 c8 83 
	ld bc,4						; 4 bytes to set								;812b	01 04 00 
	ld (hl),"0"					; set 1st byte to "0"							;812e	36 30 
	ldir						; copy this value to next 4 bytes				;8130	ed b0 

;***********************************************************************************************
;   
;   G A M E    L E V E L   I N I T
;
;***********************************************************************************************
GAME_LEVEL_INIT:
; -- create Collision Map
	call CMAP_DOTS_PILLS		; mark Dots and Power Pills in Collision Map	;8132	cd 52 8b 
	call CMAP_MARK_PASSAGES		; mark Passages/Walls in Collision Map			;8135	cd f5 8a 

; -- reset Game State Data - fill block (46 bytes) with 0 value
	ld hl,GAME_STATE			; src - address of Game State block data		;8138	21 05 80 
	ld de,GAME_STATE+1			; dst - address + 1								;813b	11 06 80
	ld bc,45					; cnt - 45 bytes of data						;813e	01 2d 00 
	ld (hl),0					; store 0 as init value							;8141	36 00 
	ldir						; fill Game State data with 0 					;8143	ed b0 

; -- set number of times Heart will spawn in this Level
	ld a,r						; a - random value								;8145	ed 5f 
	and $03						; narrow range to 0..3							;8147	e6 03
	inc a						; shift range to 1..4							;8149	3c
	ld (HEARTS_PER_LEVEL),a		; store number of Hearts for this Level			;814a	32 31 80 

; -- initialize Level Data for current Level
	ld a,(LEVEL)				; current Level to play							;814d	3a 03 80 
	cp 1						; is this 1st Level								;8150	fe 01 
	jp z,COPY_LEVEL1_DATA		; initialize Level Data							;8152	ca 6a 81
	cp 2						; is this 2nd Level								;8155	fe 02  
	jp z,COPY_LEVEL2_DATA		; initialize Level Data							;8157	ca 70 81 
	cp 3						; is this 3rd Level								;815a	fe 03 
	jp z,COPY_LEVEL3_DATA		; initialize Level Data							;815c	ca 76 81  
	cp 4						; is this 4th Level								;815f	fe 04  
	jp z,COPY_LEVEL4_DATA		; initialize Level Data							;8161	ca 7c 81  
; - must be 5 Level 

; -- initialize 4 Level dependend variables
	ld hl,DATA_LEVEL5			; src - Level Data 0							;8164	21 5a 8c 
	jp INIT_LEVEL_DATA			; copy Level data								;8167	c3 7f 81 
COPY_LEVEL1_DATA:
	ld hl,DATA_LEVEL1			; src - Level Data 1							;816a	21 4a 8c  
	jp INIT_LEVEL_DATA			; copy Level data								;816d	c3 7f 81
COPY_LEVEL2_DATA:
	ld hl,DATA_LEVEL2			; src - Level Data 2							;8170	21 4e 8c  
	jp INIT_LEVEL_DATA			; copy Level data								;8173	c3 7f 81 
COPY_LEVEL3_DATA:
	ld hl,DATA_LEVEL3			; src - Level Data 3							;8176	21 52 8c 
	jp INIT_LEVEL_DATA			; copy Level data								;8179	c3 7f 81 
COPY_LEVEL4_DATA:
	ld hl,DATA_LEVEL4			; src - Level Data 4							;817c	21 56 8c 

; -- copy data predefined for this Level - 4 bytes
INIT_LEVEL_DATA:
	ld de,LEVEL_DATASET			; dst - Level Data for current Level			;817f	11 07 80 
	ld bc,4						; 4 bytes to copy								;8182	01 04 00 
	ldir						; copy data										;8185	ed b0 

;***********************************************************************************************
;   
;   G A M E   L E V E L  S T A R T
;
;***********************************************************************************************
; Start of Gameplay - current Level
GAME_LEVEL_START:
	ld sp,$8ffe					; reset Stack Pointer 							;8187	31 fe 8f
	call PRINT_STATUS_CLS		; clear screen and print Status Screen			;818a	cd c0 82 
; -- as a side effect from above routine register bc = 0

; -- long delay - 8*65536 = 524288
	ld a,8						; repeat delay counter							;818d	3e 08 
.WAIT_DELAY:
	push af						; save af - repeat counter						;818f	f5 
	call DELAY_BC				; delay (bc = 65536)							;8190	cd 5d 87 
	pop af						; restore af 									;8193	f1
	dec a						; decrement counter (check if 0)				;8194	3d 
	jp nz,.WAIT_DELAY			; no - repeat delay 8 times						;8195	c2 8f 81 

; -- initialize screen 
	call DRAW_LEVEL_SCREEN		; draw Maze Walls, Dots and Pills				;8198	cd ee 8a 

; -- initialize Update Timers to 1 - will update in next iteration of Game Loop
	ld a,1						; a - init value for Timers (update now)		;819b	3e 01 
	ld (PLAYER_UPD_TIMER),a		; set Player Update Timer						;819d	32 12 80 
	ld (GHOSTS_UPD_TIMER),a		; set Ghosts Update Timer 						;81a0	32 13 80 
	ld (CMODE_DRAW_TIMER),a		; set Chase Mode Update Timer 					;81a3	32 14 80 

; -- initialize Player screen position and Move Direction
	ld hl,VRAM+(44*32)+13		; screen coord (52,44)px (13,44)bytes [$758d]	;81a6	21 8d 75 
	ld (PLAYER_VADR),hl			; hl - destination VRAM address Player			;81a9	22 0d 80 
	ld bc,00003h				; b - no spr shift (0), c - Move Dir (Left)		;81ac	01 03 00 
	ld (PLAYER_PROPS),bc		; store initial values							;81af	ed 43 0f 80 
; -- spawn Ghost Blue 1 at position 40x30px 	
	ld hl,VRAM+(30*32)+10		; screen coord (40,30)px (10,30)bytes [$73ca]	;81b3	21 ca 73
	ld (GHOST_B1.VADR),hl		; hl - destination VRAM address Ghost Blue 1	;81b6	22 18 80 	
	call DRAW_GHOST_BLUE		; draw Ghost Blue sprite on screen				;81b9	cd ea 83 
; -- spawn Ghost Blue 2 at position 48x30px 	
	ld hl,VRAM+(30*32)+12		; screen coord (48,30)px (12,30)bytes [$73cc]	;81bc	21 cc 73 
	ld (GHOST_B2.VADR),hl		; hl - destination VRAM address Ghost Blue 2	;81bf	22 1d 80 
	call DRAW_GHOST_BLUE		; draw Ghost Blue sprite on screen				;81c2	cd ea 83 	
; -- spawn Ghost Red 1 at position 56x30px 	
	ld hl,VRAM+(30*32)+14		; screen coord (56,30)px (14,30)bytes [$73ce]	;81c5	21 ce 73 
	ld (GHOST_R1.VADR),hl		; hl - destination VRAM address	Ghost Red 1		;81c8	22 22 80 
	call DRAW_GHOST_RED			; draw Ghost Red sprite on screen				;81cb	cd f7 83 
; -- spawn Ghost Red 1 at position 64x30px 	
	ld hl,VRAM+(30*32)+16		; screen coord (64,30)px (16,30)bytes [$73d0]	;81ce	21 d0 73 
	ld (GHOST_R2.VADR),hl		; hl - destination VRAM address	Ghost Red 2		;81d1	22 27 80 
	call DRAW_GHOST_REDA		; draw Ghost Red A variant sprite on screen		;81d4	cd fd 83 
; -- generate random Freeze Time for Ghost Blue 1
	call RANDOM_32_63			; a - Random Value in range 32..63				;81d7	cd 03 84  
	and $0f						; constrain range to 0..15						;81da	e6 0f 
	or $08						; move range value to 8..15						;81dc	f6 08 
	ld (GHOST_B1.FREEZE),a		; set Ghost Blue 1 Freeze Timer					;81de	32 1c 80 
; -- generate random Freeze Time for Ghost Blue 2
	call RANDOM_32_63			; a - Random Value in range 32..63				;81e1	cd 03 84 
	or $10						; move range value to 48..63					;81e4	f6 10 
	ld (GHOST_B2.FREEZE),a		; set Ghost Blue 2 Freeze Timer					;81e6	32 21 80 
; -- generate random Freeze Time for Ghost Red 1
	call RANDOM_32_63			; a - Random Value in range 32..63				;81e9	cd 03 84
	or $20						; move range value to 32..63					;81ec	f6 20 
	ld (GHOST_R1.FREEZE),a		;; set Ghost Red 1 Freeze Timer					;81ee	32 26 80 
; -- generate random Freeze Time for Ghost Red 2
	call RANDOM_32_63			; a - Random Value in range 32..63				;81f1	cd 03 84 
	or $40						; move range to range value 64..95 				;81f4	f6 40 
	ld (GHOST_R2.FREEZE),a		; set Ghost Red 2 Freeze Timer					;81f6	32 2b 80 
; -- initialize Heart timers
	call INIT_HEART_PROPS		; init Heart parameters							;81f9	cd 7e 82 


;***********************************************************************************************
;
;   G A M E    L O O P
;
;***********************************************************************************************

GAME_LOOP
	call GL_DRAW_DOTS_PILLS		; draw Dots and Power Pills						;81fc	cd 5d 8a 
	call GL_UPDATE_PLAYER		; update Player position and draw 				;81ff	cd 64 87 
	call GL_UPDATE_GHOSTS		; update Ghosts positions (except Ghost Red A)	;8202	cd 4d 84 
	call GL_UPDATE_GHOSTA		; update Ghost Red A position and draw			;8205	cd b9 84 
	call GL_UPDATE_CHASE_MODE	; update screen colors if in Chase Mode 		;8208	cd 0a 84 
	call GL_DRAW_FREEZED_GHOSTS	; draw freezed Ghosts 							;820b	cd 22 8a
	call GL_UPDATE_HEART		; update Heart timer and draw if it's active	;820e	cd 1a 82 
	ld bc,18					; delay value									;8211	01 12 00 
	call DELAY_BC				; wait Delay									;8214	cd 5d 87 
	jp GAME_LOOP				; ---------- Repeat Game Loop -----------------	;8217	c3 fc 81


;***********************************************************************************************
;
;   G A M E    L O O P  -  U P D A T E   H E A R T 
;
;***********************************************************************************************
GL_UPDATE_HEART:
; -- decrement timer and check if it's time to update 
	ld a,(HEART_UPD_TIMER)		; Heart Update Timer value						;821a	3a 2d 80
	dec a						; decrement timer - check if 0					;821d	3d 
	ld (HEART_UPD_TIMER),a		; store new value								;821e	32 2d 80 
	ret nz						; no - don't update in this Game Loop iteration	;8221	c0 
; -- check if any Hearts can be shown for this Level
	ld a,(HEARTS_PER_LEVEL)		; Number of Hearts left for this Level			;8222	3a 31 80
	or a						; are any left?									;8225	b7 
	ret z						; no ------------ End of Proc -----------------	;8226	c8 
; -- check if it's time to show Heart 
	ld a,(HEART_SHOW_TIMER)		; Heart Show Timer value						;8227	3a 2e 80 
	or a						; check if it's already shown					;822a	b7 
	jp z,.UPDATE_HEART			; yes - skip create - just update Heart			;822b	ca 48 82 
; -- decrement Heart Show Timer and check if it's time to show Heart
	dec a						; decrement timer and check if 0				;822e	3d 
	ld (HEART_SHOW_TIMER),a		; store new value								;822f	32 2e 80 
	ret nz						; not yet ------- End of Proc ----------------- ;8232	c0 

; -- counter just set to 0 - it's time to create Heart 
; -- set Heart Bits (7,6) in Collision Map
	ld hl,VRAM+(37*32)+13		; screen coord (52,37)px (13,37)bytes [$74ad]	;8233	21 ad 74 
	call CMAP_GET_BYTE			; de - address in Colision Map					;8236	cd e9 89 
	ld b,%11000000				; Heart Bits (7,6) to set in CMap				;8239	06 c0 	
	call CMAP_SET_2X4			; set Heart Bits (7,6) in CMap (8x4)px (2x4)b	;823b	cd 8f 86 
; -- check Show Walls Flag - skip drawing Maze Walls if not set
	ld a,(SHOW_WALLS_FLAG)		; show/hide Maze Walls flag 					;823e	3a 30 80 
	or a						; check if 0									;8241	b7 
	jp z,.UPDATE_HEART			; yes - don't draw Maze Walls					;8242	ca 48 82 
	call DRAW_MAZE_WALLS		; draw Maze Lines on screen						;8245	cd c8 8b 
.UPDATE_HEART:
; -- draw Heart Sprite at predefined coordinates 
	ld hl,SPR.HEART				; Sprite Heart data (8x4)px (2x4) bytes			;8248	21 3a 8f 
	ld de,VRAM+(37*32)+13		; screen coord (52,37)px (13,37)bytes [$74ad]	;824b	11 ad 74
	ld bc,2						; bc - 2 bytes (8px) - sprite width				;824e	01 02 00
	ld a,4						; a - 4 lines (4px) - sprite height				;8251	3e 04 
	call DRAW_SPRITE			; draw sprite on screen							;8253	cd 75 89 
; -- decrement Heart Life Counter and check if time elapsed
	ld a,(HEART_ON_TIMER)		; Heart On Timer value							;8256	3a 2f 80 
	dec a						; decrement timer - check if 0					;8259	3d 
	ld (HEART_ON_TIMER),a		; store new value								;825a	32 2f 80 
	ret nz						; no ------------ End of Proc -----------------	;825d	c0 

; -- Heart LifeTime Elapsed - remove Heart from screen and Collision Map
	ld hl,VRAM+(37*32)+13		; screen coord (52,37)px (13,37)bytes [$74ad]	;825e	21 ad 74 
	call CMAP_GET_BYTE			; de - address in Colision Map					;8261	cd e9 89 
	ld b,%00111111				; bitmask to clear bits 7 and 6					;8264	06 3f  
	call CMAP_CLEAR_2X4			; clear bits 7 and 6 in buffer for this sprite	;8266	cd 78 86 
; -- clear screen area
	ld hl,SPR.EMPTY				; Sprite Empty (8x4)px (2x4) bytes				;8269	21 f1 8e 
	ld de,VRAM+(37*32)+13		; screen coord (52,37)px (13,37)bytes [$74ad]	;826c	11 ad 74 
	ld bc,2						; bc - 2 bytes (8px) - sprite width				;826f	01 02 00 
	ld a,4						; a - 4 lines (4px) - sprite height				;8272	3e 04 
	call DRAW_SPRITE			; draw sprite on screen (clear)					;8274	cd 75 89 
; -- update Show Walls Flag and reinitialize Heart parameters for next time
	call UPDATE_SHOW_WALLS		; update Show Walls Flag if Level > 3			;8277	cd 2b 8c 
	call INIT_HEART_PROPS		; initialize Heart Timers						;827a	cd 7e 82
	ret							; -------------- End of Proc ------------------	;827d	c9  


;***********************************************************************************************
; Initialize Heart parameters:
; HEART_TIMER - number of game loop ticks before Heart will show
; HEART_LIFETIME - number of game loop ticks Heart wil be shown before removed 
INIT_HEART_PROPS:
; -- reset Heart Timer to random value (128..255)
	ld a,r						; a - random value								;827e	ed 5f 
	and %01111111				; range 0..127									;8280	e6 7f 
	or 	%10000000				; range 128..255								;8282	f6 80 
	ld (HEART_SHOW_TIMER),a		; set Heart Timer								;8284	32 2e 80 
; -- reset Heart LifeTime 
	ld a,80						; set LifeTIme Counter to 80					;8287	3e 50 
	ld (HEART_ON_TIMER),a		; store into timer variable 					;8289	32 2f 80 
; -- hide Maze Walls 
	xor a						; reset Show Walls Flag							;828c	af 
	ld (SHOW_WALLS_FLAG),a		; hide Maze Walls - don't draw					;828d	32 30 80 
	ret							; -------------- End of Proc ------------------	;8290	c9 

;***********************************************************************************************
; Show Game Over Screen
; Clear screen and print Game Over Text 12 times in 6 lines. Next jump to PRINT_STATUS routine. 
GAME_OVER:
	call CLEAR_SCREEN			; reset Screen to MODE 0 (text) and clear		;8291	cd f6 82 
	ld a,3						; repeat 3 times								;8294	3e 03 
	ld hl,TXT_GAME_OVER			; Game Over text line							;8296	21 cd 83 
	ld de,VRAM+0				; screen text coord (0,0) [$7000]				;8299	11 00 70 
	call PRINT_TEXT_X_TIMES		; print Game Over line 3 times					;829c	cd ad 82 
	ld a,3						; repeat 3 times								;829f	3e 03 
	ld hl,TXT_GAME_OVER			; Game Over text line							;82a1	21 cd 83 
	ld de,VRAM+(12*32)+0		; screen text coord (0,12) [$7180]				;82a4	11 80 71 
	call PRINT_TEXT_X_TIMES		; print Game Over line 3 times					;82a7	cd ad 82 
	jp PRINT_STATUS				; jump to Print Status routine					;82aa	c3 c3 82 

;***********************************************************************************************
; Print Text on screen multiple times in multiple lines
; IN: hl - address of text data to print on screen
;     de - destination VRAM address 
;     a  - how many times (lines) display this text   
PRINT_TEXT_X_TIMES:
	push af						; save af (a = repeat counter)					;82ad	f5 
	push hl						; save hl - text to print on screen				;82ae	e5 
	push de						; save de - VRAM destination address			;82af	d5 
	call PRINT_TEXT				; Print Text on screen							;82b0	cd 08 83 
	pop de						; restore de - VRAM address						;82b3	d1 
	ld hl,32					; 32 bytes per screen line						;82b4	21 20 00 
	add hl,de					; shift adrress to next line 					;82b7	19 
	ex de,hl					; de - new VRAM destination address				;82b8	eb 
	pop hl						; restore hl - text source						;82b9	e1 
	pop af						; restore af - a repeat counter					;82ba	f1 
	dec a						; decrement counter (check if 0)				;82bb	3d 
	jp nz,PRINT_TEXT_X_TIMES	; not 0 - repeat print on screeen				;82bc	c2 ad 82 
	ret							; --------------- End of Proc -----------		;82bf	c9 

;***********************************************************************************************
; Clear Screen and print Status data.beg.
; Used before fresh new Game and along with Game Over Screen 
PRINT_STATUS_CLS:
	call CLEAR_SCREEN			; reset Screen to MODE 0 (text) and clear		;82c0	cd f6 82 
PRINT_STATUS:
; -- copy score digits from Help Screen to Status Screen
	ld hl,TXT_SCORE_DIGITS		; src - Score digits - Help Screen				;82c3	21 c7 83 
	ld de,TXT_SCORE_DIGITS_STA	; dst - Score digits - Status Screen			;82c6	11 4c 83 
	ld bc,5						; 5 bytes/chars to copy							;82c9	01 05 00 
	ldir						; copy bytes 									;82cc	ed b0 
; -- update Life Counter info (MEN)
	ld a,(MEN_LIVES)			; current Life Counter value					;82ce	3a 04 80 
	add a,'0'					; convert to char digit							;82d1	c6 30 
	ld (TXT_MEN_DIGIT),a		; update text buffer							;82d3	32 59 83 
; -- update info about Game Frame
	ld a,(LEVEL)				; a - current Game Level to play				;82d6	3a 03 80 
	push af						; save af 										;82d9	f5 
	add a,'0'					; convert to char digit							;82da	c6 30 
	ld (TXT_LEVEL_DIGITS),a		; update text buffer							;82dc	32 62 83 
	pop af						; restore af - a - current Level				;82df	f1 
; -- place '+' char if current Level > 5
	cp 6						; check if LEVEL > 5							;82e0	fe 06 
	ld a,' '					; space char for Levels 1..5					;82e2	3e 20 
	jp m,.SET_EXTRA_CHAR		; skip if LEVEL < 6								;82e4	fa e9 82 
	ld a,'+'					; '+' char for Levels 6...n						;82e7	3e 2b 
.SET_EXTRA_CHAR:
	ld (TXT_LEVEL_DIGITS+1),a	; set char next to Level number					;82e9	32 63 83
; -- everything updated - print on screen
	ld hl,TXT_GAME_STATUS		; src - Status Text								;82ec	21 39 83 
	ld de,VRAM+(4*32)+10		; screen text coord (10,4) [$708a]				;82ef	11 8a 70 
	call PRINT_TEXT				; Print Text data on screen						;82f2	cd 08 83 
	ret							; ---------------- End of Proc -------------	;82f5	c9 

;***********************************************************************************************
; Clear Screen
; Custom clear screen routine via set first byte to Space and copy previous byte to next 511 times. 
CLEAR_SCREEN:
	ld hl,VRAM				; src - address of Video RAM Memory					;82f6	21 00 70 
	ld de,VRAM+1			; dst - address + 1									;82f9	11 01 70
	ld bc,511				; cnt - 511 times copy								;82fc	01 ff 01 
	ld (hl)," "				; set 1st byte to space (clear)						;82ff	36 20 
	ldir					; fill VRAM with space char							;8301	ed b0 
; -- reset VDG MODE 0, Background Green, Speaker Off
	xor a					; VDG MODE 0, Background Color Green				;8303	af 
	ld (IOLATCH),a			; store to hardware latch							;8304	32 00 68 
	ret						; --------------- End of Proc ---------------		;8307	c9 

;***********************************************************************************************
; Print Text data on screen
; Text must be delimited by 0. Routine supports new line character ($0d) (simplified way).
; ASCII chars are converted to upper case before print.
; IN: hl - address of text data to print on screen
;     de - destination VRAM address 
PRINT_TEXT:
	push de					; save de - target VRAM address						;8308	d5 
.NEXT_CHAR:
	ld a,(hl)				; char to display on screen							;8309	7e
	cp $0d					; check if New Line Char							;830a	fe 0d 
	jp z,.NEXT_LINE			; yes - calculate new target address				;830c	ca 1b 83 
; -- Char to print is not New Line ($0d)
	or a					; check if 0 - end of text							;830f	b7
	jp z,.EXIT				; yes - return to caller							;8310	ca 27 83
; -- a - ASCII char do print on screen
	res 6,a					; clear bit 6 - change to UpperCase					;8313	cb b7 
	ld (de),a				; print char to screen								;8315	12 
	inc hl					; next source address								;8316	23 
	inc de					; next destination address							;8317	13 
	jp .NEXT_CHAR			; continue with remaining chars						;8318	c3 09 83
.NEXT_LINE:
; -- add 32 bytes to destination VRAM address
	pop de					; VRAM address of first char of current line		;831b	d1 
	push hl					; save hl - current char address					;831c	e5 
	ld hl,32				; 32 bytes per screen line							;831d	21 20 00 
	add hl,de				; VRAM address in next line							;8320	19 
	ex de,hl				; set as destination address						;8321	eb 
	pop hl					; restore hl - current char address					;8322	e1 
	inc hl					; next char to pront								;8323	23 
	jp PRINT_TEXT			; continue with remaining chars						;8324	c3 08 83 
.EXIT:
	pop de					; restore de 										;8327	d1 
	ret						; -------------- End of Proc ---------------		;8328	c9 

;***********************************************************************************************
; Input Settings Question text
TXT_JOYSTICK_Q:

	defb	"JOYSTICKS (Y-N)",0							;8329	4a 4f 59 53 54 49 43 4b 53 20 28 59 2d 4e 29 00 

;***********************************************************************************************
; Game Status and Score text
TXT_GAME_STATUS:

	defb	"GAME STATUS",$0d,$0d						;8339	47 41 4d 45 20 53 54 41 54 55 53 0d 0d  
	defb 	"SCORE "									;8346	53 43 4f 52 45 20
TXT_SCORE_DIGITS_STA
	defb	0,0,0,0,0		; digit placeholder			;834c	00 00 00 00 00 
	defb	$0d,$0d										;8351	0d 0d 
	defb	"MEN   "									;8353	4d 45 4e 20 20 20 	    
TXT_MEN_DIGIT
	defb	0				; digit placeholder			;8359	00  
	defb	$0d,$0d										;835a	0d 0d 
	defb	"FRAME "									;835c	46 52 41 4d 45 20 
TXT_LEVEL_DIGITS
	defb	0,0				; digit placeholder			;8362	00 00
	defb	0				; end of text				;8364	00 

;***********************************************************************************************
; Game Title text
TXT_GAME_TITLE:
	
	defb	" V Z  -  G H O S T  H U N T E R",0			;8365	20 56 20 5a 20 20 2d 20 20 47 20 48 20 4f 20 53 20 54 20 20 48 20 55 20 4e 20 54 20 45 20 52 00

;***********************************************************************************************
; Help screen text 
TXT_HELP_SCREEN:
	
	defb	"<S> = START",$0d,$0d						;8385	3c 53 3e 20 3d 20 53 54 41 52 54 0d 0d 
	defb	"<M> = LEFT",$0d,$0d						;8392	3c 4d 3e 20 3d 20 4c 45 46 54 0d 0d
	defb	"<,> = RIGHT",$0d,$0d						;839e	3c 2c 3e 20 3d 20 52 49 47 48 54 0d 0d
	defb	"<Q> = UP",$0d,$0d							;83ab	3c 51 3e 20 3d 20 55 50 0d 0d 
	defb	"<A> = DOWN",$0d,$0d						;83b5	3c 41 3e 20 3d 20 44 4f 57 4e 0d 0d
	defb	"SCORE "									;83c1	53 43 4f 52 45 20 
TXT_SCORE_DIGITS
	defb 	"00000"					; digit placeholder ;83c7	30 30 30 30 30 00
	defb 	0						; end of text		;83cc	00

;***********************************************************************************************
; Game Over text 
TXT_GAME_OVER:
	
	defb 	"   GAME",$60,"OVER       GAME",$60,"OVER",0 ;83cd	20 20 20 47 41 4d 45 60 4f 56 45 52 20 20 20 20 20 20 20 47 41 4d 45 60 4f 56 45 52 00 


;***********************************************************************************************
; Draw Ghost Blue sprite data on screen at VRAM addres set in hl
; IN: hl - destination VRAM address 
DRAW_GHOST_BLUE:
	ld de,SPR.GHOST_BLUE		; Sprite Ghost Blue data (8x4)px (2x4) bytes	;83ea	11 0a 8f 
;***********************************************************************************************
; Draw 8x4 sprite
; IN: de - address of sprite data
;     hl - destination VRAM address
DRAW_8x4_SPRITE:
	ex de,hl					; hl - source, de - destination address			;83ed	eb 
	ld bc,2						; bc - 2 bytes (8px) - sprite width				;83ee	01 02 00 
	ld a,4						; a - 4 lines (4px) - sprite height				;83f1	3e 04 
	call DRAW_SPRITE			; draw Ghost Blue sprite on screen				;83f3	cd 75 89 
	ret							; ---------- End of Proc ----------------		;83f6	c9 

;***********************************************************************************************
; Draw Ghost Red sprite data on screen at VRAM addres set in hl
; IN: hl - destination VRAM address 
DRAW_GHOST_RED:
	ld de,SPR.GHOST_RED			; Sprite Ghost Red data (8x4)px (2x4) bytes		;83f7	11 1a 8f 
	jp DRAW_8x4_SPRITE			; Draw 8x4 sprite								;83fa	c3 ed 83

;***********************************************************************************************
; Draw Ghost Red A variant sprite data on screen at VRAM addres set in hl
; IN: hl - destination VRAM address 
DRAW_GHOST_REDA:
	ld de,SPR.GHOST_REDA		; Sprite Ghost Red A variant (8x4)px (2x4)bytes	;83fd	11 2a 8f 
	jp DRAW_8x4_SPRITE			; Draw 8x4 sprite								;8400	c3 ed 83



;***********************************************************************************************
; Get Random Value in range 32..63
RANDOM_32_63:
	ld a,r						; a - random value								;8403	ed 5f 
	and $1f						; value range 0..31								;8405	e6 1f 
	add a,32					; value range 32..63 							;8407	c6 20 
	ret							; ---------- End of Proc ----------------		;8409	c9 




;***********************************************************************************************
;
;   G A M E    L O O P  -  U P D A T E   C H A S E   M O D E 
;
;***********************************************************************************************
; Checks Timer if it's time to update Chase Mode in this Game Loop iteration
; If so decrement Chase Mode Timer and if value is less than 13 changes Screen Colors
; in order to inform Player that is close to the end
GL_UPDATE_CHASE_MODE:
; -- decrement Chase Mode Update Timer and check if we Update Screen in this Game Loop iteration 
	ld a,(CMODE_DRAW_TIMER)		; a - Chase Mode Update Timer					;840a	3a 14 80 
	dec a						; decrement timer - check if elapsed			;840d	3d 
	ld (CMODE_DRAW_TIMER),a		; store new value								;840e	32 14 80 
	ret nz						; no - no update in this Game Loop iteration	;8411	c0 

; -- Update Timer elapsed - check if game is in Ghost Chase Mode
	ld a,(CMODE_ON_TIMER)		; a - Ghost Chase Mode Timer					;8412	3a 2c 80 
	or a						; is Mode active (a > 0)						;8415	b7 
	ret z						; no ------- End of Proc ----------------------	;8416	c8 

; -- Ghost Chase Mode is active - decrement LifeTimer
	dec a						; decrement Timer value							;8417	3d 
	ld (CMODE_ON_TIMER),a		; store new value								;8418	32 2c 80 
; -- flash screen colors when Chase Mode is ending
	cp 12						; is 12 "ticks" left? 							;841b	fe 0c 
	jp z,SET_GFX_MODE_COLORS_0	; yes - change Colors to Green Palette			;841d	ca 3b 84 
	cp 11						; is 11 "ticks" left? 							;8420	fe 0b  
	jp z,SET_GFX_MODE_COLORS_1	; yes - change Colors to Buff Palette			;8422	ca 44 84 
	cp 8						; is 8 "ticks" left? 							;8425	fe 08  
	jp z,SET_GFX_MODE_COLORS_0	; yes - change Colors to Green Palette			;8427	ca 3b 84  
	cp 7						; is 7 "ticks" left? 							;842a	fe 07 
	jp z,SET_GFX_MODE_COLORS_1	; yes - change Colors to Buff Palette			;842c	ca 44 84  
	cp 4						; is 4 "ticks" left? 							;842f	fe 04 
	jp z,SET_GFX_MODE_COLORS_0	; yes - change Colors to Green Palette			;8431	ca 3b 84  
	cp 3						; is 3 "ticks" left? 							;8434	fe 03 
	jp z,SET_GFX_MODE_COLORS_1	; yes - change Colors to Buff Palette			;8436	ca 44 84 
	or a						; is still active?								;8439	b7 	 
	ret nz						; yes ----------- End of Proc -----------------	;843a	c0  
; -- Ghost Chase Mode has ended - revert back Colors to Green Palette

;***********************************************************************************************
; Set HiRes graphics Mode (1) and Color Palette to 0 (GREEN/YELLOW/BLUE/RED)
SET_GFX_MODE_COLORS_0:
	ld a,VDG_GFX_COLORS_0		; set VDG MODE 1 and Color Palette to 0			;843b	3e 08 
	ld (IOLATCH),a				; store to hardware register					;843d	32 00 68 
	ld (IOLATCH_SHADOW),a		; store to shadow register 						;8440	32 6f 80 
	ret							; -------------- End of Proc ------------------	;8443	c9  

;***********************************************************************************************
; Set HiRes graphics Mode (1) and Color Palette to 1 (BUFF/CYAN/MAGENTA/ORANGE)
SET_GFX_MODE_COLORS_1:
	ld a,VDG_GFX_COLORS_1		; set VDG MODE 1 and Color Palette to 1			;8444	3e 18  
	ld (IOLATCH),a				; store to hardware register					;8446	32 00 68 
	ld (IOLATCH_SHADOW),a		; store to shadow register 						;8449	32 6f 80  
	ret							; -------------- End of Proc ------------------	;844c	c9  


;***********************************************************************************************
;
;   G A M E    L O O P  -  U P D A T E   G H O S T S 
;
;***********************************************************************************************
GL_UPDATE_GHOSTS:
; -- decrement Ghosts Update Timer - check if we update in this Game Loop iteration
	ld a,(GHOSTS_UPD_TIMER)		; a - Ghost Update Timer 						;844d	3a 13 80 
	dec a						; decrement value and check if 0				;8450	3d 
	ld (GHOSTS_UPD_TIMER),a		; store new value 								;8451	32 13 80 
	ret nz						; no - dont update this time					;8454	c0 
; -- reset Timer value to one defined in Level Data - this value evective determine moving speed
	ld a,(LEVEL_GH_UPD_TIMER)	; initial value for this Level					;8455	3a 07 80 
	ld (GHOSTS_UPD_TIMER),a		; store new value								;8458	32 13 80 

;***********************************************************************************************
; Update/Move Ghosts Blue 1, Blue 2 and Red 1
; -- Pepeare 2 variants of Sprite - base and shifted 2px - to use by subroutine for Blue Ghosts
	ld hl,SPR.GHOST_BLUE		; Sprite Ghost Blue data (8x4)px (2x4) bytes	;845b	21 0a 8f 
	ld (SPR_BASE_VAR),hl		; store as current moving Sprite				;845e	22 eb 84 
	ld hl,SPR.GHOST_BLUE_2R		; Sprite Ghost Blue shifted 2px right			;8461	21 12 8f 
	ld (SPR_2R_VAR),hl			; store as current moving Sprite 2R variant		;8464	22 ed 84 
; -- Update/Move Ghost Blue 1
	ld hl,(GHOST_B1.VADR)		; hl - VRAM address of Ghost Blue 1				;8467	2a 18 80 
	ld bc,(GHOST_B1.PROPS)		; c - move direction, b - sprite shift flag		;846a	ed 4b 1a 80 
	ld a,(GHOST_B1.FREEZE)		; a - Ghost Freeze Timer						;846e	3a 1c 80 
	call UPDATE_MOVE_GHOST		; Update Move Ghost								;8471	cd ef 84 
	ld (GHOST_B1.FREEZE),a		; store new Freeze Timer value					;8474	32 1c 80  
	ld (GHOST_B1.VADR),hl		; new VRAM address of Ghost Blue 1				;8477	22 18 80 
	ld (GHOST_B1.PROPS),bc		; store new Move Direction and Sprite Shift Flag;847a	ed 43 1a 80  
; -- Update/Move Ghost Blue 2	
	ld hl,(GHOST_B2.VADR)		; hl - VRAM address of Ghost Blue 2				;847e	2a 1d 80 
	ld bc,(GHOST_B2.PROPS)		; c - move direction, b - sprite shift flag		;8481	ed 4b 1f 80 
	ld a,(GHOST_B2.FREEZE)		; a - Ghost Freeze Timer						;8485	3a 21 80 
	call UPDATE_MOVE_GHOST		; Update Move Ghost								;8488	cd ef 84  
	ld (GHOST_B2.FREEZE),a		; store new Freeze Timer value					;848b	32 21 80  
	ld (GHOST_B2.VADR),hl		; new VRAM address of Ghost Blue 2				;848e	22 1d 80 
	ld (GHOST_B2.PROPS),bc		; store new Move Direction and Sprite Shift Flag;8491	ed 43 1f 80 

; -- Pepeare 2 variants of Ghost Red Sprite - base and shifted 2px - to use by subroutine
	ld hl,SPR.GHOST_RED			; Sprite Ghost Red data (8x4)px (2x4) bytes		;8495	21 1a 8f 
	ld (SPR_BASE_VAR),hl		; store as current moving Sprite				;8498	22 eb 84 
	ld hl,SPR.GHOST_RED_2R		; Sprite Ghost Red  shifted 2px right			;849b	21 22 8f 
	ld (SPR_2R_VAR),hl			; store as current moving Sprite 2R variant		;849e	22 ed 84 
; -- Update/Move Ghost Red 1
	ld hl,(GHOST_R1.VADR)		; hl - VRAM address of Ghost Red 1				;84a1	2a 22 80  
	ld bc,(GHOST_R1.PROPS)		; c - move direction, b - sprite shift flag		;84a4	ed 4b 24 80  
	ld a,(GHOST_R1.FREEZE)		; a - Ghost Freeze Timer					;84a8	3a 26 80
	call UPDATE_MOVE_GHOST		; Update Move Ghost								;84ab	cd ef 84  
	ld (GHOST_R1.FREEZE),a		; store new Freeze Timer value					;84ae	32 26 80  
	ld (GHOST_R1.VADR),hl		; new VRAM address of Ghost Red 1				;84b1	22 22 80  
	ld (GHOST_R1.PROPS),bc		; store new Move Direction and Sprite Shift Flag;84b4	ed 43 24 80  
	ret							; -------------- End of Proc ------------------	;84b8	c9 

;***********************************************************************************************
;
;   G A M E    L O O P  -  U P D A T E   G H O S T   R E D   A 
;
;***********************************************************************************************
GL_UPDATE_GHOSTA:
; -- decrement Ghost Red A Update Timer - check if we update in this Game Loop iteration
	ld a,(GHOSTA_UPD_TIMER)		; a - Ghost Red 2 (A) Update timer value		;84b9	3a 17 80 
	dec a						; decrement value and check if 0				;84bc	3d 
	ld (GHOSTA_UPD_TIMER),a		; store new value 								;84bd	32 17 80 
	ret nz						; timer <> 0 - dont update this time			;84c0	c0 
; -- reset Timer value to one defined in Level Data - this value evective determine moving speed
	ld a,(LEVEL_GA_UPD_TIMER)	; initial value for this Level					;84c1	3a 08 80
	ld (GHOSTA_UPD_TIMER),a		; store new value								;84c4	32 17 80 

;***********************************************************************************************
; Update/Move Ghost Red A
; -- Pepeare 2 variants of Sprite - base and shifted 2px - to use by subroutine
	ld hl,SPR.GHOST_REDA		; Sprite Ghost Red A variant (8x4)px (2x4)bytes	;84c7	21 2a 8f 
	ld (SPR_BASE_VAR),hl		; store as current moving Sprite				;84ca	22 eb 84  
	ld hl,SPR.GHOST_REDA_2R		; Sprite Ghost Red A shifted 2px right			;84cd	21 32 8f  
	ld (SPR_2R_VAR),hl			; store as current moving Sprite 2R variant		;84d0	22 ed 84  
; -- Update/Move Ghost Red 1
	ld hl,(GHOST_R2.VADR)		; hl - VRAM address of Ghost Red 2				;84d3	2a 27 80 
	ld bc,(GHOST_R2.PROPS)		; c - move direction, b - sprite shift flag		;84d6	ed 4b 29 80
	ld a,(GHOST_R2.FREEZE)		; a - Ghost Freeze Timer						;84da	3a 2b 80 
	call UPDATE_MOVE_GHOST		; Update Move Ghost								;84dd	cd ef 84 
	ld (GHOST_R2.FREEZE),a		; store new Freeze Timer value					;84e0	32 2b 80 
	ld (GHOST_R2.VADR),hl		; store new VRAM address of Ghost Red 2			;84e3	22 27 80 
	ld (GHOST_R2.PROPS),bc		; store new Move Direction and Sprite Shift Flag;84e6	ed 43 29 80
	ret							; -------------- End of Proc ------------------	;84ea	c9  

;***********************************************************************************************
; Helper variables - used to transfer data to common Ghost update routine
SPR_BASE_VAR	defw	$0000	; current processed Ghost Sprite - used as param	;84eb	00 00 
SPR_2R_VAR		defw	$0000	; current processed Ghost Sprite (shifted variant)	;84ed	00 00 

;***********************************************************************************************
; Update/Move Ghost common routine
; IN: hl - VRAM address of Ghost
;     b - Sprite Shifted Flag
;     c - Ghost Move Direction
;     a - Ghost Freeze TImer
;     SPR_BASE_VAR - Ghost Sprite data - regular variant
;     SPR_2R_VAR - Ghost Sprite data - shifted 2px variant
UPDATE_MOVE_GHOST
; -- check Freeze Timer and if not 0 don't move Ghost - just decrement timer
	or a						; check if Ghost is freezed (Freeze Timer > 0)	;84ef	b7
	jp nz,DEC_FREEZE_TIMER		; yes - just decrement Freeze Timer				;84f0	c2 bf 86 

; -- Ghost isn't freezed anymore - first test collision with Player
	push bc						; save Shift Flag (b) and Move Direction (c)	;84f3	c5 
	push hl						; save hl - current VRAM address				;84f4	e5 
	call CMAP_GET_BYTE			; de - address in Colision Map					;84f5	cd e9 89 
	call TEST_KILL_PLAYER		; check collision with Player 					;84f8	cd 53 86

; -- clear screen area where Ghost was
	ld de,SPR.EMPTY				; Sprite Empty (8x4)px (2x4) bytes				;84fb	11 f1 8e 
	ex de,hl					; hl - sprite to draw, de - screen address		;84fe	eb
	ld bc,2						; bc - 2 bytes (8px) - sprite width				;84ff	01 02 00 
	ld a,4						; a - 4 lines (4px) - sprite height				;8502	3e 04  
	call DRAW_SPRITE			; draw sprite on screen	(clear)					;8504	cd 75 89 

; -- clear Ghost Bits in Collision Map 
	pop hl						; hl - VRAM address								;8507	e1
	call CMAP_GET_BYTE			; de - address in Colision Map					;8508	cd e9 89 
	ld b,%11101111				; bitmask to clear bit 4 (Ghost)				;850b	06 ef 
	call CMAP_CLEAR_2X4			; clear Ghost Bit (4) in Collision Map			;850d	cd 78 86 

; -- check if we use Sprite Shiftet 2px right - if so continue move in same direction
	pop bc						; restore Shift Flag (b) and Move Direction (c)	;8510	c1 
	ld a,b						; a - Sprite Shift Flag							;8511	78 
	or a						; check if Sprite is Shifted					;8512	b7 
	jp nz,CONT_GHOST_MOVE		; yes - continue moving (LEFT or RIGHT)			;8513	c2 a6 86

; -- sprite is NOT shifted - can move any direction now
; check current move direction and clear allow bit at opposite direction to avoid moving back and forth
	ld a,c						; a - current move direction					;8516	79 
	or a						; is moving UP?									;8517	b7 
	jp z,SPR_MOVE_NO_DOWN		; yes - eliminate DOWN Direction from CMap byte	;8518	ca 28 85 
	cp 1						; is moving RIGHT?								;851b	fe 01 
	jp z,SPR_MOVE_NO_LEFT		; yes - eliminate LEFT Direction from CMap byte	;851d	ca 38 85 
	cp 2						; is moving DOWN?								;8520	fe 02 
	jp z,SPR_MOVE_NO_UP			; yes - eliminate UP Direction from CMap byte	;8522	ca 30 85
	jp SPR_MOVE_NO_RIGHT		; moving LEFT - eliminate RIGHT Direction		;8525	c3 40 85 

; -- eliminate DOWN direction from possible moves and determine next move
SPR_MOVE_NO_DOWN
	call CMAP_GET_BYTE			; a - byte from Collision Map					;8528	cd e9 89 
	and %00001011				; clear Down Direction Bit						;852b	e6 0b 	
	jp FIND_GHOST_MOVE			; move Ghost in 1 of 3 direction				;852d	c3 45 85 

; -- eliminate UP direction from possible moves and determine next move
SPR_MOVE_NO_UP:
	call CMAP_GET_BYTE			; a - byte from Collision Map					;8530	cd e9 89 
	and %00001110				; clear Up Direction Bit						;8533	e6 0e 
	jp FIND_GHOST_MOVE			; move Ghost in 1 of 3 direction				;8535	c3 45 85 

; -- eliminate LEFT direction from possible moves and determine next move
SPR_MOVE_NO_LEFT:
	call CMAP_GET_BYTE			; a - byte from Collision Map					;8538	cd e9 89 
	and %00000111				; clear Left Direction Bit						;853b	e6 07  
	jp FIND_GHOST_MOVE			; move Ghost in 1 of 3 direction				;853d	c3 45 85  

; -- eliminate RIGHT direction from possible moves and determine next move
SPR_MOVE_NO_RIGHT:
	call CMAP_GET_BYTE			; a - byte from Collision Map					;8540	cd e9 89 
	and %00001101				; clear Right Direction Bit						;8543	e6 0d 

FIND_GHOST_MOVE
	ld e,a						; e - byte from CMap with Bit cleared			;8545	5f 

; -- if Chase Mode is Active Ghost will run away (random direction),
	ld a,(CMODE_ON_TIMER)		; a - Ghost Chase Mode Timer					;8546	3a 2c 80 
	or a						; is Chase Mode active?							;8549	b7 
	jp nz,TRY_MOV_RANDOM		; yes - move Ghost to random direction	(run)	;854a	c2 c1 85 

; -- Chase Mode is inactive - Ghost will try to chase Player - try to move to direction where Player is
	ld a,r						; a - random byte								;854d	ed 5f 
	bit 0,a						; random preference - Horizontal or Vertical	;854f	cb 47 
	jp z,TRY_CHASE_PLAYER_V		; yes - chase Player Up or Down					;8551	ca 9b 85 
	jp TRY_CHASE_PLAYER_H		; no - chase Player Left or Right				;8554	c3 66 85

;***********************************************************************************************
; Compare X position of Ghost and Player
; IN: hl - Ghost VRAM address
CMP_PLAYER_X_POS
	push bc						; save bc										;8557	c5  
; -- calculate Player X position (in screen bytes)
	ld bc,(PLAYER_VADR)			; bc - player screen coord (VRAM address)		;8558	ed 4b 0d 80
	ld a,c						; a - low byte of address						;855c	79 
	and $1f						; range 0..31 -  - Palyer X position			;855d	e6 1f 
	ld c,a						; store in c to compare later					;855f	4f 
; -- calculate Ghost X position (in screen bytes)
	ld a,l						; a - low byte of Ghost address					;8560	7d 
	and $1f						; range 0..31 -  - Ghost X position				;8561	e6 1f 
; -- compare values 
	cp c						; compare with Player X position				;8563	b9 
; -- - Sign Flag is set if Player is on right side of Ghost (Ghost X pos < Player X pos)
	pop bc						; restore saved bc								;8564	c1 
	ret							; --------- End of Proc (Flags) --------		;8565	c9 

;***********************************************************************************************
; Try move Ghost to Left or Right depending on which side is Player
; If none of above is possible, try chase Player Up or Down
; If it is still impossible, try random move
TRY_CHASE_PLAYER_H
	call CMP_PLAYER_X_POS		; is Player somewhere on left from Ghost 		;8566	cd 57 85 
	jp p,TRY_CHASE_PLAYER_LEFT	; yes - try move left							;8569	f2 74 85  
; -- player is somewhere on right from Ghost - try move right	
	bit 1,e						; is Wall on RIGHT?								;856c	cb 4b 
	jp nz,SPR_MOVE_RIGHT_SO		; no - move sprite Right (shift sprite only)	;856e	c2 23 86 
; -- can't chase Player Right - try Up or Down
	jp CHASE_PLAYER_UP_DOWN		; yes - so try move Up or Down					;8571	c3 79 85 

TRY_CHASE_PLAYER_LEFT
	bit 3,e						; is Wall on LEFT?								;8574	cb 5b 
	jp nz,SPR_MOVE_LEFT			; no - move sprite Left (VRAM will change)		;8576	c2 2e 86 

; -- can't chase Player Left or Right - try Up or Down
;***********************************************************************************************
; Try move Ghost Up or Down depending on if Player is above or below
CHASE_PLAYER_UP_DOWN
	call CMP_PLAYER_Y_POS		; is Player somewhere above Ghost 				;8579	cd 8f 85 
	jp p,CHASE_PLAYER_UP		; yes - try move up								;857c	f2 87 85  
; -- player is somewhere below Ghost - try move down	
	bit 2,e						; is Wall DOWN below							;857f	cb 53 
	jp nz,SPR_MOVE_DOWN			; no - move sprite Down (VRAM will change)		;8581	c2 16 86 
; -- can't chase Player Down - try random move in any direction
	jp TRY_MOV_RANDOM			; yes - move Ghost in random Direction			;8584	c3 c1 85 

CHASE_PLAYER_UP
	bit 0,e						; is Wall Up above?								;8587	cb 43 
	jp nz,SPR_MOVE_UP			; no - move sprite Up (VRAM will change)		;8589	c2 07 86  
; -- can't chase Player Up - try random move in any direction
	jp TRY_MOV_RANDOM			; yes - move Ghost in random Direction			;858c	c3 c1 85  


;***********************************************************************************************
; Compare Y position of Ghost and Player
; IN: hl - Ghost VRAM address
CMP_PLAYER_Y_POS
	push hl						; save hl 										;858f	e5 
	push bc						; save bc										;8590	c5 
; -- calculate difference beetween Player and Ghost positions on screen (in bytes)
	ld bc,(PLAYER_VADR)			; bc - Player screen coord (VRAM address)		;8591	ed 4b 0d 80
	or a						; clear Carry flag								;8595	b7 
	sbc hl,bc					; compare Ghost adr with Player adr				;8596	ed 42 
; -- Sign Flag is set if Player is below Ghost (Player VRAM sddr > Ghost VRAM addr)
	pop bc						; restore bc									;8598	c1 
	pop hl						; restore hl									;8599	e1 
	ret							; --------------- End of Proc (Flags) ---------	;859a	c9 

;***********************************************************************************************
; Try move Ghost Up or Down depending on if Player is above or below
; If none of above is possible, try chase Player Left or Right
; If it is still impossible, try random move
TRY_CHASE_PLAYER_V
	call CMP_PLAYER_Y_POS		; is Player somewhere above Ghost 				;859b	cd 8f 85 
	jp p,TRY_CHASE_PLAYER_UP	; yes - try move up								;859e	f2 a9 85 
; -- player is somewhere below Ghost - try move down	
	bit 2,e						; is Wall Down below							;85a1	cb 53
	jp nz,SPR_MOVE_DOWN			; no - move sprite Down (VRAM will change)		;85a3	c2 16 86  
; -- can't chase player Down
	jp CHASE_PLAYER_LEFT_RIGHT	; try to chase Player Left or Right				;85a6	c3 ae 85 

TRY_CHASE_PLAYER_UP
	bit 0,e						; is Wall Up above								;85a9	cb 43 
	jp nz,SPR_MOVE_UP			; no - move sprite Up (VRAM will change)		;85ab	c2 07 86 	 

; -- can't chase Player Up or Down - try Left or Right 
;***********************************************************************************************
; Try move Ghost Left or Right depending on which side is Player
CHASE_PLAYER_LEFT_RIGHT:
	call CMP_PLAYER_X_POS		; is Player somewhere on left from Ghost 		;85ae	cd 57 85 
	jp p,CHASE_PLAYER_LEFT		; yes - try move left							;85b1	f2 bc 85 
; -- player is somewhere on right from Ghost - try move right
	bit 1,e						; is Wall on Right side							;85b4	cb 4b
	jp nz,SPR_MOVE_RIGHT_SO		; no - move sprite Right (shift sprite only)	;85b6	c2 23 86  
; -- can't chase Player - try random move
	jp TRY_MOV_RANDOM			; try random move in any direction				;85b9	c3 c1 85 

; -- player is somewhere on Left from Ghost - try move Left
CHASE_PLAYER_LEFT:
	bit 3,e						; is Wall on Left side							;85bc	cb 5b 
	jp nz,SPR_MOVE_LEFT			; no - move sprite Left (VRAM will change)		;85be	c2 2e 86  
; -- can't chase Player - try random move

;***********************************************************************************************
; Move Ghost in Random direction
TRY_MOV_RANDOM:
	ld a,r						; a - random value								;85c1	ed 5f 
	bit 0,a						; bit 0 - random pref Vertical or Horizontal	;85c3	cb 47 
	jp z,TRY_MOV_RND_VERT		; try random move Up or Down					;85c5	ca e6 85  

;***********************************************************************************************
; Move Ghost Horizontal in Random direction (Left or Right)
TRY_MOV_RND_HORIZ
	ld a,r						; a - random value								;85c8	ed 5f 
	bit 0,a						; check bit 0 - random preference Left or Right ;85ca	cb 47 
	jp z,TRY_MOVE_LEFT_OR_RIGHT	; bit is set - try move Left then Right			;85cc	ca dc 85 
; -- bit is not set - try move Right and then Left	
	bit 1,e						; is Wall on Right side							;85cf	cb 4b  
	jp nz,SPR_MOVE_RIGHT_SO		; no - move sprite Right (shift sprite only)	;85d1	c2 23 86  
	bit 3,e						; is Wall on Left side							;85d4	cb 5b 
	jp nz,SPR_MOVE_LEFT			; no - move sprite Left (VRAM will change)		;85d6	c2 2e 86 
; -- can't move Right nor Left
	jp TRY_MOV_RND_VERT			; try random move Up or Down					;85d9	c3 e6 85 

TRY_MOVE_LEFT_OR_RIGHT:
	bit 3,e						; is Wall on Left side							;85dc	cb 5b
	jp nz,SPR_MOVE_LEFT			; no - move sprite Left (VRAM will change)		;85de	c2 2e 86  
; -- can't move Left - try move Right
	bit 1,e						; is Wall on Right side							;85e1	cb 4b 
	jp nz,SPR_MOVE_RIGHT_SO		; no - move sprite Right (shift sprite only)	;85e3	c2 23 86  
; -- can't move Left nor Right - try random Up or Down

;***********************************************************************************************
; Move Ghost Vertical in Random direction (Up or Down)
TRY_MOV_RND_VERT:
	ld a,r						; a - random value								;85e6	ed 5f 
	bit 0,a						; check bit 0 - random Up or Down				;85e8	cb 47 
	jp z,TRY_MOV_UP_OR_DOWN		; bit is set - try Up then Down					;85ea	ca fa 85 
; -- bit is not set - try Down then Up
	bit 2,e						; is Wall Down below							;85ed	cb 53 
	jp nz,SPR_MOVE_DOWN			; no - move sprite Down (VRAM will change)		;85ef	c2 16 86  
; -- can't move Down - try move Up
	bit 0,e						; is Wall Up above								;85f2	cb 43  
	jp nz,SPR_MOVE_UP			; no - move sprite Up (VRAM will change)		;85f4	c2 07 86  
; -- cant move Down nor Up
	jp TRY_MOV_RND_HORIZ		; try random move Left or Right					;85f7	c3 c8 85 

TRY_MOV_UP_OR_DOWN
	bit 0,e						; is Wall Up above								;85fa	cb 43 
	jp nz,SPR_MOVE_UP			; no - move sprite Up (VRAM will change)		;85fc	c2 07 86  
; -- can't move up - try move down
	bit 2,e						; is Wall Down below							;85ff	cb 53 
	jp nz,SPR_MOVE_DOWN			; no - move sprite Down (VRAM will change)		;8601	c2 16 86  
; -- cant move Up nor Down
	jp TRY_MOV_RND_HORIZ		; try random move Left or Right					;8604	c3 c8 85 

SPR_MOVE_UP
	ld c,0						; set Move Direction Up							;8607	0e 00 
	ld de,32					; 32 bytes per screen line						;8609	11 20 00 
	or a						; clear Carry flag								;860c	b7 
	sbc hl,de					; new VRAM address (1 line above)				;860d	ed 52 
	ld de,(SPR_BASE_VAR)		; not shifted variant of Ghost Sprite			;860f	ed 5b eb 84
	jp DRAW_GHOST				; draw Ghost Sprite								;8613	c3 37 86 
	 
SPR_MOVE_DOWN
	ld c,2						; set Move Direction Down						;8616	0e 02 
	ld de,32					; 32 bytes per screen line						;8618	11 20 00 
	add hl,de					; new VRAM address (1 line below)				;861b	19 
	ld de,(SPR_BASE_VAR)		; not shifted variant of Ghost Sprite			;861c	ed 5b eb 84
	jp DRAW_GHOST				; draw Ghost Sprite								;8620	c3 37 86 

SPR_MOVE_RIGHT_SO
	ld c,1						; set Move Direction Right						;8623	0e 01 
	ld b,1						; set Sprite Shifted Flag						;8625	06 01 
	ld de,(SPR_2R_VAR)			; 2px shifted variant of Ghost Sprite			;8627	ed 5b ed 84  
	jp DRAW_GHOST				; draw Ghost Sprite								;862b	c3 37 86  

SPR_MOVE_LEFT
	ld c,3						; set Move Direction Left						;862e	0e 03 
	dec hl						; new VRAM addres (to left)						;8630	2b 
	ld b,1						; set Sprite Shifted Flag						;8631	06 01 
	ld de,(SPR_2R_VAR)			; 2px shifted variant of Ghost Sprite			;8633	ed 5b ed 84

;***********************************************************************************************
; Draw Ghost Sprite and update Collision Map
; IN: hl - destination VRAM address
;     de - address of Ghost sprite to draw
; OUT: hl - Ghost VRAM address (position on screen)
;      b - Sprite Shifted Flag (1 if shifted 2px right)
;      c - Ghost Move Direction
;      a - Ghost Freeze Timer 
DRAW_GHOST:
	push bc						; save bc										;8637	c5 
; -- draw Ghost Sprite on Screen
	push hl						; save hl - VRAM address						;8638	e5 
	ex de,hl					; de - VRAM target address, hl - sprite source	;8639	eb 
	ld bc,2						; bc - 2 bytes (8px) - sprite width				;863a	01 02 00 
	ld a,4						; a - 4 lines (4px) - sprite height				;863d	3e 04
	call DRAW_SPRITE			; draw sprite on screen							;863f	cd 75 89 
	pop hl						; restore hl - VRAM address						;8642	e1 
; -- mark Ghost position in Collision Map
	push hl						; save hl										;8643	e5 
	call CMAP_GET_BYTE			; de - address in Colision Map					;8644	cd e9 89 
	ld b,%00010000				; Ghost Bit (4) to set in Collision Map			;8647	06 10 
	call CMAP_SET_2X4			; set Ghost Bit (6) in CMap (8x4)px (2x4)bytes 	;8649	cd 8f 86 
; -- test Collision with Player
	call TEST_KILL_PLAYER		; check collision with Player 					;864c	cd 53 86  
	pop hl						; restore hl - VRAM address						;864f	e1
	pop bc						; restore bc - direction and shift flag			;8650	c1 
	xor a						; a - turn off Ghost Freeze Timer				;8651	af 
	ret							; ---------- End of Proc -------------------	;8652	c9 


TEST_KILL_PLAYER:
; -- if Chase Mode is active Ghost can't kill Player
	ld a,(CMODE_ON_TIMER)		; a - Ghost Chase Mode Timer					;8653	3a 2c 80 
	or a						; is Chase Mode active?							;8656	b7 
	ret nz						; yes ---------- End of Proc ------------------	;8657	c0 

; -- Chase Mode is inactive - chceck collision with Player 	
	push hl						; save hl - Ghost VRAM address					;8658	e5 
	push de						; save de - address in Collision Map			;8659	d5 
	ex de,hl					; hl - address in Collision Map					;865a	eb 
	ld de,31					; 31 bytes per line (32-1 handled below)		;865b	11 1f 00 
	bit 5,(hl)					; check if Player Bit (5) is set in CMap		;865e	cb 6e 
	inc hl						; point to next byte							;8660	23 
	jp z,.NEXT_LINE				; no - check next line							;8661	ca 69 86
; -- bit is set - there is Player (left side)
	bit 5,(hl)					; check if Player Bit (5) is set in CMap		;8664	cb 6e 
	jp nz,KILL_PLAYER			; yes - both are set - Kill Player				;8666	c2 dc 86 
.NEXT_LINE:
	add hl,de					; point to next line in Collision Map			;8669	19 
	bit 5,(hl)					; check if Player Bit (5) is set in CMap		;866a	cb 6e 
	jp z,.EXIT					; no - there is no collision					;866c	ca 75 86 
; -- bit is set - there is Player (left side)
	inc hl						; point to next byte							;866f	23 
	bit 5,(hl)					; check if Player Bit (5) is set in CMap		;8670	cb 6e 
	jp nz,KILL_PLAYER			; yes - Kill Player								;8672	c2 dc 86 
.EXIT:
	pop de						; restore de - address in Collision Map			;8675	d1 
	pop hl						; restore hl - Ghost VRAM address				;8676	e1 
	ret							; ---------- End of Proc ----------------------	;8677	c9 

;***********************************************************************************************
; Clear bit(s) of specified area (8x4px) bytes in Collision Map
; IN de - adress in Collision Map 
;     b - mask to clear bits
CMAP_CLEAR_2X4
	push hl						; save hl										;8678	e5 
	push de						; save de										;8679	d5 
	ex de,hl					; hl - addres in Buffer							;867a	eb 
	ld de,31					; 31 bytes per screen line						;867b	11 1f 00 
	ld c,4						; 4 lines to draw								;867e	0e 04 
.NEXT_LINE:
	ld a,b						; b - mask to clear pixels 						;8680	78 
	and (hl)					; a - masked byte from Buffer					;8681	a6 
	ld (hl),a					; store back to Buffer							;8682	77 
	inc hl						; next address in Buffer						;8683	23 
	ld a,b						; b - mask to clear pixels						;8684	78 
	and (hl)					; a - masked byte from Buffer					;8685	a6 
	ld (hl),a					; store back to Buffer							;8686	77 
	add hl,de					; next address in Buffer - 1 line below			;8687	19 
	dec c						; check if all 4 lines processed				;8688	0d 
	jp nz,.NEXT_LINE			; no - process 2 bytes in next line 			;8689	c2 80 86
	pop de						; restore de									;868c	d1 
	pop hl						; restore hl									;868d	e1 
	ret							; -------------- End of Proc ---------------	;868e	c9 


;***********************************************************************************************
; Set bit(s) of specified area (8x4px) bytes in Collision Map
; IN de - adress in Collision Map 
;     b - mask to set bits
CMAP_SET_2X4:
	push hl						; save hl										;868f	e5 
	push de						; save de										;8690	d5 
	ex de,hl					; hl - addres in Buffer							;8691	eb 
	ld de,31					; 31 bytes per screen line						;8692	11 1f 00 
	ld c,4						; 4 lines to draw								;8695	0e 04  
.NEXT_LINE:
	ld a,b						; b - mask to set pixels 						;8697	78 
	or (hl)						; a - byte from Buffer with bits set			;8698	b6 
	ld (hl),a					; store back to Buffer							;8699	77 	
	inc hl						; next address in Buffer						;869a	23 
	ld a,b						; b - mask to set pixels 						;869b	78  
	or (hl)						; a - byte from Buffer with bits set			;869c	b6  
	ld (hl),a					; store back to Buffer							;869d	77  
	add hl,de					; next address in Buffer - 1 line below			;869e	19  
	dec c						; check if all 4 lines processed				;869f	0d  
	jp nz,.NEXT_LINE			; no - process 2 bytes in next line 			;86a0	c2 97 86 
	pop de						; restore de									;86a3	d1 
	pop hl						; restore hl									;86a4	e1  
	ret							; -------------- End of Proc ---------------	;86a5	c9 

;***********************************************************************************************
; Continue Ghost Move in current direction 
; When sprite used for Ghost is shifted 2px right then Ghost can move only Left or Right
; However game is trying to avoid movig Ghost in dirtection where it comes from, so the only move
; possible in such case is the same as was just before.
CONT_GHOST_MOVE:
	ld a,c						; a - Ghost Move Direction						;86a6	79 
	cp 1						; check if Ghost is moving Right				;86a7	fe 01 
	jp z,GHOST_MOVE_RIGHT		; yes - move sprite Right again					;86a9	ca b5 86 

; -- Ghost is moving Left so do this again (without VRAM addres change)
	ld b,0						; b - use nonshifted Ghost Sprite 				;86ac	06 00 
	ld de,(SPR_BASE_VAR)		; de - Ghost Sprite in nonshifted variant		;86ae	ed 5b eb 84 
	jp DRAW_GHOST				; draw Ghost									;86b2	c3 37 86 

;***********************************************************************************************
; Move selected Ghost Right - next VRAM byte
; Sprite was already shifted (b != 0) so change position to next VRAM byte
; -- b != 0 && c = 1
GHOST_MOVE_RIGHT
	inc hl						; next VRAM address								;86b5	23 
	ld b,0						; clear Sprite Shifted Flag						;86b6	06 00 
	ld de,(SPR_BASE_VAR)		; use Base Variant Sprite						;86b8	ed 5b eb 84
	jp DRAW_GHOST				; draw Ghost at new position					;86bc	c3 37 86

;***********************************************************************************************
; Decrement Ghost Freeze Timer
; Every Ghost has assigned at start some random Freeze time. Until this time elapse 
; Ghost doesn't move
DEC_FREEZE_TIMER:
; -- check if game is in Chase Mode - don't decrement Ghost Freeze Timer in Chase Mode
	ld e,a						; e - save a - Ghost's Freeze Timer				;86bf	5f
	ld a,(CMODE_ON_TIMER)		; a - Ghost Chase Mode Timer					;86c0	3a 2c 80 
	or a						; is Chase Mode active?							;86c3	b7  
	ld a,e						; restore a - Ghost's Freeze Timer				;86c4	7b
	ret nz						; yes ------- End of Proc --------------------	;86c5	c0 

; -- Chase Mode is inactive - decrement Freeze Timer and return if not 0	
	dec a						; decrement Freeze Timer - check if 0			;86c6	3d 
	ret nz						; no ---------End of Proc ---------------------	;86c7	c0 

; -- Freeze Timer reached 0 - remove Ghost from current screen position
	ld de,SPR.EMPTY				; Sprite Empty (8x4)px (2x4) bytes				;86c8	11 f1 8e
	ex de,hl					; hl - sprite address, de - VRAM address		;86cb	eb 
	ld bc,2						; bc - 2 bytes (8px) - sprite width				;86cc	01 02 00 	
	ld a,4						; a - 4 lines (4px) - sprite height				;86cf	3e 04  
	call DRAW_SPRITE			; draw sprite on screen (clear)					;86d1	cd 75 89  

; -- reset Ghost Sprite data to initial values
	ld bc,$0000					; Move Direction = 0, Sprite Shifted Flag = 0	;86d4	01 00 00 
	ld hl,VRAM+(30*32)+13		; screen coord (52,30)px (13,30)bytes			;86d7	21 cd 73 
	xor a						; new Freeze Time 0 - moving enabled			;86da	af 
	ret							; ---------- End of Proc ----------------		;86db	c9 	

;***********************************************************************************************
; Kill Player
; Remove Player and all Ghosts from Collision Map and flash screen colors 6 time.
; Next decrement Life Counter and if it's not 0 start again this Level otherwise show Game Over screen.
; There is no need to remove sprites from screen because in both cases screen will be reinitialized. 
KILL_PLAYER:
; -- clear Player position in Collision Map
	ld hl,(PLAYER_VADR)			; VRAM address of Player						;86dc	2a 0d 80 
	call CMAP_GET_BYTE			; de - address in Collision Map					;86df	cd e9 89 
	ld b,%11011111				; bitmask to clear Player Bit (5)				;86e2	06 df 
	call CMAP_CLEAR_2X4			; clear Player Bit (5) in Collision Map			;86e4	cd 78 86 
; -- clear Ghost Blue 1 position in Collision Map
	ld hl,(GHOST_B1.VADR)		; VRAM address of Ghost Blue 1					;86e7	2a 18 80 
	call CMAP_GET_BYTE			; de - address in Collision Map					;86ea	cd e9 89 	
	ld b,%11101111				; bitmask to clear Ghost Bit (4)				;86ed	06 ef 
	call CMAP_CLEAR_2X4			; clear Ghost Bit (4) in Collision Map			;86ef	cd 78 86 
; -- clear Ghost Blue 2 position in Collision Map
	ld hl,(GHOST_B2.VADR)		; VRAM address of Ghost Blue 2					;86f2	2a 1d 80 
	call CMAP_GET_BYTE			; de - address in Collision Map					;86f5	cd e9 89 
	ld b,%11101111				; bitmask to clear Ghost Bit (4)				;86f8	06 ef 
	call CMAP_CLEAR_2X4			; clear Ghost Bit (4) in Collision Map			;86fa	cd 78 86 
; -- clear Ghost Red 1 position in Collision Map
	ld hl,(GHOST_R1.VADR)		; VRAM address of Ghost Red 1					;86fd	2a 22 80 
	call CMAP_GET_BYTE			; de - address in Collision Map					;8700	cd e9 89 
	ld b,%11101111				; bitmask to clear Ghost Bit (4)				;8703	06 ef 
	call CMAP_CLEAR_2X4			; clear Ghost Bit (4) in Collision Map			;8705	cd 78 86 
; -- clear Ghost Red 2 position in Collision Map
	ld hl,(GHOST_R2.VADR)		; VRAM address of Ghost Red 2					;8708	2a 27 80 
	call CMAP_GET_BYTE			; de - address in Collision Map					;870b	cd e9 89 
	ld b,%11101111				; bitmask to clear Ghost Bit (4)				;870e	06 ef 
	call CMAP_CLEAR_2X4			; clear Ghost Bit (4) in Collision Map			;8710	cd 78 86 
; -- flash screen 6 times 	
	call FLASH_SCREEN			; flash screeen 6 times 						;8713	cd 31 87
; -- decrement Life Counter
	ld a,(MEN_LIVES)			; a - current number of Lives/Men				;8716	3a 04 80 
	dec a						; decrement value (check if 0)					;8719	3d 
	ld (MEN_LIVES),a			; store new value								;871a	32 04 80 
	jp nz,GAME_LEVEL_START		; start again the same Level gameplay			;871d	c2 87 81 
; -- no more Lives left - Game Over
	call GAME_OVER				; show Game Over Screen							;8720	cd 91 82 
; -- wait delay 
	ld a,20						; a - delay repeat counter 						;8723	3e 14 
GO_DELAY:
	push af						; save af										;8725	f5 
	call DELAY_BC				; wait daly (bc == 0 == 65536)					;8726	cd 5d 87 
	pop af						; restore af									;8729	f1 
	dec a						; decrement repeat counter						;872a	3d 
	jp nz,GO_DELAY				; repeat 20 times								;872b	c2 25 87
	jp GAME_START				; ------------ Start New Game ------------		;872e	c3 fa 80 

;***********************************************************************************************
; Flash Screen
FLASH_SCREEN:
	ld a,6						; number of screen flashes to display			;8731	3e 06 
.INVERT_PIXELS:
	push af						; save af - flash counter						;8733	f5
; -- invert all pixels on screen
	ld hl,VRAM					; start of Video RAM							;8734	21 00 70 
	ld bc,64*32					; 2048 bytes - 32x64 bytes - 128x64px 			;8737	01 00 08 
.NEXT_BYTE:
	ld a,(hl)					; byte from screen								;873a	7e
	xor $ff						; invert all pixels								;873b	ee ff 
	ld (hl),a					; save new byte to screen						;873d	77 
	inc hl						; next screen address							;873e	23 
	dec bc						; decrement bytes counter						;873f	0b 
	ld a,b						; check if bc = 0								;8740	78 
	or c						; a = b|c										;8741	b1 
	jp nz,.NEXT_BYTE			; no - repeat for all pixels					;8742	c2 3a 87 
; -- play sounds
	call SND.PLAY_MiddleLong	; play sound (middle/long)						;8745	cd 40 80
	ld bc,$3000					; delay value									;8748	01 00 30 
	call DELAY_BC				; wait delay									;874b	cd 5d 87 
	call SND.PLAY_LowLong		; play sound (low/long)							;874e	cd 46 80 
	ld bc,$3000					; delay value									;8751	01 00 30 
	call DELAY_BC				; wait delay									;8754	cd 5d 87 
; -- repeat if needed
	pop af						; flash counter									;8757	f1 
	dec a						; check if 0									;8758	3d 
	jp nz,.INVERT_PIXELS		; no - repeat 6 times							;8759	c2 33 87 
	ret							; ---------------- End of Proc ----------		;875c	c9 

;***********************************************************************************************
; Delay 
; IN: bc - delay counter
DELAY_BC:
	dec bc						; decrement delay counter						;875d	0b 
	ld a,b						; check if bc = 0								;875e	78 
	or c						; a = b|c										;875f	b1 
	jp nz,DELAY_BC				; no - wait delay								;8760	c2 5d 87 
	ret							; ---------------- End of Proc ----------		;8763	c9 




;***********************************************************************************************
;
;   G A M E    L O O P  -  U P D A T E   P L A Y E R 
;
;***********************************************************************************************
GL_UPDATE_PLAYER:
; -- decrement and check Player Update Timer
	ld a,(PLAYER_UPD_TIMER)		; a - Player Update Timer						;8764	3a 12 80 
	dec a						; decrement Timer - check if elapsed			;8767	3d 
	ld (PLAYER_UPD_TIMER),a		; store new value								;8768	32 12 80 
	ret nz						; no ------------- End of Proc ----------------	;876b	c0 
; -- reset Timer to initial value 188
	ld a,188					; initial value for Player Update Timer			;876c	3e bc 
	ld (PLAYER_UPD_TIMER),a		; set new value									;876e	32 12 80 
; -- push on Stack address of routine to RETurn from jumps 
	ld hl,PLAYER_MOVE			; address of Proc to continue 					;8771	21 b1 87
	push hl						; set as RETurn from routine					;8774	e5 

; -- clear screeen area at Player position	
	ld de,(PLAYER_VADR)			; de - Player's VRAM address					;8775	ed 5b 0d 80 
	push de						; save de 										;8779	d5 
	ld hl,SPR.EMPTY				; Sprite Empty (8x4)px (2x4) bytes				;877a	21 f1 8e 
	ld bc,2						; bc - 2 bytes (8px) - sprite width				;877d	01 02 00 
	ld a,4						; a - 4 lines (4px) - sprite height				;8780	3e 04  
	call DRAW_SPRITE			; draw sprite on screen (clear)					;8782	cd 75 89 
; -- clear Player Bit (5) in Collision Map for this area
	pop hl						; hl - Player's VRAM address					;8785	e1 
	call CMAP_GET_BYTE			; de - address in Collision Map					;8786	cd e9 89 
	ld b,%11011111				; bitmask to clear Player Bit (5)				;8789	06 df  
	call CMAP_CLEAR_2X4			; clear Player Bit (5) in Collision Map			;878b	cd 78 86 

	call TEST_KILL_GHOST		; check collision with any Ghost				;878e	cd 15 88 
; -- preload Player Sprite Props 
	ld a,(PLAYER_PROPS)			; Player Move Direction							;8791	3a 0f 80
	ld b,a						; b - current Move Direction 					;8794	47 
	ld a,(PLAYER_PROPS+1)		; Sprite Shifted Flag							;8795	3a 10 80 
	ld c,a						; c - Sprite Shifted Flag						;8798	4f 
; -- read keys pressed and joystick (if enabled) - bit=1 -> input registered
	call INPUT.READ_INPUT		; read user input - a - input bitmask			;8799	cd 42 8f 
	bit INPUT.UP,a				; is UP key pressed								;879c	cb 47 
	jp nz,TEST_MOVE_UP			; yes - try to move player UP					;879e	c2 f2 89
	bit INPUT.DOWN,a			; is DOWN key pressed							;87a1	cb 4f 
	jp nz,TEST_MOVE_DOWN		; yes - try to move player DOWN					;87a3	c2 fe 89
	bit INPUT.LEFT,a			; is LEFT key pressed							;87a6	cb 57 
	jp nz,TEST_MOVE_LEFT		; yes - try to move player LEFT					;87a8	c2 16 8a
	bit INPUT.RIGHT,a			; is RIGHT key pressed							;87ab	cb 5f 
	jp nz,TEST_MOVE_RIGHT		; yes - try to move player RIGHT				;87ad	c2 0a 8a 

; -- no keys pressed - no move change required
	pop de						; remove from Stack RETurn address				;87b0	d1 
PLAYER_MOVE
; -- push on Stack address of routine to RETurn from jumps 
	ld de,PLAYER_UPDATE			; address of Proc to continue					;87b1	11 c7 87 
	push de						; set as RETurn from subroutine 				;87b4	d5 
; -- try to move player 
	ld a,b						; Player move direction							;87b5	78 
	or a						; is facing UP (0)								;87b6	b7 
	jp z,PLAYER_MOVE_UP			; yes - move Player 1 line Up					;87b7	ca 87 89 
	cp 1						; is facing RIGHT (1)							;87ba	fe 01 
	jp z,PLAYER_MOVE_RIGHT		; yes - move Player 2px (??) Right				;87bc	ca ad 89 
	cp 2						; is facing DOWN (2)							;87bf	fe 02 
	jp z,PLAYER_MOVE_DOWN		; yes - move Player 1 line Down					;87c1	ca 9b 89 
; -- is facing LEFT (3)
	jp PLAYER_MOVE_LEFT			; move Player 2px (??) Left						;87c4	c3 cb 89 

; -- hl - destination VRAM address for Player, b - move direction, c - sprite shifted flag
PLAYER_UPDATE:
; -- store new values
	ld (PLAYER_VADR),hl			; sore new VRAM address of Player Sprite		;87c7	22 0d 80 
	ld a,b						; a - player move direction 					;87ca	78 
	ld (PLAYER_PROPS),a			; store as current 								;87cb	32 0f 80 
	ld a,c						; a - is sprite is shifted 2px right			;87ce	79 
	ld (PLAYER_PROPS+1),a		; store as current								;87cf	32 10 80 
	push hl						; save hl - Player VRAM address					;87d2	e5 
	ex de,hl					; de - destination to draw sprite				;87d3	eb 
	ld a,c						; Sprite Shifter Flag							;87d4	79 
	or a						; is shifted 2px right?							;87d5	b7 
	jp nz,.DRAW_SHIFTED			; yes - draw shifted variant of sprite			;87d6	c2 ea 87 
; -- check if Playar changes move direction
	ld a,(PLAYER_ANIM)			; a - player Animation Flag						;87d9	3a 11 80 
	or a						; is this animation frame ?						;87dc	b7 
	jp z,.SET_ANIM_FLAG			; no - set Flag and draw regular Player sprite	;87dd	ca fc 87 

; -- in this frame - use Animated Sprite Variant and toggle (clear) Animation Flag
	ld hl,SPR.PLAYER_ANIM		; Sprite Player (animation frame)				;87e0	21 e9 8e 
	xor a						; reset value									;87e3	af 
	ld (PLAYER_ANIM),a			; clear Animation Flag							;87e4	32 11 80 
	jp DRAW_PLAYER				; --------- draw sprite on screen ----------	;87e7	c3 03 88 

; -- draw player using shifted variant of sprite
.DRAW_SHIFTED
	ld a,b						; a - player moving direction					;87ea	78 
	cp 1						; is player faicing right ?						;87eb	fe 01 
	jp z,.DRAW_PLAYER_R_SH		; yes - draw Player facing right				;87ed	ca f6 87

.DRAW_PLAYER_L_SH
; -- draw player using shifted variant of sprite (facing Left)
	ld hl,SPR.PLAYER_L_SH		; Sprite Player (facing Left) shifted 2px right	;87f0	21 d1 8e 
	jp DRAW_PLAYER				; --------- draw sprite on screen ----------	;87f3	c3 03 88 
	 
; -- draw player using shifted variant of sprite (facing Right)
.DRAW_PLAYER_R_SH:
	ld hl,SPR.PLAYER_R_SH		; Sprite Player (facing Right) shifted 2px right;87f6	21 c9 8e 
	jp DRAW_PLAYER				; --------- draw sprite on screen ----------	;87f9	c3 03 88 

; -- set Animation Flag and draw player using current sprite 
.SET_ANIM_FLAG:
	inc a						; toggle (set) Animation Flag					;87fc	3c 
	ld (PLAYER_ANIM),a			; next time draw Animated Sprite Variant		;87fd	32 11 80 
	ld hl,(PLAYER_SADR)			; address of current Player Sprite Variant		;8800	2a 0b 80  

; -- de - destination VRAM address, hl - sprite data address
DRAW_PLAYER:
	ld bc,2						; bc - 2 bytes (8px) - sprite width				;8803	01 02 00 
	ld a,4						; a - 4 lines (4px) - sprite height				;8806	3e 04 
	call DRAW_SPRITE			; draw sprite on screen							;8808	cd 75 89 
; -- check collision with 
	pop hl						; hl - destination VRAM address					;880b	e1 
	call CMAP_GET_BYTE			; de - address in Buffer, a - byte from Buffer	;880c	cd e9 89 
	call TEST_KILL_GHOST		; check collision with any Ghost				;880f	cd 15 88 
	jp TEST_EAT_STUFF			; check Collision with Dots, Power Pills, Heart ;8812	c3 e3 88 


;***********************************************************************************************
; Test Player collision with Ghost but only if Ghost Chase Mode is active
; Player can Kill Ghost only if Chase Mode is active.
; Collision when Ghost can KIll Player is tested in Ghosts Update routines (TEST_KILL_PLAYER)
TEST_KILL_GHOST
; -- check if Chase Mode is active 
	ld a,(CMODE_ON_TIMER)		; a - Ghost Chase Mode Timer					;8815	3a 2c 80 
	or a						; is Chase Mode active?							;8818	b7  
	ret z						; no ---------- End of Proc -------------------	;8819	c8 

; -- Chase Mode is active - check collision with any Ghost
	push hl						; save hl - Player VRAM address					;881a	e5 
	push de						; save de - address in Collision Map			;881b	d5 
	ex de,hl					; hl - address in Collision Map					;881c	eb 
	ld de,31					; 31 bytes per line (32-1 handled below)		;881d	11 1f 00 
	bit 4,(hl)					; check if Ghost Bit (4) is set in CMap			;8820	cb 66 
	inc hl						; point to next byte							;8822	23  
	jp z,.NEXT_LINE				; no - skip checking next byte					;8823	ca 2b 88 
; -- bit is set - there is Ghost (left side)
	bit 4,(hl)					; check if Ghost Bit (4) is set in CMap			;8826	cb 66  
	jp nz,KILL_GHOST			; yes - both are set - Kill Ghost				;8828	c2 3a 88 
.NEXT_LINE:
	add hl,de					; point to next line in Collision Map			;882b	19  
	bit 4,(hl)					; check if Ghost Bit (4) is set in CMap			;882c	cb 66  
	jp z,.EXIT					; no - there is no collision					;882e	ca 37 88 
; -- bit is set - there is Ghost (left side)
	inc hl						; point to next byte							;8831	23 
	bit 4,(hl)					; check if Ghost Bit (4) is set in CMap			;8832	cb 66  
	jp nz,KILL_GHOST			; yes - both are set - Kill Ghost				;8834	c2 3a 88  
.EXIT:
	pop de						; restore de - address in Collision Map			;8837	d1  
	pop hl						; restore hl - Player VRAM address				;8838	e1 
	ret							; --------------- End of Proc -----------------	;8839	c9 

KILL_GHOST:
; -- mark place (bytes) in Collision Map where Ghost was killed
	dec hl						; hl - addr of "sprite left byte" in CMap 		;883a	2b
	ld a,(hl)					; a - current CMap byte value					;883b	7e 
	ld (hl),$ff					; store Ghost Killed Here Flag					;883c	36 ff 
	push af						; save a - previous CMap value					;883e	f5 
	push hl						; save hl - address in Collision Map			;883f	e5 
; -- find Ghost that was killed and respawn it
	ld hl,(GHOST_B1.VADR)		; VRAM address of Ghost Blue 1					;8840	2a 18 80 
	call GHOST_HAS_KILL_FLAG	; check if Ghost Blue 1 was killed 				;8843	cd c2 88 
	jp z,RESPAWN_GHOST_B1		; yes - respawn Ghost Blue 1					;8846	ca 88 88 
	ld hl,(GHOST_B2.VADR)		; VRAM address of Ghost Blue 2					;8849	2a 1d 80 
	call GHOST_HAS_KILL_FLAG	; check if Ghost Blue 2 was killed 				;884c	cd c2 88 
	jp z,RESPAN_GHOST_B2		; yes - respawn Ghost Blue 2					;884f	ca 7e 88  
	ld hl,(GHOST_R1.VADR)		; VRAM address of Ghost Red 1					;8852	2a 22 80 
	call GHOST_HAS_KILL_FLAG	; check if Ghost Red 1 was killed 				;8855	cd c2 88 
	jp z,RESPAWN_GHOST_R1		; yes - respawn Ghost Red 1						;8858	ca 74 88 
	ld hl,(GHOST_R2.VADR)		; VRAM address of Ghost Red 2					;885b	2a 27 80 
	call GHOST_HAS_KILL_FLAG	; check if Ghost Red 2 was killed 				;885e	cd c2 88 
	jp z,RESPAWN_GHOST_R2		; yes - respawn Ghost Red 2						;8861	ca 6a 88 
; -- restore previous value of byte in Collision Map	
	pop hl						; restore hl - address in Collision Map			;8864	e1 
	pop af						; restore a - previous CMap value				;8865	f1 
	ld (hl),a					; restore previous value in Collision Map		;8866	77 
	pop de						; restore de - address in Collision Map			;8867	d1  
	pop hl						; restore hl - Player VRAM address				;8868	e1  
	ret							; --------------- End of Proc -----------------	;8869	c9 

;***********************************************************************************************
; Respawn Ghost in Ghost Cage - Multiple entries for every Ghost
RESPAWN_GHOST_R2:
	push hl					; save hl - current VRAM address					;886a	e5 
	ld hl,GHOST_R2.VADR		; VRAM address of Ghost Red 2						;886b	21 27 80 
	ld de,VRAM+(30*32)+16	; screen coord (64,30)px (16,30)bytes [$73d0]		;886e	11 d0 73 
	jp RESPAWN_GHOST		; spawn Ghost Red 2									;8871	c3 8f 88
RESPAWN_GHOST_R1:
	push hl					; save hl - current VRAM address					;8874	e5  
	ld hl,GHOST_R1.VADR		; VRAM address of Ghost Red 1						;8875	21 22 80 
	ld de,VRAM+(30*32)+14	; screen coord (56,30)px (14,30)bytes [$73ce]		;8878	11 ce 73
	jp RESPAWN_GHOST		; spawn Ghost Red 1									;887b	c3 8f 88 
RESPAN_GHOST_B2:
	push hl					; save hl - current VRAM address					;887e	e5  
	ld hl,GHOST_B2.VADR		; VRAM address of Ghost Blue 2						;887f	21 1d 80 
	ld de,VRAM+(30*32)+12	; screen coord (48,30)px (12,30)bytes [$73cc]		;8882	11 cc 73 
	jp RESPAWN_GHOST		; spawn Ghost Blue 2								;8885	c3 8f 88 
RESPAWN_GHOST_B1:
	push hl					; save hl - current VRAM address					;8888	e5 
	ld hl,GHOST_B1.VADR		; VRAM address of Ghost Blue 1						;8889	21 18 80 
	ld de,VRAM+(30*32)+10	; screen coord (40,30)px (10,30)bytes [$73ca]		;888c	11 ca 73 

; -- hl - Ghost VRAM address variable, de - VRAM address where Ghost will be drawn
RESPAWN_GHOST:
; -- fill GHOST variable structure to initial values
	ld (hl),e				; store low byte of spawn new VRAM address			;888f	73 
	inc hl					; address GHOST_xx.VRAM + 1							;8890	23 
	ld (hl),d				; store high byte of spawn new VRAM address			;8891	72 	
	inc hl					; address GHOST_xx.PROPS (Move Direction)			;8892	23 
	ld (hl),0				; reset value to 0 									;8893	36 00 
	inc hl					; address GHOST_xx.PROPS + 1 (Sprite Shift Flag)	;8895	23 
	ld (hl),0				; reset value to 0 									;8896	36 00 
	inc hl					; address GHOST_xx.FREEZE							;8898	23 
	call RANDOM_32_63		; a - Random Value in range 32..63					;8899	cd 03 84 
	ld (hl),a				; init Freeze Timer with Random value 				;889c	77 
; -- remove Ghost sprite from screen at old position
	pop de					; de - current (old) VRAM addres of Ghost			;889d	d1 
	push de					; save de											;889e	d5  
	ld hl,SPR.EMPTY			; Sprite Empty (8x4)px (2x4) bytes					;889f	21 f1 8e 
	ld bc,2					; bc - 2 bytes (8px) - sprite width					;88a2	01 02 00  
	ld a,4					; a - 4 lines (4px) - sprite height					;88a5	3e 04 
	call DRAW_SPRITE		; draw sprite on screen								;88a7	cd 75 89 
; -- restore Collision Map byte
	pop hl					; hl - current (old) VRAM addres of Ghost			;88aa	e1 
	pop de					; restore de - CMap address where Ghost was KIlled	;88ab	d1 
	pop af					; restore af - previous CMap byte value				;88ac	f1 
	ld (de),a				; replace Ghost Killed Flag ($ff) with prev value	;88ad	12 
; -- remove Ghost Bit (4) from Collision Map where Ghost was
	call CMAP_GET_BYTE		; de - address in Collision Map						;88ae	cd e9 89 
	ld b,%11101111			; bitmask to clear Ghost Bit (4)					;88b1	06 ef  
	call CMAP_CLEAR_2X4		; clear Ghost Bit (4) in Collision Map				;88b3	cd 78 86 
; -- add Points to Score and play Sound
	call SCORE_ADD_100		; add 100 points to Score							;88b6	cd 94 80 
	call SCORE_ADD_100		; add 100 points to Score (200 in total)			;88b9	cd 94 80 
	call SND.PLAY_LowShort	; generate Sound (low/short)						;88bc	cd 34 80 
	pop de					; restore de - address in Collision Map				;88bf	d1  
	pop hl					; restore hl - Player VRAM address					;88c0	e1  
	ret						; --------------- End of Proc ---------------------	;88c1	c9 	

;***********************************************************************************************
; Checks if Ghost is marked with Killed Flag ($ff)
; IN: hl - VRAM address of Ghost 
; OUT: a - 0 if Ghost is marked, $ff if not
;      Flag Z - 1 if Ghost is marked, 0 if not
GHOST_HAS_KILL_FLAG:
	push hl						; save hl - VRAM Ghost address					;88c2	e5 
	call CMAP_GET_BYTE			; de - address in Collision Map					;88c3	cd e9 89 
	ex de,hl					; hl - address in Collision Map					;88c6	eb 
	ld de,32					; 32 bytes per screen line						;88c7	11 20 00
	ld a,$ff					; a - value to compare							;88ca	3e ff 
	cp (hl)						; check if byte in buffer = $ff					;88cc	be 
	jp z,.EXIT_YES				; yes - return with 0 value						;88cd	ca e0 88 
	add hl,de					; hl - address in next line						;88d0	19 
	cp (hl)						; check if byte in buffer = $ff					;88d1	be 
	jp z,.EXIT_YES				; yes - return with 0 value						;88d2	ca e0 88 
; -- strange code ??? - (selfmodify???) 
; 16 bit add will never change Z flag, so if we're here than Z=0 and below jumps will never occour
	add hl,de					; hl - address in next line (2 lines below)		;88d5	19 
	jp z,.EXIT_YES				; ?? flag Z is unaffected - never will jump		;88d6	ca e0 88 
	add hl,de					; hl - address in next line (3 lines below)		;88d9	19 	. 
	jp z,.EXIT_YES				; ?? flag Z is unaffected - never will jump		;88da	ca e0 88
; -- pop hl will discard additions above (no point of above code!)
	pop hl						; restore hl - VRAM Ghost address				;88dd	e1 
	or a						; set flags (a = -1)							;88de	b7 
	ret							; --------- End of Proc (-1) -------------		;88df	c9 	
.EXIT_YES:
	xor a						; set a to 0 and flags							;88e0	af 
	pop hl						; restore hl - VRAM Ghost address				;88e1	e1 
	ret							; --------- End of Proc (0) --------------		;88e2	c9 


;***********************************************************************************************
; Test Player collision with Dots, Power Pills or Heart (Bonus)
; IN: de - address in Collision Map
TEST_EAT_STUFF:
; -- update Player position in Collision Map
	ld b,%00100000				; Player Bit (5) to set in Colision Map			;88e3	06 20 
	call CMAP_SET_2X4			; set Player Bit (5) in CMap (8x4)px (2x4)bytes	;88e5	cd 8f 86  

; -- check collision with Dot, Power Pill or Heart
	ld hl,32					; 32 bytes per line								;88e8	21 20 00 
	add hl,de					; CMap address in line where Stuff is marked	;88eb	19 
	call TRY_EAT_STUFF			; check collision with sprite "left" byte		;88ec	cd f4 88 
	inc hl						; next CMap address - sprite "right" byte		;88ef	23 
	call TRY_EAT_STUFF			; check collision with sprite "right" byte		;88f0	cd f4 88 
	ret							; ------------End of Proc --------------------- ;88f3	c9 


;***********************************************************************************************
; Try Eat Dots, Power Pills or Heart (Bonus) if it is at Player position
; IN: hl - address in Collision Map to test
TRY_EAT_STUFF:
	ld a,(hl)					; a - byte from Collision Map					;88f4	7e 
	bit 7,a						; is there Dot or Heart (bit 7 is set)			;88f5	cb 7f
	jp nz,TRY_EAT_DOT_OR_HEART	; yes - check if it is Heart or Dot				;88f7	c2 15 89 

; -- no Dot here - check if is there Power Pill
	bit 6,a						; is there Power Pill (bit 6 is set)			;88fa	cb 77 
	ret z						; no -------- End of Proc ---------------------	;88fc	c8 

;***********************************************************************************************
; Eat Power Pill
; Remove Power Pill from screen and Collision Map and add 100 Points to Score
; Also turn ON Ghost Chase Mode when Player can kill Ghost when catch it 	
EAT_POWER_PILL
; -- remove mark from Collision Map
	res 6,a						; clear Power Pill Bit (6)						;88fd	cb b7 
	ld (hl),a					; update byte in Collision Map					;88ff	77 
; -- set Ghost Chase Mode - Player can Eat Ghosts and they run away
	ld a,(LEVEL_CMODE_TIME)		; Ghost Chase Mode Time 						;8900	3a 09 80 
	ld (CMODE_ON_TIMER),a		; set Ghost Chase Mode Timer					;8903	32 2c 80 

; -- change screen colors 
	ld a,VDG_GFX_COLORS_1		; alternate colors (Mode 1)						;8906	3e 18 
	ld (IOLATCH),a				; change screen									;8908	32 00 68
	ld (IOLATCH_SHADOW),a		; store into shadow register					;890b	32 6f 80

; -- add 100 points to Score and play Sound
	call SCORE_ADD_100			; add 100 points to Player Score				;890e	cd 94 80 
	call SND.PLAY_MiddleLong	; play middle-long sound						;8911	cd 40 80 
	ret							; ----------- End of Proc ---------------------	;8914	c9 

;***********************************************************************************************
; Try Eat Dots, Power Pills or Heart (Bonus) if it is at Player position
; IN: hl - address in Collision Map to test
;     a - byte from Colission Map
;-----------------------------------------------------------------------------------------------
; -- bit 7 is set in Collision Map - could be Heart or Dot
TRY_EAT_DOT_OR_HEART:
	bit 6,a						; is there Heart (bit 7 and 6 set)				;8915	cb 77 
	jp nz,EAT_HEART				; yes - add 300 points and remove Heart			;8917	c2 49 89 

; -- only 7 bit is set - it is regular Dot

;***********************************************************************************************
; Eat Dot
; Remove Dot from Colission Map and add 10 Points to Score
; Game counts dots eaten. If this is 25th, 50th or 75th dot than it raise difficulty
; by speed up moves of Ghost Red 2 (A).
; IN: hl - address in Collision Map 
;     a - byte from Colission Map
EAT_DOT
; -- remove Dot Bit (6) from Collision Map
	res 7,a						; clear Dot Bit (6)								;891a	cb bf 
	ld (hl),a					; update byte in Collision Map					;891c	77 
; -- add 1 Dot Eaten to counter
	ld a,(DOTS_EATEN)			; a - Dots Eaten Counter						;891d	3a 06 80 
	inc a						; add 1 Dot										;8920	3c 
	ld (DOTS_EATEN),a			; save new value								;8921	32 06 80 
; -- when Player has eaten 25th, 50th or 75th Dot we will speed up Ghost Red A moves 
	cp 25						; is this 25th Dot?								;8924	fe 19 
	jp z,.EXIT_SPEEDUP			; yes - speed up Ghost Red 2					;8926	ca 3a 89 
	cp 50						; is this 50th Dot?								;8929	fe 32  
	jp z,.EXIT_SPEEDUP			; yes - speed up Ghost Red 2					;892b	ca 3a 89  
	cp 75						; is this 75th Dot?								;892e	fe 4b  
	jp z,.EXIT_SPEEDUP			; yes - speed up Ghost Red 2					;8930	ca 3a 89  

; -- none of above - just add 10 points to Score and play Sound
	call SCORE_ADD_10			; add 10 points to Player Score					;8933	cd 82 80  
	call SND.PLAY_HighShort		; play middle-short sound						;8936	cd 3a 80 
	ret							; ----------- End of Proc ---------------------	;8939	c9  

.EXIT_SPEEDUP:
	ld a,(LEVEL_GA_SPEEDUP)		; value to decrement Ghost Red A Update Timer	;893a	3a 0a 80 
	ld e,a						; e - value 									;893d	5f 
	ld a,(LEVEL_GA_UPD_TIMER)	; a - Ghost Red A Update Timer for this Level	;893e	3a 08 80 
	sub e						; lower Timer value by Speedup value			;8941	93 
	ld (LEVEL_GA_UPD_TIMER),a	; store new initial value for Timer				;8942	32 08 80
; -- add 10 points to Score
	call SCORE_ADD_10			; add 10 points to Player Score					;8945	cd 82 80 
	ret							; ----------- End of Proc ---------------------	;8948	c9 

;***********************************************************************************************
; Eat Heart
; Add 300 Points to Score, remove Heart from screen and Colission MapTry Eat Dots, 
; reinitialize Heart parameters (Timer and LifeTime) and decrement Heart counter for this Level
EAT_HEART:
; -- add 300 points to Score
	call SCORE_ADD_100			; add 100 points to Score						;8949	cd 94 80 
	call SCORE_ADD_100			; add 100 points to Score						;894c	cd 94 80 
	call SCORE_ADD_100			; add 100 points to Score (300 in total)		;894f	cd 94 80 
; -- clear area on screen	
	ld hl,SPR.EMPTY				; Sprite Empty (8x4)px (2x4) bytes				;8952	21 f1 8e 
	ld de,VRAM+(37*32)+13		; screen coord (52,37)px (13,37) [$74ad]		;8955	11 ad 74 
	push de						; save de - screeen coords						;8958	d5 
	ld bc,2						; bc - 2 bytes (8px) - sprite width				;8959	01 02 00 
	ld a,4						; a - 4 lines (4px) - sprite height				;895c	3e 04  
	call DRAW_SPRITE			; clear area on screen							;895e	cd 75 89 
; -- clear marks in Collision Map (remove Heart from CMap)
	pop hl						; hl - VRAM address								;8961	e1 
	call CMAP_GET_BYTE			; de - address in Collision Map					;8962	cd e9 89 
	ld b,%00111111				; Heart Bits (7,6)								;8965	06 3f 
	call CMAP_CLEAR_2X4			; clear Heart Bits (7,6) in Collision Map		;8967	cd 78 86 
; -- initialize Heart parameters (Timer and LifeTime)
	call INIT_HEART_PROPS		; set initial values for Heart					;896a	cd 7e 82
; -- decrement 1 Heart Counter for this Level
	ld a,(HEARTS_PER_LEVEL)		; number of Hearts for this Level				;896d	3a 31 80 
	dec a						; decrement Hearts left							;8970	3d 
	ld (HEARTS_PER_LEVEL),a		; store new value								;8971	32 31 80
	ret							; ---------------- End of Proc ------------		;8974	c9 

;***********************************************************************************************
; Draw Sprite
; IN: hl - source - sprite data
;     de - destination - VRAM address (top-left pixel)
;     bc - sprite width in bytes
; 	  a  - sprite height in pixels (lines) 
DRAW_SPRITE:
	push bc						; save bc - sprite width (in bytes)				;8975	c5 
	push de						; save de - destination VRAM address			;8976	d5 
	ldir						; copy to screen one sprite line				;8977	ed b0 
	pop de						; restore de - VRAM address of left pixel		;8979	d1 
	push hl						; save hl - current source data					;897a	e5 
	ld hl,32					; 32 bytes per screen line						;897b	21 20 00 
	add hl,de					; add one screen line 							;897e	19 
	ex de,hl					; de - sprite left edge, one line below 		;897f	eb 
	pop hl						; restore hl - current source byte				;8980	e1
	pop bc						; restore bc - sprite width (in bytes)			;8981	c1 
	dec a						; decrement line counter (check if 0)			;8982	3d 
	jp nz,DRAW_SPRITE			; no - draw next sprite line					;8983	c2 75 89 
	ret							; --------------- End of Proc -----------------	;8986	c9 


PLAYER_MOVE_UP:
	ld de,SPR.PLAYER_U			; Sprite Player (facing Up)						;8987	11 d9 8e
	ld (PLAYER_SADR),de			; store as address of current Sprite Variant	;898a	ed 53 0b 80 
	call CMAP_GET_BYTE			; a - byte from Collision Map					;898e	cd e9 89 
	bit 0,a						; is wall 1 byte above 							;8991	cb 47 
	ret z						; yes - can't move ---- Return to PLAYER_UPDATE	;8993	c8 
; -- no wall above - calculate new VRAM position for Player
	ld de,32					; 32 bytes per screen line						;8994	11 20 00 
	or a						; clear Carry flag								;8997	b7 
	sbc hl,de					; hl address of pixel 1 line above				;8998	ed 52 
	ret							; ---- Return to PLAYER_UPDATE routine --------	;899a	c9 

PLAYER_MOVE_DOWN:
	ld de,SPR.PLAYER_D			; Sprite Player (facing Down)					;899b	11 e1 8e 
	ld (PLAYER_SADR),de			; store as address of current Sprite Variant	;899e	ed 53 0b 80 
	call CMAP_GET_BYTE			; a - byte from Collision Map					;89a2	cd e9 89 
	bit 2,a						; is wall 1 byte below							;89a5	cb 57 
	ret z						; yes - can't move ---- Return to PLAYER_UPDATE	;89a7	c8 
; -- no wall below - calculate new VRAM position for Player
	ld de,32					; 32 bytes per screen line						;89a8	11 20 00 
	add hl,de					; hl address of pixel 1 line below				;89ab	19 
	ret							; ---- Return to PLAYER_UPDATE routine --------	;89ac	c9 

PLAYER_MOVE_RIGHT:
; -- reset Timer to initial value 170
	ld a,170					; initial value for Player Update Timer			;89ad	3e aa  
	ld (PLAYER_UPD_TIMER),a		; set new value									;89af	32 12 80 
; -- change Player Sprite for use from now on
	ld de,SPR.PLAYER_R			; Sprite Player (facing Right)  				;89b2	11 fa 8e 
	ld (PLAYER_SADR),de			; store as address of current Sprite Variant	;89b5	ed 53 0b 80
; -- do we have to move Sprite to next VRAM address or only change Sprite variant 
	ld a,c						; Sprite Shifted Flag 							;89b9	79 
	or a						; check if sprite is Shifted 2px right			;89ba	b7 
	jp z,.ONLY_SHIFT			; no - use shifted sprite - VRAM won't change	;89bb	ca c2 89
; -- Player position was already shifted 2px right - move to next VRAM byte
	ld c,0						; reset Sprite Shifted Flag						;89be	0e 00 
	inc hl						; hl address of next right byte					;89c0	23 
	ret							; ---- Return to PLAYER_UPDATE routine --------	;89c1	c9 
.ONLY_SHIFT:
	call CMAP_GET_BYTE			; a - byte from Collision Map					;89c2	cd e9 89 
	bit 1,a						; is wall 1 byte right							;89c5	cb 4f 
	ret z						; yes - can't move ---- Return to PLAYER_UPDATE	;89c7	c8 
; -- no wall on right - Player position wasn't shifted - switch to shifted (2px right) sprite - no VRAM change
	ld c,1						; set Sprite Shifted Flag						;89c8	0e 01 
	ret							; ---- Return to PLAYER_UPDATE routine --------	;89ca	c9 

PLAYER_MOVE_LEFT:
; -- reset Timer to initial value 170
	ld a,170					; initial value for Player Update Timer			;89cb	3e aa 
	ld (PLAYER_UPD_TIMER),a		; set new value									;89cd	32 12 80 
; -- change Player Sprite for use from now on
	ld de,SPR.PLAYER_L			; Sprite Player (facing Left) 					;89d0	11 02 8f 
	ld (PLAYER_SADR),de			; store as address of current Sprite Variant	;89d3	ed 53 0b 80 
; -- do we have to move Sprite to next VRAM address or only change Sprite variant to nonshifted
	ld a,c						; Sprite Shifted Flag 							;89d7	79 
	or a						; check if sprite is Shifted 2px right			;89d8	b7 
	jp z,.CHANGE_VADR			; no - change VRAM address to previous byte		;89d9	ca df 89 
; -- Player position was already shifted 2px right - switch to nonshifted sprite - no VRAM change
	ld c,0						; clear Sprite Shifted Flag						;89dc	0e 00 
	ret							; ---- Return to PLAYER_UPDATE routine --------	;89de	c9 
.CHANGE_VADR:
	call CMAP_GET_BYTE			; a - byte from Collision Map					;89df	cd e9 89 
	bit 3,a						; is wall 1 byte left							;89e2	cb 5f 
	ret z						; yes - can't move ---- Return to PLAYER_UPDATE	;89e4	c8  
; -- no wall on left - Player position wasn't shifted - switch to shifted (2px right) sprite and change VRAM address
	ld c,1						; set Sprite Shifted Flag						;89e5	0e 01 
	dec hl						; hl address of next left byte					;89e7	2b 
	ret							; ---- Return to PLAYER_UPDATE routine --------	;89e8	c9 


;***********************************************************************************************
; Get Byte from Collision Map for specified VRAM Address
; IN:  hl - adres in VRAM
; OUT: de - address in Collision Map
;      a - byte from Collision Map
CMAP_GET_BYTE:
	push hl						; save hl - VRAM address						;89e9	e5 
	ld de,$0800					; offset beetween VRAM and Collision Map Data	;89ea	11 00 08 
	add hl,de					; hl - addres in CMap for this VRAM 			;89ed	19 
	ld a,(hl)					; a - byte from Collision Map					;89ee	7e 
	ex de,hl					; de - addres in CMap for this VRAM				;89ef	eb 
	pop hl						; hl - addres in VRAM							;89f0	e1 
	ret							; ----------- End of Proc ---------------------	;89f1	c9 

;***********************************************************************************************
; Test if Player can Move Up
; Player can move up if no wall is above current position and player sprite is not shifted (2px)
; IN: c - 1 if shifted (2px) sprite is used
; OUT: b - move direction (0 if Playar CAN move Up, unchanged if CAN'T)
TEST_MOVE_UP:
	ld a,c						; a - Sprite Shifted Flag						;89f2	79 
	or a						; is Player in shifted position					;89f3	b7 
	ret nz						; yes - cant't move UP	-----------------------	;89f4	c0 
; -- non-shifted Player sprite - Player can move UP or DOWN if no Wall there
	call CMAP_GET_BYTE			; a - byte from Collision Map					;89f5	cd e9 89  
	bit 0,a						; is Wall above ?								;89f8	cb 47 
	ret z						; yes - can't move UP							;89fa	c8 
; -- no Wall above - Player can move UP
	ld b,0						; set Player Move Direction Up					;89fb	06 00 
	ret							; -------- End of Proc (b=0) ------------------	;89fd	c9 

;***********************************************************************************************
; Test if Player can Move Down
; Player can move down if no wall is below current position and player sprite is not shifted (2px)
; IN: c - 1 if shifted (2px) sprite is used
; OUT: b - move direction (2 if Playar CAN move Down, unchanged if CAN'T)
TEST_MOVE_DOWN:
	ld a,c						; a - Sprite Shifted Flag						;89fe	79 
	or a						; is Player in shifted position					;89ff	b7 
	ret nz						; yes - cant't move UP							;8a00	c0  
; -- non-shifted Player sprite - Player can move UP or DOWN if no Wall there
	call CMAP_GET_BYTE			; a - byte from Collision Map					;8a01	cd e9 89 
	bit 2,a						; is Wall below ?								;8a04	cb 57 
	ret z						; yes - can't move UP -------------------------	;8a06	c8  
; -- no Wall below - Player can move DOWN
	ld b,2						; set Player Move Direction Down				;8a07	06 02 
	ret							; -------- End of Proc (b=2) ------------------	;8a09	c9  


;***********************************************************************************************
; Test if Player can Move Right
; Player can move Right if no wall is on right side from current position and player sprite is not shifted (2px)
; IN: c - 1 if shifted (2px) sprite is used
; OUT: b - move direction (1 if Playar CAN move Right, unchanged if CAN'T)
TEST_MOVE_RIGHT:
	ld a,c						; a - Sprite Shifted Flag						;8a0a	79 
	or a						; is Player in shifted position					;8a0b	b7  
	ret nz						; yes - cant't move RIGHT						;8a0c	c0 
; -- non-shifted Player sprite - Player can move LEFT or RIGHT if no Wall there
	call CMAP_GET_BYTE			; a - byte from Collision Map					;8a0d	cd e9 89 
	bit 1,a						; is Wall on the right ?						;8a10	cb 4f 
	ret z						; yes - can't move RIHGT ----------------------	;8a12	c8 
; -- no Wall on the right - Player can move RIGHT
	ld b,1						; set Player Move Direction Right				;8a13	06 01 
	ret							; -------- End of Proc (b=1) ------------------	;8a15	c9 

;***********************************************************************************************
; Test if Player can Move Left
; Player can move Left if no wall is on left side from current position and player sprite is not shifted (2px)
; IN: c - 1 if shifted (2px) sprite is used
; OUT: b - move direction (3 if Playar CAN move Left, unchanged if CAN'T)
TEST_MOVE_LEFT:
	ld a,c						; a - Sprite Shifted Flag						;8a16	79  
	or a						; is Player in shifted position					;8a17	b7  
	ret nz						; yes - cant't move LEFT ----------------------	;8a18	c0 
; -- non-shifted Player sprite - Player can move LEFT or RIGHT if no Wall there
	call CMAP_GET_BYTE			; a - byte from Collision Map					;8a19	cd e9 89 
	bit 3,a						; is Wall on the left ?							;8a1c	cb 5f 
	ret z						; yes - can't move LEFT							;8a1e	c8  
; -- no Wall on the right - Player can move RIGHT
	ld b,3						; set Player Move Direction Left				;8a1f	06 03 
	ret							; -------- End of Proc (b=3) ------------------	;8a21	c9  



;***********************************************************************************************
;
;   G A M E    L O O P  -  D R A W   F R E E Z E D   G H O S T S 
;
;***********************************************************************************************
GL_DRAW_FREEZED_GHOSTS
; --
	ld a,(GHOSTS_DRAW_TIMER)	; Ghosts Redraw Timer value						;8a22	3a 16 80 
	dec a						; decrement value and check if 0				;8a25	3d 
	ld (GHOSTS_DRAW_TIMER),a	; store new value								;8a26	32 16 80 
	ret nz						; no - don't draw in this Game Loop iteration	;8a29	c0 
.BLUE1
; -- check if Ghost Blue 1 is Freezed 
	ld a,(GHOST_B1.FREEZE)		; Ghost Blue 1 Freeze Timer						;8a2a	3a 1c 80 
	or a						; check if timer > 0 - Ghost is Freezed			;8a2d	b7 
	jp z,.BLUE2					; no - check Ghost Blue 2						;8a2e	ca 37 8a 
; -- Ghost Blue 1 is Freezed - draw it on screen
	ld hl,(GHOST_B1.VADR)		; hl - destination VRAM address of Ghost Blue 1	;8a31	2a 18 80 
	call DRAW_GHOST_BLUE		; draw Ghost Blue sprite on screen				;8a34	cd ea 83 
.BLUE2
; -- check if Ghost Blue 2 is alive 
	ld a,(GHOST_B2.FREEZE)		; Ghost Blue 2 Freeze Timer						;8a37	3a 21 80 
	or a						; check if timer > 0 - Ghost is Freezed			;8a3a	b7 	
	jp z,.RED1					; no - check Ghost Red 1						;8a3b	ca 44 8a 
; -- Ghost Blue 2 is Freezed - draw it on screen
	ld hl,(GHOST_B2.VADR)		; hl - destination VRAM address	Ghost Blue 2	;8a3e	2a 1d 80 
	call DRAW_GHOST_BLUE		; draw Ghost Blue sprite on screen				;8a41	cd ea 83  
.RED1
; -- check if Ghost Red 1 is alive 
	ld a,(GHOST_R1.FREEZE)		; Ghost Red 1 Freeze Timer						;8a44	3a 26 80 
	or a						; check if timer > 0 - Ghost is Freezed			;8a47	b7  
	jp z,.RED2					; no - check Ghost Red 2						;8a48	ca 51 8a 
; -- Ghost Red 1 is Freezed - draw it on screen
	ld hl,(GHOST_R1.VADR)		; hl - destination VRAM address Ghost Red 1		;8a4b	2a 22 80 	
	call DRAW_GHOST_RED			; draw Ghost Red sprite on screen				;8a4e	cd f7 83 
.RED2
; -- check if Ghost Red 2 (A) is alive 
	ld a,(GHOST_R2.FREEZE)		; Ghost Red 2 Freeze Timer						;8a51	3a 2b 80 
	or a						; check if timer > 0 - Ghost is Freezed			;8a54	b7  
	ret z						; no - -------- End of Proc ---------------		;8a55	c8 	 
; -- Ghost Red 2 is Freezed - draw it on screen
	ld hl,(GHOST_R2.VADR)		; hl - destination VRAM address Ghost Red 2		;8a56	2a 27 80 
	call DRAW_GHOST_REDA		; draw Ghost Red A variant sprite on screen		;8a59	cd fd 83 	
	ret							; ------------- End of Proc ---------------		;8a5c	c9 




;***********************************************************************************************
;
;   G A M E    L O O P  -  D R A W   D O T S   A N D   P I L L S 
;
;***********************************************************************************************
GL_DRAW_DOTS_PILLS
	ld a,(DOTS_DRAW_TIMER)		; Dots and Pills Update Timer value				;8a5d	3a 15 80 
	dec a						; decrement value and check if 0				;8a60	3d 
	ld (DOTS_DRAW_TIMER),a		; store new value								;8a61	32 15 80 
	ret nz						; no - don't update in this Game Loop iteration	;8a64	c0 

DRAW_DOTS_PILLS:
	ld hl,VRAM+(3*32)+0			; screen coord (0,3) [$7060]					;8a65	21 60 70 
	xor a						; initialy clear flag - none of Dots left		;8a68	af 
	ld (DOTS_LEFT_FLAG),a		; clear flag - 0 means Level Completed			;8a69	32 ec 8a 
	ld de,CMAP_ADR+(3*32)+0		; address in Collision Map for (0,3)px [$7860]	;8a6c	11 60 78 
	ld a,9						; a - number of rows to check/draw Dots, Pills	;8a6f	3e 09 
DDP_NEXT_ROW
	push af						; save af 										;8a71	f5 
	push hl						; save hl - screen coord						;8a72	e5 
	push de						; save de - CMap coord							;8a73	d5 
	ld b,31						; 31 bytes in line to process/draw				;8a74	06 1f 
DDP_NEXT_BYTE
; -- test byte from Collision Map
	ld a,(de)					; byte from Collision Map						;8a76	1a 
	and %11000000				; check any Dot, Power Pills or Heart is here	;8a77	e6 c0 
	jp z,DDP_NEXT				; no - move on to next byte						;8a79	ca bb 8a 
; -- some bits are set - check if it is Heart (both bits 7 and 6 are set)
	cp  %11000000				; check if this is Heart						;8a7c	fe c0 
	jp nz,DDP_TEST_DOT			; no - check if is Dot or Power Pill			;8a7e	c2 84 8a 
	jp DDP_NEXT					; yes - move on to next byte					;8a81	c3 bb 8a

; -- there is Dot or Power Pill - check if it's Dot
DDP_TEST_DOT:
	bit 7,a						; check Dot Bit (7) is set						;8a84	cb 7f 
	jp z,DDP_TEST_PILL			; no - check if it's Power Pill					;8a86	ca 90 8a 

DDP_DRAW_DOT
; -- found Dot at these coordinates, hl - VRAM address
	ld a,(hl)					; a - byte from screen							;8a89	7e 
	or %00000001				; add Yellow pixel [-][-][-][X]					;8a8a	f6 01 
	ld (hl),a					; draw back on screen							;8a8c	77 
	jp DDP_NEXT_SETFLAG			; set Dots Left Flag and move on 				;8a8d	c3 b6 8a 

; -- there is Power Pill - make sure it is
DDP_TEST_PILL:
	bit 6,a						; check Power Pill Bit (6) is set				;8a90	cb 77 
	jp z,DDP_NEXT_SETFLAG		; no - set Dots Left Flag and move on 	 		;8a92	ca b6 8a 

; -- found Power Pill at these coordinates
	push hl						; save hl - VRAM address						;8a95	e5 
	push de						; save de - CMap address						;8a96	d5 
	push bc						; save bc - b is byte-in-line counter			;8a97	c5 
; -- check Pill Animate Flag to determine which Pattern use in this Game Loop iteration
	ld a,(PILLS_ANIM_FLAG)		; Pills Animate Flag 							;8a98	3a ed 8a 
	or a						; should draw alternate Pattern					;8a9b	b7 
	jp z,DRAW_POWER_PILL_BASE	; no - draw Base Pattern in this Game Loop 		;8a9c	ca a5 8a 

DRAW_POWER_PILL_ALT
; -- set alternate pattern to use and draw Power Pill
	ld bc,$1104					; b = [-][X][-][X], c = [-][-][X][-]			;8a9f	01 04 11 
	jp DRAW_POWER_PILL			; draw Power Pill								;8aa2	c3 a8 8a 
DRAW_POWER_PILL_BASE:
; -- set base pattern to use and draw Power Pill
	ld bc,$0411					; b = [-][-][X][-], c = [-][X][-][X]			;8aa5	01 11 04 

;***********************************************************************************************
; Draw Power Pill
; IN: hl - VRAM address (in base line)						[X][ ][X]			[ ][X][ ]
;     b - pattern for 1st and 3rd line to draw				[ ][X][ ]			[X][ ][X]
;     c - pattern for 2nd (base) line to draw				[X][ ][X]			[ ][X][ ]
DRAW_POWER_PILL:
	ld de,32					; 32 bytes per screen line						;8aa8	11 20 00 
	or a						; clear Carry flag								;8aab	b7
	sbc hl,de					; move VRAM pointer 1 line up					;8aac	ed 52
	ld (hl),b					; draw b pattern on screen 						;8aae	70 
	add hl,de					; move VRAM pointer to base line				;8aaf	19 
	ld (hl),c					; draw c pattern on screen						;8ab0	71 
	add hl,de					; move VRAM pointer 1 line down					;8ab1	19 
	ld (hl),b					; draw b pattern on screen 						;8ab2	70 
	pop bc						; restore bc - b is byte-in-line counter		;8ab3	c1 
	pop de						; restore de - CMap address						;8ab4	d1 
	pop hl						; restore hl - VRAM address						;8ab5	e1 

DDP_NEXT_SETFLAG:
	ld a,1						; at least 1 Dot left 							;8ab6	3e 01 
	ld (DOTS_LEFT_FLAG),a		; set Dots Left Flag - Level NOT Completed yet	;8ab8	32 ec 8a 

; -- move to next line
DDP_NEXT
	inc hl						; next VRAM address								;8abb	23 
	inc de						; next offscreen buffer address					;8abc	13 
	dec b						; check if all 31 bytes processed				;8abd	05 
	jp nz,DDP_NEXT_BYTE			; no - process next byte						;8abe	c2 76 8a 

; -- 1 line processed - calculate next line coordinates
	pop hl						; hl - address in Collision Map					;8ac1	e1 
	ld de,7*32					; 7 lines * 32 bytes per line					;8ac2	11 e0 00 
	add hl,de					; hl - 7 lines below in CMap					;8ac5	19 
	ex de,hl					; de - new address in Collision Map, hl - 7*32	;8ac6	eb 
	pop bc						; bc - VRAM address								;8ac7	c1 
	add hl,bc					; hl - 7 lines below in VRAM					;8ac8	09 
	pop af						; a - number of rows to draw					;8ac9	f1 
	dec a						; check if all 9 rows already drawn				;8aca	3d 
	jp nz,DDP_NEXT_ROW			; no - draw next row at new coordinates			;8acb	c2 71 8a

; -- toggle Pill Animate Flag to draw alternate Pattern in next Game Loop iteration
	ld a,(PILLS_ANIM_FLAG)		; Pill Animate Flag 							;8ace	3a ed 8a
	or a						; is flag set?									;8ad1	b7 
	jp z,DDP_SET_ANIM_FLAG		; no - set Pill Animate Flag					;8ad2	ca d9 8a 
; -- flag is set so clear it
DDP_CLEAR_ANIM_FLAG
	xor a						; 0 value for Pill Animate Flag 				;8ad5	af 
	jp DDP_STORE_ANIM_FLAG		; store new value								;8ad6	c3 da 8a 
DDP_SET_ANIM_FLAG
	inc a						; 1 value for Pill Animate Flag					;8ad9	3c 
DDP_STORE_ANIM_FLAG
	ld (PILLS_ANIM_FLAG),a		; store new Flag value							;8ada	32 ed 8a 

; -- check if any Dots left to Eat - if none then Level is Completed	
	ld a,(DOTS_LEFT_FLAG)		; Dots Left Flag 								;8add	3a ec 8a
	or a						; has all Dots been Eaten ?						;8ae0	b7 
	ret nz						; no ---------- End of Proc -------------------	;8ae1	c0 

; -- All Dots has been Eaten - Level Up
LEVEL_UP
	ld a,(LEVEL)				; current Game Level 							;8ae2	3a 03 80 
	inc a						; increment - next Level to Play				;8ae5	3c 
	ld (LEVEL),a				; store as new Level to Play					;8ae6	32 03 80 
	jp GAME_LEVEL_INIT			; start over and Play new Level					;8ae9	c3 32 81 

;***********************************************************************************************
; -- local variables
DOTS_LEFT_FLAG	defb	0		; 0 - all Dots are Eaten, 1 - some Dots left	;8aec	00 
PILLS_ANIM_FLAG	defb	0		; 0 - use Base Pattern, 1 - use Alt Pattern		;8aed	00 


;***********************************************************************************************
; Clear screen and draw static graphics - Walls, Dots and Pills
DRAW_LEVEL_SCREEN:
	call DRAW_MAZE_WALLS_CLS	; clear screen and draw Maze Walls				;8aee	cd c5 8b 
	call DRAW_DOTS_PILLS		; draw Dots and Pills							;8af1	cd 65 8a
	ret							; ------------- End of Proc -------------------	;8af4	c9 	

;***********************************************************************************************
; Mark Walls/Passages in Collision Map
; 4 low bits of byte in Collision Map defines if Player/Ghost can move in any direction.
; Bit 0 - Up direction
; Bit 1 - Right direction
; Bit 2 - Down direction
; Bit 3 - Left direction
; If bit is set (1) Player/Ghost CAN move in that direction
; If bit is not set (0) there is a Wall and Player/Ghost CAN'T move in that direction
CMAP_MARK_PASSAGES
; -- mark Horizontal Passages (player can move Left and Right) 
	ld hl,SDB_H_PASSAGES		; Screen Data Block - Horizontal Passages		;8af5	21 a9 8d 
.NEXT_LINE:
	call READ_SDB_VADR			; de - VRAM destination address 				;8af8	cd 26 8c
	ld a,(hl)					; a - passage width (in bytes)					;8afb	7e 
	inc hl						; address of next Line VRAM address 			;8afc	23 
	or a						; check if length = 0 (end of data)				;8afd	b7  
	jp z,CMAP_MARK_V_PASS		; yes - mark next Screen Data Block				;8afe	ca 11 8b 
	push hl						; address of next Line VRAM address in SDB 		;8b01	e5  
	ld hl,$0800					; offset beetween VRAM and Collision Map		;8b02	21 00 08
	add hl,de					; hl - destination adress in CMap buffer		;8b05	19 
.NEXT_BYTE:
	ld (hl),%00001010			; mark allowed Move Left (bit 1) and Right (bit 3)	;8b06	36 0a 
	inc hl						; address of next byte in CMap buffer			;8b08	23 
	dec a						; check if all bytes marked already				;8b09	3d 
	jp nz,.NEXT_BYTE			; no - mark next byte in this passage			;8b0a	c2 06 8b 
	pop hl						; address of next Line VRAM address in SDB 		;8b0d	e1
	jp .NEXT_LINE				; repeat for all passages defined in SDB		;8b0e	c3 f8 8a 

; -- mark Vertical Passages (60px height) by adding Passage Bits Up and Down
CMAP_MARK_V_PASS
	ld hl,SDB_V_PASSAGES		; Screen Data Block - Vertical Passages			;8b11	21 91 8d 
.NEXT_COLUMN
	call READ_SDB_VADR			; de - VRAM destination address 				;8b14	cd 26 8c 
	ld a,d						; check if 0 - end of Screen Data Block			;8b17	7a 
	or a																		;8b18	b7 
	jp z,CMAP_MARK_OTHER		; yes - mark next Screen Data Block				;8b19	ca 39 8b 
	push hl						; address of next column VRAM address 			;8b1c	e5 
	ld hl,$0800					; offset beetween VRAM and Collision Map		;8b1d	21 00 08 
	add hl,de					; hl - destination adress in CMap buffer				;8b20	19 
	ld de,32					; 32 bytes per screen line						;8b21	11 20 00 
	ld b,60						; 60px - Vertical Passage Height				;8b24	06 3c 
.NEXT_BYTE
; -- if byte in Collision Map already has set bit 1 or 3 by above routine
; it means that there were set Walls Up and Down so we will skip such byte
	ld a,(hl)					; a - definition already in Collision Map		;8b26	7e 
	and %00111111				; is defined (Left & Right) already? 			;8b27	e6 3f 
	jp nz,.SKIP					; yes - skip this screen line					;8b29	c2 30 8b 
; -- no direction bits are set - can be Dot (Bit 7) or Power Pill (Bit 6)
	ld a,(hl)					; a - existing definition from Collision Map	;8b2c	7e 
	or %00000101				; mark allowed Move Up (bit 0) and Down (bit 2)	;8b2d	f6 05 
	ld (hl),a					; store definition into Collision Map			;8b2f	77 
.SKIP
	add hl,de					; add 32 bytes per line - new screen line		;8b30	19 
	dec b						; check if all 60 lines in column processed 	;8b31	05 
	jp nz,.NEXT_BYTE			; no - process next screen line in this column	;8b32	c2 26 8b 
	pop hl						; address of next column VRAM address 			;8b35	e1 
	jp .NEXT_COLUMN				; repeat for all columns defined in SDB 		;8b36	c3 14 8b 

; Routines above defined only those coordinates where it was clear Passage (Horizontal or Vertical).
; Horizontal passages were defined as allowed moves Left & Right and not allowed moves (Walls) Up & Down
; Similarly Vertical Passages allowed moves Up & Down and set Walls Left & Right at the same time
; This routine marks in Collision Map bytes with definitions different than above
CMAP_MARK_OTHER
	ld hl,SDB_OTHER_PASSAGES	; Screen Data Block - Other Passages			;8b39	21 f4 8d 
.NEXT_BYTE
	call READ_SDB_VADR			; de - VRAM destination address 				;8b3c	cd 26 8c 
	ld a,(hl)					; a - Passage/Wall definition					;8b3f	7e 
	inc hl						; address of next data VRAM address 			;8b40	23 
	or a						; check if 0 - end of Screen Data Block			;8b41	b7  
	ret z						; yes ------------- End of Proc	-----------		;8b42	c8 
	push hl						; address of next data VRAM address 			;8b43	e5 
	ld hl,$0800					; offset beetween VRAM and Collision Map		;8b44	21 00 08
	add hl,de					; hl - destination adress in CMap Buffer		;8b47	19 
	ld b,a						; b - byte data with new definitions			;8b48	47 
	ld a,(hl)					; a - existing data from CMap buffer			;8b49	7e 
	and %11000000				; preserve Dots and Pills (clear Pass/Walls)	;8b4a	e6 c0 
	or b						; add definitions from SDB						;8b4c	b0 
	ld (hl),a					; store new data into Collision Map				;8b4d	77 
	pop hl						; address of next data VRAM address 			;8b4e	e1 
	jp .NEXT_BYTE				; repeat for all address+byte defined in SDB	;8b4f	c3 3c 8b 

;***********************************************************************************************
; Fill Collision Map with predefined Dots and Power Pills 
; Clear data in Collision Map and mark all Dots and Power Pills
CMAP_DOTS_PILLS
; -- clear CMap buffer	7800 .. 7fff
	ld hl,CMAP_ADR				; src - Collision Map buffer					;8b52	21 00 78 
	ld de,CMAP_ADR+1			; dst - next byte in buffer						;8b55	11 01 78 
	ld bc,2047					; cnt - 2047 bytes to clear						;8b58	01 ff 07 
	ld (hl),$00					; clear Collision Map byte						;8b5b	36 00 
	ldir						; fill buffer with 0 value						;8b5d	ed b0 

; -- mark Grid of Dots which Payer will Eat in game - 9 roww by 12 columns (108 in total)
CMAP_MARK_DOTS
	ld hl,SDB_DOTS_GRID			; Screen Data Block - Dots' Grid				;8b5f	21 41 8d 
	ld bc,7*32					; vertical space beetween Dots - 7 lines 		;8b62	01 e0 00
.NEXT_COLUMN
	call READ_SDB_VADR			; de - VRAM destination address 				;8b65	cd 26 8c 
	ld a,d						; check if 0 - end of Screen Data Block			;8b68	7a 
	or a																		;8b69	b7 
	jp z,CMAP_CLEAR_DOTS		; yes - mark next Screen Data Block				;8b6a	ca 80 8b 
	push hl						; address of next Dot VRAM address 				;8b6d	e5 
	ld hl,$0800					; offset beetween VRAM and Collision Map		;8b6e	21 00 08 
	add hl,de					; hl - destination adress in CMap				;8b71	19 
	pop de						; de - address of next Dot to mark				;8b72	d1 
	ld a,9						; number of Dot rows to mark 					;8b73	3e 09 
.NEXT_DOT
	ld (hl),%10000000			; Dot Bit (7) - mark Dot is here 				;8b75	36 80 
	add hl,bc					; add 7 lines to destination address			;8b77	09 
	dec a						; check if all 9 Dots marked already			;8b78	3d 
	jp nz,.NEXT_DOT				; no - mark next Dot in this column				;8b79	c2 75 8b 
	ex de,hl					; hl - address of next Dot data 				;8b7c	eb 
	jp .NEXT_COLUMN				; repeat for all columns defined in SDB			;8b7d	c3 65 8b 

; -- clear 14 unwanted Dots marked by above routine
CMAP_CLEAR_DOTS:
	ld hl,SDB_DOTS_CLR			; Screen Data Block - Dots Unwanted				;8b80	21 5b 8d 
.NEXT:
	call READ_SDB_VADR			; de - VRAM destination address 				;8b83	cd 26 8c 
	ld a,d						; check if 0 - end of Screen Data Block			;8b86	7a 
	or a																		;8b87	b7  
	jp z,CMAP_MARK_DOTS_EX		; yes - mark next Screen Data Block				;8b88	ca 97 8b 
	push hl						; address of next VRAM address to clear			;8b8b	e5 
	ld hl,$0800					; offset beetween VRAM and Collision Map		;8b8c	21 00 08 
	add hl,de					; hl - destination adress in CMap buffer		;8b8f	19 
	ex de,hl					; de - destination adress in buffer				;8b90	eb 
	pop hl						; address of next VRAM address to clear			;8b91	e1 
	xor a						; clear all Bits - nothing is here				;8b92	af 
	ld (de),a					; clear all Bits in Collision Map				;8b93	12 
	jp .NEXT					; clear next byte defined in SDB				;8b94	c3 83 8b 

; -- mark Extra 6 Dots placed outside of Grid constrained coordinates
CMAP_MARK_DOTS_EX:
	ld hl,SDB_DOTS_EXTRA		; Screen Data Block - Dots Extra				;8b97	21 79 8d 
.NEXT
	call READ_SDB_VADR			; de - VRAM destination address 				;8b9a	cd 26 8c  
	ld a,d						; check if 0 - end of Screen Data Block			;8b9d	7a
	or a																		;8b9e	b7 
	jp z,CMAP_MARK_PILLS		; yes - mark next Screen Data Block				;8b9f	ca af 8b 
	push hl						; address of next Dot VRAM address 				;8ba2	e5 
	ld hl,$0800					; offset beetween VRAM and Collision Map		;8ba3	21 00 08 
	add hl,de					; hl - destination adress in CMap buffer		;8ba6	19  
	ex de,hl					; de - destination adress in buffer				;8ba7	eb 
	pop hl						; hl - address of next Dot to draw				;8ba8	e1 
	ld a,%10000000				; Dot Bit (7) - mark Dot is here 				;8ba9	3e 80  
	ld (de),a					; mark Dot in Collision Map						;8bab	12 
	jp .NEXT					; mark next Dot defined in SDB					;8bac	c3 9a 8b 

; -- mark 4 Power Pills placed at each edge of maze
CMAP_MARK_PILLS
	ld hl,SDB_POWER_PILLS		; Screen Data Block - Power Pills				;8baf	21 87 8d 
.NEXT
	call READ_SDB_VADR			; de - VRAM destination address 				;8bb2	cd 26 8c 
	ld a,d						; check if 0 - end of Screen Data Block			;8bb5	7a 
	or a																		;8bb6	b7  
	ret z						; yes ------------ End of Proc -------------	;8bb7	c8 
	push hl						; address of next Power Pill VRAM address 			;8bb8	e5 
	ld hl,$0800					; offset beetween VRAM and Collision Map		;8bb9	21 00 08 
	add hl,de					; hl - destination adress in CMap buffer		;8bbc	19 
	ex de,hl					; de - destination adress in buffer				;8bbd	eb 
	pop hl						; hl - address of next Power Pill to draw		;8bbe	e1  
	ld a,%01000000				; Power Pill Bit (6) - mark Power Pill is here	;8bbf	3e 40 
	ld (de),a					; mark Power Pill in Collision Map				;8bc1	12 
	jp .NEXT					; mark next Dot defined in SDB					;8bc2	c3 b2 8b 


;***********************************************************************************************
; Clear Screen and draw Horizontal and Verital Walls of Maze defined in Screen Data Blocks
DRAW_MAZE_WALLS_CLS:
	call CLEAR_SCREEN_GFX	; Clear Screen, set MODE 1, Colors 0 				;8bc5	cd 34 8c

;***********************************************************************************************
; Draw Horizontal and Verital Walls of Maze defined in Screen Data Blocks
DRAW_MAZE_WALLS
	ld hl,SDB_H_LINES			; Screen Data Block - Horizontal Lines			;8bc8	21 5f 8c
.NEXT_LINE
	call READ_SDB_VADR			; de - VRAM destination address 				;8bcb	cd 26 8c  
	ld a,(hl)					; a - line length (in bytes)					;8bce	7e 
	inc hl						; address of next Line VRAM address 			;8bcf	23 
	or a						; check if length = 0 (end of data)				;8bd0	b7
	jp z,DRAW_H_4PX_LINES		; yes - draw next Screen Data Block				;8bd1	ca e0 8b 
	ex de,hl					; de - address in SDB, hl - VRAM address		;8bd4	eb 
.NEXT_BYTE
	ld (hl),$55					; [X][X][X][X] - draw 4 yellow pixels			;8bd5	36 55 
	inc hl						; next VRAM address								;8bd7	23 
	dec a						; check if all bytes of this line were drawn	;8bd8	3d 
	jp nz,.NEXT_BYTE			; no - draw next 4 pixels						;8bd9	c2 d5 8b 
	ex de,hl					; hl - address of next Line VRAM address		;8bdc	eb 
	jp .NEXT_LINE				; read and draw next line from SDB				;8bdd	c3 cb 8b

;-- draw Horizontal Short (4px) Lines
DRAW_H_4PX_LINES:
	ld hl,SDB_H_4PX_LINES		; Screen Data Block - Horizontal Short Lines	;8be0	21 98 8c 
.NEXT_LINE
	call READ_SDB_VADR			; de - VRAM destination address 				;8be3	cd 26 8c  
	ld a,d						; check if 0 - end of Screen Data Block			;8be6	7a 
	or a																		;8be7	b7 
	jp z,DRAW_V_LINES			; yes - draw next Screen Data Block				;8be8	ca f1 8b 
	ld a,$55					; [X][X][X][X] - 4 yellow pixels				;8beb	3e 55 
	ld (de),a					; draw on screen								;8bed	12 
	jp .NEXT_LINE				; read and draw next SHort Line					;8bee	c3 e3 8b 

; -- draw Vertical Lines
DRAW_V_LINES:
	ld hl,SDB_V_LINES			; Screen Data Block - Vertical Lines			;8bf1	21 f0 8c 
	ld bc,32					; 32 bytes per screen line						;8bf4	01 20 00 
.NEXT_LINE
	call READ_SDB_VADR			; de - VRAM destination address 				;8bf7	cd 26 8c  
	ld a,(hl)					; line height in pixels							;8bfa	7e 
	inc hl						; address of next Line VRAM address 			;8bfb	23 
	or a						; check if 0 - end of Screen Data Block			;8bfc	b7  
	jp z,DRAW_V_DBL_LINES		; yes - draw next Screen Data Block				;8bfd	ca 0c 8c 
	ex de,hl					; de - address in SDB, hl - VRAM address		;8c00	eb 
.NEXT_BYTE
	ld (hl),$41					; [X][-][-][X] - 2 yellow pixels				;8c01	36 41  
	add hl,bc					; add 32 bytes per line - next line				;8c03	09
	dec a						; check if all pixels of this line were drawn	;8c04	3d 
	jp nz,.NEXT_BYTE			; no - draw next 2 pixels						;8c05	c2 01 8c  
	ex de,hl					; hl - address of next Line VRAM address		;8c08	eb 
	jp .NEXT_LINE				; read and draw next line from SDB				;8c09	c3 f7 8b  

; -- draw Double Vertical Lines
DRAW_V_DBL_LINES:
	ld hl,SDB_V_DBL_LINES		; Screen Data Block - Vertical Lines			;8c0c	21 2c 8d 
	dec bc						; 31 bytes per screen line (1 covered in loop)	;8c0f	0b 
.NEXT_LINE:
	call READ_SDB_VADR			; de - VRAM destination address 				;8c10	cd 26 8c 
	ld a,(hl)					; line height in pixels							;8c13	7e 
	inc hl						; address of next Line VRAM address 			;8c14	23 
	or a						; check if 0 - end of Screen Data Block			;8c15	b7 
	ret z						; yes ------------ End of Proc -------------	;8c16	c8 
	ex de,hl					; de - address in SDB, hl - VRAM address		;8c17	eb 
.NEXT_BYTE:
	ld (hl),$40					; [X][-][-][-] - draw 1 of 2 yellow pixels		;8c18	36 40 
	inc hl						; next VRAM address								;8c1a	23 
	ld (hl),$01					; [-][-][-][X] - draw 2 of 2 yellow pixels		;8c1b	36 01 
	add hl,bc					; add 31 bytes per line - next line				;8c1d	09 
	dec a						; check if all pixels of this line were drawn	;8c1e	3d  
	jp nz,.NEXT_BYTE			; no - draw next 2 pixels						;8c1f	c2 18 8c  
	ex de,hl					; hl - address of next Line VRAM address		;8c22	eb 
	jp .NEXT_LINE				; read and draw next line from SDB				;8c23	c3 10 8c 

;***********************************************************************************************
; Read VRAM address form curent item in Screen Data Block
; IN: hl - address of current SDB item
READ_SDB_VADR
	ld e,(hl)					; e - low byte from memory pointed by hl		;8c26	5e 
	inc hl						; hl - address of high byte						;8c27	23 
	ld d,(hl)					; d - high byte from memory pointed by hl		;8c28	56 
	inc hl						; hl - address of next byte						;8c29	23 
	ret							; ------------ End of Proc --------------------	;8c2a	c9 

;***********************************************************************************************
UPDATE_SHOW_WALLS
	ld a,(LEVEL)				; current Game Level to play					;8c2b	3a 03 80 
	cp 3						; check if less than 3 (0, 1 or 2)				;8c2e	fe 03 
	ret m						; yes - ------------- End of Proc -----------	;8c30	f8 
; -- Level greater than equel to 3
	ld (SHOW_WALLS_FLAG),a		; set non zero value - hide Maze Walls 			;8c31	32 30 80

;***********************************************************************************************
; Clear Screen and set Graphics MODE 1 with default Color Palette
CLEAR_SCREEN_GFX:
	ld hl,VRAM					; src - video memory start						;8c34	21 00 70 
	ld de,VRAM+1				; dst - next byte								;8c37	11 01 70 
	ld bc,$07ff					; ctn - size of video memory in MODE 1 (gfx)	;8c3a	01 ff 07 
	ld (hl),0					; 4 green (background) pixels					;8c3d	36 00 
	ldir						; fill VRAM with green pixels					;8c3f	ed b0 
; -- set VIdeo Graphics Mode 1, Color Palette 0
	ld a,VDG_GFX_COLORS_0		; VDG Gfx MODE 1 Colors (Green/Yellow/Blue/Red)	;8c41	3e 08 
	ld (IOLATCH),a				; store to hardware register					;8c43	32 00 68 
	ld (IOLATCH_SHADOW),a		; save to shadow register fo future use			;8c46	32 6f 80 
	ret							; ----------------- End of Proc ---------------	;8c49	c9 


;***********************************************************************************************
; Levels Data Definitions
; Parameter for every Level has four values each
; GH_TIMER - Ghosts move in speed inverse proportional to this value
; GA_TIMER - Gost Red A moves in speed inverse proportional to this value
; CMODE_TIME - Duration time of Chase Mode
; GA_SPEEDUP - Value substracted from GA_TIMER in certain time in game - efectively speed up Ghost A move
DATA_LEVEL1:
	defb	255, 255, 110, 10			;8c4a	ff ff 6e 0a
DATA_LEVEL2:
	defb	220, 220,  80, 10			;8c4e	dc dc 50 0a
DATA_LEVEL3:
	defb	200, 200,  60, 15			;8c52	c8 c8 3c 0f
DATA_LEVEL4:
	defb	180, 180,  40, 20			;8c56	b4 b4 28 14 
DATA_LEVEL5:
	defb	150, 150,  20, 25			;8c5a	96 96 14 19 
	
;***********************************************************************************************
	ret							; Not used code									;8c5e	c9 
;***********************************************************************************************
; Screen Data Block - Horizontal Lines
; Every line definition contains 2 members: 16bit VRAM address and 8bit width of line (in bytes)
; Line width in pixels equals 4 * number of bytes.
; Width equals 0 means end of Screen Block Data
SDB_H_LINES:
	defw		$7000			; screen coord (0,0)px (0,0)bytes				;8c5f	00 70
	defb		32				; width 128px (32 bytes)						;8c61	20  
	defw		$70e6			; screen coord (24,7)px (6,7)bytes				;8c62	e6 70 
	defb		5				; width 20px (5 bytes)							;8c64	05  
	defw 		$71c9			; screen coord (36,14)px (9,14)bytes			;8c65	c9 71 
	defb		10				; width 40px (10 bytes)							;8c67	0a 
	defw		$71d6			; screen coord (88,14)px (22,14)bytes			;8c68	d6 71 
	defb		4				; width 16px (4 bytes)							;8c6a	04  
	defw		$72a7			; screen coord (28,21)px (7,21)bytes			;8c6b	a7 72
	defb		4				; width 16px (4 bytes)							;8c6d	04 
	defw		$72b1			; screen coord (68,21)px (17,21)bytes			;8c6e	b1 72 
	defb		4				; width 16px (4 bytes)							;8c70	04 
	defw		$7389			; screen coord (36,28)px (9,28)bytes			;8c71	89 73
	defb		4				; width 16px (4 bytes)							;8c73	04 
	defw		$738f			; screen coord (60,28)px (15,28)bytes			;8c74	8f 73 
	defb		4				; width 16px (4 bytes)							;8c76	04 
	defw		$7460			; screen coord (0,35)px (0,35)bytes				;8c77	60 74 
	defb		4				; width 16px (4 bytes)							;8c79	04 
	defw		$7469			; screen coord (36,35)px (9,35)bytes			;8c7a	69 74
	defb		10				; width 40px (10 bytes)							;8c7c	0a 
	defw		$7549			; screen coord (36,42)px (9,42)bytes			;8c7d	49 75
	defb		10				; width 40px (10 bytes)							;8c7f	0a 
	defw		$7558			; screen coord (96,42)px (24,42)bytes			;8c80	58 75 
	defb		5				; width 20px (5 bytes)							;8c82	05 
	defw		$7621			; screen coord (4,49)px (1,49)bytes				;8c83	21 76
	defb		3				; width 12px (3 bytes)							;8c85	03 
	defw		$7629			; screen coord (36,49)px (9,49)bytes			;8c86	29 76 
	defb		10				; width 40px (10 bytes)							;8c88	0a 
	defw		$7703			; screen coord (12,56)px (3,56)bytes			;8c89	03 77 
	defb		8				; width 32px (8 bytes)							;8c8b	08 
	defw		$7711			; screen coord (68,56)px (17,56)bytes			;8c8c	11 77
	defb		5				; width 20px (5 bytes)							;8c8e	05  
	defw		$7718			; screen coord (96,56)px (24,56)bytes			;8c8f	18 77 
	defb		5				; width 20px (5 bytes)							;8c91	05 
	defw		$77e0			; screen coord (0,63)px (0,63)bytes				;8c92	e0 77 
	defb		32				; width 128px (32 bytes)						;8c94	20 
	defw		$0000			; null address									;8c95	00 00 
	defb		0				; ----------- End of Data -----------			;8c97	00 

;***********************************************************************************************
; Screen Data Block - Horizontal Short (4px) Lines
; Every line definition contains 16bit VRAM address where we draw 4 yellow pixels
; Address equals 0 means end of Screen Block Data
SDB_H_4PX_LINES:
	
	defw		$70e3			; screen coord (12,7)px (3,7)bytes				;8c98	e3 70 
	defw 		$70ed			; screen coord (52,7)px (13,7)bytes				;8c9a	ed 70 
	defw		$70ee			; screen coord (56,7)px (14,7)bytes				;8c9c	ee 70 
	defw		$70f1			; screen coord (68,7)px (17,7)bytes				;8c9e	f1 70
	defw		$70f2			; screen coord (72,7)px (18,7)bytes				;8ca0	f2 70
	defw		$70f5			; screen coord (84,7)px (21,7)bytes				;8ca2	f5 70
	defw		$70f9			; screen coord (100,7)px (25,7)bytes			;8ca4	f9 70 
	defw		$70fc			; screen coord (112,7)px (28,7)bytes			;8ca6	fc 70
	defw		$71c3			; screen coord (12,14)px (3,14)bytes			;8ca8	c3 71
	defw		$71c6			; screen coord (24,14)px (6,14)bytes			;8caa	c6 71 
	defw		$71dc			; screen coord (112,14)px (28,14)bytes			;8cac	dc 71
	defw		$72a3			; screen coord (12,21)px (3,21)bytes			;8cae	a3 72
	defw		$72ad			; screen coord (52,21)px (13,21)bytes			;8cb0	ad 72
	defw		$72ae			; screen coord (56,21)px (14,21)bytes			;8cb2	ae 72 
	defw		$72b8			; screen coord (96,21)px (24,21)bytes			;8cb4	b8 72
	defw		$72bb			; screen coord (108,21)px (27,21)bytes			;8cb6	bb 72 
	defw		$72be			; screen coord (120,21)px (30,21)bytes			;8cb8	be 72
	defw		$7380			; screen coord (0,28)px (0,28)bytes				;8cba	80 73 
	defw		$7383			; screen coord (12,28)px (3,28)bytes			;8cbc	83 73 
	defw		$7386			; screen coord (24,28)px (6,28)bytes			;8cbe	86 73 
	defw		$7395			; screen coord (84,28)px (21,28)bytes			;8cc0	95 73 
	defw		$7398			; screen coord (96,28)px (24,28)bytes			;8cc2	98 73 
	defw		$737e			; screen coord (120,27)px (30,27)bytes			;8cc4	7e 73 
	defw		$737f			; screen coord (124,27)px (31,27)bytes			;8cc6	7f 73 
	defw		$745e			; screen coord (120,34)px (30,34)bytes			;8cc8	5e 74 
	defw		$745f			; screen coord (124,34)px (31,34)bytes			;8cca	5f 74
	defw		$7466			; screen coord (24,35)px (6,35)bytes			;8ccc	66 74 
	defw		$7475			; screen coord (84,35)px (21,35)bytes			;8cce	75 74 
	defw		$7478			; screen coord (96,35)px (24,35)bytes			;8cd0	78 74
	defw		$747b			; screen coord (108,35)px (27,35)bytes			;8cd2	7b 74 
	defw		$747e			; screen coord (120,35)px (30,35)bytes			;8cd4	7e 74 
	defw		$747f			; screen coord (124,35)px (31,35)bytes			;8cd6	7f 74 
	defw		$7543			; screen coord (12,42)px (3,42)bytes			;8cd8	43 75 
	defw		$7546			; screen coord (24,42)px (6,42)bytes			;8cda	46 75
	defw		$7555			; screen coord (84,42)px (21,42)bytes			;8cdc	55 75 
	defw		$7626			; screen coord (24,49)px (6,49)bytes			;8cde	26 76 
	defw		$7635			; screen coord (84,49)px (21,49)bytes			;8ce0	35 76 
	defw 		$7638			; screen coord (96,49)px (24,49)bytes			;8ce2	38 76 
	defw		$7639			; screen coord (100,49)px (25,49)bytes			;8ce4	39 76 
	defw		$763c			; screen coord (112,49)px (28,49)bytes			;8ce6	3c 76 
	defw		$770d			; screen coord (52,56)px (13,56)bytes			;8ce8	0d 77
	defw		$770e			; screen coord (56,56)px (14,56)bytes			;8cea	0e 77 
	defw		$70f8			; screen coord (96,7)px (24,7)bytes				;8cec	f8 70
	defw		0				; ----------- End of Data -----------			;8cee	00 00 

;***********************************************************************************************
; Screen Data Block - Vertical Lines - pattern [X][-][-][X]
; Every line definition contains 2 members: 16bit VRAM address (line start) and 8bit height of line
; Length equals 0 means end of Screen Block Data
SDB_V_LINES:
	defw		$7020			; screen coord (0,1)px (0,1)bytes				;8cf0	20 70 
	defb		27				; height 27px									;8cf2	1b 
	defw		$703f			; screen coord (124,1)px (31,1)bytes			;8cf3	3f 70 
	defb		21				; height 21px									;8cf5	15 
	defw		$7103			; screen coord (12,8)px (3,8)bytes				;8cf6	03 71 
	defb		6				; height 6px									;8cf8	06
	defw		$7115			; screen coord (84,8)px (21,8)bytes				;8cf9	15 71
	defb		20				; height 20px									;8cfb	14 
	defw		$711c			; screen coord (112,8)px (28,8)bytes			;8cfc	1c 71 
	defb		6				; height 6px									;8cfe	06 
	defw		$71e6			; screen coord (24,15)px (6,15)bytes			;8cff	e6 71 
	defb		13				; height 13px									;8d01	0d 
	defw		$72c3			; screen coord (12,22)px (3,22)bytes			;8d02	c3 72
	defb		6				; height 6px									;8d04	06
	defw		$72d8			; screen coord (96,22)px (24,22)bytes			;8d05	d8 72 
	defb		6				; height 6px									;8d07	06
	defw		$72db			; screen coord (108,22)px (27,22)bytes			;8d08	db 72
	defb		13				; height 13px									;8d0a	0d 
	defw		$73a9			; screen coord (36,29)px (9,29)bytes			;8d0b	a9 73
	defb		6				; height 6px									;8d0d	06
	defw 		$73b2			; screen coord (72,29)px (18,29)bytes			;8d0e	b2 73
	defb		6				; height 6px									;8d10	06
	defw		$7480			; screen coord (0,36)px (0,36)bytes				;8d11	80 74
	defb		27				; height 27px									;8d13	1b 
	defw		$7486			; screen coord (24,36)px (6,36)bytes			;8d14	86 74 
	defb		6				; height 6px									;8d16	06 
	defw		$7495			; screen coord (84,36)px (21,36)bytes			;8d17	95 74
	defb		6				; height 6px									;8d19	06 
	defw		$7498			; screen coord (96,36)px (24,36)bytes			;8d1a	98 74 
	defb		6				; height 6px									;8d1c	06 
	defw		$749f			; screen coord (124,36)px (31,36)bytes			;8d1d	9f 74
	defb		27				; height 27px									;8d1f	1b 
	defw		$757c			; screen coord (112,43)px (28,43)bytes			;8d20	7c 75
	defb		6				; height 6px									;8d22	06
	defw		$7646			; screen coord (24,50)px (6,50)bytes			;8d23	46 76
	defb		6				; height 6px									;8d25	06 
	defw		$7655			; screen coord (84,50)px (21,50)bytes			;8d26	55 76 
	defb		6				; height 6px									;8d28	06 
	defw		$0000			; null address									;8d29	00 00
	defb		0				; ----------- End of Data -----------			;8d2b	00 

;***********************************************************************************************
; Screen Data Block - Vertical Double Lines - pattern [X][-][-][-][-][-][-][X]
; Every line definition contains 2 members: 16bit VRAM address (line start) and 8bit height of line
; Length equals 0 means end of Screen Block Data
SDB_V_DBL_LINES:
	defw		$702d			; screen coord (52,1)px (13,1)bytes				;8d2c	2d 70
	defb		6				; height 6px									;8d2e	06
	defw		$7038			; screen coord (96,1)px (24,1)bytes				;8d2f	38 70
	defb		6				; height 6px									;8d31	06
	defw		$71ed			; screen coord (52,15)px (13,15)bytes			;8d32	ed 71
	defb		6				; height 6px									;8d34	06
	defw		$72de			; screen coord (120,22)px (30,22)bytes			;8d35	de 72
	defb		5				; height 5px									;8d37	05 
	defw		$764d			; screen coord (52,50)px (13,50)bytes			;8d38	4d 76 
	defb		6				; height 6px									;8d3a	06
	defw		$7658			; screen coord (96,50)px (24,50)bytes			;8d3b	58 76
	defb		6				; height 6px									;8d3d	06
	defw		$0000			; null address									;8d3e	00 00
	defb		0				; ----------- End of Data -----------			;8d40	00 

;***********************************************************************************************
; Screen Data Block - Dots Grid
; VRAM addresses of Dots to Eat by Player. Every address determines 1st of 9 Dots drawn 
; in column with 7 lines space beetween them. 
; Address $0000 marks end of data.
SDB_DOTS_GRID:
	
	defw		$7061			; screen coord (4,3)px (1,3)bytes				;8d41	61 70
	defw		$7064			; screen coord (16,3)px (4,3)bytes				;8d43	64 70 
	defw		$7067			; screen coord (28,3)px (7,3)bytes				;8d45	67 70
	defw		$7069			; screen coord (36,3)px (9,3)bytes				;8d47	69 70
	defw		$706b			; screen coord (44,3)px (11,3)bytes				;8d49	6b 70 
	defw		$706d			; screen coord (52,3)px (13,3)bytes				;8d4b	6d 70
	defw		$706f			; screen coord (60,3)px (15,3)bytes				;8d4d	6f 70 
	defw		$7071			; screen coord (68,3)px (17,3)bytes				;8d4f	71 70 
	defw		$7073			; screen coord (76,3)px (19,3)bytes				;8d51	73 70 
	defw		$7076			; screen coord (88,3)px (22,3)bytes				;8d53	76 70 
	defw		$707a			; screen coord (104,3)px (26,3)bytes			;8d55	7a 70 
	defw		$707d			; screen coord (116,3)px (29,3)bytes			;8d57	7d 70 
	defw		0				; ----------- End of Data -----------			;8d59	00 00 

;***********************************************************************************************
; Screen Data Block - Dots Unwanted
; VRAM addresses of Dots to remove from screen.
; This routine is needed beacuse SDB_DOTS_GRID routine draws every dots in defined grid w/o skipping unwanted
SDB_DOTS_CLR:
	
	defw		$706d			; screen coord (52,3)px (13,3)bytes				;8d5b	6d 70 
	defw		$722d			; screen coord (52,17)px (13,17)bytes			;8d5d	2d 72 
	defw		$73e9			; screen coord (36,31)px (9,31)bytes			;8d5f	e9 73 
	defw		$73eb			; screen coord (44,31)px (11,31)bytes			;8d61	eb 73 
	defw 		$73ed			; screen coord (52,31)px (13,31)bytes			;8d63	ed 73 
	defw		$73ef			; screen coord (60,31)px (15,31)bytes			;8d65	ef 73 
	defw		$73f1			; screen coord (68,31)px (17,31)bytes			;8d67	f1 73
	defw		$731a			; screen coord (104,24)px (26,24)bytes			;8d69	1a 73 
	defw		$731d			; screen coord (116,24)px (29,24)bytes			;8d6b	1d 73
	defw		$73fa			; screen coord (104,31)px (26,31)bytes			;8d6d	fa 73  
	defw		$73fd			; screen coord (116,31)px (29,31)bytes			;8d6f	fd 73
	defw		$768d			; screen coord (52,52)px (13,52)bytes			;8d71	8d 76 
	defw		$75ad			; screen coord (52,45)px (13,45)bytes			;8d73	ad 75 
	defw		$74cd			; screen coord (52,38)px (13,38)bytes			;8d75	cd 74 
	defw		0				; ----------- End of Data -----------			;8d77	00 00

;***********************************************************************************************
; Screen Data Block - Dots Extra
; Extra 6 Dots placed outside of Grid constrained coordinates
SDB_DOTS_EXTRA:
	defw		$7158			; screen coord (96,10)px (24,10)bytes			;8d79	58 71
	defw		$7238			; screen coord (96,17)px (24,17)bytes			;8d7b	38 72 
	defw		$7319			; screen coord (100,24)px (25,24)bytes			;8d7d	19 73 
	defw		$73f9			; screen coord (100,31)px (25,31)bytes			;8d7f	f9 73 
	defw		$75b8			; screen coord (96,45)px (24,45)bytes			;8d81	b8 75 
	defw		$7778			; screen coord (96,59)px (24,59)bytes			;8d83	78 77
	defw		0				; ----------- End of Data -----------			;8d85	00 00 

;***********************************************************************************************
; Screen Data Block - Power Pills
; Four Power Pills placed at 4 places 
SDB_POWER_PILLS:
	defw		$7141			; screen coord (4,10)px (1,10)bytes				;8d87	41 71
	defw		$715d			; screen coord (116,10)px (29,10)bytes			;8d89	5d 71 
	defw		$75a1			; screen coord (4,45)px (1,45)bytes				;8d8b	a1 75 
	defw		$75bd			; screen coord (116,45)px (29,45)bytes			;8d8d	bd 75 
	defw		0				; ----------- End of Data -----------			;8d8f	00 00


;***********************************************************************************************
; Screen Data Block - Vertical Passages 
; Every line definition contains 16bit VRAM address of top byte where starts 60px hight Passage
SDB_V_PASSAGES: 
	defw		$7001			; screen coord (4,0)px (1,0)bytes				;8d91	01 70
	defw		$7004			; screen coord (16,0)px (4,0)bytes				;8d93	04 70
	defw		$7007			; screen coord (28,0)px (7,0)bytes				;8d95	07 70 
	defw		$700b			; screen coord (44,0)px (11,0)bytes				;8d97	0b 70
	defw		$700f			; screen coord (60,0)px (15,0)bytes				;8d99	0f 70 
	defw		$7013			; screen coord (76,0)px (19,0)bytes				;8d9b	13 70 
	defw		$7016			; screen coord (88,0)px (22,0)bytes				;8d9d	16 70 
	defw		$701a			; screen coord (104,0)px (26,0)bytes			;8d9f	1a 70 
	defw		$701c			; screen coord (112,0)px (28,0)bytes			;8da1	1c 70
	defw		$701d			; screen coord (116,0)px (29,0)bytes			;8da3	1d 70 
	defw		$7019			; screen coord (100,0)px (25,0)bytes			;8da5	19 70 
	defw		0				; ----------- End of Data -----------			;8da7	00 00 	

;***********************************************************************************************
; Screen Data Block - Horizontal Passages 
; Every line definition contains 2 members: 16bit VRAM address and 8bit width of passage (in bytes)
; When Player or Ghost is at this position, can move Left and Right only 
; Width equals 0 means end of Screen Block Data
SDB_H_PASSAGES:

	defw		$7042			; screen coord (8,2)px (2,2)bytes				;8da9	42 70 
	defb		9				; width 36px (9 bytes)							;8dab	09 
	defw		$7050			; screen coord (64,2)px (16,2)bytes				;8dac	50 70 
	defb		6				; width 24px (6 bytes)							;8dae	06
	defw		$705b			; screen coord (108,2)px (27,2)bytes			;8daf	5b 70
	defb		2				; width 8px (2 bytes)							;8db1	02
	defw		$7125			; screen coord (20,9)px (5,9)bytes				;8db2	25 71 
	defb		14				; width 56px (14 bytes)							;8db4	0e
	defw		$7137			; screen coord (92,9)px (23,9)bytes				;8db5	37 71
	defb		3				; width 12px (3 bytes)							;8db7	03 
	defw		$7202			; screen coord (8,10)px (2,10)bytes				;8db8	02 72
	defb		2				; width 8px (2 bytes)							;8dba	02 
	defw		$7208			; screen coord (32,10)px (8,10)bytes			;8dbb	08 72
	defb		3				; width 12px (3 bytes)							;8dbd	03 
	defw		$7210			; screen coord (64,10)px (16,10)bytes			;8dbe	10 72 
	defb		3				; width 12px (3 bytes)							;8dc0	03 
	defw		$7217			; screen coord (92,10)px (23,10)bytes			;8dc1	17 72 
	defb		6				; width 24px (6 bytes)							;8dc3	06 
	defw		$72e8			; screen coord (32,23)px (8,23)bytes			;8dc4	e8 72
	defb		11				; width 44px (11 bytes)							;8dc6	0b 
	defw		$73bd			; screen coord (116,23)px (29,23)bytes			;8dc7	bd 73
	defb		4				; width 16px (4 bytes)							;8dc9	04 
	defw		$73c2			; screen coord (8,30)px (2,30)bytes				;8dca	c2 73
	defb		2				; width 8px (2 bytes)							;8dcd	02
	defw		$73c5			; screen coord (20,30)px (5,30)bytes			;8dcd	c5 73 
	defb		2				; width 8px (2 bytes)							;8dcf	02
	defw		$73d4			; screen coord (80,30)px (20,30)bytes			;8dd0	d4 73
	defb		2				; width 8px (2 bytes)							;8dd2	02
	defw		$73d7			; screen coord (92,30)px (23,30)bytes			;8dd3	d7 73
	defb		2				; width 8px (2 bytes)							;8dd5	02 
	defw		$74a2			; screen coord (8,37)px (2,37)bytes				;8dd6	a2 74
	defb		2				; width 8px (2 bytes)							;8dd8	02 
	defw		$74a8			; screen coord (32,37)px (8,37)bytes			;8dd9	a8 74 
	defb		11				; width 44px (11 bytes)							;8ddb	0b 
	defw		$74ba			; screen coord (104,37)px (26,37)bytes			;8ddc	ba 74 
	defb		2				; width 8px (2 bytes)							;8dde	02 
	defw		$7582			; screen coord (8,44)px (2,44)bytes				;8ddf	82 75 
	defb		24				; width 96px (24 bytes)							;8de1	18 
	defw		$7662			; screen coord (8,51)px (2,51)bytes				;8de2	62 76 
	defb		2				; width 8px (2 bytes)							;8de4	02 
	defw		$7668			; screen coord (32,51)px (8,51)bytes			;8de5	68 76 
	defb		3				; width 12px (3 bytes)							;8de7	03 
	defw		$7670			; screen coord (64,51)px (16,51)bytes			;8de8	70 76
	defb		3				; width 12px (3 bytes)							;8dea	03 
	defw		$767b			; screen coord (108,51)px (27,51)bytes			;8deb	7b 76
	defb		2				; width 8px (2 bytes)							;8ded	02 
	defw		$7742			; screen coord (8,58)px (2,58)bytes				;8dee	42 77
	defb		27				; width 108px (27 bytes)						;8df0	1b 
	defw		$0000			; null address									;8df1	00 00 
	defb		0				; ----------- End of Data -----------			;8df3	00 

;***********************************************************************************************
; Screen Data Block - Other Passages
; Every line definition contains 2 members: 16bit VRAM address and 4 bit data
; Data equals 0 means end of Screen Block Data.
SDB_OTHER_PASSAGES
	defw		$7041			; screen coord (4,2)px (1,2)bytes				;8df4	41 70 
	defb		%00000110		; PASS: Right/Down WALL: Up/Left				;8df6	06 
	defw		$7044			; screen coord (16,2)px (4,2)bytes				;8df7	44 70
	defb		%00001110		; PASS: Right/Down/Left WALL: Up				;8df9	0e	
	defw		$704f			; screen coord (60,2)px (15,2)bytes				;8dfa	4f 70
	defb		%00000110		; PASS: Right/Down WALL: Up/Left				;8dfc	06 
	defw		$704b			; screen coord (44,2)px (11,2)bytes				;8dfd	4b 70
	defb		%00001100		; PASS: Down/Left WALL: Up/Right				;8dff	0c 
	defw		$7053			; screen coord (76,2)px (19,2)bytes				;8e00	53 70 
	defb		%00001110		; PASS: Right/Down/Left WALL: Up				;8e02	0e
	defw		$7056			; screen coord (88,2)px (22,2)bytes				;8e03	56 70
	defb		%00001100		; PASS: Down/Left WALL: Up/Right				;8e05	0c 
	defw		$705a			; screen coord (104,2)px (26,2)bytes			;8e06	5a 70
	defb		%00000110		; PASS: Right/Down WALL: Up/Left				;8e08	06 
	defw		$705d			; screen coord (116,2)px (29,2)bytes			;8e09	5d 70
	defb		%00001100		; PASS: Down/Left WALL: Up/Right				;8e0b	0c 
	defw		$7124			; screen coord (16,9)px (4,9)bytes				;8e0c	24 71
	defb		%00000111		; PASS: Up/Right/Down WALL: Left				;8e0e	07 
	defw		$7127			; screen coord (28,9)px (7,9)bytes				;8e0f	27 71 
	defb		%00001110		; PASS: Right/Down/Left WALL: Up				;8e11	0e 
	defw		$712b			; screen coord (44,9)px (11,9)bytes				;8e12	2b 71
	defb		%00001011		; PASS: Up/Right/Left WALL: Down				;8e14	0b 
	defw		$712f			; screen coord (60,9)px (15,9)bytes				;8e15	2f 71
	defb		%00001011		; PASS: Up/Right/Left WALL: Down				;8e17	0b 
	defw		$7133			; screen coord (76,9)px (19,9)bytes				;8e18	33 71
	defb		%00001101		; PASS: Up/Down/Left WALL: Right				;8e1a	0d 
	defw		$7136			; screen coord (88,9)px (22,9)bytes				;8e1b	36 71 
	defb		%00000011		; PASS: Up/Right WALL: Down/Left				;8e1d	03 
	defw		$713a			; screen coord (104,9)px (26,9)bytes			;8e1e	3a 71
	defb		%00001101		; PASS: Up/Down/Left WALL: Right				;8e20	0d
	defw		$7201			; screen coord (4,16)px (1,16)bytes				;8e21	01 72
	defb		%00000111		; PASS: Up/Right/Down WALL: Left				;8e23	07
	defw		$7204			; screen coord (16,16)px (4,16)bytes			;8e24	04 72 
	defb		%00001101		; PASS: Up/Down/Left WALL: Right				;8e26	0d 
	defw		$7207			; screen coord (28,16)px (7,16)bytes			;8e27	07 72 
	defb		%00000011		; PASS: Up/Right WALL: Down/Left				;8e29	03 
	defw		$720b			; screen coord (44,16)px (11,16)bytes			;8e2a	0b 72 
	defb		%00001100		; PASS: Down/Left WALL: Up/Right				;8e2c	0c 
	defw		$720f			; screen coord (60,16)px (15,16)bytes			;8e2d	0f 72
	defb		%00000110		; PASS: Right/Down WALL: Up/Left				;8e2f	06 
	defw		$7213			; screen coord (76,16)px (19,16)bytes			;8e30	13 72
	defb		%00001001		; PASS: Up/Left WALL: Right/Down				;8e32	09 
	defw		$7216			; screen coord (88,16)px (22,16)bytes			;8e33	16 72 
	defb		%00000110		; PASS: Right/Down WALL: Up/Left				;8e35	06 
	defw		$7219			; screen coord (100,16)px (25,16)bytes			;8e36	19 72
	defb		%00001110		; PASS: Right/Down/Left WALL: Up				;8e38	0e
	defw		$721a			; screen coord (104,16)px (26,16)bytes			;8e39	1a 72
	defb		%00001011		; PASS: Up/Right/Left WALL: Down				;8e3b	0b 
	defw		$721c			; screen coord (112,16)px (28,16)bytes			;8e3c	1c 72
	defb		%00001110		; PASS: Right/Down/Left WALL: Up				;8e3e	0e 
	defw		$721d			; screen coord (116,16)px (29,16)bytes			;8e3f	1d 72
	defb		%00001001		; PASS: Up/Left WALL: Right/Down				;8e41	09 
	defw		$72e7			; screen coord (28,23)px (7,23)bytes			;8e42	e7 72
	defb		%00000110		; PASS: Right/Down WALL: Up/Left				;8e44	06 
	defw		$72eb			; screen coord (44,23)px (11,23)bytes			;8e45	eb 72
	defb		%00001011		; PASS: Up/Right/Left WALL: Down				;8e47	0b 
	defw		$72ef			; screen coord (60,23)px (15,23)bytes			;8e48	ef 72 
	defb		%00001011		; PASS: Up/Right/Left WALL: Down				;8e4a	0b 
	defw		$72f3			; screen coord (76,23)px (19,23)bytes			;8e4b	f3 72
	defb		%00001100		; PASS: Down/Left WALL: Up/Right				;8e4d	0c 
	defw		$73c1			; screen coord (4,30)px (1,30)bytes				;8e4e	c1 73
	defb		%00001011		; PASS: Up/Right/Left WALL: Down				;8e50	0b 
	defw		$73c4			; screen coord (16,30)px (4,30)bytes			;8e51	c4 73
	defb		%00001111		; PASS: Up/Right/Down/Left						;8e53	0f
	defw		$73c7			; screen coord (28,30)px (7,30)bytes			;8e54	c7 73 
	defb		%00001101		; PASS: Up/Down/Left WALL: Right				;8e56	0d 
	defw		$73d3			; screen coord (76,30)px (19,30)bytes			;8e57	d3 73 
	defb		%00000111		; PASS: Up/Right/Down WALL: Left				;8e59	07 
	defw		$73d6			; screen coord (88,30)px (22,30)bytes			;8e5a	d6 73 
	defb		%00001111		; PASS: Up/Right/Down/Left						;8e5c	0f 
	defw		$73d9			; screen coord (100,30)px (25,30)bytes			;8e5d	d9 73 
	defb		%00001101		; PASS: Up/Down/Left WALL: Right				;8e5f	0d 
	defw		$73bc			; screen coord (112,29)px (28,29)bytes			;8e60	bc 73
	defb		%00000111		; PASS: Up/Right/Down WALL: Left				;8e62	07 
	defw		$74a1			; screen coord (4,37)px (1,37)bytes				;8e63	a1 74 
	defb		%00000110		; PASS: Right/Down WALL: Up/Left				;8e65	06 
	defw		$74a4			; screen coord (16,37)px (4,37)bytes			;8e66	a4 74
	defb		%00001101		; PASS: Up/Down/Left WALL: Right				;8e68	0d 
	defw		$74a7			; screen coord (28,37)px (7,37)bytes			;8e69	a7 74 
	defb		%00000111		; PASS: Up/Right/Down WALL: Left				;8e6b	07 
	defw		$74b3			; screen coord (76,37)px (19,37)bytes			;8e6c	b3 74 
	defb		%00001101		; PASS: Up/Down/Left WALL: Right				;8e6e	0d 
	defw		$74b9			; screen coord (100,37)px (25,37)bytes			;8e6f	b9 74 
	defb		%00000011		; PASS: Up/Right WALL: Down/Left				;8e71	03 
	defw		$74bc			; screen coord (112,37)px (28,37)bytes			;8e72	bc 74
	defb		%00001011		; PASS: Up/Right/Left WALL: Down				;8e74	0b 
	defw		$74bd 			; screen coord (116,37)px (29,37)bytes			;8e75	bd 74
	defb		%00001100		; PASS: Down/Left WALL: Up/Right				;8e77	0c 
	defw		$7581			; screen coord (4,44)px (1,44)bytes				;8e78	81 75 
	defb		%00000011		; PASS: Up/Right WALL: Down/Left				;8e7a	03 
	defw		$7584			; screen coord (16,44)px (4,44)bytes			;8e7b	84 75 
	defb		%00001111		; PASS: Up/Right/Down/Left						;8e7d	0f 
	defw		$7587			; screen coord (28,44)px (7,44)bytes			;8e7e	87 75 
	defb		%00001111		; PASS: Up/Right/Down/Left						;8e80	0f 
	defw		$7593			; screen coord (76,44)px (19,44)bytes			;8e81	93 75
	defb		%00001111		; PASS: Up/Right/Down/Left						;8e83	0f 
	defw		$7596			; screen coord (88,44)px (22,44)bytes			;8e84	96 75 
	defb		%00001111		; PASS: Up/Right/Down/Left						;8e86	0f 
	defw		$759a			; screen coord (104,44)px (26,44)bytes			;8e87	9a 75
	defb		%00001100		; PASS: Down/Left WALL: Up/Right				;8e89	0c 
	defw		$7661			; screen coord (4,51)px (1,51)bytes				;8e8a	61 76 
	defb		%00000110		; PASS: Right/Down WALL: Up/Left				;8e8c	06 
	defw		$7664			; screen coord (16,51)px (4,51)bytes			;8e8d	64 76
	defb		%00001001		; PASS: Up/Left WALL: Right/Down				;8e8f	09 
	defw		$7667			; screen coord (28,51)px (7,51)bytes			;8e90	67 76 
	defb		%00000011		; PASS: Up/Right WALL: Down/Left				;8e92	03 
	defw		$766b			; screen coord (44,51)px (11,51)bytes			;8e93	6b 76
	defb		%00001100		; PASS: Down/Left WALL: Up/Right				;8e95	0c 
	defw 		$766f			; screen coord (60,51)px (15,51)bytes			;8e96	6f 76
	defb		%00000110		; PASS: Right/Down WALL: Up/Left				;8e98	06
	defw		$7673			; screen coord (76,51)px (19,51)bytes			;8e99	73 76
	defb		%00001001		; PASS: Up/Left WALL: Right/Down				;8e9b	09  
	defw		$767a			; screen coord (104,51)px (26,51)bytes			;8e9c	7a 76
	defb		%00000011		; PASS: Up/Right WALL: Down/Left				;8e9e	03 
	defw		$767d			; screen coord (116,51)px (29,51)bytes			;8e9f	7d 76 
	defb		%00001101		; PASS: Up/Down/Left WALL: Right				;8ea1	0d 
	defw		$7741			; screen coord (4,58)px (1,58)bytes				;8ea2	41 77 
	defb		%00000011		; PASS: Up/Right WALL: Down/Left				;8ea4	03 
	defw		$774b			; screen coord (44,58)px (11,58)bytes			;8ea5	4b 77
	defb		%00001011		; PASS: Up/Right/Left WALL: Down				;8ea7	0b 
	defw		$774f			; screen coord (60,58)px (15,58)bytes			;8ea8	4f 77 
	defb		%00001011		; PASS: Up/Right/Left WALL: Down				;8eaa	0b 
	defw 		$7756			; screen coord (88,58)px (22,58)bytes			;8eab	56 77 
	defb		%00001011		; PASS: Up/Right/Left WALL: Down				;8ead	0b 
	defw		$775d			; screen coord (116,58)px (29,58)bytes			;8eae	5d 77 
	defb		%00001001		; PASS: Up/Left WALL: Right/Down				;8eb0	09 
	defw		$73cd			; screen coord (52,30)px (13,30)bytes			;8eb1	cd 73
	defb		%00000001		; PASS: Up WALL: Right/Down/Left				;8eb3	01 
	defw		$73ad			; screen coord (52,29)px (13,29)bytes			;8eb4	ad 73 
	defb		%00000001		; PASS: Up WALL: Right/Down/Left				;8eb6	01 
	defw		$738d			; screen coord (52,28)px (13,28)bytes			;8eb7	8d 73 
	defb		%00000001		; PASS: Up WALL: Right/Down/Left				;8eb9	01 
	defw		$736d			; screen coord (52,27)px (13,27)bytes			;8eba	6d 73 
	defb		%00000001		; PASS: Up WALL: Right/Down/Left				;8ebc	01 
	defw		$734d			; screen coord (52,26)px (13,26)bytes			;8ebd	4d 73 
	defb		%00000001		; PASS: Up WALL: Right/Down/Left				;8ebf	01 
	defw		$732d			; screen coord (52,25)px (13,25)bytes			;8ec0	2d 73 
	defb		%00000001		; PASS: Up WALL: Right/Down/Left				;8ec2	01 
	defw		$730d			; screen coord (52,24)px (13,24)bytes			;8ec3	0d 73 
	defb		%00000001		; PASS: Up WALL: Right/Down/Left				;8ec5	01 
	defw		$0000			; null address									;8ec6	00 00 
	defb		0				; ----------- End of Data -----------			;8ec8	00 



;================================================================================================
;================================================================================================
;================================================================================================
;
;   Sprites Data Module 
;   -------------------
;	All sprites used in this game have dimension 8x4 px
;   Sprites are moved in 2px steps horizontal and 1px step vertical
;   Because 2px step Sprites for Player and Ghosts have defined second
;   variant shifted 2px right in order to draw them moved in the same VRAM address
;
	MODULE	SPR
;
;
;***********************************************************************************************
; Sprite Player (facing Right) (8x4)px (2x4) bytes - shifted 2px right
PLAYER_R_SH:
	
	defb		$00,$55			;8ec9	00 55		----XXXX
	defb		$01,$50			;8ecb	01 50		---XXX--
	defb		$01,$50			;8ecd	01 50		---XXX--
	defb		$00,$55			;8ecf	00 55 		----XXXX

;***********************************************************************************************
; Sprite Player (facing Left) (8x4)px (2x4) bytes - shifted 2px right
PLAYER_L_SH:
	
	defb		$01,$54			;8ed1	01 54		---XXXX-
	defb		$00,$15			;8ed4	00 15 		-----XXX
	defb		$00,$15			;8ed5	00 15 		-----XXX
	defb		$01,$54			;8ed7	01 54		---XXXX-
	
;***********************************************************************************************
; Sprite Player (facing Up) (8x4)px (2x4) bytes
PLAYER_U

	defb 		$10,$10			;8ed9	10 10		-X---X--
	defb		$14,$50			;8edb	14 50		-XX-XX--
	defb		$15,$50			;8edd	15 50 		-XXXXX--
	defb		$05,$40			;8edf	05 40 		--XXX---

;***********************************************************************************************
; Sprite Player (facing Down) (8x4)px (2x4) bytes
PLAYER_D:
	
	defb		$05,$40			;8ee1	05 40 		--XXX---
	defb		$15,$50			;8ee3	15 50 		-XXXXX--
	defb		$14,$50			;8ee5	14 50 		-XX-XX--
	defb		$10,$10			;8ee7	10 10 		-X---X--

;***********************************************************************************************
; Sprite Player (8x4)px (2x4) bytes - for animation frames
PLAYER_ANIM:
	
	defb		$05,$40			;8ee9	05 40		--XXX---
	defb		$15,$50			;8eeb	15 50 		-XXXXX--
	defb		$15,$50			;8eed	15 50 		-XXXXX--
	defb		$05,$40			;8eef	05 40 		--XXX---

;***********************************************************************************************
; Sprite Empty (all pixels background) (8x4)px (2x4) bytes
; Used to remove other sprite (Ghost,Player,etc) from screen at old position 
EMPTY:
	
	defb		$00,$00			;8ef1	00 00 		--------
	defb		$00,$00			;8ef3	00 00		--------
	defb		$00,$00			;8ef5	00 00 		--------
	defb		$00,$00			;8ef7	00 00 		--------

;***********************************************************************************************
; Dummy data	
	defb		0				;8ef9	00 	. 

;***********************************************************************************************
; Sprite Player (facing Right) (8x4)px (2x4) bytes 
PLAYER_R:
	
	defb		$05,$50			;8efa	05 50 		--XXXX--
	defb		$15,$00			;8efc	15 00 		-XXX----
	defb		$15,$00			;8efe	15 00 		-XXX----
	defb		$05,$50			;8f00	05 50 		--XXXX--

;***********************************************************************************************
; Sprite Player (facing Left) (8x4)px (2x4) bytes 
PLAYER_L:
	
	defb		$15,$40			;8f02	15 40 		-XXXX---
	defb		$01,$50			;8f04	01 50		---XXX--
	defb		$01,$50			;8f06	01 50 		---XXX--
	defb		$15,$40			;8f08	15 40 		-XXXX---

;***********************************************************************************************
; Sprite Ghost Blue data (8x4)px (2x4) bytes
GHOST_BLUE:
	
	defb		$0a,$80			;8f0a	0a 80		--XXX---
	defb		$22,$20			;8f0c	22 20		-X-X-X--
	defb		$2a,$a0			;8f0e	2a a0  		-XXXXX--
	defb		$22,$20			;8f10	22 20 		-X-X-X--

;***********************************************************************************************
; Sprite Ghost Blue data (8x4)px (2x4) bytes - shifted 2px to the right
GHOST_BLUE_2R
	
	defb		$00,$a8			;8f12	00 a8 		----XXX-
	defb		$02,$22			;8f14	02 22 		---X-X-X
	defb		$02,$aa 		;8f16	02 aa 		---XXXXX
	defb 		$02,$22			;8f18	02 22 		---X-X-X
	
;***********************************************************************************************
; Sprite Ghost Red data (8x4)px (2x4) bytes
GHOST_RED	
	
	defb		$0f,$c0			;8f1a	0f c0		--XXX--- 
	defb		$33,$30			;8f1c	33 30 		-X-X-X--
	defb 		$3f,$f0			;8f1e	3f f0 		-XXXXX--
	defb		$33,$30			;8f20	33 30 		-X-X-X--

;***********************************************************************************************
; Sprite Ghost Red data (8x4)px (2x4) bytes - shifted 2px to the right
GHOST_RED_2R
	
	defb 		$00,$fc			;8f22	00 fc 		----XXX-
	defb		$03,$33			;8f24	03 33  		---X-X-X
	defb		$03,$ff			;8f26	03 ff 		---XXXXX
	defb		$03,$33			;8f28	03 33 		---X-X-X

;***********************************************************************************************
; Sprite Ghost Red A variant data (8x4)px (2x4) bytes
GHOST_REDA
	
	defb		$0f,$c0			;8f2a	0f c0 		--XXX---
	defb		$30,$f0			;8f2c	30 f0 		-X--XX--
	defb		$3f,$f0			;8f2e	3f f0 		-XXXXX--
	defb		$33,$30			;8f30	33 30 		-X-X-X--
	
;***********************************************************************************************
; Sprite Ghost Red A variant data (8x4)px (2x4) bytes - shifted 2px to the right
GHOST_REDA_2R	
	defb		$00,$fc			;8f32	00 fc 		----XXX-
	defb		$03,$0f			;8f34	03 0f 		---X--XX
	defb		$03,$ff			;8f36	03 ff 		---XXXXX
	defb		$03,$33			;8f38	03 33		--_X-X-X

;***********************************************************************************************
; Sprite S001 (8x4) px (2x4) bytes
HEART
	defb		$3c,$3c			;8f3a	3c 3c 		-XX--XX-
	defb		$ff,$ff			;8f3c	ff ff 		XXXXXXXX
	defb		$3e,$fc			;8f3e	3e fc 		-XX*XXX-
	defb		$0f,$f0			;8f40	0f f0 		--XXXX--

	ENDMODULE		; ================ End SPR module ===========================================







;================================================================================================
;================================================================================================
;================================================================================================
;
;
	MODULE 	INPUT
;
;
;************************************************************************
; Keyboard Map              ADRES   |   D5  D4      D3  D2      D1  D0  |
;-----------------------------------|-----------------------------------|
KEYS_ROW_0  		equ     $6ffe   ;   R   Q       E           W   T   |
KEYS_ROW_1  		equ     $6ffd   ;   F   A       D   CTRL    S   G   |
KEYS_ROW_2  		equ     $6ffb   ;   V   Z       C   SHIFT   X   B   |
KEYS_ROW_4  		equ     $6fef   ;   M   SPACE   ,           .   N   |
KEYS_ROW_6  		equ     $6fbf   ;   U   P       I   RETURN  O   Y   |

JOYSTICK_PORT		equ		$20			; (RD) Joystick Input IO Port

UP					equ		0		; bit 0 in input bitmask variable
DOWN				equ		1		; bit 1 in input bitmask variable
LEFT				equ		2		; bit 2 in input bitmask variable
RIGHT				equ		3		; bit 3 in input bitmask variable
FIRE				equ		4		; bit 4 in input bitmask variable


;***********************************************************************************************
; Read keys and joystick (if allowed by player)
; OUT: a - bitmask with input events (keys or joystick) 
;          bit 0 - UP, bit 1 - DOWN, bit 2 - LEFT, bit 3 - RIGHT, bit 4 - FIRE
READ_INPUT:
	push bc					; save bc											;8f42	c5 
	ld c,%00000000			; initial empty bitmask - no input detected			;8f43	0e 00 
TEST_KEY_Q
	ld a,(KEYS_ROW_0)		; select Keyboard row 0 							;8f45	3a fe 6f
	bit 4,a					; check if key 'Q' is pressed						;8f48	cb 67 
	jp nz,TEST_KEY_A		; no - check next key								;8f4a	c2 4f 8f 
; -- set bit UP in input bitmask variable
	set UP,c				; set bit for UP key pressed						;8f4d	cb c1 
TEST_KEY_A:
	ld a,(KEYS_ROW_1)		; select Keyboard row 1 							;8f4f	3a fd 6f
	bit 4,a					; check if key 'A' is pressed						;8f52	cb 67 
	jp nz,TEST_KEY_M		; no - check next key								;8f54	c2 59 8f 
; -- set bit DOWN in input bitmask variable
	set DOWN,c				; set bit for DOWN key pressed						;8f57	cb c9 
TEST_KEY_M:
	ld a,(KEYS_ROW_4)		; select Keyboard row 4 							;8f59	3a ef 6f 
	bit 5,a					; check if key 'M' pressed							;8f5c	cb 6f 
	jp nz,TEST_KEY_COMMA	; no - check next key								;8f5e	c2 63 8f 
; -- set bit LEFT in input bitmask variable
	set LEFT,c				; set bit for LEFT key pressed						;8f61	cb d1 
TEST_KEY_COMMA:
	cpl						; invert bits - 1 means key pressed	 				;8f63	2f 
	and %00011000			; mask keys ',' (RIGHT) and SPACE (FIRE)			;8f64	e6 18
	or c					; a - bitmask with inputs detected					;8f66	b1 
	ld c,a					; store to local variable							;8f67	4f 
TEST_KEY_Z
	ld a,(KEYS_ROW_2)		; select Keyboard row 2								;8f68	3a fb 6f
	cpl						; invert bits - 1 means key pressed					;8f6b	2f 
	and %00010000			; mask on key 'Z' (bit FIRE)						;8f6c	e6 10 
	or c					; a - all detected keys								;8f6e	b1 
	pop bc					; restore bc										;8f6f	c1 
	ret nz					; ----- return if any checked key pressed			;8f70	c0 
; -- no keys pressed detected - check joystick if enabled 
	ld a,(JOY_ENABLE)		; Input flag - 0-keys, 1-joystick					;8f71	3a 7c 8f 
	or a					; check if joystick is enabled						;8f74	b7 
	ret z					; no -  return with a=0 - no key pressed			;8f75	c8 
; -- check joistick 	
	in a,(JOYSTICK_PORT)	; read Joystick										;8f76	db 20 
	cpl						; invert bits - 1 means joystick move/fire			;8f78	2f 
	and %00011111			; mask UP/DOWN/LEFT/RIGHT/FIRE						;8f79	e6 1f 
	ret						; -------- End of Proc ------ a - input bitmask 	;8f7b	c9 

;***********************************************************************************************
; Game Variables
JOY_ENABLE:
	defb	$00				; 1-joystick enabled, 0-keys only					;8f7c	00 
	


	ENDMODULE	; ================ End INPUT module ==========================================


;***********************************************************************************************
; Dummy Data	
	defb	0,0,0			;Not used											;8f7d	00 00 00
