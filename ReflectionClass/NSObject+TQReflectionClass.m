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
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *properties = [[self class] tq_properties];
    
    for (NSDictionary *item in properties)
    {
        NSMutableString *format = ({
        
            NSMutableString *formatString = [NSMutableString stringWithFormat:@"@property "];
            //attribute
            NSArray *attribute = [item objectForKey:@"attribute"];
            if (attribute && attribute.count > 0)
            {
                //TODO:attributeArray 属性习惯性顺序优化
                
                NSString *attributeStr = [NSString stringWithFormat:@"(%@)",[attribute componentsJoinedByString:@", "]];
                
                [formatString appendString:attributeStr];
            }
            
            //type
            NSString *type = [item objectForKey:@"type"];
            if (type) {
                [formatString appendString:@" "];
                [formatString appendString:type];
            }
            
            //name
            NSString *name = [item objectForKey:@"name"];
            if (name) {
                [formatString appendString:@" "];
                [formatString appendString:name];
                [formatString appendString:@";"];
            }
            
            formatString;
        });
        
        [array addObject:format];
    }

    return array;
}

+ (NSDictionary *)tq_protocols
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    unsigned int count;
    Protocol * __unsafe_unretained * protocols = class_copyProtocolList([self class], &count);
    for (int i = 0; i < count; i++)
    {
        Protocol *protocol = protocols[i];
        
        NSString *protocolName = [NSString stringWithCString:protocol_getName(protocol) encoding:NSUTF8StringEncoding];
        
        NSMutableArray *superProtocolArray = ({
            
            NSMutableArray *array = [NSMutableArray array];
            
            unsigned int superProtocolCount;
            Protocol * __unsafe_unretained * superProtocols = protocol_copyProtocolList(protocol, &superProtocolCount);
            for (int ii = 0; ii < superProtocolCount; ii++)
            {
                Protocol *superProtocol = superProtocols[ii];
                
                NSString *superProtocolName = [NSString stringWithCString:protocol_getName(superProtocol) encoding:NSUTF8StringEncoding];
                
                [array addObject:superProtocolName];
            }
            free(superProtocols);
            
            array;
        });
        
        [dictionary setObject:superProtocolArray forKey:protocolName];
    }
    free(protocols);
    
    return dictionary;
}

+ (NSArray *)tq_protocolsWithCodeFormat
{
    NSMutableArray *result = [NSMutableArray array];
    
    [[[self class] tq_protocols] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        NSString *protocolName = key;
        NSString *superProtocols = [obj componentsJoinedByString:@", "];
        NSString *description = [NSString stringWithFormat:@"%@ <%@>",protocolName,superProtocols];
        
        [result addObject:description];
    }];
    
    return result;
}

#pragma mark - helper


@end
