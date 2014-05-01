//
//  embViewController.m
//  MaskImagePVC
//
//  Created by Evan Buxton on 2/4/14.
//  Copyright (c) 2014 neoscape. All rights reserved.
//

#import "embBlockViewController.h"
#import "embDrawBezierPath.h"
#import "embFenwayBlockPaths.h"

@interface embBlockViewController () <embDrawBezierPathDelegate>
{
	BOOL			cancelled;
	UIView			*dataView;
	NSString		*str_Title;
	NSString		*str_Body;
	NSArray			*plistArray;
	NSDictionary	*dict;
	int				currentIndex;
}

@property (nonatomic, strong) embDrawBezierPath                 *blockPath;
@property (nonatomic, strong) NSMutableArray                    *pathsArray;
@property (nonatomic, strong) embFenwayBlockPaths				*embPlanPath;


@end

@implementation embBlockViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	NSString *plistPath = [[NSBundle mainBundle] pathForResource:
						   @"fenway_blockData" ofType:@"plist"];
	//Build the array from the plist
	plistArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
}

-(void)viewDidAppear:(BOOL)animated
{
	//cancelled=YES;
	[self drawPaths];
}

-(void)viewDidDisappear:(BOOL)animated
{
	//cancelled=YES;
	//[_blockPath removeFromSuperview];
}

#pragma mark - Darw Paths On Map
-(void)drawPaths
{
	
	_embPlanPath = [[embFenwayBlockPaths alloc] init];
	_pathsArray = _embPlanPath.bezierPaths;
	
	// actual drawpath function
	_blockPath = [[embDrawBezierPath alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
	_blockPath.delegate=self;
	[self.view addSubview:_blockPath];
	
	for (int i=0; i<[_pathsArray count]; i++) {
		
		embBezierPathItem *p = _pathsArray[i];
		NSLog(@"%@", [p description]);
		
		_blockPath.myPath = p.embPath;
		_blockPath.animationSpeed = 0;
		_blockPath.pathStrokeColor = [UIColor redColor];
		_blockPath.pathFillColor = [UIColor clearColor];
		_blockPath.pathLineWidth = 3.0;
		_blockPath.animationSpeed = 1.5;
		_blockPath.isTappable = YES;
		_blockPath.animated = YES;
		_blockPath.isStack = NO;
		[_blockPath startAnimationFromIndex:i afterDelay:p.pathDelay];
	}

	
//	// Delay execution of my block for 10 seconds.
//	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.00 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//		//while (!cancelled) {
//			[_blockPath fadePaths];
//			cancelled = NO;
//		//}
//		NSLog(@"stopped");
//	});
}

#pragma mark - Path Drawing Delegate Methods
-(void)pathAnimating:(embDrawBezierPath *)animating {
	//NSLog(@"animating");
}

-(void)didFinishAnimatingPath:(embDrawBezierPath *)finished {
	//NSLog(@"finished animating path");
}

-(void)didFinishAllAnimations:(embDrawBezierPath *)finished {
	//NSLog(@"finished All");
	if (!cancelled) {
		[_blockPath fadePaths];
	}
	//cancelled = YES;
}

-(void)embDrawBezierPath:(embDrawBezierPath *)path indexOfTapped:(int)i
{
	cancelled = YES;
	
	[_blockPath fadePaths];
	
	// remove existing dataView
	if (dataView) {
		[UIView animateWithDuration:0.33
	 					 animations:^{
							 dataView.tag = 1100;
							 dataView.transform = CGAffineTransformMakeTranslation(-380, -145);
							 dataView.alpha = 0.0;
						 }
	 					 completion:^(BOOL completed){
						 }];
	}
	
	if (currentIndex!=i) {
		dict = plistArray[i];
		[self performSelector:@selector(drawDataView:) withObject:dict afterDelay:0.33];
		currentIndex = i;
	} else {
		currentIndex = -1;
	}

}

-(void)drawDataView:(NSDictionary*)summDict
{
	if (dataView) {
		[dataView removeFromSuperview];
		str_Title=nil;
		str_Body=nil;
	}
	
	NSLog(@"%@",summDict);

	str_Title = [summDict objectForKey:@"title"];
	
	if ([summDict objectForKey:@"body"] != nil) {
		str_Body = [summDict objectForKey:@"body"];
	}
	
	if ([str_Body length]==0) {
		dataView = [[UIView alloc] initWithFrame:CGRectMake(1024, 75, 350, 75)];
	} else {
		dataView = [[UIView alloc] initWithFrame:CGRectMake(1024, 75, 350, 125)];
	}
	
	dataView.tag = 1000;
	[dataView setBackgroundColor:[UIColor colorWithRed:211.0/255.0f green:71.0f/255.0 blue:39.0/255.0 alpha:1.0]];
	
	UILabel *dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 320, 40)];
	dataLabel.textAlignment = NSTextAlignmentCenter;
	[dataLabel setTextColor:[UIColor whiteColor]];
	[dataLabel setFont:[UIFont fontWithName:@"Futura" size:18]];
    [dataLabel setBackgroundColor:[UIColor clearColor]];
	[dataView addSubview:dataLabel];
	dataLabel.text = str_Title;
	
	CGRect textViewFrame = CGRectMake(15.0f, 40.0f, 320, 124.0f);
	UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame];
	[textView setTextAlignment:NSTextAlignmentCenter];
	[textView setBackgroundColor:[UIColor clearColor]];
	[textView setTextColor:[UIColor whiteColor]];
	textView.editable = NO;
	[textView setText:str_Body];
	[textView setFont:[UIFont fontWithName:@"Futura" size:14]];
	[dataView addSubview:textView];
	
	[self.view addSubview:dataView];

//	UIButton *uib_loadMore = [UIButton buttonWithType:UIButtonTypeCustom];
//	uib_loadMore.frame = CGRectMake(120, 90, 80, 35);
//	[uib_loadMore setTitle:@"More" forState:UIControlStateNormal];
//	[uib_loadMore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//	[uib_loadMore setBackgroundColor:[UIColor redColor]];
//	[dataView addSubview:uib_loadMore];
	
	[UIView animateWithDuration:0.33
					 animations:^{
						 dataView.transform = CGAffineTransformMakeTranslation(-380, 0);
					 }
					 completion:^(BOOL completed){
						 [(UIView*)[self.view viewWithTag:1100] removeFromSuperview];
					 }];
	
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
