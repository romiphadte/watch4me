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

-(void)SiriManilli{
        LanguageModelGenerator *lmGenerator = [[LanguageModelGenerator alloc] init];
    NSArray *words = [NSArray arrayWithObjects:@"OPEN", @"THE", @"DOOR", @"OPEN SESAME", @"Call Sid", @"Call Romi", nil];
    NSString *name = @"Voice Recognition";
    NSError *err = [lmGenerator generateLanguageModelFromArray:words withFilesNamed:name];
    
    NSDictionary *languageGeneratorResults = nil;
    [self.openEarsEventsObserver setDelegate:self];
    lmPath = nil;
    dicPath = nil;
	
    if([err code] == noErr) {
        
        languageGeneratorResults = [err userInfo];
		
        lmPath = [languageGeneratorResults objectForKey:@"LMPath"];
        dicPath = [languageGeneratorResults objectForKey:@"DictionaryPath"];
		
    } else {
        NSLog(@"Error: %@",[err localizedDescription]);
    }
    [self.pocketsphinxController startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath languageModelIsJSGF:NO];
}

-(void)callsid
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"14087755468"]]];
}

-(void)authorize
{
    [self.fliteController say:@"Awesome! Welcome home. Opening door!" withVoice:self.slt];
}

-(void)wrong
{
    [self.fliteController say:@"Sorry wrong password bro. Try hacking something to get past me at the next hackathon." withVoice:self.slt];
}

-(void)callromi
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"14086428972"]]];
}



-(void)tweetbitch
{
    _postText.text = @"A burgular has broken in!";
    NSString *post = [NSString stringWithFormat:@"%@", _postText.text];
    
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
