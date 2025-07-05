extends RigidBody3D
class_name Item

@export var y_offset: float = 2
var in_box:bool = true
@onready var interact_delay:Timer = Timer.new()

var picked: bool = false:
	set(value):
		picked = value

		freeze = picked
		if picked:
			G.main.camera.append_look_at_target(self)
		else:
			G.main.camera.erase_look_at_targets(self)
	get(): return picked

var tween: Tween

func _ready() -> void:
	interact_delay.one_shot = true
	add_child(interact_delay)
	input_event.connect(_on_input_event)
	collision_layer = 1 | 2
	collision_mask = 1 | 2

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("MMB") and picked:
		
		if !(event is InputEventMouseMotion):return
		rotate_item(event)


func pick_item():
	if !interact_delay.is_stopped():return
	
	if tween:
		tween.kill()
		
	if picked:
		picked = false
		tween.kill()
		interact_delay.start()
		return
	picked = true
	
	tween = create_tween()
	tween.tween_property(self, "position", position + Vector3(0, y_offset, 0), 2)


func kick_from_click(camera: Camera3D, event_position: Vector3):
	if tween:
		tween.kill()
	picked = false

	var direction = (global_transform.origin - camera.global_transform.origin).normalized()
	var force = direction * 7

	apply_impulse(force, event_position)


func rotate_item(event: InputEventMouseMotion):
	var camera = get_viewport().get_camera_3d()
	if camera == null:
		return
	
	var right = camera.global_transform.basis.x
	var up = camera.global_transform.basis.y

	rotate(up, event.relative.x * 0.01) 
	rotate(right, event.relative.y * 0.01)


func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if !event.is_pressed(): return

	if event.is_action("LMB"):
		pick_item()
	if event.is_action("RMB") and picked:
		kick_from_click(camera, event_position)
