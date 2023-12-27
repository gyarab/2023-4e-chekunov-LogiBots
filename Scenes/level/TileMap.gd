extends TileMap

@export var randomInt:= 0
signal floor_reset
# Called when the node enters the scene tree for the first time.
var movment_tiles = [0,0,0,0,0,0,5,5,5,5,5,5,4,6,6,6,6,6,6]

func flr_rst():
	var tiles = []
	
	if Variables.level <6:
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
