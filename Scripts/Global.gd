extends Node

var has_active_window : bool = false
var _selected_description : String = ""
var ViewerWindowInstance : Resource = preload("res://Scenes/TaskViewerWindow.tscn")

signal ChangedDescription()

func Set_Selected_Description(text : String) -> void:
    _selected_description = text
    ChangedDescription.emit()

func Get_Selected_Description() -> String:
    return _selected_description

func CreateViewerWindow(Title : String, Description : String = "") -> void:
    if(has_active_window): return
    var node : Window = ViewerWindowInstance.instantiate()
    get_node("/root").add_child(node)
    node.Init(Title, Description)   
