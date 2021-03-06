//*********************************************************
// Copyright (c) Microsoft Corporation
// All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the ""License"");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
//
// THIS CODE IS PROVIDED ON AN  *AS IS* BASIS, WITHOUT
// WARRANTIES OR CONDITIONS OF ANY KIND, EITHER EXPRESS
// OR IMPLIED, INCLUDING WITHOUT LIMITATION ANY IMPLIED
// WARRANTIES OR CONDITIONS OF TITLE, FITNESS FOR A PARTICULAR
// PURPOSE, MERCHANTABLITY OR NON-INFRINGEMENT.
//
// See the Apache Version 2.0 License for specific language
// governing permissions and limitations under the License.
//*********************************************************

#import <ADAL/ADAL.h>
#import <Foundation/Foundation.h>
#import "MSGONAPIResponseDelegate.h"
#import "MSGONAuthDelegate.h"

@interface MSGONAuthSession : NSObject

@property (nonatomic, copy) NSString *accessToken;

+ (instancetype)sharedSession;

- (void)setDelegatesforAPIResponse:(id<MSGONAPIResponseDelegate>)responseDelegate andAuth:(id<MSGONAuthDelegate>)authDelegate;

// Authenticate against Azure AD passing a controller to host the auth UI on.
- (void)authenticateUserUsingController:(UIViewController *)controller;

// Check access token for expiration and request a new token via the refresh token
- (void)checkAndRefreshTokenWithCompletion:(void (^)(ADAuthenticationError *error))completion;

@end
