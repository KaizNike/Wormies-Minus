extends Node2D

var Event = "none"
var players = []
var ais = []
var playersNum = 0
var canistersNum = 0
export (PackedScene) var PlayerScene
export (PackedScene) var CanisterScene
onready var pc = self.get_node("PlayerController")
var spawner_disabled = false
var area_last

var placed = false
var lightPlaced = false
var first = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.connect("death_canister",self,"spawn_canister")
	Globals.connect("detect_death",self,"wormy_died")
#	print(OS.window_size)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		for code in players:
			if code == event.scancode:
				return
				
		if spawner_disabled:
			return
		
		players.append(event.scancode)
		var scene_instance = PlayerScene.instance()
		if first == false:
			first = true
			get_parent().game_start()
			$AudioStreamPlayer.play()
			get_parent().get_node("UI").visible = false
#			$Control.visible = false
			scene_instance.first = true
		playersNum += 1
#		scene_instance.position = OS.get_window_size() / 2
#		scene_instance.position = $SpawnLocation.position
		scene_instance.position = $SpawnLantern.position
		scene_instance.button = event.scancode
		$PlayArea.connect("body_exited", scene_instance, "_on_PlayArea_body_exited")
		add_child(scene_instance)
		spawn_rand(scene_instance)
		print(event.scancode)
	if event.is_action_pressed("spawn_enemy"):
		spawn_ai()

func spawn_canister(pos:Vector2):
	var scene_instance = CanisterScene.instance()
	scene_instance.position = pos
	canistersNum += 1
	add_child(scene_instance)
	pass
	
func remove_canister():
	canistersNum -= 1


func change_spawn_loc():
	lightPlaced = false
	while (lightPlaced == false):
		var point = Vector2(rand_range(0,OS.window_size.x),
		rand_range(0,OS.window_size.y))
#		point = Vector2(400,220)
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_point(point, 32, [], 1, true, true)
#		print(result)
		for part in result:
			if part.collider == $SpawnArea:
				print("PULL")
				$SpawnLantern.position = point
				lightPlaced = true
	pass

func _on_SpawnLanternTimer_timeout():
	change_spawn_loc()
	pass # Replace with function body.


func _on_SpawnAiTimer_timeout():
#	if playersNum > 0:
#		spawn_ai()
#		pass
	spawn_ai()
	pass # Replace with function body.


func _on_SpawnPrevention_area_entered(area):
	if area.is_in_group("spawnprev"):
		change_spawn_loc()
#		print(area)
#		spawner_disabled = true
#		area_last = area
	pass # Replace with function body.


func _on_SpawnPrevention_area_exited(area):
#	if area == area_last:
#		spawner_disabled = false
	pass # Replace with function body.

func spawn_rand(scene):
	var test = randf()
	if test < 0.1:
		scene.first = true

func spawn_ai():
	if spawner_disabled:
		return
	if playersNum > 48:
		return
			
	var finished = false
	var AIid = 0
	while !finished:
		AIid = randi()
		for code in ais:
			if code == AIid:
				return
		ais.append(AIid)
		finished = true
	var scene_instance = PlayerScene.instance()
	playersNum += 1
#	scene_instance.position = OS.get_window_size() / 2
#	scene_instance.position = $SpawnLocation.position
	scene_instance.position = $SpawnLantern.position
	scene_instance.ai_controlled = true
	print("SPAWNED: " + str(AIid))
	scene_instance.button = AIid
	$PlayArea.connect("body_exited", scene_instance, "_on_PlayArea_body_exited")
	add_child(scene_instance)
	spawn_rand(scene_instance)
	
func breeding_frenzy(duration, event):
	$SpawnAiTimer.stop()
	$SpawnAiTimer.wait_time = 0.2
	$SpawnAiTimer.start()
	Event = event
	$EventDuration.wait_time = duration
	$EventDuration.start()
#	yield(get_tree().create_timer(duration),"timeout")
#	$SpawnAiTimer.wait_time = 15

func feeding_time(duration, event):
	$GrowthCanTimer.stop()
	$GrowthCanTimer.wait_time = 0.01
	$GrowthCanTimer.start()
	Event = event
	$EventDuration.wait_time = duration
	$EventDuration.start()

func _on_EventDuration_timeout():
	if Event == "breedingfrenzy":
		$SpawnAiTimer.stop()
		$SpawnAiTimer.wait_time = 15
		$SpawnAiTimer.start()
	elif Event == "feedingtime":
		$GrowthCanTimer.stop()
		$GrowthCanTimer.wait_time = 7.5
		$GrowthCanTimer.start()
	pass # Replace with function body.


func _on_GrowthCanTimer_timeout():	
	placed = false
	if placed == false:
		if canistersNum < 64:
#			placed = true
			var point = Vector2(rand_range(0,OS.window_size.x),
			rand_range(0,OS.window_size.y))
	#		point = Vector2(400,220)
			var space_state = get_world_2d().direct_space_state
			var result = space_state.intersect_point(point, 2, [], 1, true, true)
	#		print(result)
			for part in result:
				if part.collider == $SpawnArea:
					print("PUSH")
					spawn_canister(point)
					print(canistersNum)
					placed = true
		else:
			print("FULL!")
#			print(point)
#		placed = false
	pass # Replace with function body.
	
func wormy_died():
	playersNum -= 1
