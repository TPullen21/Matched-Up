//
//  MatchViewController.m
//  MatchedUp
//
//  Created by Tom Pullen on 26/01/2015.
//  Copyright (c) 2015 Tom Pullen. All rights reserved.
//

#import "MatchViewController.h"

@interface MatchViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *matcheduserImageView;
@property (strong, nonatomic) IBOutlet UIImageView *currentUserImageView;
@property (strong, nonatomic) IBOutlet UIButton *viewChatsButton;
@property (strong, nonatomic) IBOutlet UIButton *keepSearchingButton;


@end

@implementation MatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PFQuery *query = [PFQuery queryWithClassName:kPhotoClassKey];
    [query whereKey:kPhotoUserKey equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0) {
            PFObject *photo = objects[0];
            PFFile *pictureFile = photo[kPhotoPictureKey];
            [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                self.currentUserImageView.image = [UIImage imageWithData:data];
                self.matcheduserImageView.image = self.matchedUserImage;
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)viewChatsButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];    
    
}

- (IBAction)keepSearchingButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
