extends ColorRect

export var next_scene = "res://Scenes/DayEnd.tscn"

func _enter_tree():
	$AnimationPlayer.play("fade_in")



func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene(next_scene)
