# Heads up display

The final piece our game needs is a User Interface (UI) to display things like
score, a "game over" message, and a restart button.

Create a new scene, click the "Other Node" button and add a CanvasLayer node named
HUD. "HUD" stands for "heads-up display", an informational display that
appears as an overlay on top of the game view.

The CanvasLayer node lets us draw our UI elements on
a layer above the rest of the game, so that the information it displays isn't
covered up by any game elements like the player or mobs.

The HUD needs to display the following information:

- Score, changed by ScoreTimer.
- A message, such as "Game Over" or "Get Ready!"
- A "Start" button to begin the game.

The basic node for UI elements is Control. To create our
UI, we'll use two types of Control nodes: Label and Button.

Create the following as children of the HUD node:

- Label named ScoreLabel.
- Label named Message.
- Button named StartButton.
- Timer named MessageTimer.

Click on the ScoreLabel and type a number into the Text field in the
Inspector. The default font for Control nodes is small and doesn't scale
well. There is a font file included in the game assets called
"Xolonium-Regular.ttf". To use this font, do the following:

Under "Theme Overrides > Fonts", choose "Load" and select the "Xolonium-Regular.ttf" file.

![../../_images/custom_font_load_font.png](../../_images/custom_font_load_font.png)

The font size is still too small, increase it to 64 under "Theme Overrides > Font Sizes".
Once you've done this with the ScoreLabel, repeat the changes for the Message and StartButton nodes.

![../../_images/custom_font_size.png](../../_images/custom_font_size.png)

Note

Anchors: Control nodes have a position and size,
but they also have anchors. Anchors define the origin -
the reference point for the edges of the node.

Arrange the nodes as shown below.
You can drag the nodes to place them manually, or for more precise placement,
use "Anchor Presets".

![../../_images/ui_anchor.png](../../_images/ui_anchor.png)

## ScoreLabel

1. Add the text 0.
2. Set the "Horizontal Alignment" and "Vertical Alignment" to Center.
3. Choose the "Anchor Preset" Center Top.

## Message

1. Add the text Dodge the Creeps!.
2. Set the "Horizontal Alignment" and "Vertical Alignment" to Center.
3. Set the "Autowrap Mode" to Word, otherwise the label will stay on one line.
4. Under "Control - Layout/Transform" set "Size X"  to 480 to use the entire width of the screen.
5. Choose the "Anchor Preset" Center.

## StartButton

1. Add the text Start.
2. Under "Control - Layout/Transform", set "Size X" to 200 and "Size Y" to 100
to add a little bit more padding between the border and text.
3. Choose the "Anchor Preset" Center Bottom.
4. Under "Control - Layout/Transform", set "Position Y" to 580.

On the MessageTimer, set the Wait Time to 2 and set the One Shot
property to "On".

Now add this script to HUD:

```
extends CanvasLayer
# Notifies `Main` node that the button has been pressed
signal start_game
```

```
using Godot;
public partial class HUD : CanvasLayer
{
    // Don't forget to rebuild the project so the editor knows about the new signal.
    [Signal]
    public delegate void StartGameEventHandler();
}
```

We now want to display a message temporarily,
such as "Get Ready", so we add the following code

```
func show_message(text):
    $Message.text = text
    $Message.show()
    $MessageTimer.start()
```

```
public void ShowMessage(string text)
{
    var message = GetNode("Message");
    message.Text = text;
    message.Show();
    GetNode("MessageTimer").Start();
}
```

We also need to process what happens when the player loses. The code below will show "Game Over" for 2 seconds, then return to the title screen and, after a brief pause, show the "Start" button.

```
func show_game_over():
    show_message("Game Over")
    # Wait until the MessageTimer has counted down.
    await $MessageTimer.timeout
    $Message.text = "Dodge the Creeps!"
    $Message.show()
    # Make a one-shot timer and wait for it to finish.
    await get_tree().create_timer(1.0).timeout
    $StartButton.show()
```

