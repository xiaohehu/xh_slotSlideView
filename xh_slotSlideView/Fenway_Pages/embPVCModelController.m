//
//  embModelController.m
//  Example
//
//  Created by Evan Buxton on 11/23/13.
//  Copyright (c) 2013 neoscape. All rights reserved.
//

#import "embPVCModelController.h"

#import "embPVCBaseViewController.h"

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */

@interface embPVCModelController()
@property (readonly, strong, nonatomic) NSArray *pageData;
@end

@implementation embPVCModelController
 
- (id)init
{
    self = [super init];
    if (self) {
		// Create the data model.
		_pageData = [[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"images" ofType:@"plist"]] copy];
		NSLog(@"pagedata %i",(int)[self.pageData count]);
    }
    return self;
}

- (embPVCBaseViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{   
    // Return the data view controller for the given index.
    if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
        return nil;
    }
    
	// Create a new view controller and pass suitable data.
	embPVCBaseViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"embPVCBaseViewController"];
	dataViewController.dataObject = self.pageData[index];
	dataViewController.vcIndex = index;
	return dataViewController;
}

- (NSUInteger)indexOfViewController:(embPVCBaseViewController *)viewController
{   
     // Return the index of the given data view controller.
     // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return [self.pageData indexOfObject:viewController.dataObject];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(embPVCBaseViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(embPVCBaseViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageData count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

@end
