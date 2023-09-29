extends StaticBody2D

var pos:Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector2(pos.x * 64 + 32,pos.y * 64 + 32 +64)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
