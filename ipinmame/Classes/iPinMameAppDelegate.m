#import "iPinMameAppDelegate.h"

@implementation iPinMameAppDelegate

@synthesize window;
@synthesize rootViewController;

/**
 * sharedInstance
 */

+(iPinMameAppDelegate*)sharedInstance {
	return (iPinMameAppDelegate*)[[UIApplication sharedApplication] delegate];
}

/**
 * application:didFinishLaunchingWithOptions
 */

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.rootViewController = rootViewController;
    
    //[self.window addSubview:rootViewController.view];
    
    return YES;
}

/**
 * applicationWillResignActive
 */

-(void)applicationWillResignActive:(UIApplication *)application {
}

/**
 * applicationDidEnterBackground
 */

-(void)applicationDidEnterBackground:(UIApplication *)application {
}

/**
 * applicationWillEnterForeground
 */

-(void)applicationWillEnterForeground:(UIApplication *)application {
}

/**
 * applicationDidBecomeActive
 */

-(void)applicationDidBecomeActive:(UIApplication *)application {
}

/**
 * applicationWillTerminate
 */

-(void)applicationWillTerminate:(UIApplication *)application {
}

/**
 * dealloc()
 */ 

-(void)dealloc {
	[rootViewController release];
	[window release];
	
	[super dealloc];
}

@end
