//
//  Manager.m
//  Homester
//
//  Created by Siddhant Dange on 4/7/13.
//  Copyright (c) 2013 homester. All rights reserved.
//

#import "Manager.h"
#import <OpenEars/LanguageModelGenerator.h>
#include "PracticalSocket.h"  // For Socket and SocketException
#include <iostream>           // For cerr and cout
#include <cstdlib>            // For atoi()


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

-(void)checkfortweet
{
    /// [self sharet];
    username = @"ischoolerz";
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        if (granted) {
            
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            
            // Check if the users has setup at least one Twitter account
            
            if (accounts.count > 0)
            {
                ACAccount *twitterAccount = [accounts objectAtIndex:0];
                
                // Creating a request to get the info about a user on Twitter
                
                SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"] parameters:[NSDictionary dictionaryWithObject:username forKey:@"screen_name"]];
                [twitterInfoRequest setAccount:twitterAccount];
                
                // Making the request
                
                [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        // Check if we reached the reate limit
                        
                        if ([urlResponse statusCode] == 429) {
                            NSLog(@"Rate limit reached");
                            return;
                        }
                        
                        // Check if there was an error
                        
                        if (error) {
                            NSLog(@"Error: %@", error.localizedDescription);
                            return;
                        }
                        
                        // Check if there is some response data
                        
                        if (responseData) {
                            
                            NSError *error = nil;
                            NSArray *TWData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                            
                            
                            // Filter the preferred data
                            
                            
                            NSString *lastTweet = [[(NSDictionary *)TWData objectForKey:@"status"] objectForKey:@"text"];
                            lastTweetTextView.text= lastTweet;
                            NSString *numberString;
                            NSScanner *scanner = [NSScanner scannerWithString:lastTweet];
                            NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
                            [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
                            
                            // Collect numbers.
                            [scanner scanCharactersFromSet:numbers intoString:&numberString];
                            NSLog(numberString);
                            parsednumber = numberString;
                            [self callWithNumber:parsednumber];
                            // Result.
                            //long int number = [numberString integerValue];
                            // [self checkforphone:numberString];
                        }
                    });
                }];
            }
        } else {
            NSLog(@"No access granted");
        }
    }];
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
using namespace std;

const int RCVBUFSIZE = 32;    // Size of receive buffer

int setupTCP(string servAddress, char *echoString, unsigned short echoServPort) {
    
    int echoStringLen = strlen(echoString);   // Determine input length
    
    try {
        // Establish connection with the echo server
        TCPSocket sock(servAddress, echoServPort);
        
        // Send the string to the echo server
        sock.send(echoString, echoStringLen);
        
        char echoBuffer[RCVBUFSIZE + 1];    // Buffer for echo string + \0
        int bytesReceived = 0;              // Bytes read on each recv()
        int totalBytesReceived = 0;         // Total bytes read
        // Receive the same string back from the server
        cout << "Received: ";               // Setup to print the echoed string
        while (totalBytesReceived < echoStringLen) {
            // Receive up to the buffer size bytes from the sender
            if ((bytesReceived = (sock.recv(echoBuffer, RCVBUFSIZE))) <= 0) {
                cerr << "Unable to read";
                exit(1);
            }
            totalBytesReceived += bytesReceived;     // Keep tally of total bytes
            echoBuffer[bytesReceived] = '\0';        // Terminate the string!
            cout << echoBuffer;                      // Print the echo buffer
        }
        cout << endl;
        
        // Destructor closes the socket
        
    } catch(SocketException &e) {
        cerr << e.what() << endl;
        exit(1);
    }
    
    return 0;
}

#endif

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
