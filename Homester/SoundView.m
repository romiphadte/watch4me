//
//  SoundView.m
//  Homester
//
//  Created by Siddhant Dange on 4/6/13.
//  Copyright (c) 2013 homester. All rights reserved.
//

#import "SoundView.h"
#import <OpenEars/LanguageModelGenerator.h>
#import "Manager.h"


@interface SoundView ()
@property (nonatomic, strong) ACAccountStore *accountStore;
@end

@implementation SoundView

@synthesize username;
@synthesize pocketsphinxController;
@synthesize openEarsEventsObserver;
@synthesize fliteController;
@synthesize slt;


- (id)init
{
    self = [super init];
    if (self) {
        _accountStore = [[ACAccountStore alloc] init];
    }
    return self;
}

-(void)checktwitter
{
    
}

- (void)viewDidLoad
{
    //[[Manager sharedInstance] setTweetWithMessage:@"test"];
    //sends tweet with specified string
    
    
    [[Manager sharedInstance] checkfortweet];
    //parses a tweeted phonenumber and calls from iSchoolerz
    
    
   // [[Manager sharedInstance] SiriManilli];
    //voice recognition. Open sesami to open, any thing else for rejection
    
    
   // [[Manager sharedInstance] callWithNumber:@"14083874931"];
    //calls person with this number automatedly
    
    
    //[[Manager sharedInstance] callromi];
    
    
  // [[Manager sharedInstance] approve:@"Awesome! Welcome home!"];
    //approved method with string on approval
    
  //  [[Manager sharedInstance] fail:@"You have failed. Please try a new hack. No access."];
    //denial message with string for denial
    
    
    
 /* imageskm.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                             [NSURL URLWithString:@"http://www.openmicroscopy.org/site/support/ome-artwork/ome-icon-black-on-white-32.png"]]];
    [self postImage:imageskm.image withStatus:@"hi"];*/
}
/*
}
    //[[Manager sharedInstance] tweetbitch];
   // [[Manager sharedInstance] SiriManilli];
 NSTimer *currentTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(checktwitter) userInfo:nil repeats:YES];
    
    [currentTimer fire];
    imageskm.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                             [NSURL URLWithString:@"http://www.openmicroscopy.org/site/support/ome-artwork/ome-icon-black-on-white-32.png"]]];
*/
/*- (void)postImage:(UIImage *)image withStatus:(NSString *)status
    [self shareposted];
    UIImage *image2 = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.openmicroscopy.org/site/support/ome-artwork/ome-icon-black-on-white-32.png"]]];
    [self postImage:image2 withStatus:@"intruder alert!"];
    NSLog(@"gets here");
    LanguageModelGenerator *lmGenerator = [[LanguageModelGenerator alloc] init];
    username = @"theashbhat";
    //[self checkfortweet];
    [super viewDidLoad];
    _postText.delegate = self;
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
	// Do any additional setup after loading the view.
}

/*
-(void)shareposted{
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
                                                 //update.json
                                                                      parameters:[NSDictionary dictionaryWithObject:post forKey:@"status"]];
                    NSData *imageData = UIImageJPEGRepresentation(imageskm.image, 1.f);
                    [twitterRequest addMultipartData:imageData
                                            withName:@"media[]"
                                                type:@"image/jpeg"
                                            filename:@"image.jpg"];
                    
                    [twitterRequest setAccount:twitterAccount];
                    
                    [twitterRequest performRequestWithHandler:^(NSData* responseData, NSHTTPURLResponse* urlResponse, NSError* error) {
                        NSLog(@"%@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                        
                    }];
                    
                }
                
            }
            
        }];
        _postText.text = [NSString stringWithFormat:@"test"];
        
    }
    _charCounter.text = [NSString stringWithFormat:@"140"];
    
    
}
*//*
- (void)postImage:(UIImage *)image withStatus:(NSString *)status
{
    ACAccountType *twitterType =
    [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    SLRequestHandler requestHandler =
    ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (responseData) {
            NSInteger statusCode = urlResponse.statusCode;
            if (statusCode >= 200 && statusCode < 300) {
                NSDictionary *postResponseData =
                [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers
                                                  error:NULL];
                NSLog(@"[SUCCESS!] Created Tweet with ID: %@", postResponseData[@"id_str"]);
            }
            else {
                NSLog(@"[ERROR] Server responded: status code %d %@", statusCode,
                      [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
            }
        }
        else {
            NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
        }
    };
    
    ACAccountStoreRequestAccessCompletionHandler accountStoreHandler =
    ^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [self.accountStore accountsWithAccountType:twitterType];
            NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                          @"/1.1/statuses/update_with_media.json"];
            NSDictionary *params = @{@"status" : status};
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                    requestMethod:SLRequestMethodPOST
                                                              URL:url
                                                       parameters:params];
            NSData *imageData = UIImageJPEGRepresentation(image, 1.f);
            [request addMultipartData:imageData
                             withName:@"media[]"
                                 type:@"image/jpeg"
                             filename:@"image.jpg"];
            [request setAccount:[accounts lastObject]];
            [request performRequestWithHandler:requestHandler];
        }
        else {
            NSLog(@"[ERROR] An error occurred while asking for user authorization: %@",
                  [error localizedDescription]);
        }
    };
    
    [self.accountStore requestAccessToAccountsWithType:twitterType
                                               options:NULL
                                            completion:accountStoreHandler];
}

*/
/*
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
	NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID);
    if ([hypothesis isEqual: @"Call Sid"]) {
        [self callsid];
    }
    else if ([hypothesis isEqual:@"Call Romi"]) {
        [self callromi];
    }
    else if ([hypothesis isEqual:@"OPEN SESAME"]) {
        [self authorize];
    }
    else {
        [self wrong];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _accountStore = [[ACAccountStore alloc] init];
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
    [self.fliteController say:@"Sorry wrong password bro. Try hacking something to get past me at the next hack awww thon." withVoice:self.slt];
}


-(void)checkforphone:(NSString *)number
{
    NSString *phonenum = lastTweetTextView.text;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",parsednumber]]];
}

- (void)viewDidAppear:(BOOL)animated {
    [_postText becomeFirstResponder];
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger length;
    length = [_postText.text length];
    NSInteger number;
    number = 140-length;
    _charCounter.text = [NSString stringWithFormat:@"%u", number];
    
    if (length >= 141) {
        _charCounter.text = [NSString stringWithFormat:@"nope"];
        
    }
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

/*@end

/*
@implementation SoundView

@synthesize username;
@synthesize pocketsphinxController;
@synthesize openEarsEventsObserver;
@synthesize fliteController;
@synthesize slt;

- (id)init
{
    self = [super init];
    if (self) {
        _accountStore = [[ACAccountStore alloc] init];
    }
    return self;
}

- (void)postImage:(UIImage *)image withStatus:(NSString *)status
{
    ACAccountType *twitterType =
    [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    SLRequestHandler requestHandler =
    ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (responseData) {
            NSInteger statusCode = urlResponse.statusCode;
            if (statusCode >= 200 && statusCode < 300) {
                NSDictionary *postResponseData =
                [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers
                                                  error:NULL];
                NSLog(@"[SUCCESS!] Created Tweet with ID: %@", postResponseData[@"id_str"]);
            }
            else {
                NSLog(@"[ERROR] Server responded: status code %d %@", statusCode,
                      [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
            }
        }
        else {
            NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
        }
    };
    
    ACAccountStoreRequestAccessCompletionHandler accountStoreHandler =
    ^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [self.accountStore accountsWithAccountType:twitterType];
            NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                          @"/1.1/statuses/update_with_media.json"];
            NSDictionary *params = @{@"status" : status};
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                    requestMethod:SLRequestMethodPOST
                                                              URL:url
                                                       parameters:params];
            NSData *imageData = UIImageJPEGRepresentation(image, 1.f);
            [request addMultipartData:imageData
                             withName:@"media[]"
                                 type:@"image/jpeg"
                             filename:@"image.jpg"];
            [request setAccount:[accounts lastObject]];
            [request performRequestWithHandler:requestHandler];
        }
        else {
            NSLog(@"[ERROR] An error occurred while asking for user authorization: %@",
                  [error localizedDescription]);
        }
    };
    
    [self.accountStore requestAccessToAccountsWithType:twitterType
                                               options:NULL
                                            completion:accountStoreHandler];
}

- (void)viewDidLoad
{
    [[Manager sharedInstance] tweetbitch];
    [[Manager sharedInstance] SiriManilli];
    
    NSTimer *currentTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(checktwitter) userInfo:nil repeats:YES];
    
    [currentTimer fire];
    imageskm.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                              [NSURL URLWithString:@"http://www.openmicroscopy.org/site/support/ome-artwork/ome-icon-black-on-white-32.png"]]];
    
    //(void)postImage:(UIImage *)image withStatus:(NSString *)status
    [self shareposted];
    UIImage *image2 = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.openmicroscopy.org/site/support/ome-artwork/ome-icon-black-on-white-32.png"]]];
    UIImage * myImage = [UIImage imageWithContentsOfFile: @"pops.png"];
    [self postImage:myImage withStatus:@"intruder alert!"];
    NSLog(@"gets here");
    LanguageModelGenerator *lmGenerator = [[LanguageModelGenerator alloc] init];
    username = @"theashbhat";
    [self checkfortweet];
    [super viewDidLoad];
    _postText.delegate = self;
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
	// Do any additional setup after loading the view.
}

-(void)shareposted{
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
                                                 //update.json
                                                                      parameters:[NSDictionary dictionaryWithObject:post forKey:@"status"]];
                    NSData *imageData = UIImageJPEGRepresentation(imageskm.image, 1.f);
                    [twitterRequest addMultipartData:imageData
                                     withName:@"media[]"
                                         type:@"image/jpeg"
                                     filename:@"image.jpg"];
                    
                    [twitterRequest setAccount:twitterAccount];
                    
                    [twitterRequest performRequestWithHandler:^(NSData* responseData, NSHTTPURLResponse* urlResponse, NSError* error) {
                        NSLog(@"%@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                        
                    }];
                    
                }
                
            }
            
        }];
        _postText.text = [NSString stringWithFormat:@"test"];
        
    }
    _charCounter.text = [NSString stringWithFormat:@"140"];
    
    
}
/*
- (void)postImage:(UIImage *)image withStatus:(NSString *)status
{
    ACAccountType *twitterType =
    [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSLog(@"got to here!");
    SLRequestHandler requestHandler = ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSLog(@"Hey");
        if (responseData) {
            NSInteger statusCode = urlResponse.statusCode;
            if (statusCode >= 200 && statusCode < 300)
            {
                NSDictionary *postResponseData =
                [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers
                                                  error:NULL];
                NSLog(@"[SUCCESS!] Created Tweet with ID: %@", postResponseData[@"id_str"]);
            }
            else {
                NSLog(@"[ERROR] Server responded: status code %d %@", statusCode,
                      [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
            }
        }
        else {
            NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
        }
        NSLog(@"heer");
    };
    NSLog(@"got to here! yp");
    ACAccountStoreRequestAccessCompletionHandler accountStoreHandler =
    ^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [self.accountStore accountsWithAccountType:twitterType];
            NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                          @"/1.1/statuses/update_with_media.json"];
            NSDictionary *params = @{@"status" : status};
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                    requestMethod:SLRequestMethodPOST
                                                              URL:url
                                                       parameters:params];
            NSData *imageData = UIImageJPEGRepresentation(image, 1.f);
            [request addMultipartData:imageData
                             withName:@"media[]"
                                 type:@"image/jpeg"
                             filename:@"image.jpg"];
            [request setAccount:[accounts lastObject]];
            [request performRequestWithHandler:requestHandler];
        }
        else {
            NSLog(@"[ERROR] An error occurred while asking for user authorization: %@",
                  [error localizedDescription]);
        }
    };
    
    [self.accountStore requestAccessToAccountsWithType:twitterType
                                               options:NULL
                                            completion:accountStoreHandler];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
	NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID);
    if ([hypothesis isEqual: @"Call Sid"]) {
        [self callsid];
    }
    else if ([hypothesis isEqual:@"Call Romi"]) {
        [self callromi];
    }
    else if ([hypothesis isEqual:@"OPEN SESAME"]) {
        [self authorize];
    }
    else {
    [self wrong];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _accountStore = [[ACAccountStore alloc] init];
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
    [self.fliteController say:@"Sorry wrong password bro. Try hacking something to get past me at the next hack awww thon." withVoice:self.slt];
}


-(void)checkforphone:(NSString *)number
{
    NSString *phonenum = lastTweetTextView.text;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",parsednumber]]];
}

- (void)viewDidAppear:(BOOL)animated {
    [_postText becomeFirstResponder];
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger length;
    length = [_postText.text length];
    NSInteger number;
    number = 140-length;
    _charCounter.text = [NSString stringWithFormat:@"%u", number];
    
    if (length >= 141) {
        _charCounter.text = [NSString stringWithFormat:@"nope"];
        
    }
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
*/
@end
