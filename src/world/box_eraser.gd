extends Area3D

@export var with_reward:bool = false
@onready var ban_list:Array[int] = G.gamedata.ban_list
@export var indicator_light:Light3D
@export var audio_player:AudioStreamPlayer
func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body is Item:
		if with_reward:
			if !(body.item_id in ban_list):
				G.main.acceptable_parcels_count += 1
			else:
				G.main.mistakes_count += 1
		elif !(body.item_id in ban_list):
			G.main.mistakes_count += 1
			
		body.queue_free()
		animate_light()
		play_audio()
	if body is Box:
		body.reset()
		

var light_tween:Tween
func animate_light(duration = 0.5):
	if !indicator_light:return
	var start_energy = indicator_light.light_energy
	if light_tween:
		light_tween.kill()
	light_tween = create_tween()
	await light_tween.tween_property(indicator_light,"light_energy",start_energy + 5,duration/2)
	light_tween.tween_property(indicator_light,"light_energy",start_energy,duration/2)
	
func play_audio():
	if audio_player:
		audio_player.pitch_scale = [0.8,0.9,1,1.1,1.2].pick_random()
		audio_player.play()
