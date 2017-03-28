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

#import "MSGONAuthDelegate.h"
#import "MSGONAuthUtils.h"
#import "MSGONConstants.h"
#import "MSGONSession.h"

@implementation MSGONAuthUtils {
    MSGONSession *session;
}

- (id) initWithClientId:(NSString *)clientId
               delegate:(id<MSGONAuthDelegate>)delegate
{
    return [self initWithClientId:clientId
                        scopes:nil
                        delegate:delegate];
}


- (id) initWithClientId:(NSString *)clientId
                 scopes:(NSArray *)scopes
               delegate:(id<MSGONAuthDelegate>)delegate
{
    return [self initWithClientId:clientId
                           scopes:scopes
                         delegate:delegate
                        userState:nil];
}

- (id) initWithClientId:(NSString *)clientId
                 scopes:(NSArray *)scopes
               delegate:(id<MSGONAuthDelegate>)delegate
              userState:(id)userState
{
    if ([clientId length] == 0)
    {
        [NSException raise:NSInvalidArgumentException format:LIVE_ERROR_DESC_MISSING_PARAMETER, @"clientId", @"initWithClientId:redirectUri:scopes:delegate:userState"];
    }
    
    if (session)
    {
        // We already initialized, so silently ignore it.
        return self;
    }
    
    self = [super init];
    if (self)
    {
        session = [[MSGONSession alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [_liveClientCore release];
    
    [super dealloc];
}

#pragma mark Parameter validation

- (void) validateInit
{
    if (_liveClientCore == nil ||
        _liveClientCore.clientId == nil)
    {
        [NSException raise:LIVE_EXCEPTION format:LIVE_ERROR_DESC_MUST_INIT];
    }
}

- (void) validateRequiredParam:(id)value
                     paramName:(NSString *)name
                    methodName:(NSString *)methodName
{
    if (value == nil)
    {
        [NSException raise:NSInvalidArgumentException
                    format:LIVE_ERROR_DESC_MISSING_PARAMETER, name, methodName];
    }
}

- (void) validateRequiredDictionaryParam:(NSDictionary *)value
                               paramName:(NSString *)name
                              methodName:(NSString *)methodName
{
    if (value == nil || value.count == 0)
    {
        [NSException raise:NSInvalidArgumentException
                    format:LIVE_ERROR_DESC_MISSING_PARAMETER, name, methodName];
    }
}

- (void) validateStringParam:(NSString *)value
                   paramName:(NSString *)name
                  methodName:(NSString *)methodName
{
    if ([value length] == 0)
    {
        [NSException raise:NSInvalidArgumentException
                    format:LIVE_ERROR_DESC_MISSING_PARAMETER, name, methodName];
    }
}

- (void) validatePath:(NSString *)path
           methodName:(NSString *)methodName
             relative:(BOOL)relative
{
    [self validateStringParam:path paramName:@"path" methodName:methodName];
    if (relative && [UrlHelper isFullUrl:path])
    {
        [NSException raise:NSInvalidArgumentException
                    format:LIVE_ERROR_DESC_REQUIRE_RELATIVE_PATH, methodName];
    }
}

- (void) validateCopyMoveDestination:(NSString *)destination
                          methodName:(NSString *)methodName
{
    [self validateStringParam:destination paramName:@"destination" methodName:methodName];
}

#pragma mark Auth members

- (MSGONSession *) session
{
    [self validateInit];
    return session;
}

- (void) login:(UIViewController *) currentViewController
      delegate:(id<MSGONAuthDelegate>) delegate
{
    [self login:currentViewController delegate:delegate userState:nil];
}

- (void) login:(UIViewController *) currentViewController
      delegate:(id<MSGONAuthDelegate>) delegate
     userState:(id) userState
{
    [self login:currentViewController scopes:nil delegate:delegate userState:userState];
}

- (void) login:(UIViewController *) currentViewController
        scopes:(NSArray *) scopes
      delegate:(id<MSGONAuthDelegate>) delegate
{
    [self login:currentViewController scopes:scopes delegate:delegate userState:nil];
}

- (void) login:(UIViewController *) currentViewController
        scopes:(NSArray *) scopes
      delegate:(id<MSGONAuthDelegate>) delegate
     userState:(id) userState
{
    [self validateInit];
    
    if (_liveClientCore.hasPendingUIRequest)
    {
        [NSException raise:LIVE_EXCEPTION format:LIVE_ERROR_DESC_PENDING_LOGIN_EXIST];
    }
    
    if (currentViewController == nil)
    {
        [NSException raise:NSInvalidArgumentException
                    format:LIVE_ERROR_DESC_MISSING_PARAMETER, @"currentViewController", @"login:scopes:delegate:userState:"];
    }
    
    scopes = [LiveAuthHelper normalizeScopes:scopes];
    if (scopes.count == 0)
    {
        // scopes is not provided, then use the default scopes.
        scopes = _liveClientCore.scopes;
        if (scopes.count == 0)
        {
            // Neither init nor login has scopes, raise error.
            [NSException raise:NSInvalidArgumentException
                        format:LIVE_ERROR_DESC_MISSING_PARAMETER, @"scopes", @"login:scopes:delegate:userState:"];
        }
    }
    
    [_liveClientCore login:currentViewController
                    scopes:scopes
                  delegate:delegate
                 userState:userState];
}

- (void) logout
{
    [self logoutWithDelegate:nil
                   userState:nil];
}

- (void) logoutWithDelegate:(id<LiveAuthDelegate>)delegate
                  userState:(id)userState
{
    [self validateInit];
    
    [_liveClientCore logoutWithDelegate:delegate
                              userState:userState];
}

@end
