//
//  embBezierPathItems.m
//  embAnimatedPath
//
//  Created by Evan Buxton on 2/19/14.
//  Copyright (c) 2014 neoscape. All rights reserved.
//

#import "embFenwayBlockPaths.h"
@implementation embFenwayBlockPaths

- (id) init
{
    if (self = [super init]) {
		
		// setup
		_bezierPaths = [[NSMutableArray alloc] init];
		
		UIColor *pathRed = [UIColor colorWithRed:235.0f/255.0f
										   green:199.0f/255.0f
											blue:113.0f/255.0f
										   alpha:1.0];
		
		
		
		UIColor *pathBlue = [UIColor colorWithRed:235/255.0f
											green:199.0f/255.0f
											 blue:113.0f/255.0f
											alpha:1.0];
		
		CGFloat pathWidth = 7.0;
		CGFloat pathSpeed = 3.5;
		

		// Bezier paths created in paintcode
		// COPY FROM PAINTCODE

		//// Bezier Drawing
		UIBezierPath* bezierPath = [UIBezierPath bezierPath];
		[bezierPath moveToPoint: CGPointMake(425.5, 238.5)];
		[bezierPath addLineToPoint: CGPointMake(372.5, 151.5)];
		[bezierPath addLineToPoint: CGPointMake(416.5, 123.5)];
		[bezierPath addLineToPoint: CGPointMake(448.5, 172.5)];
		[bezierPath addLineToPoint: CGPointMake(425.5, 188.5)];
		[bezierPath addLineToPoint: CGPointMake(448.5, 224.5)];
		[bezierPath addLineToPoint: CGPointMake(425.5, 238.5)];
		[bezierPath closePath];
	
		
		
		//// Bezier 2 Drawing
		UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
		[bezier2Path moveToPoint: CGPointMake(476.5, 245.5)];
		[bezier2Path addLineToPoint: CGPointMake(504.5, 228.5)];
		[bezier2Path addLineToPoint: CGPointMake(537.5, 283.5)];
		[bezier2Path addLineToPoint: CGPointMake(510.5, 300.5)];
		[bezier2Path addLineToPoint: CGPointMake(476.5, 245.5)];
		[bezier2Path closePath];
		
		
		
		//// Bezier 3 Drawing
		UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
		[bezier3Path moveToPoint: CGPointMake(844.5, 501.5)];
		[bezier3Path addLineToPoint: CGPointMake(844.5, 496.5)];
		[bezier3Path addLineToPoint: CGPointMake(835.5, 496.5)];
		[bezier3Path addLineToPoint: CGPointMake(835.5, 456.5)];
		[bezier3Path addLineToPoint: CGPointMake(844.5, 456.5)];
		[bezier3Path addLineToPoint: CGPointMake(844.5, 445.5)];
		[bezier3Path addLineToPoint: CGPointMake(830.5, 445.5)];
		[bezier3Path addLineToPoint: CGPointMake(830.5, 417.5)];
		[bezier3Path addLineToPoint: CGPointMake(938.5, 416.5)];
		[bezier3Path addLineToPoint: CGPointMake(938.5, 445.5)];
		[bezier3Path addLineToPoint: CGPointMake(906.5, 445.5)];
		[bezier3Path addLineToPoint: CGPointMake(906.5, 522.5)];
		[bezier3Path addLineToPoint: CGPointMake(887.5, 522.5)];
		[bezier3Path addLineToPoint: CGPointMake(886.5, 456.5)];
		[bezier3Path addLineToPoint: CGPointMake(901.5, 456.5)];
		[bezier3Path addLineToPoint: CGPointMake(901.5, 445.5)];
		[bezier3Path addLineToPoint: CGPointMake(851.5, 445.5)];
		[bezier3Path addLineToPoint: CGPointMake(851.5, 456.5)];
		[bezier3Path addLineToPoint: CGPointMake(864.5, 456.5)];
		[bezier3Path addLineToPoint: CGPointMake(864.5, 496.5)];
		[bezier3Path addLineToPoint: CGPointMake(856.5, 496.5)];
		[bezier3Path addLineToPoint: CGPointMake(856.5, 501.5)];
		[bezier3Path addLineToPoint: CGPointMake(844.5, 501.5)];
		[bezier3Path closePath];
	
		
		
		//// Bezier 4 Drawing
		UIBezierPath* bezier4Path = [UIBezierPath bezierPath];
		[bezier4Path moveToPoint: CGPointMake(728.5, 642.5)];
		[bezier4Path addCurveToPoint: CGPointMake(904.5, 642.5) controlPoint1: CGPointMake(729.21, 642.96) controlPoint2: CGPointMake(904.5, 642.5)];
		[bezier4Path addLineToPoint: CGPointMake(904.5, 592.5)];
		[bezier4Path addLineToPoint: CGPointMake(728.5, 592.5)];
		[bezier4Path addCurveToPoint: CGPointMake(728.5, 642.5) controlPoint1: CGPointMake(728.5, 592.5) controlPoint2: CGPointMake(727.79, 642.04)];
		[bezier4Path closePath];
	
		
		//// Bezier 5 Drawing
		UIBezierPath* bezier5Path = [UIBezierPath bezierPath];
		[bezier5Path moveToPoint: CGPointMake(571, 402)];
		[bezier5Path addLineToPoint: CGPointMake(570, 529)];
		[bezier5Path addLineToPoint: CGPointMake(690, 529)];
		[bezier5Path addLineToPoint: CGPointMake(690, 402)];
		[bezier5Path addLineToPoint: CGPointMake(571, 402)];
		[bezier5Path closePath];
		
		
		
		//// Bezier 6 Drawing
		UIBezierPath* bezier6Path = [UIBezierPath bezierPath];
		[bezier6Path moveToPoint: CGPointMake(379, 588)];
		[bezier6Path addLineToPoint: CGPointMake(440, 588)];
		[bezier6Path addLineToPoint: CGPointMake(440, 647)];
		[bezier6Path addLineToPoint: CGPointMake(379, 647)];
		[bezier6Path addLineToPoint: CGPointMake(379, 588)];
		[bezier6Path closePath];
		
		
		
		//// Bezier 7 Drawing
		UIBezierPath* bezier7Path = [UIBezierPath bezierPath];
		[bezier7Path moveToPoint: CGPointMake(529, 390)];
		[bezier7Path addLineToPoint: CGPointMake(543, 390)];
		[bezier7Path addCurveToPoint: CGPointMake(549, 396) controlPoint1: CGPointMake(543, 390) controlPoint2: CGPointMake(549.6, 391.01)];
		[bezier7Path addCurveToPoint: CGPointMake(549, 414) controlPoint1: CGPointMake(548.4, 400.99) controlPoint2: CGPointMake(549, 414)];
		[bezier7Path addLineToPoint: CGPointMake(545, 414)];
		[bezier7Path addLineToPoint: CGPointMake(545, 521)];
		[bezier7Path addLineToPoint: CGPointMake(550, 521)];
		[bezier7Path addLineToPoint: CGPointMake(550, 533)];
		[bezier7Path addCurveToPoint: CGPointMake(544, 538) controlPoint1: CGPointMake(550, 533) controlPoint2: CGPointMake(546.41, 537.79)];
		[bezier7Path addCurveToPoint: CGPointMake(379, 538) controlPoint1: CGPointMake(541.59, 538.21) controlPoint2: CGPointMake(379, 538)];
		[bezier7Path addCurveToPoint: CGPointMake(375, 533) controlPoint1: CGPointMake(379, 538) controlPoint2: CGPointMake(375.83, 538.9)];
		[bezier7Path addCurveToPoint: CGPointMake(374, 481) controlPoint1: CGPointMake(374.17, 527.1) controlPoint2: CGPointMake(374, 481)];
		[bezier7Path addCurveToPoint: CGPointMake(379, 476) controlPoint1: CGPointMake(374, 481) controlPoint2: CGPointMake(378.62, 473.14)];
		[bezier7Path addCurveToPoint: CGPointMake(379, 432) controlPoint1: CGPointMake(379.38, 478.86) controlPoint2: CGPointMake(379, 432)];
		[bezier7Path addLineToPoint: CGPointMake(372, 432)];
		[bezier7Path addCurveToPoint: CGPointMake(365, 418) controlPoint1: CGPointMake(372, 432) controlPoint2: CGPointMake(368.27, 426.47)];
		[bezier7Path addCurveToPoint: CGPointMake(365, 396) controlPoint1: CGPointMake(363.18, 413.3) controlPoint2: CGPointMake(353.76, 403.68)];
		[bezier7Path addCurveToPoint: CGPointMake(388, 389) controlPoint1: CGPointMake(374.02, 389.84) controlPoint2: CGPointMake(382.34, 388.85)];
		[bezier7Path addCurveToPoint: CGPointMake(389, 393) controlPoint1: CGPointMake(393.66, 389.15) controlPoint2: CGPointMake(389, 393)];
		[bezier7Path addLineToPoint: CGPointMake(529, 394)];
		[bezier7Path addLineToPoint: CGPointMake(529, 390)];
		[bezier7Path closePath];
		
		
		
		//// Bezier 8 Drawing
		UIBezierPath* bezier8Path = [UIBezierPath bezierPath];
		[bezier8Path moveToPoint: CGPointMake(100, 586)];
		[bezier8Path addLineToPoint: CGPointMake(349, 585)];
		[bezier8Path addLineToPoint: CGPointMake(349, 648)];
		[bezier8Path addLineToPoint: CGPointMake(100, 650)];
		[bezier8Path addLineToPoint: CGPointMake(100, 586)];
		[bezier8Path closePath];
	
		
		
		//// Bezier 9 Drawing
		UIBezierPath* bezier9Path = [UIBezierPath bezierPath];
		[bezier9Path moveToPoint: CGPointMake(58, 529)];
		[bezier9Path addLineToPoint: CGPointMake(50, 515)];
		[bezier9Path addCurveToPoint: CGPointMake(140, 459) controlPoint1: CGPointMake(50, 515) controlPoint2: CGPointMake(139.48, 459.35)];
		[bezier9Path addCurveToPoint: CGPointMake(170, 504) controlPoint1: CGPointMake(140.52, 458.65) controlPoint2: CGPointMake(170, 504)];
		[bezier9Path addLineToPoint: CGPointMake(170, 529)];
		[bezier9Path addLineToPoint: CGPointMake(58, 529)];
		[bezier9Path closePath];
	
		
		
		//// Bezier 10 Drawing
		UIBezierPath* bezier10Path = [UIBezierPath bezierPath];
		[bezier10Path moveToPoint: CGPointMake(1, 199)];
		[bezier10Path addLineToPoint: CGPointMake(44, 182)];
		[bezier10Path addLineToPoint: CGPointMake(105, 270)];
		[bezier10Path addLineToPoint: CGPointMake(108, 270)];
		[bezier10Path addLineToPoint: CGPointMake(157, 394)];
		[bezier10Path addLineToPoint: CGPointMake(26, 444)];
		[bezier10Path addLineToPoint: CGPointMake(18, 424)];
		[bezier10Path addLineToPoint: CGPointMake(15, 426)];
		[bezier10Path addLineToPoint: CGPointMake(3, 395)];
		[bezier10Path addLineToPoint: CGPointMake(4, 393)];
		[bezier10Path addLineToPoint: CGPointMake(1, 387)];
		[bezier10Path addLineToPoint: CGPointMake(1, 199)];
		[bezier10Path closePath];
		
		
		//// Bezier 11 Drawing
		UIBezierPath* bezier11Path = [UIBezierPath bezierPath];
		[bezier11Path moveToPoint: CGPointMake(356, 370)];
		[bezier11Path addLineToPoint: CGPointMake(337, 339)];
		[bezier11Path addLineToPoint: CGPointMake(388, 306)];
		[bezier11Path addLineToPoint: CGPointMake(412, 344)];
		[bezier11Path addLineToPoint: CGPointMake(399, 352)];
		[bezier11Path addLineToPoint: CGPointMake(402, 356)];
		[bezier11Path addLineToPoint: CGPointMake(390, 363)];
		[bezier11Path addLineToPoint: CGPointMake(377, 363)];
		[bezier11Path addLineToPoint: CGPointMake(356, 370)];
		[bezier11Path closePath];
		
		
		// END COPY FROM PAINT CODE

		
		
		// copy new paths from paint code above into array
		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = pathBlue;
		pathItem.pathSpeed = pathSpeed;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = bezierPath;
		[_bezierPaths addObject:pathItem];
		
		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = pathRed;
		pathItem.pathSpeed = pathSpeed;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = bezier2Path;
		[_bezierPaths addObject:pathItem];
		
		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = pathRed;
		pathItem.pathSpeed = pathSpeed;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = bezier3Path;
		[_bezierPaths addObject:pathItem];
		
		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = pathBlue;
		pathItem.pathSpeed = pathSpeed;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = bezier4Path;
		[_bezierPaths addObject:pathItem];
		
		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = pathRed;
		pathItem.pathSpeed = pathSpeed;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = bezier5Path;
		[_bezierPaths addObject:pathItem];
		
		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = pathBlue;
		pathItem.pathSpeed = pathSpeed;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = bezier6Path;
		[_bezierPaths addObject:pathItem];
		
		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = pathRed;
		pathItem.pathSpeed = pathSpeed;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = bezier7Path;
		[_bezierPaths addObject:pathItem];
		
		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = pathBlue;
		pathItem.pathSpeed = pathSpeed;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = bezier8Path;
		[_bezierPaths addObject:pathItem];
		
		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = pathRed;
		pathItem.pathSpeed = pathSpeed;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = bezier9Path;
		[_bezierPaths addObject:pathItem];

		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = pathRed;
		pathItem.pathSpeed = pathSpeed;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = bezier10Path;
		[_bezierPaths addObject:pathItem];
		
		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = pathRed;
		pathItem.pathSpeed = pathSpeed;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = bezier11Path;
		[_bezierPaths addObject:pathItem];

	}
	
	return self;
}

@end
