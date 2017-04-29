//
//  TCHConstants.h
//  Twilio Chat Client
//
//  Copyright (c) 2017 Twilio, Inc. All rights reserved.
//

#import "TCHResult.h"

@class TCHChannels;
@class TCHChannel;
@class TCHMessage;
@class TCHChannelPaginator;
@class TCHChannelDescriptorPaginator;
@class TCHMemberPaginator;

/** Client connection state. */
typedef NS_ENUM(NSInteger, TCHClientConnectionState) {
    TCHClientConnectionStateUnknown,        ///< Client connection state is not yet known.
    TCHClientConnectionStateDisconnected,   ///< Client is offline and no connection attempt in process.
    TCHClientConnectionStateConnected,      ///< Client is online and ready.
    TCHClientConnectionStateConnecting,     ///< Client is offline and connection attempt is in process.
    TCHClientConnectionStateDenied,         ///< Client connection is denied because of invalid token.
    TCHClientConnectionStateError           ///< Client connection is in the erroneous state.
};

/** Synchronization strategy to use during client initialization. */
typedef NS_ENUM(NSInteger, TCHClientSynchronizationStrategy) {
    TCHClientSynchronizationStrategyAll,              ///< Initialize channels list, members and messages collections for all joined channels.  Loads the number of messages per channel indicated during client initialization.
    TCHClientSynchronizationStrategyChannelsList      ///< Initialize just the channels list, no additional data on channels regardless of join state.  As channels are manually synchronized, the number of messages declared during client initialization will be loaded.
};

/** The synchronization status of the client. */
typedef NS_ENUM(NSInteger, TCHClientSynchronizationStatus) {
    TCHClientSynchronizationStatusStarted = 0,               ///< Client synchronization has started.
    TCHClientSynchronizationStatusChannelsListCompleted,     ///< Channels list is available.
    TCHClientSynchronizationStatusCompleted,                 ///< All joined channels, their members and the requested number of messages are synchronized.
    TCHClientSynchronizationStatusFailed                     ///< Synchronization failed.
};

/** Enumeration indicating the client's logging level. */
typedef NS_ENUM(NSInteger, TCHLogLevel) {
    TCHLogLevelFatal = 0,        ///< Show fatal errors only.
    TCHLogLevelCritical,         ///< Show critical log messages as well as all Fatal log messages.
    TCHLogLevelWarning,          ///< Show warnings as well as all Critical log messages.
    TCHLogLevelInfo,             ///< Show informational messages as well as all Warning log messages.
    TCHLogLevelDebug             ///< Show low-level debugging messages as well as all Info log messages.
};

/** Enumeration indicating the channel's current synchronization status with the server. */
typedef NS_ENUM(NSInteger, TCHChannelSynchronizationStatus) {
    TCHChannelSynchronizationStatusNone = 0,        ///< Channel not ready yet, local object only.
    TCHChannelSynchronizationStatusIdentifier,      ///< Channel SID is available.
    TCHChannelSynchronizationStatusMetadata,        ///< Channel SID, Friendly Name, Attributes and Unique Name are available.
    TCHChannelSynchronizationStatusAll,             ///< Channels, Members and Messages collections are ready to use.
    TCHChannelSynchronizationStatusFailed           ///< Channel synchronization failed.
};

/** Enumeration indicating the user's current status on a given channel. */
typedef NS_ENUM(NSInteger, TCHChannelStatus) {
    TCHChannelStatusInvited = 0,        ///< User is invited to the channel but not joined.
    TCHChannelStatusJoined,             ///< User is joined to the channel.
    TCHChannelStatusNotParticipating    ///< User is not participating on this channel.
};

/** Enumeration indicating the channel's visibility. */
typedef NS_ENUM(NSInteger, TCHChannelType) {
    TCHChannelTypePublic = 0,        ///< Channel is publicly visible
    TCHChannelTypePrivate            ///< Channel is private and only visible to invited members.
};

/** Enumeration indicating the updates made to the TCHUserInfo object. */
typedef NS_ENUM(NSInteger, TCHUserInfoUpdate) {
    TCHUserInfoUpdateFriendlyName = 0,        ///< The friendly name changed.
    TCHUserInfoUpdateAttributes,              ///< The attributes changed.
    TCHUserInfoUpdateReachabilityOnline,      ///< The user's online status changed.
    TCHUserInfoUpdateReachabilityNotifiable   ///< The user's notifiability status changed.
};

/** Completion block which will indicate the TCHResult of the operation. */
typedef void (^TCHCompletion)(TCHResult *result);

/** Completion block which will indicate the TCHResult of the operation and a public channels paginator. */
typedef void (^TCHChannelDescriptorPaginatorCompletion)(TCHResult *result, TCHChannelDescriptorPaginator *paginator);

/** Completion block which will indicate the TCHResult of the operation and a user channels paginator. */
typedef void (^TCHChannelPaginatorCompletion)(TCHResult *result, TCHChannelPaginator *paginator);

/** Completion block which will indicate the TCHResult of the operation and a channel members paginator. */
typedef void (^TCHMemberPaginatorCompletion)(TCHResult *result, TCHMemberPaginator *paginator);

/** Completion block which will indicate the TCHResult of the operation and a channel. */
typedef void (^TCHChannelCompletion)(TCHResult *result, TCHChannel *channel);

/** Completion block which will indicate the TCHResult of the operation and a message. */
typedef void (^TCHMessageCompletion)(TCHResult *result, TCHMessage *message);

/** Completion block which will indicate the TCHResult of the operation and a list of messages. */
typedef void (^TCHMessagesCompletion)(TCHResult *result, NSArray<TCHMessage *> *messages);

/** Completion block which will provide the requested count. */
typedef void (^TCHCountCompletion)(TCHResult *result, NSUInteger count);

/** Channel creation options key for setting friendly name. */
FOUNDATION_EXPORT NSString *const TCHChannelOptionFriendlyName;

/** Channel creation options key for setting unqiue name. */
FOUNDATION_EXPORT NSString *const TCHChannelOptionUniqueName;

/** Channel creation options key for setting type.  Expected values are @(TCHChannelTypePublic) or @(TCHChannelTypePrivate) */
FOUNDATION_EXPORT NSString *const TCHChannelOptionType;

/** Channel creation options key for setting attributes.  Expected value is an NSDictionary* */
FOUNDATION_EXPORT NSString *const TCHChannelOptionAttributes;

/** The Twilio Chat error domain used as NSError's `domain`. */
FOUNDATION_EXPORT NSString *const TCHErrorDomain;

/** The errorCode specified when an error client side occurs without another specific error code. */
FOUNDATION_EXPORT NSInteger const TCHErrorGeneric;

/** The userInfo key for the error message, if any. */
FOUNDATION_EXPORT NSString *const TCHErrorMsgKey;
