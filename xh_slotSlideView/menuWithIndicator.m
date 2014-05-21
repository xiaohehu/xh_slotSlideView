//
//  menuWithIndicator.m
//  xh_menuWithIndicator
//
//  Created by Xiaohe Hu on 5/19/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import "menuWithIndicator.h"

static float buttonSpace = 20.0;
@interface menuWithIndicator ()
//@property (nonatomic)         int                   numOfLevels;
@property (nonatomic, strong) NSMutableArray        *arr_buttons;
@property (nonatomic)         int                   preBtnTag;
@property (nonatomic, strong) UIView                *uiv_menuIndicator;
@property (nonatomic, strong) UIView                *uiv_buttonContainer;
@end

@implementation menuWithIndicator
@synthesize arr_buttonImages, arr_buttonSelectImage, arr_buttonTitles;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _preBtnTag = -1;
        self.arr_buttonImages = [[NSMutableArray alloc] init];
        self.arr_buttonTitles = [[NSMutableArray alloc] init];
        self.arr_buttonSelectImage = [[NSMutableArray alloc] init];
        _arr_buttons = [[NSMutableArray alloc] init];
        _uiv_menuIndicator = [[UIView alloc] init];
        _uiv_buttonContainer = [[UIView alloc] initWithFrame:self.bounds];
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

-(void)setDataSource:(id<indicatorMenuDataSource>)dataSource {
    _dataSource = dataSource;
    [self reloadData];
}

-(void) reloadData {
    NSLog(@"Load the data");
    [self.arr_buttonTitles removeAllObjects];
    [self.arr_buttonImages removeAllObjects];
    [self.arr_buttonSelectImage removeAllObjects];
    
//    _numOfLevels = (int)[self.dataSource numberOfLevels];
//    if (_numOfLevels == 0) {
//        return;
//    }
//    else {
//        if (self.dataSource != nil) {
//            for (int level = 0; level < _numOfLevels; level++) {
//                //Add Button Titles
//                if ([self.dataSource titleOfButtons] != nil) {
//                    [self.arr_buttonTitles setArray:[self.dataSource titleOfButtons]];
//                }
//            }
//        }
//    }
    
    if (self.dataSource != nil) {
        NSInteger count = [self.dataSource numberOfMenuItems];
        
        //Add button Title
        if ([self.dataSource titleOfButtonsAtIndex:0] != nil) {
            for (int i = 0; i < count; i++) {
                NSString *buttonTitle = [self.dataSource titleOfButtonsAtIndex:i];
                [self.arr_buttonTitles addObject:buttonTitle];
            }
        }
        //Add Button Background Image
        if ([self.dataSource imageOfButtonsAtIndex:0] != nil) {
            for (int j = 0; j < count; j++) {
                UIImage *buttonBgImg = [self.dataSource imageOfButtonsAtIndex:j];
                [self.arr_buttonImages addObject:buttonBgImg];
            }
        }
        //Add Selected Button's Background Image
        if ([self.dataSource imageOfSelectedButtonAtIndex:0] != nil) {
            for (int k = 0; k < count; k++) {
                UIImage *selectedBtnImg = [self.dataSource imageOfSelectedButtonAtIndex:k];
                [self.arr_buttonSelectImage addObject:selectedBtnImg];
            }
        }
        //Add menu's indicator
        _uiv_menuIndicator = [self.dataSource indicatorForMenu];
        _uiv_menuIndicator.hidden = YES;
    }
    
    [self initMenuItems];
}

