//
//  MainViewController.m
//  Ruler
//
//  Created by Com on 26/10/2016.
//  Copyright © 2016 Com. All rights reserved.
//

#import "MainViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import "RulerView.h"
#import "AppDelegate.h"


#define MAX_HEIGHT		3000



@interface MainViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UIImageView *imgBkSensor;
@property (weak, nonatomic) IBOutlet UIImageView *imgSensor;

@property (nonatomic) RulerView *rulerView;
@property (nonatomic) CGRect rtSensor;

@end



@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	_scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, MAX_HEIGHT);

	_rulerView = [[RulerView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.contentSize.width, _scrollView.contentSize.height)];
	[_scrollView addSubview:_rulerView];
	
	[self startMotionUpdates];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	_rtSensor = _imgSensor.frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
	_scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, MAX_HEIGHT);
	_rulerView.frame = (CGRect){0, 0, _scrollView.contentSize.width, _scrollView.contentSize.height};
	
//	CGSize sz;
//	NSString *sensorImageName;
//	if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)) {
//		sz = (CGSize){88, 312};
//		sensorImageName = @"accel_portrait.png";
//	} else {
//		sz = (CGSize){312, 88};
//		sensorImageName = @"accel_landscape.png";
//	}
//	_viewContainer.frame = (CGRect){(self.view.frame.size.width - sz.width)/2, (self.view.frame.size.height - sz.height)/2, sz.width, sz.height};
//	_imgBkSensor.image = [UIImage imageNamed:sensorImageName];
	
	[_rulerView setNeedsDisplay];
	
	return YES;
}

- (BOOL)prefersStatusBarHidden {
	return YES;
}

- (IBAction)onBtnReset:(id)sender {
	CGRect rt = [sender frame];
	
	[sender setUserInteractionEnabled:NO];
	[UIView animateWithDuration:0.2 animations:^{
		[sender setFrame:CGRectOffset(rt, 0, 50)];
		[_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
	} completion:^(BOOL finished) {
		
		[UIView animateWithDuration:0.2 animations:^{
			[sender setFrame:rt];
		} completion:^(BOOL finished) {
			[sender setUserInteractionEnabled:YES];
		}];
	}];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - motion action

- (void)startMotionUpdates {
 
	// Determine the update interval
	NSTimeInterval updateInterval = (1.f/30.f);
 
	// Create a CMMotionManager
	CMMotionManager *mManager = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).motionManager;
	MainViewController * __weak weakSelf = self;
	
	[mManager startDeviceMotionUpdates];
 
	// Check whether the accelerometer is available
	if ([mManager isAccelerometerAvailable] == YES) {
		// Assign the update interval to the motion manager
		[mManager setAccelerometerUpdateInterval:updateInterval];
		[mManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
			CGFloat rotation = atan2(accelerometerData.acceleration.x, accelerometerData.acceleration.y) - M_PI;
			//NSLog(@"%f, %f, %f, %f", accelerometerData.acceleration.x, accelerometerData.acceleration.y, accelerometerData.acceleration.z, rotation);
			//CMRotationRate rotation = mManager.deviceMotion.rotationRate;
			//NSLog(@"%f, %f, %f, %f", rotation.x, rotation.y, rotation.z, rotation);
			self.imgSensor.frame = (CGRect){self.rtSensor.origin.x + rotation * 5, self.rtSensor.origin.y, self.rtSensor.size.width, self.rtSensor.size.height};
		}];
	}
	
//	self.updateIntervalLabel.text = [NSString stringWithFormat:@"%f", updateInterval];
}


- (void)stopUpdates {
	CMMotionManager *mManager = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).motionManager;
	if ([mManager isAccelerometerActive] == YES) {
		[mManager stopAccelerometerUpdates];
	}
}

#pragma mark - ScrollView Delegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
	[scrollView setContentOffset:scrollView.contentOffset animated:NO];
}
@end

