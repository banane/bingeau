//
//  gameViewController.m
//  bingueau
//
//  Created by Anna on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "gameViewController.h"
#import "bingueauAppDelegate.h"
#import "resultsViewController.h"

@implementation gameViewController

@synthesize fdict; // retained from appDelegate
@synthesize startButton, callWordLabel, newWordButton, square, timerLabel; //UI objects
@synthesize selectedBoxes, keyDiscard, keyDeck, callWord, gameState,snapSound;

#pragma mark setupstuff

-(void)viewDidLoad {
	self.title = @"le Bingueau";
	bingueauAppDelegate *appDelegate = (bingueauAppDelegate *)[[UIApplication sharedApplication] delegate];
	fdict = appDelegate.fdict;	
	
	// start button?
	startButton.hidden = NO;
	newWordButton.hidden = YES;
	[super viewDidLoad];
 }

-(IBAction)startGame{
	[self setupBoard];
	[self pickWord];
	timer = [NSTimer scheduledTimerWithTimeInterval:1
									 target:self
								   selector:@selector(startClock)
								   userInfo:nil
									repeats:YES];	
	count = 0; // reset time
	
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
	
	selectedBoxes = [[[NSMutableArray alloc] init] retain];		// chosen keys
	keyDiscard = [[[NSMutableArray alloc] init] retain];			// discarded callwords
	keyDeck =  [[[NSMutableArray alloc] initWithArray:[fdict allKeys]] retain]; // available callwords to pick from
	
	// display key values in board
	for(UIView *view in [[self view] subviews ]) {
		if(view.tag < 25){
			if([view isKindOfClass:[UIButton class]]) {
				[view setBackgroundColor:[UIColor redColor]];
				//[view setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
				//[view setTextAlignment:UITextAlignmentCenter];
				[view setAlpha:0.67f];
				[view setTitle:[keysInPlay objectAtIndex:view.tag] forState:UIControlStateNormal];	
				
			}
		}
	}	
	startButton.hidden = NO;
	callWordLabel.hidden = YES;
	newWordButton.hidden = YES;
	timerLabel.hidden = NO;
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

-(void)startClock{
	count++;
	int mins = count/60;
	int seconds = count % 60;
	timerLabel.text = [NSString stringWithFormat:@"%02d:%02d",mins,seconds];
	
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

-(void)showResults{
	NSLog(@"in showresults");
	newWordButton.hidden = YES;
	startButton.hidden = NO;
	resultsViewController *rvc = [[resultsViewController alloc] initWithNibName:@"resultsViewController" bundle:nil];
	rvc.selectedBoxes = selectedBoxes;
	rvc.WordsOnBoard = keysInPlay;
	rvc.lineArray = lineArray;
	rvc.keyDiscard = keyDiscard;
	NSLog(@"timerLabel.text: %@", timerLabel.text);
	rvc.rTimeString = timerLabel.text;
	[[self navigationController] pushViewController:rvc animated:YES];

	[rvc autorelease];
}

#pragma mark gameActions

- (void)pickWord{
	int i;
	i=arc4random() % [keyDeck count];
	// get the key
	NSString *callWordKey = [keyDeck objectAtIndex:i];
	NSLog(@"callwordkey: %@", callWordKey);
	
	callWord = [fdict objectForKey:callWordKey];	

	[keyDeck removeObject:callWordKey];	
	[keyDiscard addObject:callWord];

	NSLog(@"callWord: %@", callWord);
	NSLog(@"discard pile: %@", keyDiscard);
	
	callWordLabel.text = callWord;
}

-(IBAction)newCallWord{
	[self pickWord];
}

-(void)evaluateBoard{
	int sBcount = [selectedBoxes count];
	gameState = 0;
	int lineCount = 0;
	NSLog(@"in evalboard, selectedboxes array: %d", [selectedBoxes count]);
	
	if([selectedBoxes count] > 4){
		for(int i=0;i<sBcount;i++){
			int senderTag = [[selectedBoxes objectAtIndex:i] intValue];
			NSLog(@" selectbox item ------------ %d", senderTag);
			int j=0;
			int k=0;
			
			NSLog(@"horizontal evaluation");
			int val = senderTag % 5;
			if(val == 0){ // is multiple of 5, first column
				lineCount = 1;
				lineArray = nil;
				lineArray = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:senderTag],nil];
				
				for(j=1;j<5;j++){ // evaluate potential mates
					if ([selectedBoxes containsObject:[NSNumber numberWithInt:(j+senderTag)]]){
						lineCount++;
						[lineArray addObject:[NSNumber numberWithInt:(j+senderTag)]];
					}
					
				}
				NSLog(@"the line array count is: %d, lineCount: %d", [lineArray count], lineCount);
				if(lineCount > 4){
					if([self checkWinner:lineCount]) {
						[self showResults];
						break;
					}
				}
			}
			NSLog(@"vertical evaluation");
			// check for vertical matches
			if(senderTag < 5){
				lineCount = 1;
				lineArray = nil;
				lineArray = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:senderTag], nil];
				
				for(j=1;j<5;j++){
					k = senderTag +  (j*5);
					if ([selectedBoxes containsObject:[NSNumber numberWithInt:k]]){
						[lineArray addObject:[NSNumber numberWithInt:k]];
						lineCount++;
					}
				}
				NSLog(@"the line array count is: %d, lineCount: %d", [lineArray count], lineCount);
				if(lineCount > 4){
					if([self checkWinner:lineCount]) {
						[self showResults];
						break;
					}
				}
				
			}
			if(gameState > 0) break;
			
		
			
			// check diagnoals only on corner cells
			if((senderTag == 0) || (senderTag == 4)){
				lineCount = 1;
				lineArray = nil;
				lineArray = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:senderTag],nil];
				NSLog(@"in diagonals with sender tag: %d", senderTag);
				int l = 1;
				int j;
				NSLog(@"++++++++++ selectedboxes: %@", selectedBoxes);
				for(j=1;j<5;j++){
					int k=j*5;
					if(senderTag == 0){ k = k + senderTag + l;}
					if(senderTag == 4){ k = k + senderTag - l;}
					if([selectedBoxes containsObject:[NSNumber numberWithInt:k]]){
						[lineArray addObject:[NSNumber numberWithInt:k]];
						lineCount++;
					}
					l++;
				}
				if(lineCount > 4){
					if([self checkWinner:lineCount]) {
						[self showResults];
						break;
					}
				}
			}
		}
	}
}


