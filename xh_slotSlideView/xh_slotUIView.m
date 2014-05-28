//
//  xh_slotUIView.m
//  xh_slotSlideView
//
//  Created by Xiaohe Hu on 5/28/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import "xh_slotUIView.h"
#define kImage_X 185.0
#define kImage_Y 192.0
#define kImage_W 185.0
#define kImage_H 192.0

@interface xh_slotUIView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView              *uis_scrollView;

@end

@implementation xh_slotUIView
@synthesize startPage;
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}
-(void)setStartPage:(int)start {
    if (start > -1) {
        startPage = start;
        [self setOffsetOfScrollView];
    }
    else {
        startPage = 0;
        [self setOffsetOfScrollView];
    }
}
-(void)setOffsetOfScrollView
{
    [_uis_scrollView setContentOffset:CGPointMake(0, _uis_scrollView.frame.size.height*startPage)];
}

- (id)initWithFrame:(CGRect)frame andViewData:(NSArray *)dataArray  {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //setup container
        [self setBackgroundColor:[UIColor whiteColor]];
        
        //setup scroll view
        _uis_scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _uis_scrollView.clipsToBounds = YES;
        _uis_scrollView.delegate = self;
        _uis_scrollView.scrollEnabled = YES;
        _uis_scrollView.pagingEnabled = YES;
        [_uis_scrollView setBackgroundColor:[UIColor clearColor]];
        [_uis_scrollView setShowsVerticalScrollIndicator:NO];
        [self addSubview: _uis_scrollView];
        if (dataArray) {
            [self initViewInScrollView:dataArray];
        }
    }
    return self;
}
-(void)initViewInScrollView:(NSArray *)dataArray
{
    _uis_scrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height*dataArray.count);
    
    for (int i = 0; i < [dataArray count]; i++) {
        
        CGRect contentFrame;
        contentFrame.origin.x = 0;
        contentFrame.origin.y = self.frame.size.height * i;
        contentFrame.size = self.frame.size;
        
        UIView *uiv_contentView = [[UIView alloc] initWithFrame:CGRectMake(contentFrame.origin.x, contentFrame.origin.y, contentFrame.size.width, contentFrame.size.height)];
        NSDictionary *contentViewData = [[NSDictionary alloc] initWithDictionary:[dataArray objectAtIndex:i]];
        uiv_contentView.tag = 100+i;
        
        //Check Background image and Init
        if ([contentViewData objectForKeyedSubscript:@"bgimage"] != nil) {
            UIImageView *uiiv_bgImage = [[UIImageView alloc] initWithFrame:uiv_contentView.bounds];
            [uiiv_bgImage setImage:[UIImage imageNamed:[contentViewData objectForKey:@"bgimage"]]];
            [uiiv_bgImage setContentMode:UIViewContentModeScaleAspectFit];
            [uiv_contentView addSubview:uiiv_bgImage];
        }
        
        //Init animation Imageview part
        NSArray *imageNames = [[NSArray alloc]initWithArray:[contentViewData objectForKey:@"images"]];
        
        CGRect  frame;
        if ([contentViewData objectForKey:@"text"] != nil)
            frame = CGRectMake(kImage_X-100, kImage_Y-20, kImage_W, kImage_H);
        else
            frame = CGRectMake(kImage_X, kImage_Y, kImage_W, kImage_H);
        
        if (imageNames.count > 1) {
            NSMutableArray *imageFiles = [[NSMutableArray alloc] init];
            for (int j = 0; j < imageNames.count; j++) {
                [imageFiles addObject:[UIImage imageNamed:[imageNames objectAtIndex:j]]];
            }
            UIImageView *uiiv_animationView = [[UIImageView alloc] initWithFrame:frame];
            [uiiv_animationView setContentMode:UIViewContentModeScaleAspectFit];
            uiiv_animationView.animationImages = imageFiles;
            uiiv_animationView.animationDuration = [[contentViewData objectForKey:@"duration"] floatValue];
            [uiv_contentView addSubview:uiiv_animationView];
            [uiiv_animationView startAnimating];
            uiiv_animationView.tag = 200+i;
        }
        //If there is only 1 image, no animation
        if (imageNames.count == 1) {
            UIImageView *uiiv_animationView = [[UIImageView alloc] initWithFrame:frame];
            [uiiv_animationView setImage:[UIImage imageNamed:imageNames[0]]];
            [uiiv_animationView setContentMode:UIViewContentModeScaleAspectFit];
            [uiv_contentView addSubview:uiiv_animationView];
            uiiv_animationView.tag = 99;
        }
        
        //Change Content View BG Color
        if ([contentViewData objectForKey:@"color" ] != nil) {
            NSString *colorData = [contentViewData objectForKey: @"color"];
            NSArray *colorsArray = [colorData componentsSeparatedByString:@","];
            float redValue = [[colorsArray objectAtIndex:0] floatValue];
            float greenValue = [[colorsArray objectAtIndex:1] floatValue];
            float blueValue = [[colorsArray objectAtIndex:2] floatValue];
            [uiv_contentView setBackgroundColor:[UIColor colorWithRed:redValue/255.0 green:greenValue/255.0 blue:blueValue/255.0 alpha:1.0]];
        }
        
        
        //Init Label Text Part
        if ([contentViewData objectForKey:@"label"] != nil) {
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 255.0, self.frame.size.width, 300)];
            textView.userInteractionEnabled = NO;
            NSString *str_text = [contentViewData objectForKey:@"label"];
            textView.text = [str_text stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
            textView.backgroundColor = [UIColor clearColor];
            if ([str_text length] > 16) {
                //            textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y + 50, textView.frame.size.width, textView.frame.size.height);
                [textView setFont: [UIFont systemFontOfSize:50]];
            }
            else {
                [textView setFont: [UIFont systemFontOfSize:70]];
            }
            
            
            //        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            //        paragraphStyle.lineHeightMultiple = 50.0f;
            //        paragraphStyle.maximumLineHeight = 50.0f;
            //        paragraphStyle.minimumLineHeight = 50.0f;
            //
            //        NSDictionary *ats = @{
            //                              NSFontAttributeName : [UIFont systemFontOfSize:100],
            //                              NSParagraphStyleAttributeName : paragraphStyle,
            //                              };
            //        textView.attributedText = [[NSAttributedString alloc] initWithString:str_text attributes:ats];
            [uiv_contentView addSubview:textView];
        }
        
        //Init info Text Part
        if ([contentViewData objectForKey:@"text"] != nil) {
            //ADD TEXT
            
            //CHANGE IMAGE SIZE & POSITION
            
        }
        [_uis_scrollView addSubview: uiv_contentView];
    }
}

