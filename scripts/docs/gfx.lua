-- Global `gfx` table

-- Creates a new circle arc shaped sub-path
---@param cx number # center x-coordinate
---@param cy number # center y-coordinate
---@param r number # radius
---@param a0 number # starting angle, in radians
---@param a1 number # ending angle, in radians
---@param dir integer # 1 = counter-clockwise, 2 = clockwise
Arc = function(cx, cy, r, a0, a1, dir) end

-- Adds an arc segment at the corner defined by the previous point and two specified points
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@param radius number
ArcTo = function(x1, y1, x2, y2, radius) end

-- Clears currently defined paths to begin drawing a new "shape"
BeginPath = function() end

-- Adds a cubic bezier segment from the previous point to the specified point  
-- Uses the two control points `(c1x, c1y)` and `(c2x, c2y)`
---@param c1x number
---@param c1y number
---@param c2x number
---@param c2y number
---@param x number
---@param y number
BezierTo = function(c1x, c1y, c2x, c2y, x, y) end

-- Creates a box gradient that can be used by `FillPaint` or `StrokePaint`  
---@param x number
---@param y number
---@param w number
---@param h number
---@param r number # radius
---@param f number # feather amount
BoxGradient = function(x, y, w, h, r, f) end

-- Creates a new circle shaped sub-path
---@param cx number
---@param cy number
---@param r number
Circle = function(cx, cy, r) end

-- Closes the current sub-path with a line segment
ClosePath = function() end

-- Loads an image from the specified filename
---@param filename string
---@param flags? integer # options are under the `gfx` table prefixed with `IMAGE`
CreateImage = function(filename, flags) end

-- Creates a cached text that can be drawn by `DrawLabel`
---@param text string
---@param size integer
---@param monospace boolean
CreateLabel = function(text, size, monospace) end

-- Creates a new `ShadedMesh` object
---@param materialName string
---@param path? string # Optional path to the material, loads from the current skin's `shaders` folder otherwise  
-- `<materialName>.fs` and `<materialName>.vs` must exist at either location
---@return ShadedMesh
CreateShadedMesh = function(materialName, path) end

-- Loads an image from the specified filename, prepended with `skins/<skin>/textures/`
---@param filename string
---@param flags? integer
CreateSkinImage = function(filename, flags) end

-- Draws the loaded gauge  
-- The game loads the gauge itself, using the textures in `skins/<skin>/textures/gauges/`
---@param rate number # current gauge percentage
---@param x number
---@param y number
---@param w number
---@param h number
---@param deltaTime number
DrawGauge = function(rate, x, y, w, h, deltaTime) end

-- Draws a created label, resized if `maxWidth > 0`  
-- Labels are always be drawn on top of other drawn elements
---@param label any # label created by `CreateLabel`
---@param x number
---@param y number
---@param maxWidth? number
DrawLabel = function(label, x, y, maxWidth) end

-- Creates a new ellipse shaped sub-path
---@param cx number
---@param cy number
---@param rx number
---@param ry number
Ellipse = function(cx, cy, rx, ry) end

-- Draws a string at the specified location, but will always be drawn on top of other drawn elements
---@param text string
---@param x number
---@param y number
FastText = function(text, x, y) end

-- Gets the width and height of a given fast text
---@param text string
---@return number w, number h
FastTextSize = function(text) end

-- Fills the current path with the current fill style
Fill = function() end

-- Sets the current fill to a solid color
---@param r integer
---@param g integer
---@param b integer
---@param a? integer # default 255
FillColor = function(r, g, b, a) end

-- Sets the current fill to a paint
---@param paint any # pattern created by `ImagePattern` or gradient created by  `BoxGradient`, `LinearGradient`, or `RadialGradient`
FillPaint = function(paint) end

-- Sets the font face for the current text style
---@param font string
FontFace = function(font) end

-- Sets the font size of the current text style
---@param size number
FontSize = function(size) end

