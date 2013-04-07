//
//  Manager.m
//  Homester
//
//  Created by Siddhant Dange on 4/7/13.
//  Copyright (c) 2013 homester. All rights reserved.
//

#import "Manager.h"

@implementation Manager

static Manager *_instance = nil;

+(Manager*)sharedInstance{
	@synchronized([Manager class])
	{
		if (_instance == nil)
			_instance = [[self alloc] init];
        
		return _instance;
	}
    
	return nil;
}


@end
