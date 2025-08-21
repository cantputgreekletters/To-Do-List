extends Button

var customize_window : PackedScene = preload("res://Scenes/CustomizeWindow.tscn")

func _pressed() -> void:
    var node : Window = customize_window.instantiate()
    get_node("/root").add_child(node)
