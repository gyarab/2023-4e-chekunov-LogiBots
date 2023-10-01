extends Node

#Globals
var level := 0



var current_save_file := 1
# level
#saves
var lvl_maps:Array = []
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
	

func create_save_files():
	if !DirAccess.dir_exists_absolute("user://Saves"):
		var dir = DirAccess.open("user://")
		dir.make_dir("Saves")
		
	if !DirAccess.dir_exists_absolute("user://Saves/Save "+str(current_save_file)):
		var current_save_dir = DirAccess.open("user://Saves")
		current_save_dir.make_dir("Save "+str(current_save_file))
		print("Save")
	else:
		print("exist!")
func code_save():
	create_save_files()
	game_progress_save()
	#CodeSave dir
	if !DirAccess.dir_exists_absolute("user://Saves/Save "+str(current_save_file)+"/CodeSaves/"):
		var dir = DirAccess.open("user://Saves/Save "+str(current_save_file))
		dir.make_dir("CodeSaves")
		
	if !FileAccess.file_exists("user://Saves/Save "+str(current_save_file)+"/CodeSaves/"+"Level "+str(level)):
		var dir = DirAccess.open("user://Saves/Save "+str(current_save_file)+"/CodeSaves/")
		dir.make_dir("Level "+str(level))
	for i in range(0,current_bot_count):
		
		var file = FileAccess.open("user://Saves/Save "+str(current_save_file)+"/CodeSaves/"+"Level "+str(level)+"/Bot "+str(i)+".txt", FileAccess.WRITE)
		file.store_string(codes[i])

func game_progress_save():
	var file_path := "user://Saves/Save "+str(current_save_file)+"/gameProgress.bat"
	var file
	file = FileAccess.open(file_path,FileAccess.WRITE)
	file.store_var(level)
		
func game_progress_load():
	pass

func code_load():
	for i in range(0,current_bot_count):
		var content:String
		var bot_path := "user://Saves/Save "+str(current_save_file)+"/CodeSaves/"+"Level "+str(level)+"/Bot "+str(i)+".txt"
		if FileAccess.file_exists(bot_path):
			var file = FileAccess.open(bot_path, FileAccess.READ)
			content = file.get_as_text()
		else:
			content = ""
		codes[i] = content
	
