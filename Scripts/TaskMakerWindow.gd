extends Window

@onready var TitleInput : LineEdit = $"MainContainer/TextInput Container/TitleInput"
@onready var DescrInput : TextEdit = $"MainContainer/TextInput Container/DescriptionInput"

@onready var OkButton : Button = $MainContainer/ButtonsContainer/OkButton
@onready var DiscardButton : Button = $MainContainer/ButtonsContainer/DiscardButton

@onready var FailLabel : Label = $"MainContainer/TextInput Container/FailLabel"

var task_container : TaskContainer

func _ready():
    Global.has_active_window = true
    if (FailLabel.is_visible_in_tree()):
        FailLabel.visible = false

    OkButton.connect("pressed", _OnOkPress)
    DiscardButton.connect("pressed", _OnDiscardPress)

func _exit_tree() -> void:
    Global.has_active_window = false

func Init(Task_Container : TaskContainer) -> void:
    if(task_container == null):
        print("task_container was not provided")
    task_container = Task_Container
    connect("close_requested", _OnDiscardPress)

func _fade_in_FailLabel() -> void:
    pass

func _check_if_valid_form() -> bool:
    return TitleInput.text.length() > 0

func SendDataToTaskContainer() -> void:
    var Title : String = TitleInput.text
    var Description : String = DescrInput.text
    task_container.make_task(Title, Description, false)

func _OnOkPress() -> void:
    var valid : bool = _check_if_valid_form()
    if(valid):
        SendDataToTaskContainer()
        queue_free()
    else:
        _fade_in_FailLabel()

func _OnDiscardPress() -> void:
    queue_free()

func _input(event: InputEvent) -> void:
    if(event is InputEventKey):
        if(event.pressed and event.keycode == KEY_ENTER):
            _OnOkPress()
            
#TODO add enter key functionality
