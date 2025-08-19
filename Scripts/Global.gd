extends Node

const DefaultFolderName : String = "Default"

const SAVE_PATH : String = "user://saved_data.json"
const SETTINGS_PATH : String = "user://settings.json"

var has_active_window : bool = false
var _selected_description : String = ""
var ViewerWindowInstance : Resource = preload("res://Scenes/TaskViewerWindow.tscn")

var _CurrentFolder : String = DefaultFolderName

var tasks_dictionary : Dictionary

signal ChangedDescription()
signal ChangedCurrentFolder()
signal IsSaving()

func _ready():
    _CheckIfNecessaryFilesExist(SAVE_PATH)
    _CheckIfNecessaryFilesExist(SETTINGS_PATH)
    _load_tasks()

func Set_Selected_Description(text : String) -> void:
    _selected_description = text
    ChangedDescription.emit()
    

func Set_Current_Folder(folder_name : String) -> void:
    if(not tasks_dictionary.has(folder_name)): 
        print("Tried to change to a folder that does not exist")
        return
    _CurrentFolder = folder_name
    ChangedCurrentFolder.emit()

func Get_Current_Folder_Name() -> String:
    return _CurrentFolder

func Get_Selected_Description() -> String:
    return _selected_description

func CreateViewerWindow(Title : String, Description : String = "") -> void:
    if(has_active_window): return
    var node : Window = ViewerWindowInstance.instantiate()
    get_node("/root").add_child(node)
    node.Init(Title, Description)   

func _CheckIfNecessaryFilesExist(path : String) -> void:
    if(not FileAccess.file_exists(path)):
        print(path % "File %s did not exist.")
        var file : FileAccess = FileAccess.open(path, FileAccess.WRITE)
        file.close()
        print(path % "Making %s")

func SaveDictionary(D : Dictionary, path : String) -> void:
    var file : FileAccess = FileAccess.open(path, FileAccess.WRITE)
    if(not file.is_open()):
        print("Could not open file when trying to save")
        return
    var contents : String = JSON.stringify(D)
    file.store_string(contents)
    file.close()

func Save() -> void:
    SaveDictionary(tasks_dictionary, SAVE_PATH)
    IsSaving.emit()

func _load_tasks() -> void:
    var file : FileAccess = FileAccess.open(Global.SAVE_PATH, FileAccess.READ)
    if(not file.is_open()):
        print("Could not open file when trying to load")
        return
    var contents : String = file.get_as_text()
    file.close()
    var result : Variant = JSON.parse_string(contents)
    if(result == null):
        tasks_dictionary[DefaultFolderName] = {}
    else:
        tasks_dictionary = result
    if(not tasks_dictionary.has(DefaultFolderName)):
        tasks_dictionary[DefaultFolderName] = {}

func AddTaskToDictionary(Title : String, Description : String, State : bool) ->void:
    IsSaving.emit()
    tasks_dictionary[_CurrentFolder][Title] = {
        "description" : Description,
        "state" : State
    }

func ChangeStateOfTask(task_name : String, state : bool) -> void:
    IsSaving.emit()
    tasks_dictionary[_CurrentFolder][task_name]["state"] = state

func DeleteTask(task_name : String) -> void:
    IsSaving.emit()
    tasks_dictionary[_CurrentFolder].erase(task_name)

func AddFolder(Name : String) -> void:
    IsSaving.emit()
    tasks_dictionary[Name] = {}

func DeleteFolder(Name : String) -> void:
    IsSaving.emit()
    tasks_dictionary.erase(Name)

func GetExistingFolders() -> Array:
    return tasks_dictionary.keys()
