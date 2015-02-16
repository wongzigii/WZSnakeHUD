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

@interface WZSnakeHUD : UIView

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