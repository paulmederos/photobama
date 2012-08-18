//
//  Constants.h
//  PhotObama2
//
//  Created by Paul Mederos Jr on 8/18/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//


#pragma mark - NSUserDefaults
extern NSString *const kUserDefaultsActivityFeedViewControllerLastRefreshKey;
extern NSString *const kUserDefaultsCacheFacebookFriendsKey;

#pragma mark - Launch URLs

extern NSString *const kLaunchURLHostTakePicture;


#pragma mark - NSNotification
extern NSString *const AppDelegateApplicationDidReceiveRemoteNotification;
extern NSString *const UtilityUserFollowingChangedNotification;
extern NSString *const UtilityUserLikedUnlikedPhotoCallbackFinishedNotification;
extern NSString *const UtilityDidFinishProcessingProfilePictureNotification;
extern NSString *const TabBarControllerDidFinishEditingPhotoNotification;
extern NSString *const TabBarControllerDidFinishImageFileUploadNotification;
extern NSString *const PhotoDetailsViewControllerUserDeletedPhotoNotification;
extern NSString *const PhotoDetailsViewControllerUserLikedUnlikedPhotoNotification;
extern NSString *const PhotoDetailsViewControllerUserCommentedOnPhotoNotification;


#pragma mark - User Info Keys
extern NSString *const PhotoDetailsViewControllerUserLikedUnlikedPhotoNotificationUserInfoLikedKey;
extern NSString *const kEditPhotoViewControllerUserInfoCommentKey;


#pragma mark - Installation Class

// Field keys
extern NSString *const kInstallationUserKey;
extern NSString *const kInstallationChannelsKey;


#pragma mark - PFObject Activity Class
// Class key
extern NSString *const kActivityClassKey;

// Field keys
extern NSString *const kActivityTypeKey;
extern NSString *const kActivityFromUserKey;
extern NSString *const kActivityToUserKey;
extern NSString *const kActivityContentKey;
extern NSString *const kActivityPhotoKey;

// Type values
extern NSString *const kActivityTypeLike;
extern NSString *const kActivityTypeFollow;
extern NSString *const kActivityTypeComment;
extern NSString *const kActivityTypeJoined;


#pragma mark - PFObject User Class
// Field keys
extern NSString *const kUserDisplayNameKey;
extern NSString *const kUserFacebookIDKey;
extern NSString *const kUserPhotoIDKey;
extern NSString *const kUserProfilePicSmallKey;
extern NSString *const kUserProfilePicMediumKey;
extern NSString *const kUserAlreadyAutoFollowedFacebookFriendsKey;
extern NSString *const kUserPrivateChannelKey;


#pragma mark - PFObject Photo Class
// Class key
extern NSString *const kPhotoClassKey;

// Field keys
extern NSString *const kPhotoPictureKey;
extern NSString *const kPhotoThumbnailKey;
extern NSString *const kPhotoUserKey;


#pragma mark - Cached Photo Attributes
// keys
extern NSString *const kPhotoAttributesIsLikedByCurrentUserKey;
extern NSString *const kPhotoAttributesLikeCountKey;
extern NSString *const kPhotoAttributesLikersKey;
extern NSString *const kPhotoAttributesCommentCountKey;
extern NSString *const kPhotoAttributesCommentersKey;


#pragma mark - Cached User Attributes
// keys
extern NSString *const kUserAttributesPhotoCountKey;
extern NSString *const kUserAttributesIsFollowedByCurrentUserKey;


#pragma mark - PFPush Notification Payload Keys

extern NSString *const kAPNSAlertKey;
extern NSString *const kAPNSBadgeKey;
extern NSString *const kAPNSSoundKey;

extern NSString *const kPushPayloadPayloadTypeKey;
extern NSString *const kPushPayloadPayloadTypeActivityKey;

extern NSString *const kPushPayloadActivityTypeKey;
extern NSString *const kPushPayloadActivityLikeKey;
extern NSString *const kPushPayloadActivityCommentKey;
extern NSString *const kPushPayloadActivityFollowKey;

extern NSString *const kPushPayloadFromUserObjectIdKey;
extern NSString *const kPushPayloadToUserObjectIdKey;
extern NSString *const kPushPayloadPhotoObjectIdKey;