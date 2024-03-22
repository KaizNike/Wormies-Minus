extends Node2D

var Event = "none"
var players = []
var player = {"scancode": 0, "node": Node2D}
var ais = []
var playersNum = 0
var canistersNum = 0
export (PackedScene) var PlayerScene
export (PackedScene) var CanisterScene
onready var pc = self.get_node("PlayerController")
export var spawner_disabled := false
var area_last
export var point_to_move_to = Vector2.ZERO

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
	var removeIndx = null
	if event is InputEventKey:
		var count = 0
		for worm in players:
			if worm.scancode == event.scancode:
				if has_node(worm.node):
					return
				else:
					removeIndx = count
			count += 1
				
		if spawner_disabled:
			return
		
		if removeIndx:
			players.remove(removeIndx)
#		players.append(event.scancode)
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
		var new_worm = player.duplicate(true)
		new_worm.scancode = event.scancode
		new_worm.node = scene_instance.get_path()
		players.append(new_worm)
		print(event.scancode)
		print(players)
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
		var found_point = false
		for part in result:
			if part.collider == $SpawnArea:
				found_point = true
#			if part.collider.is_in_group("spawnprev"):
#				$SpawnLantern.visible = false
#				spawner_disabled = true
#				$SpawnLanternTimer.start()
#				return
		if found_point:
			print("PULL Spawner")
#			$SpawnLantern.position = point
			point_to_move_to = point
#			$SpawnLantern.visible = true
			$SpawnLantern/SpawnAnimator.play("fadeout")
			lightPlaced = true
	pass

func change_point():
	$SpawnLantern.position = point_to_move_to

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
	spawner_disabled = false
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
			pass
#			print("FULL!")
#			print(point)
#		placed = false
	pass # Replace with function body.
	
func wormy_died():
	playersNum -= 1


func _on_SpawnLaternTimer_timeout():
	$SpawnLantern.visible = true
	spawner_disabled = false
	change_spawn_loc()
	pass # Replace with function body..


func _on_P1Button_pressed():
	var removeIndx = null
	var count = 0
	for worm in players:
		if worm.scancode == -1:
			if has_node(worm.node):
				get_node(worm.node).change_movement()
				return
			else:
				removeIndx = count
		count += 1
			
	if spawner_disabled:
		return
	
	if removeIndx:
		players.remove(removeIndx)
#		players.append(event.scancode)
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
	scene_instance.button = null
	scene_instance.specialPlayer = -1
	scene_instance.get_node("Player").color = Color("#ff2a00")
	$PlayArea.connect("body_exited", scene_instance, "_on_PlayArea_body_exited")
	
	add_child(scene_instance)
	spawn_rand(scene_instance)
	var new_worm = player.duplicate(true)
	new_worm.scancode = -1
	new_worm.node = scene_instance.get_path()
	players.append(new_worm)
	print(-1)
	print(players)


func _on_P2Button_pressed():
	var removeIndx = null
	var count = 0
	for worm in players:
		if worm.scancode == -2:
			if has_node(worm.node):
				get_node(worm.node).change_movement()
				return
			else:
				removeIndx = count
		count += 1
			
	if spawner_disabled:
		return
	
	if removeIndx:
		players.remove(removeIndx)
#		players.append(event.scancode)
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
	scene_instance.button = null
	scene_instance.specialPlayer = -2
	scene_instance.get_node("Player").color = Color("#00ff2e")
	$PlayArea.connect("body_exited", scene_instance, "_on_PlayArea_body_exited")
	
	add_child(scene_instance)
	spawn_rand(scene_instance)
	var new_worm = player.duplicate(true)
	new_worm.scancode = -2
	new_worm.node = scene_instance.get_path()
	players.append(new_worm)
	print(-2)
	print(players)
	pass # Replace with function body.


func _on_P3Button_pressed():
	var removeIndx = null
	var count = 0
	for worm in players:
		if worm.scancode == -3:
			if has_node(worm.node):
				get_node(worm.node).change_movement()
				return
			else:
				removeIndx = count
		count += 1
			
	if spawner_disabled:
		return
	
	if removeIndx:
		players.remove(removeIndx)
#		players.append(event.scancode)
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
	scene_instance.button = null
	scene_instance.specialPlayer = -3
	scene_instance.get_node("Player").color = Color("#1400ff")
	$PlayArea.connect("body_exited", scene_instance, "_on_PlayArea_body_exited")
	
	add_child(scene_instance)
	spawn_rand(scene_instance)
	var new_worm = player.duplicate(true)
	new_worm.scancode = -3
	new_worm.node = scene_instance.get_path()
	players.append(new_worm)
	print(-3)
	print(players)


func _on_P4Button_pressed():
	var removeIndx = null
	var count = 0
	for worm in players:
		if worm.scancode == -4:
			if has_node(worm.node):
				get_node(worm.node).change_movement()
				return
			else:
				removeIndx = count
		count += 1
			
	if spawner_disabled:
		return
	
	if removeIndx:
		players.remove(removeIndx)
#		players.append(event.scancode)
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
	scene_instance.button = null
	scene_instance.specialPlayer = -4
	scene_instance.get_node("Player").color = Color("#161700")
	$PlayArea.connect("body_exited", scene_instance, "_on_PlayArea_body_exited")
	
	add_child(scene_instance)
	spawn_rand(scene_instance)
	var new_worm = player.duplicate(true)
	new_worm.scancode = -4
	new_worm.node = scene_instance.get_path()
	players.append(new_worm)
	print(-4)
	print(players)
