extends Node3D

@export var direction:int = 1
@export var enable:bool = false
@export_range(0.01,0.99,0.01) var speed:float = 0.01

@onready var static_body_3d: StaticBody3D = $StaticBody3D
@onready var conveyor: MeshInstance3D = $conveyor/conveyor

func _ready() -> void:
	G.main.current_item_changed.connect(func():if G.main.current_item.picked:enable = false)

func _physics_process(delta: float) -> void:
	if enable:
		conveyor.material_override.uv1_offset.x -= speed * direction / 2
		static_body_3d.constant_linear_velocity.x = -direction * speed * 100
	else:
		static_body_3d.constant_linear_velocity.x = 0
		

func _input(event: InputEvent) -> void:
	if G.main.current_item:
		if G.main.current_item.picked:return
	if Input.is_action_just_pressed("ui_accept"):
		enable = !enable
	if Input.is_action_just_pressed("ui_left"):
		direction = -1
	if Input.is_action_just_pressed("ui_right"):
		direction = 1
