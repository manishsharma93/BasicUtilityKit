//
//  BasicUtility.h
//  BasicUtilityKit
//
//  Created by Manish Kumar on 22/03/18.
//  Copyright © 2018 Manish Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

@interface BasicUtility : NSObject

+ (instancetype)sharedInstance;
/*
 @Method registerForPushNotifications: this method is used to register for Push Notifications
 @return - void
 */
+(void)registerForPushNotifications;
/*
 @Method getDeviceTokenString: this method is used to get device token string value
 @return - String
 */
+(NSString *)getDeviceTokenString:(NSData *)deviceToken;
/*
 @Method removeBlankSpaceValue: this method is used to remove NULL or Nil values from Stings
 @return - String
 */
+(NSString *)removeBlankSpaceValue:(id)val;

/**********************************
*****RICH PUSH NOTIFICATION METHODS*****

***********************************/
/*
 @Method didReceiveNotificationRequest: this method is used to get the Rich Push Request
 @return - void
 */
- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withAttachmentURL:(NSString *)mediaURL withContentHandler:(void (^)(UNNotificationContent *))contentHandler ;
/*
 @Method serviceExtensionTimeWillExpire: this method will be called if the service Extention Time will Expire
 @return - void
 */
- (void)serviceExtensionTimeWillExpire;

@end
