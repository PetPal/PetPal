//
//  TwilioChatClient.h
//  Twilio Chat Client
//
//  Copyright (c) 2017 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TCHConstants.h"
#import "TCHError.h"
#import "TCHChannels.h"
#import "TCHChannel.h"
#import "TCHChannelPaginator.h"
#import "TCHChannelDescriptor.h"
#import "TCHChannelDescriptorPaginator.h"
#import "TCHMessages.h"
#import "TCHMessage.h"
#import "TCHMember.h"
#import "TCHMemberPaginator.h"
#import "TCHUserInfo.h"

@class TwilioChatClientProperties;
@protocol TwilioChatClientDelegate;

/** Represents a chat client connection to Twilio. */
@interface TwilioChatClient : NSObject

/** Messaging client delegate */
@property (nonatomic, weak) id<TwilioChatClientDelegate> delegate;

/** The info for the logged in user in the chat system. */
@property (nonatomic, strong, readonly) TCHUserInfo *userInfo;

/** The client's current connection state. */
@property (nonatomic, assign, readonly) TCHClientConnectionState connectionState;

/** The current client synchronization state. */
@property (nonatomic, assign, readonly) TCHClientSynchronizationStatus synchronizationStatus;

/** Sets the logging level for the client. 
 
 @param logLevel The new log level.
 */
+ (void)setLogLevel:(TCHLogLevel)logLevel;

/** The logging level for the client. 
 
 @return The log level.
 */
+ (TCHLogLevel)logLevel;

/** Initialize a new chat client instance.
 
 @param token The client access token to use when communicating with Twilio.
 @param properties The properties to initialize the client with, if this is nil defaults will be used.
 @param delegate Delegate conforming to TwilioChatClientDelegate for chat client lifecycle notifications.
 
 @return New chat client instance.
 */
+ (TwilioChatClient *)chatClientWithToken:(NSString *)token
                               properties:(TwilioChatClientProperties *)properties
                                 delegate:(id<TwilioChatClientDelegate>)delegate;

/** Returns the version of the SDK
 
 @return The chat client version.
 */
- (NSString *)version;

/** Updates the access token currently being used by the client.
 
 @param token The updated client access token to use when communicating with Twilio.
 */
- (void)updateToken:(NSString *)token;

/** List of channels available to the current user.
 
 This will be nil until the client is fully initialized, see the client delegate callback `chatClient:synchronizationStatusChanged:`
 
 @return The channelsList object.
 */
- (TCHChannels *)channelsList;

/** Register APNS token for push notification updates.
 
 @param token The APNS token which usually comes from `didRegisterForRemoteNotificationsWithDeviceToken`.
 */
- (void)registerWithToken:(NSData *)token;

/** De-register from push notification updates.
 
 @param token The APNS token which usually comes from `didRegisterForRemoteNotificationsWithDeviceToken`.
 */
- (void)deregisterWithToken:(NSData *)token;

/** Queue the incoming notification with the messaging library for processing - notifications usually arrive from `didReceiveRemoteNotification`.
 
 @param notification The incomming notification.
 */
- (void)handleNotification:(NSDictionary *)notification;

/** Indicates whether reachability is enabled for this instance.
 
 @return YES if reachability is enabled.
 */
- (BOOL)isReachabilityEnabled;

/** Cleanly shut down the messaging subsystem when you are done with it. */
- (void)shutdown;

@end

#pragma mark -

/** Optional chat client initialization properties. */
@interface TwilioChatClientProperties : NSObject

/** The synchronization strategy to use during client initialization.  Default: `TCHClientSynchronizationStrategyChannelsList`
 @see TCHClientSynchronizationStrategy */
@property (nonatomic, assign) TCHClientSynchronizationStrategy synchronizationStrategy;

/** The number of most recent messages to fetch automatically when synchronizing a channel.  Default: 100 */
@property (nonatomic, assign) uint initialMessageCount;

@property (nonatomic, copy) NSString *region;

@end

#pragma mark -

/** This protocol declares the chat client delegate methods. */
@protocol TwilioChatClientDelegate <NSObject>
@optional

/** Called when the client connection state changes.
 
 @param client The chat client.
 @param state The current connection state of the client.
 */
- (void)chatClient:(TwilioChatClient *)client connectionStateChanged:(TCHClientConnectionState)state;

/** Called when the client synchronization state changes during startup.
 
 @param client The chat client.
 @param status The current synchronization status of the client.
 */
- (void)chatClient:(TwilioChatClient *)client synchronizationStatusChanged:(TCHClientSynchronizationStatus)status;

/** Called when the current user has a channel added to their channel list.
 
 @param client The chat client.
 @param channel The channel.
 */
- (void)chatClient:(TwilioChatClient *)client channelAdded:(TCHChannel *)channel;

