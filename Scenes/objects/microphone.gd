extends StaticBody2D

var pos:Vector2
@export var number:int
@export var show_questionmark := false
var random_number:= randi_range(0,99)
# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector2(pos.x * 64 + 32,pos.y * 64 + 32 +64)

func _process(_delta):
	
	if show_questionmark:
		$number.text = random_number
	else:
		$number.text = str(number)


func _on_number_timer_timeout():
	random_number = randi_range(0,99)
