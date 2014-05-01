//
//  embRootViewController.h
//  Example
//
//  Created by Evan Buxton on 11/23/13.
//  Copyright (c) 2013 neoscape. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface embPVCRootViewController : UIViewController <UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
-(void)loadPageFromParent:(int)index;
@property (nonatomic,assign) int incomingIndex;
@end
