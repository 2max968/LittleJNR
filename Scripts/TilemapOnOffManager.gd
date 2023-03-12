extends Node2D

var blueOn = preload("res://Tilesets/BlueOn.tres");
var blueOff = preload("res://Tilesets/BlueOff.tres");

var redOn = preload("res://Tilesets/RedOn.tres");
var redOff = preload("res://Tilesets/RedOff.tres");

var greenOn = preload("res://Tilesets/GreenOn.tres");
var greenOff = preload("res://Tilesets/GreenOff.tres");

var blues = [];
var reds = [];
var greens = [];

func _init():
	add_to_group("colorhandler");

func _ready():
	var levelNode = $"../../Level";
	for childNode in levelNode.get_children():
		if(childNode is TileMap):
			if(childNode.tile_set == blueOff || childNode.tile_set == blueOn):
				blues.push_back(childNode);
			if(childNode.tile_set == redOff || childNode.tile_set == redOn):
				reds.push_back(childNode);
			if(childNode.tile_set == greenOff || childNode.tile_set == greenOn):
				greens.push_back(childNode);

func _setColorActive(tilemaps : Array, active : bool, tsActive : TileSet, tsInactive : TileSet):
	for tilemap in tilemaps:
		if(active):
			tilemap.tile_set = tsActive;
		else:
			tilemap.tile_set = tsInactive;

func SetColor(color : String):
	_setColorActive(blues, color == "blue", blueOn, blueOff);
	_setColorActive(reds, color == "red", redOn, redOff);
	_setColorActive(greens, color == "green", greenOn, greenOff);
