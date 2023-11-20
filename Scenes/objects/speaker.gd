extends StaticBody2D

var pos:Vector2
var number:int
var show_questionmark := false
# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector2(pos.x * 64 + 32,pos.y * 64 + 32 +64)

func _process(_delta):
	
	if show_questionmark:
		$number.text = "?"
	else:
		$number.text = str(number)
