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

#pragma mark - ViewControllerImplementation

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
    _frameCount = _onCount = _downTimeCount = 0;
    
    [self performSelectorInBackground:@selector(startSpeechRecognition) withObject:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [self.videoCamera start];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.videoCamera stop];
}

-(void)startSpeechRecognition{
    [[Manager sharedInstance] SiriManilli];
}

#pragma mark - Protocol CvVideoCameraDelegate

#ifdef __cplusplus

float pointDist(Point2f one, Point2f two);
int greatestContourArea(int size, vector<vector<cv::Point>>data);
void replaceMatWithChannel(cv::Mat *original, NSString *channel, float multiplier, float constant);

- (void)processImage:(Mat&)origImage{
    //correct image
    cv::Mat image(origImage.rows,origImage.cols, origImage.type());
    origImage.copyTo(image);
    transpose(image, image);
    flip(image, image, 0); //flip around x-axis
    
    //convert to hsv
    cvtColor(image, image, CV_BGRA2BGR);
    cvtColor(image, image, CV_BGR2HSV);
    
    //replace with channel
    replaceMatWithChannel(&image, @"S", 1.3, 0);
    
    //instantiate mats
    if(_meanImage == NULL || _stdDevImage == NULL){
        _meanImage = new Mat(image.rows,image.cols,image.type());
        _stdDevImage = new Mat(image.rows,image.cols,image.type());
        _positiveImage = new Mat(image.rows,image.cols,image.type());
        _testImage = new Mat(image.rows,image.cols,image.type());
        _backgroundImage = new Mat(image.rows,image.cols,image.type());
    }
    
    /*ABS algorithm*/
    float ALPHA = 0.07;
    *_meanImage = ALPHA * image + (1-ALPHA) * *_meanImage;
    image -= *_meanImage;
    threshold(image, image, 10, 255, THRESH_BINARY); //65
    
    //grab contours
    vector<vector<cv::Point>>allCountours;
    findContours(image, allCountours, CV_RETR_LIST, CV_CHAIN_APPROX_NONE);
    
    //if contours exist, process them
    if(allCountours.size() > 0 && _frameCount > 20){
        
        //find largest contour and threshold by area
        int indexGrestest = greatestContourArea(allCountours.size(), allCountours);
        vector<cv::Point> lContour = allCountours[indexGrestest];
        if(contourArea(lContour) > 1000 && contourArea(lContour) < 100000){
            
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
                _onCount++;
                _downTimeCount = 0;
            }
            
            cout << "time sensed: " << (int)(_onCount/FPS);
            
            //if target was moving for 30 seconds straight, trigger alarm
            if(_onCount > 7 * FPS){
                
                //take picture
                UIImage *image = [self UIImageFromCVMat:*_testImage];
                
                //ask question -> voice recognize, tweet built in
                [Manager sharedInstance]._suspicionArised = YES;
                [[Manager sharedInstance] SiriManilli];
                cout << "SUSPICIOUS ACTIVITY DETECTED" << endl;
                _onCount = 0;
            }
        } else{
            
            //if there's a still-gap of <= 3 seconds, continue tracking counter
            if(_downTimeCount < 3 * FPS){
                _onCount++;
            }else if(_downTimeCount > 3 * FPS){ //after 3 seconds reset tracking counter
                _onCount = 0;
            }
            
            //if someone just finished moving process face
            if (_isMoving && _downTimeCount > 3 * FPS) {
                origImage.copyTo(*_testImage);
                cout << "done moving" << endl;
                
//                // holds images and labels
//                vector<cv::Mat> images;
//                vector<int> labels;
//                // images for first person
//                IplImage* img1 = cvLoadImage("/Users/siddhantdanger/Projects/App Stuff/watch4me/Homester/Homester/s1.jpg");
//                cv::Mat mat1(img1);
//                cvReleaseImage(&img1);
//                IplImage* img2 = cvLoadImage("/Users/siddhantdanger/Projects/App Stuff/watch4me/Homester/Homester/s2.jpg");
//                cv::Mat mat2(img2);
//                cvReleaseImage(&img2);
//                IplImage* img3 = cvLoadImage("/Users/siddhantdanger/Projects/App Stuff/watch4me/Homester/Homester/s3.jpg");
//                cv::Mat mat3(img3);
//                cvReleaseImage(&img3);
//            //    images.push_back(mat1); labels.push_back(0);
//                images.push_back(mat2); labels.push_back(0);
//                images.push_back(mat3); labels.push_back(0);
//                // images for second person
//                
//                // Let's say we want to keep 10 Eigenfaces and have a threshold value of 10.0
//                int num_components = 1;
//                double threshold = 10.0;
//                // Then if you want to have a cv::FaceRecognizer with a confidence threshold,
//                // create the concrete implementation with the appropiate parameters:
//                Ptr<FaceRecognizer> model = createEigenFaceRecognizer(num_components, threshold);
//                cout << "rows: " << _testImage->rows << " cols: " << _testImage->cols << endl;
//                model->train(images, labels);
//                
//                // The following line reads the threshold from the Eigenfaces model:
//                double current_threshold = model->getDouble("threshold");
//                // And this line sets the threshold to 0.0:
//                model->set("threshold", 10.0);
//                
//                // Get a prediction from the model. Note: We've set a threshold of 0.0 above,
//                // since the distance is almost always larger than 0.0, you'll get -1 as
//                // label, which indicates, this face is unknown
//                int predicted_label = model->predict(*_testImage);
//                cout << "prediction: " << predicted_label;
                
                _doneMoving = YES;
                _isMoving = NO;
            }
            
            //increment no-motion counter and make sure integer doesnt overload
            _downTimeCount++;
            if(_downTimeCount == 10000)
                _downTimeCount = 4 * FPS;
        }
    } else { //else update background of background image
        origImage.copyTo(*_backgroundImage);
    }
    
      //convert original image to single channel and output thresholded image
      origImage.convertTo(origImage, CV_8UC1);
      image.copyTo(origImage);
    
    //increment frame counter and make sure integer doesnt overload
    _frameCount++;
    if(_frameCount == 10000)
        _frameCount = 21;
}

void subtractFeatures(cv::Mat background, cv::Mat *current, int threshold){
    for (int i = 0; i < current->rows; i++) {
        for (int j = 0; j < current->cols; j++) {
            Vec3b diff = current->at<Vec3b>(i,j) - background.at<Vec3b>(i,j);
            for (int k = 0; k < 3; k++) {
                if(diff[k] < threshold) {
                    current->at<Vec3b>(i,j)[2] = 0;
                }
            }
        }
    }
}

//find distance between two points
float pointDist(Point2f one, Point2f two){
    return sqrt(pow(one.x - two.x,2) + pow(one.y - two.y,2));
}


//find index of contour with greatest area in a set
int greatestContourArea(int size, vector<vector<cv::Point>>data){
    int greatest = 0;
    for(int i = 0; i < size; i++){
        if(contourArea(data[i]) > contourArea(data[greatest]))
            greatest = i;
    }
    return greatest;
}

//convert a 3-channel matrix to a specified single channel matrix
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

//get a Mat from a UIImage
- (cv::Mat)cvMatFromUIImage:(UIImage *)image{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    return cvMat;
}

//get a UIImage from a Mat
-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat {
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}
#endif

#pragma mark - ViewControllerImplementationEtc

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
