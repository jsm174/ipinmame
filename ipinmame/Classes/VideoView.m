#import "VideoView.h"
#import "VideoLayer.h"

@implementation VideoView

/**
 * layerClass
 */ 

+(Class)layerClass {
    return [VideoLayer class];
}

/**
 * initWithFrame
 */

-(id)initWithFrame:(CGRect)frame size:(CGSize)size depth:(NSInteger)depth {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize:size depth:depth];
    }
    return self;
}

/**
 * initialize
 */

-(void)initialize:(CGSize)size depth:(NSInteger)depth {
    self.opaque = YES;
    self.clearsContextBeforeDrawing = NO;
    self.multipleTouchEnabled = NO;
    self.layer.magnificationFilter = kCAFilterNearest;

 
    [(VideoLayer*)self.layer setSize:size depth:depth];
}

/**
 * buffer
 */

-(void*)buffer {
    return ((VideoLayer*)self.layer).buffer;
}

/**
 * drawRect
 */

-(void)drawRect:(CGRect)rect {
}
                
@end
