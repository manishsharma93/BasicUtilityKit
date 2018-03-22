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

+(void)registerForPushNotifications;
+(NSString *)getDeviceTokenString:(NSData *)deviceToken;
+(NSString *)removeBlankSpaceValue:(id)val;

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withAttachmentURL:(NSString *)mediaURL withContentHandler:(void (^)(UNNotificationContent *))contentHandler ;
- (void)serviceExtensionTimeWillExpire;

@end
