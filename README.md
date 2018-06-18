# BasicUtilityKit
# iOS Rich Push Notifications

1. Integrating Rich Push Notifications into App
  1) Add “Notification Service Extension” to your app. File -> New-> Target-> Notification Service Extension.
  2) Click Next and when asked to “Activate”, Click yes.
  3) Make Sure you have enabled “Background Mode -> Background fetch” in your apps Capabilities too.
  
###2. Implementing Rich Push Notifications into App(Objective C)###
  1) Remove all the code written in “didReceiveNotificationRequest” and “serviceExtensionTimeWillExpire” .
  2) Import BasicUtilityKit Framework into Extension
      #import <BasicUtility/BasicUtility.h>
  3) Handle Notification Request
```swift
  - (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler { 
[[BasicUtility sharedInstance] didReceiveNotificationRequest:request withAttachmentURL:"https://wallpapercave.com/wp/X0hSfWT.jpg" withContentHandler:^(UNNotificationContent *contentToDeliver) {
contentHandler(contentToDeliver); }];
}
```
4) Handle Notification Service Time Expire
```swift
- (void)serviceExtensionTimeWillExpire {
    [[BasicUtility sharedInstance] serviceExtensionTimeWillExpire]; 
}
```
    
***3. Implementing Rich Push Notifications into App(Swift)***
  1) Remove all the code written in “didReceiveNotificationRequest” and “serviceExtensionTimeWillExpire” .
  2) Import BasicUtilityKit Framework into Extension
      import BasicUtility
  3) Handle Notification Request
```swift
override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
BasicUtility.sharedInstance().didReceive(request,"https://wallpapercave.com/wp/X0hSfWT.jpg") { (contentToDeliver:UNNotificationContent) in
contentHandler(contentToDeliver) }
}
```
  4) Handle Notification Service Time Expire
```swift
override func serviceExtensionTimeWillExpire() {
    BasicUtility.sharedInstance().serviceExtensionTimeWillExpire() 
}
```
    
      

