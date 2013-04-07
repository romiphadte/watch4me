//
//  SoundView.m
//  Homester
//
//  Created by Siddhant Dange on 4/6/13.
//  Copyright (c) 2013 homester. All rights reserved.
//

#import "SoundView.h"
#import <OpenEars/LanguageModelGenerator.h>



@interface SoundView ()

@end

@implementation SoundView

@synthesize username;
@synthesize pocketsphinxController;
@synthesize openEarsEventsObserver;
@synthesize fliteController;
@synthesize slt;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

-(void)sharet
{
    {
        if ([SLComposeViewController isAvailableForServiceType: SLServiceTypeTwitter])
        {
            myslcomposersheet = [[SLComposeViewController alloc] init];
            myslcomposersheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            NSString* string = @"@";
            //string = [string stringByAppendingString:twitterUsername];
            [myslcomposersheet setInitialText: string];
            //[myslcomposersheet addImage:[UIImage imageNamed:@"screen.png"]];
            [self presentViewController:myslcomposersheet animated:YES completion:nil];
        }
        [myslcomposersheet setCompletionHandler:^
         (SLComposeViewControllerResult result) {
             switch (result) {
                 case SLComposeViewControllerResultCancelled:
                     //   output = @"Uh oh! Tweet not posted! Press cancel to leave.";
                     break;break;
                 case SLComposeViewControllerResultDone:
                     //     output = @"Tweet Success! Points rewarded!";
                     //[self progressbaradvance];
                     // NSLog(@"Successful");
                     
                     break;
                     
                 default:
                     break;
             }
             
             //UIAlertView *alert = [[UIAlertView alloc]
             //              initWithTitle:@"Twitter" message:output delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             //[alert show];
         }];
    }
}
- (IBAction)recognizer:(id)sender {
    [self.pocketsphinxController startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath languageModelIsJSGF:NO];
}


-(void)sharef
{
    if ([SLComposeViewController isAvailableForServiceType: SLServiceTypeFacebook])
    {
        myslcomposersheet = [[SLComposeViewController alloc] init];
        myslcomposersheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [myslcomposersheet setInitialText:@"Check out the Evergreen Valley High School app on iTunes! http://bit.ly/ULeRwS"];
        [myslcomposersheet addImage:[UIImage imageNamed:@"screen.png"]];
        [self presentViewController:myslcomposersheet animated:YES completion:nil];
    }
    [myslcomposersheet setCompletionHandler:^
     (SLComposeViewControllerResult result) {
         switch (result) {
             case SLComposeViewControllerResultCancelled:
                 output = @"Uh oh! We weren't able to post.";
                 break;
             case SLComposeViewControllerResultDone:
                 output = @"Posted!";
                 //[Flurry logEvent:@"Shared to Facebook"];
                 NSLog(@"Successful");
                 break;
                 
             default:
                 break;
         }
         UIAlertView *alert = [[UIAlertView alloc]
                               initWithTitle:@"Facebook" message:output delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
         
     }];
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


- (IBAction)checktweet:(id)sender {
    [self checkfortweet];
    [self checkforphone:parsednumber];
}
- (IBAction)check:(id)sender {
    [self checkfortweet];
    [self checkforphone:parsednumber];
}

-(void)youdostuff
{
    [self checkfortweet];
    [self checkforphone:parsednumber];
}
-(void)checkfortweet
{
   /// [self sharet];
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

- (IBAction)voice:(id)sender {
    [self.fliteController say:@"Hey. You fucking intruder. Get the fuckity fuck away from my door. Fuckin shit man." withVoice:self.slt];
}


-(void)checkforphone:(NSString *)number
{
    NSString *phonenum = lastTweetTextView.text;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",parsednumber]]];
}



- (void)viewDidLoad
{
    LanguageModelGenerator *lmGenerator = [[LanguageModelGenerator alloc] init];
    username = @"theashbhat";
    [self checkfortweet];
    [super viewDidLoad];
    
    NSArray *words = [NSArray arrayWithObjects:@"OPEN", @"THE", @"DOOR", @"OPEN SESAME", nil];
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
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
	NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID);
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
