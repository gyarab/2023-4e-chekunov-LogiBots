extends Node

var bots:Array #[(x,y),(x,y)]
var boxes:Array#[(x,y),(x,y)]
var mics:Array#[[(x,y),value],[(x,y),value]]
var speakers:Array#[[(x,y),value],[(x,y),value]]
var plates:Array #[(x,y),(x,y)]
var map:Array = [] # Game map
var title:String
var description:String
"""
saves:
1. (1,[Vector2(5,5)],[],[],[],[Vector2(10,5)],"movement","move to the plate")
2. (2,[Vector2(1,1),Vector2(14,8)],[Vector2(2,0),Vector2(2,1),Vector2(2,2),Vector2(2,3),Vector2(2,4),Vector2(2,5),Vector2(2,6),Vector2(2,7),Vector2(2,8),Vector2(3,2),Vector2(3,6),Vector2(4,2),Vector2(4,8),Vector2(4,9),Vector2(4,4),Vector2(5,2),Vector2(5,4),Vector2(5,5),Vector2(5,6),Vector2(5,7),Vector2(5,8),Vector2(6,2),Vector2(6,4),Vector2(7,2),Vector2(7,3),Vector2(7,4),Vector2(9,0),Vector2(9,1),Vector2(9,2),Vector2(9,3),Vector2(9,4),Vector2(9,5),Vector2(10,0),Vector2(10,5),Vector2(11,0),Vector2(11,1),Vector2(11,2),Vector2(11,3),Vector2(11,5),Vector2(12,5),Vector2(13,1),Vector2(13,2),Vector2(13,3),Vector2(13,4),Vector2(13,5),Vector2(13,6),Vector2(13,7),Vector2(13,8),Vector2(13,9)],[],[],[Vector2(6,3),Vector2(10,1)],"moving with mind","move to the green block")
3. (3,[Vector2(3,4)],borders,[[Vector2(10,5),0]],[[Vector2(5,5),-12057]],[],"first counting!","take number from red speaker double it and say it to the green one")
4. (4,[Vector2(3,4)],boxes,[[Vector2(10,5),0]],[[Vector2(5,5),-10000]],[],"simple switch","if the number is negative, say 0 to green microphone, if not, say 1")
	"""
func save_level(idx,new_bots,new_boxes,new_mics,new_speakers,new_plates,new_title,new_description):
	"""manual created levels"""
	var index = idx
	bots = new_bots
	boxes = new_boxes
	mics = new_mics
	speakers = new_speakers
	plates = new_plates
	title = new_title
	description = new_description
	if !DirAccess.dir_exists_absolute("res://levels"):
		var dir = DirAccess.open("res://")
		dir.make_dir("levels")
	
	var file = FileAccess.open("res://levels/level"+str(index)+".bat",FileAccess.WRITE)
	var level:Dictionary = {
		"bots": bots,
		"boxes": boxes,
		"mics": mics,
		"speakers":speakers,
		"plates":plates,
		"title":title,
		"description":description
	}
	file.store_var(level)
	file.close()
	print("zapsal")
func load_level(index:int):
	Variables.current_code = 0
	Variables.level = index
	if FileAccess.file_exists("res://levels/level"+str(index)+".bat"):
		var file = FileAccess.open("res://levels/level"+str(index)+".bat",FileAccess.READ)
		var level = file.get_var(true)
		bots = level["bots"]
		boxes = level["boxes"]
		mics = level["mics"]
		speakers = level["speakers"]
		description = level["description"]
		title = level["title"]
		plates = level["plates"]
		file.close()
		create_map()

func create_map():
	
	# Map reset
	Variables.map_reset()
	
	Variables.mics_val = []
	Variables.speakers_val = []
	# Bots
	for bot in bots:
		Variables.lvl_maps[bot.x][bot.y] = 1
	# Boxes
	for item in boxes:
		Variables.lvl_maps[item.x][item.y] = 2
	for item in mics:
		Variables.lvl_maps[item[0].x][item[0].y] = 3
		Variables.mics_val.append(item[1])
	for item in speakers:
			Variables.lvl_maps[item[0].x][item[0].y] = 4
			Variables.speakers_val.append(item[1])
	Variables.plates = plates
	Variables.description = description
	Variables.title = title
