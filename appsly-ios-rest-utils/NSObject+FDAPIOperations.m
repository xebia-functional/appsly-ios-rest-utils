//
//  Appsly REST Utils
//
//  Copyright (c) 2010-2014 47 Degrees LLC. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//


#import <RestKit/Network/RKObjectRequestOperation.h>
#import <RestKit/ObjectMapping/RKMappingResult.h>
#import "NSObject+FDAPIOperations.h"
#import "FDRequestCallback.h"
#import "FDRKRequestMappingProvider.h"
#import "FDRKUtils.h"
#import "APPCacheService.h"
#import "APPCacheContainer.h"
#import "FDAPIResponse.h"


@interface NSObject ()
- (void)processCacheForCallback:(FDRequestCallback *)callback cacheKeyArgs:(NSArray *)args operation:(void (^)(void))operation;

- (void)handleSuccessForOperationWithCachedResult:(id)result onCallback:(FDRequestCallback *)callback retryOp:(void (^)())op;

@end

@implementation NSObject (FDAPIOperations)

- (void) assertPrerequisites {
    assert(self.manager != nil);
}

- (void)get:(Class <FDRKResponseMappingProvider>)responseType path:(NSString *)path request:(id <FDRKRequestMappingProvider>)request callback:(FDRequestCallback *)callback isList:(BOOL)isList {
    [self get:responseType path:path params:request != nil ? [FDRKUtils serializeRequest:request withMapping:[request requestMapping] forMethod:RKRequestMethodGET] : nil callback:callback isList:isList];
}

- (void)get:(Class <FDRKResponseMappingProvider>)responseType path:(NSString *)path params:(NSDictionary *)params callback:(FDRequestCallback *)callback isList:(BOOL)isList {
    [self assertPrerequisites];
    [self processCacheForCallback:callback cacheKeyArgs:[NSArray arrayWithObjects:path, params, nil] operation:^(){
        [FDRKUtils request:RKRequestMethodGET responseType:responseType
                      path:path
               queryParams:params
                   manager:self.manager
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       [FDRKUtils handleSuccessForOperation:operation mappingResult:mappingResult onCallback:callback isList:isList];
                   } failure:^(RKObjectRequestOperation *operation, NSError *failure) {
            [FDRKUtils handleFailureForOperation:operation failure:failure onCallback:callback];
        }
        ];
    }];
}

- (void)mutationRequestWithMethod:(RKRequestMethod)method responseType:(Class <FDRKResponseMappingProvider>)responseType path:(NSString *)path request:(id <FDRKRequestMappingProvider>)request callback:(FDRequestCallback *)callback isList:(BOOL)isList {
    [self assertPrerequisites];
    [self processCacheForCallback:callback cacheKeyArgs:[NSArray arrayWithObjects:path, request, nil] operation:^(){
        [FDRKUtils request:method responseType:responseType
                      path:path
               queryParams:request != nil ? [FDRKUtils serializeRequest:request withMapping:[request requestMapping] forMethod:method] : nil
                   manager:self.manager
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       [FDRKUtils handleSuccessForOperation:operation mappingResult:mappingResult onCallback:callback isList:isList];
                   } failure:^(RKObjectRequestOperation *operation, NSError *failure) {
            [FDRKUtils handleFailureForOperation:operation failure:failure onCallback:callback];
        }
        ];
    }];
}

- (void)mutationRequestWithMethod:(RKRequestMethod)method responseType:(Class <FDRKResponseMappingProvider>)responseType path:(NSString *)path requestBody:(id <FDRKRequestMappingProvider>)request callback:(FDRequestCallback *)callback isList:(BOOL)isList {
    [self assertPrerequisites];
    [self processCacheForCallback:callback cacheKeyArgs:[NSArray arrayWithObjects:path, request, nil] operation:^(){
        Class responseClass = (Class) responseType;
        [FDRKUtils request:method
                    object:request
           responseMapping:[FDRKUtils responseMappingForObject:[[responseClass alloc] init]]
                      path:path
                   manager:self.manager
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       [FDRKUtils handleSuccessForOperation:operation mappingResult:mappingResult onCallback:callback isList:isList];
                   } failure:^(RKObjectRequestOperation *operation, NSError *failure) {
            [FDRKUtils handleFailureForOperation:operation failure:failure onCallback:callback];
        }
        ];
    }];
}

- (void)post:(Class <FDRKResponseMappingProvider>)responseType path:(NSString *)path request:(id <FDRKRequestMappingProvider>)request callback:(FDRequestCallback *)callback isList:(BOOL)isList {
    [self mutationRequestWithMethod:RKRequestMethodPOST responseType:responseType path:path request:request callback:callback isList:isList];
}

- (void)post:(Class <FDRKResponseMappingProvider>)responseType path:(NSString *)path requestBody:(id <FDRKRequestMappingProvider>)request callback:(FDRequestCallback *)callback isList:(BOOL)isList {
    [self mutationRequestWithMethod:RKRequestMethodPOST responseType:responseType path:path requestBody:request callback:callback isList:isList];
}

