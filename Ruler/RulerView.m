//
//  RulerView.m
//  Ruler
//
//  Created by Com on 26/10/2016.
//  Copyright © 2016 Com. All rights reserved.
//

#import "RulerView.h"
#include <sys/utsname.h>

@implementation RulerView

- (id)init {
	self = [super init];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		
		_isLandscape = NO;
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		
		_isLandscape = NO;
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		
		_isLandscape = NO;
	}
	
	return self;
}

- (float)getmmByPPI {
	float ppm = 0.0;
	struct utsname systemInfo;
	uname(&systemInfo);
	NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
	float scale = [UIScreen mainScreen].scale;
	
	NSLog(@"current device mode: %@, scale: %f", deviceModel, scale);
	
	if ([deviceModel containsString:@"iPhone1"] || [deviceModel containsString:@"iPhone2"]) { // iPhone3
		ppm = 163/25.4;
		
	} else if ([deviceModel containsString:@"iPhone3"] || [deviceModel containsString:@"iPhone4"]
			    || [deviceModel containsString:@"iPhone5"]  || [deviceModel containsString:@"iPhone6"]) { // iPhone4, 5
		ppm = 326/scale/25.4;
		
	} else if ([deviceModel containsString:@"iPhone7,2"] || [deviceModel containsString:@"iPhone8,1"]
			    || [deviceModel containsString:@"iPhone9,1"]  || [deviceModel containsString:@"iPhone9,3"]) { // iPhone 6, 7
		ppm = 326/scale/25.4;
		
	} else if ([deviceModel containsString:@"iPhone7,1"] || [deviceModel containsString:@"iPhone8,2"]
			    || [deviceModel containsString:@"iPhone9,2"]  || [deviceModel containsString:@"iPhone9,4"]) { // iPhone 6+, 7+
		ppm = 401/scale/25.4;
		
	} else if ([deviceModel containsString:@"iPad"]){
		ppm = 132/25.4;
		
	} else {
		ppm = 163/25.4;
	}
	
	return ppm;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
//	[[UIColor clearColor] setFill];
//	UIRectFill(rect);
	
	float i;
	NSInteger count;
	
	float linesDist = [self getmmByPPI]; // ppi/mm per inch (regular size iPad would be 132.0)
	
	float linesWidthShort = 15.0;
	float linesWidthLong = 24.0;
	
	float max = self.isLandscape == YES? self.bounds.size.width: self.bounds.size.height;
	
	for (i = 20, count = 0; i <= max; i = i + linesDist, count++)
	{
		bool isLong = (int)count % 10 == 0;
		bool isMiddle = (int)count % 5 == 0;
		
		float linesWidth = isLong? (linesWidthLong + linesWidthShort): (isMiddle? linesWidthLong: linesWidthShort);
	
		[[UIColor blackColor] setFill];
		
		// draw left ruler
		if (_isLandscape == NO) {
			UIRectFill( (CGRect){0, i, linesWidth, 1} );
		} else {
			UIRectFill( (CGRect){i, rect.size.height - linesWidth, 1, linesWidth} );
		}

		// draw text
		if (isLong) {
			BOOL isMul = (count / 10) % 10 == 0;
			UIFont *font = [UIFont systemFontOfSize:16.0];
			UIColor *foreColor = isMul ? [UIColor whiteColor]: [UIColor blackColor];
			UIColor *backColor = isMul ? [UIColor blackColor]: [UIColor clearColor];
			NSString *number = [NSString stringWithFormat:@"%ld", count / 10];
			
			CGSize sz = [number sizeWithAttributes:@{NSFontAttributeName: font}];
			
			[backColor setFill];
			if (_isLandscape == NO) {
				UIRectFill((CGRect){linesWidth + 5, i - (sz.height / 2), sz.width + 10, sz.height + 8});
				[number drawInRect:(CGRect){linesWidth + 10, i - 5, sz.width, sz.height}
					withAttributes:@{NSFontAttributeName: font,
									 NSForegroundColorAttributeName: foreColor}];
			} else {
				UIRectFill((CGRect){i - (sz.width / 2), rect.size.height - linesWidth - 5 - sz.height, sz.width, sz.height});
				[number drawInRect:(CGRect){i - (sz.width / 2), rect.size.height - linesWidth - 5 - sz.height, sz.width, sz.height}
					withAttributes:@{NSFontAttributeName: font,
									 NSForegroundColorAttributeName: foreColor}];
			}
		}
	}
	
	
	linesDist = linesDist * 304.8 / 10 / 10;
	for (i = 20, count = 0; i <= max; i = i + linesDist, count++)
	{
		bool isLong = (int)count % 10 == 0;
		bool isMiddle = (int)count % 5 == 0;
		
		float linesWidth = isLong? (linesWidthLong + linesWidthShort): (isMiddle? linesWidthLong: linesWidthShort);
		
		[[UIColor blackColor] setFill];
		
		// draw right ruler
		if (_isLandscape == NO) {
			UIRectFill( (CGRect){rect.size.width - linesWidth, i, linesWidth, 1} );
		} else {
			UIRectFill( (CGRect){i, 0, 1 , linesWidth} );
		}
		
		// draw text
		if (isLong) {
			UIFont *font = [UIFont systemFontOfSize:16.0];
			UIColor *foreColor = [UIColor blackColor];
			NSString *number = [NSString stringWithFormat:@"%ld", count / 10];
			
			CGSize sz = [number sizeWithAttributes:@{NSFontAttributeName: font}];
		
			if (_isLandscape == NO) {
				[number drawInRect:(CGRect){rect.size.width - linesWidth - 10 - sz.width, i - 8, sz.width, sz.height}
					withAttributes:@{NSFontAttributeName: font,
									 NSForegroundColorAttributeName: foreColor}];
			} else {
				[number drawInRect:(CGRect){i - 8, linesWidth + 5, sz.width, sz.height}
					withAttributes:@{NSFontAttributeName: font,
									 NSForegroundColorAttributeName: foreColor}];
			}
		}
	}
}


@end
