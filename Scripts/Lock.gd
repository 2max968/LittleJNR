extends StaticBody2D

var numKeys = 0;
var keysUnlocked = 0;
var particles = preload("res://Prefabs/DeathParticles.tscn");

func _init():
	add_to_group("lock");

func AddKey():
	numKeys += 1;

func UnlockKey():
	keysUnlocked += 1;
	if(keysUnlocked >= numKeys):
		var pp = get_tree().get_nodes_in_group("player")[0].position;
		var distToPlayer = (pp - position).length()
		var t = Timer.new()
		add_child(t)
		t.wait_time = distToPlayer * .001
		t.one_shot = true
		t.connect("timeout",Callable(self,"openLock"))
		t.start()
		#openLock()

func openLock():
	var instance = particles.instantiate();
	instance.global_position = global_position + Vector2(16, 16)
	instance.get_node("part").emitting = true;
	get_parent().add_child(instance);
	var sound : AudioStreamPlayer2D = $sound;
	remove_child(sound)
	get_parent().add_child(sound);
	sound.play();
	queue_free()
