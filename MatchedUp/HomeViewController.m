//
//  HomeViewController.m
//  MatchedUp
//
//  Created by Tom Pullen on 19/01/2015.
//  Copyright (c) 2015 Tom Pullen. All rights reserved.
//

#import "HomeViewController.h"
#import "TestUser.h"
#import "ProfileViewController.h"

@interface HomeViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *chatBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *settingsBarButtonItem;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *tagLineLabel;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UIButton *dislikeButton;

@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) PFObject *photo;
@property (strong, nonatomic) NSMutableArray *activities;

@property (nonatomic) int currentPhotoIndex;
@property (nonatomic) BOOL isLikedByCurrentUser;
@property (nonatomic) BOOL isDislikedByCurrentUser;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[TestUser saveTestUserToParse];
    
    self.likeButton.enabled = NO;
    self.dislikeButton.enabled = NO;
    self.infoButton.enabled = NO;
    
    self.currentPhotoIndex = 0;
    
    PFQuery *query = [PFQuery queryWithClassName:kPhotoClassKey];
    [query whereKey:kPhotoUserKey notEqualTo:[PFUser currentUser]];
    [query includeKey:kPhotoUserKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.photos = objects;
            [self queryForCurrentPhotoIndex];
            [self updateView];
        }
        else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"homeToProfileSegue"]) {
        ProfileViewController *profileVC = segue.destinationViewController;
        profileVC.photo = self.photo;
    }
}

#pragma mark - IBActions

- (IBAction)chatBarButtonItemPressed:(UIBarButtonItem *)sender {
}

- (IBAction)settingsBarButtonItemPressed:(UIBarButtonItem *)sender {
}

- (IBAction)likeButtonPressed:(UIButton *)sender {
    [self checkLike];
}

- (IBAction)dislikeButtonPressed:(UIButton *)sender {
    [self checkDislike];
}

- (IBAction)infoButtonPressed:(UIButton *)sender {
    [self performSegueWithIdentifier:@"homeToProfileSegue" sender:nil];
}

#pragma mark - Helper Methods

- (void)queryForCurrentPhotoIndex {
    if ([self.photos count] > 0) {
        self.photo = self.photos[self.currentPhotoIndex];
        PFFile *file = self.photo[kPhotoPictureKey];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                self.photoImageView.image = image;
            }
            else NSLog(@"%@", error);
        }];
    }
    
    PFQuery *queryForLike = [PFQuery queryWithClassName:kActivityClassKey];
    [queryForLike whereKey:kActivityTypeKey equalTo:kActivityTypeLikeKey];
    [queryForLike whereKey:kActivityPhotoKey equalTo:self.photo];
    [queryForLike whereKey:kActivityFromUserKey equalTo:[PFUser currentUser]];
    
    PFQuery *queryForDislike = [PFQuery queryWithClassName:kActivityClassKey];
    [queryForDislike whereKey:kActivityTypeKey equalTo:kActivityTypeDislikeKey];
    [queryForLike whereKey:kActivityPhotoKey equalTo:self.photo];
    [queryForDislike whereKey:kActivityFromUserKey equalTo:[PFUser currentUser]];
    
    PFQuery *likeAndDislike = [PFQuery orQueryWithSubqueries:@[queryForLike, queryForDislike]];
    [likeAndDislike findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.activities = [objects mutableCopy];
            
            if ([self.activities count] == 0) {
                self.isLikedByCurrentUser = NO;
                self.isDislikedByCurrentUser = NO;
            }
            else {
                PFObject *activity = self.activities[0];
                
                if ([activity[kActivityTypeKey] isEqualToString:kActivityTypeLikeKey]) {
                    self.isLikedByCurrentUser = YES;
                    self.isDislikedByCurrentUser = NO;
                }
                else if ([activity[kActivityTypeKey] isEqualToString:kActivityTypeDislikeKey]) {
                    self.isLikedByCurrentUser = NO;
                    self.isDislikedByCurrentUser = YES;
                    
                }
                else {
                    //Some other type of activity
                }
            }
            
            self.likeButton.enabled = YES;
            self.dislikeButton.enabled = YES;
            self.infoButton.enabled = YES;
        }
    }];
    
}

