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

#define kTimeToLiveInfinite -1

@interface APPCacheContainer : NSObject <NSCoding>
@property(nonatomic, strong) NSDate *expiresOn;
@property(nonatomic, strong) id<NSObject, NSCoding> value;

- (BOOL) isAlive;

- (id)initWithValue:(id)value timeToLive:(NSTimeInterval)timeToLive;

+ (id)containerWithValue:(id)value timeToLive:(NSTimeInterval)timeToLive;

+ (id)emptyContainer;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToContainer:(APPCacheContainer *)container;

- (id)initWithCoder:(NSCoder *)coder;

- (void)encodeWithCoder:(NSCoder *)coder;

- (NSUInteger)hash;


@end