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
#import "MSGONSession.h"
#import "ONSCPSCreateExamples.h"
#import "MSGONConstants.h"

@implementation MSGONSession 

NSInteger expires = 300;

// Singleton
+ (id)authSession {
    static MSGONSession *sharedSession = nil;
    if (!sharedSession) {
        sharedSession = [[MSGONSession alloc] init];
    }
    return sharedSession;
}

#pragma mark - init
- (void)initWithAuthority:(NSString *)authority
                 clientId:(NSString *)clientId
              redirectURI:(NSString *)redirectURI
               resourceID:(NSString *)resourceID
               completion:(void (^)(ADAuthenticationError *error))completion {
    ADAuthenticationError *error;
    _context = [ADAuthenticationContext authenticationContextWithAuthority:authority error:&error];
    
    if(error){
        // Log error
        completion(error);
    }
    else{
        self.authority = authority;
        
        completion(nil);
    }
}

#pragma mark - acquire token
- (void)acquireAuthTokenCompletion:(void (^)(ADAuthenticationError *error))completion {
    [self acquireAuthTokenWithResource:resourceId
                              clientID:clientId
                           redirectURI: [NSURL URLWithString:redirectUri]
                            completion:^(ADAuthenticationError *error) {
                                completion(error);}];
}

- (void)acquireAuthTokenWithResource:(NSString *)resourceID
                            clientID:(NSString *)clientID
                         redirectURI:(NSURL*)redirectURI
                          completion:(void (^)(ADAuthenticationError *error))completion {
    [self.context acquireTokenWithResource:resourceID
                                  clientId:clientID
                               redirectUri:redirectURI
                           completionBlock:^(ADAuthenticationResult *result) {
                               if (result.status !=AD_SUCCEEDED){
                                   completion(result.error);
                               }
                               
                               else{
                                   self.accessToken = result.accessToken;
                                   self.refreshToken = result.tokenCacheItem.refreshToken;
                                   self.userId = result.tokenCacheItem.userInformation.userId;
                                   completion(nil);
                               }
                           }];
}

#pragma mark - Refresh token
- (void) checkAndRefreshTokenWithCompletion:(void (^)(ADAuthenticationError *error))completion{
    if(self.refreshToken) {
        NSDate *nowWithBuffer = [NSDate dateWithTimeIntervalSinceNow:expires];
        NSComparisonResult result = [self.expiresDate compare:nowWithBuffer];
        if (result == NSOrderedSame || result == NSOrderedAscending) {
            [self.context acquireTokenSilentWithResource:resourceId
                                                clientId:clientId
                                            redirectUri:[NSURL URLWithString:redirectUri]
                                          completionBlock:^(ADAuthenticationResult *result) {
                                         if(AD_SUCCEEDED == result.status){
                                             completion(nil);
                                         }
                                         else{
                                             completion(result.error);
                                         }
                                     }];
            return;
        }
    }
    completion(nil);
}

#pragma mark - clear credentials
//Clears the ADAL token cache and the cookie cache.
- (void)clearCredentials{
    
    // Remove all the cookies from this application's sandbox. The authorization code is stored in the
    // cookies and ADAL will try to get to access tokens based on auth code in the cookie.
    NSHTTPCookieStorage *cookieStore = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in cookieStore.cookies) {
        [cookieStore deleteCookie:cookie];
    }
    
//    [ADKeychainTokenCache alloc];
}



@end
