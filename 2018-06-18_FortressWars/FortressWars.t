import GUI

/**************************************************************
 *   This procedure gives the instructions for the game.      *
 **************************************************************/
procedure Instructions
    setscreen ("noecho,nocursor")
    locate (5, 52)
    put "Fortress Wars"
    color (2)
    locate (8, 50)
    put "by Vincent Zhang"
    locate (9, 50)
    put "June 15-18, 2018"
    put skip


    locate (15, 43)
    put "Hit any key to start the game..."

    Input.Pause

    cls
end Instructions


var winID : int := Window.Open ("graphics:1024;768")
View.Set ("graphics:1024;768,nobuttonbar")

Instructions

class Global
    export picMelee1, picRanged1, picCavalry1
	, picMelee2, picRanged2, picCavalry2
	, picSword1, picSword2, picCastle1, picCastle2, picWin, picFailed
	, font
	, WARRIOR_MY_START_X, WARRIOR_MY_START_Y, WARRIOR_MY_START_DX, WARRIOR_OP_START_X, WARRIOR_OP_START_Y, WARRIOR_OP_START_DX
	, GRID_TOP_Y, GRID_BOTTOM_Y, GRID_TOP_LEFT_X, GRID_TOP_RIGHT_X, GRID_BOTTOM_LEFT_X, GRID_BOTTOM_RIGHT_X


    const WARRIOR_MY_START_X := 50
    const WARRIOR_MY_START_Y := 40
    const WARRIOR_MY_START_DX := 100

    const WARRIOR_OP_START_X := 50
    const WARRIOR_OP_START_Y := 620
    const WARRIOR_OP_START_DX := 100

    const GRID_TOP_INTERVAL := 78
    const GRID_HEIGHT_INTERVAL := 200
    %//const GRID_MIDDLE_BOX_INTERVAL :=

    const GRID_TOP_Y := (maxy div 2) + GRID_HEIGHT_INTERVAL
    const GRID_BOTTOM_Y := (maxy div 2) - GRID_HEIGHT_INTERVAL + 20

    const GRID_TOP_LEFT_X := (maxx div 2) - 3 * GRID_TOP_INTERVAL
    const GRID_TOP_RIGHT_X := (maxx div 2) + 3 * GRID_TOP_INTERVAL

    const GRID_BOTTOM_LEFT_X := (maxx div 2) - 6 * GRID_TOP_INTERVAL
    const GRID_BOTTOM_RIGHT_X := (maxx div 2) + 6 * GRID_TOP_INTERVAL

    %//var font : int := Font.New ("sans serif:10:bold")
    var font : int := Font.New ("sans serif:10")

    var picMelee1 : int := Pic.FileNew ("Pictures/picMelee.jpg")
    var picRanged1 : int := Pic.FileNew ("Pictures/picRanged.jpg")
    var picCavalry1 : int := Pic.FileNew ("Pictures/picCavalry.jpg")
    var picMelee2 : int := Pic.FileNew ("Pictures/picMelee2.jpg")
    var picRanged2 : int := Pic.FileNew ("Pictures/picRanged2.jpg")
    var picCavalry2 : int := Pic.FileNew ("Pictures/picCavalry2.jpg")

    var picSword1 : int := Pic.FileNew ("Pictures/sword1.jpg")
    var picSword2 : int := Pic.FileNew ("Pictures/sword2.jpg")

    var picCastle1 : int := Pic.FileNew ("Pictures/castle1.jpg")
    var picCastle2 : int := Pic.FileNew ("Pictures/castle2.jpg")

    var picWin : int := Pic.FileNew ("Pictures/win.jpg")
    var picFailed : int := Pic.FileNew ("Pictures/failed.jpg")

end Global

var global : ^Global
new global


var initialized : int := 0

