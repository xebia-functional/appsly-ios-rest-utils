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

#import "APPPersistentCacheManager.h"
#import "APPCacheContainer.h"

#define kCacheExtension @".cache.plist"
#define kAppAppCacheDataFile [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] stringByAppendingString:kCacheExtension]

@interface APPPersistentCacheManager ()
@property(nonatomic, strong) NSMutableDictionary *cache;

- (void)loadCache;

- (void)persistCache;
@end

@implementation APPPersistentCacheManager

- (id)init {
    self = [super init];
    if (self) {
        [self loadCache];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(persistCache) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }

    return self;
}

+ (APPPersistentCacheManager *)instance {
    static APPPersistentCacheManager *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (void)loadCache {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    if (self.cache == nil) {
        NSString *filePath = [documentsPath stringByAppendingPathComponent:kAppAppCacheDataFile];
        self.cache = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        if (self.cache == nil) {
            self.cache = [NSMutableDictionary dictionary];
            NSLog(@"Cache created from scratch, none found on disk");
        } else {
            NSLog(@"Cache loaded from disk");
        }
    }
}

- (void)persistCache {
    //save the data to disk; this causes "encodeWithCoder" to be called

    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:kAppAppCacheDataFile];
    [NSKeyedArchiver archiveRootObject:self.cache toFile:filePath];
    NSLog(@"Cache persisted to disk");
}


- (NSString *)keyForArgs:(NSArray *)args {
    NSMutableArray *argsHashes = [NSMutableArray arrayWithCapacity:[args count]];
    for (id arg in args) {
        NSString *hash = nil;
        if ([arg isKindOfClass:[NSArray class]]){
            hash = [self keyForArgs:arg];
        } else if([arg isKindOfClass:[NSDictionary class]]){
            hash = [self keyForArgs:[arg allValues]];
        }else{
            hash = [NSString stringWithFormat:@"%@", [NSNumber numberWithUnsignedInteger:[arg hash]]];
        }
        [argsHashes addObject:hash];
    }
    return [argsHashes componentsJoinedByString:@"_"];
}

- (APPCacheContainer *)cacheForKey:(NSString *)key {
    APPCacheContainer *result = [APPCacheContainer emptyContainer];
    APPCacheContainer *container = [self containerForKey:key];
    if ([container isAlive]) {
        result = container;
    } else {
        [self remove:key];
        NSLog(@"APPSLY CACHE EXPIRED -> [%@, %@]", key, container.value);
    }
    return result;
}

- (void)putObject:(id)value forKey:(NSString *)key {
    [self putObject:value forKey:key timeToLive:kTimeToLiveInfinite];
}

- (void)putObject:(id)value forKey:(NSString *)key timeToLive:(NSTimeInterval)timeToLive {
    [self.cache setObject:[APPCacheContainer containerWithValue:value timeToLive:timeToLive] forKey:key];
}

- (BOOL)remove:(NSString *)key {
    [self.cache removeObjectForKey:key];
    return [self.cache objectForKey:key] == nil;
}

- (APPCacheContainer *) containerForKey: (NSString *) key  {
    id foundContainer = [self.cache objectForKey:key];
    return foundContainer != nil ? foundContainer : [APPCacheContainer emptyContainer];
}

@end