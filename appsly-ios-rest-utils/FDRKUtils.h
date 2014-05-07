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


#import <Foundation/Foundation.h>

@class FDRequestCallback;


@interface FDRKUtils : NSObject

+ (RKObjectMapping *)responseMappingForObject:(id)object;

+ (void)request:(RKRequestMethod)method path:(NSString *)path manager:(RKObjectManager *)manager success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

+ (void)request:(RKRequestMethod)method responseType:(Class)objectClass path:(NSString *)path queryParams:(NSDictionary *)queryParams manager:(RKObjectManager *)manager success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

+ (void)request:(RKRequestMethod)method object:(id)object path:(NSString *)path manager:(RKObjectManager *)manager success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

+ (void)request:(RKRequestMethod)method object:(id)object responseMapping:(RKObjectMapping *)mapping path:(NSString *)path manager:(RKObjectManager *)manager success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

+ (void)request:(RKRequestMethod)method responseType:(Class)responseType data:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType path:(NSString *)path manager:(RKObjectManager *)manager success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

+ (NSDictionary *)serializeRequest:(id)request withMapping:(RKObjectMapping *)requestMapping forMethod:(RKRequestMethod)method;
@end