//
//  TransistionAnimator.h
//  MatchedUp
//
//  Created by Tom Pullen on 04/02/2015.
//  Copyright (c) 2015 Tom Pullen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransistionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL presenting;

@end
