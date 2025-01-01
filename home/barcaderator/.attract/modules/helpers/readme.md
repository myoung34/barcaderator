# Helpers module for AttractMode front end

by [Keil Miller Jr](http://keilmillerjr.com)

## DESCRIPTION:

Helpers module is for the [AttractMode](http://attractmode.org) front end. It consists of a few common functions to supplement the default squirrel functions and aid in the creation of an AttractMode layout.

## Paths

You may need to change file paths as necessary as each platform (windows, mac, linux) has a slightly different directory structure.

## Install Files

1. Copy module files to `$HOME/.attract/modules/Helpers/`

## Usage

Functions can be called by their full or short name. Load the module within your layout, plugin or module before any dependencies. All functions are global (stored in root table) so they can be called from anywhere without having to load the module again.

```Squirrel
// --------------------
// Print Formatting
// --------------------

// Print Line
printLine(x)
printL(x)

// --------------------
// Values and Data Types
// --------------------

// Percentages of A Value
percentage(percent, val=100)
per(percent, val=100)

// Is value within range
inRange(val, low, high)

// Generate a pseudo-random integer between 0 and max
randInteger(max)
randInt(max)

// Generate a pseudo-random boolean
randomBoolean()
randBool()

// Convert 0/1 and Yes/No to Boolean
toBoolean(x)
toBool(x)

// --------------------
// Display Functions
// --------------------

// Seperate X and Y Resolutions From String
// Example: if var = "640x480" and type = "height", splitRes will return an integer of 480
splitResolution(var, type, separator="x")
splitRes(var, type, separator="x")

// Reverse X and Y Resolutions Within String
// Example: if var = "640x480", reverseRes will return an string of "480x640"
reverseResolution(var)
reverseRes(var)

// Is Layout In Vertical Orientation
isLayoutVertical()
isLayoutVert()

// Is Widescreen
// Warning: Attractmode calculates layout size with the screen width and height, not the window
isWidescreen()

// --------------------
// Object Formatting
// --------------------

// Set Properties On An Object
// Example:
//   local imageConfig = { x = 10, y = 10, width = 100, height = 100, rgb = [255, 255, 255]};
//   local image = fe.add_image("image.png");
//   setProps(image, imageConfig);
setProperties(target, properties)
setProps(target, properties)

// Shade Object
// Example: if val = 50, object will be shaded %50
shadeObject(obj, val)

// Match Aspect Ratio
matchAspect(aw, ah, dimension, param, obj=null)

// --------------------
// Resource Paths
// --------------------

// Path to single white pixel for use with creating colorized backgrounds
pixelPath
```

## Notes

The setProperties function is taken from liquid8d and his [forum post](http://forum.attractmode.org/index.php?topic=1107.msg8464#msg8464) on the AttractMode forum.

More functionality is expected as it meets my needs. If you have an idea of something to add that might benefit a wide range of layout developers, please join the AttractMode forum and send me a message, or issue a pull request.
