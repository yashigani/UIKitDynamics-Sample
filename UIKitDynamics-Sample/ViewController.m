//
//  ViewController.m
//  UIKitDynamics-Sample
//
//  Created by taiki on 12/12/13.
//  Copyright (c) 2013 yashigani. All rights reserved.
//

#import "ViewController.h"

#import "Animator.h"

@interface ViewController ()
@property Animator *animator;
@end

@implementation ViewController

- (UIView *)selectedView
{
    NSInteger index = self.segmentedControl.selectedSegmentIndex;
    UIView *v = nil;
    switch (index) {
    case 0: {
        v = [[UIView alloc] initWithFrame:CGRectMake(20, -100, 280, 100)];
        v.backgroundColor = [self.view.tintColor colorWithAlphaComponent:.8];
        break;
    }
    case 1: {
        v = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"thai_curry"]];
        break;
    }
    case 2: {
        v = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Git-Icon-1788C"]];
        break;
    }
    default:
        break;
    }

    v.layer.borderWidth = 2;
    v.layer.borderColor = self.view.tintColor.CGColor;
    v.userInteractionEnabled = YES;
    return v;
}

- (IBAction)moveTapped:(id)sender
{
    _animator.item = self.selectedView;
    [_animator moveIn];
}

- (IBAction)dropTapped:(id)sender
{
    _animator.item = self.selectedView;
    [_animator drop];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _animator = [[Animator alloc] initWithView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
