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

- (void)exampleAuthStateDidChange
{
    [self updateMasterView];
}

- (void)authFailed:(NSError *)error
{
    [self exampleAuthStateDidChange];
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
    [[MSGONAuthSession sharedSession] setDelegate:self];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [self createSampleData];
    
    self.detailViewController = (MSGONDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    [self updateMasterView];
    
    // Setup for ipad, where detail view is availabe immediately
    if(self.detailViewController) {
        examples = [[MSGONRequestExamples alloc] initWithDelegate:self.detailViewController];

        [self.detailViewController setExamples:examples];
        [self.detailViewController setDetailItem:objects[0]];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please add a client Id to your code."
                                                    message:@"Visit http://go.microsoft.com/fwlink/?LinkId=392537 for instructions on getting a Client Id. Please specify your client ID at field ClientId in the MSGONAppConfig.m file and rebuild the application."
                                              delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
    /**
    Check if client ID has not yet been entered in MSGONAppConfig
    If yes, alert that a client ID must be inserted in file MSGONAppConfig.m
     */
    if([clientId isEqual: @"Insert Your Client Id Here"]) {
        [alert show];
    }
}

// Toggle master view depending on user's state of authentication
- (void) updateMasterView
{
    if ([[MSGONAuthSession sharedSession] accessToken] != nil) {
        _authButton = [_authButton initWithTitle:@"Sign Out" style:UIBarButtonItemStyleDone target:self action:@selector(authClicked:)];
        [_signInText setHidden:YES];
    }
    else {
        _authButton = [_authButton initWithTitle:@"Sign In" style:UIBarButtonItemStyleDone target:self action:@selector(authClicked:)];
        [_signInText setHidden:NO];
    }
    [self]
}

- (void)createSampleData
{
    if(!objects) {
        objects = @[
            [[MSGONDataItem alloc] initWithTitle:@"Get notebooks"
                                      description:@"Get all notebooks."
                                   implementation: @selector(getNotebooks)],
            [[MSGONDataItem alloc] initWithTitle:@"Get notebooks & sections"
                                      description:@"Get all notebooks with expanded sections."
                                   implementation: @selector(getNotebooksWithSections)],
            [[MSGONDataItem alloc] initWithTitle:@"Get pages"
                                      description:@"Get all pages."
                                   implementation: @selector(getPages)],
            [[MSGONDataItem alloc] initWithTitle:@"Get sections"
                                      description:@"Get all sections."
                                   implementation: @selector(getSections)],
            [[MSGONDataItem alloc] initWithTitle:@"Create a page"
                                      description:@"Create a page in the default section."
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

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
        [examples setDelegate:self.detailViewController];
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
            [examples delegate];
            examples = [[MSGONRequestExamples alloc] initWithDelegate:self.detailViewController];
            
            [self.detailViewController setExamples:examples];
            [self.detailViewController setDetailItem:object];
        }
    }
}

@end
