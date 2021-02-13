extends Node

export var current_day = 1
export var DEFAULT_DAY_LENGTH_IN_SECONDS = 120

var DAY_IMAGE_MAP = {
	1: preload("res://Assets/Images/Polaroids/1.jpg"),
	2: preload("res://Assets/Images/Polaroids/2.jpg"),
	3: preload("res://Assets/Images/Polaroids/3.jpg"),
	4: preload("res://Assets/Images/Polaroids/4.jpg"),
	5: preload("res://Assets/Images/Polaroids/5.png")
}

func get_current_day_image():
	return DAY_IMAGE_MAP[current_day]