-- Forces the current render queue to be processed  
-- This causes "fast" elements such as `FastRect`, `FastText` or `labels` to be drawn/processed immediately rather than at the end of the render queue
ForceRender = function() end

-- Sets the global alpha value for all drawings  
-- Elements that have their alpha set will be adjusted relative to the global value
---@param alpha number
GlobalAlpha = function(alpha) end

-- Sets the composite operation with custom pixel arithmetic  
-- Options are under the `gfx` table prefixed with `BLEND`
---@param srcFactor integer
---@param desFactor integer
GlobalCompositeBlendFunc = function(srcFactor, desFactor) end

-- Sets the composite operation with custom pixel arithmetic for RGB and alpha components separately  
-- Options are under the `gfx` table prefixed with `BLEND`
---@param srcRGB integer
---@param desRGB integer
---@param srcAlpha integer
---@param desAlpha integer
GlobalCompositeBlendFuncSeparate = function(srcRGB, desRGB, srcAlpha, desAlpha) end

-- Sets the composite operation  
-- Options are under the `gfx` table prefixed with `BLEND_OP`
---@param op integer
GlobalCompositeOperation = function(op) end

-- Sets the inner and outer colors for a gradient  
-- `ri, gi, bi, ai` inner color  
-- `ro, go, bo, ao` outer color
---@param ri integer
---@param gi integer
---@param bi integer
---@param ai integer
---@param ro integer
---@param go integer
---@param bo integer
---@param ao integer
GradientColors = function(ri, gi, bi, ai, ro, bo, go, ao) end

-- Creates an image pattern that can be used by `FillPaint` or `StrokePaint`  
-- `(sx, sy)` is the top-left location of the pattern  
-- `(ix, iy)` is the size of one image
---@param sx number
---@param sy number
---@param ix number
---@param iy number
---@param angle number # in radians
---@param image any # image created by `CreateImage` or `CreateSkinImage`
---@param alpha number # `0.0` to `1.0`
ImagePattern = function(sx, sy, ix, iy, angle, image, alpha) end

-- Draws an image in the specified rect; stretches the image to fit
---@param x number
---@param y number
---@param w number
---@param h number
---@param image any # image created by `CreateImage` or `CreateSkinImage`, or an animation loaded with `LoadSkinAnimation`
---@param alpha number # `0.0` to `1.0`
---@param angle number # in radians
ImageRect = function(x, y, w, h, image, alpha, angle) end

-- Gets the width and height of a given image
---@param image any # image created by `CreateImage` or `CreateSkinImage`
---@return number w, number h
ImageSize = function(image) end

-- Intersects the current scissor rectangle with the specified rectangle
---@param x number
---@param y number
---@param w number
---@param h number
IntersectScissor = function(x, y, w, h) end

-- Gets the width and height of a given label
---@param label any # label created by `CreateLabel`
---@return number w, number h
LabelSize = function(label) end

-- Creates a linear gradient that can be used by `FillPaint` or `StrokePaint`  
-- `(sx, sy)` ->  `(ex, ey)` starting to ending coordinates
---@param sx number
---@param sy number
---@param ex number
---@param ey number
LinearGradient = function(sx, sy, ex, ey) end

-- Sets how the end of the line is drawn  
-- Options are under the `gfx` table prefixed with `LINE`
---@param cap integer
LineCap = function(cap) end

-- Sets how sharp path corners are drawn  
-- Options are under the `gfx` table prefixed with `LINE`
---@param join integer
LineJoin = function(join) end

-- Adds a line segment from the previous point to the specified point
---@param x number
---@param y number
LineTo = function(x, y) end

-- Loads all images of the specified folder as frames to be used for an animation  
-- Returns an `animation` that can be used the same way as an `image`
---@param path string
---@param frameTime number # 1 / fps
---@param loopCount? integer # 0
---@param compressed boolean # false
-- if `compressed`, the animation will be stored in RAM and decoded on-demand; this uses more CPU but much less RAM
LoadAnimation = function(path, frameTime, loopCount, compressed) return; end

