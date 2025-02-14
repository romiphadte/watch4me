//
//  Manager.h
//  Homester
//
//  Created by Siddhant Dange on 4/7/13.
//  Copyright (c) 2013 homester. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenEars/PocketsphinxController.h>
#import <OpenEars/OpenEarsEventsObserver.h>
#import <Slt/Slt.h>
#import <OpenEars/FliteController.h>
#import "Manager.h"

@interface Manager : NSObject{
    FliteController *flitecontroller;
    IBOutlet UITextView *lastTweetTextView;
    NSString *username;
    NSString *output;
    NSString *parsednumber;
    NSString *lmPath;
    NSString *dicPath;
    SLComposeViewController *myslcomposersheet;
    PocketsphinxController *pocketsphinxController;
    OpenEarsEventsObserver *openEarsEventsObserver;
    Slt *slt;
    UIImageView *imageskm;
}


@property (nonatomic, retain) NSString *username;
@property (strong, nonatomic) PocketsphinxController *pocketsphinxController;
@property (strong, nonatomic) OpenEarsEventsObserver *openEarsEventsObserver;
@property (strong, nonatomic) FliteController *fliteController;
@property (strong, nonatomic) Slt *slt;
@property (weak, nonatomic) IBOutlet UITextView *postText;
@property (weak, nonatomic) IBOutlet UILabel *charCounter;
@property BOOL _suspicionArised;


-(void)sayHi;
- (void)setTweetWithMessage:(NSString *)message;
- (void)SiriManilli;
- (void)callWithNumber:(NSString *)number;
- (void)callromi;
- (void)checkfortweet;
- (void)approve:(NSString *)approvetext;
- (void)fail:(NSString *)denytext;
+(Manager*)sharedInstance;

@end
