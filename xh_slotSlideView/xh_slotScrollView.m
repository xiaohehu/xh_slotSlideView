//
//  xh_slotScrollView.m
//  xh_slotSlideView
//
//  Created by Xiaohe Hu on 4/24/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import "xh_slotScrollView.h"

@interface xh_slotScrollView () <UIScrollViewDelegate>

@end

@implementation xh_slotScrollView

@synthesize arr_imgArray;
@synthesize startPage;

-(void)setStartPage:(int)start {
    if (start > -1) {
        startPage = start;
        [self setOffsetOfScrollView];
    }
}
-(void)setArr_imgArray:(NSArray *)imgArray {
    if ([imgArray count] > 0) {
        arr_imgArray =  [[NSArray alloc] init];
        arr_imgArray = imgArray;
        
        [self setDataToScrollView];
    }
    else
        return;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //setup scroll view
        self.clipsToBounds = YES;
        self.delegate = self;
        self.scrollEnabled = YES;
        self.pagingEnabled = YES;
        [self setBackgroundColor:[UIColor whiteColor]];
        
    }
    return self;
}

-(void)setDataToScrollView
{
    self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height*arr_imgArray.count);
    
    for (int i = 0; i < arr_imgArray.count; i++) {
        CGRect frameOfImage;
        frameOfImage.origin.x = 0;
        frameOfImage.origin.y = self.frame.size.height * i;
        frameOfImage.size = self.frame.size;
        
        UIImageView *uiiv_imgInScrView = [[UIImageView alloc] initWithFrame:frameOfImage];
        [uiiv_imgInScrView setContentMode:UIViewContentModeTop];
        uiiv_imgInScrView.image = [UIImage imageNamed:[arr_imgArray objectAtIndex:i ]];
        uiiv_imgInScrView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview: uiiv_imgInScrView];
    }
    [self setContentOffset:CGPointMake(0, self.frame.size.height*startPage)];
}
-(void)setOffsetOfScrollView
{
    [self setContentOffset:CGPointMake(0, self.frame.size.height*startPage)];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
