extends ColorRect

func _ready():
    Global.App_Settings.connect("OnChange", _apply_color)

func _apply_color() -> void:
    print_debug("Changing background color")
    color = Global.App_Settings.BackGroundColor
