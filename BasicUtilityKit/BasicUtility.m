//
//  BasicUtility.m
//  BasicUtilityKit
//
//  Created by Admin on 22/03/18.
//  Copyright © 2018 Manish Kumar. All rights reserved.
//

#import "BasicUtility.h"
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface BasicUtility()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation BasicUtility

+ (instancetype)sharedInstance{
    //create singleton instance of webService class
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


+(void)registerForPushNotifications {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (@available(iOS 10.0, *)) {
            UNUserNotificationCenter *center = [UNUserNotificationCenter
                                                currentNotificationCenter];
            center.delegate = (id)self;
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound |
                                                     UNAuthorizationOptionAlert | UNAuthorizationOptionBadge)
                                  completionHandler:^(BOOL granted, NSError * _Nullable error){
                                      if(granted){
                                      }
                                      [[UIApplication sharedApplication] registerForRemoteNotifications];
                                  }];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
        
        else{
            UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
            UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                    settingsForTypes:userNotificationTypes categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
    });
}

+(NSString *)getDeviceTokenString:(NSData *)deviceToken {
    
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *deviceTokenString = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                                   ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                                   ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                                   ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    return deviceTokenString;
}

+(NSString *)removeBlankSpaceValue:(id)val
{
    if([val isKindOfClass:[NSNull class]]) {
        return @"";
    }
    if([val isEqual:@"<null>"]||[val isEqual:@"(null)"]) {
        val = @"";
    }
    NSString *strVal = [val stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([strVal length] == 0)
        return @"";
    else
        return strVal;
}

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withAttachmentURL:(NSString *)mediaURL withContentHandler:(void (^)(UNNotificationContent *))contentHandler {
    
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@",request.content.title];
    self.bestAttemptContent.body = [NSString stringWithFormat:@"%@",request.content.body];
    
    NSString *attachmentUrlString = [NSString stringWithFormat:@"%@",mediaURL];
    
    if (![attachmentUrlString isKindOfClass:[NSString class]]) {
        [self failEarly];
        return;
    }
    
    NSURL *url = [NSURL URLWithString:attachmentUrlString];
    if (!url) {
        [self failEarly];
        return;
    }
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (!data) {
        [self failEarly];
        return;
    }
    
    NSString *identifierName = [self getIdentifierName:attachmentUrlString];
    NSString *tmpSubFolderName = [[NSProcessInfo processInfo] globallyUniqueString];
    
    self.bestAttemptContent.attachments = [NSArray arrayWithObject:[self create:identifierName andData:data withOptions:nil andTmpFolderName:tmpSubFolderName]] ;
    self.contentHandler(self.bestAttemptContent);
    
}

-(void)failEarly {
    self.contentHandler(self.bestAttemptContent);
}

-(NSString *)getIdentifierName:(NSString *)fileURL
{
    NSString *identifierName = @"image.jpg";
    
    if (fileURL) {
        identifierName = [NSString stringWithFormat:@"file.%@",fileURL.lastPathComponent];
    }
    
    return identifierName;
}

-(UNNotificationAttachment *)create:(NSString *)identifier andData:(NSData *)data withOptions:(NSDictionary *)options andTmpFolderName:(NSString *)tmpSubFolderName {
    
    NSString *fileURLPath = NSTemporaryDirectory();
    NSString *tmpSubFolderURL = [fileURLPath stringByAppendingPathComponent:tmpSubFolderName];
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:tmpSubFolderURL withIntermediateDirectories:TRUE attributes:nil error:&error];
    if(!error) {
        NSString *fileURL = [tmpSubFolderURL stringByAppendingPathComponent:identifier];
        [data writeToFile:fileURL atomically:YES];
        UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:identifier URL:[NSURL fileURLWithPath:fileURL] options:options error:&error];
        return attachment;
    }
    return nil;
}

- (void)serviceExtensionTimeWillExpire {
    self.contentHandler(self.bestAttemptContent);
}



@end
