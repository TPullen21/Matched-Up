//
//  MatchViewController.h
//  MatchedUp
//
//  Created by Tom Pullen on 26/01/2015.
//  Copyright (c) 2015 Tom Pullen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MatchViewControllerDelegate <NSObject>

- (void)presentMatchesViewController;

@end

@interface MatchViewController : UIViewController

@property (strong, nonatomic) UIImage *matchedUserImage;
@property (weak) id <MatchViewControllerDelegate> delegate;

@end
