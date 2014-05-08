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
#import "RKHTTPUtilities.h"
#import "FDRKObjectManagerProvider.h"

@class FDRequestCallback;
@protocol FDRKRequestMappingProvider;
@protocol FDRKResponseMappingProvider;
@class RKObjectRequestOperation;
@class RKMappingResult;

@interface NSObject (FDAPIOperations)

- (RKObjectManager *) manager;

- (void)get:(Class <FDRKResponseMappingProvider>)responseType path:(NSString *)path request:(id <FDRKRequestMappingProvider>)request callback:(FDRequestCallback *)callback isList:(BOOL)isList;

- (void)get:(Class <FDRKResponseMappingProvider>)responseType path:(NSString *)path params:(NSDictionary *)params callback:(FDRequestCallback *)callback isList:(BOOL)isList;

- (void)mutationRequestWithMethod:(RKRequestMethod)method responseType:(Class <FDRKResponseMappingProvider>)responseType path:(NSString *)path request:(id <FDRKRequestMappingProvider>)request callback:(FDRequestCallback *)callback isList:(BOOL)isList;

- (void)mutationRequestWithMethod:(RKRequestMethod)method responseType:(Class <FDRKResponseMappingProvider>)responseType path:(NSString *)path requestBody:(id <FDRKRequestMappingProvider>)request callback:(FDRequestCallback *)callback isList:(BOOL)isList;

- (void)post:(Class <FDRKResponseMappingProvider>)responseType path:(NSString *)path request:(id <FDRKRequestMappingProvider>)request callback:(FDRequestCallback *)callback isList:(BOOL)isList;

- (void)post:(Class <FDRKResponseMappingProvider>)responseType path:(NSString *)path requestBody:(id <FDRKRequestMappingProvider>)request callback:(FDRequestCallback *)callback isList:(BOOL)isList;

- (void)put:(Class <FDRKResponseMappingProvider>)responseType path:(NSString *)path request:(id <FDRKRequestMappingProvider>)request callback:(FDRequestCallback *)callback isList:(BOOL)isList;

- (void)delete:(Class <FDRKResponseMappingProvider>)responseType path:(NSString *)path request:(id <FDRKRequestMappingProvider>)request callback:(FDRequestCallback *)callback isList:(BOOL)isList;

- (void)handleSuccessForOperation:(RKObjectRequestOperation *)operation mappingResult:(RKMappingResult *)mappingResult onCallback:(FDRequestCallback *)callback isList:(BOOL)isList;

- (void)handleFailureForOperation:(RKObjectRequestOperation *)operation failure:(NSError *)failure onCallback:(FDRequestCallback *)callback;
@end