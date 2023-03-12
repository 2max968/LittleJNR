extends ItemList


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	loadTileset(load("res://Tilesets/Tileset.tres"))

func loadTileset(ts : TileSet):
	self.clear()
	var tiles := ts.get_tiles_ids()
	for tile in tiles:
		var name = ts.tile_get_name(tile)
		var texture = ts.tile_get_texture(tile)
		self.add_item(name, texture, true)
