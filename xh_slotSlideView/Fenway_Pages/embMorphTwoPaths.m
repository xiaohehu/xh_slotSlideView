//
//  embDraw2D.m
//  victoryparkmenudemo
//
//  Created by Evan Buxton on 11/29/13.
//  Copyright (c) 2013 neoscape. All rights reserved.
//

#import "embMorphTwoPaths.h"

#define kAnimSpeed			((CGFloat) 0.03)	// 0.13
#define kMenuOpenAnimSpeed	((CGFloat) 0.03)	// 0.13		0.25 for continous
#define kMenuCloseAnimSpeed	((CGFloat) 0.04)	// 1.04		4.50 for continous

@implementation embMorphTwoPaths
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame andPlistName:(NSString*)p
{
    self = [super initWithFrame:frame];
    if (self) {
		shapesPlist = p;
		pauseTimeBeforeStart = [self pauseDelay];
		[self pathMenuSetup];
    }
    return self;
}

-(void)setPanelAlignment:(embPanelAlignment)panelAlignment
{
    _panelAlignment = panelAlignment;
	// plists
	NSString *path = [[NSBundle mainBundle] pathForResource:shapesPlist ofType:@"plist"];
    NSMutableArray *pathArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
	
	if (_panelAlignment == embPanelLeftAlignment) {
		arr_allShapes = [[NSMutableArray alloc] initWithArray:[pathArray objectAtIndex:0]];
	} else if (_panelAlignment == embPanelRightAlignment){
		arr_allShapes = [[NSMutableArray alloc] initWithArray:[pathArray objectAtIndex:1]];
	}
	
	for (NSDictionary *dict in arr_allShapes) {
		[arr_polyShapes addObject:[dict valueForKey:@"pathClose"]];
		[arr_polyShapes addObject:[dict valueForKey:@"pathOpen"]];
		[arr_pauses addObject:[dict valueForKey:@"pathDelay"]];
    }
}

-(NSArray*)titles
{
	NSArray *clr = nil;
	return clr;
}

-(UIColor*)panelColor
{
	UIColor *clr = [UIColor redColor];
	return clr;
}

-(void)setPanelColor:(UIColor*)color
{
	if (color) {
		panelColor = color;
	} else {
		panelColor = [UIColor blueColor];
	}
}

-(UIColor*)arrowColor
{
	UIColor *clr = [UIColor redColor];
	return clr;
}

-(void)setArrowColor:(UIColor*)color
{
	if (color) {
		arrowColor = color;
	} else {
		arrowColor = [UIColor blueColor];
	}
}

-(UIColor*)buttonColor
{
	UIColor *clr = [UIColor redColor];
	return clr;
}

-(void)setButtonColor:(UIColor*)color
{
	if (color) {
		buttonColor = color;
	} else {
		buttonColor = [UIColor blueColor];
	}
}

- (CGFloat)pauseDelay {
	return 1.33;
}

- (void)setPauseDelay:(CGFloat)pause {
    if (pause) {
		pauseTimeBeforeStart=pause;
		// Do any additional setup after loading the view from its nib.
		[self performSelector:@selector(pathsForMenu) withObject:nil afterDelay:pauseTimeBeforeStart];
    } else if (!pause) {
		pauseTimeBeforeStart = [self pauseDelay];
    }
}

#pragma mark - DELEGATE MESSAGE
-(void)pathTappedAtIndex:(int)i
{
	if ([delegate respondsToSelector:@selector(embMorphTwoPaths:indexOfTapped:)]) {
		[delegate embMorphTwoPaths:self indexOfTapped:i];
	}
}

#pragma mark - path setup
-(void)pathMenuSetup
{
	// arrays
	arr_shapeArray = [[NSMutableArray alloc] init];
	arr_bezierPathArray = [[NSMutableArray alloc] init];
	arr_cgPathArray = [[NSMutableArray alloc] init];
	arr_polyShapes = [[NSMutableArray alloc] init];
	arr_pauses = [[NSMutableArray alloc] init];
}

