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

@interface SoundView : UIViewController
{
    IBOutlet UITextView *lastTweetTextView;
    NSString *username;
}

@property (nonatomic, retain) NSString *username;


@end
