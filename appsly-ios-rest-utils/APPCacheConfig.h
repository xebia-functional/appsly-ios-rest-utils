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


#define kDefaultCacheTimeToLive @3600


typedef enum CachePolicy {

    //
    // Never use the cache
    //
            CachePolicyNever,

    //
    // Load from the cache if we encounter an error
    //
            CachePolicyLoadOnError,

    //
    // Load from the cache if we have data stored
    //
            CachePolicyEnabled,

    //
    // Load from the cache then refresh the cache with a network call (calls subscribers twice if the network reload
    // brings results different from those store in the cache based on the equals and hashcode impl)
    //
            CachePolicyNetworkEnabled
} CachePolicy;

#define kEmptyCacheKey  @""


@interface APPCacheConfig : NSObject
@property(nonatomic, copy) NSString *key;
@property(nonatomic, strong) NSNumber *timeToLive;
@property(nonatomic) enum CachePolicy cachePolicy;
@property(nonatomic) BOOL enforce;

- (instancetype)initWithKey:(NSString *)key timeToLive:(NSNumber *)timeToLive cachePolicy:(enum CachePolicy)cachePolicy;

+ (instancetype) never;

@end

