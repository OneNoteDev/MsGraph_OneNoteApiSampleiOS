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
#import "MSGONAppConfig.h"
#import "MSGONExampleDelegate.h"
#import "MSGONAuthSession.h"

NSTimeInterval const Expires = 300;

// Add private extension members
@interface MSGONAuthSession () {
    
    //Callback for app-defined behavior when state changes
    id<MSGONExampleDelegate> _delegate;
}


@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *authority;
@property (nonatomic, strong) NSDate *expiresDate;
@property (nonatomic, strong) NSString *refreshToken;

@property (nonatomic, strong) ADAuthenticationContext *context;

@end

@implementation MSGONAuthSession

// Singleton session
+ (MSGONAuthSession*)sharedSession {
    static MSGONAuthSession *sharedSession;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSession = [[self alloc] init];
    });
    return sharedSession;
}

#pragma mark - init
- (instancetype)init {
    if (self  = [super init]) {
        [self initWithAuthority:authority
                       clientId:clientId
                    redirectURI:redirectUri
                     resourceID:resourceId
                     completion:^(ADAuthenticationError *error) {
                         if(error){
                             // handle error
                         }
                     }];
    }
    return self;
}

#pragma mark - delegate getter and setter
// Get the delegate in use
- (id<MSGONExampleDelegate>)delegate {
    return _delegate;
}

// Update the delegate to use
- (void)setDelegate:(id<MSGONExampleDelegate>)newDelegate {
    _delegate = newDelegate;
    // Force a refresh on the new delegate with the current state
    [_delegate exampleAuthStateDidChange];
}

#pragma mark - auth
// Initialize the auth context
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
        completion(nil);
    }
}

// If signed in, clear credentials and log out. Otherwise, request access token.
- (void)authenticateUserUsingController:(UIViewController *)controller {
    if (self.accessToken != nil) {
        [self clearCredentials];
        [_delegate exampleAuthStateDidChange];
    }
    else {
        [self acquireAuthTokenCompletion:^(ADAuthenticationError *acquireTokenError) {
            if(acquireTokenError){
                [_delegate authFailed:acquireTokenError];
                [self updateAuthInfo:nil];
                return;
            }
        }];;
    }
}

- (void)updateAuthInfo:(ADAuthenticationResult *)authInfo {
    //Initialize the values for the access token, the refresh token and the amount of time in which the token expires after successful completion of authentication
    if (authInfo == nil) {
        self.accessToken = nil;
        self.refreshToken = nil;
        self.userId = nil;
        self.expiresDate = nil;
    }
    else {
        self.accessToken = authInfo.accessToken;
        self.refreshToken = authInfo.tokenCacheItem.refreshToken;
        self.expiresDate = authInfo.tokenCacheItem.expiresOn;
        self.userId = authInfo.tokenCacheItem.userInformation.userId;
        // Update our UI for the new state
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [_delegate exampleAuthStateDidChange];
        });
    }
}


#pragma mark - acquire token
- (void)acquireAuthTokenCompletion:(void (^)(ADAuthenticationError *error))completion {
    [self acquireAuthTokenWithResource:resourceId
                              clientID:clientId
                           redirectURI: [NSURL URLWithString:redirectUri]
                            completion:^(ADAuthenticationError *error) {
                                completion(error);
                            }
     ];
}

- (void)acquireAuthTokenWithResource:(NSString *)resourceID
                            clientID:(NSString *)clientID
                         redirectURI:(NSURL*)redirectURI
                          completion:(void (^)(ADAuthenticationError *error))completion {
    [self.context acquireTokenWithResource:resourceID
                                  clientId:clientID
                               redirectUri:redirectURI
                           completionBlock:^(ADAuthenticationResult *result) {
                               if (result.status != AD_SUCCEEDED){
                                   completion(result.error);
                                   [_delegate authFailed:result.error];
                                   [self updateAuthInfo:nil];
                               }
                               
                               else{
                                   [self updateAuthInfo:result];
                                   completion(nil);
                               }
                           }];
}

#pragma mark - Refresh token
- (void) checkAndRefreshTokenWithCompletion:(void (^)(ADAuthenticationError *error))completion{
    if (self.refreshToken) {
        NSDate *nowWithBuffer = [NSDate dateWithTimeIntervalSinceNow:Expires];
        NSComparisonResult result = [self.expiresDate compare:nowWithBuffer];
        if (result == NSOrderedSame || result == NSOrderedAscending) {
            [self.context acquireTokenSilentWithResource:resourceId
                                                clientId:clientId
                                            redirectUri:[NSURL URLWithString:redirectUri]
                                          completionBlock:^(ADAuthenticationResult *result) {
                                         if(AD_SUCCEEDED == result.status){
                                             completion(nil);
                                             [self updateAuthInfo:result];
                                         }
                                         else{
                                             [_delegate authFailed:result.error];
                                             completion(result.error);
                                         }
                                     }];
            return;
        }
        else {
            completion(nil);
        }
    }
    else {
        [self acquireAuthTokenCompletion:^(ADAuthenticationError *acquireTokenError) {
            if(acquireTokenError){
                [_delegate authFailed:acquireTokenError];
                [self updateAuthInfo:nil];
                return;
            }
        }];
        [_delegate exampleAuthStateDidChange];
        completion(nil);
    }
}

#pragma mark - clear credentials
//Clears the ADAL token cache and the cookie cache.
- (void)clearCredentials {
    
    // Remove all the cookies from this application's sandbox. The authorization code is stored in the
    // cookies and ADAL will try to get to access tokens based on auth code in the cookie.
    NSHTTPCookieStorage *cookieStore = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in cookieStore.cookies) {
        [cookieStore deleteCookie:cookie];
    }
    
    [[ADKeychainTokenCache new] removeAllForClientId:clientId error:nil];
    [self updateAuthInfo:nil];
}


@end
