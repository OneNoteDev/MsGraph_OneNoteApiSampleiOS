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

#import "MSGONSession.h"
#import "MSGONCreateExamples.h"

@implementation MSGONSession

- (id) init {
    if(self = [super init])
    {
        self.isSignedIn = false;
    }
    return self;
}

+ (void) getToken:(void (^)(NSString *))completionBlock {
    ADAuthenticationError *error = nil;
    authContext = [ADAuthenticationContext authenticationContextWithAuthority:@"https://login.microsoftonline.com/common"
                                                            error:&error]
    
    [authContext acquireTokenWithResource:"https://graph.windows.net"
                                clientId: ClientId
                              redirectUri: [NSURL URLWithString:redirectUri]
                          completionBlock:^(ADAuthenticationResult *result)
     {
         if (AD_SUCCEEDED != result.status) {
             // display error on screen
             [self showError: result.error.errorDetails];
         }
         else {
             completionBlock(result.accessToken);
         }
     }];
}

@end
