#import "GameViewController.h"
#import "CustomNavigationBar.h"
#import "Constants.h"

#include <driver.h>
#include <osdepend.h>
#include <unzip.h>
#include <stdio.h>
#include <string.h>

void set_pathlist(int file_type, const char* new_rawpath);

typedef struct {
    const char *name;
    int index;
} driver_data_type;

static GameViewController* _gameViewController = nil;
static driver_data_type* sorted_drivers;
static int game_count = 0;

int stricmp(char *s1, char *s2) {
	int i;
	
	for (i=0; s1[i] && s2[i]; i++) {
		if (((unsigned char)s1[i] | 0x20) > ((unsigned char)s2[i] | 0x20)) return 1;
		if (((unsigned char)s1[i] | 0x20) < ((unsigned char)s2[i] | 0x20)) return -1;
	}
	
	if (!(s1[i] | s2[i])) return 0;
	
	if (s1[i]) return 1;
	else return 0;
}

int CLIB_DECL DriverDataCompareFunc(const void *arg1, const void *arg2) {
    return strcmp( ((driver_data_type *)arg1)->name, ((driver_data_type *)arg2)->name );
}

/**
 * ipinmame_logger() 
 */

void ipinmame_logger(const char* fmt, ...) {
    va_list vl;
    va_start(vl, fmt); 
    
    NSString* buffer = [[NSString alloc] initWithFormat:[NSString stringWithCString:fmt encoding:NSUTF8StringEncoding] arguments:vl];
    NSLog(@"%@", buffer);
    
    va_end(vl);  
    
    [_gameViewController performSelectorOnMainThread:@selector(appendLog:) 
                                          withObject:buffer 
                                       waitUntilDone:NO];
}

/**
 * ipinmame_logger() 
 */

UINT8* ipinmame_init_video(int width, int height, int depth) {
    UINT8* buffer = NULL;
    
    NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:[NSValue valueWithCGSize:CGSizeMake(width, height)] forKey:@"size"];
    [userInfo setObject:[NSNumber numberWithInteger:(NSInteger)depth] forKey:@"depth"];
    
    [_gameViewController performSelectorOnMainThread:@selector(initializeVideo:)
                                          withObject:userInfo 
                                       waitUntilDone:YES];
    
    NSValue* value = [userInfo objectForKey:@"buffer"];
    
    if (value) {
        buffer = (UINT8*)[value pointerValue];
    }
    
    return buffer;
}

/**
 * ipinmame_update_display() 
 */

void ipinmame_update_display() {
    [_gameViewController.videoView performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];  
}

/**
 * ipinmame_get_keycode_status() 
 */

int ipinmame_get_keycode_status(int keycode) {
    return [_gameViewController.keyboardView keyState:keycode];
}

@implementation GameViewController

@synthesize videoView;
@synthesize keyboardView;

/**
 * viewDidLoad
 */

-(void)viewDidLoad {
    [super viewDidLoad];
    
    _gameViewController = self;
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0
                                                                        green:0
                                                                         blue:0 
                                                                        alpha:1.0];
    
    //self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:kOrangeColor_Red
    //                                                                    green:kOrangeColor_Green
    //                                                                     blue:kOrangeColor_Blue 
    //                                                                    alpha:1.0];
    //[((CustomNavigationBar*)self.navigationController.navigationBar) setPattern:[UIImage imageNamed:@"navigationBar"]];
    
    self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]] autorelease];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    fullscreen = NO;
    
    [self performSelector:@selector(performStartup:) withObject:nil afterDelay:.5];
}

/** 
 * appendLog
 */

-(void)appendLog:(NSString*)log {
    if (log != nil) {
        NSMutableString* data = [[NSMutableString alloc] initWithString:textView.text];
        if (data.length > 0) {
            [data appendString:@"\n"];
        }
        [data appendString:log];
        textView.text = data;               
        textView.selectedRange = NSMakeRange(data.length - 1, 0);
        [data release];
        
        [log release];
    }
}

/**
 * initializeVideo
 */

-(void)initializeVideo:(NSMutableDictionary*)userInfo {
    CGSize size = [[userInfo objectForKey:@"size"] CGSizeValue];
    NSInteger depth = [[userInfo objectForKey:@"depth"] integerValue];
    
    if (self.videoView) {
        [self.videoView removeFromSuperview];
        [self.videoView release];
    }
    
    self.videoView = [[VideoView alloc] initWithFrame:CGRectMake(20, 35, 320, 320) 
                                                 size:size
                                                depth:depth];
    
    self.videoView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    [self.view insertSubview:self.videoView belowSubview:keyboardView];
    
    [userInfo setObject:[NSValue valueWithPointer:[self.videoView buffer]] forKey:@"buffer"];
    
    return;
}

/**
 * performStartup
 */ 

-(void)performStartup:(id)unused {
    ipinmame_logger("iPinMAME started");
    
    while (drivers[game_count] != 0) {
		game_count++;
    }
    
    sorted_drivers = (driver_data_type *)malloc(sizeof(driver_data_type) * game_count);
    for (int i=0;i<game_count;i++) {
        sorted_drivers[i].name = drivers[i]->name;
        sorted_drivers[i].index = i;
    }
    qsort(sorted_drivers,game_count,sizeof(driver_data_type),DriverDataCompareFunc );
    
    [self startup];
}

/**
 * startup
 */

-(void)startup {
    [NSThread detachNewThreadSelector:@selector(performGameThread:) toTarget:self withObject:nil];          
}

