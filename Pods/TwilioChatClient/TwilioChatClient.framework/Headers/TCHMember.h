//
//  TCHMember.h
//  Twilio Chat Client
//
//  Copyright (c) 2017 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TCHUserInfo.h"

/** Representation of a Member on a chat channel. */
@interface TCHMember : NSObject

/** The info for this member. */
@property (nonatomic, strong, readonly) TCHUserInfo *userInfo;

/** Index of the last Message the Member has consumed in this Channel. */
@property (nonatomic, copy, readonly) NSNumber *lastConsumedMessageIndex;

/** Timestamp the last consumption updated for the Member in this Channel. */
@property (nonatomic, copy, readonly) NSString *lastConsumptionTimestamp;

/** Timestamp the last consumption updated for the Member in this Channel as an NSDate. */
@property (nonatomic, strong, readonly) NSDate *lastConsumptionTimestampAsDate;

@end
