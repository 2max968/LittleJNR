extends Node2D

var numKeys : = 0;
var keysUnlocked : = 0;
var sprites : = [];

export var KeySlotEmpty : Texture;
export var KeySlotFull : Texture;

var currentSpriteX : = 0

func _init():
	add_to_group("lock");

func AddKey():
	numKeys += 1;
	var sprite : = Sprite.new();
	add_child(sprite);
	sprite.position = Vector2(currentSpriteX, 0);
	currentSpriteX += 40;
	sprite.texture = KeySlotEmpty;
	sprites.append(sprite);

func UnlockKey():
	sprites[keysUnlocked].texture = KeySlotFull;
	keysUnlocked += 1;
