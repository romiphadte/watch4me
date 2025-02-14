//
//  SoundView.h
//  Homester
//
//  Created by Siddhant Dange on 4/6/13.
//  Copyright (c) 2013 homester. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenEars/PocketsphinxController.h>
#import <OpenEars/OpenEarsEventsObserver.h>
#import <Slt/Slt.h>
#import <OpenEars/FliteController.h>
#import "Manager.h"


@interface SoundView : UIViewController<OpenEarsEventsObserverDelegate>{
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


- (IBAction)sharePost:(id)sender;
-(void)youdostuff;
- (void)postImage:(UIImage *)image withStatus:(NSString *)status;

@end
