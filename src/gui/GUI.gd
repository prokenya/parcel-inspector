class_name GUI
extends Control

var in_ui: bool = false
var showing_controls:bool = true
@onready var gui_animations: AnimationPlayer = $gui_animations

@onready var music_spin_box: SpinBox = $VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/grid/music_spin_box
@onready var sfx_spin_box: SpinBox = $VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/grid/sfx_spin_box



func _ready() -> void:
	set_audio()


func set_audio(data: Data = G.data):
	var bus_index = AudioServer.get_bus_index("sfx")
	var bus_index1 = AudioServer.get_bus_index("music")
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(data.sfx)
	)
	AudioServer.set_bus_volume_db(
		bus_index1,
		linear_to_db(data.music)
	)
	sfx_spin_box.value = data.sfx * 100
	music_spin_box.value = data.music * 100


func _on_settings_pressed() -> void:
	if in_ui:
		gui_animations.play_backwards("open")
	else:
		gui_animations.play("open")

	in_ui = !in_ui

func _on_show_controls_pressed() -> void:
	if showing_controls:
		gui_animations.play_backwards("show_controls")
	else:
		gui_animations.play("show_controls")
		
	showing_controls = !showing_controls

func _on_music_spin_box_value_changed(value: float) -> void:
	G.data.music = value / 100
	G.data.save()
	set_audio()



func _on_sfx_spin_box_value_changed(value: float) -> void:
	G.data.sfx = value / 100
	G.data.save()
	set_audio()
