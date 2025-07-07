extends Node

@onready var main:Main = get_node("/root/main")
@onready var data:Data = Data.load_or_create()

@onready var gamedata:GameData = GameData.load_or_create()
