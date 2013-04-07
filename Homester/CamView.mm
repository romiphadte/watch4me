//
//  CamView.m
//  Homester
//
//  Created by Siddhant Dange on 4/6/13.
//  Copyright (c) 2013 homester. All rights reserved.
//

#import "CamView.h"

#define DEGREES_RADIANS(angle) ((angle) / 180.0 * M_PI)

@implementation CamView
@synthesize _imageview, videoCamera;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //camera settings
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:_imageview];
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationLandscapeRight;
    self.videoCamera.defaultFPS = 30;
    self.videoCamera.grayscaleMode = NO;
    self.videoCamera.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated{
    [self.videoCamera start];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.videoCamera stop];
}

#pragma mark - Protocol CvVideoCameraDelegate

#ifdef __cplusplus
- (void)processImage:(Mat&)image{
    //correct image
    transpose(image, image);
    flip(image, image, 0); //flip around x-axis
    
    //convert
    cvtColor(image, image, CV_BGRA2BGR);
    cvtColor(image, image, CV_BGR2HSV);
    
    //replace with channel
    replaceMatWithChannel(&image, @"S", 2);
    
    //instantiate mats
    if(_meanImage == NULL || _stdDevImage == NULL){
        _meanImage = new Mat(image.rows,image.cols,image.type());
        _stdDevImage = new Mat(image.rows,image.cols,image.type());
    }
    
   // std::cout << "img"<< image.type() << " alphaimg" << (ALPHA * image).type() << " meanimage" <<  _meanImage->type() << " alphameanimg" <<  (ALPHA* *_meanImage).type() << " add" <<  (ALPHA * image + (1-ALPHA) * *_meanImage).type();
    
    //adaptive background subtraction
    float ALPHA = 0.2;
    *_meanImage = ALPHA * image + (1-ALPHA) * *_meanImage;
    
    image -= *_meanImage;
}

void replaceMatWithChannel(cv::Mat *original, NSString *channel, float multiplier){
    int componentNum = 0;
    int cCap = 255;
    if([channel isEqual: @"H"] || [channel isEqual: @"R"]){
        componentNum = 0;
        cCap = 180;
    } else if([channel isEqual:@"S"] || [channel isEqual: @"G"]){
        componentNum = 1;
    } else if([channel isEqual:@"V"] || [channel isEqual: @"B"]){
        componentNum = 2;
    }
    
    cv::Mat channelMat(original->rows, original->cols, CV_8UC1);
    for (int i = 0; i < channelMat.rows; i++) {
        for (int j = 0; j < channelMat.cols; j++) {
            int cVal = (int)original->at<Vec3b>(i,j)[componentNum] * multiplier;
            if(cVal > cCap)
                cVal = cCap;
            channelMat.at<uchar>(i,j) = cVal;
        }
    }
    
    original->convertTo(*original, CV_8UC1);
    channelMat.copyTo(*original);
}
#endif

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