% -------------------------------------------------------------
class Warrior
    import Global
    export setTeam, setAttributes, setWarriorCoordinate, setState, draw, clear, attacked
	, warriorType, x, y, health, state
	, attackMelee, attackRanged, attackCavalry, attackCastle

    var warriorType : int
    var x : int := -1 % for draw images
    var y : int := -1
    var health : int := 0
    var attackMelee : int := 0
    var attackRanged : int := 0
    var attackCavalry : int := 0
    var attackCastle : int := 0
    var state : int := 0 % 0 : unselected, 1 : selected, 2: selecting, 3: in field, 4, die
    var team : int := 0

    proc setTeam (t : int)
	team := t
    end setTeam
    proc setAttributes (wt, h, am, ar, ah, ac : int)
	warriorType := wt
	health := h
	attackMelee := am
	attackRanged := ar
	attackCavalry := ah
	attackCastle := ac
	state := 0
    end setAttributes

    proc setWarriorCoordinate (xx, yy : int) % for draw image
	x := xx;
	y := yy;
    end setWarriorCoordinate

    proc setState (s : int)
	state := s
    end setState

    proc attacked (w : ^Warrior)
	var attack : int := 0
	case warriorType of
	    label 1 :
		attack := w -> attackMelee
	    label 2 :
		attack := w -> attackRanged
	    label 3 :
		attack := w -> attackCavalry
	end case

	if health <= attack then
	    health := 0
	else
	    health -= attack
	end if
    end attacked

    proc draw (global : ^Global, xc, yc : int)

	var pic : int
	case warriorType of
	    label 1 :
		if team = 1 then
		    pic := global -> picMelee2
		else
		    pic := global -> picMelee1
		end if
	    label 2 :
		if team = 1 then
		    pic := global -> picRanged2
		else
		    pic := global -> picRanged1
		end if
	    label 3 :
		if team = 1 then
		    pic := global -> picCavalry2
		else
		    pic := global -> picCavalry1
		end if
	end case

	var xx : int := x
	var yy : int := y

	if state = 2 or state = 3 then     % 2 selecting, 3: in field
	    xx := xc - 50
	    yy := yc - 40
	end if

	if health > 0 then
	    Pic.Draw (pic, xx, yy, 0)
	    Font.Draw (intstr (attackMelee) + " " + intstr (attackRanged) + " " + intstr (attackCavalry) + " " + intstr (attackCastle), xx, yy + 100, global -> font, red)
	    Font.Draw (intstr (health), xx + 75, yy + 100, global -> font, green)
	end if

	var clr : int := white
	if state = 1 then     % state = 1 : seleted
	    clr := red
	end if

	% Draw select box
	Draw.Box (x, y, x + 99, y + 112, clr);

	if state >= 2 then
	    Draw.FillBox (x, y, x + 100, y + 113, white);
	end if
    end draw

    proc clear (global : ^Global, xc, yc : int)
	var xx : int := x
	var yy : int := y

	if state = 2 or state = 3 then     % 2 selecting, 3: in field
	    xx := xc - 50
	    yy := yc - 40
	end if
	% Clear select box
	Draw.FillBox (xx, yy, xx + 100, yy + 113, white);
    end clear

end Warrior

var null : ^Warrior
new null

class Position
    export x, y, setxy
    var x : int := -1
    var y : int := -1
    proc setxy (xx, yy : int)
	x := xx;
	y := yy;
    end setxy
end Position

class Cell
    inherit Position
    import Global, Warrior
    export warrior, draw, redraw, setWarrior, drawArea
    var warrior : ^Warrior

    proc setWarrior (w : ^Warrior)
	warrior := w
    end setWarrior

    proc drawArea (clr : int)
	Draw.Box (x - 15, y - 15, x + 15, y + 15, clr);
    end drawArea

    proc draw (global : ^Global)
	/*
	 var pic : int %
	 pic := global -> picMelee %
	 Pic.Draw (pic, x, y, 0) %
	 */

	if warrior -> health = 0 then
	    % draw empty sell
	else
	    % draw in grid
	    warrior -> draw (global, x, y)
	end if
    end draw

    proc redraw (global : ^Global)
	warrior -> clear (global, x, y)
	warrior -> draw (global, x, y)
    end redraw
end Cell

class Castle
    inherit Position
    import Global, Warrior
    export health, setTeam, attacked, resumeHealth, draw, clear, redraw
    var health : int := 50
    var team : int := 0

    proc resumeHealth
	health := 50
    end resumeHealth

    proc setTeam (t : int)
	team := t
    end setTeam

    proc attacked (w : ^Warrior)
	var attack : int := w -> attackCastle
	if health <= attack then
	    health := 0
	else
	    health -= attack
	end if
    end attacked

    proc clear (global : ^Global)
	Draw.FillBox (x, y, x + 100, y + 111, white);
    end clear

    proc draw (global : ^Global)
	if team = -1 then
	    Pic.Draw (global -> picCastle1, x, y, picCopy)
	else
	    Pic.Draw (global -> picCastle2, x, y, picCopy)
	end if
	Font.Draw (intstr (health), x + 75, y + 100, global -> font, green)
    end draw

    proc redraw (global : ^Global)
	clear (global)
	draw (global)
    end redraw

