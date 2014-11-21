//
//  WZSnakeHUDViewController.m
//  WZSnakeHudDemo
//
//  Created by Wongzigii on 11/21/14.
//  Copyright (c) 2014 Wongzigii. All rights reserved.
//

#import "WZSnakeHUDViewController.h"
#import "WZSnakeHUD.h"

static const CGFloat centerViewWidth  = 84.0f;
static const CGFloat centerViewHeight = 75.5f;

@interface WZSnakeHUDViewController ()

@property (nonatomic, strong) WZSnakeHUD *hudView;

@end

@implementation WZSnakeHUDViewController

#pragma mark - instance method

- (void)hide:(void (^)(void))completion {
    [UIView animateWithDuration:0.3 / 1.5 animations: ^{
        _hudView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
    } completion: ^(BOOL finished) {
        [UIView animateWithDuration:0.3 / 2 animations: ^{
            _hudView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        } completion: ^(BOOL finished) {
            [UIView animateWithDuration:0.3 / 2 animations: ^{
                _hudView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
            } completion:^(BOOL finished) {
                completion();
            }];
        }];
    }];

}

#pragma mark - private

- (void)setupDefaultHUD {
    CGRect messageFrame = CGRectZero;
    UILabel *hudMessageLabel;
    
    hudMessageLabel = [[UILabel alloc] init];
    hudMessageLabel.attributedText = self.hudMessage;
    [hudMessageLabel sizeToFit];
    messageFrame = hudMessageLabel.frame;
    
    _hudView = [[WZSnakeHUD alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - centerViewWidth / 2, self.view.frame.size.height / 2 - centerViewWidth / 2, centerViewWidth,centerViewHeight)];
    
    _hudView.backgroundColor = self.hudBackgroundColor;
    _hudView.layer.cornerRadius = 5.0f;
    _hudView.layer.masksToBounds = YES;
    _hudView.hudColors = self.hudColors;
    _hudView.hudLineWidth = self.hudLineWidth;
    [self.view addSubview:_hudView];
    
    hudMessageLabel.frame = CGRectMake(_hudView.frame.size.width / 2 - hudMessageLabel.frame.size.width / 2,_hudView.frame.size.height / 2, hudMessageLabel.frame.size.width, hudMessageLabel.frame.size.height);
    [_hudView addSubview:hudMessageLabel];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = self.hudMaskColor;
    [self setupDefaultHUD];
    
    _hudView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [UIView animateWithDuration:0.3 / 1.5 animations: ^{
        _hudView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion: ^(BOOL finished) {
        [UIView animateWithDuration:0.3 / 2 animations: ^{
            _hudView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion: ^(BOOL finished) {
            [UIView animateWithDuration:0.3 / 2 animations: ^{
                _hudView.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
}

@end

