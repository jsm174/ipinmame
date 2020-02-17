#import <UIKit/UIKit.h>
#import "VideoView.h"
#import "KeyboardView.h"

int stricmp(char *s1, char *s2);

extern void ipinmame_logger(const char* fmt, ...);
extern void ipinmame_update_display();
extern int ipinmame_get_keycode_status(int keycode);

@interface GameViewController : UIViewController {
    IBOutlet UITextView* textView;
    IBOutlet KeyboardView* keyboardView;

    BOOL fullscreen;
}

@property (nonatomic, retain) VideoView* videoView;
@property (nonatomic, retain) KeyboardView* keyboardView;

-(int)keycodeStatus:(int)keycode;
-(IBAction)isKeyDown:(id)sender;
-(IBAction)isKeyUp:(id)sender;

-(IBAction)didTouchReset:(id)sender;
-(IBAction)didTouchFullscreen:(id)sender;

@end
