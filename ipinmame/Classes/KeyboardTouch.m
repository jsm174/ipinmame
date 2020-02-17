#import "KeyboardTouch.h"

@implementation KeyboardTouch 

@synthesize touch;
@synthesize keyCode;

/**
 * initWithTouch
 */

-(id)initWithTouch:(UITouch*)inTouch code:(NSInteger)inCode {
    self = [super init];
    if (self) {
        self.touch = inTouch;
        self.keyCode = inCode;
    }
    return self; 
}

@end

