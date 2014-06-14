//
//  DFConnector.m
//  PokerDemoTable
//
//  Created by DF on 6/14/14.
//
//

#import "DFConnector.h"

@interface DFConnector () <NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSMutableData *dataBuffer;
@end

@implementation DFConnector

-(id)initWithDelegate:(id <DFConnectorDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}

-(void)downloadDataWithURLString:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_6_1) {
        NSURLConnection *connection  = [NSURLConnection connectionWithRequest:request
                                                                     delegate:self];
        self.connection = connection;
        [connection start];
    }
    else {
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                     delegate:nil
                                                delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             if (error) {
                                                                 [self.delegate connectorDidFailWithError:error];
                                                             }
                                                             else {
                                                                 [self parseData:data];
                                                             }
                                                         }];
        [dataTask resume];
    }
}

#pragma mark - NSURLConnectionDelegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response     {
    NSLog(@"received response with status code %d",(int)((NSHTTPURLResponse *)response).statusCode);
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.dataBuffer = nil;
        [self.delegate connectorDidFailWithError:error];
    });
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (!self.dataBuffer) {
        self.dataBuffer = [NSMutableData dataWithData:data];
    }
    else {
        [self.dataBuffer appendData:data];
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.dataBuffer.length > 0) {
            [self parseData:self.dataBuffer];
        }
    });
}

#pragma mark - Parsing

- (void)parseData:(NSData *)data {
    NSError *error;
    id response = [NSJSONSerialization JSONObjectWithData:data
                                                  options:kNilOptions
                                                    error:&error];
    if (error) {
        [self.delegate connectorDidFailWithError:error];
    }
    else {
        [self.delegate connectorDidFinishLoading:response];
    }
}

@end
