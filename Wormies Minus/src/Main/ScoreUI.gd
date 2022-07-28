extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Reset")
	Globals.connect("highScoreUpdate", self, "highScoreUpdate")
	Globals.connect("topScorerUpdate", self, "bestPlayerUpdate")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func highScoreUpdate(score, diff):
	$HighScoreChange.text = str(diff)
	$AnimationPlayer.play("HighScoreUpdate")
	$CenterContainer/PanelContainer/VSplitContainer/HighScore.text = "High Score:  " + str(score)
	
	
func bestPlayerUpdate(score, diff, color):
	$BestPlayerChange.text = str(diff)
	$CenterContainer/PanelContainer/VSplitContainer/BestPlayerScore.text = "Best Player: " + str(score)
	$CenterContainer/PanelContainer/VSplitContainer/BestPlayerScore.modulate = color
	$AnimationPlayer2.play("BestPlayerUpdate")
	pass
