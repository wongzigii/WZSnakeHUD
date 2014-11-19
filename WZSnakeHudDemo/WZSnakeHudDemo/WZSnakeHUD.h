//
//  WZSnakeHUD.h
//  WZSnakeHudDemo
//
//  Created by Wongzigii on 11/19/14.
//  Copyright (c) 2014 Wongzigii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

#import "WZSnakeHUDDisplayLink.h"

@interface WZSnakeHUD : UIView <WZSnakeDisplayLinkDelegate>

@property (nonatomic, strong) NSArray *hudColors;
@property (nonatomic, assign) CGFloat hudLineWidth;

+ (void)show;
+ (void)hide;
@end
