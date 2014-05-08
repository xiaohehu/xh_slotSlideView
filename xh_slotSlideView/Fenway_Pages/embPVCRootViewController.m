//
//  embRootViewController.m
//  Example
//
//  Created by Evan Buxton on 11/23/13.
//  Copyright (c) 2013 neoscape. All rights reserved.
//

#import "embPVCRootViewController.h"
#import "embPVCModelController.h"
#import "embPVCBaseViewController.h"
#import "embMorphTwoPaths.h"

@interface embPVCRootViewController () <embMorphTwoPathsDelegate>
{
	CGRect				titleLabelFrame;
	NSArray				*arr_titleArray;
	int					pageToLoad;
	int					pageCurrent;
	int					convertedPageIndex;
	NSMutableArray		*buttons;
	NSArray				*paneldata;
	NSArray				*rightpaneldata;
    UIStoryboard        *storyboard;
    int                 pageInSection;
    int                 prePageInSection;
}

@property (readonly, strong, nonatomic) embPVCModelController	*modelController;
@property (nonatomic, strong)			embMorphTwoPaths		*embdraw2dview;
@property (nonatomic, strong)			embMorphTwoPaths		*embdraw2dRightPanel;
@property (nonatomic, strong)			UIButton				*uib_panelBtn;
@property (nonatomic, strong)			UIButton				*uib_rightPanelBtn;
@property (assign)						NSUInteger				pageIndex;
@property (assign)						NSUInteger				prevIndex;
@property (nonatomic, strong)			UILabel					*titleLabel;
@property (nonatomic, strong)			NSMutableArray			*arr_titleLabels;
@property (nonatomic, strong)			UIImageView				*panelImg;
@property (nonatomic, strong)			NSArray					*sectionsIndex;
@property (nonatomic, strong)			UIView					*uivBtn_container;
@property (nonatomic, strong)			UIButton				*uib_hiliteBtn;
@property (nonatomic, strong)           UIButton                *uib_pageNum;
@end

@implementation embPVCRootViewController

static int TotalPages = 7;

@synthesize modelController = _modelController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDictionary *dict_option = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:50],@"UIPageViewControllerOptionInterPageSpacingKey", nil];
	// Do any additional setup after loading the view, typically from a nib.
	// Configure the page view controller and add it as a child view controller.
	self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:dict_option];
	self.pageViewController.delegate = self;

//    UIStoryboard *tmpSb = [[UIStoryboard alloc] instantiateViewControllerWithIdentifier:@"Fenway"];
    storyboard = [UIStoryboard storyboardWithName:@"Fenway" bundle:nil];
    
	embPVCBaseViewController *startingViewController = [self.modelController viewControllerAtIndex:0 storyboard:storyboard];
	NSArray *viewControllers = @[startingViewController];
	[self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

	self.pageViewController.dataSource = self.modelController;

	[self addChildViewController:self.pageViewController];
	[self.view addSubview:self.pageViewController.view];

	// Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
	CGRect pageViewRect = self.view.bounds;
	pageViewRect = CGRectInset(pageViewRect, 0.0, 0.0);
	self.pageViewController.view.frame = pageViewRect;

	[self.pageViewController didMoveToParentViewController:self];

	// Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
	self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
	
	[self createMenuButtons];
	
//	UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 204, 67)];
//	logo.image = [UIImage imageNamed:@"logo.png"];
//	[self.view insertSubview:logo atIndex:HUGE_VAL];
//	
//	UIImageView *subnav = [[UIImageView alloc] initWithFrame:CGRectMake(0, 728, 1024, 40)];
//	subnav.image = [UIImage imageNamed:@"subnav.png"];
//	[self.view insertSubview:subnav atIndex:HUGE_VAL];
	
	// labels for titles
	_arr_titleLabels = [[NSMutableArray alloc] init];
	
	// just to set initial value of pagendex var
	[self setPageIndex];
	
	[self titleLabels];
	
	// example
	//[self loadPageFromParent:_incomingIndex];
    prePageInSection = -1;
}

