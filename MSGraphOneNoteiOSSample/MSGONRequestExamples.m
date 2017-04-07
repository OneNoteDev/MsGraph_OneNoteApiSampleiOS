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

#import "MSGONConstructRequestHeaders.h"
#import "MSGONRequestExamples.h"
#import "MSGONAuthSession.h"

// Add private extension members
@interface MSGONRequestExamples () {
    
    //Callback for app-defined behavior when state changes
    id<MSGONExampleDelegate> _delegate;
    
    // Data being built for the current in-progress request
    NSMutableData *returnData;
}
@end

@implementation MSGONRequestExamples

- (instancetype)init {
    return [self initWithDelegate:nil];
}

- (instancetype)initWithDelegate:(id<MSGONExampleDelegate>)newDelegate {
    self = [super init];
    if(self != nil) {
        _delegate = newDelegate;
    }
    return self;
}

// Update the delegate to use
- (void)setDelegate:(id<MSGONExampleDelegate>)newDelegate {
    _delegate = newDelegate;
//    // Force a refresh on the new delegate with the current state
//    [_delegate exampleAuthStateDidChange];
}

- (void)getNotebooks {
    
    [[MSGONAuthSession sharedSession] checkAndRefreshTokenWithCompletion:^(ADAuthenticationError *error) {
        if(error){
            // log error;
            return;
        }
        
        NSURLRequest *request = [MSGONConstructRequestHeaders constructRequestHeaders:@"notebooks"
                                                                    withMethod:@"GET"
                                                                      andToken:[[MSGONAuthSession sharedSession] accessToken]];
        
        NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                                 delegate:self
                                                            delegateQueue:[NSOperationQueue mainQueue]];
        
        NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                [_delegate requestDidCompleteWithError:error];
                NSLog(@"dataTaskWithRequest error: %@", error);
                return;
            }
            
            // handle HTTP errors here
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                
                NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                
                if (statusCode != 200) {
                    MSGONStandardErrorResponse *error = [[MSGONStandardErrorResponse alloc] init];
                    error.httpStatusCode = statusCode;
                    error.message = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                    [_delegate requestDidCompleteWithError:error];
                }
                else {
                    NSLog(@"dataTaskWithRequest HTTP status code: %ld", (long)statusCode);
                    [self URLSession:urlSession dataTask:dataTask didReceiveData:data];
                }
                
            }
        }];
        [dataTask resume];
    }];
}

- (void)getNotebooksWithSections {
    [[MSGONAuthSession sharedSession] checkAndRefreshTokenWithCompletion:^(ADAuthenticationError *error) {
        if(error){
            // log error;
            return;
        }
        
        NSURLRequest *request = [MSGONConstructRequestHeaders constructRequestHeaders:@"notebooks?$expand=sections"
                                                                    withMethod:@"GET"
                                                                      andToken:[[MSGONAuthSession sharedSession] accessToken]];
        
        NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                                 delegate:self
                                                            delegateQueue:[NSOperationQueue mainQueue]];
        
        NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                [_delegate requestDidCompleteWithError:error];
                NSLog(@"dataTaskWithRequest error: %@", error);
                return;
            }
            
            // handle HTTP errors here
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                
                NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                
                if (statusCode != 200) {
                    MSGONStandardErrorResponse *error = [[MSGONStandardErrorResponse alloc] init];
                    error.httpStatusCode = statusCode;
                    error.message = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                    [_delegate requestDidCompleteWithError:error];
                }
                else {
                    NSLog(@"dataTaskWithRequest HTTP status code: %ld", (long)statusCode);
                    [self URLSession:urlSession dataTask:dataTask didReceiveData:data];
                }
                
            }
        }];
        [dataTask resume];
    }];
}

- (void)getSections {
    
    [[MSGONAuthSession sharedSession] checkAndRefreshTokenWithCompletion:^(ADAuthenticationError *error) {
        if(error){
            // log error;
            return;
        }
        
        NSURLRequest *request = [MSGONConstructRequestHeaders constructRequestHeaders:@"sections"
                                                                    withMethod:@"GET"
                                                                      andToken:[[MSGONAuthSession sharedSession] accessToken]];
        
        NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                                 delegate:self
                                                            delegateQueue:[NSOperationQueue mainQueue]];
        
        NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                NSLog(@"dataTaskWithRequest error: %@", error);
                [_delegate requestDidCompleteWithError:error];
                return;
            }
            
            // handle HTTP errors here
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                
                NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                
                if (statusCode != 200) {
                    MSGONStandardErrorResponse *error = [[MSGONStandardErrorResponse alloc] init];
                    error.httpStatusCode = statusCode;
                    error.message = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                    [_delegate requestDidCompleteWithError:error];
                }
                else {
                    NSLog(@"dataTaskWithRequest HTTP status code: %ld", (long)statusCode);
                    [self URLSession:urlSession dataTask:dataTask didReceiveData:data];
                }
                
            }
        }];
        [dataTask resume];
    }];
}

