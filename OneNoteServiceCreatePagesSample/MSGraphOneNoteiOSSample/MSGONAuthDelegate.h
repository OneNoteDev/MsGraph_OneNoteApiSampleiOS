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
#import "MSGONSession.h"
#import "MSGONSessionStatus.h"

// LiveAuthDelegate represents the protocol capturing authentication related callback handling
// methods, which includes methods to be invoked when an authentication process is completed
// or failed.
// A delegate that implements the protocol should be passed in as parameter when an app invokes
// init*, login* and logout* methods on an instance of LiveConnectClient class.
@protocol MSGONAuthDelegate <NSObject>

// This is invoked when the original method call is considered successful.
- (void) authCompleted: (MSGONSessionStatus) status
               session: (MSGONSession *) session;

@optional
// This is invoked when the original method call fails.
- (void) authFailed: (NSError *) error;

@end
