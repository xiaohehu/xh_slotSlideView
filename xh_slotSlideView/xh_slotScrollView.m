//
//  xh_slotScrollView.m
//  xh_slotSlideView
//
//  Created by Xiaohe Hu on 4/24/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import "xh_slotScrollView.h"

@interface xh_slotScrollView () <UIScrollViewDelegate>
//@property (nonatomic, strong)       UIView                  *uiv_contentView;
//@property (nonatomic, strong)       UIImageView             *uiiv_animationImages;
@end
static float alphaValue = 0.8;
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

- (id)initWithFrame:(CGRect)frame andViewData:(NSArray *)dataArray
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //setup scroll view
        self.clipsToBounds = YES;
        self.delegate = self;
        self.scrollEnabled = YES;
        self.pagingEnabled = YES;
        [self setBackgroundColor:[UIColor clearColor]];
        self.alpha = alphaValue;
        if (dataArray) {
            [self initViewInScrollView:dataArray];
        }
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

-(void)initViewInScrollView:(NSArray *)dataArray
{
    self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height*dataArray.count);
    
    for (int i = 0; i < [dataArray count]; i++) {
        
        CGRect contentFrame;
        contentFrame.origin.x = 0;
        contentFrame.origin.y = self.frame.size.height * i;
        contentFrame.size = self.frame.size;
        
        UIView *uiv_contentView = [[UIView alloc] initWithFrame:CGRectMake(contentFrame.origin.x, contentFrame.origin.y, contentFrame.size.width, contentFrame.size.height)];
        NSDictionary *contentViewData = [[NSDictionary alloc] initWithDictionary:[dataArray objectAtIndex:i]];
        
        //Init animation Imageview part
        NSArray *imageNames = [[NSArray alloc]initWithArray:[contentViewData objectForKey:@"images"]];
        NSMutableArray *imageFiles = [[NSMutableArray alloc] init];
        for (int j = 0; j < imageNames.count; j++) {
            [imageFiles addObject:[UIImage imageNamed:[imageNames objectAtIndex:j]]];
        }
        UIImageView *uiiv_animationView = [[UIImageView alloc] initWithFrame:CGRectMake(185.0, 192.0, 185.0, 192.0)];
        [uiiv_animationView setContentMode:UIViewContentModeScaleAspectFit];
        uiiv_animationView.animationImages = imageFiles;
        uiiv_animationView.animationDuration = [[contentViewData objectForKey:@"duration"] floatValue];
        [uiv_contentView addSubview:uiiv_animationView];
        [uiiv_animationView startAnimating];
        
        //Change Content View BG Color
        NSString *colorData = [contentViewData objectForKey: @"color"];
        NSArray *colorsArray = [colorData componentsSeparatedByString:@","];
        float redValue = [[colorsArray objectAtIndex:0] floatValue];
        float greenValue = [[colorsArray objectAtIndex:1] floatValue];
        float blueValue = [[colorsArray objectAtIndex:2] floatValue];
        [uiv_contentView setBackgroundColor:[UIColor colorWithRed:redValue/255.0 green:greenValue/255.0 blue:blueValue/255.0 alpha:1.0]];
        
        //Init Text Part
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 200.0, self.frame.size.width, 300)];
        textView.userInteractionEnabled = NO;
        NSString *str_text = [contentViewData objectForKey:@"label"];
        textView.text = str_text;
        textView.backgroundColor = [UIColor clearColor];
        [textView setFont: [UIFont systemFontOfSize:100]];
        
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
        
        [self addSubview: uiv_contentView];
    }
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
