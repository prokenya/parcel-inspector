extends Node3D

@onready var seconds: MeshInstance3D = $clock/seconds
@onready var hours: MeshInstance3D = $clock/hours


func _physics_process(delta: float) -> void:
	var time = Time.get_datetime_dict_from_system()
	hours.rotation.y = -deg_to_rad(time["hour"] * 6)
	seconds.rotation.y = -deg_to_rad(time["second"] * 6)
