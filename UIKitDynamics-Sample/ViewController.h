//
//  ViewController.h
//  UIKitDynamics-Sample
//
//  Created by taiki on 12/12/13.
//  Copyright (c) 2013 yashigani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)moveTapped:(id)sender;
- (IBAction)dropTapped:(id)sender;

@end