#pragma mark - Create & Animate shapes
-(void)createShapeFromPath:(CGPathRef)start end:(CGPathRef)end withColor:(UIColor*)myFillColor andZIndex:(int)myZIndex withDelay:(CGFloat)pause
{
	//Create Shape
	menuShapeLayer = [CAShapeLayer layer];
	menuShapeLayer.zPosition = myZIndex;
	menuShapeLayer.path = start;
	menuShapeLayer.fillColor = myFillColor.CGColor;
	menuShapeLayer.opacity=0.0;
	[self.layer addSublayer:menuShapeLayer];
	[arr_shapeArray addObject:menuShapeLayer];
	UITapGestureRecognizer *menuFingerTap =
	[[UITapGestureRecognizer alloc] initWithTarget:self
											action:@selector(mainMenuTapped:)];
	[self addGestureRecognizer:menuFingerTap];
	[self startShapeAnimationWith:[arr_shapeArray lastObject] from:start to:end delay:pause];
}

#pragma mark - menu tap gesture handling
-(void)mainMenuTapped:(UIGestureRecognizer*)recognizer
{
	CGPoint touchPoint = [recognizer locationInView: self];
	[arr_bezierPathArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if( [obj containsPoint:touchPoint] ){
			[self pathTappedAtIndex:(int)idx];
			*stop = YES;    // Stop enumerating
			return;
		}
	}];
}

#pragma mark - Menu Open Animations
-(void)pathsForMenu
{
	isMenuClosing = NO;
	
	// grab all paths
	for (int i = 0; i  < [arr_polyShapes count]; i ++) {
		CGPathRef menuBtnPath = CGPathCreateMutable();
		menuBtnPath = CGPathCreateMutableCopy([self buildPathAtIndex:i fromArray:arr_polyShapes].CGPath);
		[arr_cgPathArray addObject:[UIBezierPath bezierPathWithCGPath:menuBtnPath]];
		CFRelease(menuBtnPath); // no release on ARC
	}
	
	// used for which to tap
	int ss = (int)[arr_polyShapes count];
	NSMutableArray *newArray = [[NSMutableArray alloc]init];
	
	for (int i = 1; i  < ss; i += 2) {
		//NSLog(@"i %i",i);
		[newArray addObject:[self buildPathAtIndex:(i) fromArray:arr_polyShapes]];
	}
	
	arr_bezierPathArray = [NSMutableArray arrayWithArray:[newArray objectsAtIndexes:[ newArray indexesOfObjectsPassingTest:^BOOL( id obj, NSUInteger index, BOOL * stop) {
				return (index & 1) == 0 ;
			} ] ]] ;
		
	// draw & animate paths
	UIColor *bgColor;
	int myZindex = 0;
	int step = 2;
	for (int i = 0; i  < [arr_polyShapes count]/step; i ++) {

		UIBezierPath *one = arr_cgPathArray [i*step];
		CGPathRef ref = one.CGPath;
		UIBezierPath *two = arr_cgPathArray [(i*step) + 1];
		CGPathRef reff = two.CGPath;
		
		switch (i) {
			case 0:
				bgColor = panelColor;
				break;
			case 1:
				bgColor = buttonColor;
				break;
			case 2: // button
				bgColor = arrowColor;
				break;
			case 3:
				bgColor = [UIColor colorWithRed: 0.827 green: 0.278 blue: 0.153 alpha: 1];
				break;
			case 4:
				bgColor = [UIColor colorWithRed: 0.145 green: 0.593 blue: 0.647 alpha: 1];
				break;
			default:
				break;
		}
				
		NSDictionary *tmp = arr_allShapes[i];
		myZindex = (int)[[tmp valueForKey:@"pathZindex"]integerValue];
		
		CGFloat pause = [arr_pauses[i]floatValue];
		
		[self createShapeFromPath:isMenuClosing ? reff : ref
										end:isMenuClosing ? ref : reff
								  withColor:bgColor
								  andZIndex:myZindex
								  withDelay:pause*1*i];
	}
	
	NSInteger i = 0;
	for(UIView *view in [self subviews]) {
		if([view isKindOfClass:[UILabel class]]) {
			UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction;
			[UIView animateWithDuration:.33 delay:((0.05 * i) + 0.2) options:options
							 animations:^{
								 view.alpha = 1.0;
								 view.layer.contentsRect = CGRectMake(0.0, 0.0, 1.0, 1.0);
							 }
							 completion:^(BOOL finished){
							 }];
			i += 1;
		}
	}
}


