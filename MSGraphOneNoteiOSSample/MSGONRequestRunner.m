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

@interface MSGONRequestRunner() {
    id<MSGONAPIResponseDelegate> _responseDelegate;
    id<MSGONAuthDelegate> _authDelegate;
}

@end

@implementation MSGONRequestRunner

#pragma init
- (instancetype)initWithAuthDelegate:(id<MSGONAuthDelegate>)authDelegate andResponseDelegate:(id<MSGONAPIResponseDelegate>)responseDelegate {
    if (self = [super init]) {
        _responseDelegate = responseDelegate;
        _authDelegate = authDelegate;
    }
    return self;
}

#pragma API request methods
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

- (void)getRequest:(NSString *)resource withToken:(NSString *)token {
    
    NSURLRequest *request = [MSGONRequestRunner constructRequestHeaders:resource
                                                             withMethod:@"GET"
                                                               andToken:[[MSGONAuthSession sharedSession] accessToken]];
    
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                             delegate:_responseDelegate
                                                        delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request
                                                   completionHandler:^(NSData *data,
                                                                       NSURLResponse *response,
                                                                       NSError *error) {
                                                       if (error) {
                                                           MSGONStandardErrorResponse *err = [[MSGONStandardErrorResponse alloc] initWithStatusCode:(int)error.code];
                                                           [_responseDelegate requestDidCompleteWithError:err];
                                                           NSLog(@"dataTaskWithRequest error: %@", error);
                                                           return;
                                                       }
                                                       
                                                         // handle HTTP errors here
                                                       if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            
                                                           NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                                                           
                                                           if (statusCode != 200) {
                                                               MSGONStandardErrorResponse *error = [[MSGONStandardErrorResponse alloc] init];
                                                               error.httpStatusCode = (int)statusCode;
                                                               error.message = [[NSString alloc] initWithData:data
                                                                                                     encoding:NSUTF8StringEncoding];
                                                               [_responseDelegate requestDidCompleteWithError:error];
                                                           }
                                                           else {
                                                               NSLog(@"dataTaskWithRequest HTTP status code: %ld", (long)statusCode);
                                                               [_responseDelegate URLSession:urlSession
                                                                                    dataTask:dataTask
                                                                              didReceiveData:data];
                                                           }
                                                           
                                                       }
                                                   }];
   [dataTask resume];
}

- (void)postRequest:(NSString *)resouce withToken:(NSString *)token {
    
    NSMutableURLRequest *request = [MSGONRequestRunner constructRequestHeaders:@"pages"
                                                                    withMethod:@"POST"
                                                                      andToken:[[MSGONAuthSession sharedSession] accessToken]];

	NSString *requestBodyPattern = [[NSBundle mainBundle] localizedStringForKey:@"CREATE_PAGE_HTML_PATTERN" value:nil table:@"Nonlocalizable"];

	NSString *pageTitle = NSLocalizedString(@"A simple page created from basic HTML-formatted text from iOS", @"Title of sample page created");
	NSString *pageBody = NSLocalizedString(@"This is a page that just contains some simple <i>formatted</i> <b>text</b>", @"Body of sample page created");

	NSString *requestBody = [NSString stringWithFormat:requestBodyPattern, pageTitle, pageBody];

    [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
    [request addValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                             delegate:_responseDelegate
                                                        delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request
                                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"dataTaskWithRequest error: %@", error);
            MSGONStandardErrorResponse *err = [[MSGONStandardErrorResponse alloc] initWithStatusCode:(int)error.code];
            [_responseDelegate requestDidCompleteWithError:err];
            return;
        }
        
        // handle HTTP errors here
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            
            if (statusCode != 201) {
                MSGONStandardErrorResponse *error = [[MSGONStandardErrorResponse alloc] init];
                error.httpStatusCode = (int)statusCode;
                error.message = [[NSString alloc] initWithData:data
                                                      encoding:NSUTF8StringEncoding];
                [_responseDelegate requestDidCompleteWithError:error];
            }
            
            else {
                NSLog(@"dataTaskWithRequest HTTP status code: %ld", (long)statusCode);
                
                [_responseDelegate URLSession:urlSession
                                     dataTask:dataTask
                       didReceivePostResponse:data];
            }
            
        }
    }];
    [dataTask resume];

}

@end
