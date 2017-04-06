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
#import "MSGONExampleDelegate.h"

@interface MSGONRequestExamples : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

+ (BOOL) isStringEmpty:(NSString *)string;

- (id)init;

+ (NSString*)clientId;

// Initialize the class with a delegate for state changes
- (id)initWithDelegate:(id<MSGONExampleDelegate>)newDelegate;
//
// Five samples of OneNote Graph API requests
- (void)getNotebooks;
- (void)getNotebooksWithSections;
- (void)getPages;
- (void)getSections;
- (void)createPage;

@property id<MSGONExampleDelegate> delegate;

@end
