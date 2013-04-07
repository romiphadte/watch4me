//
//  CamView.m
//  Homester
//
//  Created by Siddhant Dange on 4/6/13.
//  Copyright (c) 2013 homester. All rights reserved.
//

#import "CamView.h"

#define DEGREES_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define FPS 30.0

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
    
    //set up camera
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:_imageview];
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationLandscapeRight;
    self.videoCamera.defaultFPS = 30;
    self.videoCamera.grayscaleMode = NO;
    self.videoCamera.delegate = self;
    
    //set up variables
    _oldContourCOM = new Point2f();
    _doneMoving = _isMoving = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [self.videoCamera start];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.videoCamera stop];
}

#pragma mark - Protocol CvVideoCameraDelegate

#ifdef __cplusplus

//float pointDist(Point2f one, Point2f two);
//int greatestContourArea(int size, vector<vector<cv::Point>>data);
//void replaceMatWithChannel(cv::Mat *original, NSString *channel, float multiplier, float constant);


- (void)processImage:(Mat&)origImage{
    //correct image
    cv::Mat image(origImage.rows,origImage.cols, origImage.type());
    origImage.copyTo(image);
    transpose(image, image);
    flip(image, image, 0); //flip around x-axis
    
    //convert
    cvtColor(image, image, CV_BGRA2BGR);
    cvtColor(image, image, CV_BGR2HSV);
    
    //replace with channel
    replaceMatWithChannel(&image, @"S", 1, 0);
    
    //instantiate mats
    if(_meanImage == NULL || _stdDevImage == NULL){
        _meanImage = new Mat(image.rows,image.cols,image.type());
        _stdDevImage = new Mat(image.rows,image.cols,image.type());
        _positiveImage = new Mat(image.rows,image.cols,image.type());
        _testImage = new Mat(image.rows,image.cols,image.type());
        _backgroundImage = new Mat(image.rows,image.cols,image.type());
    }
    
    // std::cout << "img"<< image.type() << " alphaimg" << (ALPHA * image).type() << " meanimage" <<  _meanImage->type() << " alphameanimg" <<  (ALPHA* *_meanImage).type() << " add" <<  (ALPHA * image + (1-ALPHA) * *_meanImage).type();
    
    //adaptive background subtraction
    float ALPHA = 0.05;
    *_meanImage = ALPHA * image + (1-ALPHA) * *_meanImage;
    image -= *_meanImage;
    
    threshold(image, image, 10, 255, THRESH_BINARY); //65
    
    //grab contours
    vector<vector<cv::Point>>allCountours;
    findContours(image, allCountours, CV_RETR_LIST, CV_CHAIN_APPROX_NONE);
    
    //if there's a contour found then grab COM of largest contour
    if(allCountours.size() > 0){
        
        int indexGrestest = greatestContourArea(allCountours.size(), allCountours);
        vector<cv::Point> lContour = allCountours[indexGrestest];
        if(contourArea(lContour) > 10000 && contourArea(lContour) < 100000){
            //    cout << contourArea(lContour) << endl;
            
            //draw contours
            vector<vector<cv::Point>>biggestCShell;
            biggestCShell.push_back(lContour);
            drawContours(image, biggestCShell, -1, Scalar(360,255,255), CV_FILLED);
            
            //find COM with moments
            Moments moment = moments(Mat(lContour), false);
            Point2f currContourCOM = Point2f(moment.m10/moment.m00 , moment.m01/moment.m00);
            circle(image, currContourCOM, 30, Scalar(150,255,255));
            
            //find distance per frame
            float dist = pointDist(currContourCOM, *_oldContourCOM);
            *_oldContourCOM = currContourCOM;
            
            //confirm valid moving target
            if(dist > 5 && dist < 20){
                _isMoving = YES;
            } else{ //if nothing is moving, check if something WAS moving
                cout << dist << endl;
                if (_isMoving) {
                    _doneMoving = YES;
                    _isMoving = NO;
                }
            }
            
            /*if something is done moving ie: someone standing in front of camera, make
             a ROI of face
             */
            if(_doneMoving){
                origImage.copyTo(*_testImage);
                _doneMoving = NO;
            }
        }
    } else{ //else update background of background image
        origImage.copyTo(*_backgroundImage);
    }
    
    origImage.convertTo(origImage, CV_8UC1);
    image.copyTo(origImage);
    
}

float pointDist(Point2f one, Point2f two){
    return sqrt(pow(one.x - two.x,2) + pow(one.y - two.y,2));
}

int greatestContourArea(int size, vector<vector<cv::Point>>data){
    int greatest = 0;
    for(int i = 0; i < size; i++){
        if(contourArea(data[i]) > contourArea(data[greatest]))
            greatest = i;
    }
    return greatest;
}

void replaceMatWithChannel(cv::Mat *original, NSString *channel, float multiplier, float constant){
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
            int cVal = ((int)original->at<Vec3b>(i,j)[componentNum] * multiplier) + constant;
            if(cVal > cCap)
                cVal = cCap;
            else if(cVal < 0)
                cVal = 0;
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
