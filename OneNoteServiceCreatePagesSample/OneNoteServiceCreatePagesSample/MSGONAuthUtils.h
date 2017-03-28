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


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MSGONAuthDelegate.h"
#import "MSGONSession.h"

// MSONAuthUtils class represents a client object that helps the app to access Microsoft Graph
// resources on the user's behalf. MSONAuthUtils class provides authentication/authorization methods,
// including init* methods, login* methods and logout* methods.
@interface MSGONAuthUtils: NSObject

// The user's current session object.
@property(nonatomic, readonly) MSGONSession *session;

#pragma mark - init* methods

// init* methods are async methods used to initialize a new instance of MSONAuthUtils class.
// An instance of MSONAuthUtils class must be initialized via one of the init* methods before
// other methods can be invoked. Invoking any methods other than init* on an uninitialized instance
// will receive an exception. Invoking any init* methods on an instance of MSAuthUtils class
// that is already initialized will be silently ignored.
// The initialization process will retrieve the user authentication session using a refresh token
// persisted in the device if available.
//
// Parameters:
// - clientId: Required. The Client Id value of the app when registered on https://apps.dev.microsoft.com
// - delegate: Optional. An app class instance that implements the MSONAuthDelegate protocol.
//   Note: Only authCompleted:session:userState of the protocol method will be invoked.
// - scopes: Optional. An array of scopes value that determines the initialization scopes.
//   Note: The app may retrieve the app session during initialization process. The scopes value will be
//         passed to the Live authentication server, which will return a user session with access token
//         if the authenticated user has already consented the scopes passed in to the app. Otherwise,
//         the server will reject to send back authentication session data.
// - userState: Optional. An object that is used to track asynchronous state. The userState object will
//         be passed as userState parameter when any LiveAuthDelegate protocol method is invoked.

- (id) initWithClientId:(NSString *)clientId
               delegate:(id<MSGONAuthDelegate>)delegate;

- (id) initWithClientId:(NSString *)clientId
                 scopes:(NSArray *)scopes
               delegate:(id<MSGONAuthDelegate>)delegate;

#pragma mark - login* methods

// login* methods are async methods used to present a modal window and show login and authorization forms so
// that the user can login with his/her Microsoft account and authorize the app to access the Live services on
// the user behalf.
// If the current user session already satisfies the scopes specified in the parameter, the delegate method
// authCompleted:session:userState will be invoked right away.
// At any time, only one login* method can be invoked. If there is a pending login* process ongoing, a call to
// a login* method will receive an exception.
// Parameters:
// - currentViewController: Required. The current UIViewController that will present login UI in a modal window.
// - delegate: Optional. An app class instance that implements the LiveAuthDelegate protocol.
// - scopes: Optional. An array of scopes value for the user to authorize. If the scopes value is missing, the
//           scopes value passed in via the init* method will be used. If neither the init* method nor the login*
//           method has a scope value, the call will receive an exception.
// - userState: Optional. An object that is used to track asynchronous state. The userState object will be
//           passed as userState parameter when any LiveAuthDelegate protocol method is invoked.

- (void) login:(UIViewController *)currentViewController
      delegate:(id<MSGONAuthDelegate>)delegate;

- (void) login:(UIViewController *)currentViewController
        scopes:(NSArray *)scopes
      delegate:(id<MSGONAuthDelegate>)delegate;

#pragma mark - logout* methods

// logout* methods are async methods used to log out the user from the app.
// Parameters:
// - delegate: Optional. An app class instance that implements the LiveAuthDelegate protocol.
// - userState: Optional. An object that is used to track asynchronous state. The userState object will be
//             passed as userState parameter when any LiveAuthDelegate protocol method is invoked.

- (void) logout;

- (void) logoutWithDelegate:(id<MSGONAuthDelegate>)delegate
                  userState:(id)userState;

@end
