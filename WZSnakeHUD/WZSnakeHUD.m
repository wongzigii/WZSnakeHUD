//
//  WZSnakeHUD.m
//  WZSnakeHudDemo
//
//  Created by Wongzigii on 11/19/14.
//  Copyright (c) 2014 Wongzigii. All rights reserved.
//

#import "WZSnakeHUD.h"
#import <objc/runtime.h>
#import "WZSnakeHUDViewController.h"
#import "WZSnakeHUDWindow.h"
static const CGFloat WZSnakeHUDFrameWidth    = 84.0f;
static const CGFloat WZSnakeHUDFrameHeight   = 76.0f;
static const CGFloat WZSnakeLengthIteration  = 8.0f;
static const CGFloat WZSnakeFramePerSecond   = 60.0f;

typedef NS_ENUM(NSInteger, LineDirection) {
    LineDirectionGoRight,
    LineDirectionGoDown,
    LineDirectionGoLeft,
    LineDirectionGoUp,
    LineDirectionStop
};

@interface WZSnakeHUD()<WZSnakeDisplayLinkDelegate>

@property (nonatomic, assign) NSInteger lengthTop;
@property (nonatomic, assign) NSInteger heightTop;
@property (nonatomic, assign) NSInteger lengthBottom;
@property (nonatomic, assign) NSInteger heightBottom;
@property (nonatomic, assign) LineDirection direction;
@property (nonatomic, strong) UIImage *lineImage;
@property (nonatomic, strong) WZSnakeHUDDisplayLink *displayLink;
@property (nonatomic, weak)   WZSnakeHUDWindow *window;
@property (nonatomic, assign) CGFloat *movingSpeed;

@end

/*!
 *  @implementation WZSnakeHUD
 */
@implementation WZSnakeHUD

#pragma mark - class method

+ (void)show:(NSString *)text {
    NSString *string = [NSString stringWithFormat:@"%@",text];
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    UIColor *color = [UIColor whiteColor];
    NSDictionary *attributes = @{ NSForegroundColorAttributeName : color,
                                  NSFontAttributeName : font };
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:string attributes:attributes];
    WZSnakeHUDViewController *vc = [[WZSnakeHUDViewController alloc] init];
    vc.hudColors = self.hudColors;
    vc.hudBackgroundColor = self.hudBackgroundColor;
    vc.hudMaskColor = self.hudMaskColor;
    vc.hudLineWidth = self.hudLineWidth;
    vc.hudMessage = attributedString;
    self.hudWindow.rootViewController = vc;
    [self.hudWindow makeKeyAndVisible];
}

+ (void)hide {
    [self.hudWindow.rootViewController performSelector:@selector(hide:) withObject: ^{
        self.hudWindow.hidden = YES;
        self.hudWindow = nil;
        self.hudWindow.backgroundColor = nil;
        [[UIApplication sharedApplication].keyWindow makeKeyWindow];
    }];
}

+ (void)showWithColors:(NSArray *)colors {
    self.hudColors = colors;
}

+ (void)showWithBackgroundColor:(UIColor *)backgroundColor {
    self.hudBackgroundColor = backgroundColor;
}

+ (void)showWithMaskColor:(UIColor *)maskColor {
    self.hudMaskColor = maskColor;
}

+ (void)showWithLineWidth:(CGFloat)lineWidth {
    self.hudLineWidth = lineWidth;
}

