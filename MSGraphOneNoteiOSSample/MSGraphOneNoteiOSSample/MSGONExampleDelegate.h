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
#import "MSGONStandardResponse.h"

@protocol MSGONExampleDelegate <NSObject, NSURLSessionTaskDelegate, NSURLSessionDelegate, NSURLSessionDataDelegate>

@optional
// Auth state has changed
- (void)exampleAuthStateDidChange;

@optional
// Auth failed
- (void)authFailed:(nonnull NSError *)error;

// Service call has completed and a response has been received
- (void)getRequestDidCompleteWithResponse:(nonnull MSGONStandardResponse *)response;

- (void)postRequestDidCompleteWithResponse:(nonnull MSGONStandardResponse *)response;

// Data is being received in a response
- (void)URLSession:(nonnull NSURLSession *)session
          dataTask:(nonnull NSURLSessionDataTask *)dataTask
didReceiveResponse:(nonnull NSURLResponse *)response completionHandler:(nonnull void (^)(NSURLSessionResponseDisposition))completionHandler;

// A response has been received in full
- (void)URLSession:(nonnull NSURLSession *)session
          dataTask:(nonnull NSURLSessionDataTask *)dataTask
    didReceiveData:(nonnull NSData *)data;

// An error was received with the response
- (void)URLSession:(nonnull NSURLSession *)session
              task:(nonnull NSURLSessionTask *)task
didCompleteWithError:(nonnull NSError *)error;

@end
