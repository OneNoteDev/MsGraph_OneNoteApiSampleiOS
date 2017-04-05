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
#import "ONSCPSExampleDelegate.h"
#import "ONSCPSStandardResponse.h"

@interface ONSCPSCreateExamples : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

+ (NSString *)clientId;

+ (BOOL) isStringEmpty:(NSString *)string;

- (id)init;

// Initialize the class with a delegate for state changes
- (id)initWithDelegate:(id<ONSCPSExampleDelegate>)newDelegate;
//
// Five samples of creating pages
- (void)getNotebooks;
- (void)getPages;
- (void)getSections;
- (void)createPage;

//- (void)createSimplePage:(NSString *)sectionName;

@property id<ONSCPSExampleDelegate> delegate;

@end
