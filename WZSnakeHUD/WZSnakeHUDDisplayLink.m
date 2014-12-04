//
//  WZSnakeHUDDisplayLink.m
//  WZSnakeHudDemo
//
//  Created by Wongzigii on 11/19/14.
//  Copyright (c) 2014 Wongzigii. All rights reserved.
//

#import "WZSnakeHUDDisplayLink.h"

@interface WZSnakeHUDDisplayLink()

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) BOOL nextDeltaTimeZero;
@property (nonatomic, assign) CFTimeInterval previousTimestamp;

@end

@implementation WZSnakeHUDDisplayLink

- (void)removeDisplayLink
{
    //remove displaylink
    [self.displayLink invalidate];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)setUpDisplayLink
{
    //setup displayLink
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkUpdate)];
    
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActiveNotification) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)applicationDidBecomeActiveNotification
{
    self.displayLink.paused = NO;
    self.nextDeltaTimeZero = YES;
}

- (void)applicationWillResignActiveNotification
{
    self.displayLink.paused = YES;
    self.nextDeltaTimeZero = YES;
}

/**
 *
 *This method creates the selector that we told the CADisplayDelegate call */
- (void)displayLinkUpdate
{
    //calculate the frame time difference by subtracting the current time from the previous time
    CFTimeInterval currentTime = self.displayLink.timestamp;
    CFTimeInterval deltaTime;
    if (self.nextDeltaTimeZero) {
        self.nextDeltaTimeZero = NO;
        deltaTime = 0.0;
    }
    else{
        deltaTime = currentTime - self.previousTimestamp;
    }
    self.previousTimestamp = currentTime;
    
    [self.delegate displayWillUpdateWithDeltaTime:deltaTime];
}

- (id)initWithDelegate:(id <WZSnakeDisplayLinkDelegate> )delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.nextDeltaTimeZero = YES;
        self.previousTimestamp = 0;
        [self setUpDisplayLink];
    }
    return self;
}

@end
