extends Area2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_GrowthCanister_body_entered(body: Node) -> void:
	if body.is_in_group("players"):
		body.get_parent().grow()
		picked(body)
	pass # Replace with function body.


func picked(bod):
	get_parent().remove_canister()
	queue_free()
	pass