-(void) initMenuItems {
    CGSize preSize = CGSizeZero;
    CGFloat preX = 0.0;
    if ([self.arr_buttonTitles count] > 0) {
        for (int i = 0; i < self.arr_buttonTitles.count; i++) {
            NSString *titleString = [self.arr_buttonTitles objectAtIndex:i];
            CGSize stringsize = [titleString sizeWithFont:[UIFont systemFontOfSize:20]];
            UIButton *uib_menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
            uib_menuItem.frame = CGRectMake((preSize.width + buttonSpace + preX), 0.0, stringsize.width, self.frame.size.height);
            [uib_menuItem setTitle:titleString forState:UIControlStateNormal];
            [uib_menuItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            uib_menuItem.tag = i;
            [uib_menuItem setBackgroundColor:[UIColor yellowColor]];
            [uib_menuItem addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
            preSize = stringsize;
            preX = uib_menuItem.frame.origin.x;
            [_uiv_buttonContainer addSubview:uib_menuItem];
            [_arr_buttons addObject:uib_menuItem];
        }
    }
    [self addSubview: _uiv_buttonContainer];
}

-(void)buttonTapped:(id)sender {    
    UIButton *tmpButton = sender;
    [self addSubview:_uiv_menuIndicator];
    // Tap the button again
    if (_preBtnTag == tmpButton.tag) {
        if (self.arr_buttonTitles.count > 0) {
            [tmpButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _uiv_menuIndicator.hidden = YES;
        }
        [self didSelectItemAgainInMenu:self];
        _preBtnTag = -1;
    }
    // Tap the button first time
    else {
        for (UIButton *tmp in _arr_buttons) {
            [tmp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        if (self.arr_buttonTitles.count > 0) {
            [tmpButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            if (_uiv_menuIndicator.hidden) {
                _uiv_menuIndicator.frame = CGRectMake(tmpButton.frame.origin.x+(tmpButton.frame.size.width - _uiv_menuIndicator.frame.size.width)/2, 0.0, _uiv_menuIndicator.frame.size.width, _uiv_menuIndicator.frame.size.height);
                _uiv_menuIndicator.hidden = NO;
            }
            else {
                [UIView animateWithDuration:0.6 animations:^{
                    _uiv_menuIndicator.frame = CGRectMake(tmpButton.frame.origin.x+(tmpButton.frame.size.width - _uiv_menuIndicator.frame.size.width)/2, 0.0, _uiv_menuIndicator.frame.size.width, _uiv_menuIndicator.frame.size.height);
                }];
            }
            
        }
        [self didSelectItemAtIndex:tmpButton.tag inMenu:self];
        _preBtnTag = (int)tmpButton.tag;
    }
}

#pragma mark- Delegate Method
-(void) didSelectItemAtIndex:(NSInteger) selectedIndex inMenu:(menuWithIndicator *)indicatorMenu{
    [self.delegate didSelectItemAtIndex:selectedIndex inMenu:indicatorMenu];
}
-(void) didSelectItemAgainInMenu:(menuWithIndicator *)indicatorMenu {
    [self.delegate didSelectItemAgainInMenu:indicatorMenu];
}

#pragma mark - Highlight buttons control
-(void)unHighLightBtns {
    for (UIButton *tmp in [_uiv_buttonContainer subviews]) {
        [tmp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _uiv_menuIndicator.hidden = YES;
    }
    _preBtnTag = -1;
}

-(void)hightLightBtns:(int) index withAnimation:(BOOL)animate{
    for (UIButton *tmp in [_uiv_buttonContainer subviews]) {
        [tmp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        if (animate) {
            if (tmp.tag == index) {
                [tmp setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [UIView animateWithDuration:0.6 animations:^{
                    _uiv_menuIndicator.frame = CGRectMake(tmp.frame.origin.x+(tmp.frame.size.width - _uiv_menuIndicator.frame.size.width)/2, 0.0, _uiv_menuIndicator.frame.size.width, _uiv_menuIndicator.frame.size.height);
                }];
            }
        }
        else {
            [self addSubview:_uiv_menuIndicator];
            if (tmp.tag == index) {
                [tmp setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                _uiv_menuIndicator.frame = CGRectMake(tmp.frame.origin.x+(tmp.frame.size.width - _uiv_menuIndicator.frame.size.width)/2, 0.0, _uiv_menuIndicator.frame.size.width, _uiv_menuIndicator.frame.size.height);
                _uiv_menuIndicator.hidden = NO;
            }

        }
        
        
//        _uiv_menuIndicator.hidden = YES;
    }
    _preBtnTag = index;
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
