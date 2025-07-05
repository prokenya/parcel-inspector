extends Area3D

var looked:bool = false

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if !event.is_pressed():return
	if event.is_action("LMB"):
		looked = !looked
	if looked:
		G.main.camera.append_look_at_target(self)
	else:
		G.main.camera.erase_look_at_targets(self)
		
