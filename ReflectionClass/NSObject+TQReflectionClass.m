//
//  NSObject+TQReflectionClass.m
//  TQReflectionClass
//
//  Created by qfu on 9/16/15.
//  Copyright (c) 2015 qfu. All rights reserved.
//

#import "NSObject+TQReflectionClass.h"
#import "TQReflectionClassHelper.h"
#import <objc/runtime.h>

@implementation NSObject (TQReflectionClass)

+ (NSArray *)tq_classes
{
    NSMutableArray *result = [NSMutableArray array];
    
    unsigned int count;
    Class *classes = objc_copyClassList(&count);
    for (int i = 0; i < count; i++)
    {
        [result addObject:NSStringFromClass(classes[i])];
    }
    free(classes);
    [result sortedArrayUsingSelector:@selector(compare:)];
    
    return result;
}

+ (NSString *)tq_className
{
    return NSStringFromClass([self class]);
}

+ (NSString *)tq_superclassName
{
    return NSStringFromClass([self superclass]);
}

+ (NSArray *)tq_properties
{
    NSMutableArray *propertieArray = [NSMutableArray array];
    
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    
    for (int i = 0; i < propertyCount; i++)
    {
        [propertieArray addObject:({
            
            NSDictionary *dictionary = [TQReflectionClassHelper dictionaryWithProperty:properties[i]];
            
            dictionary;
        })];
    }
    
    free(properties);
    
    return propertieArray;
}

+ (NSArray *)tq_propertiesWithCodeFormat
{
    NSMutableArray *propertieFormatArray = [NSMutableArray array];
    
    NSArray *properties = [[self class] tq_properties];
    
    for (NSDictionary *item in properties)
    {
        NSMutableString *format = [NSMutableString stringWithFormat:@"@property "];
        //attribute
        NSArray *attribute = [item objectForKey:@"attribute"];
        if (attribute && attribute.count > 0)
        {
            //TODO:attributeArray 属性习惯性顺序优化
            
            NSString *attributeStr = [NSString stringWithFormat:@"(%@)",[attribute componentsJoinedByString:@", "]];
            
            [format appendString:attributeStr];
        }
        
        //type
        NSString *type = [item objectForKey:@"type"];
        if (type) {
            [format appendString:@" "];
            [format appendString:type];
        }
        
        //name
        NSString *name = [item objectForKey:@"name"];
        if (name) {
            [format appendString:@" "];
            [format appendString:name];
            [format appendString:@";"];
        }
        
        [propertieFormatArray addObject:format];
    }
    
    
    
    return propertieFormatArray;
}

#pragma mark - helper


@end
