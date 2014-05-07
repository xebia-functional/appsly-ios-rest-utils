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

@class APPCacheContainer;


@protocol APPCacheManager

- (NSString *) keyForArgs:(NSArray *) args;

- (APPCacheContainer *) cacheForKey:(NSString *) key;

- (void) putObject:(id) value forKey:(NSString *) key;

- (void) putObject:(id) value forKey:(NSString *) key timeToLive:(NSTimeInterval) timeToLive;

- (BOOL) remove:(NSString *) key;

@end