-(BOOL)checkWinner:(int)lineCount{
	NSLog(@"in checkwinner");
	NSLog(@"Keydiscard: %@",keyDiscard); 
	int winCount = 0;
	for(int i=0;i<lineCount; i++){
		int wordkey = [[lineArray objectAtIndex:i] intValue];
		NSLog(@"--- keysinplay: %@", keysInPlay);
		NSString *fr_word = [keysInPlay objectAtIndex:wordkey];
		NSString *eng_word = [fdict objectForKey:fr_word];
		NSLog(@"the french word is: %@  for English word: %@, for key: %d",fr_word, eng_word, wordkey);
		if([keyDiscard containsObject:eng_word]){
			NSLog(@"Yes, %@ was in the deck.", eng_word);
			winCount++;
		} else {
			NSLog(@"no, %@ was never a correct selection.",eng_word);
		}
	}
	if(winCount==5){
		[timer invalidate];
		return YES;
	} else {
		return NO;
	}
}

-(void)alertWin{
	// deprecated
	[timer invalidate];
	UIAlertView *charAlert = [[UIAlertView alloc]
							  initWithTitle:@"Félicitations!"
							  message:@"Vous êtes le champion! Vous êtes très intelligent, bien sûr."
							  delegate:nil
							  cancelButtonTitle:@"Abandonnée"
							  otherButtonTitles:nil];
	[charAlert addButtonWithTitle:@"Encore"];
	[charAlert addButtonWithTitle:@"Les Resultats"];
	
	charAlert.delegate = self;
	
	[charAlert show];
	[charAlert autorelease];	
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	// reload board
	if(buttonIndex == 1){		
		[self setupBoard];				
	}
}

- (void)dealloc {
	[keyDeck release];
	[keyDiscard release];
//	[keysInPlay release];
    [super dealloc];
}

@end

