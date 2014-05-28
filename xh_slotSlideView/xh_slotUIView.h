//
//  xh_slotUIView.h
//  xh_slotSlideView
//
//  Created by Xiaohe Hu on 5/28/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface xh_slotUIView : UIView <UIScrollViewDelegate>
{
    
}

@property (nonatomic, strong)       NSArray         *arr_imgArray;
@property (nonatomic, readwrite)    int             startPage;

- (id)initWithFrame:(CGRect)frame andViewData:(NSArray *)dataArray;

-(void)pauseAnimation:(BOOL)pause;


@end
