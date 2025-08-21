extends Node

const DefaultFolderName : String = "Default"

const SAVE_PATH : String = "user://saved_data.json"
const SETTINGS_PATH : String = "user://settings.tres"

const SettingsClass = preload("res://Scripts/Settings_Script.gd")

var has_active_window : bool = false
var Selected_Description : String = "" :
    set(value):
        Selected_Description = value
        ChangedDescription.emit()
    get():
        return Selected_Description
var ViewerWindowInstance : Resource = preload("res://Scenes/TaskViewerWindow.tscn")

var CurrentFolder : String = DefaultFolderName:
    set(value):
        if(not tasks_dictionary.has(value)): 
            print("Tried to change to a folder that does not exist")
            return
        CurrentFolder = value
        ChangedCurrentFolder.emit()
    get():
        return CurrentFolder

var tasks_dictionary : Dictionary

var App_Settings : Settings

var main_theme : Theme = preload("res://Objects/main_theme.tres")

signal ChangedDescription()
signal ChangedCurrentFolder()
signal UpdatedFolders()
signal UpdatedTasks()
signal IsSaving()

func _ready():
    if not FileAccess.file_exists(SAVE_PATH):
        tasks_dictionary[DefaultFolderName] = {}
        SaveDictionary(tasks_dictionary, SAVE_PATH) 
    _load_tasks()
    LoadSettings()
    call_deferred("_apply_settings")

func CreateViewerWindow(Title : String, Description : String = "") -> void:
    if(has_active_window): return
    var node : Window = ViewerWindowInstance.instantiate()
    get_node("/root").add_child(node)
    node.Init(Title, Description)   

func SaveDictionary(D : Dictionary, path : String) -> void:
    var file : FileAccess = FileAccess.open(path, FileAccess.WRITE)
    if(not file.is_open()):
        print("Could not open file when trying to save")
        return
    var contents : String = JSON.stringify(D)
    file.store_string(contents)
    file.close()

#Tasks - - - - - -

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
    tasks_dictionary[CurrentFolder][Title] = {
        "description" : Description,
        "state" : State
    }
    Save()
    UpdatedTasks.emit()


func ChangeStateOfTask(task_name : String, state : bool) -> void:
    tasks_dictionary[CurrentFolder][task_name]["state"] = state
    Save()

func DeleteTask(task_name : String) -> void:
    tasks_dictionary[CurrentFolder].erase(task_name)
    Save()
    UpdatedTasks.emit()

#Folders - - - - - - 

func AddFolder(Name : String) -> void:
    tasks_dictionary[Name] = {}
    Save()
    UpdatedFolders.emit()

func DeleteFolder(Name : String) -> void:
    tasks_dictionary.erase(Name)
    Save()
    UpdatedFolders.emit()

func GetExistingFolders() -> Array:
    return tasks_dictionary.keys()

func GetExistingTasks() -> Array:
    return tasks_dictionary[CurrentFolder].keys()

#Settings - - - - - -

func LoadSettings() -> void:
    App_Settings = ResourceLoader.load(SETTINGS_PATH, "Settings") as Settings
    if(App_Settings == null):
        print_debug("Could not load settings making default")
        App_Settings = Settings.new()
        SaveSettings()
    else:
        print_debug("Loaded settings")
        print_debug(App_Settings)
    _apply_settings()
        
        
func SaveSettings() -> void:
    _apply_settings()
    IsSaving.emit()
    var re = ResourceSaver.save(App_Settings, SETTINGS_PATH)
    if(re != OK):
        print_debug("Failed to save settings")
    else:
        print_debug("Saved settings")
        

func _apply_settings() -> void:
    print_debug("applying changes")
    #Label
    main_theme.get_stylebox("normal", "Label").bg_color = Global.App_Settings.LabelBg
    main_theme.set_font_size("font_size", "Label", Global.App_Settings.FontSize)
    #RichTextlabel
    main_theme.set_font_size("bold_font_size", "RichTextLabel", Global.App_Settings.FontSize)
    main_theme.set_font_size("bold_italics_font_size", "RichTextLabel", Global.App_Settings.FontSize)
    main_theme.set_font_size("italics_font_size", "RichTextLabel", Global.App_Settings.FontSize)
    main_theme.set_font_size("mono_font_size", "RichTextLabel", Global.App_Settings.FontSize)
    main_theme.set_font_size("normal_font_size", "RichTextLabel", Global.App_Settings.FontSize)
    #Buttons
    main_theme.set_color("font_color", "Button", Global.App_Settings.ButtonFontColor)
    main_theme.get_stylebox("normal", "Button").bg_color = Global.App_Settings.ButtonBgNormalColor
    main_theme.get_stylebox("pressed", "Button").bg_color = Global.App_Settings.ButtonBgPressedColor
    main_theme.set_font_size("font_size", "Button", Global.App_Settings.FontSize)
    #Tabs
    main_theme.set_font_size("font_size", "TabBar", Global.App_Settings.FontSize)
    main_theme.set_font_size("font_size", "TabContainer", Global.App_Settings.FontSize)
    #LineEdit
    main_theme.set_font_size("font_size", "LineEdit", Global.App_Settings.FontSize)

    #Window
    main_theme.get_stylebox("embedded_border", "Window").bg_color = Global.App_Settings.WindowColor
    App_Settings.EmitChange()
