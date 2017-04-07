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
#import "MSGONAuthSession.h"
#import "MSGONRequestRunner.h"

@implementation MSGONRequestRunner

+ (NSMutableURLRequest*)constructRequestHeaders:(NSString*)resource withMethod:(NSString*)method andToken:(NSString*)token {
    
    // MSGraph OneNote endpoint with resource appended
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@", resourceUri, resource];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestUrl]];
    
    // Specify the method
    [request setHTTPMethod:method];
    [request setValue:@"application/json, text/plain, */*" forHTTPHeaderField:@"Accept"];
    
    // Set authorization header with token
    NSString *authorization = [NSString stringWithFormat:@"Bearer %@", token];
    [request setValue:authorization forHTTPHeaderField:@"Authorization"];
    
    return request;
}

+ (void)getRequest:(NSString *)resource withToken:(NSString *)token usingDelegate:(MSGONRequestExamples*)delegate {
    
    NSMutableData *returnData;
    
    NSURLRequest *request = [self constructRequestHeaders:resource
                                               withMethod:@"GET"
                                                 andToken:[[MSGONAuthSession sharedSession] accessToken]];
    
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                             delegate:self
                                                        delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request
                                                   completionHandler:^(NSData *data,
                                                                       NSURLResponse *response,
                                                                       NSError *error) {
                                                       if (error) {
                                                           MSGONStandardErrorResponse *err = [[MSGONStandardErrorResponse alloc] initWithStatusCode:(int)error.code];
                                                 //          [delegate requestDidCompleteWithError:err];
                                                           NSLog(@"dataTaskWithRequest error: %@", error);
                                                           return;
                                                       }
                                                       
                                                         // handle HTTP errors here
                                                       if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            
                                                           NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                                                           
                                                           if (statusCode != 200) {
                                                               MSGONStandardErrorResponse *error = [[MSGONStandardErrorResponse alloc] init];
                                                               error.httpStatusCode = (int)statusCode;
                                                               error.message = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                                                               //[delegate requestDidCompleteWithError:error];
                                                           }
                                                           else {
                                                               NSLog(@"dataTaskWithRequest HTTP status code: %ld", (long)statusCode);
                                                               [delegate URLSession:urlSession dataTask:dataTask didReceiveData:data];
                                                           }
                                                           
                                                       }
                                                   }];
   [dataTask resume];
}

@end
