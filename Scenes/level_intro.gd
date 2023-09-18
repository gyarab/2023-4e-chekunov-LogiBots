extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Bot.emit_signal("get_new")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