- (void)put:(Class <FDRKResponseMappingProvider>)responseType path:(NSString *)path request:(id <FDRKRequestMappingProvider>)request callback:(FDRequestCallback *)callback isList:(BOOL)isList {
    [self mutationRequestWithMethod:RKRequestMethodPUT responseType:responseType path:path request:request callback:callback isList:isList];
}

- (void)delete:(Class <FDRKResponseMappingProvider>)responseType path:(NSString *)path request:(id <FDRKRequestMappingProvider>)request callback:(FDRequestCallback *)callback isList:(BOOL)isList {
    [self mutationRequestWithMethod:RKRequestMethodDELETE responseType:responseType path:path request:request callback:callback isList:isList];
}

- (void)processCacheForCallback:(FDRequestCallback *)callback cacheKeyArgs:(NSArray *)args operation:(void (^)(void))operation {
    if (callback.cacheConfig.cachePolicy != CachePolicyNever) {
        APPCacheService *cacheService = [APPCacheService instance];
        callback.cacheConfig.key = callback.cacheConfig.key != nil ? callback.cacheConfig.key : [cacheService keyWithConfig:callback.cacheConfig forArgs:args];
        APPCacheContainer *cacheContainer = [cacheService cacheWithConfig:callback.cacheConfig forKey:callback.cacheConfig.key];
        if (cacheContainer.value) {
//            NSLog(@"CACHE: Returning Cached Result -> %@", cacheContainer.value);
            [FDRKUtils handleSuccessForOperationWithCachedResult:cacheContainer.value onCallback:callback retryOp:operation];
        } else {
            operation();
        }
    } else {
        operation();
    }
}

- (void)handleSuccessForOperationWithCachedResult:(id)result onCallback:(FDRequestCallback *)callback retryOp:(void (^)())op {
    callback.executions = [NSNumber numberWithInt:[callback.executions intValue] + 1];
    FDAPIResponse *response = [[FDAPIResponse alloc] init];
    response.entity = result;
    response.status = @200;
    response.headers = nil;
    response.json = nil;
    response.cached = @YES;
    callback.result(response);
    switch (callback.cacheConfig.cachePolicy) {
        case CachePolicyNetworkEnabled:
            if ([callback.executions isEqualToNumber:@1]) {
//                NSLog(@"CACHE: Calling callback with result for the first time -> %@", response.entity);
                op();
            } else if ([callback.executions isEqualToNumber:@2]) {
//                NSLog(@"CACHE: Called callback with result for a second time with refreshed result -> %@", response.entity);
            }
            break;
        default:
            break;
    }
}

- (void)handleSuccessForOperation:(RKObjectRequestOperation *)operation mappingResult:(RKMappingResult *)mappingResult onCallback:(FDRequestCallback *)callback isList:(BOOL)isList {
    callback.executions = [NSNumber numberWithInt:[callback.executions intValue] + 1];
    FDAPIResponse *response = [[FDAPIResponse alloc] init];
    response.entity = isList ? mappingResult.array : mappingResult.firstObject;
    response.status = [NSNumber numberWithInteger:operation.HTTPRequestOperation.response.statusCode];
    response.headers = operation.HTTPRequestOperation.response.allHeaderFields;
    response.body = [[NSString alloc] initWithData:operation.HTTPRequestOperation.responseData encoding:NSUTF8StringEncoding];
    response.json = operation.mappingResult.dictionary;
    if (response.entity != nil) {
        APPCacheService *cacheService = [APPCacheService instance];
        switch (callback.cacheConfig.cachePolicy) {
            case CachePolicyNever:
                break;
            default:
                [cacheService putCacheWithConfig:callback.cacheConfig forKey:callback.cacheConfig.key withValue:response.entity];
//                NSLog(@"CACHE: Added Result To Cache -> %@", response.entity);
                break;
        }
    }
    if ([response.entity respondsToSelector:@selector(afterRemotePropertiesLoaded)]) {
        [response.entity performSelector:@selector(afterRemotePropertiesLoaded)];
    }
    callback.result(response);
}

- (void)handleFailureForOperation:(RKObjectRequestOperation *)operation failure:(NSError *)failure onCallback:(FDRequestCallback *)callback {
    FDAPIResponse *response = [[FDAPIResponse alloc] init];
    response.status = [NSNumber numberWithInteger:operation.HTTPRequestOperation.response.statusCode];
    response.headers = operation.HTTPRequestOperation.response.allHeaderFields;
    response.json = operation.mappingResult.dictionary;
    response.body = [[NSString alloc] initWithData:operation.HTTPRequestOperation.responseData encoding:NSUTF8StringEncoding];
    response.error = failure;
    APPCacheService *cacheService = nil;
    APPCacheContainer *cacheContainer = nil;
    switch (callback.cacheConfig.cachePolicy) {
        case CachePolicyLoadOnError:
            cacheService = [APPCacheService instance];
            cacheContainer = [cacheService cacheWithConfig:callback.cacheConfig forKey:callback.cacheConfig.key];
            response.entity = cacheContainer.value;
            break;
        default:
            break;
    }
    callback.result(response);
}


@end