-(void)createMenuButtons
{
	CGFloat staticWidth     = 105;		// Static Width for all Buttons.
	CGFloat staticHeight    = 42;		// Static Height for all buttons.
	CGFloat staticPadding   = 10;		// Padding to add between each button.
	
//	_sectionsIndex		= @[@0,@3,@7,@13,@16];
    _sectionsIndex		= @[@1,@2,@3,@4,@5,@6];
	NSArray *sectionTitles	= @[@"BIKE",@"PUBLIC TRANSPORT",@"PLANE",@"FOOT",@"BOAT", @"CAR"];
//    _sectionsIndex		= @[@0,@3,@5,@7,@13,@16];
//	NSArray *sectionTitles	= @[@"INTRODUCTION",@"CULTURE",@"SCIENCE",@"RESIDENTIAL",@"GREEN SPACE",@"RETAIL"];
	
	_uivBtn_container = [[UIView alloc] initWithFrame:CGRectMake(158, 675, _sectionsIndex.count*(staticWidth+staticPadding)+40, staticHeight)];
    
	[self.view insertSubview:_uivBtn_container atIndex:HUGE_VAL];
	
	buttons = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < [_sectionsIndex count]; i++)
	{
		UIButton *settButton = [UIButton buttonWithType:UIButtonTypeCustom];
		//[settButton setTag:i];
        if (i ==0) {
            [settButton setFrame:CGRectMake(((i * (staticWidth+staticPadding))),0,staticWidth,staticHeight)];
        }
        else if (i==1){
            [settButton setFrame:CGRectMake(((i * (staticWidth+staticPadding))),0,staticWidth+40,staticHeight)];
        }
        else if (i > 1){
            [settButton setFrame:CGRectMake(((i * (staticWidth+staticPadding)))+40,0,staticWidth,staticHeight)];
        }
		
		settButton.tag = [_sectionsIndex[i] integerValue];
		[settButton setTitle:sectionTitles[i] forState:UIControlStateNormal];
		[settButton setTitle:sectionTitles[i] forState:UIControlStateSelected];
		[settButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
		[settButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
		
		settButton.titleLabel.font = [UIFont systemFontOfSize:13]; //custom font
		[settButton setTitleEdgeInsets:UIEdgeInsetsMake(5.0f, 0.0f, 0.0f, 0.0f)];
		settButton.backgroundColor = [UIColor blackColor];
		UIImage* defaultImage = [UIImage imageNamed:@"btn_fenway.png"];
		UIImage* hilightImage = [UIImage imageNamed:@"btn_fenway_hlt.png"];
		
		UIEdgeInsets insets = UIEdgeInsetsMake(0, 18, 0, 18);
		defaultImage = [defaultImage resizableImageWithCapInsets:insets];
		hilightImage = [hilightImage resizableImageWithCapInsets:insets];
		
		[settButton setBackgroundImage:defaultImage forState:UIControlStateNormal];
		[settButton setBackgroundImage:hilightImage forState:UIControlStateSelected];
		
		[settButton addTarget:self action:@selector(loadPage:) forControlEvents:UIControlEventTouchDown];
		[_uivBtn_container addSubview: settButton];
		[buttons addObject:settButton];
		
	}
	
	// BACK button
	staticWidth     = 36;		// Static Width for Back Button
	
	UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[menuButton setFrame:CGRectMake( _uivBtn_container.frame.origin.x-38,_uivBtn_container.frame.origin.y,56,staticHeight)];
	
    [menuButton setTitle:@"<" forState:UIControlStateNormal];
    [menuButton setTitle:@"<" forState:UIControlStateSelected];
    [menuButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    menuButton.titleLabel.font = [UIFont fontWithName:@"DINEngschriftStd" size:13.5]; //custom font
    [menuButton setTitleEdgeInsets:UIEdgeInsetsMake(5.0f, 0.0f, 0.0f, 0.0f)];
//	UIImage* defaultImage = [UIImage imageNamed:@"btn_menu_fenway.png"];
//	UIImage* hilightImage = [UIImage imageNamed:@"btn_menu_fenway_hlt.png"];
	UIImage* defaultImage = [UIImage imageNamed:@"btn_fenway.png"];
    UIImage* hilightImage = [UIImage imageNamed:@"btn_fenway_hlt.png"];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 18, 0, 18);
    defaultImage = [defaultImage resizableImageWithCapInsets:insets];
    hilightImage = [hilightImage resizableImageWithCapInsets:insets];
    
	[menuButton setBackgroundImage:defaultImage forState:UIControlStateNormal];
	[menuButton setBackgroundImage:hilightImage forState:UIControlStateSelected];

	[menuButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
//	[self.view addSubview: menuButton];
//    [self.view insertSubview:menuButton belowSubview:_uivBtn_container];
    
    UIImageView *uiiv_containerBG = [[UIImageView alloc] initWithFrame:CGRectMake(menuButton.frame.origin.x-2, _uivBtn_container.frame.origin.y-2, _uivBtn_container.frame.size.width+menuButton.frame.size.width+4, _uivBtn_container.frame.size.height+4)];
    uiiv_containerBG.image = [UIImage imageNamed:@"grfx_fenway_btn_bg.png"];
    [self.view insertSubview:uiiv_containerBG belowSubview:_uivBtn_container];
    
    _uib_pageNum = [[UIButton alloc] initWithFrame:CGRectMake(860.0, 685.0, 52.0, 21.0)];
    _uib_pageNum.backgroundColor = [UIColor clearColor];
    [_uib_pageNum setBackgroundImage:[UIImage imageNamed:@"grfx_pageBtn_bg.png"] forState:UIControlStateNormal];
    _uib_pageNum.userInteractionEnabled = NO;
//    [self.view addSubview: _uib_pageNum];
    
    UIImageView *uiiv_pageNumBg = [[UIImageView alloc] initWithFrame:CGRectMake(_uib_pageNum.frame.origin.x-2, _uib_pageNum.frame.origin.y-2, _uib_pageNum.frame.size.width+4, _uib_pageNum.frame.size.height+4)];
    uiiv_pageNumBg.image = [UIImage imageNamed:@"grfx_numBtn_bg.png"];
    [self.view insertSubview:uiiv_pageNumBg belowSubview:_uib_pageNum];
}

-(void)back:(id)sender
{
//	NSLog(@"MAKE YOUR OWN BACK FUNCTION");
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"removePageVC"
     object:self];
}

#pragma mark - Menu Button Utilities
-(void)clearAllButtons
{
	for (UIView *tmp in [_uivBtn_container subviews]) {
		if ([tmp isKindOfClass:[UIButton class]]) {
			[(UIButton*)tmp setSelected:NO];
			[(UIButton*)tmp setTitleColor:[UIColor colorWithRed:227.0/255.0 green:24.0/255.0 blue:55.0/255.0 alpha:1.0] forState:UIControlStateNormal];
		}
	}
}

-(void)hilightButton:(id)sender
{
	_uib_hiliteBtn = (UIButton*)sender;
	[_uib_hiliteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_uib_hiliteBtn setSelected:YES];
}

-(void)scaleButtons:(id)sender
{
	UIButton *menubtn  = (UIButton*)sender;
	
	CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];///use transform
	theAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    theAnimation.duration=0.10;
    theAnimation.repeatCount=0;
    theAnimation.autoreverses=YES;
    theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
    theAnimation.toValue=[NSNumber numberWithFloat:0.9];
    [menubtn.layer addAnimation:theAnimation forKey:@"animateTranslation"];//animationkey
}

