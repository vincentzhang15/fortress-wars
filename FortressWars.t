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
    % [Code Private - Contact to View]
end Global

var global : ^Global
new global


var initialized : int := 0

% -------------------------------------------------------------
class Warrior
    % [Code Private - Contact to View]
end Warrior

var null : ^Warrior
new null

class Position
    % [Code Private - Contact to View]
end Position

class Cell
    inherit Position
    import Global, Warrior
    export warrior, draw, redraw, setWarrior, drawArea
    var warrior : ^Warrior

    % [Code Private - Contact to View]
end Cell

class Castle
    % [Code Private - Contact to View]
end Castle

class Troop
    % [Code Private - Contact to View]
end Troop


% -------------------------------------------------------------

var my_troop : ^Troop
var op_troop : ^Troop % opponent troop

procedure RedrawWarriors (warriors : array 1 .. 9 of ^Warrior)
    % [Code Private - Contact to View]
end RedrawWarriors

procedure DrawInitialWarriors (start_x, start_y, dx : int, warriors : array 1 .. 9 of ^Warrior)
    % [Code Private - Contact to View]
end DrawInitialWarriors

procedure CreateWarriors (troop : ^Troop)
    % [Code Private - Contact to View]
end CreateWarriors

var opponent_method : int := 1 % 1: column, 2: row, 3: random

procedure OpponentDeployTroops (numberOfWarriors : int)
    % [Code Private - Contact to View]
end OpponentDeployTroops

var total_moving_denomiator : real := 1
var step : int := 0

procedure battle (attacker, defender : ^Troop)
    % [Code Private - Contact to View]
end battle

procedure fighting (who : int) % who attacks first
    % [Code Private - Contact to View]
end fighting

procedure prepareInitData
    % [Code Private - Contact to View]
end prepareInitData

var max_new_warriors : int := 0
var num_new_warriors : int := 0
var who_attack_first : int := -1
var nextBtn : int := -1
var radioBtn : array 1 .. 3 of int

procedure NewGame
    % [Code Private - Contact to View]
end NewGame


procedure ProcessMouseData
    % [Code Private - Contact to View]
end ProcessMouseData

procedure nextStep
    % [Code Private - Contact to View]
end nextStep

procedure RadioPressed
    % [Code Private - Contact to View]
end RadioPressed

prepareInitData


loop
    exit when GUI.ProcessEvent
    % Process mouse events
    ProcessMouseData
end loop
Window.Close (winID)
