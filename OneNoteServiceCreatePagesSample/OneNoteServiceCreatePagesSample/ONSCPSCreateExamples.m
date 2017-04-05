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
//    [_delegate exampleAuthStateDidChange];
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
        
        NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                [_delegate getRequestDidCompleteWithResponse:error];
                NSLog(@"dataTaskWithRequest error: %@", error);
                return;
            }
            
            // handle HTTP errors here
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                
                NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                
                if (statusCode != 200) {
                    ONSCPSStandardErrorResponse *error = [[ONSCPSStandardErrorResponse alloc] init];
                    error.httpStatusCode = statusCode;
                    error.message = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                    [_delegate getRequestDidCompleteWithResponse:error];
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
        
        NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                NSLog(@"dataTaskWithRequest error: %@", error);
                [_delegate getRequestDidCompleteWithResponse:error];
                return;
            }
            
            // handle HTTP errors here
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                
                NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                
                if (statusCode != 200) {
                    ONSCPSStandardErrorResponse *error = [[ONSCPSStandardErrorResponse alloc] init];
                    error.httpStatusCode = statusCode;
                    error.message = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                    [_delegate getRequestDidCompleteWithResponse:error];
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
        
        NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                NSLog(@"dataTaskWithRequest error: %@", error);
                [_delegate getRequestDidCompleteWithResponse:error];
                return;
            }
            
            // handle HTTP errors here
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                
                NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                
                if (statusCode != 200) {
                    ONSCPSStandardErrorResponse *error = [[ONSCPSStandardErrorResponse alloc] init];
                    error.httpStatusCode = statusCode;
                    error.message = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                    [_delegate getRequestDidCompleteWithResponse:error];
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
    [[MSGONSession sharedSession] checkAndRefreshTokenWithCompletion:^(ADAuthenticationError *error) {
        if(error){
            // log error;
            return;
        }
        
        NSMutableURLRequest *request = [MSGONExampleApiCaller constructRequestHeaders:@"pages"
                                                                    withMethod:@"POST"
                                                                      andToken:[[MSGONSession sharedSession] accessToken]];
        
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
                [_delegate postRequestDidCompleteWithResponse:error];
                return;
            }
            
            // handle HTTP errors here
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                
                NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                
                if (statusCode != 201) {
                    ONSCPSStandardErrorResponse *error = [[ONSCPSStandardErrorResponse alloc] init];
                    error.httpStatusCode = statusCode;
                    error.message = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                    [_delegate postRequestDidCompleteWithResponse:error];
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
        res.headers = [responseObject objectForKey:@"@odata.context"];
        res.body = [responseObject objectForKey:@"value"];
    }
    NSAssert(res != nil, @"The standard response for the connection that finished loading appears to be nil");
    // Send the response back to the client.
    [_delegate getRequestDidCompleteWithResponse:res];

}

- (void)URLSession:(NSURLSession *)urlSession dataTask:(NSURLSessionDataTask *)dataTask didReceivePostResponse:(NSData *)response {

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
    // Send the response back to the client.
    [_delegate postRequestDidCompleteWithResponse:res];
}

// Handle error responses
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error{
    if (error) {
        // add error handling for post as well
        [_delegate getRequestDidCompleteWithResponse:[[ONSCPSStandardErrorResponse alloc] init]];
    }
}

@end