#pragma mark - model
- (embPVCModelController *)modelController
{
     // Return the model controller object, creating it if necessary.
     // In more complex implementations, the model controller may be passed to the view controller.
    if (!_modelController) {
        _modelController = [[embPVCModelController alloc] init];
    }
    return _modelController;
}

#pragma mark - UIPageViewController delegate methods

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
	// clean up for next pages
	_embdraw2dRightPanel.delegate=nil;
	[_embdraw2dRightPanel animateMenuClose];
	[_panelImg removeFromSuperview];
	_embdraw2dRightPanel=nil;
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addPanel:) object: nil];
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addPanelRight) object: nil];
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addTitleLabels) object: nil];
}


- (void)pageViewController:(UIPageViewController *)pvc didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
	if (completed) {
		[self setPageIndex];
//		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addTitleLabels) object: nil];
	}
}


#pragma mark - Set Page Index
-(void)setPageIndex
{
    embPVCBaseViewController *theCurrentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
    _pageIndex = [self.modelController indexOfViewController:theCurrentViewController];
    
    NSLog(@"\n\nThe current page is %i", _pageIndex);
    if (_pageIndex == TotalPages) {
        _pageIndex = 0;
        
        _uib_hiliteBtn = buttons[0];
        [self clearAllButtons];
        [self hilightButton:_uib_hiliteBtn];

        UIStoryboard *tmp_Sb = [UIStoryboard storyboardWithName:@"Fenway" bundle:nil];
        
        embPVCBaseViewController *startingViewController = [self.modelController viewControllerAtIndex:_pageIndex storyboard:tmp_Sb];
        
        NSArray *viewControllers = @[startingViewController];
        
        [self.pageViewController setViewControllers:viewControllers
                                              direction:UIPageViewControllerNavigationDirectionForward
                                               animated:NO
                                         completion:nil];
        return;
    }
    if (_pageIndex == 0) {
        _pageIndex = TotalPages;
        
        _uib_hiliteBtn = buttons[5];
        [self clearAllButtons];
        [self hilightButton:_uib_hiliteBtn];
        UIStoryboard *tmp_Sb = [UIStoryboard storyboardWithName:@"Fenway" bundle:nil];
        
        embPVCBaseViewController *startingViewController = [self.modelController viewControllerAtIndex:_pageIndex storyboard:tmp_Sb];
        
        NSArray *viewControllers = @[startingViewController];
        
        [self.pageViewController setViewControllers:viewControllers
                                              direction:UIPageViewControllerNavigationDirectionReverse
                                               animated:NO
                                             completion:nil];
        return;
    }
    
	BOOL shouldAddPanel;
    BOOL shouldChange = NO;
	int convertedIndex = 1;
	int sumOfPage = 1;
    
	if (_pageIndex >= [_sectionsIndex[0]integerValue] && _pageIndex < [_sectionsIndex[1]integerValue]) {
//		shouldAddPanel=YES;
		convertedIndex = 0;
//        sumOfPage = 4;
		
	} else if (_pageIndex >= [_sectionsIndex[1]integerValue] && _pageIndex < [_sectionsIndex[2]integerValue]) {
//		shouldAddPanel=YES;
		convertedIndex = 1;
//        sumOfPage = 4;
		
	} else if (_pageIndex >= [_sectionsIndex[2]integerValue] && _pageIndex < [_sectionsIndex[3]integerValue]) {
//		shouldAddPanel=YES;
		convertedIndex = 2;
//        sumOfPage = 6;
		
	} else if (_pageIndex >= [_sectionsIndex[3]integerValue] && _pageIndex < [_sectionsIndex[4]integerValue]) {
//		shouldAddPanel=YES;
		convertedIndex = 3;
//		sumOfPage = 3;
	}
    else if (_pageIndex >= [_sectionsIndex[4]integerValue] && _pageIndex < [_sectionsIndex[5]integerValue]) {
//		shouldAddPanel=YES;
		convertedIndex = 4;
//        sumOfPage = 9;
	}
    else if (_pageIndex >= [_sectionsIndex[5]integerValue]) { //&& _pageIndex < [_sectionsIndex[5]integerValue]) {
        //		shouldAddPanel=YES;
		convertedIndex = 5;
        //        sumOfPage = 9;
	}
//    else if (_pageIndex >= [_sectionsIndex[5]integerValue]) {
//		shouldAddPanel=YES;
//		convertedIndex = 5;
//	}

    
	// add panel if needed
	if (_pageIndex == [_sectionsIndex[0]integerValue]) { //
//		shouldAddPanel=YES;
        pageInSection = 1;
        shouldChange = NO;
	} else if (_pageIndex == [_sectionsIndex[1]integerValue]) { //
//		shouldAddPanel=YES;
        pageInSection = 1;
        shouldChange = NO;
	} else if (_pageIndex == [_sectionsIndex[2]integerValue]) { //
//		shouldAddPanel=YES;
        pageInSection = 1;
        shouldChange = NO;
	} else if (_pageIndex == [_sectionsIndex[3]integerValue]) { //
//		shouldAddPanel=YES;
        pageInSection = 1;
        shouldChange = NO;
	} else if (_pageIndex == [_sectionsIndex[4]integerValue]) { //
//		shouldAddPanel=YES;
        pageInSection = 1;
        shouldChange = NO;
//	} else if (_pageIndex == [_sectionsIndex[5]integerValue]) { //
//		shouldAddPanel=YES;
	}
    
    else {
    
        if (_pageIndex == 3) {
            pageInSection = 4;
            shouldChange = NO;
        }
        if (_pageIndex == 7) {
            pageInSection = 4;
            shouldChange = NO;
        }
        if (_pageIndex == 13) {
            pageInSection = 6;
            shouldChange = NO;
        }
        if (_pageIndex == 16) {
            pageInSection = 3;
            shouldChange = NO;
        }
        if (_pageIndex == 25) {
            pageInSection = 9;
            shouldChange = NO;
        }
        
        else if ((prePageInSection != -1) && shouldChange) {
            if (_pageIndex > prePageInSection) {
                pageInSection = pageInSection + 1;
            }
            if (_pageIndex < prePageInSection) {
                pageInSection = pageInSection - 1;
            }
        }
        
		shouldAddPanel=NO;
		[self removePanel];
		[self animateLabelsAway];
		[_panelImg removeFromSuperview];
	}
	
    NSString *pageBtnTitle = [[NSString alloc] initWithFormat:@"%i OF %i", pageInSection, sumOfPage];
    [_uib_pageNum setTitle:pageBtnTitle forState:UIControlStateNormal];
    [_uib_pageNum setTitleColor:[UIColor colorWithRed:227.0/255.0 green:24.0/255.0 blue:55.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    _uib_pageNum.titleLabel.font = [UIFont fontWithName:@"DINEngschriftStd" size:13.5]; //custom font
    [_uib_pageNum setTitleEdgeInsets:UIEdgeInsetsMake(3.0f, 0.0f, 0.0f, 0.0f)];
    
	_uib_hiliteBtn = buttons[convertedIndex];
	[self clearAllButtons];
	[self hilightButton:_uib_hiliteBtn];

	[self performSelector:@selector(addPanelRight) withObject:nil afterDelay:0.33];
	
	if (shouldAddPanel==YES) {
		NSLog(@"shouldAddPanel");
		[self performSelector:@selector(addPanel:) withObject:nil afterDelay:0.33];
		[self animateLabelsAway];
	}
    
    prePageInSection = (int)_pageIndex;
}

-(void)loadPageFromParent:(int)index
{
	UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
	btn.tag = index;
    _incomingIndex = index;
	[self loadPage:btn];
}

-(void)loadPage:(id)sender
{
	[self clearAllButtons];
	[self hilightButton:sender];
	[self scaleButtons:sender];
	
	if (_uib_rightPanelBtn) {
		[_uib_rightPanelBtn removeFromSuperview];
	}
	
	// data for the page that is loading
	self.pageViewController.dataSource = self.modelController;
	
	_pageIndex = [sender tag];
    UIStoryboard *tmp_Sb = [UIStoryboard storyboardWithName:@"Fenway" bundle:nil];

	embPVCBaseViewController *startingViewController = [self.modelController viewControllerAtIndex:_pageIndex storyboard:tmp_Sb];
	
	NSArray *viewControllers = @[startingViewController];
	
	if (_pageIndex<pageCurrent) {
		[self.pageViewController setViewControllers:viewControllers
										  direction:UIPageViewControllerNavigationDirectionReverse
										   animated:NO
										 completion:nil];
	} else {
		[self.pageViewController setViewControllers:viewControllers
										  direction:UIPageViewControllerNavigationDirectionForward
										   animated:NO
										 completion:nil];
	}
	
	[self setPageIndex];

}

-(NSArray*)rightPanelData
{
	if (!rightpaneldata) {
		NSString *path = [[NSBundle mainBundle] pathForResource:
						  @"panel_images" ofType:@"plist"];
		// Build the array from the plist
		rightpaneldata= [[NSArray alloc] initWithContentsOfFile:path];
	}
	
	return rightpaneldata;
}

-(void)addPanelRight
{
	[_panelImg removeFromSuperview];
	
	NSLog(@"addPanelRight");
	if (_embdraw2dRightPanel) {
		[_embdraw2dRightPanel removeFromSuperview];
	}
	
	if (_uib_rightPanelBtn) {
		[_uib_rightPanelBtn removeFromSuperview];
	}

	[self rightPanelData];
	
	int convertedIndex = -1;
	
	// convert index
	if (_pageIndex == 9) {
		convertedIndex = 1;
	} else if (_pageIndex == 7) {
		convertedIndex = 2;
	} else if (_pageIndex == 8) {
		convertedIndex = 3;
	} else {
		convertedIndex=(int)_prevIndex;
		return;
	}
	
	if	(!_panelImg) {
		_panelImg = [[UIImageView alloc] initWithFrame:CGRectMake(620, 0, 400, 768)];
	}
	
	_panelImg.image = [UIImage imageNamed:rightpaneldata[convertedIndex]];
	_panelImg.alpha = 0.0;
	[self.view insertSubview:_panelImg atIndex:HUGE_VAL];
	
	double delayInSeconds = 0.33;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		_panelImg.alpha = 1.0;
	});
	
	// clever. we set the view to zero, and clips to NO so touches pass to the scrollview.
	// http://stackoverflow.com/questions/7488551/how-to-pass-touches-from-uiview-to-uiscrollview
	
	_embdraw2dRightPanel = [[embMorphTwoPaths alloc] initWithFrame:CGRectZero andPlistName:@"panel_fenway"];
	_embdraw2dRightPanel.clipsToBounds = NO;
	_embdraw2dRightPanel.buttonColor = [UIColor whiteColor];
	_embdraw2dRightPanel.arrowColor = [UIColor colorWithRed: 0.827 green: 0.278 blue: 0.153 alpha: 1];
	_embdraw2dRightPanel.pauseDelay=0.1f;
	_embdraw2dRightPanel.delegate=self;
	
	_embdraw2dRightPanel.panelAlignment = embPanelLeftAlignment;
	
	_uib_rightPanelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[_uib_rightPanelBtn addTarget:self
					  action:@selector(hidePanels)
			forControlEvents:UIControlEventTouchDown];
		
	CGRect buttonframe = CGRectZero;
	if (_embdraw2dRightPanel.panelAlignment == embPanelLeftAlignment) {
		buttonframe = CGRectMake(880.0, 625.0, 40.0, 40.0);
		_uib_rightPanelBtn.frame = buttonframe;
	}
	
	[self.view insertSubview:_uib_rightPanelBtn aboveSubview:_embdraw2dRightPanel];
	
	_embdraw2dRightPanel.panelColor = [UIColor colorWithRed: 0.827 green: 0.278 blue: 0.153 alpha: .9];
	[self.view insertSubview:_embdraw2dRightPanel belowSubview:_uivBtn_container];

}

