# HTML5 shell class reference

Projects exported for the Web expose the Engine() class to the JavaScript environment, that allows
fine control over the engine's start-up process.

This API is built in an asynchronous manner and requires basic understanding
of Promises [https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Using_promises].

## Engine

The Engine class provides methods for loading and starting exported projects on the Web. For default export
settings, this is already part of the exported HTML page. To understand practical use of the Engine class,
see Custom HTML page for Web export.

### Static Methods

Promise | load ( string basePath )
void | unload ( )
boolean | isWebGLAvailable ( [ number majorVersion=1 ] )

### Instance Methods

Promise | init ( [ string basePath ] )
Promise | preloadFile ( string|ArrayBuffer file [, string path ] )
Promise | start ( EngineConfig override )
Promise | startGame ( EngineConfig override )
void | copyToFS ( string path, ArrayBuffer buffer )
void | requestQuit ( )

**class Engine(initConfig)**
  Create a new Engine instance with the given configuration.

  Arguments:

  initConfig (EngineConfig()) -- The initial config for this instance.

  Static Methods

  Engine.load(basePath)
  Load the engine from the specified base path.

  Arguments:

  basePath (string()) -- Base path of the engine to load.

  Returns:
  A Promise that resolves once the engine is loaded.

  Return type:
  Promise

  Engine.unload()
  Unload the engine to free memory.
  This method will be called automatically depending on the configuration. See unloadAfterInit.

  Engine.isWebGLAvailable([majorVersion=1])
  Check whether WebGL is available. Optionally, specify a particular version of WebGL to check for.

  Arguments:

  majorVersion (number()) -- The major WebGL version to check for.

  Returns:
  If the given major version of WebGL is available.

  Return type:
  boolean

  Instance Methods

  Engine.prototype.init([basePath])
  Initialize the engine instance. Optionally, pass the base path to the engine to load it,
  if it hasn't been loaded yet. See Engine.load().

  Arguments:

  basePath (string()) -- Base path of the engine to load.

  Returns:
  A Promise that resolves once the engine is loaded and initialized.

  Return type:
  Promise

  Engine.prototype.preloadFile(file[, path])
  Load a file so it is available in the instance's file system once it runs. Must be called before starting the
  instance.
  If not provided, the path is derived from the URL of the loaded file.

  Arguments:

  file (string|ArrayBuffer()) -- The file to preload.
  If a string the file will be loaded from that path.
  If an ArrayBuffer or a view on one, the buffer will used as the content of the file.

  path (string()) -- Path by which the file will be accessible. Required, if file is not a string.

  Returns:
  A Promise that resolves once the file is loaded.

  Return type:
  Promise

  Engine.prototype.start(override)
  Start the engine instance using the given override configuration (if any).
  startGame can be used in typical cases instead.
  This will initialize the instance if it is not initialized. For manual initialization, see init.
  The engine must be loaded beforehand.
  Fails if a canvas cannot be found on the page, or not specified in the configuration.

  Arguments:

  override (EngineConfig()) -- An optional configuration override.

  Returns:
  Promise that resolves once the engine started.

  Return type:
  Promise

  Engine.prototype.startGame(override)
  Start the game instance using the given configuration override (if any).
  This will initialize the instance if it is not initialized. For manual initialization, see init.
  This will load the engine if it is not loaded, and preload the main pck.
  This method expects the initial config (or the override) to have both the executable and mainPack
  properties set (normally done by the editor during export).

  Arguments:

  override (EngineConfig()) -- An optional configuration override.

  Returns:
  Promise that resolves once the game started.

  Return type:
  Promise

  Engine.prototype.copyToFS(path, buffer)
  Create a file at the specified path with the passed as buffer in the instance's file system.

  Arguments:

  path (string()) -- The location where the file will be created.
  buffer (ArrayBuffer()) -- The content of the file.

  Engine.prototype.requestQuit()
  Request that the current instance quit.
  This is akin the user pressing the close button in the window manager, and will
  have no effect if the engine has crashed, or is stuck in a loop.

## Engine configuration

An object used to configure the Engine instance based on godot export options, and to override those in custom HTML
templates if needed.

### Properties

type | name
boolean | unloadAfterInit
HTMLCanvasElement | canvas
string | executable
string | mainPack
string | locale
number | canvasResizePolicy
Array. | args
function | onExecute
function | onExit
function | onProgress
function | onPrint
function | onPrintError

**EngineConfig**
  The Engine configuration object. This is just a typedef, create it like a regular object, e.g.:
  const MyConfig = { executable: 'godot', unloadAfterInit: false }
  Property Descriptions

  unloadAfterInit
  Whether the unload the engine automatically after the instance is initialized.

  Type:
  boolean

  Value:
  true

  canvas
  The HTML DOM Canvas object to use.
  By default, the first canvas element in the document will be used is none is specified.

  Type:
  HTMLCanvasElement

  Value:
  null

  executable
  The name of the WASM file without the extension. (Set by Godot Editor export process).

  Type:
  string

  Value:
  ""

  mainPack
  An alternative name for the game pck to load. The executable name is used otherwise.

  Type:
  string

  Value:
  null

  locale
  Specify a language code to select the proper localization for the game.
  The browser locale will be used if none is specified. See complete list of
  supported locales.

  Type:
  string

  Value:
  null

  canvasResizePolicy
  The canvas resize policy determines how the canvas should be resized by Godot.
  0 means Godot won't do any resizing. This is useful if you want to control the canvas size from
  javascript code in your template.
  1 means Godot will resize the canvas on start, and when changing window size via engine functions.
  2 means Godot will adapt the canvas size to match the whole browser window.

  Type:
  number

  Value:
  2

  args
  The arguments to be passed as command line arguments on startup.
  See command line tutorial.
  Note: startGame will always add the --main-pack argument.

  Type:
  Array.

  Value:
  []

  onExecute(path, args)
  A callback function for handling Godot's OS.execute calls.
  This is for example used in the Web Editor template to switch between Project Manager and editor, and for running the game.

  Arguments:

  path (string()) -- The path that Godot's wants executed.
  args (Array.) -- The arguments of the "command" to execute.

  onExit(status_code)
  A callback function for being notified when the Godot instance quits.
  Note: This function will not be called if the engine crashes or become unresponsive.

  Arguments:

  status_code (number()) -- The status code returned by Godot on exit.

  onProgress(current, total)
  A callback function for displaying download progress.
  The function is called once per frame while downloading files, so the usage of requestAnimationFrame()
  is not necessary.
  If the callback function receives a total amount of bytes as 0, this means that it is impossible to calculate.
  Possible reasons include:

  Files are delivered with server-side chunked compression
  Files are delivered with server-side compression on Chromium
  Not all file downloads have started yet (usually on servers without multi-threading)

  Arguments:

  current (number()) -- The current amount of downloaded bytes so far.
  total (number()) -- The total amount of bytes to be downloaded.

  onPrint([...var_args])
  A callback function for handling the standard output stream. This method should usually only be used in debug pages.
  By default, console.log() is used.

  Arguments:

  var_args (*()) -- A variadic number of arguments to be printed.

  onPrintError([...var_args])
  A callback function for handling the standard error stream. This method should usually only be used in debug pages.
  By default, console.error() is used.

  Arguments:

  var_args (*()) -- A variadic number of arguments to be printed as errors.
