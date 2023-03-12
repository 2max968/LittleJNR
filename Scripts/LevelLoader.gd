extends Node

export var levelPath : String = "res://Scenes/Levels/Demos/LoaderTest.tres"

func _ready():
	loadLevel(levelPath)

func loadLevel(path : String):
	var lvl := ConfigFile.new()
	lvl.load(levelPath)
	var hlimit := Node2D.new()
	var vlimit := Node2D.new()
	var width = lvl.get_value("Map", "width", 20)
	var height = lvl.get_value("Map", "height", 20)
	hlimit.position = Vector2(width, 0) * 32
	vlimit.position = Vector2(0, height) * 32
	hlimit.name = "HLimit"
	vlimit.name = "VLimit"
	$"../Level".add_child(hlimit)
	$"../Level".add_child(vlimit)
	get_tree().call_group("limits", "updateLimits");
	
	var i := 0;
	while true:
		if(not lvl.has_section_key("Objects", str(i))):
			break
		var oText : String = lvl.get_value("Objects", str(i))
		var words := oText.split(';')
		var obj = load(words[0]).instance()
		obj.position = Vector2(float(words[1]), float(words[2])) * 32
		$"../Level".add_child(obj)
		i += 1
	
	i = 0
	while true:
		var sName := "Tilemap" + str(i)
		i += 1
		if(not lvl.has_section(sName)):
			break
		var tilesetPath = lvl.get_value(sName, "tileset")
		var j := 0;
		var tilemaps := []
		var tileset : TileSet = load(tilesetPath)
		var tilemap := TileMap.new()
		tilemap.cell_size = Vector2(32,32)
		tilemap.tile_set = tileset;
		$"../Level".add_child(tilemap)
		while true:
			if(not lvl.has_section_key(sName, str(j))):
				break
			var tilemapName = lvl.get_value(sName, str(j))
			tilemaps.append(tilemapName)
			j += 1;
		
		for i_row in range(0, height):
			var keyName := "row" + str(i_row)
			if(lvl.has_section_key(sName, keyName)):
				var row := str(lvl.get_value(sName, keyName))
				var tiles = row.split(',')
				for i_tile in range(0, len(tiles)):
					var tile = tiles[i_tile]
					var ind_tilemap := int(tile.split(':')[0]);
					var ind_tile := int(tile.split(':')[1]);
					
					var tileName = tilemaps[ind_tilemap] + " " + str(ind_tile)
					var tileId = tileset.find_tile_by_name(tileName)
					tilemap.set_cell(i_tile, i_row, tileId)
	
	pass