+ (WZSnakeHUDWindow *)hudWindow {
    if (!objc_getAssociatedObject(self, _cmd)) {
        self.hudWindow = [[WZSnakeHUDWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return objc_getAssociatedObject(self, _cmd);
}

+ (void)setHudWindow:(WZSnakeHUDWindow *)hudWindow {
    objc_setAssociatedObject(self, @selector(hudWindow), hudWindow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)setHudColors:(NSArray *)hudColors {
    objc_setAssociatedObject(self, @selector(hudColors), hudColors, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSArray *)hudColors {
    if (!objc_getAssociatedObject(self, _cmd)) {
        self.hudColors = @[[UIColor redColor], [UIColor yellowColor], [UIColor greenColor]];
    }
    return objc_getAssociatedObject(self, _cmd);
}

+ (void)setHudBackgroundColor:(UIColor *)hudBackgroundColor {
    objc_setAssociatedObject(self, @selector(hudBackgroundColor), hudBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIColor *)hudBackgroundColor {
    if (!objc_getAssociatedObject(self, _cmd)) {
        self.hudBackgroundColor = [UIColor colorWithRed:127.0/255.0 green:198.0/255.0 blue:35.0/255.0 alpha:0.65f];
    }
    return objc_getAssociatedObject(self, _cmd);
}

+ (void)setHudLineWidth:(CGFloat)hudLineWidth {
    objc_setAssociatedObject(self, @selector(hudLineWidth), @(hudLineWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (CGFloat)hudLineWidth {
    if (!objc_getAssociatedObject(self, _cmd)) {
        self.hudLineWidth = 5.0f;
    }
    NSNumber *hudLineWidth = objc_getAssociatedObject(self, _cmd);
    return [hudLineWidth floatValue];
}

+ (void)setHudMaskColor:(UIColor *)hudMaskColor {
    objc_setAssociatedObject(self, @selector(hudMaskColor), hudMaskColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIColor *)hudMaskColor {
    if (!objc_getAssociatedObject(self, _cmd)) {
        self.hudMaskColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
    }
    return objc_getAssociatedObject(self, _cmd);
}

//Speed
#pragma mark - WZSnakeDisplayLink Delegate
- (void)displayWillUpdateWithDeltaTime:(CFTimeInterval)deltaTime
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        CGFloat deltaValue = MIN(1.0f, deltaTime / (1.0f / WZSnakeFramePerSecond));
        
        switch (self.direction) {
            case LineDirectionGoRight:
            {
                self.lengthTop += (WZSnakeLengthIteration * deltaValue / 5);
                if (self.lengthTop >= WZSnakeHUDFrameWidth) {
                    self.direction = LineDirectionGoDown;
                }
                break;
            }
            case LineDirectionGoDown:
            {
                self.heightTop += WZSnakeLengthIteration * deltaValue / 5;
                if (self.heightTop >= WZSnakeHUDFrameHeight) {
                    self.direction = LineDirectionGoLeft;
                }
                break;
            }
            case LineDirectionGoLeft:
            {
                self.lengthBottom += WZSnakeLengthIteration * deltaValue / 5;
                if (self.lengthBottom >= WZSnakeHUDFrameWidth) {
                    self.direction = LineDirectionGoUp;
                }
                break;
            }
            case LineDirectionGoUp:
            {
                self.heightBottom += WZSnakeLengthIteration * deltaValue / 5;
                if (self.heightBottom >= WZSnakeHUDFrameHeight) {
                    self.direction = LineDirectionStop;
                }
                break;
            }
            case LineDirectionStop:
            {
                //NSLog(@"Done");
            }
                break;
        }
        self.lineImage = [self preDrawImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setNeedsDisplay];
        });
    });
}

#pragma mark - private
- (UIImage *)preDrawImage
{
    UIImage *rectLineImage;
    
    UIGraphicsBeginImageContext(CGSizeMake(self.bounds.size.width, self.bounds.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetRGBStrokeColor(context, 255, 255, 255, 1);
    CGContextSetLineWidth(context, self.hudLineWidth);
    //original point
    CGContextMoveToPoint(context, 0, 0);
    
    //here we go
    CGContextAddLineToPoint(context, self.lengthTop, 0);
    
    //reached upper-right corner
    if  (self.lengthTop >= WZSnakeHUDFrameWidth) {
        CGContextAddLineToPoint(context, WZSnakeHUDFrameWidth, (self.heightTop >= WZSnakeHUDFrameHeight) ? WZSnakeHUDFrameHeight : self.heightTop);
    }
    
    //reached lower-right corner
    if (self.heightTop >= WZSnakeHUDFrameHeight) {
        CGContextAddLineToPoint(context, (self.lengthBottom <= -WZSnakeHUDFrameWidth) ? -WZSnakeHUDFrameWidth : (WZSnakeHUDFrameWidth - self.lengthBottom), WZSnakeHUDFrameHeight);
    }
    
    //reached lower-left corner
    if (self.lengthBottom >= WZSnakeHUDFrameWidth) {
        CGContextAddLineToPoint(context, 0, (self.heightBottom <= -WZSnakeHUDFrameHeight) ? -WZSnakeHUDFrameHeight : (WZSnakeHUDFrameHeight - self.heightBottom));
    }
    
    CGContextStrokePath(context);
    rectLineImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return rectLineImage;
}

- (void)showAnimated
{
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.0, 0.0);
    [UIView animateWithDuration:0.3 / 1.5 animations: ^{
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion: ^(BOOL finished) {
        [UIView animateWithDuration:0.3 / 2 animations: ^{
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion: ^(BOOL finished) {
            [UIView animateWithDuration:0.3 / 2 animations: ^{
                self.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
}

#pragma mark - method override
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self.lineImage drawInRect:rect];
}

#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //init
        self.backgroundColor = [UIColor clearColor];
        self.lengthTop = 0;
        self.direction = LineDirectionGoRight;
        //set delegate
        self.displayLink = [[WZSnakeHUDDisplayLink alloc] initWithDelegate:self];
    }
    
    return self;
}

@end