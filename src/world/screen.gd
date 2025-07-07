extends Area3D

var looked: bool = false:
	set(value):
		if value != looked:
			upadate_look(value)
		looked = value

@onready var acceptable_parcels: Label = %"acceptable parcels"
@onready var mistakes: Label = %mistakes
@onready var massage: Label = %massage

@onready var icons_grid: GridContainer = $SubViewport/Control/Panel/HBoxContainer/ScrollContainer/PanelContainer/icons_grid

@onready var icons:Array[CompressedTexture2D] = G.gamedata.icons
var added_ids:Array[int] = []
@onready var sign_ok:CompressedTexture2D = preload("res://assets/icons/ok.png")
@onready var sign_no:CompressedTexture2D = preload("res://assets/icons/no.png")


func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("LMB"):
		looked = true
	if event.is_action_pressed("RMB"):
		looked = false
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("look_at_screen"):
		looked = !looked


func upadate_look(value):
	if value:
		G.main.camera.append_look_at_target(self)
	else:
		G.main.camera.erase_look_at_targets(self)


func _acceptable_parcels_changed(count:int):
	acceptable_parcels.text = "acceptable parcels: " + str(count)
	if count == 10:
		massage.text = "you have completed the task"
		massage.self_modulate = Color.GREEN
	elif count > 10:
		massage.text = "..."
func _mistakes_count_changed(count:int):
	mistakes.text = "mistakes: " + str(count)
	if count == 10:
		massage.text = "you failed the task"
		massage.self_modulate = Color.RED
	elif count > 10:
		massage.text = "..."
		
		
		
func show_next_textures(id:int):
	if id in added_ids:return
	
	var item:TextureRect = TextureRect.new()
	var sign:TextureRect = TextureRect.new()
	if id in G.gamedata.ban_list:
		sign.texture = sign_no
	else:
		sign.texture = sign_ok
	item.texture = icons[id]
	
	added_ids.append(id)
	
	icons_grid.add_child(item)
	icons_grid.add_child(sign)

#region 3d ui
# Used for checking if the mouse is inside the Area3D.
var is_mouse_inside = false
# The last processed input touch/mouse event. To calculate relative movement.
var last_event_pos2D = null
# The time of the last event in seconds since engine start.
var last_event_time: float = -1.0

@export var node_viewport:Viewport
@export var node_quad:MeshInstance3D
@export var node_area:Area3D = self

func _ready():
	node_area.mouse_entered.connect(_mouse_entered_area)
	node_area.mouse_exited.connect(_mouse_exited_area)
	node_area.input_event.connect(_mouse_input_event)
	# If the material is NOT set to use billboard settings, then avoid running billboard specific code
	if node_quad.get_surface_override_material(0).billboard_mode == BaseMaterial3D.BillboardMode.BILLBOARD_DISABLED:
		set_process(false)
	#NOTE signals
	G.main.acceptable_parcels_changed.connect(_acceptable_parcels_changed)
	G.main.mistakes_count_changed.connect(_mistakes_count_changed)
	G.main.current_item_changed.connect(func():show_next_textures(G.main.current_item.item_id))
func _mouse_entered_area():
	is_mouse_inside = true


func _mouse_exited_area():
	is_mouse_inside = false


func _unhandled_input(event):
	# Check if the event is a non-mouse/non-touch event
	for mouse_event in [InputEventMouseButton, InputEventMouseMotion, InputEventScreenDrag, InputEventScreenTouch]:
		if is_instance_of(event, mouse_event):
			# If the event is a mouse/touch event, then we can ignore it here, because it will be
			# handled via Physics Picking.
			return
	node_viewport.push_input(event)


func _mouse_input_event(_camera: Camera3D, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int):
	# Get mesh size to detect edges and make conversions. This code only support PlaneMesh and QuadMesh.
	var quad_mesh_size = node_quad.mesh.size

	# Event position in Area3D in world coordinate space.
	var event_pos3D = event_position

	# Current time in seconds since engine start.
	var now: float = Time.get_ticks_msec() / 1000.0

	# Convert position to a coordinate space relative to the Area3D node.
	# NOTE: affine_inverse accounts for the Area3D node's scale, rotation, and position in the scene!
	event_pos3D = node_quad.global_transform.affine_inverse() * event_pos3D

	# TODO: Adapt to bilboard mode or avoid completely.

	var event_pos2D: Vector2 = Vector2()

	if is_mouse_inside:
		# Convert the relative event position from 3D to 2D.
		event_pos2D = Vector2(event_pos3D.x, -event_pos3D.y)

		# Right now the event position's range is the following: (-quad_size/2) -> (quad_size/2)
		# We need to convert it into the following range: -0.5 -> 0.5
		event_pos2D.x = event_pos2D.x / quad_mesh_size.x
		event_pos2D.y = event_pos2D.y / quad_mesh_size.y
		# Then we need to convert it into the following range: 0 -> 1
		event_pos2D.x += 0.5
		event_pos2D.y += 0.5

		# Finally, we convert the position to the following range: 0 -> viewport.size
		event_pos2D.x *= node_viewport.size.x
		event_pos2D.y *= node_viewport.size.y
		# We need to do these conversions so the event's position is in the viewport's coordinate system.

	elif last_event_pos2D != null:
		# Fall back to the last known event position.
		event_pos2D = last_event_pos2D

	# Set the event's position and global position.
	event.position = event_pos2D
	if event is InputEventMouse:
		event.global_position = event_pos2D

	# Calculate the relative event distance.
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		# If there is not a stored previous position, then we'll assume there is no relative motion.
		if last_event_pos2D == null:
			event.relative = Vector2(0, 0)
		# If there is a stored previous position, then we'll calculate the relative position by subtracting
		# the previous position from the new position. This will give us the distance the event traveled from prev_pos.
		else:
			event.relative = event_pos2D - last_event_pos2D
			event.velocity = event.relative / (now - last_event_time)

	# Update last_event_pos2D with the position we just calculated.
	last_event_pos2D = event_pos2D

	# Update last_event_time to current time.
	last_event_time = now

	# Finally, send the processed input event to the viewport.
	node_viewport.push_input(event)
#endregion
