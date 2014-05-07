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


@interface FDAPIResponse : NSObject

@property(nonatomic, strong) NSNumber *status;
@property(nonatomic, strong) NSDictionary *headers;
@property(nonatomic) BOOL hasEntity;
@property(nonatomic, strong) id entity;
@property(nonatomic) BOOL hasError;
@property(nonatomic, strong) id json;
@property(nonatomic, strong) NSError *error;
@property(nonatomic, readonly) BOOL success;
@property(nonatomic, strong) NSNumber * cached;

@end