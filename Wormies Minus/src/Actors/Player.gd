extends KinematicBody2D

var move = 1
# move 1 = curved, move 0 = straight
var direction = Vector2(1, 0)
export var speed = 1
export var turnspeed = 0.05
var button
var color = Color()
var ai_controlled = false
var last_hazard

export (PackedScene) var BodyScene; var links = []; var links_img = []
var pos_start = Vector2(0, 0); var size_body_link = 5; var num_links = 10; var dt = 15
 
#onready var timer = Timer.new()

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var velocity = Vector2()
var radius = 50
var angle = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var a = randf()
	var b = randf()
	var c = randf()
	color = Color(a, b, c, 1)
	var PlayerSprite = get_node("PlayerSprite")
	PlayerSprite.self_modulate = color
	$Polygons.modulate = color
	ai_controlled = get_parent().ai_controlled
	print(ai_controlled)
	
	pass # Replace with function body.
	
#	var wait = randf()
#	timer.set_one_shot(false)
#	timer.set_wait_time(wait)
#	timer.connect("timeout", self, "_timer_callback")
#	add_child(timer)

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if ai_controlled:
		pass
#	var positionn = $BodyLock.get_global_position()
#	print(positionn)
	if (move == 0):
		move_and_slide(velocity * speed)
	elif (move == 1):
		velocity = move_and_slide(velocity*speed)
		velocity = radius*Vector2(cos(angle),sin(angle))
		angle += speed*delta
		self.rotation = angle
		angle = wrapf(angle,-PI,PI)
#		print(self.position)
#		if (direction.x == 1 and direction.y != 1):
#			direction.y += turnspeed
#		if (direction.y == 1 and direction.x != -1):
#			direction.x -= turnspeed
#		if (direction.x == -1 and direction.y != -1):
#			direction.y -= turnspeed
#		if (direction.y == -1):
#			direction.x += turnspeed
#		direction.x = max(direction.x, -1)
#		direction.x = min(direction.x, 1)
#		direction.y = max(direction.y, -1)
#		direction.y = min(direction.y, 1)
#		var playerMove = move_and_collide(direction * speed)
	
	
func _input(event: InputEvent) -> void:
	if not ai_controlled:
		if event.is_action_pressed("move_1") and move == 1:
	#		print(self.position)
	#		print($PlayerLock.position + self.position)
			move = 0
		elif event.is_action_pressed("move_1") and move == 0:
			move = 1
		if event is InputEventKey and event.is_pressed() and event.scancode == button:
			if move == 1:
				move = 0
			elif move == 0:
				move = 1
#
#func _on_PlayArea_body_shape_exited(body_id: int, body: Node, body_shape: int, area_shape: int) -> void:
#	print(body)
#	die()
#	pass # Replace with function body.
	
	
#func die():
#	queue_free()
##	self.visible = false;
##	timer.start()
#
#
#
#
#func _on_PlayArea_body_exited(body: Node) -> void:
#	print(body)
#	if body == self:
#		die()
	pass # Replace with function body.
	
func _timer_callback():
	queue_free()


func _on_DieSpot_body_entered(body):
	if body.is_in_group("body") and button != body.id:
		natural_death()
	pass # Replace with function body.


func natural_death():
	queue_free()


func _on_AIDetection_area_entered(area):
	if ai_controlled:
		if area.is_in_group("hazard"):
			move = 1
			last_hazard = area
	pass # Replace with function body.


func _on_AIDetection_area_exited(area):
	if ai_controlled:
		if area == last_hazard:
			var test = randf()
			if test > 0.5:
				move = 0
			else:
				move = 1
	pass # Replace with function body.


func _on_GoodieDetection_area_entered(area):
	if ai_controlled:
		if area.is_in_group("goodie"):
			move = 0
	pass # Replace with function body.
