//
//  embModelController.h
//  Example
//
//  Created by Evan Buxton on 11/23/13.
//  Copyright (c) 2013 neoscape. All rights reserved.
//

#import <UIKit/UIKit.h>

@class embPVCBaseViewController;

@interface embPVCModelController : NSObject <UIPageViewControllerDataSource>

- (embPVCBaseViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(embPVCBaseViewController *)viewController;

@end