#pragma mark - Scrollview Delegate
// After scrolling, Get current page and resume animation
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int pageIndex = _uis_scrollView.contentOffset.y/_uis_scrollView.frame.size.height;
    for (UIView *tmp in [self subviews]) {
        if (tmp.tag == 100+pageIndex) {
            for (UIImageView *tmpImageView in [tmp subviews]) {
                if (tmpImageView.tag >= 200) {
                    [self resumeLayer:tmpImageView.layer];
                }
            }
        }
    }
}
// While scrolling, STOP all UIImageView Animation
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    for (UIView *tmp in [self subviews]) {
        if (tmp.tag >= 100) {
            for (UIImageView *tmpImageView in [tmp subviews]) {
                if (tmpImageView.tag >= 200) {
                    [self pauseLayer:tmpImageView.layer];
                }
            }
        }
    }
}
#pragma mark - Pause & Resume Image Animation

-(void)pauseAnimation:(BOOL)pause {
    if (pause) {
        for (UIView *tmp in [self subviews]) {
            if (tmp.tag >= 100) {
                for (UIImageView *tmpImageView in [tmp subviews]) {
                    if (tmpImageView.tag >= 200) {
                        [self pauseLayer:tmpImageView.layer];
                    }
                }
            }
        }
    }
    else {
        for (UIView *tmp in [self subviews]) {
            if (tmp.tag >= 100) {
                for (UIImageView *tmpImageView in [tmp subviews]) {
                    if (tmpImageView.tag >= 200) {
                        [self resumeLayer:tmpImageView.layer];
                    }
                }
            }
        }
    }
}

-(void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

-(void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
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
