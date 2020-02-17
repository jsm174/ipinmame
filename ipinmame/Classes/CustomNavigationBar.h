#import <UIKit/UIKit.h>

@interface CustomNavigationBar : UINavigationBar {
    UIImage* pattern;
    UIImage* landscapePattern;
}

-(void)setPattern:(UIImage*)inPattern;
-(void)setPattern:(UIImage*)inPattern landscapePatternPhone:(UIImage*)inLandscapePattern;
    
@end
