extends TileMap

@export var randomInt:= 0
signal floor_reset
# Called when the node enters the scene tree for the first time.
var movment_tiles = [0,0,0,0,0,0,5,5,5,5,5,5,4,6,6,6,6,6,6]
var counting_tiles = [3,3,3,7,7,8,8,8,9,10,10,10,10,10]
func flr_rst():
	var tiles = []
	
	if Variables.level <6:
		tiles = movment_tiles
	if Variables.level > 5 and Variables.level < 11:
		tiles = counting_tiles
		
	if Variables.level >= 11 and Variables.level < 17:
		tiles = counting_tiles #TODO new tiles
		
	
	if Variables.level >=17:
		tiles = movment_tiles
	
	for i in range(16):
		for j in range(10):
			set_cell(0,Vector2i(i,1+j),tiles.pick_random(),Vector2i(0,0),0)
	

func _ready():
	flr_rst()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_floor_reset():
	flr_rst()
