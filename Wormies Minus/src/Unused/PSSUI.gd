extends Control

var currentSelection = 0
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/Button.grab_focus()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
#
func _input(event: InputEvent) -> void:
#	if event.is_action_pressed("ui_down") and currentSelection == 7:
#		currentSelection = 0
#		$SelectionCursor.position.y = 70

#	elif event.is_action_pressed("ui_up") and currentSelection == 0:
#		currentSelection = 7
#		$SelectionCursor.position.y = 440

	if event.is_action_pressed("ui_down") and currentSelection != 7:
		currentSelection += 1
		$SelectionCursor.position.y += 50

	elif event.is_action_pressed("ui_up") and currentSelection != 0:
		currentSelection -= 1
		$SelectionCursor.position.y -= 50
#
#	print(currentSelection)


func _on_Button_pressed() -> void:
	pass # Replace with function body.


func _on_Button2_pressed() -> void:
	PlayerData.numPlayers = 2
	print(PlayerData.numPlayers)
	get_tree().change_scene("res://src/GameScene.tscn")


func _on_Button3_pressed() -> void:
	PlayerData.numPlayers = 3
	print(PlayerData.numPlayers)
	get_tree().change_scene("res://src/GameScene.tscn")


func _on_Button4_pressed() -> void:
	PlayerData.numPlayers = 4 
	print(PlayerData.numPlayers)
	get_tree().change_scene("res://src/GameScene.tscn")


func _on_Button5_pressed() -> void:
	PlayerData.numPlayers = 5
	print(PlayerData.numPlayers)
	get_tree().change_scene("res://src/GameScene.tscn")


func _on_Button6_pressed() -> void:
	PlayerData.numPlayers = 6
	print(PlayerData.numPlayers)
	get_tree().change_scene("res://src/GameScene.tscn")


func _on_Button7_pressed() -> void:
	PlayerData.numPlayers = 7
	print(PlayerData.numPlayers)
	get_tree().change_scene("res://src/GameScene.tscn")


func _on_Button8_pressed() -> void:
	PlayerData.numPlayers = 8
	print(PlayerData.numPlayers)
	get_tree().change_scene("res://src/GameScene.tscn")
