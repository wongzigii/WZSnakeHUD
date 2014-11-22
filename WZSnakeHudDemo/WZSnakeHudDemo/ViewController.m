//
//  ViewController.m
//  WZSnakeHudDemo
//
//  Created by Wongzigii on 11/19/14.
//  Copyright (c) 2014 Wongzigii. All rights reserved.
//

#import "ViewController.h"
#import "WZSnakeHUD.h"

@implementation ViewController

- (IBAction)showAction:(id)sender {
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    UIColor *color = [UIColor whiteColor];
    NSDictionary *attributes = @{ NSForegroundColorAttributeName : color,
                                  NSFontAttributeName : font };
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Loading" attributes:attributes];
    [WZSnakeHUD showWithText:attributedString];
    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:5.5f];
}

#pragma mark - private

- (void)hideHUD {
    [WZSnakeHUD hide];
}

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [WZSnakeHUD showWithBackgroundColor:[UIColor purpleColor]];
    [WZSnakeHUD showWithMaskColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f]];
    [WZSnakeHUD showWithLineWidth:5.0f];
}

@end
