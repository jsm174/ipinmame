#import "KeyboardView.h"
#import "KeyboardTouch.h"

static CGRect kKeyboardKeyRects[kKeyboardView_TotalKeys] = {
    {   0,   0,   0,   0 }, // 
    {   1,   0,  42,  26 }, //   1 - ESC
    {  47,   0,  42,  26 }, //   2 - F1
    {  94,   0,  42,  26 }, //   3 - F2
    { 141,   0,  42,  26 }, //   4 - F3
    { 188,   0,  42,  26 }, //   5 - F4
    { 235,   0,  42,  26 }, //   6 - F5
    { 282,   0,  42,  26 }, //   7 - F6
    { 328,   0,  42,  26 }, //   8 - F7
    { 375,   0,  42,  26 }, //   9 - F8
    { 422,   0,  42,  26 }, //  10 - F9
    { 469,   0,  42,  26 }, //  11 - F10
    { 516,   0,  42,  26 }, //  12 - F11
    { 562,   0,  42,  26 }, //  13 - F12
    { 609,   0,  42,  26 }, //  14 - EJECT
     
    { 672,   0,  42,  26 }, //  15 - F13
    { 718,   0,  42,  26 }, //  16 - F14
    { 765,   0,  42,  26 }, //  17 - F15
     
    { 827,   0,  42,  26 }, //  18 - F16
    { 872,   0,  42,  26 }, //  19 - F17
    { 917,   0,  42,  26 }, //  20 - F18
    { 962,   0,  42,  26 }, //  21 - F19
    
    {   0,  32,  41,  39 }, //  22 - ~
    {  45,  32,  41,  39 }, //  23 - 1
    {  90,  32,  41,  39 }, //  24 - 2
    { 136,  32,  41,  39 }, //  25 - 3
    { 181,  32,  41,  39 }, //  26 - 4
    { 226,  32,  41,  39 }, //  27 - 5
    { 272,  32,  41,  39 }, //  28 - 6
    { 317,  32,  41,  39 }, //  29 - 7
    { 362,  32,  41,  39 }, //  30 - 8
    { 408,  32,  41,  39 }, //  31 - 9
    { 453,  32,  41,  39 }, //  32 - 0
    { 498,  32,  41,  39 }, //  33 - -
    { 544,  32,  41,  39 }, //  34 - =
    { 587,  32,  64,  39 }, //  35 - DEL
    
    { 673,  32,  41,  39 }, //  36 - FN
    { 718,  32,  41,  39 }, //  37 - HOME
    { 764,  32,  41,  39 }, //  38 - PGUP
    
    { 827,  33,  41,  39 }, //  39 - CLEAR PAD
    { 873,  33,  41,  39 }, //  40 - = PAD
    { 918,  33,  41,  39 }, //  41 - / PAD
    { 963,  33,  41,  39 }, //  42 - * PAD
    
    {   0,  77,  64,  39 }, //  43 - TAB
    {  66,  77,  41,  39 }, //  44 - Q
    { 111,  77,  41,  39 }, //  45 - W
    { 157,  77,  41,  39 }, //  46 - E
    { 202,  77,  41,  39 }, //  47 - R
    { 247,  77,  41,  39 }, //  48 - T
    { 293,  77,  41,  39 }, //  49 - Y
    { 338,  77,  41,  39 }, //  50 - U
    { 383,  77,  41,  39 }, //  51 - I
    { 429,  77,  41,  39 }, //  52 - O
    { 474,  77,  41,  39 }, //  53 - P
    { 520,  77,  41,  39 }, //  54 - [
    { 565,  77,  41,  39 }, //  55 - ]
    { 609,  77,  64,  39 }, //  56 - \
    
    { 673,  77,  41,  39 }, //  57 - DEL
    { 718,  77,  41,  39 }, //  58 - END
    { 764,  77,  41,  39 }, //  59 - PGDN
    
    { 827,  77,  41,  39 }, //  60 - 7 PAD
    { 873,  77,  41,  39 }, //  61 - 8 PAD
    { 918,  77,  41,  39 }, //  62 - 9 PAD
    { 963,  77,  41,  39 }, //  63 - - PAD
    
    {   0, 121,  76,  39 }, //  64 - CAPS LOCK
    {  78, 121,  41,  39 }, //  65 - A
    { 123, 121,  41,  39 }, //  66 - S
    { 168, 121,  41,  39 }, //  67 - D
    { 214, 121,  41,  39 }, //  68 - F
    { 259, 121,  41,  39 }, //  69 - G
    { 305, 121,  41,  39 }, //  70 - H
    { 350, 121,  41,  39 }, //  71 - J
    { 395, 121,  41,  39 }, //  72 - K
    { 441, 121,  41,  39 }, //  73 - L
    { 486, 121,  41,  39 }, //  74 - ;
    { 531, 121,  41,  39 }, //  75 - '
    { 575, 121,  76,  39 }, //  76 - RETURN
    
    { 827, 121,  41,  39 }, //  77 - 4 PAD
    { 873, 121,  41,  39 }, //  78 - 5 PAD
    { 918, 121,  41,  39 }, //  79 - 6 PAD
    { 963, 121,  41,  39 }, //  80 - + PAD
    
    {   0, 165,  97,  39 }, //  81 - SHIFT
    {  99, 165,  41,  39 }, //  82 - Z
    { 144, 165,  41,  39 }, //  83 - X
    { 189, 165,  41,  39 }, //  84 - C
    { 234, 165,  41,  39 }, //  85 - V
    { 280, 165,  41,  39 }, //  86 - B
    { 326, 165,  41,  39 }, //  87 - N
    { 371, 165,  41,  39 }, //  88 - M
    { 416, 165,  41,  39 }, //  89 - ,
    { 462, 165,  41,  39 }, //  90 - .
    { 507, 165,  41,  39 }, //  91 - /
    { 553, 165,  98,  39 }, //  92 - SHIFT
    
    { 718, 173,  42,  38 }, //  93 - UP
    
    { 827, 165,  41,  39 }, //  94 - 1 PAD
    { 873, 165,  41,  39 }, //  95 - 2 PAD
    { 918, 165,  41,  39 }, //  96 - 3 PAD
    { 964, 165,  40,  91 }, //  97 - ENTER
    
    {   0, 209,  63,  46 }, //  98 - CONTROL
    {  66, 209,  54,  46 }, //  99 - OPTION
    { 123, 209,  64,  46 }, // 100 - COMMAND
    { 191, 209, 267,  46 }, // 101 - SPACE
    { 462, 209,  63,  46 }, // 102 - COMMAND
    { 529, 209,  53,  46 }, // 103 - OPTION
    { 587, 209,  64,  46 }, // 104 - CONTROL
    
    { 673, 217,  41,  39 }, // 105 - LEFT
    { 718, 217,  41,  39 }, // 106 - DOWN
    { 764, 217,  41,  39 }, // 107 - RIGHT
    
    { 828, 209,  85,  46 }, // 108 - 0 PAD
    { 919, 209,  40,  46 }, // 109 - . PAD
};

