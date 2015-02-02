//
//  ProfileViewController.h
//  MatchedUp
//
//  Created by Tom Pullen on 20/01/2015.
//  Copyright (c) 2015 Tom Pullen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfileViewControllerDelegate <NSObject>

- (void)didPressLike;
- (void)didPressDislike;

@end

@interface ProfileViewController : UIViewController

@property (strong, nonatomic) PFObject *photo;
@property (weak, nonatomic) id <ProfileViewControllerDelegate> delegate;

@end
