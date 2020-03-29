//
//  NotificationService.swift
//  NotificationService
//
//  Created by yagiz on 3/29/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import UserNotifications
import OneSignal

final class NotificationService: UNNotificationServiceExtension {
    
    var handler: ((UNNotificationContent) -> Void)!
    var receivedRequest: UNNotificationRequest!
    var bestAttemptContent: UNMutableNotificationContent!
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        receivedRequest = request;
        handler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            OneSignal.didReceiveNotificationExtensionRequest(self.receivedRequest, with: self.bestAttemptContent)
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = handler, let bestAttemptContent = bestAttemptContent {
            OneSignal.serviceExtensionTimeWillExpireRequest(receivedRequest, with: bestAttemptContent)
            contentHandler(bestAttemptContent)
        }
    }
    
}
