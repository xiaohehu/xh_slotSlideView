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
#import "menuWithIndicator.h"
#import "UIColor+Extensions.h"
@interface embPVCRootViewController () <embMorphTwoPathsDelegate, indicatorMenuDataSource, indicatorMenuDelegate>
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

@property (nonatomic, strong)           menuWithIndicator       *indicatorMenu;
@property (nonatomic, strong)           UIImageView             *uiiv_titleImage;
@property (nonatomic, strong)           NSArray                 *arr_titleImage;
@end

@implementation embPVCRootViewController

static int TotalPages = 7;

@synthesize modelController = _modelController;

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.frame = CGRectMake(0.0, 0.0, 1024.0, 768.0);
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
	
//	[self createMenuButtons];
	
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
	
    //Alloc the menu with indicator
    _indicatorMenu = [[menuWithIndicator alloc] initWithFrame:CGRectMake(585, 685.0, 420.0, 60.0)];
    _indicatorMenu.dataSource = self;
    _indicatorMenu.delegate = self;
    [self.view addSubview: _indicatorMenu];
    //Init title ImageView & title image array
    _arr_titleImage = [[NSArray alloc] initWithObjects:@"byCar.jpg",@"byBoat.jpg", @"byRail.jpg", @"byPlane.jpg", @"byBike.jpg", @"byFoot.jpg", nil];
    _uiiv_titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 588, 270, 180)];
    NSLog(@"%@", _arr_titleImage);
    [_uiiv_titleImage setContentMode:UIViewContentModeScaleAspectFit];
//    _uiiv_titleImage.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_uiiv_titleImage];
    
	// example
	//[self loadPageFromParent:_incomingIndex];
}

#pragma mark - Create Submenu's Control Buttons
-(void)createMenuButtons
{
	CGFloat staticWidth     = 105;		// Static Width for all Buttons.
	CGFloat staticHeight    = 42;		// Static Height for all buttons.
	CGFloat staticPadding   = 10;		// Padding to add between each button.
	
//	_sectionsIndex		= @[@0,@3,@7,@13,@16];
    _sectionsIndex		= @[@1,@2,@3,@4,@5,@6];
	NSArray *sectionTitles	= @[@"BIKE",@"PUBLIC TRANSPORT",@"PLANE",@"FOOT",@"BOAT", @"CAR"];
	
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
//	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addPanel:) object: nil];
//	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addPanelRight) object: nil];
//	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addTitleLabels) object: nil];
}


- (void)pageViewController:(UIPageViewController *)pvc didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
	if (completed) {
		[self setPageIndex];
        if (_pageIndex == 0) {
            _pageIndex = 1;
        }
        if (_pageIndex == 7) {
            _pageIndex = 6;
        }
        [_indicatorMenu hightLightBtns:(int)_pageIndex-1 withAnimation:YES];
        NSLog(@"the current page is %i",(int)_pageIndex);
//		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addTitleLabels) object: nil];
	}
}


#pragma mark - Datasource & Delegate for Menu with indicator
-(NSInteger) numberOfMenuItems {
    return 6;
}
-(CGFloat) indicatorYValue {
    return -10.0;
}
-(UIImage *)  imageOfButtonsAtIndex:(NSInteger) index {
    UIImage *buttonImage = [[UIImage alloc] init];
    switch (index) {
        case 0:
            buttonImage = [UIImage imageNamed:@"slotmachine_surroundings_getting_nav2_car_icon_off.png"];
            break;
        case 1:
            buttonImage = [UIImage imageNamed:@"slotmachine_surroundings_getting_nav2_ferry_icon_off.png"];
            break;
        case 2:
            buttonImage = [UIImage imageNamed:@"slotmachine_surroundings_getting_nav2_T_icon_off.png"];
            break;
        case 3:
            buttonImage = [UIImage imageNamed:@"slotmachine_surroundings_getting_nav2_plane_icon_off.png"];
            break;
        case 4:
            buttonImage = [UIImage imageNamed:@"slotmachine_surroundings_getting_nav2_bike_icon_off.png"];
            break;
        case 5:
            buttonImage = [UIImage imageNamed:@"slotmachine_surroundings_getting_nav2_foot_off.png"];
            break;
        default:
            break;
    }
    return buttonImage;
}

-(UIImage *)  imageOfSelectedButtonAtIndex:(NSInteger) index {
    UIImage *selectedImage = [[UIImage alloc] init];
    switch (index) {
        case 0:
            selectedImage = [UIImage imageNamed:@"slotmachine_surroundings_getting_nav2_car_icon_on.png"];
            break;
        case 1:
            selectedImage = [UIImage imageNamed:@"slotmachine_surroundings_getting_nav2_ferry_icon_on.png"];
            break;
        case 2:
            selectedImage = [UIImage imageNamed:@"slotmachine_surroundings_getting_nav2_T_icon_on.png"];
            break;
        case 3:
            selectedImage = [UIImage imageNamed:@"slotmachine_surroundings_getting_nav2_plane_icon_on.png"];
            break;
        case 4:
            selectedImage = [UIImage imageNamed:@"slotmachine_surroundings_getting_nav2_bike_icon_on.png"];
            break;
        case 5:
            selectedImage = [UIImage imageNamed:@"slotmachine_surroundings_getting_nav2_foot_icon_on.png"];
            break;
            
        default:
            break;
    }
    return selectedImage;
}

