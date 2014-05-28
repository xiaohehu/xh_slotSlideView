//
//  ViewController.m
//  xh_slotSlideView
//
//  Created by Xiaohe Hu on 4/24/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import "ViewController.h"
#import "xh_slotScrollView.h"
#import "embPVCRootViewController.h"
#import "locationViewController.h"
#import "skaskaViewController.h"
@interface ViewController ()
@property (nonatomic, strong) UIButton          *uib_location;
@property (nonatomic, strong) UIButton          *uib_skaska360;
@property (nonatomic, strong) UIButton          *uib_mainScreen;

@property (nonatomic, strong) locationViewController    *locationVC;
@property (nonatomic, strong) skaskaViewController      *skanskaVC;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    [self initButtons];
}

-(void)initButtons {
    _uib_location = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_location.frame = CGRectMake(200.0, 200.0, 200.0, 50.0);
    _uib_location.backgroundColor = [UIColor whiteColor];
    [_uib_location setTitle:@"Load Location Slot" forState:UIControlStateNormal];
    [_uib_location setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_uib_location addTarget:self action:@selector(loadLocationSlot) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: _uib_location];
    
    _uib_skaska360 = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_skaska360.frame = CGRectMake(200.0, 280.0, 200.0, 50.0);
    _uib_skaska360.backgroundColor = [UIColor whiteColor];
    [_uib_skaska360 setTitle:@"Load Skanska 360˚" forState:UIControlStateNormal];
    [_uib_skaska360 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_uib_skaska360 addTarget:self action:@selector(loadSkanskaSlot) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: _uib_skaska360];
    
    _uib_mainScreen = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_mainScreen.frame = CGRectMake(40.0, 700, 150, 40);
    _uib_mainScreen.backgroundColor = [UIColor blackColor];
    [_uib_mainScreen setTitle:@"<-MAIN MENU" forState:UIControlStateNormal];
    [_uib_mainScreen addTarget:self action:@selector(backToMainMenu) forControlEvents:UIControlEventTouchUpInside];
    _uib_mainScreen.hidden = YES;
    [self.view addSubview:_uib_mainScreen];
}

-(void)loadLocationSlot {
    _locationVC = [[locationViewController alloc] init];
    [self addChildViewController:_locationVC];
    [self.view insertSubview:_locationVC.view belowSubview:_uib_mainScreen];
    _uib_mainScreen.hidden = NO;
}
-(void)loadSkanskaSlot {
    _skanskaVC = [[skaskaViewController alloc] init];
    [self addChildViewController:_skanskaVC];
    [self.view insertSubview:_skanskaVC.view belowSubview:_uib_mainScreen];
    _uib_mainScreen.hidden = NO;
}
-(void)backToMainMenu {
    if (_locationVC.view) {
        [_locationVC removeFromParentViewController];
        [_locationVC.view removeFromSuperview];
        _locationVC = nil;
    }
    if (_skanskaVC.view) {
        [_skanskaVC removeFromParentViewController];
        [_skanskaVC.view removeFromSuperview];
        _skanskaVC = nil;
    }
    _uib_mainScreen.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
