extends Area3D

@export var with_reward:bool = false

func _on_body_entered(body: Node3D) -> void:
	if body is Item:
		body.queue_free()
	if body is Box:
		body.reset()
		
