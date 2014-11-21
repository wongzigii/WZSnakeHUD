//
//  WZSnakeHUDDisplayLink.h
//  WZSnakeHudDemo
//
//  Created by Wongzigii on 11/19/14.
//  Copyright (c) 2014 Wongzigii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//see also http://www.paulwrightapps.com/blog/2014/8/20/creating-smooth-frame-by-frame-animations-on-ios-based-on-the-time-passed-between-frames

@protocol WZSnakeDisplayLinkDelegate;

@interface WZSnakeHUDDisplayLink : NSObject

@property (nonatomic, weak) id<WZSnakeDisplayLinkDelegate> delegate;

- (id)initWithDelegate:(id <WZSnakeDisplayLinkDelegate> )delegate;
- (void)removeDisplayLink;

@end

@protocol WZSnakeDisplayLinkDelegate <NSObject>
@required
- (void)displayWillUpdateWithDeltaTime:(CFTimeInterval)deltaTime;

@end
