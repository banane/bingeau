//
//  bingueauAppDelegate.m
//  bingueau
//
//  Created by Anna & Mary on 5/1/10.
//  Copyright banane.com 2010. All rights reserved.
//

#import "bingueauAppDelegate.h"
#import "gameViewController.h"
#import "resultsViewController.h"

@implementation bingueauAppDelegate

@synthesize window, fdict,mySound, navCtrl ;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

	
    [window addSubview:[navCtrl view]];
    [window makeKeyAndVisible];

	[self playStartupSound];
	
	[self setupForeignDictionary];
	
	return YES;
}

-(void)setupForeignDictionary{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"bingo" ofType:@"xml"];
	fdict =[[NSDictionary alloc] initWithContentsOfFile:path];	
	NSLog(@"size of foriegn dictionary %d", [fdict count]);

}	

-(void)playStartupSound{
	// setup sound

	NSString *sndpath = [[NSBundle mainBundle] pathForResource:@"bingueau" ofType:@"wav"];
	CFURLRef baseURL = (CFURLRef)[NSURL fileURLWithPath:sndpath];
	
	
	// Identify it as not a UI Sound
    AudioServicesCreateSystemSoundID(baseURL, &mySound);
	AudioServicesPropertyID flag = 0;  // 0 means always play
	AudioServicesSetProperty(kAudioServicesPropertyIsUISound, sizeof(SystemSoundID), &mySound, sizeof(AudioServicesPropertyID), &flag);
	AudioServicesPlaySystemSound(mySound);		
}


- (void)dealloc {
	[window release];
    [super dealloc];
}


@end
