extends Node
class_name Main

@onready var camera: PhantomCamera3D = $world/PhantomCamera3D
@onready var camera_look_in: PhantomCamera3D = $world/PhantomCamera3D_look_in


signal current_item_changed()
var current_item:Item:
	set(value):
		current_item = value
		current_item_changed.emit()
	get():return current_item

signal acceptable_parcels_changed(count:int)
var acceptable_parcels_count:int = 0:
	set(value):
		acceptable_parcels_count = value
		acceptable_parcels_changed.emit(value)
	get():return acceptable_parcels_count

signal mistakes_count_changed(count:int)
var mistakes_count:int = 0:
	set(value):
		mistakes_count = value
		mistakes_count_changed.emit(value)
	get():return mistakes_count
