//
//  TCHResult.h
//  Twilio Chat Client
//
//  Copyright (c) 2017 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TCHError.h"

/** Result class passed via completion blocks.  Contains a boolean property, `isSuccessful`, which
 indicates the result of the operation and an error object if the operation failed.
 */
@interface TCHResult : NSObject

/** The result's TCHError if the operation failed. */
@property (nonatomic, strong, readonly) TCHError *error;

/** Indicates the success or failure of the given operation.
 
 @return Boolean YES if the operation was successful, NO otherwise.
 */
- (BOOL)isSuccessful;

@end
