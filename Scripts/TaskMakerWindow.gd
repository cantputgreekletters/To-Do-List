extends Window

@onready var TitleInput : LineEdit = $"MainContainer/TextInput Container/TitleInput"
@onready var DescrInput : TextEdit = $"MainContainer/TextInput Container/DescriptionInput"

@onready var OkButton : Button = $MainContainer/ButtonsContainer/OkButton
@onready var DiscardButton : Button = $MainContainer/ButtonsContainer/DiscardButton

@onready var FailLabel : FadingLabel = $"MainContainer/TextInput Container/FailLabel"

const Warning_Empty_Title : String = "Title was not filled!"
const Warning_Already_Using_Title : String = "Title name already been used!"


func _ready():
    Global.has_active_window = true
    OkButton.connect("pressed", _OnOkPress)
    DiscardButton.connect("pressed", _OnDiscardPress)
    connect("close_requested", _OnDiscardPress)
    
func _exit_tree() -> void:
    Global.has_active_window = false


func _check_if_filled_title() -> bool:
    var valid : bool = TitleInput.text.length() > 0
    if(not valid):
        FailLabel.text = Warning_Empty_Title
    return valid

func _check_if_valid_title() -> bool:
    var valid : bool = not Global.GetExistingTasks().has(TitleInput.text)
    if(not valid):
        FailLabel.text = Warning_Already_Using_Title
    return valid

func _OnOkPress() -> void:
    var valid : bool = _check_if_filled_title() and _check_if_valid_title()
    if(valid):
        Global.AddTaskToDictionary(TitleInput.text, DescrInput.text, false)
        queue_free()
    else:
        FailLabel.FadeIn()

func _OnDiscardPress() -> void:
    queue_free()

func _input(event: InputEvent) -> void:
    if(event is InputEventKey):
        if(event.pressed and event.keycode == KEY_ENTER):
            _OnOkPress()
