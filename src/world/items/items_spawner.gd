extends Node3D

@export var box:Box
@export var items:Array[PackedScene]

func _ready() -> void:
	box.box_reset.connect(_box_reset)

func spawn_item(item:PackedScene):
	var inst_item = item.instantiate()
	inst_item.position = box.position
	add_child(inst_item)

func _box_reset():
	await  get_tree().create_timer(2).timeout 
	pick_random_item()

func pick_random_item():
	var random_item = items.pick_random()
	spawn_item(random_item)
