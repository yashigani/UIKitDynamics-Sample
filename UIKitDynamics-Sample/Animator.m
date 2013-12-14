//
//  Animator.m
//  UIKitDynamics-Sample
//
//  Created by taiki on 12/12/13.
//  Copyright (c) 2013 yashigani. All rights reserved.
//

#import "Animator.h"

@interface Animator () <UICollisionBehaviorDelegate>
@property UIView *view;
@property UITapGestureRecognizer *tap;
@property UIDynamicAnimator *animator;
@property UICollisionBehavior *collisionForAppear;
@property UIAttachmentBehavior *attachment;
@property UICollisionBehavior *collisionForDisappear;
@end

@implementation Animator

- (instancetype)initWithView:(UIView *)view
{
    self = [super init];
    _view = view;
    return self;
}

- (void)prepareDrop
{
    [_animator removeAllBehaviors];
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:_view];
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
}

- (void)drop
{
    [self prepareDrop];
    _item.center = _view.center;
    _item.frame = ({
        CGRect f = _item.frame;
        f.origin.y = -CGRectGetHeight(f);
        f;
    });
    [_item addGestureRecognizer:_tap];
    [_view addSubview:_item];

    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[_item]];
    collision.collisionDelegate = self;
    collision.translatesReferenceBoundsIntoBoundaryWithInsets =
        UIEdgeInsetsMake(-(_item.frame.size.height + 10), 0, _view.center.y - _item.frame.size.height / 2, 0);
    _collisionForAppear = collision;
    [_animator addBehavior:_collisionForAppear];

    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[_item]];
    gravity.magnitude = 3;
    [_animator addBehavior:gravity];
}

- (void)remove
{
    _attachment = [[UIAttachmentBehavior alloc] initWithItem:_item
                                            offsetFromCenter:UIOffsetMake(0, _item.frame.size.height)
                                            attachedToAnchor:CGPointMake(CGRectGetMaxX(_item.frame), CGRectGetMinY(_item.frame))];
    [_animator addBehavior:_attachment];
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[_item]];
    gravity.magnitude = 3;
    [_animator addBehavior:gravity];

    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[_item]];
    collision.collisionDelegate = self;
    collision.translatesReferenceBoundsIntoBoundaryWithInsets = UIEdgeInsetsZero;
    _collisionForDisappear = collision;
    [_animator addBehavior:_collisionForDisappear];
}

- (void)prepareAnimate
{
    _animator = nil;
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
}

- (void)moveIn
{
    [self prepareAnimate];
    _item.center = _view.center;
    _item.frame = ({
        CGRect f = _item.frame;
        f.origin.y = -CGRectGetHeight(f);
        f;
    });
    [_item addGestureRecognizer:_tap];
    [_view addSubview:_item];

    __weak __typeof(self) wself = self;
    [UIView animateWithDuration:.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{ wself.item.center = wself.view.center; }
                     completion:nil];
}

- (void)moveOut
{
    __weak __typeof(self) wself = self;
    [UIView animateWithDuration:.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         UIView *v = wself.view;
                         wself.item.center = (CGPoint) {
                             v.center.x,
                             CGRectGetMaxY(v.frame) - CGRectGetHeight(wself.item.frame) / 2
                         };
                     }
                     completion:^(BOOL f) {
                         [UIView animateWithDuration:.25
                                          animations:^{ wself.item.alpha = 0; }];
                     }];
}

- (void)tapped:(id)sender
{
    if (_animator) {
        [self remove];
    }
    else {
        [self moveOut];
    }
}

#pragma mark - UICollisionBehaviorDelegate

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    if (behavior == _collisionForAppear) {
        [_animator removeAllBehaviors];
        _collisionForAppear = nil;
    }
    else if (behavior == _collisionForDisappear) {
        if (_attachment) {
            [_animator removeBehavior:_attachment];
            _attachment = nil;
        }
        else if (p.y >= CGRectGetMaxY(_view.frame) - 1) {
            __weak __typeof(self) wself = self;
            [UIView animateWithDuration:1.25
                             animations:^{ wself.item.alpha = 0; }
                             completion:^(BOOL finished) {
                                 [wself.item removeFromSuperview];
                                 [wself.animator removeAllBehaviors];
                                 wself.collisionForDisappear = nil;
                             }];
        }
    }
}

@end
