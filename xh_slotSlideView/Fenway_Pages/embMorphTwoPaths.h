//
//  embDraw2D.h
//  victoryparkmenudemo
//
//  Created by Evan Buxton on 11/29/13.
//  Copyright (c) 2013 neoscape. All rights reserved.
//

#import <UIKit/UIKit.h>
@class embMorphTwoPaths;

@protocol embMorphTwoPathsDelegate  <NSObject>
@optional
-(void)embMorphTwoPathsToggled:(embMorphTwoPaths *)menu;
-(void)embMorphTwoPaths:(embMorphTwoPaths *)menu indexOfTapped:(int)i;
typedef enum embPanelAlignment
{
	embPanelRightAlignment,
	embPanelLeftAlignment,
} embPanelAlignment;

@end

@interface embMorphTwoPaths : UIView  <UIGestureRecognizerDelegate>
{
	__weak id <embMorphTwoPathsDelegate> delegate;

	NSMutableArray	*arr_shapeArray;		// used for the CAShapeLayer of each menu shape
	NSMutableArray	*arr_bezierPathArray;	// used to create tappable areas for menu
	NSMutableArray	*arr_cgPathArray;		// holds paths for closing menu - remove
	NSMutableArray	*arr_polyShapes;		// all paths : close path, then open path
	NSMutableArray	*arr_allShapes;			// incoming plist creates this array
	NSMutableArray	*arr_pauses;			// pause between each animation

	
	CAShapeLayer	*menuShapeLayer;		// actual shape being drawn
	
	CGFloat			pauseTimeBeforeStart;	// pauses before beginning from class alloc
	
	NSString		*shapesPlist;			// incoming plist
		
	UIColor			*panelColor;			// panel color
	UIColor			*buttonColor;			// panel color
	UIColor			*arrowColor;			// panel color

	BOOL			isMenuClosing;			// used to determine which shape to draw first: open shape or
											// close shape. Important because we use this to reverse the animation.
}

// public properties
@property (nonatomic, assign) embPanelAlignment panelAlignment; // left side or right side
@property (weak) id<embMorphTwoPathsDelegate> delegate;

// public functions
- (id)initWithFrame:(CGRect)frame andPlistName:(NSString*)p;
-(void)setPanelColor:(UIColor*)color;
-(void)setButtonColor:(UIColor*)color;
-(void)setArrowColor:(UIColor*)color;
-(void)setPauseDelay:(CGFloat)pause;
-(void)pathTappedAtIndex:(int)i;
-(void)animateMenuClose;
@end
