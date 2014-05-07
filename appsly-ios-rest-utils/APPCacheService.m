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


#import "APPCacheService.h"
#import "APPCacheConfig.h"
#import "APPCacheContainer.h"
#import "APPCacheManager.h"
#import "APPEphemeralCacheManager.h"


@implementation APPCacheService
+ (APPCacheService *)instance {
    static APPCacheService *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
            _instance.cacheManager = [APPEphemeralCacheManager instance];
        }
    }

    return _instance;
}


- (NSString *)keyWithConfig:(APPCacheConfig *)config forArgs:(NSArray *)args {
    return [self.cacheManager keyForArgs:args];
}

- (APPCacheContainer *)cacheWithConfig:(APPCacheConfig *)config forKey:(NSString *)key {
    return [self.cacheManager cacheForKey:key];
}

- (void)putCacheWithConfig:(APPCacheConfig *)config forKey:(NSString *)key withValue:(id)value {
    return [self.cacheManager putObject:value forKey:key timeToLive:[config.timeToLive intValue]];
}


@end