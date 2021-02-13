extends Control

export(int) var day
export(int) var percentage

func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://Scenes/TitleScreen.tscn")

func _on_ContinueButton_pressed():
	get_tree().change_scene("res://Scenes/SceneOne.tscn")

func _ready():
	set_progress_percentage(percentage)
	if percentage == 100:
		set_polaroid()

func set_progress_percentage(score):
	if score <= 1:
		score *= 100
	$Control/ProgressBar.value = score
	$Control/PercentageLabel.text = str(score) + "% Completed"
	if score > 100 or score < 0:
		print("set_progress_percentage recived out of range score")
	if score == 100:
		show_photo_taken()
		resize_progress_to_normal_with()
	else:
		hide_photo_taken()
		resize_progress_to_max_width()

func set_polaroid():
	$Control/image.set_texture(Global.get_current_day_image())

func hide_photo_taken():
	$Control/image.hide()
	$Control/PhotoTakenLabel.hide()
	
func show_photo_taken():
	$Control/image.show()
	$Control/PhotoTakenLabel.show()

func resize_progress_to_max_width():
	$Control/ProgressBar.anchor_right = 1
	$Control/ProgressBar.margin_right = -30
	
func resize_progress_to_normal_with():
	$Control/ProgressBar.anchor_right = .4
	$Control/ProgressBar.margin_right = 30

