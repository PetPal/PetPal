//
//  TCHChannel.h
//  Twilio Chat Client
//
//  Copyright (c) 2017 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TCHConstants.h"

#import "TCHMessages.h"
#import "TCHMembers.h"
#import "TCHUserInfo.h"

@class TwilioChatClient;
@protocol TCHChannelDelegate;

/** Representation of a chat channel. */
@interface TCHChannel : NSObject

/** Optional channel delegate */
@property (nonatomic, weak) id<TCHChannelDelegate> delegate;

/** The unique identifier for this channel. */
@property (nonatomic, copy, readonly) NSString *sid;

/** The friendly name for this channel. */
@property (nonatomic, copy, readonly) NSString *friendlyName;

/** The unique name for this channel. */
@property (nonatomic, copy, readonly) NSString *uniqueName;

/** The messages list object for this channel. */
@property (nonatomic, strong, readonly) TCHMessages *messages;

/** The members list object for this channel. */
@property (nonatomic, strong, readonly) TCHMembers *members;

/** The channel's synchronization status. */
@property (nonatomic, assign, readonly) TCHChannelSynchronizationStatus synchronizationStatus;

/** The current user's status on this channel. */
@property (nonatomic, assign, readonly) TCHChannelStatus status;

/** The channel's visibility type. */
@property (nonatomic, assign, readonly) TCHChannelType type;

/** The timestamp the channel was created. */
@property (nonatomic, strong, readonly) NSString *dateCreated;

/** The timestamp the channel was created as an NSDate. */
@property (nonatomic, strong, readonly) NSDate *dateCreatedAsDate;

/** The identity of the channel's creator. */
@property (nonatomic, copy, readonly) NSString *createdBy;

/** The timestamp the channel was last updated. */
@property (nonatomic, strong, readonly) NSString *dateUpdated;

/** The timestamp the channel was last updated as an NSDate. */
@property (nonatomic, strong, readonly) NSDate *dateUpdatedAsDate;

/** Perform the initial synchronization for channel. 
 
 @param completion Completion block that will specify the result of the operation.
 */
- (void)synchronizeWithCompletion:(TCHCompletion)completion;

/** Return this channel's attributes.
 
 @return The developer-defined extensible attributes for this channel.
 */
- (NSDictionary<NSString *, id> *)attributes;

/** Set this channel's attributes.
 
 @param attributes The new developer-defined extensible attributes for this channel. (Supported types are NSString, NSNumber, NSArray, NSDictionary and NSNull)
 @param completion Completion block that will specify the result of the operation.
 */
- (void)setAttributes:(NSDictionary<NSString *, id> *)attributes
           completion:(TCHCompletion)completion;

/** Set this channel's friendly name.
 
 @param friendlyName The new friendly name for this channel.
 @param completion Completion block that will specify the result of the operation.
 */
- (void)setFriendlyName:(NSString *)friendlyName
             completion:(TCHCompletion)completion;

/** Set this channel's unique name.
 
 @param uniqueName The new unique name for this channel.
 @param completion Completion block that will specify the result of the operation.
 */
- (void)setUniqueName:(NSString *)uniqueName
           completion:(TCHCompletion)completion;

/** Join the current user to this channel.
 
 @param completion Completion block that will specify the result of the operation.
 */
- (void)joinWithCompletion:(TCHCompletion)completion;

/** Decline an invitation to this channel.
 
 @param completion Completion block that will specify the result of the operation.
 */
- (void)declineInvitationWithCompletion:(TCHCompletion)completion;

/** Leave the current channel.
 
 @param completion Completion block that will specify the result of the operation.
 */
- (void)leaveWithCompletion:(TCHCompletion)completion;

/** Destroy the current channel, removing all of its members.
 
 @param completion Completion block that will specify the result of the operation.
 */
- (void)destroyWithCompletion:(TCHCompletion)completion;

/** Indicates to other users and the backend that the user is typing a message to this channel. */
- (void)typing;

/** Fetch the member object for the given identity if it exists.
 
 @param identity The username to fetch.
 @return The TCHMember object, if one exists for the username for this channel.
 */
- (TCHMember *)memberWithIdentity:(NSString *)identity;

/** Fetch the number of unconsumed messages on this channel for the current user.
 
 Available even if the channel is not yet synchronized.  Subsequent calls of this
 method prior to the local cache's expiry will return cached values.
 
 @param completion Completion block that will speciy the requested count.  If no completion block is specified, no operation will be executed.
 */
- (void)getUnconsumedMessagesCountWithCompletion:(TCHCountCompletion)completion;

/** Fetch the number of messages on this channel.
 
 Available even if the channel is not yet synchronized.
 
 Available even if the channel is not yet synchronized.  Subsequent calls of this
 method prior to the local cache's expiry will return cached values.
 
 @param completion Completion block that will speciy the requested count.  If no completion block is specified, no operation will be executed.
 */
- (void)getMessagesCountWithCompletion:(TCHCountCompletion)completion;

/** Fetch the number of members on this channel.
 
 Available even if the channel is not yet synchronized.
 
 Available even if the channel is not yet synchronized.  Subsequent calls of this
 method prior to the local cache's expiry will return cached values.
 
 @param completion Completion block that will speciy the requested count.  If no completion block is specified, no operation will be executed.
 */
- (void)getMembersCountWithCompletion:(TCHCountCompletion)completion;

@end

/** This protocol declares the channel delegate methods. */
@protocol TCHChannelDelegate <NSObject>
@optional
/** Called when this channel is changed.
 
 @param client The chat client.
 @param channel The channel.
 */
- (void)chatClient:(TwilioChatClient *)client channelChanged:(TCHChannel *)channel;

/** Called when this channel is deleted.
 
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

/** Called when this channel has a new member join.
 
 @param client The chat client.
 @param channel The channel.
 @param member The member.
 */
- (void)chatClient:(TwilioChatClient *)client channel:(TCHChannel *)channel memberJoined:(TCHMember *)member;

/** Called when this channel has a member modified.
 
 @param client The chat client.
 @param channel The channel.
 @param member The member.
 */
- (void)chatClient:(TwilioChatClient *)client channel:(TCHChannel *)channel memberChanged:(TCHMember *)member;

/** Called when this channel has a member's user info updated.
 
 @param client The chat client.
 @param channel The channel.
 @param member The member.
 @param userInfo The userInfo object for changed member.
 @param updated The field updated in the user information.
 */
- (void)chatClient:(TwilioChatClient *)client channel:(TCHChannel *)channel member:(TCHMember *)member userInfo:(TCHUserInfo *)userInfo updated:(TCHUserInfoUpdate)updated;

/** Called when this channel has a member leave.
 
 @param client The chat client.
 @param channel The channel.
 @param member The member.
 */
- (void)chatClient:(TwilioChatClient *)client channel:(TCHChannel *)channel memberLeft:(TCHMember *)member;

/** Called when this channel receives a new message.
 
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

@end
