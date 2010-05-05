//
//  gameViewController.h
//  bingueau
//
//  Created by Anna on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface gameViewController : UIViewController {
	NSMutableArray *keysInPlay;
	NSDictionary *fdict;
	NSMutableArray *selectedBoxes;
	NSMutableArray *keyDiscard;
	NSMutableArray *keyDeck;
	NSMutableArray *lineArray;
	
	IBOutlet UIButton *startButton;
	IBOutlet UILabel *callWordLabel;	
	IBOutlet UIButton *newWordButton;
	UIButton *square;
	IBOutlet UILabel *timerLabel;	
	
	int gameState;
	SystemSoundID snapSound;
	
	NSString *callWord;
	NSTimer *timer;
	int count;
	
}

@property (nonatomic, retain) NSDictionary *fdict;

@property (nonatomic, retain) IBOutlet UIButton *startButton;
@property (nonatomic, retain) IBOutlet UIButton *newWordButton;
@property (nonatomic, retain) IBOutlet UIButton *square;
@property (nonatomic, retain) IBOutlet UILabel *callWordLabel;
@property (nonatomic, retain) IBOutlet UILabel *timerLabel;

@property (nonatomic, retain) NSMutableArray *selectedBoxes;
@property (nonatomic, retain) NSMutableArray *keyDiscard;
@property (nonatomic, retain) NSMutableArray *keyDeck;
//@property (nonatomic, retain) NSMutableArray *keysInPlay;
@property (nonatomic) int gameState;
@property (nonatomic, retain) NSString *callWord;
@property (nonatomic) SystemSoundID snapSound;

-(IBAction)startGame;
-(IBAction)newCallWord;
-(IBAction)selectBox:(id)sender;
-(void)setupBoard;
-(void)pickWord;
-(void)evaluateBoard;
-(BOOL)checkWinner:(int)lineCount;
-(void)alertWin;
-(void)playSnap;
-(void)startClock;
-(void)showResults;

@end
