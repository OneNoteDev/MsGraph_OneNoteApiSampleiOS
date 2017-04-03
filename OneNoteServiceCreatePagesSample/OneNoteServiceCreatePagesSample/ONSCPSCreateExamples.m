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

#import "ONSCPSCreateExamples.h"
#import "ISO8601DateFormatter.h"
#import "AFURLRequestSerialization.h"
#import "JSONSerializer.h"
#import "MSGONExampleSessionDelegate.h"
#import "MSGONExampleApiCaller.h"
#import "MSGONConstants.h"
#import "MSGONSession.h"
#import "MSGONURLSessionConfig.h"

// Client id for your application from Live Connect application management page
/**
 Visit http://go.microsoft.com/fwlink/?LinkId=392537 for instructions on getting a Client Id
 */
static NSString *const ClientId = @"103555a1-bf66-4916-85cc-c4536d58bc20";

// Main Client API object
static MSGONSession *session = nil;


// Get a date in ISO8601 string format
NSString* dateInISO8601Format() {
    ISO8601DateFormatter *isoFormatter = [[ISO8601DateFormatter alloc] init];
    [isoFormatter setDefaultTimeZone: [NSTimeZone localTimeZone]];
    [isoFormatter setIncludeTime:YES];
    NSString *date = [isoFormatter stringFromDate:[NSDate date]];
    return date;
}

// Add private extension members
@interface ONSCPSCreateExamples () {
    
    //Callback for app-defined behavior when state changes
    id<ONSCPSExampleDelegate> _delegate;
    
    // Response from the current in-progress request
    NSHTTPURLResponse *returnResponse;
    
    // Data being built for the current in-progress request
    NSMutableData *returnData;
}
@end

@implementation ONSCPSCreateExamples

+ (NSString*)clientId {
    return ClientId;
}

+ (BOOL) isStringEmpty:(NSString *)string {
    if([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

- (id)init {
    return [self initWithDelegate:nil];
}

- (id)initWithDelegate:(id<ONSCPSExampleDelegate>)newDelegate {
    self = [super init];
    if(self != nil) {
        _delegate = newDelegate;
    }
    return self;
}

// Get the delegate in use
- (id<ONSCPSExampleDelegate>)delegate {
    return _delegate;
}

// Update the delegate to use
- (void)setDelegate:(id<ONSCPSExampleDelegate>)newDelegate {
    _delegate = newDelegate;
//    // Force a refresh on the new delegate with the current state
//    [_delegate exampleAuthStateDidChange:[MSGONSession sharedSession]];
}

//- (void)authCompleted:(MSGONSession *)session {
//    //Initialize the values for the access token, the refresh token and the amount of time in which the token expires after successful completion of authentication
//    accessToken = session.accessToken;
//    refreshToken = session.refreshToken;
//    expires = session.expires;
//    [_delegate exampleAuthStateDidChange:session];
//}

- (void)authFailed:(NSError *)error userState:(id)userState {
    [_delegate exampleAuthStateDidChange:nil];
}

- (void)getNotebooks {
    
    [[MSGONSession sharedSession] checkAndRefreshTokenWithCompletion:^(ADAuthenticationError *error) {
        if(error){
            // log error;
            return;
        }
        
        NSURLRequest *request = [MSGONExampleApiCaller constructRequestHeaders:@"notebooks"
                                                                    withMethod:@"GET"
                                                                      andToken:[[MSGONSession sharedSession] accessToken]];
        
        NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                                 delegate:self
                                                            delegateQueue:[NSOperationQueue mainQueue]];
        
        NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              // do something with the data
                                          }];
        [dataTask resume]; 
    }];
     
}

- (void)getSections {
    
    [[MSGONSession sharedSession] checkAndRefreshTokenWithCompletion:^(ADAuthenticationError *error) {
        if(error){
            // log error;
            return;
        }
        
        NSURLRequest *request = [MSGONExampleApiCaller constructRequestHeaders:@"sections"
                                                                    withMethod:@"GET"
                                                                      andToken:[[MSGONSession sharedSession] accessToken]];
        
        NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                                 delegate:self
                                                            delegateQueue:[NSOperationQueue mainQueue]];
        
        NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              // do something with the data
                                          }];
        [dataTask resume];
    }];
}

