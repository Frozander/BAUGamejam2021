extends Control

signal continue_pressed
signal main_menu_pressed

func _ready():
	set_progress_percentage(75)
	$Control/ContinueButton.connect("pressed", self, "on_continue")
	$Control/MainMenuButton.connect("pressed", self, "on_main_menu")
	
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
	
func on_continue():
	emit_signal("continue_pressed")

func on_main_menu():
	emit_signal("main_menu_pressed")

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
