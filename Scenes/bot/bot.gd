extends CharacterBody2D

signal get_new()
signal send_out()
signal add(num:int)
signal sub(num:int)
@export var value:int = 0
@onready var get_new_bool: bool = false
@onready var send_out_bool: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#value update
	$value.text = str(value)
	value+=1
	#get_new
	if get_new_bool:
		var direction = ($"../markers/input".position - self.position).normalized()
		velocity = direction * 100
		
		#Stop
		if self.position.distance_to($"../markers/input".position) <= 5:
			get_new_bool = false
			velocity = Vector2.ZERO
	
	#send_out
	if send_out_bool:
		var direction = ($"../markers/output".position - self.position).normalized()
		velocity = direction * 100
		
		#Stop
		if self.position.distance_to($"../markers/output".position) <= 5:
			send_out_bool = false
			velocity = Vector2.ZERO
		
	move_and_slide()


func _on_add(num):
	pass # Replace with function body.


func _on_get_new():
	get_new_bool = true

func _on_send_out():
	pass # Replace with function body.


func _on_sub(num):
	pass # Replace with function body.
