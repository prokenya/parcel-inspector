extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func show_end() -> void:
	animation_player.play("show")
	await animation_player.animation_finished
	return

func hide_end() -> void:
	animation_player.play_backwards("show")
	await animation_player.animation_finished
	return
	
func _on_play_again_pressed() -> void:
	await get_tree().change_scene_to_file("res://src/main.tscn")
	
