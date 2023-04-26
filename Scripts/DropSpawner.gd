extends Node2D

export var drop_color := "red"
export var delay = 0.0
var timeout := 0.0
var dropPrefab := preload("res://Prefabs/DropColor.tscn")

func _ready():
	timeout = delay

func _physics_process(delta):
	timeout -= delta
	if timeout <= 0:
		timeout = 0.75
		var drop = dropPrefab.instance()
		drop.global_position = global_position
		drop.SetColor(drop_color)
		get_parent().add_child(drop)
