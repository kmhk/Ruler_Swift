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
#define kACC_WEIGHT		0.0


@interface MainViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UIImageView *imgBkSensor;
@property (weak, nonatomic) IBOutlet UIImageView *imgSensor;
@property (weak, nonatomic) IBOutlet UILabel *roationLabel;

@property (nonatomic) RulerView *rulerView;
@property (nonatomic) CGRect rtSensor;

@property (nonatomic, assign) double				gravityX;
@property (nonatomic, assign) double				gravityY;
@property (nonatomic, assign) double				gravityZ;
@property (nonatomic, assign) BOOL					isRoationInted;
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
	self.gravityX = self.gravityY = self.gravityZ = 0;
	self.isRoationInted = NO;
	
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
			
			CMAcceleration gravity = mManager.deviceMotion.gravity;
			if (_isRoationInted) {
				weakSelf.gravityX = weakSelf.gravityX * kACC_WEIGHT  + gravity.x * (1.0 - kACC_WEIGHT);
				weakSelf.gravityY = weakSelf.gravityY * kACC_WEIGHT  + gravity.y * (1.0 - kACC_WEIGHT);
				weakSelf.gravityZ = weakSelf.gravityZ * kACC_WEIGHT  + gravity.z * (1.0 - kACC_WEIGHT);
			} else {
				if (gravity.x != 0 && gravity.y != 0 && gravity.z != 0) {
					weakSelf.gravityX = gravity.x;
					weakSelf.gravityX = gravity.y;
					weakSelf.gravityX = gravity.z;
					
					_isRoationInted = YES;
				}
			}
			
			if (_isRoationInted) {
				double gravity = sqrt(weakSelf.gravityX * weakSelf.gravityX + weakSelf.gravityY * weakSelf.gravityY + weakSelf.gravityZ * weakSelf.gravityZ);
				double roationInXY = acos(self.gravityY / gravity) * 180 / M_PI;
				NSInteger rotationOfXY = (NSInteger)(-180 + acos(weakSelf.gravityZ / gravity) * 180 / M_PI);
				//weakSelf.roationLabel.text = [NSString stringWithFormat:@"%ld", (long)rotationOfXY];
				//self.roationLabel.transform = CGAffineTransformMakeRotation(roationInXY);
				
				
				CGFloat flag = (roationInXY - 90.0 < 0)? -1: 1;
				CGFloat y = (abs(rotationOfXY) % 90) * 2;
				y = flag * (y > 125? 125.0: y);
				NSLog(@"%f. %f", roationInXY, y);
				weakSelf.imgSensor.frame = (CGRect){weakSelf.rtSensor.origin.x, weakSelf.rtSensor.origin.y + y, weakSelf.rtSensor.size.width, weakSelf.rtSensor.size.height};
			}
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

