//
//  xh_slotUIView.m
//  xh_slotSlideView
//
//  Created by Xiaohe Hu on 5/28/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import "xh_slotUIView.h"
#define kImage_X 175.0
#define kImage_Y 267.0
#define kImage_W 185.0
#define kImage_H 192.0

@interface xh_slotUIView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView              *uis_scrollView;
@property (nonatomic, readwrite) float                  imageWidth;
@property (nonatomic, readwrite) float                  imageHeight;
@property (nonatomic, strong) UIButton                  *uib_upArrow;
@property (nonatomic, strong) UIButton                  *uib_downArrow;
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
    [self initArrowBtns];
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
        _uis_scrollView.userInteractionEnabled = YES;
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
        
        if (imageNames.count > 1) {
            NSMutableArray *imageFiles = [[NSMutableArray alloc] init];
            for (int j = 0; j < imageNames.count; j++) {
                [imageFiles addObject:[UIImage imageNamed:[imageNames objectAtIndex:j]]];
            }
            UIImageView *uiiv_animationView = [[UIImageView alloc] initWithFrame:CGRectMake(kImage_X, kImage_Y, kImage_W, kImage_H)];
            [uiiv_animationView setContentMode:UIViewContentModeScaleAspectFit];
            uiiv_animationView.animationImages = imageFiles;
            uiiv_animationView.animationDuration = [[contentViewData objectForKey:@"duration"] floatValue];
            [uiv_contentView addSubview:uiiv_animationView];
            [uiiv_animationView startAnimating];
            uiiv_animationView.tag = 200+i;
        }
        //If there is only 1 image, no animation
        if (imageNames.count == 1) {
            UIImageView *uiiv_animationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageNames[0]]];
            CGRect  frame;
            if ([contentViewData objectForKey:@"text"] != nil)
                    frame = CGRectMake((self.frame.size.width - uiiv_animationView.frame.size.width*0.8)/2, kImage_Y-50, uiiv_animationView.frame.size.width*0.8, uiiv_animationView.frame.size.height*0.8);
            else
                frame = CGRectMake(kImage_X, kImage_Y, uiiv_animationView.frame.size.width, uiiv_animationView.frame.size.height);
            
            _imageHeight = frame.size.height;
            _imageWidth = frame.size.width;
            
            uiiv_animationView.frame = frame;
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
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(5.0, kImage_Y+40, self.frame.size.width, 300)];
            textView.userInteractionEnabled = NO;
            NSString *str_text = [contentViewData objectForKey:@"label"];
            textView.text = [str_text stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
            textView.backgroundColor = [UIColor clearColor];
            [textView setTextColor:[UIColor colorWithRed:100.0/255.0 green:101.0/255.0 blue:105.0/255.0 alpha:1.0]];
            if ([str_text length] > 16) {
                //            textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y + 50, textView.frame.size.width, textView.frame.size.height);
                [textView setFont: [UIFont systemFontOfSize:40]];
            }
            else {
                CGRect textFrame = textView.frame;
                textFrame.origin.x += 15;
                textFrame.origin.y += 15;
                textView.frame = textFrame;
                [textView setFont: [UIFont systemFontOfSize:45]];
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
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(5.0, kImage_Y-50+_imageHeight+20 , self.frame.size.width, 300)];
            textView.userInteractionEnabled = NO;
            NSString *str_text = [contentViewData objectForKey:@"text"];
            textView.text = [str_text stringByReplacingOccurrencesOfString:@"+" withString:@"\n"];
            textView.backgroundColor = [UIColor clearColor];
            [textView setTextColor:[UIColor colorWithRed:100.0/255.0 green:101.0/255.0 blue:105.0/255.0 alpha:1.0]];
            [textView setFont: [UIFont systemFontOfSize:30]];
            [textView setTextAlignment:NSTextAlignmentCenter];
            
            [uiv_contentView addSubview:textView];
            
        }
        [_uis_scrollView addSubview: uiv_contentView];
    }
}

-(void)initArrowBtns {
    _uib_upArrow = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_upArrow.frame = CGRectMake(0.0, 40.0, self.frame.size.width, 60);
    [_uib_upArrow setImage:[UIImage imageNamed:@"slotmachine_skanska_360_button_up.png"] forState:UIControlStateNormal];
    _uib_upArrow.tag = 10;
    [_uib_upArrow addTarget:self action:@selector(arrowButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    _uib_downArrow = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_downArrow.frame = CGRectMake(0.0, self.frame.size.height-100, self.frame.size.width, 60);
    [_uib_downArrow setImage:[UIImage imageNamed:@"slotmachine_skanska_360_button_down.png"] forState:UIControlStateNormal];
    _uib_downArrow.tag = 20;
    [_uib_downArrow addTarget:self action:@selector(arrowButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_uib_upArrow];
    [self addSubview:_uib_downArrow];
    
    CGPoint position = _uis_scrollView.contentOffset;
    switch ((int)position.y) {
        case 0: {
            _uib_upArrow.hidden = YES;
            _uib_downArrow.hidden = NO;
            break;
        }
        case 768: {
            _uib_upArrow.hidden = NO;
            _uib_downArrow.hidden = NO;
            break;
        }
        case 1536: {
            _uib_upArrow.hidden = NO;
            _uib_downArrow.hidden = YES;
            break;
        }
        default:
            break;
    }
}

-(void)arrowButtonTapped:(id)sender {
    UIButton *tmpBtn = sender;
    CGPoint point = _uis_scrollView.contentOffset;
    if (tmpBtn.tag == 10) {
        point.y -= 768;
        [UIView animateWithDuration:0.33 animations:^{
            _uis_scrollView.contentOffset = point;
    }
            completion:^(BOOL finished){
                switch ((int)_uis_scrollView.contentOffset.y) {
                    case 0: {
                        _uib_upArrow.hidden = YES;
                        _uib_downArrow.hidden = NO;
                        break;
                    }
                    case 768: {
                        _uib_upArrow.hidden = NO;
                        _uib_downArrow.hidden = NO;
                        break;
                    }
                    case 1536: {
                        _uib_upArrow.hidden = NO;
                        _uib_downArrow.hidden = YES;
                        break;
                    }
                    default:
                        break;
                }
            }];
    }
    if (tmpBtn.tag == 20) {
        point.y += 768;
        [UIView animateWithDuration:0.33 animations:^{
            _uis_scrollView.contentOffset = point;
        }
            completion:^(BOOL finished){
            switch ((int)_uis_scrollView.contentOffset.y) {
                case 0: {
                    _uib_upArrow.hidden = YES;
                    _uib_downArrow.hidden = NO;
                    break;
                }
                case 768: {
                    _uib_upArrow.hidden = NO;
                    _uib_downArrow.hidden = NO;
                    break;
                }
                case 1536: {
                    _uib_upArrow.hidden = NO;
                    _uib_downArrow.hidden = YES;
                    break;
                }
                default:
                    break;
            }
        }];
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
    
    switch (pageIndex) {
        case 0: {
            _uib_upArrow.hidden = YES;
            _uib_downArrow.hidden = NO;
            break;
        }
        case 1: {
            _uib_upArrow.hidden = NO;
            _uib_downArrow.hidden = NO;
            break;
        }
        case 2: {
            _uib_upArrow.hidden = NO;
            _uib_downArrow.hidden = YES;
            break;
        }
        default:
            break;
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
