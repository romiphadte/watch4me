//
//  CamView.h
//  Homester
//
//  Created by Siddhant Dange on 4/6/13.
//  Copyright (c) 2013 homester. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/highgui/cap_ios.h>

#ifdef __cplusplus
using namespace cv;
#endif

@interface CamView : UIViewController<CvVideoCameraDelegate>{
    Mat *_meanImage, *_stdDevImage;
}

@property (nonatomic, retain) IBOutlet UIImageView *_imageview;
@property (nonatomic, retain) CvVideoCamera *videoCamera;
@property (nonatomic, retain) CALayer *customPreviewLayer;


- (void)updateOrientation;
- (void)layoutPreviewLayer;
@end
