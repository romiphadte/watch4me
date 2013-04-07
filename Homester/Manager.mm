//
//  Manager.m
//  Homester
//
//  Created by Siddhant Dange on 4/7/13.
//  Copyright (c) 2013 homester. All rights reserved.
//

#import "Manager.h"
#import <OpenEars/LanguageModelGenerator.h>

@implementation Manager

@synthesize username;
@synthesize pocketsphinxController;
@synthesize openEarsEventsObserver;
@synthesize fliteController;
@synthesize slt;

static Manager *_instance = nil;

-(void)sayHi{
    NSLog(@"Hi!");
}

<<<<<<< HEAD
-(void)SiriManilli{
=======
-(void)SiriManilli
{
    NSLog(@"0");
>>>>>>> ebc911abc0e024798a836651daebe250a8be63f4
        LanguageModelGenerator *lmGenerator = [[LanguageModelGenerator alloc] init];
    NSLog(@"1");
    NSArray *words = [NSArray arrayWithObjects:@"OPEN", @"THE", @"DOOR", @"OPEN SESAME", @"Call Sid", @"Call Romi", nil];
    NSString *name = @"Voice Recognition";
    NSLog(@"2");
    NSError *err = [lmGenerator generateLanguageModelFromArray:words withFilesNamed:name];
    NSDictionary *languageGeneratorResults = nil;
    NSLog(@"3");
    [self.openEarsEventsObserver setDelegate:self];
    lmPath = nil;
    dicPath = nil;
	NSLog(@"4");
    if([err code] == noErr) {
        
        languageGeneratorResults = [err userInfo];
		
        lmPath = [languageGeneratorResults objectForKey:@"LMPath"];
        dicPath = [languageGeneratorResults objectForKey:@"DictionaryPath"];
		
    } else {
        NSLog(@"Error: %@",[err localizedDescription]);
    }
    [self.pocketsphinxController startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath languageModelIsJSGF:NO];
}

-(void)callWithNumber:(NSString *)number
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",number]]];
}

-(void)approve:(NSString *)approvetext
{
    [self.fliteController say:approvetext withVoice:self.slt];
}

-(void)fail:(NSString *)denytext
{
    [self.fliteController say:denytext withVoice:self.slt];
}

-(void)socialParse
{
    
}

-(void)callromi
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"14086428972"]]];
}



-(void)setTweetWithMessage:(NSString *)message
{
    NSString *post = [NSString stringWithFormat:@"%@", message];
    
    if (post.length >= 141) {
        NSLog(@"Tweet won't be sent.");
    } else {
        ACAccountStore *accountStoreTw = [[ACAccountStore alloc] init];
        ACAccountType *accountTypeTw = [accountStoreTw accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        [accountStoreTw requestAccessToAccountsWithType:accountTypeTw options:NULL completion:^(BOOL granted, NSError *error) {
            if(granted) {
                
                NSArray *accountsArray = [accountStoreTw accountsWithAccountType:accountTypeTw];
                
                if ([accountsArray count] > 0) {
                    ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                    
                    SLRequest* twitterRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                                   requestMethod:SLRequestMethodPOST
                                                                             URL:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"]
                                                                      parameters:[NSDictionary dictionaryWithObject:post forKey:@"status"]];
                    
                    [twitterRequest setAccount:twitterAccount];
                    
                    [twitterRequest performRequestWithHandler:^(NSData* responseData, NSHTTPURLResponse* urlResponse, NSError* error) {
                        NSLog(@"%@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                        
                        NSTimer *currentTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(socialParse) userInfo:nil repeats:YES];
                        
                    }];
                    
                }
                
            }
            
        }];
        _postText.text = [NSString stringWithFormat:@""];
        
    }
    _charCounter.text = [NSString stringWithFormat:@"140"];
}

+(Manager*)sharedInstance{
	@synchronized([Manager class])
	{
		if (_instance == nil)
			_instance = [[self alloc] init];
        
		return _instance;
	}
    
	return nil;
}

#ifdef __cplusplus

#endif

@end