#pragma mark - Animations
-(void)startShapeAnimationWith:(CAShapeLayer*)myLayer from:(CGPathRef)startPath to:(CGPathRef)endPath delay:(CGFloat)delay
{
	myLayer.opacity=1.0;
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
	animation.duration = 0.33;
	[animation setBeginTime:CACurrentMediaTime()+delay];
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	[animation setValue:@"menuAnim" forKey:@"Name"];
	animation.delegate=self;
	animation.fromValue = (__bridge id)startPath;
	animation.toValue = (__bridge id)endPath;
	animation.removedOnCompletion = NO;
	animation.fillMode = kCAFillModeForwards;
	[myLayer addAnimation:animation forKey:@"animatePath"];
}

-(void)reverseAnimationWith:(CAShapeLayer*)myLayer from:(CGPathRef)startPath to:(CGPathRef)endPath delay:(CGFloat)delay
{
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
	animation.duration = 0.33;
	[animation setBeginTime:CACurrentMediaTime()+delay];
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	animation.fromValue = (__bridge id)startPath;
	animation.toValue = (__bridge id)endPath;
	animation.removedOnCompletion = YES;
	animation.fillMode = kCAFillModeBoth;
	[myLayer addAnimation:animation forKey:@"animatePath"];
	
	[self performSelector:@selector(cleanShapeOffScreen:) withObject:myLayer afterDelay:delay+0.33];
}

#pragma mark - utility
- (UIBezierPath *)buildPathAtIndex:(int)index fromArray:(NSArray*)data {
    NSArray *coords = [data[index] componentsSeparatedByString:@","];
    UIBezierPath *path = nil;
    if(!path){
        path = [UIBezierPath bezierPath];
        for(NSUInteger i=0;i<coords.count;i++){
            if(i == 1){
                [path moveToPoint:CGPointMake([coords[0] floatValue],[coords[1] floatValue])];
            }else if(i > 1 && i % 2 != 0){
                [path addLineToPoint:CGPointMake([coords[(i-1)] floatValue],[coords[i] floatValue])];
            }
        }
        [path closePath];
    }
    return path;
}

-(void)cleanShapeOffScreen:(CAShapeLayer*)layerToRemove {
	[layerToRemove removeFromSuperlayer];
	[arr_allShapes removeObject:layerToRemove];
}

#pragma mark - Menu Close
-(void)animateMenuClose
{
	isMenuClosing = YES;
	[self setUserInteractionEnabled:NO];
		
	int s = 2; // step value
	for (int i = (int)[arr_allShapes count]; i  > 0; i --) {
		UIBezierPath *one = arr_cgPathArray [(i*s) - 2];
		CGPathRef ref = one.CGPath;
		UIBezierPath *two = arr_cgPathArray [(i*s) - 1];
		CGPathRef reff = two.CGPath;
	
		[self indexOfShapeToReverse:i-1 withPath:reff end:ref delay:kMenuCloseAnimSpeed-(kMenuOpenAnimSpeed*i)];
	}
	
	NSInteger i = 0;
	for(UIView *view in [self subviews]) {
		if([view isKindOfClass:[UILabel class]]) {
			UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction;
			[UIView animateWithDuration:.18 delay:((0.05 * i) + 0.2) options:options
							 animations:^{
								 view.alpha = 1.0;
								 view.layer.contentsRect = CGRectMake(0.0, 0.0, 1.0, 0.0);
							 }
							 completion:^(BOOL finished){
								 [view removeFromSuperview];
							 }];
			i += 1;
		}
	}
}

#pragma mark Menu Shape reverse
-(void)indexOfShapeToReverse:(int)index withPath:(CGPathRef)start end:(CGPathRef)end delay:(CGFloat)delay
{
	//Create Shape
	menuShapeLayer = arr_shapeArray[index];
	menuShapeLayer.path = end;
	[self reverseAnimationWith:arr_shapeArray[index] from:start to:end delay:delay];
}

- (void) dealloc {
	arr_allShapes=nil;
	arr_bezierPathArray=nil;
	arr_cgPathArray=nil;
	arr_pauses=nil;
	arr_polyShapes=nil;
	arr_shapeArray=nil;
    delegate = nil;
}

@end
