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
var specialPlayer = 0
var ai_controlled = false
var first = false
var score := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerNode.button = button
	id = button
	if not ai_controlled:
		PlayerNode.change_name(id)
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
	score_change(-score)
	var children = self.get_children()
	var index = 0
	for child in children:
		if child.is_in_group("body"):
			if index % 2 == 0:
				Globals.emit_signal("death_canister", child.global_position)
		index += 1
	Globals.emit_signal("detect_death")
	queue_free()
#	self.visible = false;
#	timer.start()
	
	
func grow():
	$Player.get_node("EatenSound").play()
	score_change(100)
	var scene_instance = BodyScene.instance()
	scene_instance.id = button
	scene_instance.color = color
	scene_instance.followBody = followBodyFull.get_node("BodySpawn")
	if scene_instance.followBody == $Player:
		$Player.next_door_neighbor = scene_instance
#	scene_instance.global_transform = followBodyFull.get_node("BodySpawn").global_transform
	scene_instance.position = followBodyFull.position
#	scene_instance.position = followBodyFull.get_node("BodyLock").position
#	scene_instance.position = followBodyFull.get_node("BodySpawn").position
#	scene_instance.position = Vector2(OS.window_size.x/2, OS.window_size.y/2)
#	scene_instance.position = Vector2(PlayerNode.position.x + distance, PlayerNode.position.y) 
#	distance += 20
	lastBody = scene_instance
	followBodyFull = lastBody
	$Player.invincible = true
	add_child(scene_instance)
	bodyLength += 1
	$InvincibilityTimer.start()

func score_change(change):
	var scoreTemp = score + change
	if scoreTemp > PlayerData.topScorerScore or PlayerData.topScorerId == id:
		PlayerData.topScorerScore = scoreTemp
		var colorTemp = Color()
		if scoreTemp == 0:
			PlayerData.topScorerId = 0
			colorTemp = ColorN("white")
		else:
			PlayerData.topScorerId = id
			colorTemp = color
		Globals.emit_signal("topScorerUpdate", scoreTemp, change, colorTemp)
	if scoreTemp > PlayerData.highScore:
		PlayerData.highScore = scoreTemp
		Globals.emit_signal("highScoreUpdate", scoreTemp, change)
		
	score = scoreTemp

func change_movement():
	if $Player.move == 1:
		$Player.move = 0
	elif $Player.move == 0:
		$Player.move = 1


func _on_PlayArea_body_exited(body: Node) -> void:
	print(body)
	if body == PlayerNode:
		die()


func _on_InvincibilityTimer_timeout():
	$Player.invincible = false
	pass # Replace with function body.