@implementation KeyboardView

@synthesize delegate;

/**
 * initWithFrame
 */  

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

/**
 * initWithCoder
 */

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

/**
 * initialize
 */

-(void)initialize {
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    self.clearsContextBeforeDrawing = NO;
    self.multipleTouchEnabled = YES;
    
    keyboardImage = [[UIImage imageNamed:@"keyboard-Landscape"] retain];
    keyboardPressedImage = [[UIImage imageNamed:@"keyboardPressed-Landscape"] retain];

    touchesArray = [[NSMutableArray alloc] init];

    memset(keyState, 0, kKeyboardView_TotalKeys * sizeof(int));

    hitTest = malloc(256 * 1004 * sizeof(int));
    memset(hitTest, 0, (256 * 1004 * sizeof(int)));

    for (int keyCode = 0; keyCode < kKeyboardView_TotalKeys; keyCode++) {
        CGRect rect = kKeyboardKeyRects[keyCode];
        for (int y = rect.origin.y; y < rect.origin.y + rect.size.height; y++) {
            for (int x = rect.origin.x; x < rect.origin.x + rect.size.width; x++) {
                hitTest[(y * 1004) + x] = keyCode;
            }
        }
    } 
}


/**
 * layoutSubviews
 */

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self setNeedsDisplay];
}

/**
 * keyboardTouchByTouch
 */

-(KeyboardTouch*)keyboardTouchByTouch:(UITouch*)touch {
    for (KeyboardTouch* keyboardTouch in touchesArray) {
        if (keyboardTouch.touch == touch) {
            return keyboardTouch;
        }
    }
    return nil;
}

/**
 * touchesBegan
 */

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event{
    BOOL refresh = NO;
    
    for (UITouch* touch in touches) {
        CGPoint point = [touch locationInView:self];
        if (CGRectContainsPoint(self.bounds, point)) {
            int keyCode = hitTest[(((int)point.y)*1004) + ((int)point.x)];
            if (keyCode > 0) {
               keyState[keyCode] = 1;
               [touchesArray addObject:[[[KeyboardTouch alloc] initWithTouch:touch code:keyCode] autorelease]];
               refresh = YES;
            }
        }
    }
    
    if (refresh) {
       [self setNeedsDisplay];
    }
}

/**
 * touchesCancelled
 */

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    BOOL refresh = NO;

    for (UITouch* touch in touches) {
        KeyboardTouch* keyboardTouch = [self keyboardTouchByTouch:touch];
        if (keyboardTouch != nil) {
            keyState[keyboardTouch.keyCode] = 0;
            [touchesArray removeObject:keyboardTouch];
            refresh = YES;
        }
    }
    
    if (refresh) {
        [self setNeedsDisplay];
    }
}

/**
 * touchesEnded
 */

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    BOOL refresh = NO;
    
    for (UITouch* touch in touches) {
        KeyboardTouch* keyboardTouch = [self keyboardTouchByTouch:touch];
        if (keyboardTouch != nil) {
            keyState[keyboardTouch.keyCode] = 0;
            [touchesArray removeObject:keyboardTouch];
            refresh = YES;
        }
    }
    
    if (refresh) {
        [self setNeedsDisplay];
    }
}

/**
 * drawRect
 */

-(void)drawRect:(CGRect)rect {    
    [keyboardImage drawAtPoint:CGPointMake(0,0)];
    
    CGRect keyRects[kKeyboardView_MaxSimulatenousKeys];
    int keyCount = 0;
    
    for (KeyboardTouch* keyboardTouch in touchesArray) {
        if (keyCount >= kKeyboardView_MaxSimulatenousKeys) {
            break;
        }
        
        keyRects[keyCount] = kKeyboardKeyRects[keyboardTouch.keyCode];
        keyCount++;
    }
    
    if (keyCount > 0) {
        CGContextClipToRects(UIGraphicsGetCurrentContext(), keyRects, keyCount);        
        [keyboardPressedImage drawAtPoint:CGPointMake(0,0)];
    }
}

/**
 * keyState
 */

-(int)keyState:(int)keyCode {
    return ((keyCode > 0) && (keyCode < kKeyboardView_TotalKeys)) ? keyState[keyCode] : 0;
}

/**
 * dealloc
 */

-(void)dealloc {
    free(hitTest);
    
    [keyboardImage release];
    [keyboardPressedImage release];
    
    [touchesArray release];
    
    [super dealloc];
}

@end
