#import <UIKit/UIKit.h>

#define kKeyboardView_TotalKeys           110
#define kKeyboardView_MaxSimulatenousKeys 5

@interface KeyboardView : UIView {
    UIImage* keyboardImage;
    UIImage* keyboardPressedImage;
    
    int* hitTest;
    
    int keyState[kKeyboardView_TotalKeys];
    
    NSMutableArray* touchesArray;
}

@property(nonatomic, retain) id	delegate;

-(void)initialize;
-(int)keyState:(int)code;

@end