-- Loads all images of the specified folder (but prepended with `skins/<skin>/textures/`) as frames to be used for an animation  
-- Returns an `animation` that can be used the same way as an `image`
---@param path string
---@param frameTime number # 1 / fps
---@param loopCount? integer # 0
---@param compressed boolean # false
-- if `compressed`, the animation will be stored in RAM and decoded on-demand; this uses more CPU but much less RAM
LoadSkinAnimation = function(path, frameTime, loopCount, compressed) return; end

-- Loads a font fromt the specified filename  
-- Sets it as the current font if it is already loaded
---@param name? string
---@param filename string
LoadFont = function(name, filename) end

-- Loads an image outside of the main thread to prevent rendering lock-up  
-- Image will be loaded at original size unless `w` and `h` are provided
---@param filepath string
---@param placeholder any # image created by `CreateImage` or `CreateSkinImage`
---@param w? number # 0
---@param h? number # 0
---@return any # returns `placeholder` until the image is loaded
LoadImageJob = function(filepath, placeholder, w, h) end

-- Loads a font from the specified filename, prepended with `skins/<skin>/textures/`  
-- Sets it as the current font if it is already loaded
---@param name? string
---@param filename string
LoadSkinFont = function(name, filename) end

-- Loads an image outside of the main thread to prevent rendering lock-up  
-- Image will be loaded at original size unless `w` and `h` are provided
---@param url string # web url of image
---@param placeholder any # image created by `CreateImage` or `CreateSkinImage`
---@param w? number # 0
---@param h? number # 0
---@return any # returns `placeholder` until the image is loaded
LoadWebImageJob = function(url, placeholder, w, h) end

-- Sets the miter limit of the stroke style
---@param limit number
MiterLimit = function(limit) end

-- Starts a new sub-path at the specified point
---@param x number
---@param y number
MoveTo = function(x, y) end

-- Adds a quadratic bezier segment from the previous point to the specified point  
-- Uses the control point `(cx, cy)`
---@param cx number
---@param cy number
---@param x number
---@param y number
QuadTo = function(cx, cy, x, y) end

-- Creates a radial gradient that can be used by `FillPaint` or `StrokePaint`  
---@param cx number
---@param cy number
---@param inr number # inner radius
---@param outr number # outer radius
RadialGradient = function(cx, cy, inr, outr) end

-- Creates a new rectangle shaped sub-path
---@param x number
---@param y number
---@param w number
---@param h number
Rect = function(x, y, w, h) end

-- Resets the current render state to default values  
-- This does not affect the render state stack
Reset = function() end

-- Resets and disables scissoring
ResetScissor = function() end

-- Resets all transforms done by `Rotate`, `Scale`, or `Translate`, etc.
ResetTransform = function() end

-- Pops/restores the current render state from the state stack  
-- The render state is pushed/saved to the stack using `Save`
Restore = function() end

-- Rotates the current coordinates
---@param angle number # in radians
Rotate = function(angle) end

-- Creates a rounded rectangle shaped sub-path
---@param x number
---@param y number
---@param w number
---@param h number
---@param r number
RoundedRect = function(x, y, w, h, r) end

-- Creates a rounded rectangle shaped sub-path with varying radii for each corner  
-- `r1` is the top-left corner and continues clockwise
---@param x number
---@param y number
---@param w number
---@param h number
---@param r1 number
---@param r2 number
---@param r3 number
---@param r4 number
RoundedRectVarying = function(x, y, w, h, r1, r2, r3, r4) end

-- Pushes/saves the current render state into a state stack  
-- The render state can be popped/restored from the stack using `Restore`
Save = function() end

-- Scales the current coordinates by the given factors
---@param x number
---@param y number
Scale = function(x, y) end

