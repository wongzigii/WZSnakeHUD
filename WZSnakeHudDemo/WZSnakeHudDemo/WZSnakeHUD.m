//
//  WZSnakeHUD.m
//  WZSnakeHudDemo
//
//  Created by Wongzigii on 11/19/14.
//  Copyright (c) 2014 Wongzigii. All rights reserved.
//

#import "WZSnakeHUD.h"
#import <objc/runtime.h>


static const CGFloat FrameWidth      = 84.0f;    //Size of the HUD's frame
static const CGFloat FrameHeight     = 76.0f;
static const CGFloat lengthIteration = 8.0f;     //velocity
static const CGFloat framePerSecond  = 60.0f;    //fps

////* This is the direction of 'Snake' 's movement*////
typedef enum {
    WZSnakeHUDLineGoRight,
    WZSnakeHUDLineGoDown,
    WZSnakeHUDLineGoLeft,
    WZSnakeHUDLineGoUp,
    WZSnakeHUDLineStop
} WZSnakeHUDLineDirection;

@interface UIColor (MixColor)

@property (nonatomic, readonly) CGFloat r;
@property (nonatomic, readonly) CGFloat g;
@property (nonatomic, readonly) CGFloat b;
@property (nonatomic, readonly) CGFloat a;

- (UIColor *)mixColor:(UIColor *)otherColor;

@end

@implementation UIColor (MixColor)

@dynamic r, g, b, a;

- (CGFloat)r {
    return [[self rgba][@"r"] floatValue];
}

- (CGFloat)g {
    return [[self rgba][@"g"] floatValue];
}

- (CGFloat)b {
    return [[self rgba][@"b"] floatValue];
}

- (CGFloat)a {
    return [[self rgba][@"a"] floatValue];
}

- (UIColor *)mixColor:(UIColor *)otherColor {
    //混色的公式
    //http://stackoverflow.com/questions/726549/algorithm-for-additive-color-mixing-for-rgb-values
    CGFloat newAlpha = 1 - (1 - self.a) * (1 - otherColor.a);
    CGFloat newRed = self.r * self.a / newAlpha + otherColor.r * otherColor.a * (1 - self.a) / newAlpha;
    CGFloat newGreen = self.g * self.a / newAlpha + otherColor.g * otherColor.a * (1 - self.a) / newAlpha;
    CGFloat newBlue = self.b * self.a / newAlpha + otherColor.b * otherColor.a * (1 - self.a) / newAlpha;
    return [UIColor colorWithRed:newRed green:newGreen blue:newBlue alpha:newAlpha];
}

- (NSDictionary *)rgba {
    NSDictionary *rgba = objc_getAssociatedObject(self, _cmd);
    if (!rgba) {
        CGFloat red = 0.0f, green = 0.0f, blue = 0.0f, alpha = 0.0f;
        if ([self getRed:&red green:&green blue:&blue alpha:&alpha]) {
            [self setRgba:@{ @"r":@(red), @"g":@(green), @"b":@(blue), @"a":@(alpha) }];
        }
        else {
            //http://stackoverflow.com/questions/4700168/get-rgb-value-from-uicolor-presets
            CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
            unsigned char resultingPixel[3];
            CGContextRef context = CGBitmapContextCreate(&resultingPixel, 1, 1, 8, 4, rgbColorSpace, (CGBitmapInfo)kCGImageAlphaNone);
            CGContextSetFillColorWithColor(context, [self CGColor]);
            CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
            CGContextRelease(context);
            CGColorSpaceRelease(rgbColorSpace);
            [self setRgba:@{ @"r":@(resultingPixel[0]), @"g":@(resultingPixel[1]), @"b":@(resultingPixel[2]), @"a":@(1.0f) }];
        }
    }
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setRgba:(NSDictionary *)rgba {
    objc_setAssociatedObject(self, @selector(rgba), rgba, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@interface WZSnakeHUD()

@property (nonatomic, assign) CGFloat topLength;
@property (nonatomic, assign) CGFloat rightHeight;
@property (nonatomic, assign) CGFloat bottomLength;
@property (nonatomic, assign) CGFloat leftHeight;

@property (nonatomic, assign) WZSnakeHUDLineDirection direction;
@property (nonatomic, strong) UIImage *rectImage;
@property (nonatomic, strong) WZSnakeHUDDisplayLink *displayLink;
@property (nonatomic, assign) BOOL isFinished;

@end

@implementation WZSnakeHUD

+ (void)show
{
    
}

+ (void)hide
{
    
}

#pragma mark - DaiInboxDisplayLinkDelegate
- (void)displayWillUpdateWithDeltaTime:(CFTimeInterval)deltaTime {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        CGFloat deltaValue = MIN(1.0f, deltaTime / (1.0f / framePerSecond));
        
        switch (self.direction) {
            case WZSnakeHUDLineGoRight:
            {
                self.topLength += lengthIteration * deltaValue / 5;
                if (self.topLength >= FrameWidth) {
                    self.direction = WZSnakeHUDLineGoDown;
                }
                break;
            }
                
            case WZSnakeHUDLineGoDown:
            {
                self.rightHeight += lengthIteration * deltaValue / 5;
                if (self.rightHeight >= FrameHeight) {
                    self.direction = WZSnakeHUDLineGoLeft;
                }
                break;
            }
                
            case WZSnakeHUDLineGoLeft:
            {
                self.bottomLength += lengthIteration * deltaValue / 5;
                if (self.bottomLength >= FrameWidth) {
                    self.direction = WZSnakeHUDLineGoUp;
                }
                break;
            }
                
            case WZSnakeHUDLineGoUp:
            {
                self.leftHeight += lengthIteration * deltaValue / 5;
                if (self.leftHeight >= FrameHeight) {
                    self.direction = WZSnakeHUDLineStop;
                }
                break;
            }
                
            case WZSnakeHUDLineStop:
            {
                //NSLog(@"Done");
                self.isFinished = YES;
            }
                break;
        }
        self.rectImage = [self preDrawImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setNeedsDisplay];
        });
    });
}

- (UIImage *)preDrawImage
{
    UIImage *rectImage;
    
    UIGraphicsBeginImageContext(CGSizeMake(self.bounds.size.width, self.bounds.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //custom
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, self.hudLineWidth);
    
    CGContextMoveToPoint(context, 0, 0);
    
    ////Here we go
    CGContextAddLineToPoint(context, self.topLength, 0);
    
    ////右上角 reached top-right corner?
    if  (self.topLength >= FrameWidth) {
        
        CGContextAddLineToPoint(context, FrameWidth, (self.rightHeight >= FrameHeight) ? FrameHeight : self.rightHeight);
    }
    
    ////右下角 reached bottom-right corner?
    if (self.rightHeight >= FrameHeight) {
        
        CGContextAddLineToPoint(context, (self.bottomLength <= -FrameWidth) ? -FrameWidth : (FrameWidth - self.bottomLength), FrameHeight);
    }
    
    ////左下角 reached bottom-left corner?
    if (self.bottomLength >= FrameWidth) {
        
        CGContextAddLineToPoint(context, 0, (self.leftHeight <= -FrameHeight) ? -FrameHeight : (FrameHeight - self.leftHeight));
    }
    
    CGContextStrokePath(context);
    rectImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return rectImage;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self.rectImage drawInRect:rect];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        self.direction = WZSnakeHUDLineGoRight;
        self.displayLink = [[WZSnakeHUDDisplayLink alloc] initWithDelegate:self];
    }
    return self;
}


@end
