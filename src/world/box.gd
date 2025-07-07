extends RigidBody3D
class_name Box


signal box_reset
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var camera:PhantomCamera3D
@onready var item:Item:
	set(value):
		item = value
		if !camera:return
		if item:
			freeze = false
			camera.append_look_at_target(self)
			play_sound()
		#else:
			#camera.erase_look_at_targets(self)
			
	get():return item
@export var is_open:bool = false



func open():
	animation_player.play("open")
	is_open = true
	
func close():
	animation_player.play_backwards("open")
	is_open = false

func _ready() -> void:
	await get_tree().process_frame
	camera = G.main.camera as PhantomCamera3D
	camera.append_look_at_target(self)
	freeze = false
	play_sound()
func _on_animatable_body_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if !event.is_pressed():return
	if event.is_action("LMB"):
		if is_open:
			close()
		else:
			open()

func reset():
	freeze = true
	position = Vector3.ZERO
	rotation = Vector3.ZERO
	camera.erase_look_at_targets(self)
	close()
	box_reset.emit()
	
func _on_item_detector_body_entered(body: Node3D) -> void:
	if body is Item:
		if !item:
			item = body
			item.in_box = true

func _on_item_detector_body_exited(body: Node3D) -> void:
	if item == body:
		item.in_box = false
		item = null

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func play_sound() -> void:
	if audio_stream_player.playing:return
	audio_stream_player.pitch_scale = [0.8,0.9,1,1.1,1.2].pick_random()
	audio_stream_player.play()
