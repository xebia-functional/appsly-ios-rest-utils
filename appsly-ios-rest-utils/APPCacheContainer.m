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

#import "APPCacheContainer.h"

@implementation APPCacheContainer {

}
- (id)initWithValue:(id)value timeToLive:(NSTimeInterval)timeToLive {
    self = [super init];
    if (self) {
        self.value = value;
        self.expiresOn = timeToLive == kTimeToLiveInfinite ? nil : [NSDate dateWithTimeInterval:timeToLive sinceDate:[NSDate date]];
    }

    return self;
}

+ (id)emptyContainer {
    return [APPCacheContainer containerWithValue:nil timeToLive:kTimeToLiveInfinite];
}


+ (id)containerWithValue:(id)value timeToLive:(NSTimeInterval)timeToLive {
    return [[self alloc] initWithValue:value timeToLive:timeToLive];
}


- (BOOL)isAlive {
    return self.expiresOn == nil || [self.expiresOn compare:[NSDate date]] == NSOrderedDescending;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToContainer:other];
}

- (BOOL)isEqualToContainer:(APPCacheContainer *)container {
    if (self == container)
        return YES;
    if (container == nil)
        return NO;
    if (self.expiresOn != container.expiresOn && ![self.expiresOn isEqualToDate:container.expiresOn])
        return NO;
    if (self.value != container.value && ![self.value isEqual:container.value])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [self.expiresOn hash];
    hash = hash * 31u + (NSUInteger) [self.value hash];
    return hash;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.expiresOn = [coder decodeObjectForKey:@"self.expiresOn"];
        self.value = [coder decodeObjectForKey:@"self.value"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.expiresOn forKey:@"self.expiresOn"];
    [coder encodeObject:self.value forKey:@"self.value"];
}


@end