/**
 * didTouchReset
 */

-(IBAction)didTouchReset:(id)sender {
    [self startup];     
}

/**
 * performGameThread
 */

-(void)performGameThread:(id)userInfo {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    /*
     
     ij_l7 -rompath "C:\roms" -samplepath "samples" -inipath "ini" -cfg_directory "cfg" -nvram_directory "nvram" -memcard_directory "memcard" -input_directory "inp" -hiscore_directory "hi" -state_directory "sta" -artwork_directory "artwork" -snapshot_directory "snap" -diff_directory "diff" -cheat_file "cheat.dat" -history_file "history.dat" -mameinfo_file "mameinfo.dat" -ctrlr_directory "ctrlr" -autoframeskip -frameskip 0 -nowaitvsync -window -noddraw -hwstretch -resolution auto -refresh 0 -noscanlines -switchres -switchbpp -nomaximize -keepaspect -nomatchrefresh -nosyncrefresh -throttle -full_screen_brightness 1.000000 -frames_to_run 0 -effect none -screen_aspect 4:3 -cleanstretch auto -zoom 2 -nomouse -nojoystick -nosteadykey -ctrlr "Standard" -brightness 1.000000 -pause_brightness 0.650000 -gamma 1.000000 -samplerate 44100 -samples -resamplefilter -sound -volume 0 -audio_latency 1 -artwork -backdrop -overlay -bezel -noartcrop -artres 0 -nolog -nosleep -rdtsc -noleds -wave_directory "wave" -dmd_red 225 -dmd_green 224 -dmd_blue 32 -dmd_perc0 20 -dmd_perc33 33 -dmd_perc66 67 -nodmd_only -nodmd_compact -dmd_antialias 50
     
     */
    
    
    NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
    set_pathlist(FILETYPE_ROM, [[NSString stringWithFormat:@"%@/roms", bundlePath] cStringUsingEncoding:NSASCIIStringEncoding]);
    
    NSArray* appPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentsPath = [appPaths objectAtIndex:0];
    
    set_pathlist(FILETYPE_SAMPLE, [[NSString stringWithFormat:@"%@/samples", documentsPath] cStringUsingEncoding:NSASCIIStringEncoding]);                       
    set_pathlist(FILETYPE_CONFIG, [[NSString stringWithFormat:@"%@/cfg", documentsPath] cStringUsingEncoding:NSASCIIStringEncoding]);  
    set_pathlist(FILETYPE_NVRAM, [[NSString stringWithFormat:@"%@/nvram", documentsPath] cStringUsingEncoding:NSASCIIStringEncoding]);  
    set_pathlist(FILETYPE_SCREENSHOT, [[NSString stringWithFormat:@"%@/snap", documentsPath] cStringUsingEncoding:NSASCIIStringEncoding]);  
    set_pathlist(FILETYPE_WAVE, [[NSString stringWithFormat:@"%@/wave", documentsPath] cStringUsingEncoding:NSASCIIStringEncoding]);  
    set_pathlist(FILETYPE_HISTORY, [[NSString stringWithFormat:@"%@/history", documentsPath] cStringUsingEncoding:NSASCIIStringEncoding]);  
    set_pathlist(FILETYPE_HIGHSCORE, [[NSString stringWithFormat:@"%@/hi", documentsPath] cStringUsingEncoding:NSASCIIStringEncoding]);  
    set_pathlist(FILETYPE_ARTWORK, [[NSString stringWithFormat:@"%@/artwork", documentsPath] cStringUsingEncoding:NSASCIIStringEncoding]);  
    set_pathlist(FILETYPE_INI, [[NSString stringWithFormat:@"%@/ini", documentsPath] cStringUsingEncoding:NSASCIIStringEncoding]);  
    set_pathlist(FILETYPE_INPUTLOG, [[NSString stringWithFormat:@"%@/inp", documentsPath] cStringUsingEncoding:NSASCIIStringEncoding]);  
    set_pathlist(FILETYPE_STATE, [[NSString stringWithFormat:@"%@/sta", documentsPath] cStringUsingEncoding:NSASCIIStringEncoding]);  
    
    //pmoptions.dmd_only = 1;
    
    options.samplerate = 44100;
    options.gamma = 1;
    options.pause_bright= .65;
    options.brightness = 1;
    options.skip_disclaimer = 1;
    options.skip_gameinfo = 1;
    
    int game_index = -1;
    
    char* gamename = "ij_l7";
    //char* gamename = "mb_106b";
    
    if (game_index == -1) {
		for (int i = 0; drivers[i]; i++) {
			if (stricmp(gamename, (char*)drivers[i]->name) == 0) {
				game_index = i;
				break;
			}
        }
	}
    
    if (game_index != -1) {
        run_game(game_index);
    }
    
    [pool release];
}

-(IBAction)didTouchFullscreen:(id)sender {
    fullscreen = !fullscreen;
    
    if (fullscreen) {
        self.videoView.frame = self.view.frame;
        self.videoView.frame = CGRectMake(0, 0, 1500, 1000);
        self.videoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        keyboardView.alpha = .5;
    }
    else {
        self.videoView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.videoView.frame = CGRectMake(20, 35, 320, 320);
        keyboardView.alpha = 1;
        
    }
}

/**
 * shouldAutorotateToInterfaceOrientation
 */

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

/**
 * dealloc
 */

-(void)dealloc {
    [self.videoView release];
    [self.keyboardView release];
    
    [super dealloc];
}

@end
