extends Node

var bots:Array #[(x,y),(x,y)]
var boxes:Array#[(x,y),(x,y)]
var mics:Array#[[(x,y),value],[(x,y),value]]
var speakers:Array#[[(x,y),value],[(x,y),value]]
var plates:Array #[(x,y),(x,y)]
var map:Array = [] # Game map
var title:String
var description:String

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
	if !DirAccess.dir_exists_absolute("user://levels"):
		var dir = DirAccess.open("user://")
		dir.make_dir("levels")
	
	var file = FileAccess.open("user://levels/level"+str(index)+".bat",FileAccess.WRITE)
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
	if FileAccess.file_exists("user://levels/level"+str(index)+".bat"):
		var file = FileAccess.open("user://levels/level"+str(index)+".bat",FileAccess.READ)
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