end Castle

class Troop
    import Castle, Cell, Global, Warrior
    export team, castle, field, warriors, initialize, setPositions, draw
    var castle : ^Castle
    var field : array 1 .. 3, 1 .. 3 of ^Cell

    var warriors : array 1 .. 9 of ^Warrior
    var team : int := 0  % -1 mine, 1 opponent

    proc initialize (null : ^Warrior, who : int) % -1: my troop, 1: opponent

	team := who
	for i : 1 .. 9
	    new warriors (i)
	    warriors (i) -> setTeam (who)
	end for

	new castle
	castle -> setTeam (who)

	for i : 1 .. 3
	    for j : 1 .. 3
		new field (i, j)
		field (i, j) -> setWarrior (null)
	    end for
	end for
    end initialize

    proc setPositions (global : ^Global)
	for j : 1 .. 3
	    var dy : int := (global -> GRID_TOP_Y - global -> GRID_BOTTOM_Y) div 6
	    var y : int := global -> GRID_BOTTOM_Y - dy + dy * j * 2

	    var dxL : int := (global -> GRID_TOP_LEFT_X - global -> GRID_BOTTOM_LEFT_X) div 6
	    var xL : int := global -> GRID_BOTTOM_LEFT_X - dxL + dxL * j * 2
	    var dxR : int := (global -> GRID_TOP_RIGHT_X - global -> GRID_BOTTOM_RIGHT_X) div 6
	    var xR : int := global -> GRID_BOTTOM_RIGHT_X - dxR + dxR * j * 2
	    var xc : int := (xL + xR) div 2
	    var dx : int := (xR - xL) div 12

	    for i : 1 .. 3
		var x : int := xc + team * (i * dx * 2 - dx)
		field (i, j) -> setxy (x, y)
	    end for
	end for
    end setPositions

    proc draw (global : ^Global)
	castle -> draw (global)

	for j : 1 .. 3
	    for i : 1 .. 3

		field (i, j) -> draw (global)

	    end for
	end for
    end draw

end Troop


% -------------------------------------------------------------

var my_troop : ^Troop
var op_troop : ^Troop % opponent troop

procedure RedrawWarriors (warriors : array 1 .. 9 of ^Warrior)
    if initialized = 1 then
	for i : 1 .. 9
	    if warriors (i) -> state <= 2 then
		warriors (i) -> draw (global, 0, 0)
	    end if
	end for
    end if
end RedrawWarriors

procedure DrawInitialWarriors (start_x, start_y, dx : int, warriors : array 1 .. 9 of ^Warrior)
    for i : 1 .. 9
	var x := start_x + i * dx - dx
	var y := start_y
	warriors (i) -> setWarriorCoordinate (x, y)
    end for

    my_troop -> castle -> setxy (10, 400)
    op_troop -> castle -> setxy (880, 400)
    my_troop -> setPositions (global)
    op_troop -> setPositions (global)

    RedrawWarriors (warriors)

end DrawInitialWarriors

procedure CreateWarriors (troop : ^Troop)

    for i : 1 .. 9
	var typeOfWarrior : int := Rand.Int (1, 3)
	var health : int := 0
	var attackMelee : int := 0
	var attackRanged : int := 0
	var attackCavalry : int := 0
	var attackCastle : int := 0

	case typeOfWarrior of
	    label 1 :           % melee
		health := 10
		attackMelee := 8
		attackRanged := 8
		attackCavalry := 12
		attackCastle := 10
	    label 2 :
		health := 10   % range
		attackMelee := 12
		attackRanged := 8
		attackCavalry := 8
		attackCastle := 10
	    label 3 :
		health := 10   % horse
		attackMelee := 8
		attackRanged := 12
		attackCavalry := 8
		attackCastle := 10
	end case

	troop -> warriors (i) -> setAttributes (typeOfWarrior, health, attackMelee, attackRanged, attackCavalry, attackCastle)


    end for
end CreateWarriors

var opponent_method : int := 1 % 1: column, 2: row, 3: random

