//
//  TestUser.m
//  MatchedUp
//
//  Created by Tom Pullen on 22/01/2015.
//  Copyright (c) 2015 Tom Pullen. All rights reserved.
//

#import "TestUser.h"

@implementation TestUser

+ (void)saveTestUserToParse {
    PFUser *newUser = [PFUser user];
    newUser.username = @"user1";
    newUser.password = @"password1";
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (!error) {
            NSDictionary *profile = @{@"age" : @28, @"birthday" : @"22/11/1985", @"firstName" : @"Julie", @"gender" : @"female", @"lcoation" : @"Berlin, Germany", @"name" : @"Julie Adams" };
            [newUser setObject:profile forKey:@"profile"];
            [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                UIImage *profileImage = [UIImage imageNamed:@"person1.jpeg"];
                NSData *imageData = UIImageJPEGRepresentation(profileImage, 0.8);
                PFFile *photoFile = [PFFile fileWithData:imageData];
                [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
                    if (succeeded) {
                        PFObject *photo = [PFObject objectWithClassName:kPhotoClassKey];
                        [photo setObject:newUser forKey:kPhotoUserKey];
                        [photo setObject:photoFile forKey:kPhotoPictureKey];
                        [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            NSLog(@"Photo saved successfully");
                        }];
                    }
                }];
                
            }];
        }
        
    }];
}

@end
