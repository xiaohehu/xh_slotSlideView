//
//  ViewController.m
//  xh_slotSlideView
//
//  Created by Xiaohe Hu on 4/24/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import "ViewController.h"
#import "xh_slotScrollView.h"
@interface ViewController ()

@property (nonatomic, strong) xh_slotScrollView         *uis_slotScrollView;
@property (nonatomic, strong) xh_slotScrollView         *uis_slotScrollView1;
@property (nonatomic, strong) xh_slotScrollView         *uis_slotScrollView2;
@property (nonatomic, strong) UIView                    *uiv_backView;
@property (nonatomic, strong) UIButton                  *uib_back;
@property (nonatomic, strong) UITapGestureRecognizer    *tapToExpansion;
@property (nonatomic, strong) UITapGestureRecognizer    *tapToExpansion1;
@property (nonatomic, strong) UITapGestureRecognizer    *tapToExpansion2;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initScorllViews];
}

-(void)initScorllViews
{
    NSArray *imageArray = [[NSArray alloc] initWithObjects:@"fpo_tmp.jpg", @"movie_tmp.jpg", @"pdf_tmp.jpg", nil];
    _uis_slotScrollView = [[xh_slotScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 341, 768)];
    _uis_slotScrollView.arr_imgArray = imageArray;
    _uis_slotScrollView.startPage = 0;
    _uis_slotScrollView.tag = 100;
    
    _uis_slotScrollView1 = [[xh_slotScrollView alloc] initWithFrame:CGRectMake(341, 0.0, 341, 768)];
    _uis_slotScrollView1.arr_imgArray = imageArray;
    _uis_slotScrollView1.startPage = 1;
    _uis_slotScrollView1.tag = 101;
    
    _uis_slotScrollView2 = [[xh_slotScrollView alloc] initWithFrame:CGRectMake(682, 0.0, 342, 768)];
    _uis_slotScrollView2.arr_imgArray = imageArray;
    _uis_slotScrollView2.startPage = 2;
    _uis_slotScrollView2.tag = 102;
    
    [self.view addSubview:_uis_slotScrollView];
    [self.view addSubview:_uis_slotScrollView1];
    [self.view addSubview:_uis_slotScrollView2];
    
    _tapToExpansion = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnSlotScrollView:)];
    _tapToExpansion.delegate = self;
    _uis_slotScrollView.userInteractionEnabled = YES;
    [_uis_slotScrollView setShowsVerticalScrollIndicator:NO];
    
    _tapToExpansion1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnSlotScrollView:)];
    _tapToExpansion1.delegate = self;
    _uis_slotScrollView1.userInteractionEnabled = YES;
    [_uis_slotScrollView1 setShowsVerticalScrollIndicator:NO];
    
    _tapToExpansion2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnSlotScrollView:)];
    _tapToExpansion2.delegate = self;
    _uis_slotScrollView2.userInteractionEnabled = YES;
    [_uis_slotScrollView2 setShowsVerticalScrollIndicator:NO];
    
    [_uis_slotScrollView addGestureRecognizer:_tapToExpansion];
    [_uis_slotScrollView1 addGestureRecognizer:_tapToExpansion1];
    [_uis_slotScrollView2 addGestureRecognizer:_tapToExpansion2];
    
    _uib_back = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_back.frame = CGRectMake(0.0, 20.0, 60.0, 30.0);
    _uib_back.backgroundColor = [UIColor blueColor];
    [_uib_back setTitle:@"back" forState:UIControlStateNormal];
    [self.view insertSubview:_uib_back aboveSubview:_uis_slotScrollView];
    _uib_back.hidden = YES;
    [_uib_back addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Handle Tap On Slot Scroll View

-(void)tapOnSlotScrollView:(UITapGestureRecognizer *)recognizer {
    _uiv_backView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:_uiv_backView belowSubview:_uis_slotScrollView];
    _uiv_backView.backgroundColor = [UIColor blackColor];
    if (recognizer.view.tag == 100) {
        NSLog(@"The tag is 100");
        if ((_uis_slotScrollView.contentOffset.y/_uis_slotScrollView.frame.size.height) == 1) {
            _uiv_backView.backgroundColor = [UIColor redColor];
        }
        [UIView animateWithDuration:1.0 animations:^{
            _uis_slotScrollView.transform = CGAffineTransformMakeTranslation(-_uis_slotScrollView.frame.size.width, 0.0);
            _uis_slotScrollView1.transform = CGAffineTransformMakeTranslation(_uis_slotScrollView1.frame.size.width + _uis_slotScrollView2.frame.size.width, 0);
            _uis_slotScrollView2.transform = CGAffineTransformMakeTranslation(_uis_slotScrollView2.frame.size.width, 0);
        }
                         completion:^(BOOL finished){
                             _uib_back.hidden = NO;
                         }];
    }
    
    if (recognizer.view.tag == 101) {
        NSLog(@"The tag is 101");
        if ((_uis_slotScrollView1.contentOffset.y/_uis_slotScrollView1.frame.size.height) == 1) {
            _uiv_backView.backgroundColor = [UIColor redColor];
        }
        [UIView animateWithDuration:1.0 animations:^{
            _uis_slotScrollView.transform = CGAffineTransformMakeTranslation(-_uis_slotScrollView.frame.size.width, 0.0);
            _uis_slotScrollView1.transform = CGAffineTransformMakeTranslation(-_uis_slotScrollView1.frame.size.width - _uis_slotScrollView.frame.size.width, 0);
            _uis_slotScrollView2.transform = CGAffineTransformMakeTranslation(_uis_slotScrollView2.frame.size.width, 0);
        }
                         completion:^(BOOL finished){
                             _uib_back.hidden = NO;
                         }];
    }
    
    if (recognizer.view.tag == 102) {
        NSLog(@"The tag is 102");
        if ((_uis_slotScrollView2.contentOffset.y/_uis_slotScrollView2.frame.size.height) == 1) {
            _uiv_backView.backgroundColor = [UIColor redColor];
        }
        [UIView animateWithDuration:1.0 animations:^{
            _uis_slotScrollView.transform = CGAffineTransformMakeTranslation(-_uis_slotScrollView.frame.size.width, 0.0);
            _uis_slotScrollView1.transform = CGAffineTransformMakeTranslation(-_uis_slotScrollView1.frame.size.width - _uis_slotScrollView1.frame.size.width, 0);
            _uis_slotScrollView2.transform = CGAffineTransformMakeTranslation(-_uis_slotScrollView1.frame.size.width - _uis_slotScrollView1.frame.size.width - _uis_slotScrollView2.frame.size.width, 0);
        }
                         completion:^(BOOL finished){
                             _uib_back.hidden = NO;
                         }];
    }

}

#pragma mark - Back to Slot Scroll Views
-(void)backToMain
{
    [_uis_slotScrollView addGestureRecognizer:_tapToExpansion];
    _uib_back.hidden = YES;
    [UIView animateWithDuration:1.0 animations:^{
        _uis_slotScrollView.transform = CGAffineTransformIdentity;
        _uis_slotScrollView1.transform = CGAffineTransformIdentity;
        _uis_slotScrollView2.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        [_uiv_backView removeFromSuperview];
        _uiv_backView = nil;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
