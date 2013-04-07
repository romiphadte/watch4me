//
//  ViewController.m
//  Homester
//
//  Created by Siddhant Dange on 4/6/13.
//  Copyright (c) 2013 homester. All rights reserved.
//

#import "MainView.h"

@interface MainView ()

@end



@implementation MainView

- (void)viewDidLoad
{
    hi = [[SoundView alloc] init];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)test
{
    [hi youdostuff];
}

@end