procedure OpponentDeployTroops (numberOfWarriors : int)
    var count : int := 0

    if op_troop -> castle -> health > 0 and my_troop -> castle -> health > 0 then % the fighting has not finished yet

	case opponent_method of
	    label 1 :
		var is : int := 1
		var ie : int := 3
		if numberOfWarriors = 3 then
		    is := Rand.Int (1, 3)
		    ie := is
		end if
		for i : is .. ie
		    for j : 1 .. 3
			exit when count >= numberOfWarriors
			if op_troop -> field (i, j) -> warrior -> health = 0 then
			    for k : 1 .. 9
				if op_troop -> warriors (k) -> state < 3 then
				    op_troop -> warriors (k) -> setState (3) % in field
				    op_troop -> field (i, j) -> setWarrior (op_troop -> warriors (k))
				    exit when 1 = 1
				end if
			    end for
			    count += 1
			end if
		    end for
		end for
	    label 2 :
		var js : int := 1
		var je : int := 3
		if numberOfWarriors = 3 then
		    js := Rand.Int (1, 3)
		    je := js
		end if
		for i : 1 .. 3
		    for j : js .. je
			exit when count >= numberOfWarriors
			if op_troop -> field (i, j) -> warrior -> health = 0 then
			    for k : 1 .. 9
				if op_troop -> warriors (k) -> state < 3 then
				    op_troop -> warriors (k) -> setState (3) % in field
				    op_troop -> field (i, j) -> setWarrior (op_troop -> warriors (k))
				    exit when 1 = 1
				end if
			    end for
			    count += 1
			end if
		    end for
		end for

	    label 3 :
		for k : 1 .. 9
		    exit when count >= numberOfWarriors
		    if op_troop -> warriors (k) -> state < 3 then

			for n : 1 .. 20
			    var m : int := Rand.Int (0, 8)
			    var i : int := 1 + m div 3
			    var j : int := 1 + m mod 3
			    % locate (1, 1)
			    % put " rand ", i, ", ", j
			    if op_troop -> field (i, j) -> warrior -> health = 0 then
				op_troop -> warriors (k) -> setState (3)         % in field
				op_troop -> field (i, j) -> setWarrior (op_troop -> warriors (k))
				count += 1
				exit when 1 = 1
			    end if
			end for
		    end if
		end for
	end case

	op_troop -> draw (global)
	
    end if

end OpponentDeployTroops

var total_moving_denomiator : real := 1
var step : int := 0

procedure battle (attacker, defender : ^Troop)

    % put "Fighting"
    for i : 1 .. 3
	for j : 1 .. 3  % my troops

	    exit when defender -> castle -> health <= 0
	    exit when attacker -> castle -> health <= 0

	    % put "Fighting ", i, ", ", j, ", ",  attacker -> field(j,i) -> warrior -> health, ", ",  defender -> field(i,j) -> warrior -> health

	    if attacker -> field (j, i) -> warrior -> health > 0 then
		var done : int := 0

		for k : 1 .. 4  %opponent troops
		    exit when done > 0

		    % put " k = ", k, ", ",  defender -> field(i,k) -> warrior -> health

		    var health := defender -> castle -> health
		    if k < 4 then
			health := defender -> field (k, i) -> warrior -> health
		    end if

		    if health > 0 then

			% put " -- k = ", k, ", ",  defender -> field(k,i) -> warrior -> health

			var x1 : int := attacker -> field (j, i) -> x
			var y1 : int := attacker -> field (j, i) -> y

			var x2 : int := defender -> castle -> x
			var y2 : int := defender -> castle -> y

			if k < 4 then
			    x2 := defender -> field (k, i) -> x
			    y2 := defender -> field (k, i) -> y
			end if


			var dx : int := x2 - x1
			var dy : int := y2 - y1

			% put " i, j, k: ", i, ", ", j, ", ", k, "     ", x1, ", ", y1, "   ", x2, ", ", y2, "      ", dx, ", ", dy, "  "

			var ratio : real := 0;
			var moving_ratio : real := 0
			for t : 0 .. 29

			    var x : int := x1 + round (intreal (dx) * moving_ratio / total_moving_denomiator)
			    var y : int := y1 + round (intreal (dy) * moving_ratio / total_moving_denomiator)

			    % put " t, x, y: ", t, ", ", x, ", ", y

			    var pic : int := global -> picSword1
			    if dx < 0 then
				pic := global -> picSword2
			    end if

			    Pic.Draw (pic, x, y, picXor)
			    delay (30)
			    Pic.Draw (pic, x, y, picXor)

			    moving_ratio += 10.0 * sin (3.1416 * intreal (t) / 30.0)

			end for

			var w1 : ^Warrior := attacker -> field (j, i) -> warrior
			if k < 4 then
			    var w2 : ^Warrior := defender -> field (k, i) -> warrior
			    w2 -> attacked (w1);
			    defender -> field (k, i) -> redraw (global)
			else
			    defender -> castle -> attacked (w1)
			    defender -> castle -> redraw (global)
			    if defender -> castle -> health <= 0 then
				locate (1, 1)
				if defender -> team = 1 then
				    put "You WIN";
				    Pic.Draw (global -> picWin, 356, 302, picXor)
				else
				    put "Game Over, you failed";
				    Pic.Draw (global -> picFailed, 361, 300, picXor)
				end if
				step := 100
			    end if
			end if
			done += 1

		    end if
		end for
	    end if
	end for
    end for
