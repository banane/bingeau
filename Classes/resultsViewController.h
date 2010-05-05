//
//  resultsViewController.h
//  bingueau
//
//  Created by Anna on 5/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface resultsViewController : UIViewController {
	NSMutableArray *WordsOnBoard;
	NSMutableArray *selectedBoxes;
	NSMutableArray *lineArray;
	NSDictionary *fdict;
	NSMutableArray *keyDiscard;
//	NSMutableArray *selectedWordArray;
	
	IBOutlet UITextView *rWinWordsTextView;
	IBOutlet UITextView *rMissedWordsTextView;
	IBOutlet UITextView *rWrongMatchesTextView;
	IBOutlet UIImageView *rImageView;
	IBOutlet UILabel *finalTime;
	IBOutlet NSString *rTimeString;

}

@property (nonatomic, retain) NSMutableArray *WordsOnBoard;
@property (nonatomic, retain) NSMutableArray *lineArray;
@property (nonatomic, retain) NSMutableArray *selectedBoxes;
@property (nonatomic, retain) NSDictionary *fdict;
@property (nonatomic, retain) NSMutableArray *keyDiscard;
@property (nonatomic, retain) IBOutlet UITextView *rWinWordsTextView;
@property (nonatomic, retain) IBOutlet UITextView *rMissedWordsTextView;
@property (nonatomic, retain) IBOutlet UITextView *rWrongMatchesTextView;
@property (nonatomic, retain) IBOutlet UIImageView *rImageView;
@property (nonatomic, retain) IBOutlet UILabel *finalTime;
@property (nonatomic, retain) NSString *rTimeString;

@end
