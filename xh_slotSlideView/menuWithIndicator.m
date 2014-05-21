//
//  menuWithIndicator.m
//  xh_menuWithIndicator
//
//  Created by Xiaohe Hu on 5/19/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import "menuWithIndicator.h"
static float indicator_Y = -40;
static float buttonSpace = 20.0;
@interface menuWithIndicator ()
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
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
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
                [self.arr_buttonImages addObject:[self.dataSource imageOfButtonsAtIndex:j]];
            }
        }
        //Add Selected Button's Background Image
        if ([self.dataSource imageOfSelectedButtonAtIndex:0] != nil) {
            for (int k = 0; k < count; k++) {
                [self.arr_buttonSelectImage addObject:[self.dataSource imageOfSelectedButtonAtIndex:k]];
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
            [uib_menuItem setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            uib_menuItem.tag = i;
            [uib_menuItem setBackgroundColor:[UIColor yellowColor]];
            [uib_menuItem addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
            preSize = stringsize;
            preX = uib_menuItem.frame.origin.x;
            [_uiv_buttonContainer addSubview:uib_menuItem];
            [_arr_buttons addObject:uib_menuItem];
        }
        [self addSubview: _uiv_buttonContainer];
        return;
    }
    if (([self.arr_buttonImages count] > 0) && (self.arr_buttonSelectImage.count == 0)) {
        for (int i = 0; i < self.arr_buttonImages.count; i++) {
            UIImage *buttonImage = [self.arr_buttonImages objectAtIndex:i];
            CGSize imgSize = buttonImage.size;
            UIButton *uib_menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
            uib_menuItem.frame = CGRectMake((preSize.width + buttonSpace + preX), 0.0, imgSize.width, self.frame.size.height);
            [uib_menuItem setImage:buttonImage forState:UIControlStateNormal];
            uib_menuItem.tag = i;
            [uib_menuItem addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
            preSize = imgSize;
            preX = uib_menuItem.frame.origin.x;
            [_uiv_buttonContainer addSubview:uib_menuItem];
            [_arr_buttons addObject:uib_menuItem];
        }
        [self addSubview: _uiv_buttonContainer];
        return;
    }
    if (([self.arr_buttonImages count] > 0) && (self.arr_buttonImages.count == self.arr_buttonSelectImage.count)) {
        for (int i = 0; i < self.arr_buttonImages.count; i++) {
            UIImage *buttonImage = [self.arr_buttonImages objectAtIndex:i];
            UIImage *selectImage = [self.arr_buttonSelectImage objectAtIndex:i];
            CGSize imgSize = buttonImage.size;
            UIButton *uib_menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
            uib_menuItem.frame = CGRectMake((preSize.width + buttonSpace + preX), 0.0, imgSize.width, self.frame.size.height);
            [uib_menuItem setImage:buttonImage forState:UIControlStateNormal];
            [uib_menuItem setImage:selectImage forState:UIControlStateSelected];
            uib_menuItem.tag = i;
            [uib_menuItem addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
            preSize = imgSize;
            preX = uib_menuItem.frame.origin.x;
            [_uiv_buttonContainer addSubview:uib_menuItem];
            [_arr_buttons addObject:uib_menuItem];
        }
        [self addSubview: _uiv_buttonContainer];
        return;
    }
}

-(void)buttonTapped:(id)sender {    
    UIButton *tmpButton = sender;
    [self addSubview:_uiv_menuIndicator];
    // Tap the button again
    if (_preBtnTag == tmpButton.tag) {
        tmpButton.selected = NO;
        _uiv_menuIndicator.hidden = YES;
        [self didSelectItemAgainInMenu:self];
        _preBtnTag = -1;
    }
    // Tap the button first time
    else {
        for (UIButton *tmp in _arr_buttons) {
            if (tmp.tag == _preBtnTag) {
                tmp.selected = NO;
            }
        }
        tmpButton.selected = YES;
        if (_uiv_menuIndicator.hidden) {
            _uiv_menuIndicator.frame = CGRectMake(tmpButton.frame.origin.x+(tmpButton.frame.size.width - _uiv_menuIndicator.frame.size.width)/2, indicator_Y, _uiv_menuIndicator.frame.size.width, _uiv_menuIndicator.frame.size.height);
            _uiv_menuIndicator.hidden = NO;
        }
        else {
            [UIView animateWithDuration:0.4 animations:^{
                    _uiv_menuIndicator.frame = CGRectMake(tmpButton.frame.origin.x+(tmpButton.frame.size.width - _uiv_menuIndicator.frame.size.width)/2, indicator_Y, _uiv_menuIndicator.frame.size.width, _uiv_menuIndicator.frame.size.height);
            }];
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
        tmp.selected = NO;
        _uiv_menuIndicator.hidden = YES;
    }
    _preBtnTag = -1;
}

-(void)hightLightBtns:(int) index withAnimation:(BOOL)animate{
    for (UIButton *tmp in [_uiv_buttonContainer subviews]) {
        if (tmp.tag == _preBtnTag) {
            tmp.selected = NO;
        }
        if (animate) {
            if (tmp.tag == index) {
                tmp.selected = YES;
                [UIView animateWithDuration:0.4 animations:^{
                    _uiv_menuIndicator.frame = CGRectMake(tmp.frame.origin.x+(tmp.frame.size.width - _uiv_menuIndicator.frame.size.width)/2, indicator_Y, _uiv_menuIndicator.frame.size.width, _uiv_menuIndicator.frame.size.height);
                }];
                _uiv_menuIndicator.hidden = NO;
            }
        }
        else {
            [self addSubview:_uiv_menuIndicator];
            if (tmp.tag == index) {
                tmp.selected = YES;
                _uiv_menuIndicator.frame = CGRectMake(tmp.frame.origin.x+(tmp.frame.size.width - _uiv_menuIndicator.frame.size.width)/2, indicator_Y, _uiv_menuIndicator.frame.size.width, _uiv_menuIndicator.frame.size.height);
                _uiv_menuIndicator.hidden = NO;
            }
        }
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
