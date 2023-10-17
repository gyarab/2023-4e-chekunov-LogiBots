extends Node

#Globals
var level := 1



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

	#LevelClass.save_level(2,[Vector2(1,1),Vector2(14,8)],[Vector2(2,0),Vector2(2,1),Vector2(2,2),Vector2(2,3),Vector2(2,4),Vector2(2,5),Vector2(2,6),Vector2(2,7),Vector2(2,8),Vector2(3,2),Vector2(3,6),Vector2(4,2),Vector2(4,8),Vector2(4,9),Vector2(4,4),Vector2(5,2),Vector2(5,4),Vector2(5,5),Vector2(5,6),Vector2(5,7),Vector2(5,8),Vector2(6,2),Vector2(6,4),Vector2(7,2),Vector2(7,3),Vector2(7,4),Vector2(9,0),Vector2(9,1),Vector2(9,2),Vector2(9,3),Vector2(9,4),Vector2(9,5),Vector2(10,0),Vector2(10,5),Vector2(11,0),Vector2(11,1),Vector2(11,2),Vector2(11,3),Vector2(11,5),Vector2(12,5),Vector2(13,1),Vector2(13,2),Vector2(13,3),Vector2(13,4),Vector2(13,5),Vector2(13,6),Vector2(13,7),Vector2(13,8),Vector2(13,9)],[],[],[Vector2(6,3),Vector2(10,1)],"moving with mind","move to the green block")
	
func map_reset():
	for i in range(0,16):
		for j in range(0,10):
			map[i][j] = 0
			lvl_maps[i][j] = 0
	return

func _exit_tree():
	GameFiles.game_progress_save(false)
	

	# old lvls config
	lvl_maps[5][5] = 1
	lvl_maps[5][6] = 1
	lvl_maps[10][0] = 2
	lvl_maps[10][1] = 2
	lvl_maps[10][3] = 2
	lvl_maps[8][7] = 3
	lvl_maps[6][7] = 4
	
