#import <UIKit/UIKit.h>

@interface VideoView : UIView {
}

-(id)initWithFrame:(CGRect)frame size:(CGSize)size depth:(NSInteger)depth;
-(void)initialize:(CGSize)size depth:(NSInteger)depth;
-(void*)buffer;

@end
