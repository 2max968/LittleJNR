extends KinematicBody2D
class_name Player_Base, "res://Sprites/Player/Blue.png"

const INVINCIBLETIME = 1.0;

var health : int = 3;
var invincible = -1;
var movementRight := true
var velocity = Vector2(0,0)
var useKey : int = Inp.MOVE_DOWN

func BaseDamage(amount : int):
	if(invincible <= 0):
		health = max(0, health - amount);
		invincible = INVINCIBLETIME;
	get_tree().call_group("playerstate", "Health", health);
	if(health <= 0):
		Kill();

func Kill():
	get_tree().call_group("levelControl", "die");

func GetUseKey() -> int:
	return useKey
