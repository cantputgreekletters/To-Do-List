extends VBoxContainer

class_name TaskContainer

@export var Create_Button : Button

const TaskInstance : Resource = preload("res://Scenes/Task.tscn")
const CreateWindowInstance : Resource = preload("res://Scenes/TaskMakerWindow.tscn")
const SAVE_PATH : String = "user://saved_data.json"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    print("HELLO WORLD")
    Create_Button.connect("pressed", OnPressCreateButton)
    print("Bye world")
    if(not FileAccess.file_exists(SAVE_PATH)):
        print("Saving file did not exist")
        var file : FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
        file.close()
        print("Making saving file")

func make_empty_task() -> void:
    #TODO for now 
    var new_task : Task = TaskInstance.instantiate()
    add_child(new_task)

func make_task(Title : String, Description : String, State : bool) -> void:
    var new_task : Task = TaskInstance.instantiate()
    new_task.create(Title, Description, State)
    add_child(new_task)

func _CreateTasks(D : Dictionary) -> void:
    for key in D.keys():
        var descr : String = D[key]["description"]
        var state : bool = D[key]["state"]
        make_task(key, descr, state)
        
func LoadTasksFromFile() -> void:
    var file : FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
    if(not file.is_open()):
        print("Could not open file when trying to load")
        return
    var contents : String = file.get_as_text()
    file.close()
    _CreateTasks(JSON.parse_string(contents))

func SaveTasksToFile() -> void:
    var D : Dictionary = {}
    for child : Task in get_children():
        if child is not Task:
            continue
        
        var d := child.ToDictionary()
        var key : String = d.keys()[0]
        D[key] = d[key]

    var file : FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    if(not file.is_open()):
        print("Could not open file when trying to save")
        return
    var contents : String = JSON.stringify(D)
    file.store_string(contents)
    file.close()   

func _MakeCreateTaskWindow() -> void:
    if(Global.has_active_window): return
    var node : Window = CreateWindowInstance.instantiate()
    get_node("/root").add_child(node)
    node.Init(self)

func OnPressCreateButton() -> void: 
    _MakeCreateTaskWindow()
