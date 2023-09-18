extends CharacterBody2D

@export var active: int = 0
@export var memory: int = 0
@export var pos:Vector2
@export var available:bool = true
@export var iterator:int = 0
@export var code_lines:Array

signal move(direction:String)
signal listen(direction:String)
signal say(direction:String)

var is_moving:bool = false
var direction:String
func _ready():
	pos = Vector2(floor(self.position.x/64),floor(self.position.y/64))
	Variables.map[pos.x][pos.y] = 1
	position =Vector2(pos.x * 64 + 32,pos.y * 64 + 32)

func _process(delta):
	$Active.text = str(active)
	$Memory.text = str(memory)
	print(Variables.tick)
	if is_moving and Variables.tick:
		print("jsme tu?")
		if direction == "left":
			velocity = Vector2.LEFT * delta * 64 *60/ Variables.tick_time
			move_and_slide()
	
	

func iterator_update():
	if iterator < len(code_lines)-1:
		iterator += 1
	else:
		available = false


func _on_listen(direction):
	pass # Replace with function body.


func _on_move(direction):
	print("sigal halo?")
	var map = Variables.map
	if direction == "up":
		if Variables.map[pos.x][pos.y-1] == 0:
			map[pos.x][pos.y-1] = 1
			map[pos.x][pos.y] = 0
			pos.y-=1
			iterator_update()
			self_move("up")
	if direction == "down":
		if Variables.map[pos.x][pos.y+1] == 0:
			map[pos.x][pos.y+1] = 1
			map[pos.x][pos.y] = 0
			pos.y+=1
			iterator_update()
			self_move("down")
	if direction == "left":
		if Variables.map[pos.x-1][pos.y] == 0:
			map[pos.x-1][pos.y] = 1
			map[pos.x][pos.y] = 0
			pos.x-=1
			iterator_update()
			self_move("left")
	if direction == "right":
		if Variables.map[pos.x+1][pos.y] == 0:
			map[pos.x+1][pos.y] = 1
			map[pos.x][pos.y] = 0
			pos.x+=1
			iterator_update()
			self_move("right")
	Variables.map = map
	
func self_move(dir:String):
	is_moving = true
	direction = dir
func _on_say(direction):
	pass # Replace with function body.
