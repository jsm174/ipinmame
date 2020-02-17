#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/CALayer.h>


@interface VideoLayer : CALayer {
    CGContextRef bitmapContext;
}

@property (nonatomic, assign) void* buffer;

-(void)setSize:(CGSize)size depth:(NSInteger)depth;

@end
