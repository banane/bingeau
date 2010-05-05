//
//  bingueauAppDelegate.m
//  bingueau
//
//  Created by Anna & Mary on 5/1/10.
//  Copyright banane.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@class gameViewController;

@interface bingueauAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
	NSDictionary *fdict;
	SystemSoundID mySound;
    UINavigationController *navCtrl;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navCtrl;

@property (nonatomic, retain) NSDictionary *fdict;
@property (nonatomic) SystemSoundID mySound;


-(void)setupForeignDictionary;
-(void)playStartupSound;

@end

