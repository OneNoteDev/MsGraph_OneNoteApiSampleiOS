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


NSString *const kMSGONClientIDPlaceholder = @"Insert Your Client ID Here";

// Replace with the ClientID and redirectURI specific to your application.
// Visit https://developer.microsoft.com/en-us/graph/docs/authorization/auth_register_app_v2 for instructions on getting a Client Id
NSString *const clientId = @"1aaccdfc-4756-4662-8df4-d15dadde4ab0";
NSString *const redirectUri = @"OneNoteServiceCreatePagesSample://response";

// Base URI for API requests
NSString *const resourceUri = @"https://graph.microsoft.com/beta/me/notes";

NSString *const resourceId = @"https://graph.microsoft.com";
NSString *const authority = @"https://login.microsoftonline.com/common";

