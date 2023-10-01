class_name Level

var Bots:Array #[(x,y),(x,y)]
var boxes:Array#[(x,y),(x,y)]
var mics:Array#[[(x,y),value],[(x,y),value]]
var speakers:Array#[[(x,y),value],[(x,y),value]]
var plates:Array #[(x,y),(x,y)]
var map:Array = [] # Game map

func create_map():
	for i in range(0,16):
		map.append([])
		map.append([])
		map[i].resize(10)
		map[i].fill(0)
		map[i].resize(10)
		map[i].fill(0)
