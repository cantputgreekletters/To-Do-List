extends Label

class_name Folder_Label

var title : String

func _ready():
    mouse_filter = Control.MOUSE_FILTER_STOP
    horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

func _init(Name : String) -> void:
    ChangeTitle(Name)

func _gui_input(event: InputEvent) -> void:
    print(event)
    if event is InputEventMouseButton:
        #FIXME it aint working chief
        if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
            print("CLICKED FOLDER")
            Global.Set_Current_Folder(title)

func ChangeTitle(Name : String) -> void:
    title = Name
    text = Name

func Delete() -> void:
    if title == "Default": return
    Global.DeleteFolder(title)
    queue_free()