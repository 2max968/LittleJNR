extends Area2D

var pickedUp := false;

func _ready():
	get_tree().call_group("lock", "AddKey");


func _on_Key_body_entered(body):
	if(body is Player and not pickedUp):
		get_tree().call_group("lock", "UnlockKey");
		pickedUp = true;
		$sound.connect("finished", self, "finishedSound");
		$sound.play()
		$Sprite.visible = false;

func finishedSound():
	queue_free();
