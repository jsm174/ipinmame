#import "VideoLayer.h"
#include "driver.h"

@implementation VideoLayer

@synthesize buffer;

/**
 * init
 */

-(id)init {
    if (self = [super init]) {
        bitmapContext = nil;
    } 
    return self;
}

/**
 * setSize
 */ 

-(void)setSize:(CGSize)size depth:(NSInteger)depth {
    if (bitmapContext == nil) {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

       if (depth == 32) {
           int bitmapBytesPerRow = (size.width * 4);
           
           self.buffer = calloc((bitmapBytesPerRow * size.height), sizeof(UINT8));
           
           bitmapContext = CGBitmapContextCreate(self.buffer,
                                                 size.width, 
                                                 size.height, 
                                                 8, 
                                                 bitmapBytesPerRow, 
                                                 colorSpace, 
                                                 kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little);
       }
       else {
           int bitmapBytesPerRow = (size.width * 2);

           self.buffer = calloc((bitmapBytesPerRow * size.height), sizeof(UINT8));
           
           bitmapContext = CGBitmapContextCreate(self.buffer,
                                                 size.width, 
                                                 size.height, 
                                                 5, 
                                                 bitmapBytesPerRow, 
                                                 colorSpace, 
                                                 kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder16Little);
       }
    
       CFRelease(colorSpace);    
    }
}

/**
 * display
 */

-(void)display {
    self.frame = CGRectMake(0, 0, 1284, 1027);
    
    if (bitmapContext) {
       CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
       self.contents = (id)cgImage;
       CFRelease(cgImage);
    }
}

@end
