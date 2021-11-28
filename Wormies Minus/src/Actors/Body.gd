extends KinematicBody2D

onready var PlayerScene = get_node('/root/PlayerFull/Player')
onready var speed = 100
var followBody
var color
var id = 1
#onready var playerLock = get_node("/root/PlayerFull/Player/PlayerLock")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var BodySprite = $BodySprite
	BodySprite.self_modulate = color
#	speed = PlayerScene.speed
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	var direction = ((followBody.get_global_position()) - self.get_global_position()).normalized()
#	rotation = followBody.rotation
#	var motion = direction * speed * delta
#	position += motion
	var motion = move_and_slide(direction * speed)