- (void)getPages {
    
    [[MSGONAuthSession sharedSession] checkAndRefreshTokenWithCompletion:^(ADAuthenticationError *error) {
        if(error){
            // log error;
            return;
        }
        
        NSURLRequest *request = [MSGONConstructRequestHeaders constructRequestHeaders:@"pages"
                                                                    withMethod:@"GET"
                                                                      andToken:[[MSGONAuthSession sharedSession] accessToken]];
        
        NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                                 delegate:self
                                                            delegateQueue:[NSOperationQueue mainQueue]];
        
        NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                NSLog(@"dataTaskWithRequest error: %@", error);
                [_delegate requestDidCompleteWithError:error];
                return;
            }
            
            // handle HTTP errors here
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                
                NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                
                if (statusCode != 200) {
                    MSGONStandardErrorResponse *error = [[MSGONStandardErrorResponse alloc] init];
                    error.httpStatusCode = statusCode;
                    error.message = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                    [_delegate requestDidCompleteWithError:error];
                } else {
                    NSLog(@"dataTaskWithRequest HTTP status code: %ld", (long)statusCode);
                    [self URLSession:urlSession dataTask:dataTask didReceiveData:data];
                }
            }
        }];
        [dataTask resume];
    }];
}

- (void)createPage {
    [[MSGONAuthSession sharedSession] checkAndRefreshTokenWithCompletion:^(ADAuthenticationError *error) {
        if(error){
            // log error;
            return;
        }
        
        NSMutableURLRequest *request = [MSGONConstructRequestHeaders constructRequestHeaders:@"pages"
                                                                    withMethod:@"POST"
                                                                      andToken:[[MSGONAuthSession sharedSession] accessToken]];
        
        NSString *requestBody = @"<html>"
                                "<head>"
                                "<title>A simple page created from basic HTML-formatted text from iOS</title>"
                                "<meta name=\"created\" content=\"%@\" />"
                                "</head>"
                                "<body>"
                                "<p>This is a page that just contains some simple <i>formatted</i> <b>text</b></p>"
                                "</body>"
                                "</html>";
        
        [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
        [request addValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    
        NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                                 delegate:self
                                                            delegateQueue:[NSOperationQueue mainQueue]];
        
        NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                NSLog(@"dataTaskWithRequest error: %@", error);
                [_delegate requestDidCompleteWithError:error];
                return;
            }
            
            // handle HTTP errors here
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                
                NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                
                if (statusCode != 201) {
                    MSGONStandardErrorResponse *error = [[MSGONStandardErrorResponse alloc] init];
                    error.httpStatusCode = statusCode;
                    error.message = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                    [_delegate requestDidCompleteWithError:error];
                }
                
                else {
                    NSLog(@"dataTaskWithRequest HTTP status code: %ld", (long)statusCode);
                    
                    [self URLSession:urlSession dataTask:dataTask didReceivePostResponse:data];
                }
                
            }
        }];
        [dataTask resume];
    }];
}
#pragma mark - Delegate callbacks from HTTP requests

// Data is being received
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    completionHandler(NSURLSessionResponseAllow);
}

// Response data has been received in full
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    
    // Handle parsing the response from a finished service call
    MSGONGetSuccessResponse *res = [[MSGONGetSuccessResponse alloc] init];
    
    NSError *jsonError;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    if(responseObject && !jsonError) {
        res.oDataContext = [responseObject objectForKey:@"@odata.context"];
        res.body = [responseObject objectForKey:@"value"];
//        res.body = [NSJSONSerialization JSONObjectWithData:body options:NSJSONWritingPrettyPrinted error:&jsonError];
    }
    // Invalidate session
    [session finishTasksAndInvalidate];
    
    NSAssert(res != nil, @"The standard response for the connection that finished loading appears to be nil");
    // Send the response back to the client.
    [_delegate getRequestDidCompleteWithResponse:res];

}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceivePostResponse:(NSData *)response {

    // Handle parsing the response from a finished service call
    MSGONCreateSuccessResponse *res = [[MSGONCreateSuccessResponse alloc] init];
    
    NSError *jsonError;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonError];
    if(responseObject && !jsonError) {
        res.oneNoteClientUrl = [responseObject valueForKeyPath:@"links.oneNoteClientUrl.href"];
        res.oneNoteWebUrl = [responseObject valueForKeyPath:@"links.oneNoteWebUrl.href"];
        res.httpStatusCode = 201;
    }
    NSAssert(res != nil, @"The standard response for the connection that finished loading appears to be nil");
    
    //Invalidate session
    [session finishTasksAndInvalidate];
    
    // Send the response back to the client.
    [_delegate postRequestDidCompleteWithResponse:res];
}

// Handle error responses
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error{
    if (error) {
        [_delegate requestDidCompleteWithError:error];
    }
}

@end
