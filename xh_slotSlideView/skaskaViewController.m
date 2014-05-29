//
//  skaskaViewController.m
//  xh_slotSlideView
//
//  Created by Xiaohe Hu on 5/28/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import "skaskaViewController.h"
#import "xh_slotScrollView.h"
#import "xh_slotUIView.h"
#import "embPVCRootViewController.h"
@interface skaskaViewController ()
@property (nonatomic, strong) xh_slotUIView         *uis_slotView1;
@property (nonatomic, strong) xh_slotUIView         *uis_slotView2;
@property (nonatomic, strong) xh_slotUIView         *uis_slotView3;
@end

@implementation skaskaViewController

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
    self.view.frame = CGRectMake(0.0, 0.0, 1024.0, 768.0);
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initScorllView];
}

-(void)initScorllView {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"slotUIView" ofType:@"plist"];
    NSArray *totalData = [[NSArray alloc] initWithContentsOfFile:path];
    
    for (int i = 0; i < totalData.count; i++) {
        NSArray *slotViewData = [[NSArray alloc] initWithArray:[totalData objectAtIndex:i]];
        
        switch (i) {
            case 0:
            {
                _uis_slotView1 = [[xh_slotUIView alloc] initWithFrame:CGRectMake(0.0 + (342 * i), 0.0, 342, 768) andViewData:slotViewData];
                _uis_slotView1.tag = 100 + i;
                _uis_slotView1.userInteractionEnabled = YES;
                [_uis_slotView1 setStartPage:1];
                [self.view addSubview: _uis_slotView1];
                break;
            }
            case 1:
            {
                _uis_slotView2 = [[xh_slotUIView alloc] initWithFrame:CGRectMake(0.0 + (342 * i), 0.0, 342, 768) andViewData:slotViewData];
                _uis_slotView2.tag = 100 + i;
                _uis_slotView2.userInteractionEnabled = YES;
                [_uis_slotView2 setStartPage:1];
                [self.view addSubview: _uis_slotView2];
                break;
            }
            case 2:
            {
                _uis_slotView3 = [[xh_slotUIView alloc] initWithFrame:CGRectMake(0.0 + (342 * i), 0.0, 342, 768) andViewData:slotViewData];
                _uis_slotView3.tag = 100 + i;
                _uis_slotView3.userInteractionEnabled = YES;
                [_uis_slotView3 setStartPage:1];
                [self.view addSubview: _uis_slotView3];
                break;
            }
            default:
                break;
        }
    }
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