end battle

procedure fighting (who : int) % who attacks first
    if who = 1 then
	battle (my_troop, op_troop)
	battle (op_troop, my_troop)
    else
	battle (op_troop, my_troop)
	battle (my_troop, op_troop)
    end if

end fighting

procedure prepareInitData
    new my_troop
    new op_troop
    my_troop -> initialize (null, -1)
    op_troop -> initialize (null, 1)

    total_moving_denomiator := 0;
    for i : 1 .. 30
	total_moving_denomiator += 10.0 * sin (3.1416 * intreal (i) / 30.0)
    end for

end prepareInitData

var max_new_warriors : int := 0
var num_new_warriors : int := 0
var who_attack_first : int := -1
var nextBtn : int := -1
var radioBtn : array 1 .. 3 of int

procedure NewGame
    GUI.Hide (nextBtn)
    cls
    CreateWarriors (my_troop)
    CreateWarriors (op_troop)
    initialized := 1

    DrawInitialWarriors (global -> WARRIOR_MY_START_X, global -> WARRIOR_MY_START_Y, global -> WARRIOR_MY_START_DX, my_troop -> warriors)
    DrawInitialWarriors (global -> WARRIOR_OP_START_X, global -> WARRIOR_OP_START_Y, global -> WARRIOR_OP_START_DX, op_troop -> warriors)

    %drawGrid

    my_troop -> draw (global)
    op_troop -> draw (global)

    max_new_warriors := 3
    num_new_warriors := 0

    for i : 1 .. 3
	for j : 1 .. 3
	    my_troop -> field (i, j) -> setWarrior (null)
	    op_troop -> field (i, j) -> setWarrior (null)
	end for
    end for

    my_troop -> castle -> resumeHealth
    op_troop -> castle -> resumeHealth

    my_troop -> castle -> redraw (global)
    op_troop -> castle -> redraw (global)

    if who_attack_first = 1 then
	OpponentDeployTroops (3)
	who_attack_first := -1
	step := 11
    else
	who_attack_first := 1
	step := 1
    end if

    GUI.Refresh
end NewGame


