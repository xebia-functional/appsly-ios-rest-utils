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

@class APPCacheConfig;
@class APPCacheContainer;
@protocol APPCacheManager;


@interface APPCacheService : NSObject

@property(nonatomic, strong) id<APPCacheManager> cacheManager;

+ (APPCacheService *)instance;

- (NSString *)keyWithConfig:(APPCacheConfig *)config forArgs:(NSArray *)args;

- (APPCacheContainer *)cacheWithConfig:(APPCacheConfig *)config forKey:(NSString *)key;

- (void)putCacheWithConfig:(APPCacheConfig *)config forKey:(NSString *)key withValue:(id)value;

@end