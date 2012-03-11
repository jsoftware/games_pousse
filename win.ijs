NB. win

OFFX=: 70
OFFY=: 0

NB. =========================================================
PS=: 0 : 0
pc ps closeok nomax nosize;pn "Pousse";
menupop "Options";
menu new "&New Game" "Ctrl+N" "" "";
menupop "New_Game_Size";
menu sz3 "&3" "" "" "";
menu sz4 "&4" "" "" "";
menu sz5 "&5" "" "" "";
menu sz6 "&6" "" "" "";
menu sz7 "&7" "" "" "";
menu sz8 "&8" "" "" "";
menupopz;
menusep ;
menu undo "&Undo" "Ctrl+U" "" "";
menusep ;
menu auto "&Auto Green Move" "" "" "";
menusep ;
menu two "&Two Player" "" "" "";
menusep ;
menu exit "E&xit" "" "" "";
menupopz;
menupop "Help";
menu instructions "&Instructions" "" "" "";
menusep ;
menu about "&About" "" "" "";
menupopz;
xywh 5 5 23 9;cc s1 static;cn "Red";
xywh 29 5 31 9;cc s2 static;cn "Green";
xywh 4 14 51 60;cc log editm ws_vscroll es_readonly bottomscale;
pas 0 0;
rem form end;
)

NB. =========================================================
ps_run=: ''&$: : (4 : 0)
ps=. PS rplc 'New_Game_Size';'New Game Size'
wd ps
wd 'setfont log ',FIXFONT
defbuttons''
defgrid''
writemenu''
wd 'pas 0 0'
wd^:(-.IFJ6) 'pshow;pshow sw_hide'
if. #x do. wdcenter x
else. wd 'pcenter' end.
ps_new_button''
wd 'pshow;'
)

NB. =========================================================
ps_about_button=: 3 : 0
'About' wdview '';(topara ABOUT);1
)

NB. =========================================================
ps_auto_button=: 3 : 0
IFAUTO=: -. IFAUTO
writemenu''
if. IFGREENMOVE do. rungreen'' end.
)

NB. =========================================================
ps_close=: 3 : 0
wd'pclose'
)

NB. =========================================================
ps_exit_button=: ps_cancel=: ps_close

NB. =========================================================
ps_instructions_button=: 3 : 0
'Instructions' wdview '';(topara INSTRUCTIONS);1
)

NB. =========================================================
ps_board_mbldown=: 3 : 0
if. IFGREENMOVE > IFTWO do. rungreen'' end.
)

NB. =========================================================
ps_new_button=: 3 : 0
button_enable (4*SIZE)#1
IFGREENMOVE=: 0
SEQ=: ''
run ":SIZE
psshow''
)

NB. =========================================================
ps_nctrl_fkey=: ps_new_button

NB. =========================================================
ps_two_button=: 3 : 0
IFTWO=: -. IFTWO
writemenu''
if. IFGREENMOVE *. IFAUTO do. rungreen'' end.
)

NB. =========================================================
ps_undo_button=: 3 : 0
if. IFTWO do.
  SEQ=: _3 }. SEQ
  IFGREENMOVE=: -. IFGREENMOVE
elseif. IFGREENMOVE do.
  SEQ=: _3 }. SEQ
  IFGREENMOVE=: 0
elseif. 1 do.
  SEQ=: _6 }. SEQ
end.
run (":SIZE),' ',SEQ
psshow''
)

NB. =========================================================
ps_uctrl_fkey=: ps_undo_button

NB. =========================================================
ps_boardsize=: 3 : 0
if. y=SIZE do.
  ps_new_button''
else.
  pos=. wd 'qformx'
  wd 'pclose'
  pos pousse y
end.
)

NB. =========================================================
ps_board_paint=: 3 : 0
writeboard BS
)

NB. =========================================================
ps_sz3_button=: ps_boardsize bind 3
ps_sz4_button=: ps_boardsize bind 4
ps_sz5_button=: ps_boardsize bind 5
ps_sz6_button=: ps_boardsize bind 6
ps_sz7_button=: ps_boardsize bind 7
ps_sz8_button=: ps_boardsize bind 8

NB. =========================================================
psshow=: 3 : 0
glsel 'board'
writelog SEQ
writeboard BS
writeenable''
writemenu''
wd 'setfocus board'
glpaint''
)

NB. =========================================================
button_enable=: 3 : 0
1 button_enable I.  y
0 button_enable I.  -.y
:
if. #y do.
  bn=. y{,BUTTONS
  if. IFJAVA=0 do.
    wd 'setenable '&, @ (,&(' ',(":x),' ')) &> bn
  end.
end.
)

NB. =========================================================
defbuttons=: 3 : 0
BUTTONS=: 'LRTB' ,each "0/ ":&.> >:i.SIZE
x=. ": OFFX + ,. SIZE#0,WID+CELL*SIZE
y=. ": OFFY + ,. HITE+CELL*(,~)i.SIZE
j=. (';cc '&,@ (,&' button')) &> ,2 {.BUTTONS
wd 'xywh ',"1 x,"1 ' ',"1 y,"1 (' ',":WID,CELL),"1 j
x=. ": OFFX + ,. (,~) WID+CELL*i.SIZE
y=. ": OFFY + ,. SIZE#0,HITE+CELL*SIZE
j=. (';cc '&,@ (,&' button')) &> ,2 }. BUTTONS
wd 'xywh ',"1 x,"1 ' ',"1 y,"1 (' ',":CELL,HITE),"1 j
)

NB. =========================================================
defgrid=: 3 : 0
j=. ';cc board isigraph'
wd 'xywh ',(":(OFFX+WID),(OFFY+HITE),2#CELL*SIZE),j
NB. resize grid for even sized buttons:
NB. TODO qchildxywhx not work
NB. 'x y w h'=. 0 ". wd 'qchildxywhx board'
'x y w h'=. 2 * ((OFFX+WID),(OFFY+HITE),2#CELL*SIZE)
CELL=: <. SIZE %~ w <. h
wd 'setxywhx board ',":x,y,2#CELL*SIZE
where=: (4,~*:SIZE)$, ,&(2#CELL)"1 CELL*>{2#<i.SIZE
)

NB. =========================================================
writeboard=: 3 : 0
y=. |:y
glrgb 1{COLORS
glpen 0 0
(0{COLORS) writecell where#~' '=,y
((2+PRED='X'){COLORS) writecell where#~'X'=,y
((2+PRED='O'){COLORS) writecell where#~'O'=,y
)

NB. =========================================================
writecell=: 4 : 0 "1
glrgb x
glbrush ''
glrect y NB. ,2#<.CELL%4
)

NB. =========================================================
writemenu=: 3 : 0
wd 'set auto ',":IFAUTO
wd 'set two ',":IFTWO
wd 'setenable auto ',":IFTWO=0
)

NB. =========================================================
writelog=: 3 : 0
if. 0 e. #y do.
  wd 'set log'
else.
  seq=. ;: y
  rws=. >. -: #seq
  seq=. _2 [\ (rws*2) {. seq
  txt=. LF ,. (>{."1 seq) ,. '  ' ,"1 >{:"1 seq
  wd 'set log *', log=: }. ,txt
  wd 'setscroll log ',":rws
end.
)
