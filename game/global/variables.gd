extends Node

#Globals
var level := 1

var points:= 0

# object_intro
var object_to_show := -1
var current_screen := "menu"
var first_look = true

var current_save_file := -1
# level
#saves
var lvl_maps:Array = []
"""lvl_map from save, initial lvl map"""

var title:String = "title"
var description:String = "description"

var map:Array = []
"""dynamic map"""

var running:bool = false
# code
var current_code:int = 0
var codes:Array = [""]
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
var mics_val:Array
#speakers
var speakers:Array
var speakers_val:Array
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
	
	var boxes := []
	for i in 16:
		for j in 10:
			if i == 0 or i == 15:
				boxes.append(Vector2(i,j))
				continue
			if j == 0 or j == 9:
				boxes.append(Vector2(i,j))
				continue 
	
	#LevelClass.save_level(15,[Vector2(3,4)],boxes,[[Vector2(10,5),0]],[[Vector2(1,3),-10000],[Vector2(1,5), -10000]],[]," adding together","Add two numbers from red speakers, if sum is positive whrite 1, if zero write zero, if negative whrite -1 Add two numbers from red speakers, if sum is positive whrite 1, if zero write zero, if negative whrite -1 Add two numbers from red speakers, if sum is positive whrite 1, if zero write zero, if negative whrite -1")
	LevelsInit.create_levels()
func map_reset():
	for i in range(0,16):
		for j in range(0,10):
			map[i][j] = 0
			lvl_maps[i][j] = 0
	return

func _exit_tree():
	if current_save_file != -1:
		GameFiles.code_save()
		GameFiles.game_progress_save(false)
	

	# old lvls config
	lvl_maps[5][5] = 1
	lvl_maps[5][6] = 1
	lvl_maps[10][0] = 2
	lvl_maps[10][1] = 2
	lvl_maps[10][3] = 2
	lvl_maps[8][7] = 3
	lvl_maps[6][7] = 4
	
