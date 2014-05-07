//
//  embDataViewController.m
//  Example
//
//  Created by Evan Buxton on 11/23/13.
//  Copyright (c) 2013 neoscape. All rights reserved.
//

#import "embPVCBaseViewController.h"
#import "embBlockViewController.h"
#import "embOverlayScrollView.h"

@interface embPVCBaseViewController ()
@property (nonatomic, strong) embOverlayScrollView *zoomScroll;
@end

@implementation embPVCBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.view.clipsToBounds=YES;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
//	if (_vcIndex != 3) { // this is the tappable axonometric
		
		NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.dataObject[0]];
		
		if ([self.dataObject count]>1) {
			_zoomScroll = [[embOverlayScrollView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) image:[UIImage imageWithContentsOfFile:path] overlay:self.dataObject[1] shouldZoom:YES];
		} else {
			_zoomScroll = [[embOverlayScrollView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) image:[UIImage imageWithContentsOfFile:path] overlay:nil shouldZoom:YES];
		}
		
		[self.view addSubview:_zoomScroll];
		
//	} else {
//		
//		UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Fenway" bundle:nil];
//		UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"embBlockViewController"];
//		vc.view.frame = self.view.bounds;
//		[self addChildViewController:vc];
//		[self.view addSubview:vc.view];
//	}
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	[_zoomScroll resetScroll];
	
}



@end
