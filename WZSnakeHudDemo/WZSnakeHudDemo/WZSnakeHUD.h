//
//  WZSnakeHUD.h
//  WZSnakeHudDemo
//
//  Created by Wongzigii on 11/19/14.
//  Copyright (c) 2014 Wongzigii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WZSnakeHUDDisplayLink.h"

static const CGFloat WZSnakeHUDFrameWidth    = 84.0f;
static const CGFloat WZSnakeHUDFrameHeight   = 76.0f;
static const CGFloat WZSnakeLengthIteration  = 8.0f;
static const CGFloat WZSnakeFramePerSecond   = 60.0f;

/**
 * define the line direction
 */
typedef enum {
    LineDirectionGoRight,
    LineDirectionGoDown,
    LineDirectionGoLeft,
    LineDirectionGoUp,
    LineDirectionStop
} LineDirection;

@interface WZSnakeHUD : UIView<WZSnakeDisplayLinkDelegate>

@property (nonatomic, strong) NSArray *hudColors;
@property (nonatomic, assign) CGFloat hudLineWidth;
@property (nonatomic, strong) UIColor *hudMaskColor;
@property (nonatomic, strong) UIColor *hudBackgroundColor;
@property (nonatomic, strong) NSAttributedString *hudMessage;

+ (void)show:(NSString *)text;

+ (void)hide;

+ (void)showWithColors:(NSArray *)colors;

+ (void)showWithBackgroundColor:(UIColor *)backgroundColor;

+ (void)showWithMaskColor:(UIColor *)maskColor;

+ (void)showWithLineWidth:(CGFloat)lineWidth;

- (void)showAnimated;


@end
