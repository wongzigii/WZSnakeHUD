//
//  WZSnakeHUDViewController.h
//  WZSnakeHudDemo
//
//  Created by Wongzigii on 11/21/14.
//  Copyright (c) 2014 Wongzigii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZSnakeHUDViewController : UIViewController

@property (nonatomic, strong) NSArray *hudColors;
@property (nonatomic, assign) CGFloat hudLineWidth;
@property (nonatomic, strong) UIColor *hudMaskColor;
@property (nonatomic, strong) UIColor *hudBackgroundColor;
@property (nonatomic, strong) NSAttributedString *hudMessage;

- (void)hide:(void (^)(void))completion;

@end
