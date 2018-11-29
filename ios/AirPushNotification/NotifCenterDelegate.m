/**
 * Copyright 2017 FreshPlanet
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "NotifCenterDelegate.h"
#import "AirPushNotification.h"

@interface NotifCenterDelegate()
@end

@implementation NotifCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)(void))completionHandler {
    NSDictionary * notifDict = response.notification.request.content.userInfo;
    
    if ([[AirPushNotification instance] isInitialized]) {
        // we can dispatch an event
        [[AirPushNotification instance] trackRemoteNofiticationFromApp:[UIApplication sharedApplication] andUserInfo:notifDict];
    } else {
        // wait for it to be fetched
        self.starterNotif = notifDict;
    }
    
    completionHandler();
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    if ([[AirPushNotification instance] isInitialized]) {
        [[AirPushNotification instance] trackRemoteNofiticationFromApp:[UIApplication sharedApplication] andUserInfo:notification.request.content.userInfo];
    }
    completionHandler(UNNotificationPresentationOptionNone);
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification {
    
    if ([[AirPushNotification instance] isInitialized]) {
        // we can dispatch an event
        self.pendingOpenAppNotificationSettings = false;
        [[AirPushNotification instance] sendEvent:@"OPEN_APP_NOTIFICATION_SETTINGS"];
    } else {
        // wait for ane initialized
        self.pendingOpenAppNotificationSettings = true;
    }
}

@end
