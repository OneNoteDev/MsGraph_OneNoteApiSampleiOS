//
//  ONSCPSExampleDelegate.m
//  OneNoteServiceCreatePagesSample
//
//  Created by Stefanie Hansen on 3/31/17.
//  Copyright © 2017 Microsoft Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ONSCPSExampleDelegate.h"

@implementation ONSCPSExampleDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error;
{
    //TODO Implement method
    if (error == Nil) {
        //TODO ascertain the failure and report failure to the caller
        return;
    }
    //TODO Report success
}

@end
