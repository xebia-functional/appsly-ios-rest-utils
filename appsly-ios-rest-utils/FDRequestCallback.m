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


#import "FDRequestCallback.h"
#import "FDAPIResponse.h"


@implementation FDRequestCallback

- (id)initWithResult:(void (^)(FDAPIResponse *))result {
    self = [super init];
    if (self) {
        _result = result;
        self.cacheConfig = [APPCacheConfig never];
        self.executions = @0;
    }

    return self;
}

- (instancetype)initWithCachePolicy:(APPCacheConfig *)cacheConfig  result:(void (^)(FDAPIResponse *))result {
    self = [super init];
    if (self) {
        self.cacheConfig = cacheConfig;
        self.executions = @0;
        _result = result;
    }

    return self;
}

+ (instancetype)callbackWithCachePolicy:(APPCacheConfig *)cacheConfig  result:(void (^)(FDAPIResponse *))result {
    return [[self alloc] initWithCachePolicy:cacheConfig result:result];
}


+ (id)callbackWithResult:(void (^)(FDAPIResponse *))result {
    return [[self alloc] initWithResult:result];
}

@end