-(UIView *)indicatorForMenu {
    UIView *uiv_indicator = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 10.0, 10.0)];
    CGPoint saveCenter = uiv_indicator.center;
    CGRect newFrame = CGRectMake(uiv_indicator.frame.origin.x, uiv_indicator.frame.origin.y, uiv_indicator.frame.size.width, uiv_indicator.frame.size.height);
    uiv_indicator.frame = newFrame;
    uiv_indicator.layer.cornerRadius = uiv_indicator.frame.size.height / 2.0;
    uiv_indicator.center = saveCenter;
    return uiv_indicator;
}

-(UIColor *) colorsForIndicator:(NSInteger)index {
    UIColor *indicatorColor;
    switch (index) {
        case 0:
            indicatorColor = [UIColor skCarPath];
            break;
        case 1:
            indicatorColor = [UIColor skLightBlue];
            break;
        case 2:
            indicatorColor = [UIColor skRailPath];
            break;
        case 3:
            indicatorColor = [UIColor skDarkGray];
            break;
        case 4:
            indicatorColor = [UIColor skDarkGreen];
            break;
        case 5:
            indicatorColor = [UIColor skFootPath];
            break;
            
        default:
            break;
    }
    return indicatorColor;
}

-(void) didSelectItemAtIndex:(NSInteger) selectedIndex inMenu:(menuWithIndicator *)indicatorMenu {
    NSLog(@"\n\n No.%i  Tap first time", (int)selectedIndex);
    [self loadThePage:(int)selectedIndex+1];
}
-(void) didSelectItemAgainInMenu:(menuWithIndicator *)indicatorMenu {
    NSLog(@"\n\nTap again!");
}

#pragma mark - Set Page Mehod used in Delegate
-(void)loadThePage:(int)index {
    self.pageViewController.dataSource = self.modelController;
	
	_pageIndex = index;
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
#pragma mark - Update title Image
-(void)updateTitleImage:(int)index {
    [UIView animateWithDuration:0.33 animations:^{
        _uiiv_titleImage.alpha = 0.0;
    } completion:^(BOOL finished){
        [_uiiv_titleImage setImage:[UIImage imageNamed:[_arr_titleImage objectAtIndex:index]]];
        [UIView animateWithDuration:0.33 animations:^{
            _uiiv_titleImage.alpha = 1.0;
        }];
    }];
}

#pragma mark - Set Page Index
-(void)setPageIndex
{
    embPVCBaseViewController *theCurrentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
    _pageIndex = [self.modelController indexOfViewController:theCurrentViewController];
    
//    NSLog(@"\n\nThe current page is %i", _pageIndex);
    if (_pageIndex == TotalPages) {
        _pageIndex = 0;
        
        _uib_hiliteBtn = buttons[0];
        [self updateTitleImage:0];
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
        [self updateTitleImage:5];
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
    [self updateTitleImage:(int)_pageIndex-1];
	BOOL shouldAddPanel;
	int convertedIndex = 1;
    
	if (_pageIndex >= [_sectionsIndex[0]integerValue] && _pageIndex < [_sectionsIndex[1]integerValue]) {
		convertedIndex = 0;
		
	} else if (_pageIndex >= [_sectionsIndex[1]integerValue] && _pageIndex < [_sectionsIndex[2]integerValue]) {
		convertedIndex = 1;
		
	} else if (_pageIndex >= [_sectionsIndex[2]integerValue] && _pageIndex < [_sectionsIndex[3]integerValue]) {
		convertedIndex = 2;
		
	} else if (_pageIndex >= [_sectionsIndex[3]integerValue] && _pageIndex < [_sectionsIndex[4]integerValue]) {
		convertedIndex = 3;
	}
    else if (_pageIndex >= [_sectionsIndex[4]integerValue] && _pageIndex < [_sectionsIndex[5]integerValue]) {
		convertedIndex = 4;
	}
    else if (_pageIndex >= [_sectionsIndex[5]integerValue]) { //&& _pageIndex < [_sectionsIndex[5]integerValue]) {
		convertedIndex = 5;
	}
    
    shouldAddPanel=NO;
    [_panelImg removeFromSuperview];
	_uib_hiliteBtn = buttons[convertedIndex];
	[self clearAllButtons];
	[self hilightButton:_uib_hiliteBtn];
}

-(void)loadPageFromParent:(int)index
{
	UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
	btn.tag = index;
    _incomingIndex = index;
	[self loadPage:btn];
    [_indicatorMenu hightLightBtns:index-1 withAnimation:NO];
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

#pragma mark - Boilerplate
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
