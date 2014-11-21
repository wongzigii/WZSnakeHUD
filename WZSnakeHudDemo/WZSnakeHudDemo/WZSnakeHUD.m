//
//  WZSnakeHUD.m
//  WZSnakeHudDemo
//
//  Created by Wongzigii on 11/19/14.
//  Copyright (c) 2014 Wongzigii. All rights reserved.
//

#import "WZSnakeHUD.h"
#import <objc/runtime.h>
#import "WZSnakeHUDWindow.h"
#import "WZSnakeHUDViewController.h"

static const CGFloat FrameWidth      = 84.0f;
static const CGFloat FrameHeight     = 76.0f;
static const CGFloat lengthIteration = 8.0f;
static const CGFloat framePerSecond  = 60.0f;

typedef enum {
    RectLineGoRight,
    RectLineGoDown,
    RectLineGoLeft,
    RectLineGoUp,
    RectLineStop
} RectLineGoDirection;

@interface WZSnakeHUD()

@property (nonatomic, assign) NSInteger lengthTop;
@property (nonatomic, assign) NSInteger heightTop;
@property (nonatomic, assign) NSInteger lengthBottom;
@property (nonatomic, assign) NSInteger heightBottom;
@property (nonatomic, assign) RectLineGoDirection direction;
@property (nonatomic, strong) UIImage *lineImage;
@property (nonatomic, strong) WZSnakeHUDDisplayLink *displayLink;
@property (nonatomic, weak)   WZSnakeHUDWindow *window;

@end

@implementation WZSnakeHUD

#pragma mark - class method
+ (void)show {
    [self showMessage:nil];
}

+ (void)showMessage:(NSAttributedString *)message
{
    WZSnakeHUDViewController *vc = [[WZSnakeHUDViewController alloc] init];
    vc.hudColors = [self hudColors];
    vc.hudBackgroundColor = [self hudBackgroundColor];
    vc.hudMaskColor = [self hudMaskColor];
    vc.hudLineWidth = [self hudLineWidth];
    vc.hudMessage = message;
    [self hudWindow].rootViewController = vc;
    [[self hudWindow] makeKeyAndVisible];
}

+ (void)hide {
    [[self hudWindow].rootViewController performSelector:@selector(hide:) withObject: ^{
        [self hudWindow].hidden = YES;
        [self setHudWindow:nil];
        [[UIApplication sharedApplication].keyWindow makeKeyWindow];
    }];
}

+ (void)setColors:(NSArray *)colors {
    [self setHudColors:colors];
}

+ (void)setBackgroundColor:(UIColor *)backgroundColor {
    [self setHudBackgroundColor:backgroundColor];
}

+ (void)setMaskColor:(UIColor *)maskColor {
    [self setHudMaskColor:maskColor];
}

+ (void)setLineWidth:(CGFloat)lineWidth {
    [self setHudLineWidth:lineWidth];
}

+ (WZSnakeHUDWindow *)hudWindow {
    if (!objc_getAssociatedObject(self, _cmd)) {
        [self setHudWindow:[[WZSnakeHUDWindow alloc] initWithFrame:[UIScreen mainScreen].bounds]];
    }
    return objc_getAssociatedObject(self, _cmd);
}

+ (void)setHudWindow:(WZSnakeHUDWindow *)hudWindow {
    objc_setAssociatedObject(self, @selector(hudWindow), hudWindow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

//adding instance variable using runtime
//http://stackoverflow.com/questions/17678298/how-does-objc-setassociatedobject-work
+ (void)setHudColors:(NSArray *)hudColors {
    objc_setAssociatedObject(self, @selector(hudColors), hudColors, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSArray *)hudColors {
    if (!objc_getAssociatedObject(self, _cmd)) {
        [self setHudColors:@[[UIColor redColor], [UIColor greenColor], [UIColor yellowColor], [UIColor blueColor]]];
    }
    return objc_getAssociatedObject(self, _cmd);
}

+ (void)setHudBackgroundColor:(UIColor *)hudBackgroundColor {
    objc_setAssociatedObject(self, @selector(hudBackgroundColor), hudBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIColor *)hudBackgroundColor {
    if (!objc_getAssociatedObject(self, _cmd)) {
        [self setHudBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.65f]];
    }
    return objc_getAssociatedObject(self, _cmd);
}

+ (void)setHudLineWidth:(CGFloat)hudLineWidth {
    objc_setAssociatedObject(self, @selector(hudLineWidth), @(hudLineWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (CGFloat)hudLineWidth {
    if (!objc_getAssociatedObject(self, _cmd)) {
        [self setHudLineWidth:2.0f];
    }
    NSNumber *hudLineWidth = objc_getAssociatedObject(self, _cmd);
    return [hudLineWidth floatValue];
}

+ (void)setHudMaskColor:(UIColor *)hudMaskColor {
    objc_setAssociatedObject(self, @selector(hudMaskColor), hudMaskColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIColor *)hudMaskColor {
    if (!objc_getAssociatedObject(self, _cmd)) {
        [self setHudMaskColor:[UIColor clearColor]];
    }
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - WZSnakeDisplayLink Delegate
- (void)displayWillUpdateWithDeltaTime:(CFTimeInterval)deltaTime
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        CGFloat deltaValue = MIN(1.0f, deltaTime / (1.0f / framePerSecond));
        
        switch (self.direction) {
            case RectLineGoRight:
            {
                self.lengthTop += lengthIteration * deltaValue / 5;
                if (self.lengthTop >= FrameWidth) {
                    self.direction = RectLineGoDown;
                }
                break;
            }
            case RectLineGoDown:
            {
                self.heightTop += lengthIteration * deltaValue / 5;
                if (self.heightTop >= FrameHeight) {
                    self.direction = RectLineGoLeft;
                }
                break;
            }
            case RectLineGoLeft:
            {
                self.lengthBottom += lengthIteration * deltaValue / 5;
                if (self.lengthBottom >= FrameWidth) {
                    self.direction = RectLineGoUp;
                }
                break;
            }
            case RectLineGoUp:
            {
                self.heightBottom += lengthIteration * deltaValue / 5;
                if (self.heightBottom >= FrameHeight) {
                    self.direction = RectLineStop;
                }
                break;
            }
            case RectLineStop:
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
    //reached top-right corner
    if  (self.lengthTop >= FrameWidth) {
        CGContextAddLineToPoint(context, FrameWidth, (self.heightTop >= FrameHeight) ? FrameHeight : self.heightTop);
    }
    //reached bottom-right corner
    if (self.heightTop >= FrameHeight) {
        CGContextAddLineToPoint(context, (self.lengthBottom <= -FrameWidth) ? -FrameWidth : (FrameWidth - self.lengthBottom), FrameHeight);
    }
    //reached bottom-left corner
    if (self.lengthBottom >= FrameWidth) {
        CGContextAddLineToPoint(context, 0, (self.heightBottom <= -FrameHeight) ? -FrameHeight : (FrameHeight - self.heightBottom));
    }
    CGContextStrokePath(context);
    rectLineImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return rectLineImage;
}

- (void)showAnimated
{
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
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
        self.direction = RectLineGoRight;
        self.displayLink = [[WZSnakeHUDDisplayLink alloc] initWithDelegate:self];
    }
    return self;
}

@end
