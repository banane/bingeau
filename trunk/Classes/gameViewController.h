//
//  gameViewController.h
//  bingeau
//
//  Created by Anna on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface gameViewController : UIViewController {
	NSMutableArray *keysInPlay;
	NSDictionary *fdict;
	
	IBOutlet UIButton *startButton;
	IBOutlet UILabel *callWordLabel;	
	IBOutlet UIButton *newWordButton;
	UIButton *square;
	
	NSMutableArray *selectedBoxes;
	NSMutableArray *keyDiscard;
	NSMutableArray *keyDeck;
	int gameState;
	int lineCount;
	SystemSoundID *snapSound;
	
	NSString *callWord;
	
}

@property (nonatomic, retain) NSDictionary *fdict;

@property (nonatomic, retain) IBOutlet UIButton *startButton;
@property (nonatomic, retain) IBOutlet UIButton *newWordButton;
@property (nonatomic, retain) IBOutlet UILabel *callWordLabel;
@property (nonatomic, retain) IBOutlet UIButton *square;

@property (nonatomic, retain) NSMutableArray *selectedBoxes;
@property (nonatomic, retain) NSMutableArray *keyDiscard;
@property (nonatomic, retain) NSMutableArray *keyDeck;
@property (nonatomic, retain) NSMutableArray *keysInPlay;
@property (nonatomic) int gameState;
@property (nonatomic) int lineCount;
@property (nonatomic, retain) NSString *callWord;
@property (nonatomic) SystemSoundID *snapSound;

-(IBAction)startGame;
-(IBAction)newCallWord;
-(IBAction)selectBox:(id)sender;
-(void)setupBoard;
-(void)pickWord;
-(void)evaluateBoard;
-(int)checkWinner:(int)lineCount;
-(void)alertWin;

@end
