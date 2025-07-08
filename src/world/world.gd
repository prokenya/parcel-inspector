extends Node3D

@onready var main:Main = get_parent()
@onready var box: Box = $item_spawner/box

func _input(event: InputEvent) -> void:
	if box.behind_the_view:return
	if event.is_action_pressed("look_in"):
		if main.camera_look_in.priority == 2:
			main.camera_look_in.priority = 0
			#main.camera.priority = 0
		else:
			#main.camera.priority = 1
			main.camera_look_in.priority = 2
			
