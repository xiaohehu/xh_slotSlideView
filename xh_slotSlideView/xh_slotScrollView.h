//
//  xh_slotScrollView.h
//  xh_slotSlideView
//
//  Created by Xiaohe Hu on 4/24/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface xh_slotScrollView : UIScrollView <UIScrollViewDelegate>
{

}

@property (nonatomic, strong)       NSArray         *arr_imgArray;
@property (nonatomic, readwrite)    int             startPage;

- (id)initWithFrame:(CGRect)frame andViewData:(NSArray *)dataArray;
@end