-- Sets the current scissor rectangle  
-- Scissoring allows you to clip any rendering into a rectangle (affected by the current transform)
---@param x number
---@param y number
---@param w number
---@param h number
Scissor = function(x, y, w, h) end

-- Sets the gauge color for the specified `index`
---@param index integer #
-- ```
-- 0 = Normal gauge fail (<70%)
-- 1 = Normal gauge clear (>=70%)
-- 2 = Hard gauge fail (<30%)
-- 3 = Hard gauge fail (>=30%)
-- ```
---@param r integer
---@param g integer
---@param b integer
SetGaugeColor = function(index, r, g, b) end

-- Multiplies the color given with all incoming drawn image colors
---@param r integer
---@param g integer
---@param b integer
SetImageTint = function(r, g, b) end

-- Skews the current coordinates along the x-axis
---@param angle number # in radians
SkewX = function(angle) end

-- Skews the current coordinates along the y-axis
---@param angle number # in radians
SkewY = function(angle) end

-- Strokes the current path with the current stroke style
Stroke = function() end

-- Sets the current stroke style to a solid color
---@param r integer
---@param g integer
---@param b integer
---@param a? integer # 255
StrokeColor = function(r, g, b, a) end

-- Sets the current stroke style to a paint
---@param paint any # pattern created by `ImagePattern` or gradient created by  `BoxGradient`, `LinearGradient`, or `RadialGradient`
StrokePaint = function(paint) end

-- Sets the stroke width of the stroke style
---@param size number
StrokeWidth = function(size) end

-- Draws a string at the specified location
---@param text string
---@param x number
---@param y number
Text = function(text, x, y) end

-- Sets the text align of the current text style  
-- Options are under the `gfx` table prefixed with `TEXT_ALIGN`
---@param align integer
TextAlign = function(align) end

-- Gets the bounding rectangle coordinates of a given text
---@param x number
---@param y number
---@param text string
---@return number x1, number y1, number x2, number y2
TextBounds = function(x, y, text); end

-- Progresses the given animation
---@param animation any # animation created by `LoadAnimation` or `LoadSkinAnimation`
---@param deltaTime number
TickAnimation = function(animation, deltaTime) end

-- Translates the current coordinates by `x` and `y`
---@param x number
---@param y number
Translate = function(x, y) end

-- Updates the properties of a created pattern
-- `(sx, sy)` is the top-left location of the pattern  
-- `(ix, iy)` is the size of one image
---@param pattern any # pattern created by `ImagePattern`
---@param sx number
---@param sy number
---@param ix number
---@param iy number
---@param angle number # in radians
---@param alpha number # `0.0` to `1.0`
UpdateImagePattern = function(pattern, sx, sy, ix, iy, angle, alpha) end

-- Updates the properties of a created label
---@param label any # label created by `CreateLabel`
---@param text? string
---@param size? integer
UpdateLabel = function(label, text, size) end

