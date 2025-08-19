extends Window

@onready var NameInput = $Container/NameInput
@onready var SubmitButton = $Container/Ok
@onready var WarningLabel : FadingLabel = $Container/Fail

const Warning_Empty_Name : String = "Name is empty!"
const Warning_Name_Taken : String = "Folder name already been used"

var folder_tab_container : Folder_Tab_Container
func _ready():
    Global.has_active_window = true
    SubmitButton.connect("pressed", _On_Press_Submit)
    

func _exit_tree() -> void:
    Global.has_active_window = false

func Init(container : Folder_Tab_Container):
    folder_tab_container = container

func _check_if_used_name() -> bool:
    var is_used : bool = NameInput.text in Global.GetExistingFolders()
    if is_used:
        WarningLabel.text = Warning_Name_Taken
    return is_used

func _check_if_empty() -> bool:
    var is_empty : bool = NameInput.text.length() == 0
    if is_empty:
        WarningLabel.text = Warning_Empty_Name
    return is_empty

func _On_Press_Submit() -> void:
    var valid : bool = not (_check_if_empty() or _check_if_used_name())
    if(not valid):
        WarningLabel.FadeIn()
    else:
        folder_tab_container.Add_Folder(NameInput.text)
        queue_free()

func _input(event: InputEvent) -> void:
    if(event is InputEventKey):
        if(event.pressed and event.keycode == KEY_ENTER):
            _On_Press_Submit()
