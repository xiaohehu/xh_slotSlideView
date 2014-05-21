//
//  menuWithIndicator.h
//  xh_menuWithIndicator
//
//  Created by Xiaohe Hu on 5/19/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol indicatorMenuDataSource;
@protocol indicatorMenuDelegate;

@interface menuWithIndicator : UIView {

}

@property (nonatomic, strong) id<indicatorMenuDataSource>   dataSource;
@property (nonatomic, strong) id<indicatorMenuDelegate>     delegate;

@property (nonatomic, strong)   NSMutableArray              *arr_buttonTitles;
@property (nonatomic, strong)   NSMutableArray              *arr_buttonImages;
@property (nonatomic, strong)   NSMutableArray              *arr_buttonSelectImage;

//Method control hightlight buttons
-(void)unHighLightBtns;
-(void)hightLightBtns:(int) index withAnimation:(BOOL)animate;

@end

@protocol indicatorMenuDataSource <NSObject>
//-(NSInteger) numberOfLevels;
-(NSInteger) numberOfMenuItems;
@optional
-(NSString *) titleOfButtonsAtIndex:(NSInteger) index;
-(UIImage *)  imageOfButtonsAtIndex:(NSInteger) index;
-(UIImage *)  imageOfSelectedButtonAtIndex:(NSInteger) index;
-(UIView *) indicatorForMenu;
//-(NSArray *) titleOfButtons;
//-(NSArray *) imageOfButtons;
//-(NSArray *) imageOfSelectedButton;
//-(NSArray *) indicatorForMenu;
@end

@protocol indicatorMenuDelegate <NSObject>

-(void) didSelectItemAtIndex:(NSInteger) selectedIndex inMenu:(menuWithIndicator *)indicatorMenu;
@optional
-(void) didSelectItemAgainInMenu:(menuWithIndicator *)indicatorMenu;

@end