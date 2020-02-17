#import "CustomNavigationBar.h"

@implementation CustomNavigationBar

/**
 * setPattern
 */

-(void)setPattern:(UIImage*)inPattern {
    if (pattern != nil) {
        [pattern release];
    }

    pattern = [inPattern retain];
}

/**
 * setPattern
 */

-(void)setPattern:(UIImage*)inPattern landscapePatternPhone:(UIImage*)inLandscapePattern {
    [self setPattern:inPattern];
    
    if (landscapePattern != nil) {
        [landscapePattern release];
    }
    
    landscapePattern = [inLandscapePattern retain];
}

/**
 * drawRect
 */

-(void)drawRect:(CGRect)rect {
    UIImage* tempPattern = nil;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        tempPattern = pattern;
    }
    else {
        if ((rect.size.width > 320) && (landscapePattern != nil)) {
            tempPattern = landscapePattern;
        }
        else {
            tempPattern = pattern;
        }
    }
    
    if (tempPattern != nil) {
        [tempPattern drawAsPatternInRect:rect];
    }
    else {
        [super drawRect:rect];
    }
}

/**
 * dealloc
 */

-(void)dealloc {
    if (pattern != nil) {
        [pattern release];
    }

    if (landscapePattern != nil) {
        [landscapePattern release];
    }
    
    [super dealloc];
}

@end
