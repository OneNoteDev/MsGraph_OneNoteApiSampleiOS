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

#import "MSGONRequestExamples.h"
#import "MSGONRequestRunner.h"
#import "MSGONAuthSession.h"

// Add private extension members
@interface MSGONRequestExamples () {
    
    //Callback for app-defined behavior when state changes
    id<MSGONAuthDelegate> _authDelegate;
    id<MSGONAPIResponseDelegate> _responseDelegate;
    
//    // Data being built for the current in-progress request
//    NSMutableData *returnData;
}
@end

@implementation MSGONRequestExamples

- (instancetype)init {
    return [self initWithAuthDelegate:nil andResponseDelegate:nil];
}

- (instancetype)initWithAuthDelegate:(id<MSGONAuthDelegate>)authDelegate andResponseDelegate:(id<MSGONAPIResponseDelegate>)responseDelegate {
    self = [super init];
    if(self != nil) {
        _authDelegate = authDelegate;
        _responseDelegate = responseDelegate;
    }
    return self;
}

// Update the delegate to use
- (void)setAuthDelegate:(id<MSGONAuthDelegate>)authDelegate {
    _authDelegate = authDelegate;
    // Force a refresh on the new delegate with the current state
    [_authDelegate authStateDidChange];
}

- (void)getNotebooks {
    
    [[MSGONAuthSession sharedSession] checkAndRefreshTokenWithCompletion:^(ADAuthenticationError *error) {
 
        if(error){
            // log error;
            return;
        }
        
        
        [[[MSGONRequestRunner alloc] initWithAuthDelegate:_authDelegate and:self] getRequest:@"notebooks"
                                                                                   withToken:[[MSGONAuthSession sharedSession] accessToken]];
    }];
}

- (void)getNotebooksWithSections {
    
    [[MSGONAuthSession sharedSession] checkAndRefreshTokenWithCompletion:^(ADAuthenticationError *error) {
        
        if(error){
            // log error;
            return;
        }
        
        [[[MSGONRequestRunner alloc] initWithAuthDelegate:_authDelegate and:self]  getRequest:@"notebooks?$expand=sections"
                                                                                    withToken:[[MSGONAuthSession sharedSession] accessToken]];
    }];
     
}

- (void)getSections {
    
    [[MSGONAuthSession sharedSession] checkAndRefreshTokenWithCompletion:^(ADAuthenticationError *error) {
        
        if(error){
            // log error;
            return;
        }
        
        [[[MSGONRequestRunner alloc] initWithAuthDelegate:_authDelegate and:self] getRequest:@"sections"
                                                                                   withToken:[[MSGONAuthSession sharedSession] accessToken]];
    }];
}

- (void)getPages {
    
    [[MSGONAuthSession sharedSession] checkAndRefreshTokenWithCompletion:^(ADAuthenticationError *error) {
        
        if(error){
            // log error;
            return;
        }
        
        [[[MSGONRequestRunner alloc] initWithAuthDelegate:_authDelegate and:self] getRequest:@"pages"
                                                                                   withToken:[[MSGONAuthSession sharedSession] accessToken]];
         }];
        
}

- (void)createPage {
    [[MSGONAuthSession sharedSession] checkAndRefreshTokenWithCompletion:^(ADAuthenticationError *error) {
        if(error){
            // log error;
            return;
        }
        
        [[[MSGONRequestRunner alloc] initWithAuthDelegate:_authDelegate and:self] postRequest:@"pages"
                                                                                    withToken:[[MSGONAuthSession sharedSession] accessToken]];

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
    [_responseDelegate getRequestDidCompleteWithResponse:res];

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
    [_responseDelegate postRequestDidCompleteWithResponse:res];
}

// Handle error responses
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error{
    if (error) {
        MSGONStandardErrorResponse *err = [[MSGONStandardErrorResponse alloc] initWithStatusCode:(int)error.code];
        [_responseDelegate requestDidCompleteWithError:err];
    }
}

@end
