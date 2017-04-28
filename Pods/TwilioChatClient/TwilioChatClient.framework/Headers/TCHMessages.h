//
//  TCHMessages.h
//  Twilio Chat Client
//
//  Copyright (c) 2017 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TCHConstants.h"
#import "TCHMessage.h"

/** Representation of a chat channel's message list. */
@interface TCHMessages : NSObject

/** Index of the last Message the User has consumed in this Channel. */
@property (nonatomic, copy, readonly) NSNumber *lastConsumedMessageIndex;

/** Creates a place-holder message which can be populated and sent with sendMessage:completion:

 @param body Body for new message.
 @return Place-holder TCHMessage instance
 */
- (TCHMessage *)createMessageWithBody:(NSString *)body;

/** Sends a message to the channel.
 
 @param message The message to send.
 @param completion Completion block that will specify the result of the operation.
 */
- (void)sendMessage:(TCHMessage *)message
         completion:(TCHCompletion)completion;

/** Removes the specified message from the channel.
 
 @param message The message to remove.
 @param completion Completion block that will specify the result of the operation.
 */
- (void)removeMessage:(TCHMessage *)message
           completion:(TCHCompletion)completion;

/** Fetches the most recent `count` messages.  This will return locally cached messages if they are all available or may require a load from the server.
 
 @param count The number of most recent messages to return.
 @param completion Completion block that will specify the result of the operation as well as the requested messages if successful.  If no completion block is specified, no operation will be executed.
 */
- (void)getLastMessagesWithCount:(NSUInteger)count
                      completion:(TCHMessagesCompletion)completion;

/** Fetches at most `count` messages including and prior to the specified `index`.  This will return locally cached messages if they are all available or may require a load from the server.

 @param index The starting point for the request.
 @param count The number of preceeding messages to return.
 @param completion Completion block that will specify the result of the operation as well as the requested messages if successful.  If no completion block is specified, no operation will be executed.
 */
- (void)getMessagesBefore:(NSUInteger)index
                withCount:(NSUInteger)count
               completion:(TCHMessagesCompletion)completion;

/** Fetches at most `count` messages inclulding and subsequent to the specified `index`.  This will return locally cached messages if they are all available or may require a load from the server.
 
 @param index The starting point for the request.
 @param count The number of succeeding messages to return.
 @param completion Completion block that will specify the result of the operation as well as the requested messages if successful.  If no completion block is specified, no operation will be executed.
 */
- (void)getMessagesAfter:(NSUInteger)index
               withCount:(NSUInteger)count
              completion:(TCHMessagesCompletion)completion;

/** Returns the message with the specified index.
 
 @param index The index of the message.
 @param completion Completion block that will specify the result of the operation as well as the requested message if successful.  If no completion block is specified, no operation will be executed.
 */
- (void)messageWithIndex:(NSNumber *)index
              completion:(TCHMessageCompletion)completion;

/** Returns the oldest message starting at index.  If the message at index exists, it will be returned otherwise the next oldest message that presently exists will be returned.
 
 @param index The index of the last message reported as read (may refer to a deleted message).
 @param completion Completion block that will specify the result of the operation as well as the requested message if successful.  If no completion block is specified, no operation will be executed.
 */
- (void)messageForConsumptionIndex:(NSNumber *)index
                        completion:(TCHMessageCompletion)completion;

/** Set the last consumed index for this Member and Channel.  Allows you to set any value, including smaller than the current index.
 
 @param index The new index.
 */
- (void)setLastConsumedMessageIndex:(NSNumber *)index;

/** Update the last consumed index for this Member and Channel.  Only update the index if the value specified is larger than the previous value.
 
 @param index The new index.
 */
- (void)advanceLastConsumedMessageIndex:(NSNumber *)index;

/** Update the last consumed index for this Member and Channel to the max message currently on this device.
 */
- (void)setAllMessagesConsumed;

/** Reset the last consumed index for this Member and Channel to no messages consumed.
 */
- (void)setNoMessagesConsumed;

@end
