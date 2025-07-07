class_name GameData 
extends Resource

@export var items:Array[PackedScene]
@export var icons:Array[CompressedTexture2D]
@export var ban_list:Array[int]


func save() -> void:
	ResourceSaver.save(self, "res://src/resources/gamedata.tres")

static  func load_or_create() -> GameData:
	var res: GameData = load("res://src/resources/gamedata.tres") as GameData
	if !res:
		res = GameData.new()
	return res
