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
using namespace std;
#endif

@interface CamView : UIViewController<CvVideoCameraDelegate>{
    Mat *_meanImage, *_stdDevImage, *_backgroundImage, *_positiveImage, *_testImage;
    Point2f *_oldContourCOM;
    BOOL _doneMoving, _isMoving;
}

@property (nonatomic, retain) IBOutlet UIImageView *_imageview;
@property (nonatomic, retain) CvVideoCamera *videoCamera;
@property (nonatomic, retain) CALayer *customPreviewLayer;


- (void)updateOrientation;
- (void)layoutPreviewLayer;
@end
