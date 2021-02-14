extends Sprite

export var next_scene = "res://Scenes/DayEnd.tscn"

func _enter_tree():
	$AnimationPlayer.play("fade_in")
	$AudioStreamPlayer.play()



func _on_AudioStreamPlayer_finished():
	get_tree().change_scene(next_scene)
