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

-(void)SiriManilli
{
    LanguageModelGenerator *lmGenerator = [[LanguageModelGenerator alloc] init];
    _postText.delegate = self;
    NSArray *words = [NSArray arrayWithObjects: @"OPEN SESAME", @"Call Romi", @"Call Ash", nil];
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
	// Do any additional setup after loading the view.
    
    
    
    /*
    NSLog(@"0");
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
     */
}

- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
	NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID);
    if ([hypothesis isEqual: @"CALL ASH"]) {
        [self callWithNumber:@"14083874931"];
    }
    else if ([hypothesis isEqual:@"Call Romi"]) {
        [self callromi];
    }
    else if ([hypothesis isEqual:@"OPEN SESAME"]) {
        [self approve:@"Awesome! Welcome home!"];
    }
    else {
        [self fail:@"You have failed. Please try a new hack. No access."];
    }
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

- (OpenEarsEventsObserver *)openEarsEventsObserver {
	if (openEarsEventsObserver == nil) {
		openEarsEventsObserver = [[OpenEarsEventsObserver alloc] init];
	}
	return openEarsEventsObserver;
}

- (PocketsphinxController *)pocketsphinxController {
	if (pocketsphinxController == nil) {
		pocketsphinxController = [[PocketsphinxController alloc] init];
	}
	return pocketsphinxController;
}

- (FliteController *)fliteController {
	if (fliteController == nil) {
		fliteController = [[FliteController alloc] init];
	}
	return fliteController;
}

- (Slt *)slt {
	if (slt == nil) {
		slt = [[Slt alloc] init];
	}
	return slt;
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

- (void) pocketsphinxDidStartCalibration {
	NSLog(@"Pocketsphinx calibration has started.");
}

- (void) pocketsphinxDidCompleteCalibration {
	NSLog(@"Pocketsphinx calibration is complete.");
}

- (void) pocketsphinxDidStartListening {
	NSLog(@"Pocketsphinx is now listening.");
}

- (void) pocketsphinxDidDetectSpeech {
	NSLog(@"Pocketsphinx has detected speech.");
}

- (void) pocketsphinxDidDetectFinishedSpeech {
	NSLog(@"Pocketsphinx has detected a period of silence, concluding an utterance.");
}

- (void) pocketsphinxDidStopListening {
	NSLog(@"Pocketsphinx has stopped listening.");
}

- (void) pocketsphinxDidSuspendRecognition {
	NSLog(@"Pocketsphinx has suspended recognition.");
}

- (void) pocketsphinxDidResumeRecognition {
	NSLog(@"Pocketsphinx has resumed recognition.");
}

- (void) pocketsphinxDidChangeLanguageModelToFile:(NSString *)newLanguageModelPathAsString andDictionary:(NSString *)newDictionaryPathAsString {
	NSLog(@"Pocketsphinx is now using the following language model: \n%@ and the following dictionary: %@",newLanguageModelPathAsString,newDictionaryPathAsString);
}

- (void) pocketSphinxContinuousSetupDidFail { // This can let you know that something went wrong with the recognition loop startup. Turn on OPENEARSLOGGING to learn why.
	NSLog(@"Setting up the continuous recognition loop has failed for some reason, please turn on OpenEarsLogging to learn more.");
}

@end