---@type table
gfx = {
  BLEND_ZERO = 1,
  BLEND_ONE = 2,
  BLEND_SRC_COLOR = 4,
  BLEND_ONE_MINUS_SRC_COLOR = 8,
  BLEND_DST_COLOR = 16,
  BLEND_ONE_MINUS_DST_COLOR = 32,
  BLEND_SRC_ALPHA = 64,
  BLEND_ONE_MINUS_SRC_ALPHA = 128,
  BLEND_DST_ALPHA = 256,
  BLEND_ONE_MINUS_DST_ALPHA = 512,
  BLEND_SRC_ALPHA_SATURATE = 1024,

  BLEND_OP_SOURCE_OVER = 0,
  BLEND_OP_SOURCE_IN = 1,
  BLEND_OP_SOURCE_OUT = 2,
  BLEND_OP_ATOP = 3,
  BLEND_OP_DESTINATION_OVER = 4,
  BLEND_OP_DESTINATION_IN = 5,
  BLEND_OP_DESTINATION_OUT = 6,
  BLEND_OP_DESTINATION_ATOP = 7,
  BLEND_OP_LIGHTER = 8,
  BLEND_OP_COPY = 9,
  BLEND_OP_XOR = 10,

  IMAGE_GENERATE_MIPMAPS = 1,
  IMAGE_REPEATX = 2,
  IMAGE_REPEATY = 4,
  IMAGE_FLIPY = 8,
  IMAGE_PREMULTIPLIED = 16,
  IMAGE_NEAREST = 32,

  LINE_BUTT = 0,
  LINE_ROUND = 1,
  LINE_SQUARE = 2,
  LINE_BEVEL = 3,
  LINE_MITER = 4,

  TEXT_ALIGN_LEFT = 1,
  TEXT_ALIGN_CENTER = 2,
  TEXT_ALIGN_RIGHT = 4,

  TEXT_ALIGN_TOP = 8,
  TEXT_ALIGN_MIDDLE = 16,
  TEXT_ALIGN_BOTTOM = 32,
  TEXT_ALIGN_BASELINE = 64,

  Arc = Arc,
  ArcTo = ArcTo,
  BeginPath = BeginPath,
  BezierTo = BezierTo,
  BoxGradient = BoxGradient,
  Circle = Circle,
  ClosePath = ClosePath,
  CreateImage = CreateImage,
  CreateLabel = CreateLabel,
  CreateShadedMesh = CreateShadedMesh,
  CreateSkinImage = CreateSkinImage,
  DrawGauge = DrawGauge,
  DrawLabel = DrawLabel,
  Ellipse = Ellipse,
  FastText = FastText,
  FastTextSize = FastTextSize,
  Fill = Fill,
  FillColor = FillColor,
  FillPaint = FillPaint,
  FontFace = FontFace,
  FontSize = FontSize,
  ForceRender = ForceRender,
  GlobalAlpha = GlobalAlpha,
  GlobalCompositeBlendFunc = GlobalCompositeBlendFunc,
  GlobalCompositeBlendFuncSeparate = GlobalCompositeBlendFuncSeparate,
  GlobalCompositeOperation = GlobalCompositeOperation,
  GradientColors = GradientColors,
  ImagePattern = ImagePattern,
  ImageRect = ImageRect,
  ImageSize = ImageSize,
  IntersectScissor = IntersectScissor,
  LabelSize = LabelSize,
  LinearGradient = LinearGradient,
  LineCap = LineCap,
  LineJoin = LineJoin,
  LineTo = LineTo,
  LoadAnimation = LoadAnimation,
  LoadSkinAnimation = LoadSkinAnimation,
  LoadFont = LoadFont,
  LoadImageJob = LoadImageJob,
  LoadSkinFont = LoadSkinFont,
  LoadWebImageJob = LoadWebImageJob,
  MiterLimit = MiterLimit,
  MoveTo = MoveTo,
  QuadTo = QuadTo,
  RadialGradient = RadialGradient,
  Rect = Rect,
  Reset = Reset,
  ResetScissor = ResetScissor,
  ResetTransform = ResetTransform,
  Restore = Restore,
  Rotate = Rotate,
  RoundedRect = RoundedRect,
  RoundedRectVarying = RoundedRectVarying,
  Save = Save,
  Scale = Scale,
  Scissor = Scissor,
  SetGaugeColor = SetGaugeColor,
  SetImageTint = SetImageTint,
  SkewX = SkewX,
  SkewY = SkewY,
  Stroke = Stroke,
  StrokeColor = StrokeColor,
  StrokePaint = StrokePaint,
  StrokeWidth = StrokeWidth,
  Text = Text,
  TextAlign = TextAlign,
  TextBounds = TextBounds,
  TickAnimation = TickAnimation,
  Translate = Translate,
  UpdateImagePattern = UpdateImagePattern,
  UpdateLabel = UpdateLabel,
};