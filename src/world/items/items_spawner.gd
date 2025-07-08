extends Node3D

@export var box: Box
@onready var items: Array[PackedScene] = G.gamedata.items

@onready var deafault_view: Node3D = $"../deafault_view"


func _ready() -> void:
	box.box_reset.connect(_box_reset)


func spawn_item(item: PackedScene):
	var inst_item = item.instantiate()
	inst_item.item_id = items.find(item)
	add_child(inst_item)


func pick_random_item():
	var random_item = items.pick_random()
	spawn_item(random_item)


func _box_reset():
	G.main.camera.append_look_at_target(deafault_view)
	await get_tree().create_timer(2).timeout
	G.main.camera.erase_look_at_targets(deafault_view)
	pick_random_item()