#pragma mark - side panel
- (IBAction)addPanel:(id)sender
{
	NSLog(@"addpanel");
	if (_embdraw2dview) {
		[_embdraw2dview removeFromSuperview];
	}
	
	if (_uib_panelBtn) {
		[_uib_panelBtn removeFromSuperview];
	}
	
	if (_embdraw2dRightPanel) {
		[self addPanelRight];
	}
	
	// clever. we set the view to zero, and clips to NO so touches pass to the scrollview.
	// http://stackoverflow.com/questions/7488551/how-to-pass-touches-from-uiview-to-uiscrollview
	
	_embdraw2dview = [[embMorphTwoPaths alloc] initWithFrame:CGRectZero andPlistName:@"fenway_panel"];
	_embdraw2dview.clipsToBounds = NO;
	_embdraw2dview.buttonColor = [UIColor colorWithRed: 0.827 green: 0.278 blue: 0.153 alpha: 1];
	_embdraw2dview.arrowColor = [UIColor whiteColor];
	_embdraw2dview.pauseDelay=0.1f;;
	_embdraw2dview.delegate=self;
	
	_embdraw2dview.panelAlignment = embPanelLeftAlignment;
		
	_uib_panelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[_uib_panelBtn addTarget:self
					  action:@selector(hidePanels)
			forControlEvents:UIControlEventTouchDown];
	
	CGRect buttonframe = CGRectZero;
	if (_embdraw2dview.panelAlignment == embPanelLeftAlignment) {
		buttonframe = CGRectMake(205.0, 625.0, 60.0, 60.0);
		_uib_panelBtn.frame = buttonframe;
	} else {
		buttonframe = CGRectMake(630.0, 600.0, 60.0, 60.0);
		_uib_panelBtn.frame = buttonframe;
	}
	
	[self.view insertSubview:_uib_panelBtn aboveSubview:_embdraw2dview];
	
	_embdraw2dview.panelColor = [UIColor colorWithWhite:1.0 alpha: 1.0];
	[self.view insertSubview:_embdraw2dview atIndex:2];
	
	[self performSelector:@selector(addTitleLabels) withObject:nil afterDelay:0.2];
}