- (void)getPages {
    
    [[MSGONSession sharedSession] checkAndRefreshTokenWithCompletion:^(ADAuthenticationError *error) {
        if(error){
            // log error;
            return;
        }
        
        NSURLRequest *request = [MSGONExampleApiCaller constructRequestHeaders:@"pages"
                                                                    withMethod:@"GET"
                                                                      andToken:[[MSGONSession sharedSession] accessToken]];
        
        NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                                 delegate:self
                                                            delegateQueue:[NSOperationQueue mainQueue]];
        
        NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              // do something with the data
                                          }];
        [dataTask resume];
    }];
}


//
//- (void)checkForAccessTokenExpiration {
//    if(refreshToken) {
//        NSDate *now = [NSDate dateWithTimeIntervalSinceNow:TokenExpirationBuffer];
//        NSComparisonResult result = [expires compare:now];
//        switch (result) {
//            case NSOrderedSame:
//            case NSOrderedAscending:
//                [self attemptRefreshToken];
//                break;
//            case NSOrderedDescending:
//                break;
//            default:
//                break;
//        }
//    }
//}

//- (void)createSimplePage:(NSString*)sectionName {
//    [self checkForAccessTokenExpiration];
//    NSString *date = dateInISO8601Format();
//    NSString *simpleHtml = [NSString stringWithFormat:
//                            @"<html>"
//                            "<head>"
//                            "<title>A simple page created from basic HTML-formatted text from iOS</title>"
//                            "<meta name=\"created\" content=\"%@\" />"
//                            "</head>"
//                            "<body>"
//                            "<p>This is a page that just contains some simple <i>formatted</i> <b>text</b></p>"
//                            "</body>"
//                            "</html>", date];
//    
//    NSData *presentation = [simpleHtml dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *endpointToRequest = [ONSCPSCreateExamples getPagesEndpointUrlWithSectionName:sectionName];
//    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:endpointToRequest]];
//    request.HTTPMethod = @"POST";
//    request.HTTPBody = presentation;
//    [request addValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
//    
//    if (session) {
//        [request setValue:[@"Bearer " stringByAppendingString:accessToken] forHTTPHeaderField:@"Authorization"];
//    }
//    [NSURLConnection connectionWithRequest:request delegate:self];
//}


#pragma mark - Delegate callbacks from asynchronous request POST

// Handle send errors
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
     // Error is a failure to make the call or authenticate, not a deep HTTP error response from the server.
     [_delegate exampleServiceActionDidCompleteWithResponse:[[ONSCPSStandardErrorResponse alloc] init]];
}

// When body data arrives, store it
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [returnData appendData:data];
}

// When a response starts to arrive, allocate a data buffer for the body
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    returnData = [[NSMutableData alloc] init];
    returnResponse = (NSHTTPURLResponse *)response;
}

// Handle parsing the response from a finished service call
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    int status = [returnResponse statusCode];
    ONSCPSStandardResponse *standardResponse = nil;
    if (status == 200) {
        MSGONGetSuccessResponse *res = [[MSGONGetSuccessResponse alloc] init];
        res.httpStatusCode = status;
        NSError *jsonError;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:&jsonError];
//        if(responseObject && !jsonError) {
//            created.oneNoteClientUrl = [responseObject valueForKeyPath:@"links.oneNoteClientUrl.href"];
//            created.oneNoteWebUrl = [responseObject valueForKeyPath:@"links.oneNoteWebUrl.href"];
//        }
        if(responseObject && !jsonError) {
            res.headers = [responseObject objectForKey:@"@odata.context"];
            res.body = [responseObject objectForKey:@"value"];
        }
        standardResponse = res;
    }
    else {
        ONSCPSStandardErrorResponse *error = [[ONSCPSStandardErrorResponse alloc] init];
        error.httpStatusCode = status;
        error.message = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        standardResponse = error;
    }
    NSAssert(standardResponse != nil, @"The standard response for the connection that finished loading appears to be nil");
    // Send the response back to the client.
    [_delegate exampleServiceActionDidCompleteWithResponse: standardResponse];
}

@end
