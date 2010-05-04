//
//  gameViewController.m
//  bingeau
//
//  Created by Anna on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "gameViewController.h"
#import "bingeauAppDelegate.h"

@implementation gameViewController

@synthesize fdict; // retained from appDelegate
@synthesize startButton, callWordLabel, newWordButton, square; //UI objects
@synthesize selectedBoxes, keyDiscard, keyDeck, callWord, gameState, lineCount, keysInPlay,snapSound;

#pragma mark setupstuff

-(void)viewDidLoad {
	bingeauAppDelegate *appDelegate = (bingeauAppDelegate *)[[UIApplication sharedApplication] delegate];
	fdict = appDelegate.fdict;	
	
	
	[self setupBoard];
	[self pickWord];

	[super viewDidLoad];
 }

-(IBAction)startGame{
	startButton.hidden = YES;
	callWordLabel.hidden = NO;
	newWordButton.hidden = NO;
}


-(void)setupBoard{
	keysInPlay = [[[NSMutableArray alloc] init] retain];
	NSArray *keys = [fdict allKeys];

	// gather 25 and assign
	int i;
	while([keysInPlay count]<25){
		i=arc4random() % [keys count];
		if(![keysInPlay containsObject:[keys objectAtIndex:i]]){
			[keysInPlay addObject:[keys objectAtIndex:i]];
		}
	}
	
	selectedBoxes = [[NSMutableArray alloc] init];		// chosen keys
	keyDiscard = [[NSMutableArray alloc] init];			// discarded callwords
	keyDeck =  [[NSMutableArray alloc] initWithArray:[fdict allKeys]]; // available callwords to pick from
	
	// display key values in board
	for(UIView *view in [[self view] subviews ]) {
		if(view.tag < 25){
			if([view isKindOfClass:[UIButton class]]) {
				[view setBackgroundColor:[UIColor redColor]];
				[view setAlpha:0.67f];
				[view setTitle:[keysInPlay objectAtIndex:view.tag] forState:UIControlStateNormal];						
			}
		}
	}	
	startButton.hidden = NO;
	callWordLabel.hidden = YES;
	newWordButton.hidden = YES;
	
}

#pragma mark UI animation

-(IBAction)selectBox:(id)sender{
	NSLog(@"in the selectbox");
	[self playSnap];
	switch ([selectedBoxes containsObject:[NSNumber numberWithInt:[sender tag]]]) {
		case YES:
			// toggle off
			[selectedBoxes removeObject:[NSNumber numberWithInt:[sender tag]]];
			[sender setBackgroundColor:[UIColor redColor]];
			[sender setAlpha:0.67f];
			break;
		case NO:
			//toggle on
			[selectedBoxes addObject:[NSNumber numberWithInt:[sender tag]]];
			[sender setBackgroundColor:[UIColor whiteColor]];
			[sender setAlpha:1.0f];
			[self evaluateBoard];
			break;
		default:
			break;
	}
}


#pragma mark gameActions

- (void)pickWord{
	int i;
	i=arc4random() % [keyDeck count];
	
	callWord = [fdict objectForKey:[keyDeck objectAtIndex:i]];
	[keyDeck removeObject:callWord];
	NSLog(@"callWord: %@", callWord);
	
	callWordLabel.text = callWord;
}

-(IBAction)newCallWord{
	[keyDiscard addObject:callWord];	
	[self pickWord];
}

-(void)evaluateBoard{
	gameState = 0;
	if([selectedBoxes count] > 4){	
		
		for(int i=0; i<[selectedBoxes count]; i++){
			int senderTag = [[selectedBoxes objectAtIndex:i] intValue];
			int j=0;
			int k=0;
			
			// check for vertical matches
			if(senderTag < 5){
				NSLog(@"vertical evaluation");
				lineCount = 1;
				NSLog(@"sendertag: %d",senderTag);
				
				for(j=1;j<5;j++){
					k = senderTag + (j*5);
					NSLog(@"k: %d", k);
					if ([selectedBoxes containsObject:[NSNumber numberWithInt:k]]){
						lineCount++;
					} else{
						NSLog(@"k not in selectboxes");
						break;
					}
					k=0;
				}
				lineCount = [self checkWinner:lineCount];
			}
			
			int val = senderTag % 5;
			if(val == 0) { // is multiple of 5, first column
				NSLog(@"vertical evaluation");
				lineCount = 1;
				for(j=1;j<5;j++){ // evaluate potential mates
					if ([selectedBoxes containsObject:[NSNumber numberWithInt:(j+senderTag)]]){
						lineCount++;
					} else {
						break;
					}
				}
				lineCount = [self checkWinner:lineCount];
			}
			// check diagnoals only on corner cells
			if((senderTag == 0) || (senderTag == 4)){
				NSLog(@"in diagonals with st: %d", senderTag);
				NSLog(@"%@", selectedBoxes);
				int inc = 1;
				for(j=1;j<24;j++){
					j=j*5;
					if([selectedBoxes containsObject:[NSNumber numberWithInt:(senderTag + j + inc)]]){
						lineCount++;
					}
					if(senderTag ==0){
						inc--;
					}else{
						inc++;
					}
				}
				lineCount = [self checkWinner:lineCount];
			}
		}
	}
}


-(int)checkWinner:(int)lineCount{
	if(gameState ==0){
		if(lineCount > 4){
			gameState = 1;
			//		NSLog(@"we have a winner! horizontally. SenderTag: %d, linecount: %d", senderTag, lineCount);
			[self alertWin];
		} else {
			lineCount = 0;
		}	
		return lineCount;
	} else{
		return 0;
	}
}

-(void)playSnap{
	NSString *sndpath = [[NSBundle mainBundle] pathForResource:@"snap" ofType:@"wav"];
	CFURLRef baseURL = (CFURLRef)[NSURL fileURLWithPath:sndpath];

	// Identify it as not a UI Sound
	AudioServicesCreateSystemSoundID(baseURL, &snapSound);
	AudioServicesPropertyID flag = 0;  // 0 means always play
	AudioServicesSetProperty(kAudioServicesPropertyIsUISound, sizeof(SystemSoundID), &snapSound, sizeof(AudioServicesPropertyID), &flag);
	AudioServicesPlaySystemSound(snapSound);		
}

-(void)alertWin{
//	[timer invalidate];
	UIAlertView *charAlert = [[UIAlertView alloc]
							  initWithTitle:@"Félicitations!"
							  message:@"Vous êtes le champion! Vous êtes très intelligent, bien sûr."
							  delegate:nil
							  cancelButtonTitle:@"Cancel"
							  otherButtonTitles:nil];
	[charAlert addButtonWithTitle:@"Encore!"];
	
	charAlert.delegate = self;
	
	[charAlert show];
	[charAlert autorelease];	
}

- (void)dealloc {
    [super dealloc];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	// reload board
	if(buttonIndex == 1){		
		[self setupBoard];
				
	}
}

@end