#pragma mark panel action
-(void)hidePanels
{
	[_panelImg removeFromSuperview];
	[_embdraw2dview animateMenuClose];
	[_embdraw2dRightPanel animateMenuClose];
	[_uib_panelBtn removeFromSuperview];
	
	[self animateLabelsAway];
	
	_uib_panelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[_uib_panelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_uib_panelBtn addTarget:self
					  action:@selector(addPanel:)
			forControlEvents:UIControlEventTouchUpInside];
	
	CGRect buttonframe = CGRectZero;
	if (_embdraw2dview.panelAlignment == embPanelLeftAlignment) {
		buttonframe = CGRectMake(0.0, 636.0, 60.0, 132.0);
		_uib_panelBtn.frame = buttonframe;
		_uib_panelBtn.transform = CGAffineTransformMakeTranslation(-132.0f, 0.0f);
		[self buttonAttributes:_uib_panelBtn isOpen:NO];

	} else {
		buttonframe = CGRectMake(965.0, 636.0, 60.0, 132.0);
		_uib_panelBtn.frame = buttonframe;
		_uib_panelBtn.transform = CGAffineTransformMakeTranslation(132.0f, 0.0f);
		[self buttonAttributes:_uib_panelBtn isOpen:YES];
	}
		
	if (_embdraw2dRightPanel) {
		_uib_rightPanelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[_uib_rightPanelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
		[_uib_rightPanelBtn addTarget:self
							   action:@selector(addPanel:)
					 forControlEvents:UIControlEventTouchDown];
		
		buttonframe = CGRectMake(965.0, 0.0, 60.0, 132.0);
		_uib_rightPanelBtn.frame = buttonframe;
		//_uib_panelBtn.transform = CGAffineTransformMakeTranslation(132.0f, 0.0f);
		[_uib_rightPanelBtn setTitle:@"<" forState:UIControlStateNormal];
		[_uib_rightPanelBtn setBackgroundImage:[UIImage imageNamed:@"btn_fenway_unhide_r.png"] forState:UIControlStateNormal];
		[_uib_rightPanelBtn setTitleEdgeInsets:UIEdgeInsetsMake(-30.0, 30.0, 0.0, 0.0)];
		[self.view insertSubview:_uib_rightPanelBtn belowSubview:_embdraw2dRightPanel];
	}
	
	[self.view insertSubview:_uib_panelBtn belowSubview:_embdraw2dview];
	
	[UIView animateWithDuration:0.33
					 animations:^{
						 _uib_panelBtn.transform = CGAffineTransformIdentity;
					 }
					 completion:NULL];
	
}

#pragma mark panel removal
-(void)removePanel
{
	[_uib_panelBtn removeFromSuperview];
	[_uib_rightPanelBtn removeFromSuperview];
	[_panelImg removeFromSuperview];
	[_panelImg removeFromSuperview];
	[self animateLabelsAway];
	
	_uib_panelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[_uib_panelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_uib_panelBtn addTarget:self
					  action:@selector(addPanel:)
			forControlEvents:UIControlEventTouchDown];
	

	CGRect buttonframe = CGRectZero;
	if (_embdraw2dview.panelAlignment == embPanelLeftAlignment) {
		buttonframe = CGRectMake(0.0, 636.0, 60.0, 132.0);
		_uib_panelBtn.frame = buttonframe;
		[self buttonAttributes:_uib_panelBtn isOpen:NO];

	} else {
		buttonframe = CGRectMake(965.0, 636.0, 60.0, 132.0);
		_uib_panelBtn.frame = buttonframe;
		[self buttonAttributes:_uib_panelBtn isOpen:YES];
	}
	
//	[self.view insertSubview:_uib_panelBtn belowSubview:_embdraw2dview];
	
	[UIView animateWithDuration:0.33
					 animations:^{
						 _uib_panelBtn.transform = CGAffineTransformIdentity;
						_embdraw2dview.transform = CGAffineTransformMakeTranslation(-275.0f, 0.0f);
					 }
					 completion:NULL];
}

-(void)buttonAttributes:(UIButton*)btn isOpen:(BOOL)isOpen
{
	if (isOpen) {
		[_uib_panelBtn setTitle:@"<" forState:UIControlStateNormal];
		[_uib_panelBtn setBackgroundImage:[UIImage imageNamed:@"btn_fenway_unhide_r.png"] forState:UIControlStateNormal];
		[_uib_panelBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 30.0, 0.0, 0.0)];
	} else {
		[_uib_panelBtn setTitle:@">" forState:UIControlStateNormal];
		[_uib_panelBtn setBackgroundImage:[UIImage imageNamed:@"btn_fenway_unhide_l.png"] forState:UIControlStateNormal];
		[_uib_panelBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -30.0, 0.0, 0.0)];
	}
}

