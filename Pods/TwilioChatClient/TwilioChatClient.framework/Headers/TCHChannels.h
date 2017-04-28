//
//  TCHChannels.h
//  Twilio Chat Client
//
//  Copyright (c) 2017 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TCHConstants.h"

/** Representation of a chat channel list. */
@interface TCHChannels : NSObject

/** Retrieve a list of channels the user has a participation state on, for example invited, joined, creator.
 
 @param completion Completion block that will specify the result of the operation and a reference to the first page of user channels.  If no completion block is specified, no operation will be executed.
 */
- (void)userChannelsWithCompletion:(TCHChannelPaginatorCompletion)completion;

/** Retrieve a list of channel descriptors for publicly visible channels.
 
 @param completion Completion block that will specify the result of the operation and a reference to the first page of public channels.  If no completion block is specified, no operation will be executed.
 */
- (void)publicChannelsWithCompletion:(TCHChannelDescriptorPaginatorCompletion)completion;

/** Create a new channel with the specified options.
 
 @param options Channel options for new channel whose keys are TCHChannelOption* constants. (optional - may be empty or nil)
 @param completion Completion block that will specify the result of the operation and a reference to the new channel.
 @discussion TCHChannelOptionFriendlyName - String friendly name (optional)
 @discussion TCHChannelOptionUniqueName - String unique name (optional)
 @discussion TCHChannelOptionType - Expected values are @(TCHChannelTypePublic) or @(TCHChannelTypePrivate) (optional)
 @discussion TCHChannelOptionAttributes - Expected value is an NSDictionary<NSString*,id> *, see also TCHChannel setAttributes:completion: (optional)
 */
- (void)createChannelWithOptions:(NSDictionary *)options
                      completion:(TCHChannelCompletion)completion;

/** Obtains a channel with the specified id or unique name.
 
 @param sidOrUniqueName Identifier or unique name for the channel.
 @param completion Completion block that will specify the result of the operation and a reference to the requested channel if it exists.
 */
- (void)channelWithSidOrUniqueName:(NSString *)sidOrUniqueName
                        completion:(TCHChannelCompletion)completion;

@end
