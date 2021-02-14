extends Control

func _ready():
	var p = 100*(Global.pet_meter_current_value/Global.pet_meter_max_value)
	p = min(p,100)
	set_progress_percentage(p)
	if p == 100:
		set_polaroid()
	if Global.current_day == Global.LAST_DAY:
		$Control/NextDayButton.hide()
		move_main_menu_button_to_center()

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

func move_main_menu_button_to_center():
	$Control/MainMenuButton.margin_left = 120
	$Control/MainMenuButton.margin_right = 220
	


func _on_NextDayButton_pressed():
	Global.go_to_next_day()
