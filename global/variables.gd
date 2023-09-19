extends Node

# lvl
var level:int = 0
var map:Array = []
# code
var current_bot_count: int = 0
var current_code = 0
var codes:Array = []

# bots

# current bots
var bots:Array
# bots waiting for other to move (for bot sync)
var hoping_bots:Array

# time 
var sleep:bool = false
var tick:bool = false
var tick_time:float = 2

func _ready():
	for i in range(0,20):
		map.append([])
		map[i].resize(11)
		map[i].fill(0)
		
	print("\\")

func code_save():
	if !FileAccess.file_exists("res://codeSaves/"+"level "+str(level)):
		var dir = DirAccess.open("res://codeSaves/")
		dir.make_dir("level"+str(level))
	for i in range(0,current_bot_count):
		var file = FileAccess.open("res://codeSaves/"+"level"+str(level)+"/bot"+str(i)+".txt", FileAccess.WRITE)
		file.store_string(codes[i])
		
func code_load():
	for i in range(0,current_bot_count):
		var content:String
		if FileAccess.file_exists("res://codeSaves/"+"level"+str(level)+"/bot"+str(i)+".txt"):
			var file = FileAccess.open("res://codeSaves/"+"level"+str(level)+"/bot"+str(i)+".txt", FileAccess.READ)
			content = file.get_as_text()
		else:
			content = ""
		codes[i] = content
	
