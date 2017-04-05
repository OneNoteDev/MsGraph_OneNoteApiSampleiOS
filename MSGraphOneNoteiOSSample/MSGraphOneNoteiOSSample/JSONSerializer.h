//
//  JSONSerializer.h
//  OneNoteServiceCreatePagesSample
//
//  Created by Stefanie Hansen on 3/30/17.
//  Copyright © 2017 Microsoft Corporation. All rights reserved.
//

@interface NSObject (BVJSONString)
-(NSString*) jsonStringWithPrettyPrint:(BOOL) prettyPrint;
@end
