#import <Foundation/Foundation.h>

@interface KeyboardTouch : NSObject {
}

-(id)initWithTouch:(UITouch*)inTouch code:(NSInteger)inCode;

@property (nonatomic, retain) UITouch* touch;
@property (nonatomic, assign) NSInteger keyCode;

@end

