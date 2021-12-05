extends Node

var event = "none"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	event = "feedingtime"
	$GameScene.feeding_time(randi() % 24, event)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_EventTimer_timeout():
	random_event()
	pass # Replace with function body.


func game_start():
	$EventTimer.start()
	print("Events started!")

func random_event():
	var rand = randf()
	if rand < 0.5:
		event = "breedingfrenzy"
		$Chirps/breedingfrenzy.play()
		$GameScene.breeding_frenzy(randi() % 20, event)
		return
	elif rand > 0.5:
		event = "feedingtime"
		$Chirps/feedingtime.play()
		$GameScene.feeding_time(randi() % 28, event)


func _on_EventDuration_timeout():
	event = "none"
	pass # Replace with function body.
