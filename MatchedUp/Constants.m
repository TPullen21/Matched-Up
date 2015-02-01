//
//  Constants.m
//  MatchedUp
//
//  Created by Tom Pullen on 13/01/2015.
//  Copyright (c) 2015 Tom Pullen. All rights reserved.
//

#import "Constants.h"

@implementation Constants

#pragma mark - User Profile

NSString *const kUserTagLineKey             = @"tagLine";

NSString *const kUserProfileKey             = @"profile";
NSString *const kUserProfileNameKey         = @"name";
NSString *const kUserProfileFirstNameKey    = @"firstName";
NSString *const kUserProfileLocationKey     = @"location";
NSString *const kUserProfileGenderKey       = @"gender";
NSString *const kUserProfileBirthdayKey     = @"birthday";
NSString *const kUserProfileInterestedInKey = @"interestedIn";
NSString *const kUserProfilePictureURLKey   = @"pictureURL";
NSString *const kUserProfileAgeKey          = @"age";
NSString *const kUserProfileRelationshipStatusKey = @"relationshipStatus";

#pragma mark - Photo Class

NSString *const kPhotoClassKey              = @"Photo";
NSString *const kPhotoUserKey               = @"user";
NSString *const kPhotoPictureKey            = @"image";

#pragma mark - Activity Class

NSString *const kActivityClassKey           = @"Activity";
NSString *const kActivityTypeKey            = @"type";
NSString *const kActivityFromUserKey        = @"fromUser";
NSString *const kActivityToUserKey          = @"toUser";
NSString *const kActivityPhotoKey           = @"photo";
NSString *const kActivityTypeLikeKey        = @"like";
NSString *const kActivityTypeDislikeKey     = @"dislike";

#pragma mark - Settings

NSString *const kMenEnabledKey              = @"men";
NSString *const kWomenEnabledKey            = @"women";
NSString *const kSingleEnabledKey           = @"single";
NSString *const kAgeMaxKey                  = @"ageMax";

#pragma mark - ChatRoom

NSString *const kChatRoomClassKey           = @"ChatRoom";
NSString *const kChatRoomUser1Key           = @"user1";
NSString *const kChatRoomUser2Key           = @"user2";

#pragma mark - Chat

NSString *const kChatClassKey             = @"Chat";
NSString *const kChatChatRoomKey          = @"chatroom";
NSString *const kChatFromUserKey          = @"fromUser";
NSString *const kChatToUserKey            = @"toUser";
NSString *const kChatTextKey              = @"text";

@end