/** Called when one of the current users channels is changed.
 
 @param client The chat client.
 @param channel The channel.
 */
- (void)chatClient:(TwilioChatClient *)client channelChanged:(TCHChannel *)channel;

/** Called when one of the current users channels is deleted.
 
 @param client The chat client.
 @param channel The channel.
 */
- (void)chatClient:(TwilioChatClient *)client channelDeleted:(TCHChannel *)channel;

/** Called when a channel the current the client is aware of changes synchronization state.
 
 @param client The chat client.
 @param channel The channel.
 @param status The current synchronization status of the channel.
 */
- (void)chatClient:(TwilioChatClient *)client channel:(TCHChannel *)channel synchronizationStatusChanged:(TCHChannelSynchronizationStatus)status;

/** Called when a channel the current user is subscribed to has a new member join.
 
 @param client The chat client.
 @param channel The channel.
 @param member The member.
 */
- (void)chatClient:(TwilioChatClient *)client channel:(TCHChannel *)channel memberJoined:(TCHMember *)member;

/** Called when a channel the current user is subscribed to has a member modified.
 
 @param client The chat client.
 @param channel The channel.
 @param member The member.
 */
- (void)chatClient:(TwilioChatClient *)client channel:(TCHChannel *)channel memberChanged:(TCHMember *)member;

/** Called when a channel the current user is subscribed to has a member leave.
 
 @param client The chat client.
 @param channel The channel.
 @param member The member.
 */
- (void)chatClient:(TwilioChatClient *)client channel:(TCHChannel *)channel memberLeft:(TCHMember *)member;

/** Called when a channel the current user is subscribed to receives a new message.
 
 @param client The chat client.
 @param channel The channel.
 @param message The message.
 */
- (void)chatClient:(TwilioChatClient *)client channel:(TCHChannel *)channel messageAdded:(TCHMessage *)message;

/** Called when a message on a channel the current user is subscribed to is modified.
 
 @param client The chat client.
 @param channel The channel.
 @param message The message.
 */
- (void)chatClient:(TwilioChatClient *)client channel:(TCHChannel *)channel messageChanged:(TCHMessage *)message;

/** Called when a message on a channel the current user is subscribed to is deleted.
 
 @param client The chat client.
 @param channel The channel.
 @param message The message.
 */
- (void)chatClient:(TwilioChatClient *)client channel:(TCHChannel *)channel messageDeleted:(TCHMessage *)message;

/** Called when an error occurs.
 
 @param client The chat client.
 @param error The error.
 */
- (void)chatClient:(TwilioChatClient *)client errorReceived:(TCHError *)error;

/** Called when a member of a channel starts typing.
 
 @param client The chat client.
 @param channel The channel.
 @param member The member.
 */
- (void)chatClient:(TwilioChatClient *)client typingStartedOnChannel:(TCHChannel *)channel member:(TCHMember *)member;

/** Called when a member of a channel ends typing.
 
 @param client The chat client.
 @param channel The channel.
 @param member The member.
 */
- (void)chatClient:(TwilioChatClient *)client typingEndedOnChannel:(TCHChannel *)channel member:(TCHMember *)member;

/** Called when you are successfully registered for push notifications. 
 
 @param client The chat client.
 */
- (void)chatClientToastSubscribed:(TwilioChatClient *)client;

/** Called as a result of TwilioChatClient's handleNotification: method being invoked.  `handleNotification:` parses the push payload and extracts the channel and message for the push notification then calls this delegate method.
 
 @param client The chat client.
 @param channel The channel for the push notification.
 @param message The message for the push notification.
 */
- (void)chatClient:(TwilioChatClient *)client toastReceivedOnChannel:(TCHChannel *)channel message:(TCHMessage *)message;

/** Called when registering for push notifications fails.
 
 @param client The chat client.
 @param error An error indicating the failure.
 */
- (void)chatClient:(TwilioChatClient *)client toastRegistrationFailedWithError:(TCHError *)error;

/** Called when a processed push notification has changed the application's badge count.  You should call:
 
    [[UIApplication currentApplication] setApplicationIconBadgeNumber:badgeCount]
 
 To ensure your application's badge updates when the application is in the foreground if Twilio is managing your badge counts.  You may disregard this delegate callback otherwise.
 
 @param client The chat client.
 @param badgeCount The updated badge count.
 */
- (void)chatClient:(TwilioChatClient *)client notificationUpdatedBadgeCount:(NSUInteger)badgeCount;

/** Called when the current user's or that of any subscribed channel member's userInfo is updated.
 
 @param client The chat client.
 @param userInfo The userInfo object for changed local user or channel member.
 @param updated Indicates what portion of the object changed.
 */
- (void)chatClient:(TwilioChatClient *)client userInfo:(TCHUserInfo *)userInfo updated:(TCHUserInfoUpdate)updated;

@end
