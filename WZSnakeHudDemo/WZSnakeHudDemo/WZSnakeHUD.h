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

@interface WZSnakeHUD : UIView<WZSnakeDisplayLinkDelegate>

@property (nonatomic, strong) NSArray *hudColors;
@property (nonatomic, assign) CGFloat hudLineWidth;
@property (nonatomic, strong) UIColor *hudMaskColor;
@property (nonatomic, strong) NSAttributedString *hudMessage;

+ (void)show;

+ (void)showMessage:(NSAttributedString *)message;

+ (void)hide;

+ (void)setColors:(NSArray *)colors;

+ (void)setBackgroundColor:(UIColor *)backgroundColor;

+ (void)setMaskColor:(UIColor *)maskColor;

+ (void)setLineWidth:(CGFloat)lineWidth;

@end
