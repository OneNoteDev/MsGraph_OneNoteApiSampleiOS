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

#import "MSGONAppConfig.h"
#import "MSGONDetailViewController.h"
#import "MSGONMasterViewController.h"
#import "MSGONAuthSession.h"

@interface MSGONMasterViewController()
{
    NSArray *objects;
    
    // Service facade instance for the app.
    MSGONRequestExamples *examples;
}

@end

@implementation MSGONMasterViewController
{
    IBOutlet UIBarButtonItem *_authButton;
    IBOutlet UILabel *_signInText;
}


- (IBAction)authClicked:(id)sender
{
    [[MSGONAuthSession sharedSession] authenticateUserUsingController:self];
}

- (void)authStateDidChange
{
    [self updateMasterView];
}

- (void)authFailed:(NSError *)error
{
    // Handle error
    [self authStateDidChange];
}

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }

	[super awakeFromNib];
}

- (void)viewDidLoad
{
    [[MSGONAuthSession sharedSession] setDelegatesforAPIResponse:self.detailViewController andAuth:self];
    
    [super viewDidLoad];

	UIBarButtonItem *signInBarButton = [[UIBarButtonItem alloc] initWithTitle:nil
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(authClicked:)];
	_authButton = signInBarButton;

	self.navigationItem.title = NSLocalizedString(@"Graph API Sample Requests", @"Title of master view");
	self.navigationItem.rightBarButtonItem = signInBarButton;
	_signInText.text = NSLocalizedString(@"Please sign in to use the application", @"Footer that displays when user is signed out");

    [self createSampleData];
    
    self.detailViewController = (MSGONDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    [self updateMasterView];
    
    // Setup for ipad, where detail view is availabe immediately
    if(self.detailViewController) {
        examples = [[MSGONRequestExamples alloc] initWithAuthDelegate:self
                                                  andResponseDelegate:self.detailViewController];

        [self.detailViewController setExamples:examples];
        [self.detailViewController setDetailItem:objects[0]];
    }

    /**
    Check if client ID has not yet been entered in MSGONAppConfig
    If yes, alert that a client ID must be inserted in file MSGONAppConfig.m
     */
    if ([clientId length] == 0)
	{
		NSString *errorAlertTitle = NSLocalizedString(@"Please add a client Id to your code.", @"Title of error alert if no client Id specified");
		NSString *errorAlertBodyPatternString = NSLocalizedString(@"Visit %@ for instructions on getting a Client Id. Please specify your client ID at field ClientId in the MSGONAppConfig.m file and rebuild the application.", @"Error alert body, placeholder is URL to developer registration page");
		NSString *appRegistrationURLString = [[NSBundle mainBundle] localizedStringForKey:@"APP_REGISTRATION_URL" value:nil table:@"Nonlocalizable"];
		NSString *errorAlertBody = [NSString stringWithFormat:errorAlertBodyPatternString, appRegistrationURLString];

		UIAlertController *alert = [UIAlertController alertControllerWithTitle:errorAlertTitle
																	   message:errorAlertBody
																preferredStyle:UIAlertControllerStyleAlert];

		[alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"Ok button to dismiss alert")
												  style:UIAlertActionStyleDefault
												handler:nil]];

		[alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Open in Safari", @"Button to open Safari to developer page")
												  style:UIAlertActionStyleDefault
												handler:^(UIAlertAction *action)
		{
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:appRegistrationURLString]];
		}]];

		[self presentViewController:alert animated:YES completion:nil];
    }
}

// Toggle master view depending on user's state of authentication
- (void)updateMasterView
{
    if ([[MSGONAuthSession sharedSession] accessToken] != nil) {
        [_authButton setTitle:NSLocalizedString(@"Sign Out", @"Text of auth button when signed in")];
        [_signInText setHidden:YES];
    }
    else {
		[_authButton setTitle:NSLocalizedString(@"Sign In", @"Text of auth button when signed out")];
        [_signInText setHidden:NO];
    }
}

- (void)createSampleData
{
    if(!objects) {
        objects = @[
					[[MSGONDataItem alloc] initWithTitle:NSLocalizedString(@"Get Notebooks", @"Title of item to get notebooks")
											 description:NSLocalizedString(@"Get all notebooks.", nil)
										  implementation:@selector(getNotebooks)],
					[[MSGONDataItem alloc] initWithTitle:NSLocalizedString(@"Get Notebooks & Sections", @"Title of item to get notebooks with sections")
											 description:NSLocalizedString(@"Get all notebooks with expanded sections.", nil)
										  implementation:@selector(getNotebooksWithSections)],
					[[MSGONDataItem alloc] initWithTitle:NSLocalizedString(@"Get Pages", @"Title of item to get pages")
											 description:NSLocalizedString(@"Get all pages.", nil)
										  implementation:@selector(getPages)],
					[[MSGONDataItem alloc] initWithTitle:NSLocalizedString(@"Get Sections", @"Title of item to get sections")
											 description:NSLocalizedString(@"Get all sections.", nil)
										  implementation:@selector(getSections)],
					[[MSGONDataItem alloc] initWithTitle:NSLocalizedString(@"Create A Page", @"Title of item to create a page")
											 description:NSLocalizedString(@"Create a page in the default section.", nil)
										  implementation:@selector(createPage)],
                     ];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                            forIndexPath:indexPath];

    MSGONDataItem *object = objects[indexPath.row];
    cell.textLabel.text = [object title];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        MSGONDataItem *object = objects[indexPath.row];
        self.detailViewController.detailItem = object;
    
        
        // Reset the facade callback to the new controller.
        [examples setAuthDelegate:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MSGONDataItem *object = objects[indexPath.row];
        
        if ([[segue destinationViewController] isKindOfClass:([MSGONDetailViewController class])]) {
            
            // Setup for iPhone, where this is the first sign of detail view
            self.detailViewController = [segue destinationViewController];
            
            examples = [[MSGONRequestExamples alloc] initWithAuthDelegate:self
                                                      andResponseDelegate:self.detailViewController];
            
            [self.detailViewController setExamples:examples];
            [self.detailViewController setDetailItem:object];
        }
    }
}

@end
