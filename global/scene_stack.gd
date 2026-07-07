extends Node

var scene_stack: Array[Node] = []

func push_scene(to_add: Node) -> void:
	scene_stack.push_front(to_add)

func pop_scene() -> Node:
	if not scene_stack.is_empty():
		return scene_stack.pop_front()
	return null
