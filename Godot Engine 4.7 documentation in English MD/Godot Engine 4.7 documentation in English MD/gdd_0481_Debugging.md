# Debugging

This section contains pages that provide guidance if you're looking at the
engine code trying to find an underlying issue or an optimization possibility.

- Using sanitizers
- Debugging on macOS
- Vulkan

## Debugging the editor

When working on the Godot editor keep in mind that by default the executable
will start in the Project Manager mode. Opening a project from the Project
Manager spawns a new process, which stops the debugging session. To avoid that
you should launch directly into the project using -e and --path launch
options.

For example, using gdb directly, you may do this:

```
gdb godot
> run -e --path ~/myproject
```

You can also run the editor directly from your project's folder. In that case,
only the -e option is required.

```
cd ~/myproject
gdb godot
> run -e
```

You can learn more about these launch options and other command line arguments
in the command line tutorial.

If you're using a code editor or an IDE to debug Godot, check out our
configuration guides, which cover the setup
process for building and debugging with your particular editor.
