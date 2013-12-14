//
//  Animator.h
//  UIKitDynamics-Sample
//
//  Created by taiki on 12/12/13.
//  Copyright (c) 2013 yashigani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Animator : NSObject
@property UIView *item;

- (instancetype)initWithView:(UIView *)view;
- (void)drop;
- (void)moveIn;

@end
