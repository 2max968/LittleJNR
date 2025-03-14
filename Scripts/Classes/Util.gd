extends Node
class_name Util

static func FindNodeOfType(node : Node, type : String, level : int = 0) -> Node:
	#var name := ""
	#for i in range(0, level):
	#	name += " "
	#print(name + node.name + " : " + node.get_class())
	if node.is_class(type):
		return node
	for child in node.get_children():
		var nd := FindNodeOfType(child, type, level + 1)
		if nd != null:
			return nd
	return null

static func FindPlayer(node : Node) -> Player_Base:
	if node is Player_Base:
		var ply : Player_Base = node
		return ply
	for child in node.get_children():
		var nd := FindPlayer(child)
		if nd != null:
			return nd
	return null
