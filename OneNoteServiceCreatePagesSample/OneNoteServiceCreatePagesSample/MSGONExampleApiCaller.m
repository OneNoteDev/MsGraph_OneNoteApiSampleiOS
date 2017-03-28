
#import "MSGONExampleApiCaller.h"
#import 

@implementation MSGONExampleApiCaller

NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:yourAppURL];
NSString *authHeader = [NSString stringWithFormat:@"Bearer %@", accessToken];
[request addValue:authHeader forHTTPHeaderField:@"Authorization"];

NSOperationQueue *queue = [[NSOperationQueue alloc] init];

[NSURLConnection sendAsynchronousRequest:request
                                   queue:queue
                       completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
 {
    	// Process Response Here
 }];

@end
