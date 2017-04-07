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

#import "MSGONAuthSession.h"
#import "MSGONDetailViewController.h"

@interface MSGONDetailViewController ()

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

- (void)configureView;
@end

@implementation MSGONDetailViewController
{
    IBOutletCollection(UIButton) NSArray *launchButtons;
    IBOutlet UITextField *sectionNameField;
    IBOutlet UIButton *sendRequestButton;
    IBOutlet UITextView *responseField;
    IBOutlet UITextField *clientLinkField;
    IBOutlet UILabel *detailDescriptionLabel;
    IBOutlet UITextField *webLinkField;
    IBOutlet UILabel *clientLinkTitle;
    IBOutlet UILabel *webLinkTitle;
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(MSGONDataItem*)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        responseField.text = nil;
        clientLinkField.text = nil;
        webLinkField.text = nil;
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)setExamples:(MSGONRequestExamples *)newExample
{
    if(_examples != newExample) {
        _examples = newExample;
    }
}

- (void)setClientAndWebLinkFieldsToHidden:(BOOL)isHidden
{
    if (isHidden == YES) {
        for (UIButton *b in launchButtons) {
            [b setHidden:YES];
        }
        [clientLinkTitle setHidden: YES];
        [webLinkTitle setHidden: YES];
        [clientLinkField setHidden:YES];
        [webLinkField setHidden:YES];
    }
    else {
        for (UIButton *b in launchButtons) {
            [b setHidden:NO];
        }
        [clientLinkTitle setHidden: NO];
        [webLinkTitle setHidden: NO];
        [clientLinkField setHidden:NO];
        [webLinkField setHidden:NO];
    }
}

- (void)configureView
{
    [self setClientAndWebLinkFieldsToHidden:YES];
    
    if ([[MSGONAuthSession sharedSession] accessToken] == nil) {
        sendRequestButton.enabled = NO;
        detailDescriptionLabel.text = NSLocalizedString(@"PLEASE_SIGN_IN", nil);
    }
    else {
        sendRequestButton.enabled = YES;
        detailDescriptionLabel.text = [self.detailItem description];
    }
    
    // Update the user interface for the detail item.
    self.title = [self.detailItem title];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 800, 400)];
    self.view.userInteractionEnabled = YES;
    view.userInteractionEnabled = YES;
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"DETAIL_VIEW_TITLE", nil);
    [self.navigationItem setLeftBarButtonItem:barButtonItem
                                     animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    responseField.text = nil;
    [self.navigationItem setLeftBarButtonItem:nil
                                     animated:YES];
    self.masterPopoverController = nil;
}

- (IBAction)sendRequestClicked:(id)sender
{
    // Disable create button to prevent reentrancy
    if ([[MSGONAuthSession sharedSession] accessToken] != nil) {
        sendRequestButton.enabled = NO;
    }
    
    responseField.text = nil;
    webLinkField.text = nil;
    clientLinkField.text = nil;

    // Run the action defined for the form in the 'objects' table in the master view controller
    [self.examples performSelector:self.detailItem.implementation];
}

// GET request on the examples object has completed
- (void)getRequestDidCompleteWithResponse:(MSGONGetSuccessResponse *)response
{
    // Re-enable the create button
    sendRequestButton.enabled = YES;
    
    if (response) {
        responseField.text = [NSString stringWithFormat:@"%d", response.httpStatusCode];
        
        if ([response isKindOfClass:[MSGONGetSuccessResponse class]]) {
            NSError *jsonError;
            NSData *body = [NSJSONSerialization dataWithJSONObject:response.body
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&jsonError];
            
            responseField.text = [[NSString alloc] initWithData:body
                                                       encoding:NSUTF8StringEncoding];;
        }
        else {
            clientLinkField.text = nil;
            webLinkField.text = nil;
        }
    }
}

// POST request on the examples object has completed
- (void)postRequestDidCompleteWithResponse:(MSGONStandardResponse *)response
{
    // Re-enable the create button
    sendRequestButton.enabled = YES;
    [self setClientAndWebLinkFieldsToHidden:NO];
    
    if (response) {
        
        responseField.text = [NSString stringWithFormat:@"%d", response.httpStatusCode];
        
        if ([response isKindOfClass:[MSGONCreateSuccessResponse class]]) {
            
            MSGONCreateSuccessResponse *createSuccess = (MSGONCreateSuccessResponse *)response;
            clientLinkField.text = createSuccess.oneNoteClientUrl;
            webLinkField.text = createSuccess.oneNoteWebUrl;
            
        }
        else {
            clientLinkField.text = nil;
            webLinkField.text = nil;
        }
    }
}

// Handle errors
- (void)requestDidCompleteWithError:(MSGONStandardErrorResponse *)error
{
    // Re-enable the create button
    sendRequestButton.enabled = YES;
//    [self setClientAndWebLinkFieldsToHidden:YES];
    
    responseField.text = [NSString stringWithFormat:@"%@", error.message];
    clientLinkField.text = nil;
    webLinkField.text = nil;
}

// Launch created page
- (IBAction)clientLaunchClicked:(id)sender
{
    [self launchLink:clientLinkField.text];
}

// Launch created page
- (IBAction)webLaunchClicked:(id)sender
{
    [self launchLink:webLinkField.text];
}

- (void)launchLink:(NSString*)linkHref
{
    NSURL *url = [NSURL URLWithString: linkHref];
    UIApplication *application = [UIApplication sharedApplication];
    
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:url options:@{}
           completionHandler:^(BOOL success) {
           }];
    }
    else {
        [application openURL:url];
    }
}

@end