procedure ProcessMouseData

    if my_troop -> castle -> health > 0 and op_troop -> castle -> health > 0 then
	% check if there is any warrior left
	var warriors_total_health : int := 0
	for i : 1 .. 9
	    if my_troop -> warriors (i) -> state < 3 then
		warriors_total_health += my_troop -> warriors (i) -> health
	    end if
	end for

	if warriors_total_health = 0 then
	    GUI.Show (nextBtn)
	end if

	% checking finished

	var x, y, button : int %vars for the mouse where code
	Mouse.Where (x, y, button) %code to find data on mouse

	%check to see if button is hit
	var done : int := 0

	if button = 1 then
	    if num_new_warriors < max_new_warriors then
		for i : 1 .. 9
		    var wx : int := my_troop -> warriors (i) -> x
		    var wy : int := my_troop -> warriors (i) -> y
		    if wx < x and x < wx + global -> WARRIOR_MY_START_DX and wy < y and y < wy + global -> WARRIOR_MY_START_DX then
			case my_troop -> warriors (i) -> state of
			    label 0, 1 : % unselected or selected
				for j : 1 .. 9
				    if j = i then
					my_troop -> warriors (j) -> setState (1) % selected
				    elsif my_troop -> warriors (j) -> state <= 1 then
					my_troop -> warriors (j) -> setState (0) % not selected
				    end if
				end for
				done := 1
			    label 2 : % in field
			    label 3 : % die
			end case
		    end if
		end for
	    end if
	end if

	locate (1, 1)
	% put " button = ", x, ", ", y, "done = ", done, "         "
	if done = 0 then

	    %var text : string := " "

	    % is there any selected warrior?
	    var selected : int := -1
	    for j : 1 .. 9
		if my_troop -> warriors (j) -> state <= 2 then
		    selected := j
		end if
	    end for

	    if selected >= 0 and num_new_warriors < max_new_warriors then

		for i : 1 .. 3
		    for j : 1 .. 3
			var xx : int := my_troop -> field (i, j) -> x
			var yy : int := my_troop -> field (i, j) -> y
			%text += "( " + intstr(i) + "," + intstr(j) + " : " + intstr(xx) + ", " + intstr(yy) + " ) "

			if initialized = 1 then
			    my_troop -> field (i, j) -> drawArea (blue)
			end if

			if xx - 15 < x and x < xx + 15 and yy - 15 < y and y < yy + 15 then
			    locate (3, 1)
			    % put "( ", i, ", ", j, ") - ", button, "        "

			    if button = 1 then
				for k : 1 .. 9
				    if my_troop -> warriors (k) -> state = 1 then % state is selected
					my_troop -> warriors (k) -> setState (3) % in field
					my_troop -> field (i, j) -> setWarrior (my_troop -> warriors (k))
					num_new_warriors += 1
					if num_new_warriors >= max_new_warriors then
					    GUI.Show (nextBtn)
					end if
				    end if
				end for
				my_troop -> field (i, j) -> drawArea (white)
				my_troop -> draw (global)
			    else
				if initialized = 1 then
				    my_troop -> field (i, j) -> drawArea (red)
				    my_troop -> draw (global)
				end if
				%//my_warriors (selected) -> draw ( global, xx, yy)
			    end if
			end if
		    end for
		    % text += "\n"
		end for
	    end if

	    locate (2, 1)
	    %put text

	    RedrawWarriors (my_troop -> warriors)

	end if
    end if
end ProcessMouseData

procedure nextStep
    step += 1
    GUI.Hide (nextBtn)
    case step of
	label 1 :
	    NewGame      % deploy my troops
	label 2 : % My attack
	    OpponentDeployTroops (3)
	    fighting (1)
	    OpponentDeployTroops (1)
	    max_new_warriors := 1
	    num_new_warriors := 0
	label 3 :
	    fighting (2)
	    num_new_warriors := 0
	label 4 :
	    OpponentDeployTroops (1)
	    fighting (1)
	    OpponentDeployTroops (1)
	    num_new_warriors := 0
	    step := 2

	label 12 : % Opponent attack
	    fighting (2)
	    max_new_warriors := 1
	    num_new_warriors := 0
	label 13 :
	    OpponentDeployTroops (1)
	    fighting (1)
	    OpponentDeployTroops (1)
	    num_new_warriors := 0
	label 14 :
	    fighting (2)
	    num_new_warriors := 0
	    step := 12


	label 101 : % DONE loop until gets response
	    step := 100
    end case
end nextStep

procedure RadioPressed
    for i : 1 .. 3
	if radioBtn (i) = GUI.GetEventWidgetID then
	    opponent_method := i
	end if
    end for
end RadioPressed

prepareInitData

% difficulty levels
var difficultyLabel : int := GUI.CreateLabel (140, 23, "DIFFICULTY")
% easy
radioBtn (1) := GUI.CreateRadioButton (50, 10, "Column", 0, RadioPressed)
% medium
radioBtn (2) := GUI.CreateRadioButton (150, 10, "Row", radioBtn (1), RadioPressed)
% hard
radioBtn (3) := GUI.CreateRadioButton (250, 10, "Random", radioBtn (2), RadioPressed)
% ctr + D is short cut key as well as enter from default button
nextBtn := GUI.CreateButtonFull (380, 10, 0, "Next", nextStep, 0, '^D', true)
var newBtn : int := GUI.CreateButton (500, 10, 0, "New Game", NewGame)
var quitBtn : int := GUI.CreateButton (700, 10, 0, "Quit", GUI.Quit)


loop
    exit when GUI.ProcessEvent
    % Process mouse events
    ProcessMouseData
end loop
Window.Close (winID)
