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

@interface MSGONSession : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *authority;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *refreshToken;
@property NSInteger const *expires;
@property (nonatomic, strong) NSDate *expiresDate;

@property (nonatomic, strong) ADAuthenticationContext *context;

+ (id)authSession;

- (void)initWithAuthority:(NSString *)authority
                 clientId:(NSString *)clientId
              redirectURI:(NSString *)redirectURI
               resourceID: (NSString *)resourceID
               completion:(void (^)(ADAuthenticationError *error))completion;

- (void)acquireAuthTokenWithResource: (NSString*)resourceID
                            clientID:(NSString*)clientID
                         redirectURI:(NSString*)redirectURI
                          completion:(void (^)(ADAuthenticationError *error))completion;

- (void)acquireAuthTokenCompletion: (void (^)(ADAuthenticationError *error))completion;

- (void)clearCredentials;

- (void)checkAndRefreshTokenWithCompletion:(void (^)(ADAuthenticationError *error))completion;

@end
