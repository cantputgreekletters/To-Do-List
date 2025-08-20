extends TabContainer

class_name Folder_Tab_Container

@onready var CreateButton : Button = $Folders/FolderButtonsContainer/Create
@onready var DeleteButton : Button = $Folders/FolderButtonsContainer/Delete
@onready var Folder_Container = $Folders/FolderContainer

const Folder_Maker_Instance : Resource = preload("res://Scenes/FolderCreator.tscn")

func _ready():
    CreateButton.connect("pressed", _on_press_create)
    DeleteButton.connect("pressed", _on_press_delete)
    _load_folders()


func _on_press_create() -> void:
    if Global.has_active_window: return
    var instance : Window = Folder_Maker_Instance.instantiate()
    get_node("/root").add_child(instance)
    instance.Init(self)

func _on_press_delete() -> void:
    for child : Folder_Label in Folder_Container.get_children():
        if not (child is Folder_Label): continue
        if(child.title == Global.Get_Current_Folder_Name()):
            child.Delete()

func _load_folders() -> void:
    for key in Global.GetExistingFolders():
        Generate_Folder(key)

func Generate_Folder(Name : String) -> void:
    var new_folder : Folder_Label = Folder_Label.new(Name)
    Folder_Container.add_child(new_folder)

func Add_Folder(Name : String) -> void:
    Generate_Folder(Name)
    Global.AddFolder(Name)
