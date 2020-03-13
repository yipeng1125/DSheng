//
//  DSNetworkManger.m
//  DSheng
//
//  Created by works_yip on 2020/3/9.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSNetworkManger.h"
#import "AFNetworking.h"

#define TIMEOUT_INTERVAL 60

@interface DSNetworkManger()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) dispatch_queue_t backgroundQueue;


@end

@implementation DSNetworkManger

static DSNetworkManger *_manger;


+ (instancetype)shareManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manger = [[DSNetworkManger alloc] init];
    });
    
    return _manger;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _backgroundQueue = dispatch_queue_create("com.ds.dsBackgroundQueue", DISPATCH_QUEUE_CONCURRENT);
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForRequest = TIMEOUT_INTERVAL;
        
        _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
        _sessionManager.securityPolicy.validatesDomainName = NO;
        [_sessionManager setCompletionQueue:_backgroundQueue];
    }
    return self;
}



- (void)sendPostRequesttoUrl:(NSString *)url
                        body:(NSString *)bodystr
                   parameter:(NSDictionary *)paremters
                     success:(reqeustSuccessBlock)successBlock
                     failure:(reqeustFailedBlock)failureBlock {
    
//    _sessionManager.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
 
    NSMutableURLRequest *request = [_sessionManager.requestSerializer requestWithMethod:@"POST"
                                                                              URLString:url
                                                                             parameters:paremters
                                                                                  error:nil];
    if (bodystr) {
        NSData *bodydata = [bodystr dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:bodydata];
        [request setValue:[NSString stringWithFormat:@"%ld", bodydata.length] forHTTPHeaderField:@"Content-Length"];
    }
    
    NSURLSessionDataTask *task = [_sessionManager dataTaskWithRequest:request
                                                       uploadProgress:nil
                                                     downloadProgress:nil
                                                    completionHandler:^(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error){
                                                        if (error) {
                                                            
                                                            NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
                                                            NSLog(@"%@, %@,resposne : %@", responseObject, error, response);
                                                            failureBlock(error);
                                                        } else {
                                                            successBlock(responseObject);
                                                        }
                                                    }];
    

    [task resume];
    
}
@end
