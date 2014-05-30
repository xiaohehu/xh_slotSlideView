//
//  locationViewController.m
//  xh_slotSlideView
//
//  Created by Xiaohe Hu on 5/28/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import "locationViewController.h"
#import "xh_slotScrollView.h"
#import "xh_slotUIView.h"
#import "embPVCRootViewController.h"
@interface locationViewController ()
@property (nonatomic, strong) xh_slotScrollView         *uis_slotScrollView;
@property (nonatomic, strong) xh_slotScrollView         *uis_slotScrollView1;
@property (nonatomic, strong) xh_slotScrollView         *uis_slotScrollView2;
@property (nonatomic, strong) UIView                    *uiv_backView;
@property (nonatomic, strong) UIButton                  *uib_back;
@property (nonatomic, strong) embPVCRootViewController     *pageVC;
@end

@implementation locationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.frame = CGRectMake(0.0, 0.0, 1024, 768);
    _pageVC = [[embPVCRootViewController alloc] init];
    _pageVC.view.frame = CGRectMake(0.0, 0.0, 1024, 768);
    _pageVC.view.alpha = 0.0;
    
	// Do any additional setup after loading the view, typically from a nib.
    UIImageView *uiiv_bg = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1024, 768)];
    [uiiv_bg setImage: [UIImage imageNamed:@"grfx_location_slot_bg.jpg"]];
    [self.view addSubview:uiiv_bg];
    
    [self initScorllViews];
}
-(void)initScorllViews
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"slotScroll" ofType:@"plist"];
    NSArray *totalData = [[NSArray alloc] initWithContentsOfFile:path];
    
    for (int i = 0; i < totalData.count; i++) {
        NSArray *slotViewData = [[NSArray alloc] initWithArray:[totalData objectAtIndex:i]];
        
        switch (i) {
            case 0:
            {
                _uis_slotScrollView = [[xh_slotScrollView alloc] initWithFrame:CGRectMake(0.0 + (342 * i), 0.0, 342, 768) andViewData:slotViewData];
                _uis_slotScrollView.tag = 100 + i;
                
                UITapGestureRecognizer *tapToExpansion = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnSlotScrollView:)];
                tapToExpansion.delegate = self;
                _uis_slotScrollView.userInteractionEnabled = YES;
                [_uis_slotScrollView setShowsVerticalScrollIndicator:NO];
                [_uis_slotScrollView setStartPage:1];
                [_uis_slotScrollView addGestureRecognizer: tapToExpansion];
                [self.view addSubview: _uis_slotScrollView];
                break;
            }
            case 1:
            {
                _uis_slotScrollView1 = [[xh_slotScrollView alloc] initWithFrame:CGRectMake(0.0 + (342 * i), 0.0, 342, 768) andViewData:slotViewData];
                _uis_slotScrollView1.tag = 100 + i;
                
                UITapGestureRecognizer *tapToExpansion = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnSlotScrollView:)];
                tapToExpansion.delegate = self;
                _uis_slotScrollView1.userInteractionEnabled = YES;
                [_uis_slotScrollView1 setShowsVerticalScrollIndicator:NO];
                [_uis_slotScrollView1 setStartPage:1];
                [_uis_slotScrollView1 addGestureRecognizer: tapToExpansion];
                [self.view addSubview: _uis_slotScrollView1];
                break;
            }
            case 2:
            {
                _uis_slotScrollView2 = [[xh_slotScrollView alloc] initWithFrame:CGRectMake(0.0 + (342 * i), 0.0, 342, 768) andViewData:slotViewData];
                _uis_slotScrollView2.tag = 100 + i;
                
                UITapGestureRecognizer *tapToExpansion = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnSlotScrollView:)];
                tapToExpansion.delegate = self;
                _uis_slotScrollView2.userInteractionEnabled = YES;
                [_uis_slotScrollView2 setShowsVerticalScrollIndicator:NO];
                [_uis_slotScrollView2 setStartPage:1];
                [_uis_slotScrollView2 addGestureRecognizer: tapToExpansion];
                [self.view addSubview: _uis_slotScrollView2];
                break;
            }
            default:
                break;
        }
    }
    _uib_back = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_back.frame = CGRectMake(290.0, 710.0, 60.0, 30.0);
    _uib_back.backgroundColor = [UIColor blueColor];
    [_uib_back setTitle:@"back" forState:UIControlStateNormal];
    [self.view addSubview: _uib_back];
    _uib_back.hidden = YES;
    [_uib_back addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Handle Tap On Slot Scroll View

-(void)tapOnSlotScrollView:(UITapGestureRecognizer *)recognizer {
    _uiv_backView = [[UIView alloc] initWithFrame:self.view.bounds];
    //    [self.view insertSubview:_uiv_backView belowSubview:_uis_slotScrollView];
    _uiv_backView.backgroundColor = [UIColor blackColor];
    [self.view insertSubview:_pageVC.view belowSubview:_uib_back];
    
    
    if (recognizer.view.tag == 100) {
        
        NSLog(@"The tag is 100");
        if ((_uis_slotScrollView.contentOffset.y/_uis_slotScrollView.frame.size.height) == 1) {
            _uiv_backView.backgroundColor = [UIColor redColor];
            [_pageVC loadPageFromParent:4];
        }
        else {
            [_pageVC loadPageFromParent:5];
        }
        [UIView animateWithDuration:1.0 animations:^{
            _uis_slotScrollView.transform = CGAffineTransformMakeTranslation(-_uis_slotScrollView.frame.size.width, 0.0);
            _uis_slotScrollView1.transform = CGAffineTransformMakeTranslation(_uis_slotScrollView1.frame.size.width + _uis_slotScrollView2.frame.size.width, 0);
            _uis_slotScrollView2.transform = CGAffineTransformMakeTranslation(_uis_slotScrollView2.frame.size.width, 0);
        }
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:0.33 animations:^{
                                 _pageVC.view.alpha = 1.0;
                             }];
                             _uib_back.hidden = NO;
                             [_uis_slotScrollView pauseAnimation:YES];
                             [_uis_slotScrollView1 pauseAnimation:YES];
                             [_uis_slotScrollView2 pauseAnimation:YES];
                         }];
    }
    
    if (recognizer.view.tag == 101) {
        
        NSLog(@"The tag is 101");
        if ((_uis_slotScrollView1.contentOffset.y/_uis_slotScrollView1.frame.size.height) == 1) {
            _uiv_backView.backgroundColor = [UIColor redColor];
            [_pageVC loadPageFromParent:3];
            [_pageVC updateTitleImage:2];
        }
        else {
            [_pageVC loadPageFromParent:2];
        }
        [UIView animateWithDuration:1.0 animations:^{
            _uis_slotScrollView.transform = CGAffineTransformMakeTranslation(-_uis_slotScrollView.frame.size.width, 0.0);
            _uis_slotScrollView1.transform = CGAffineTransformMakeTranslation(-_uis_slotScrollView1.frame.size.width - _uis_slotScrollView.frame.size.width, 0);
            _uis_slotScrollView2.transform = CGAffineTransformMakeTranslation(_uis_slotScrollView2.frame.size.width, 0);
        }
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:0.33 animations:^{
                                 _pageVC.view.alpha = 1.0;
                             }];
                             _uib_back.hidden = NO;
                             [_uis_slotScrollView pauseAnimation:YES];
                             [_uis_slotScrollView1 pauseAnimation:YES];
                             [_uis_slotScrollView2 pauseAnimation:YES];
                         }];
    }
    
    if (recognizer.view.tag == 102) {
        
        NSLog(@"The tag is 102");
        if ((_uis_slotScrollView2.contentOffset.y/_uis_slotScrollView2.frame.size.height) == 1) {
            _uiv_backView.backgroundColor = [UIColor redColor];
            [_pageVC loadPageFromParent:1];
        }
        else {
            [_pageVC loadPageFromParent:6];
        }
        [UIView animateWithDuration:1.0 animations:^{
            _uis_slotScrollView.transform = CGAffineTransformMakeTranslation(-_uis_slotScrollView.frame.size.width, 0.0);
            _uis_slotScrollView1.transform = CGAffineTransformMakeTranslation(-_uis_slotScrollView1.frame.size.width - _uis_slotScrollView1.frame.size.width, 0);
            _uis_slotScrollView2.transform = CGAffineTransformMakeTranslation(-_uis_slotScrollView1.frame.size.width - _uis_slotScrollView1.frame.size.width - _uis_slotScrollView2.frame.size.width, 0);
        }
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:0.33 animations:^{
                                 _pageVC.view.alpha = 1.0;
                             }];
                             _uib_back.hidden = NO;
                             [_uis_slotScrollView pauseAnimation:YES];
                             [_uis_slotScrollView1 pauseAnimation:YES];
                             [_uis_slotScrollView2 pauseAnimation:YES];
                         }];
    }
    
}

#pragma mark - Back to Slot Scroll Views
-(void)backToMain
{
    _uib_back.hidden = YES;
    
    //    for (xh_slotScrollView *tmp_slot in [self.view subviews]) {
    //        [tmp_slot pauseAnimation:YES];
    //    }
    
    [UIView animateWithDuration:0.33 animations:^{
        _pageVC.view.alpha = 0.0;
    } completion:^(BOOL finished){
        //        [_uiv_backView removeFromSuperview];
        //        _uiv_backView = nil;
        
        [UIView animateWithDuration:1.0 animations:^{
            _uis_slotScrollView.transform = CGAffineTransformIdentity;
            _uis_slotScrollView1.transform = CGAffineTransformIdentity;
            _uis_slotScrollView2.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){
            [_uis_slotScrollView pauseAnimation:NO];
            [_uis_slotScrollView1 pauseAnimation:NO];
            [_uis_slotScrollView2 pauseAnimation:NO];
        }];
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
