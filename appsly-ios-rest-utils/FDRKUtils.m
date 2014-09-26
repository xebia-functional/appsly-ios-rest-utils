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
#import <RestKit/Network/RKObjectParameterization.h>
#import <RestKit/Network/RKResponseDescriptor.h>
#import <objc/runtime.h>
#import <RestKit/Network/RKObjectManager.h>
#import "FDRKUtils.h"
#import "FDRKResponseMappingProvider.h"
#import "NSObject+FDAPIOperations.h"
#import "RKObjectManager.h"
#import "RKObjectRequestOperation.h"
#import "RKMappingResult.h"


@interface FDRKUtils ()
+ (RKObjectMapping *)requestMappingForObject:(id)object;

+ (void)request:(RKRequestMethod)method object:(id)object responseDescriptor:(RKResponseDescriptor *)responseDescriptor path:(NSString *)path manager:(RKObjectManager *)manager success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;
@end

@implementation FDRKUtils

+ (RKObjectMapping *)requestMappingForObject:(id)object {
    RKObjectMapping *mapping = nil;
    if ([object respondsToSelector:@selector(requestMapping)]) {
        mapping = [object requestMapping];
    } else {
        [NSException raise:@"Object does not explicitly or indirectly conform to @protocol FDRKRequestMappingProvider" format:@"object type %@ is invalid", object];
    }
    return mapping;
}

+ (RKObjectMapping *)responseMappingForObject:(id)object {
    RKObjectMapping *mapping = nil;
    if ([object respondsToSelector:@selector(remoteMapping)]) {
        mapping = [object remoteMapping];
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        mapping = [RKObjectMapping mappingForClass:[NSDictionary class]];
    } else {
        [NSException raise:@"Object does not explicitly or indirectly conform to @protocol FDRKResponseMappingProvider" format:@"object type %@ is invalid", object];
    }
    return mapping;
}

+ (void)request:(RKRequestMethod)method
           path:(NSString *)path
        manager:(RKObjectManager *)manager
        success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
        failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure {
    NSAssert(path, @"Cannot make a request without a path.");
    NSMutableURLRequest *urlRequest = [manager requestWithObject:nil method:method path:path parameters:nil];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:urlRequest responseDescriptors:@[]];
    [operation setCompletionBlockWithSuccess:success failure:failure];
    [manager enqueueObjectRequestOperation:operation];
}

+ (void)request:(RKRequestMethod)method
   responseType:(Class)objectClass
           path:(NSString *)path
    queryParams:(NSDictionary *)queryParams
        manager:(RKObjectManager *)manager
        success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
        failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure {
    NSAssert(objectClass || path, @"Cannot make a request without an object or a path.");
    RKObjectMapping *mapping = [FDRKUtils responseMappingForObject:[[objectClass alloc] init]];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:method pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    NSMutableURLRequest *urlRequest = [manager requestWithObject:nil method:method path:path parameters:queryParams];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:urlRequest responseDescriptors:@[responseDescriptor]];
    [operation setCompletionBlockWithSuccess:success failure:failure];
    [manager enqueueObjectRequestOperation:operation];
}

+ (void)request:(RKRequestMethod)method
         object:(id)object
           path:(NSString *)path
        manager:(RKObjectManager *)manager
        success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
        failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure {
    [FDRKUtils request:method object:object responseMapping:[FDRKUtils responseMappingForObject:object] path:path manager:manager success:success failure:failure];
}

+ (void)request:(RKRequestMethod)method
         object:(id)object
responseMapping:(RKObjectMapping *)mapping
           path:(NSString *)path
        manager:(RKObjectManager *)manager
        success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
        failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure {
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:method pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [FDRKUtils request:method object:object responseDescriptor:responseDescriptor path:path manager:manager success:success failure:failure];
}


+ (void)request:(RKRequestMethod)method
            object:(id)object
responseDescriptor:(RKResponseDescriptor *)responseDescriptor
              path:(NSString *)path
           manager:(RKObjectManager *)manager
           success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
           failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure {
    NSAssert(object || path, @"Cannot make a request without an object or a path.");
    RKObjectMapping *requestMapping = [FDRKUtils requestMappingForObject:object];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:requestMapping.objectClass rootKeyPath:nil method:method];
    NSError *requestSerializationError = nil;
    NSDictionary *parameters = [RKObjectParameterization parametersWithObject:object requestDescriptor:requestDescriptor error:&requestSerializationError];
    NSAssert(requestSerializationError == nil, @"Error serializing %@", requestSerializationError);
    NSMutableURLRequest *urlRequest = [manager requestWithObject:object method:method path:path parameters:parameters];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:urlRequest responseDescriptors:@[responseDescriptor]];
    [operation setCompletionBlockWithSuccess:success failure:failure];
    [manager enqueueObjectRequestOperation:operation];
}

+ (void) request:(RKRequestMethod)method
responseType:(Class)responseType
              data:(NSData *)data
              name:(NSString *)name
          fileName:(NSString *)fileName
          mimeType:(NSString *)mimeType
              path:(NSString *)path
           manager:(RKObjectManager *)manager
           success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
           failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure {
    NSMutableURLRequest *urlRequest = [manager multipartFormRequestWithObject:@{} method:method path:path parameters:nil constructingBodyWithBlock:^(id <AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data
                                    name:name
                                fileName:fileName
                                mimeType:mimeType];
    }];
    RKObjectMapping *mapping = [FDRKUtils responseMappingForObject:[[responseType alloc] init]];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:method pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:urlRequest responseDescriptors:@[responseDescriptor]];
    [operation setCompletionBlockWithSuccess:success failure:failure];
    [manager enqueueObjectRequestOperation:operation];
}

+ (void) request:(RKRequestMethod)method
    responseType:(Class)responseType
            data:(NSData *)data
            name:(NSString *)name
        fileName:(NSString *)fileName
        mimeType:(NSString *)mimeType
        formFields:(NSDictionary *)formFields
            path:(NSString *)path
         manager:(RKObjectManager *)manager
         success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
         failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure {
    NSMutableURLRequest *urlRequest = [manager multipartFormRequestWithObject:@{} method:method path:path parameters:nil constructingBodyWithBlock:^(id <AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data
                                    name:name
                                fileName:fileName
                                mimeType:mimeType];


        for (NSString *key in [formFields allKeys]) {
            [formData appendPartWithFormData:[formFields objectForKey:key] name:key];
        }
    }];
    RKObjectMapping *mapping = [FDRKUtils responseMappingForObject:[[responseType alloc] init]];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:method pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:urlRequest responseDescriptors:@[responseDescriptor]];
    [operation setCompletionBlockWithSuccess:success failure:failure];
    [manager enqueueObjectRequestOperation:operation];
}


+ (NSDictionary *)serializeRequest:(id)request withMapping:(RKObjectMapping *)requestMapping forMethod:(RKRequestMethod)method {
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:requestMapping.objectClass rootKeyPath:nil method:method];
    NSError *requestSerializationError = nil;
    NSDictionary *params = [RKObjectParameterization parametersWithObject:request requestDescriptor:requestDescriptor error:&requestSerializationError];
    NSAssert(requestSerializationError == nil, @"Error serializing %@", requestSerializationError);
    return params;
}



@end