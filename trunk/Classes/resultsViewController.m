//
//  resultsViewController.m
//  bingueau
//
//  Created by Anna on 5/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "resultsViewController.h"
#import "gameViewController.h"
#import "bingueauAppDelegate.h"


@implementation resultsViewController
@synthesize WordsOnBoard;
@synthesize rWinWordsTextView;
@synthesize lineArray;
@synthesize fdict;
@synthesize selectedBoxes;
@synthesize rMissedWordsTextView;
@synthesize rImageView;
@synthesize finalTime;
@synthesize rTimeString;
@synthesize keyDiscard;
@synthesize rWrongMatchesTextView;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	NSLog(@"in rvc view did load");
	NSLog(@"%@ <--timeString in rvc ", rTimeString);
	finalTime.text = rTimeString;
	bingueauAppDelegate *appDelegate  = (bingueauAppDelegate *)[[UIApplication sharedApplication] delegate];
	fdict = [appDelegate.fdict retain];
	
	NSArray *keys = [fdict allKeys];
	
	rWinWordsTextView.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
	NSString *winWS = @"";
	int i;
	for(i=0;i<5;i++){
		int wordkey = [[lineArray objectAtIndex:i] intValue];
		NSString *s = [WordsOnBoard objectAtIndex:wordkey];
		winWS = [winWS stringByAppendingFormat:@"%@ ", s];
		winWS = [winWS stringByAppendingFormat:@"(%@)",[fdict objectForKey:s]];
		if(i<4){
			winWS = [winWS stringByAppendingFormat:@","];
		}
		
	}	
	rWinWordsTextView.text = winWS;

	// wrong matches, it's selected but shoudln't be
	rWrongMatchesTextView.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
	NSString *wrongWS = @"";
	NSLog(@"%@", selectedBoxes);

	for(i=0; i<[selectedBoxes count];i++){
		int wordkey = [[selectedBoxes objectAtIndex:i] intValue];
		NSLog(@"%d wordkey", wordkey);
		NSString *fr_word = [WordsOnBoard objectAtIndex:wordkey];
		NSLog(@"%@ fr_word", fr_word);
		NSString *eng_word = [fdict objectForKey:fr_word];
		NSLog(@"%@ eng_word", eng_word);
		if(![keyDiscard containsObject:eng_word]){
			wrongWS = [wrongWS stringByAppendingFormat:@"%@ (%@)", fr_word, eng_word];
			if(i<4){
				wrongWS = [wrongWS stringByAppendingFormat:@","];
			}			
		}		
	}
	rWrongMatchesTextView.text = wrongWS;
	
	
	rWinWordsTextView.text = winWS;
	
	// missed chances, eng. word was there but not selected
	rMissedWordsTextView.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
	NSString *missWS = @"";
	NSLog(@"%@", selectedBoxes);
	
	/*for(i=0; i<[keyDiscard count];i++){
		NSString *eng_word = [keyDiscard objectAtIndex:i];
		NSArray *keys_ob = [fdict allKeysForObject:eng_word];
		for(NSString *fr_word in keys_ob){
			int fr_key = [[keys indexOfObject:fr_word] intValue];
			if([WordsOnBoard containsObject:fr_key]){
				missWS = [missWS  stringByAppendingFormat:@"%@ (%@)", fr_word, eng_word];
			}
			if(i<4){
				missWS = [missWS stringByAppendingFormat:@","];
			}			
		}		
	}*/
	rMissedWordsTextView.text = missWS;

	// store levels and show here that it's a first level and sartre.
	UIImage *img1 = [UIImage imageNamed:@"sartre0.png"];
	UIImage *img2 = [UIImage imageNamed:@"sartre2.png"];
	NSArray *imgArray = [[NSArray alloc] initWithObjects:img1, img2, nil];
	rImageView.animationImages = imgArray;
	rImageView.animationDuration = 2.0f;
	rImageView.animationRepeatCount = 3;
	
	[rImageView startAnimating]; 	
			
			
			
	
	
/*	self.title = @"Results";
	// two buttons for higher level or back to same level
	NSLog(@"in the viewdidload");
	NSLog(@"%d <-- keysinplay count", [WordsOnBoard count]);


/*	NSMutableArray *selectedWordArray = [[NSMutableArray alloc] init];
	for(int i=0;i<[selectedBoxes count];i++){
		int *wordKey = [selectedBoxes objectAtIndex:[NSNumber numberWithInt:i]];
		[selectedWordArray addObject:[keys objectAtIndex:[NSNumber numberWithInt:wordKey]]];
	}
	NSLog(@"%d", [selectedWordArray count]);*/

}

#pragma mark -
#pragma mark Table view methods

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	[super viewDidUnload];
}


- (void)dealloc {
//	[keysInPlay release];
	[fdict release];
    [super dealloc];
}


@end

