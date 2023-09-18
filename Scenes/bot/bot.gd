extends CharacterBody2D

@export var active: int = 0
@export var memory: int = 0
@export var pos:Vector2
@export var available:bool = true
func _ready():
	pos = Vector2(floor(self.position.x/64),floor(self.position.y/64))
	Variables.map[pos.x][pos.y] = 1
	position =Vector2(pos.x * 64 + 32,pos.y * 64 + 32)
func _process(_delta):
	$Active.text = str(active)
	$Memory.text = str(memory)
	move_and_slide()
	
