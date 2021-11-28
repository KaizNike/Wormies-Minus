extends Node2D
export var segments = 0
onready var PlayerNode = get_node("Player")
export (PackedScene) var BodyScene
var color = Color()
var followBodyFull
var lastBody
var distance = 20
var button
var bodyLength = 0
var id = 1
var ai_controlled = false
var first = false


# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerNode.button = button
	id = button
	color = PlayerNode.color
	if segments == 0:
		followBodyFull = PlayerNode
	for segment in segments:
		print('Spawn body' + str(segment) )
		if segment == 0:
			followBodyFull = PlayerNode
		else:
			followBodyFull = lastBody
		grow()
#		var scene_instance = BodyScene.instance()
#		scene_instance.id = button
#		scene_instance.color = color
#		scene_instance.followBody = followBodyFull
##		scene_instance.position = followBodyFull.get_node('BodyLock').position
#		scene_instance.position = Vector2(PlayerNode.position.x + distance, PlayerNode.position.y) 
#		distance += 20
#		add_child(scene_instance)
#		lastBody = scene_instance
	if first == true:
		$Player.get_node("BirthRand1Sound").play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func die():
	SoundsInd.get_node("Death").play()
	queue_free()
#	self.visible = false;
#	timer.start()
	
	
func grow():
	$Player.get_node("EatenSound").play()
	var scene_instance = BodyScene.instance()
	scene_instance.id = button
	scene_instance.color = color
	scene_instance.followBody = followBodyFull.get_node("BodyLock")
#	scene_instance.global_position = followBodyFull.get_node("BodyLock").global_position
	scene_instance.position = followBodyFull.get_node("BodyLock").position
#	scene_instance.global_position = Vector2(OS.window_size.x/2, OS.window_size.y/2)
#	scene_instance.position = Vector2(PlayerNode.position.x + distance, PlayerNode.position.y) 
#	distance += 20
	lastBody = scene_instance
	followBodyFull = lastBody
	add_child(scene_instance)
	bodyLength += 1

func _on_PlayArea_body_exited(body: Node) -> void:
	print(body)
	if body == PlayerNode:
		die()
