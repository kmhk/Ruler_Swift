//
//  RulerView.m
//  Ruler
//
//  Created by Com on 26/10/2016.
//  Copyright © 2016 Com. All rights reserved.
//

#import "RulerView.h"

@implementation RulerView

- (id)init {
	self = [super init];
	if (self) {
		
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		
	}
	
	return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
	[[UIColor whiteColor] setFill];
	UIRectFill(rect);
	
	float i;
	NSInteger count;
	
	float linesDist = 163.0/25.4; // ppi/mm per inch (regular size iPad would be 132.0)
	
	float linesWidthShort = 15.0;
	float linesWidthLong = 24.0;
	
	for (i = 20, count = 0; i <= self.bounds.size.height; i = i + linesDist, count++)
	{
		bool isLong = (int)count % 10 == 0;
		bool isMiddle = (int)count % 5 == 0;
		
		float linesWidth = isLong? (linesWidthLong + linesWidthShort): (isMiddle? linesWidthLong: linesWidthShort);
	
		[[UIColor blackColor] setFill];
		
		// draw left ruler
		UIRectFill( (CGRect){0, i, linesWidth, 1} );
		
		// draw right ruler
		//UIRectFill( (CGRect){rect.size.width - linesWidth, i, linesWidth, 1} );
		
		// draw text
		if (isLong) {
			BOOL isMul = (count / 10) % 10 == 0;
			UIFont *font = [UIFont systemFontOfSize:16.0];
			UIColor *foreColor = isMul ? [UIColor whiteColor]: [UIColor blackColor];
			UIColor *backColor = isMul ? [UIColor blackColor]: [UIColor whiteColor];
			NSString *number = [NSString stringWithFormat:@"%ld", count / 10];
			
			CGSize sz = [number sizeWithAttributes:@{NSFontAttributeName: font}];
			
			[backColor setFill];
			UIRectFill((CGRect){linesWidth + 5, i - (sz.height / 2), sz.width + 10, sz.height + 8});
			//UIRectFill((CGRect){rect.size.width - linesWidth - 15 - sz.width, i - 5, sz.width + 10, sz.height + 10});
			
			[number drawInRect:(CGRect){linesWidth + 10, i - 5, sz.width, sz.height}
				withAttributes:@{NSFontAttributeName: font,
								 NSForegroundColorAttributeName: foreColor}];
//			[number drawInRect:(CGRect){rect.size.width - linesWidth - 10 - sz.width, y, sz.width, sz.height}
//				withAttributes:@{NSFontAttributeName: font,
//								 NSForegroundColorAttributeName: foreColor}];
		}
	}
	
	
	linesDist = linesDist * 304.8 / 10 / 10;
	for (i = 20, count = 0; i <= self.bounds.size.height; i = i + linesDist, count++)
	{
		bool isLong = (int)count % 10 == 0;
		bool isMiddle = (int)count % 5 == 0;
		
		float linesWidth = isLong? (linesWidthLong + linesWidthShort): (isMiddle? linesWidthLong: linesWidthShort);
		
		[[UIColor blackColor] setFill];
		
		// draw right ruler
		UIRectFill( (CGRect){rect.size.width - linesWidth, i, linesWidth, 1} );
		
		// draw text
		if (isLong) {
			//BOOL isMul = (count / 10) % 10 == 0;
			UIFont *font = [UIFont systemFontOfSize:16.0];
			UIColor *foreColor = [UIColor blackColor];
			//UIColor *backColor = isMul ? [UIColor blackColor]: [UIColor whiteColor];
			NSString *number = [NSString stringWithFormat:@"%ld", count / 10];
			
			CGSize sz = [number sizeWithAttributes:@{NSFontAttributeName: font}];
			
			//[backColor setFill];
			//UIRectFill((CGRect){linesWidth + 5, i - (sz.height / 2), sz.width + 10, sz.height + 8});
			//UIRectFill((CGRect){rect.size.width - linesWidth - 15 - sz.width, i - 5, sz.width + 10, sz.height + 10});
			
//			[number drawInRect:(CGRect){linesWidth + 10, i - 5, sz.width, sz.height}
//				withAttributes:@{NSFontAttributeName: font,
//								 NSForegroundColorAttributeName: foreColor}];
			[number drawInRect:(CGRect){rect.size.width - linesWidth - 10 - sz.width, i - 8, sz.width, sz.height}
				withAttributes:@{NSFontAttributeName: font,
								 NSForegroundColorAttributeName: foreColor}];
		}
	}
}


@end
