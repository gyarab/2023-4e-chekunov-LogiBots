extends StaticBody2D

var pos:Vector2
var number:int
# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector2(pos.x * 64 + 32,pos.y * 64 + 32)

func _process(_delta):
	$number.text = str(number)
