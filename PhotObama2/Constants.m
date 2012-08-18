//
//  Constants.m
//  PhotObama2
//
//  Created by Paul Mederos Jr on 8/18/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import "Constants.h"


NSString *const kUserDefaultsActivityFeedViewControllerLastRefreshKey    = @"com.parse.PhotObama2.userDefaults.activityFeedViewController.lastRefresh";
NSString *const kUserDefaultsCacheFacebookFriendsKey                     = @"com.parse.PhotObama2.userDefaults.cache.facebookFriends";


#pragma mark - Launch URLs

NSString *const kLaunchURLHostTakePicture = @"camera";


#pragma mark - NSNotification

NSString *const AppDelegateApplicationDidReceiveRemoteNotification           = @"com.parse.PhotObama2.appDelegate.applicationDidReceiveRemoteNotification";
NSString *const UtilityUserFollowingChangedNotification                      = @"com.parse.PhotObama2.utility.userFollowingChanged";
NSString *const UtilityUserLikedUnlikedPhotoCallbackFinishedNotification     = @"com.parse.PhotObama2.utility.userLikedUnlikedPhotoCallbackFinished";
NSString *const UtilityDidFinishProcessingProfilePictureNotification         = @"com.parse.PhotObama2.utility.didFinishProcessingProfilePictureNotification";
NSString *const TabBarControllerDidFinishEditingPhotoNotification            = @"com.parse.PhotObama2.tabBarController.didFinishEditingPhoto";
NSString *const TabBarControllerDidFinishImageFileUploadNotification         = @"com.parse.PhotObama2.tabBarController.didFinishImageFileUploadNotification";
NSString *const PhotoDetailsViewControllerUserDeletedPhotoNotification       = @"com.parse.PhotObama2.photoDetailsViewController.userDeletedPhoto";
NSString *const PhotoDetailsViewControllerUserLikedUnlikedPhotoNotification  = @"com.parse.PhotObama2.photoDetailsViewController.userLikedUnlikedPhotoInDetailsViewNotification";
NSString *const PhotoDetailsViewControllerUserCommentedOnPhotoNotification   = @"com.parse.PhotObama2.photoDetailsViewController.userCommentedOnPhotoInDetailsViewNotification";


#pragma mark - User Info Keys
NSString *const PhotoDetailsViewControllerUserLikedUnlikedPhotoNotificationUserInfoLikedKey = @"liked";
NSString *const kEditPhotoViewControllerUserInfoCommentKey = @"comment";

#pragma mark - Installation Class

// Field keys
NSString *const kInstallationUserKey = @"user";
NSString *const kInstallationChannelsKey = @"channels";

#pragma mark - Activity Class
// Class key
NSString *const kActivityClassKey = @"Activity";

// Field keys
NSString *const kActivityTypeKey        = @"type";
NSString *const kActivityFromUserKey    = @"fromUser";
NSString *const kActivityToUserKey      = @"toUser";
NSString *const kActivityContentKey     = @"content";
NSString *const kActivityPhotoKey       = @"photo";

// Type values
NSString *const kActivityTypeLike       = @"like";
NSString *const kActivityTypeFollow     = @"follow";
NSString *const kActivityTypeComment    = @"comment";
NSString *const kActivityTypeJoined     = @"joined";

#pragma mark - User Class
// Field keys
NSString *const kUserDisplayNameKey                          = @"displayName";
NSString *const kUserFacebookIDKey                           = @"facebookId";
NSString *const kUserPhotoIDKey                              = @"photoId";
NSString *const kUserProfilePicSmallKey                      = @"profilePictureSmall";
NSString *const kUserProfilePicMediumKey                     = @"profilePictureMedium";
NSString *const kUserAlreadyAutoFollowedFacebookFriendsKey   = @"userAlreadyAutoFollowedFacebookFriends";
NSString *const kUserPrivateChannelKey                       = @"channel";

#pragma mark - Photo Class
// Class key
NSString *const kPhotoClassKey = @"Photo";

// Field keys
NSString *const kPhotoPictureKey         = @"image";
NSString *const kPhotoThumbnailKey       = @"thumbnail";
NSString *const kPhotoUserKey            = @"user";


#pragma mark - Cached Photo Attributes
// keys
NSString *const kPhotoAttributesIsLikedByCurrentUserKey = @"isLikedByCurrentUser";
NSString *const kPhotoAttributesLikeCountKey            = @"likeCount";
NSString *const kPhotoAttributesLikersKey               = @"likers";
NSString *const kPhotoAttributesCommentCountKey         = @"commentCount";
NSString *const kPhotoAttributesCommentersKey           = @"commenters";


#pragma mark - Cached User Attributes
// keys
NSString *const kUserAttributesPhotoCountKey                 = @"photoCount";
NSString *const kUserAttributesIsFollowedByCurrentUserKey    = @"isFollowedByCurrentUser";


#pragma mark - Push Notification Payload Keys

NSString *const kAPNSAlertKey = @"alert";
NSString *const kAPNSBadgeKey = @"badge";
NSString *const kAPNSSoundKey = @"sound";

// the following keys are intentionally kept short, APNS has a maximum payload limit
NSString *const kPushPayloadPayloadTypeKey          = @"p";
NSString *const kPushPayloadPayloadTypeActivityKey  = @"a";

NSString *const kPushPayloadActivityTypeKey     = @"t";
NSString *const kPushPayloadActivityLikeKey     = @"l";
NSString *const kPushPayloadActivityCommentKey  = @"c";
NSString *const kPushPayloadActivityFollowKey   = @"f";

NSString *const kPushPayloadFromUserObjectIdKey = @"fu";
NSString *const kPushPayloadToUserObjectIdKey   = @"tu";
NSString *const kPushPayloadPhotoObjectIdKey    = @"pid";