```
async public void ShowGameOver()
{
    ShowMessage("Game Over");
    var messageTimer = GetNode("MessageTimer");
    await ToSignal(messageTimer, Timer.SignalName.Timeout);
    var message = GetNode("Message");
    message.Text = "Dodge the Creeps!";
    message.Show();
    await ToSignal(GetTree().CreateTimer(1.0), SceneTreeTimer.SignalName.Timeout);
    GetNode("StartButton").Show();
}
```

Note

When you need to pause for a brief time, an alternative to using a
Timer node is to use the SceneTree's create_timer() function. This
can be very useful to add delays such as in the above code, where we
want to wait some time before showing the "Start" button.

Add the code below to HUD to update the score

```
func update_score(score):
    $ScoreLabel.text = str(score)
```

```
public void UpdateScore(int score)
{
    GetNode("ScoreLabel").Text = score.ToString();
}
```

Connect the pressed() signal of StartButton and the timeout()
signal of MessageTimer to the HUD node, and add the following code to the new functions:

```
func _on_start_button_pressed():
    $StartButton.hide()
    start_game.emit()
func _on_message_timer_timeout():
    $Message.hide()
```

```
// We also specified this function name in PascalCase in the editor's connection window.
private void OnStartButtonPressed()
{
    GetNode("StartButton").Hide();
    EmitSignal(SignalName.StartGame);
}
// We also specified this function name in PascalCase in the editor's connection window.
private void OnMessageTimerTimeout()
{
    GetNode("Message").Hide();
}
```

## Connecting HUD to Main

Now that we're done creating the HUD scene, go back to Main. Instance
the HUD scene in Main like you did the Player scene. The scene tree
should look like this, so make sure you didn't miss anything:

![../../_images/completed_main_scene.png](../../_images/completed_main_scene.png)

Now we need to connect the HUD functionality to our Main script. This
requires a few additions to the Main scene:

In the Signals tab, connect the HUD's start_game signal to the new_game()
function of the Main node by clicking the "Pick" button in the "Connect a Signal"
window and selecting the new_game() method or type "new_game" below "Receiver Method"
in the window. Verify that the green connection icon now appears next to
func new_game() in the script.

In new_game(), update the score display and show the "Get Ready" message:

```
$HUD.update_score(score)
$HUD.show_message("Get Ready")
```

```
var hud = GetNode("HUD");
hud.UpdateScore(_score);
hud.ShowMessage("Get Ready!");
```

In game_over() we need to call the corresponding HUD function:

```
$HUD.show_game_over()
```

```
GetNode("HUD").ShowGameOver();
```

Finally, add this to _on_score_timer_timeout() to keep the display in sync
with the changing score:

```
$HUD.update_score(score)
```

```
GetNode("HUD").UpdateScore(_score);
```

Warning

Remember to remove the call to new_game() from
_ready() if you haven't already, otherwise
your game will start automatically.

Now you're ready to play! Click the "Play the Project" button.

## Removing old creeps

If you play until "Game Over" and then start a new game right away, the creeps
from the previous game may still be on the screen. It would be better if they
all disappeared at the start of a new game. We just need a way to tell all the
mobs to remove themselves. We can do this with the "group" feature.

In the Mob scene, select the root node and click the Groups tab next to the
Signals tab and the "+" button to open the "Create New Group" dialog.

![../../_images/group_tab.png](../../_images/group_tab.png)

Name the group mobs and click "ok" to add a new scene group.

![../../_images/add_group_dialog.png](../../_images/add_group_dialog.png)

Now all mobs will be in the "mobs" group.

![../../_images/scene_group_mobs.png](../../_images/scene_group_mobs.png)

We can then add the following line to the new_game() function in Main:

```
get_tree().call_group("mobs", "queue_free")
```

```
// Note that for calling Godot-provided methods with strings,
// we have to use the original Godot snake_case name.
GetTree().CallGroup("mobs", Node.MethodName.QueueFree);
```

The call_group() function calls the named function on every node in a
group - in this case we are telling every mob to delete itself.

The game's mostly done at this point. In the next and last part, we'll polish it
a bit by adding a background, looping music, and some keyboard shortcuts.
