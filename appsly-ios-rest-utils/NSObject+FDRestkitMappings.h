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
#import "RKObjectMapping.h"
#import "FDRKResponseMappingProvider.h"


#define RKSimpleAutoResponseMappings() \
- (RKObjectMapping *)remoteMapping { \
    return [self remoteMappingWithSimpleProperties]; \
}

#define RKSimpleAutoResponseMappingsExcluding(excluded) \
- (RKObjectMapping *)remoteMapping { \
    return [self remoteMappingExcludingProperties:excluded]; \
}


#define RKSimpleRequestMapping() \
- (RKObjectMapping *)requestMapping { \
    return [self requestMappingWithSimpleProperties]; \
}

#define RKResponseMappings(__p) \
- (RKObjectMapping *)remoteMapping { \
    return [self remoteMappingForPropertyAndRelations:[__p objectForKey:@"properties"] relations:[__p objectForKey:@"associations"]]; \
}

#define RKSimpleAutoResponsePascalMappings() \
- (RKObjectMapping *)remoteMapping { \
    return [self remoteMappingWithSimplePascalProperties]; \
}



@interface NSObject (FDRestkitMappings)

- (NSDictionary *)pascalToPropertiesDictionary;

- (NSDictionary *)pascalFromPropertiesDictionary;

- (NSString *)pascalCasePropertyName:(NSString *)propertyName;

- (NSArray *)pascalCasePropertyNames;

- (NSArray *)propertyNames;

- (RKObjectMapping *)requestMappingForPropertyDictAndComplexRelations:(NSDictionary *)array relations:(NSDictionary *)relations;

- (RKObjectMapping *)requestMappingForPropertyAndRelations:(NSArray *)p relations:(NSDictionary *)r;

- (RKObjectMapping *)remoteMappingForPropertyDictAndRelations:(NSDictionary *)p relations:(NSDictionary *)r;

- (RKObjectMapping *)remoteMappingForPropertyDictAndComplexRelations:(NSDictionary *)p relations:(NSDictionary *)r;

- (RKObjectMapping *)remoteMappingForPropertyAndRelations:(NSArray *)p relations:(NSDictionary *)r;

- (RKObjectMapping *)remoteMappingWithSimpleProperties;

- (RKObjectMapping *)remoteMappingWithSimplePascalProperties;

- (RKObjectMapping *)remoteMappingWithSimplePascalPropertiesExcluding:(NSArray *)props;

- (RKObjectMapping *)requestMappingWithSimplePropertiesExcluding:(NSArray *)props;

- (RKObjectMapping *)remoteMappingWithSimplePropertiesExcluding:(NSArray *)props;

- (RKObjectMapping *)requestMappingWithSimpleProperties;

- (RKObjectMapping *)remoteMappingExcludingProperties:(NSArray *)excluded;

- (RKObjectMapping *)remoteMappingWithSimplePropertiesAndRelationships:(NSDictionary *)r;
@end