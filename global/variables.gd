extends Node

#lvl saves
var lvl_maps:Array = []

# lvl
var level:int = 0
var map:Array = []
var running:bool = false
# code
var current_code:int = 0
var codes:Array = []



# bots
# current bots
var bots:Array
var current_bot_count: int = 0
var bot_ids:int = 0
# bots waiting for other to move (for bot sync)
var hoping_bots:Array

# objects

#mic
var mics:Array
#speakers
var speakers:Array
# Plates
var plates:Array

# time
var sleep:bool = false
var tick:bool = false
var tick_time:float = 0.5

func _ready():
	for i in range(0,16):
		lvl_maps.append([])
		map.append([])
		lvl_maps[i].resize(10)
		lvl_maps[i].fill(0)
		map[i].resize(10)
		map[i].fill(0)
	# lvls config
	lvl_maps[5][5] = 1
	lvl_maps[5][6] = 1
	lvl_maps[10][0] = 2
	lvl_maps[10][1] = 2
	lvl_maps[10][3] = 2
	lvl_maps[8][7] = 3
	lvl_maps[6][7] = 4
	
	
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
	