-(NSArray*)titleLabels
{
	if (!paneldata) {
		NSString *path = [[NSBundle mainBundle] pathForResource:
						  @"titles" ofType:@"plist"];
		// Build the array from the plist
		paneldata = [[NSArray alloc] initWithContentsOfFile:path];
	}

	return paneldata;
}

-(void)convertPageIndex
{
	convertedPageIndex = -1;
	
	if (_pageIndex == [_sectionsIndex[0]integerValue]) { //
		convertedPageIndex = 0;
	} else if (_pageIndex == [_sectionsIndex[1]integerValue]) { //
		convertedPageIndex = 1;
	} else if (_pageIndex == [_sectionsIndex[2]integerValue]) { //
		convertedPageIndex = 2;
	} else if (_pageIndex == [_sectionsIndex[3]integerValue]) { //
		convertedPageIndex = 3;
	} else if (_pageIndex == [_sectionsIndex[4]integerValue]) { //
		convertedPageIndex = 4;
	} else if (_pageIndex == [_sectionsIndex[5]integerValue]) { //
		convertedPageIndex = 5;
	} else {
		convertedPageIndex=(int)_prevIndex;
	}
}

-(void)addTitleLabels
{

	NSArray *lblarray;
	
	[self convertPageIndex];
	_prevIndex = convertedPageIndex;
	
	lblarray = [paneldata[convertedPageIndex][0] componentsSeparatedByString:@"."];
	
	arr_titleArray = [[NSMutableArray alloc] init];
	arr_titleArray = lblarray;
	
	int x = 0;
	int y = 0;
	
	for (int i=0; i< arr_titleArray.count; i++)
	{
		// Create the label
		if (_embdraw2dview.panelAlignment == embPanelLeftAlignment) {
			if (arr_titleArray.count==1) {
				titleLabelFrame = CGRectMake(185-x, 490-y, 650, 100); //107,90
			} else if (arr_titleArray.count==2) {
				titleLabelFrame = CGRectMake(145-x, 490-y-(80), 650, 100); //107,90
			} else if (arr_titleArray.count==3) {
				titleLabelFrame = CGRectMake(118-x, 490-y-(150), 650, 100); //107,90
			}
		} else if
			(_embdraw2dview.panelAlignment == embPanelRightAlignment) {
				titleLabelFrame = CGRectMake(246-x, 490+y, 650, 100);
			}
		
		CGRect rectQty = titleLabelFrame;
		_titleLabel = [[UILabel alloc] initWithFrame:rectQty];
		NSString *tUpper = [arr_titleArray[i] uppercaseString];
		[_titleLabel setText:tUpper];
		
		_titleLabel.font = [UIFont fontWithName:@"DINEngschriftStd" size:75]; //custom font
		_titleLabel.numberOfLines = 1;
		_titleLabel.baselineAdjustment = YES;
		_titleLabel.adjustsFontSizeToFitWidth = YES;
		_titleLabel.minimumScaleFactor = 1.0;
		_titleLabel.clipsToBounds = YES;
		_titleLabel.backgroundColor = [UIColor clearColor];
		_titleLabel.textColor = [UIColor whiteColor];
		
		_titleLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
        _titleLabel.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        _titleLabel.layer.shadowOpacity = 0.4f;
        _titleLabel.layer.shadowRadius = 15.0f;
		_titleLabel.layer.shouldRasterize = YES;
		_titleLabel.clipsToBounds = NO;
		
		if (_embdraw2dview.panelAlignment == embPanelLeftAlignment) {
			_titleLabel.textAlignment = NSTextAlignmentLeft;
		} else if
			(_embdraw2dview.panelAlignment == embPanelRightAlignment) {
				_titleLabel.textAlignment = NSTextAlignmentRight;
			}
		
		_titleLabel.alpha = 1.0;
		[_titleLabel setUserInteractionEnabled:NO];
		_titleLabel.layer.contentsRect = CGRectMake(0.0, 0.0, 1.0, 0.0);
		y = y - 75.0;
		x = x - 35.0;
//		[self.view insertSubview:_titleLabel belowSubview:_embdraw2dview];
		
		[_arr_titleLabels addObject:_titleLabel];
	}
	
	NSInteger i = 0;
	for(UIView *view in [self.view subviews]) {
		if([view isKindOfClass:[UILabel class]]) {
			UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction;
			[UIView animateWithDuration:.33 delay:((0.05 * i) + 0.2) options:options
							 animations:^{
								 view.alpha = 1.0;
								 view.layer.contentsRect = CGRectMake(0.0, 0.0, 1.0, 1.0);
							 }
							 completion:^(BOOL finished){
								 NSLog(@"add more labels");
							 }];
			i += 1;
		}
	}
}

-(void)animateLabelsAway
{
	for (int i=0; i< arr_titleArray.count; i++) {
		for(UIView *view in [self.view subviews]) {
			if([view isKindOfClass:[UILabel class]]) {
				UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction;
				[UIView animateWithDuration:.33 delay:((0.05 * i) + 0.2) options:options
								 animations:^{
									 view.alpha = 0.0;
									 view.layer.contentsRect = CGRectMake(0.0, 0.0, 0.0, 1.0);
								 }
								 completion:^(BOOL finished){
									 [view removeFromSuperview];
								 }];
				i += 1;
			}
		}
	}
}

#pragma mark - Boilerplate
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
