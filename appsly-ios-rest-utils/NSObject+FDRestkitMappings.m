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

#import <objc/runtime.h>
#import "NSObject+FDRestkitMappings.h"
#import "RKRelationshipMapping.h"


@implementation NSObject (FDRestkitMappings)

- (NSDictionary *) pascalToPropertiesDictionary {
    return [NSDictionary dictionaryWithObjects:[self propertyNames] forKeys:[self pascalCasePropertyNames]];
}

- (NSDictionary *) pascalFromPropertiesDictionary {
    return [NSDictionary dictionaryWithObjects:[self pascalCasePropertyNames] forKeys:[self propertyNames]];
}

- (NSString *)pascalCasePropertyName:(NSString *)propertyName {
    return [propertyName stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                          withString:[[propertyName substringToIndex:1] capitalizedString]];
}

- (NSArray *)pascalCasePropertyNames {
    NSMutableArray *props = [NSMutableArray array];
    for (NSString *prop in [self propertyNames]) {
        NSString *capped = [self pascalCasePropertyName:prop];
        [props addObject:capped];
    }
    return props;
}

- (NSArray *)propertyNames {
    unsigned int i, count = 0;
    objc_property_t *properties = class_copyPropertyList(self.class, &count);

    if (count == 0) {
        free(properties);
        return (nil);
    }

    NSMutableArray *list = [NSMutableArray array];

    for (i = 0; i < count; i++)
        [list addObject:[NSString stringWithUTF8String:property_getName(properties[i])]];

    return ([list copy]);
}

- (RKObjectMapping *)requestMappingForPropertyDictAndComplexRelations:(NSDictionary *)p relations:(NSDictionary *)r {
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    if (p != nil) {
        [mapping addAttributeMappingsFromDictionary:p];
    }
    if (r != nil) {
        for (id key in [r allKeys]) {
            NSArray *tuple = [r objectForKey:key];
            id currentValue = [self valueForKey:[tuple objectAtIndex:0]];
            Class propertyClass = NSClassFromString([tuple objectAtIndex:1]);
            RKObjectMapping *relMapping = nil;
            if (currentValue != nil && [currentValue isKindOfClass:propertyClass]) {
                relMapping = [currentValue requestMapping];
            } else {
                relMapping = [[[NSClassFromString([tuple objectAtIndex:1]) alloc] init] requestMapping];
            }
            [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:[tuple objectAtIndex:0] toKeyPath:key withMapping:relMapping]];
        }
    }
    return mapping;
}

- (RKObjectMapping *)requestMappingForPropertyAndRelations:(NSArray *) p  relations :(NSDictionary *) r {
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    if (p != nil) {
        [mapping addAttributeMappingsFromArray:p];
    }
    if (r != nil) {
        for (id key in [r allKeys]) {
            RKObjectMapping *relMapping = [[[NSClassFromString([r objectForKey:key]) alloc] init] requestMapping];
            [mapping addRelationshipMappingWithSourceKeyPath:key mapping:relMapping];
        }
    }
    return mapping;
}


- (RKObjectMapping *)remoteMappingForPropertyDictAndRelations:(NSDictionary *) p  relations :(NSDictionary *) r {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self.class];
    if (p != nil) {
        [mapping addAttributeMappingsFromDictionary:p];
    }
    if (r != nil) {
        for (id key in [r allKeys]) {
            RKObjectMapping *relMapping = [[[NSClassFromString([r objectForKey:key]) alloc] init] remoteMapping];
            [mapping addRelationshipMappingWithSourceKeyPath:key mapping:relMapping];
        }
    }
    return mapping;
}

- (RKObjectMapping *)remoteMappingForPropertyDictAndComplexRelations:(NSDictionary *) p  relations :(NSDictionary *) r {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self.class];
    if (p != nil) {
        [mapping addAttributeMappingsFromDictionary:p];
    }
    if (r != nil) {
        for (id key in [r allKeys]) {
            NSArray *tuple = [r objectForKey:key];
            RKObjectMapping *relMapping = [[[NSClassFromString([tuple objectAtIndex:1]) alloc] init] remoteMapping];
            [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:[tuple objectAtIndex:0] toKeyPath:key withMapping:relMapping]];
        }
    }
    return mapping;
}


- (RKObjectMapping *)remoteMappingForPropertyAndRelations:(NSArray *) p  relations :(NSDictionary *) r {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self.class];
    if (p != nil) {
        [mapping addAttributeMappingsFromArray:p];
    }
    if (r != nil) {
        for (id key in [r allKeys]) {
            RKObjectMapping *relMapping = [[[NSClassFromString([r objectForKey:key]) alloc] init] remoteMapping];
            [mapping addRelationshipMappingWithSourceKeyPath:key mapping:relMapping];
        }
    }
    return mapping;
}

- (RKObjectMapping *)remoteMappingWithSimpleProperties {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self.class];
    [mapping addAttributeMappingsFromArray:[self propertyNames]];
    return mapping;
}

- (RKObjectMapping *)remoteMappingWithSimplePascalProperties {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self.class];
    [mapping addAttributeMappingsFromDictionary:[self pascalToPropertiesDictionary]];
    return mapping;
}

- (RKObjectMapping *)remoteMappingWithSimplePascalPropertiesExcluding:(NSArray *) props {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self.class];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self pascalToPropertiesDictionary]];
    [dict removeObjectsForKeys:props];
    [mapping addAttributeMappingsFromDictionary:dict];
    return mapping;
}

- (RKObjectMapping *)requestMappingWithSimplePropertiesExcluding:(NSArray *) props {
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self propertyNames]];
    [array removeObjectsInArray:props];
    [mapping addAttributeMappingsFromArray:array];
    return mapping;
}



- (RKObjectMapping *)remoteMappingWithSimplePropertiesExcluding:(NSArray *) props {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self.class];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self propertyNames]];
    [array removeObjectsInArray:props];
    [mapping addAttributeMappingsFromArray:array];
    return mapping;
}

- (RKObjectMapping *)requestMappingWithSimpleProperties {
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    NSMutableArray *props = [NSMutableArray array];
    for (NSString *prop in [self propertyNames]) {
        if ([self valueForKey:prop] != nil) {
            [props addObject:prop];
        }
    }
    [mapping addAttributeMappingsFromArray:props];
    return mapping;
}

- (RKObjectMapping *)remoteMappingExcludingProperties:(NSArray *) excluded {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self.class];
    NSMutableArray *props = [NSMutableArray arrayWithArray:[self propertyNames]];
    [props removeObjectsInArray:excluded];
    [mapping addAttributeMappingsFromArray:props];
    return mapping;
}


- (RKObjectMapping *)remoteMappingWithSimplePropertiesAndRelationships:(NSDictionary *)r {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self.class];
    NSMutableArray *props = [NSMutableArray arrayWithArray:[self propertyNames]];
    // Remove the relationships from the mapping
    [props removeObjectsInArray:[r allKeys]];
    [mapping addAttributeMappingsFromArray:props];
    if (r != nil) {
        for (id key in [r allKeys]) {
            RKObjectMapping *relMapping = [[[NSClassFromString([r objectForKey:key]) alloc] init] remoteMapping];
            [mapping addRelationshipMappingWithSourceKeyPath:key mapping:relMapping];
        }
    }
    return mapping;
}



@end