- (void)updateView {
    self.firstNameLabel.text = self.photo[kPhotoUserKey][kUserProfileKey][kUserProfileFirstNameKey];
    self.ageLabel.text = [NSString stringWithFormat:@"%@", self.photo[kPhotoUserKey][kUserProfileKey][kUserProfileAgeKey]];
    self.tagLineLabel.text = self.photo[kPhotoUserKey][kUserTagLineKey];
}

- (void)setupNextPhoto {
    if (self.currentPhotoIndex + 1 < self.photos.count) {
        self.currentPhotoIndex++;
        [self queryForCurrentPhotoIndex];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No more users to view" message:@"Check back later for more people" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)saveLike {
    PFObject *likeActivity = [PFObject objectWithClassName:kActivityClassKey];
    [likeActivity setObject:kActivityTypeLikeKey forKey:kActivityTypeKey];
    [likeActivity setObject:[PFUser currentUser] forKey:kActivityFromUserKey];
    [likeActivity setObject:[self.photo objectForKey:kPhotoUserKey] forKey:kActivityToUserKey];
    [likeActivity setObject:self.photo forKey:kActivityPhotoKey];
    [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.isLikedByCurrentUser = YES;
        self.isDislikedByCurrentUser = NO;
        [self.activities addObject:likeActivity];
        [self checkForPhotoUserLikes];
        [self setupNextPhoto];
    }];
}

- (void)saveDislike {
    PFObject *likeActivity = [PFObject objectWithClassName:kActivityClassKey];
    [likeActivity setObject:kActivityTypeDislikeKey forKey:kActivityTypeKey];
    [likeActivity setObject:[PFUser currentUser] forKey:kActivityFromUserKey];
    [likeActivity setObject:[self.photo objectForKey:kPhotoUserKey] forKey:kActivityToUserKey];
    [likeActivity setObject:self.photo forKey:kActivityPhotoKey];
    [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.isLikedByCurrentUser = NO;
        self.isDislikedByCurrentUser = YES;
        [self.activities addObject:likeActivity];
        [self setupNextPhoto];
    }];
}

- (void)checkLike {
    if (self.isLikedByCurrentUser) {
        [self setupNextPhoto];
        return;
    }
    else if (self.isDislikedByCurrentUser) {
        for (PFObject *activity in self.activities) {
            [activity deleteInBackground];
        }
        [self.activities removeLastObject];
        [self saveLike];
    }
    else {
        [self saveLike];
    }
}

- (void)checkDislike {
    if (self.isDislikedByCurrentUser) {
        [self setupNextPhoto];
        return;
    }
    else if (self.isLikedByCurrentUser) {
        for (PFObject *activity in self.activities) {
            [activity deleteInBackground];
        }
        [self.activities removeLastObject];
        [self saveDislike];
    }
    else {
        [self saveDislike];
    }
}

- (void)checkForPhotoUserLikes {
    PFQuery *query = [PFQuery queryWithClassName:kActivityClassKey];
    [query whereKey:kActivityFromUserKey equalTo:self.photo[kPhotoUserKey]];
    [query whereKey:kActivityToUserKey equalTo:[PFUser currentUser]];
    [query whereKey:kActivityTypeKey equalTo:kActivityTypeLikeKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0) {
            [self createChatRoom];
        }
    }];
}

- (void)createChatRoom {
    PFQuery *queryForChatRoom = [PFQuery queryWithClassName:@"ChatRoom"];
    [queryForChatRoom whereKey:@"user1" equalTo:[PFUser currentUser]];
    [queryForChatRoom whereKey:@"user2" equalTo:self.photo[kPhotoUserKey]];
    
    PFQuery *queryForChatRoomInverse = [PFQuery queryWithClassName:@"ChatRoom"];
    [queryForChatRoom whereKey:@"user1" equalTo:self.photo[kPhotoUserKey]];
    [queryForChatRoom whereKey:@"user2" equalTo:[PFUser currentUser]];
    
    PFQuery *combinedQuery = [PFQuery orQueryWithSubqueries:@[queryForChatRoom, queryForChatRoomInverse]];
    
    [combinedQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] == 0) {
            PFObject *chatroom = [PFObject objectWithClassName:@"ChatRoom"];
            [chatroom setObject:[PFUser currentUser] forKey:@"user1"];
            [chatroom setObject:self.photo[kPhotoUserKey] forKey:@"user2"];
            [chatroom saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [self performSegueWithIdentifier:@"homeToMatchSegue" sender:nil];
            }];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
