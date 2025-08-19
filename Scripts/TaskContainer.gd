extends VBoxContainer

class_name TaskContainer

@export var Create_Button : Button
@export var Save_Button : Button
@export var Save_Indicator : FadingLabel

const TaskInstance : Resource = preload("res://Scenes/Task.tscn")
const CreateWindowInstance : Resource = preload("res://Scenes/TaskMakerWindow.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    Create_Button.connect("pressed", OnPressCreateButton)
    Save_Button.connect("pressed", OnPressSaveButton)
    _LoadTasks(Global.DefaultFolderName)
    Global.connect("ChangedCurrentFolder", _On_Change_Folder)
    Global.connect("IsSaving", Save_Indicator.FadeIn)
    
"""
func make_empty_task() -> void: 
    var new_task : Task = TaskInstance.instantiate()
    add_child(new_task)
"""

func generate_task(Title : String, Description : String, State : bool) -> void:
    var new_task : Task = TaskInstance.instantiate()
    new_task.create(Title, Description, State)
    add_child(new_task)

func make_new_task(Title : String, Description : String, State : bool) -> void:
    var new_task : Task = TaskInstance.instantiate()
    new_task.create_and_save(Title, Description, State)
    add_child(new_task)

func _UnloadCurrentTasks() -> void:
    for child : Task in get_children():
        child.queue_free()

func _LoadTasks(folder_name : String) -> void:
    for key in Global.tasks_dictionary[folder_name]:
        var descr : String = Global.tasks_dictionary[folder_name][key]["description"]
        var state : bool = Global.tasks_dictionary[folder_name][key]["state"]
        generate_task(key, descr, state)

func GetUsedTaskTitles() -> Array[String]:
    var titles : Array[String] = []
    for child : Task in get_children():
        if(child is not Task): continue
        titles.append(child.title)
    return titles


func _MakeCreateTaskWindow() -> void:
    if(Global.has_active_window): return
    var node : Window = CreateWindowInstance.instantiate()
    get_node("/root").add_child(node)
    node.Init(self)

func OnPressCreateButton() -> void: 
    _MakeCreateTaskWindow()

func OnPressSaveButton() -> void:
    Global.Save()

func _On_Change_Folder() -> void:
    _UnloadCurrentTasks()
    _LoadTasks(Global.Get_Current_Folder_Name())

#add ctrl + s saving
