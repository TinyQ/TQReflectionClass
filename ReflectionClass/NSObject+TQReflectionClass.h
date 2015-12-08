//
//  NSObject+TQReflectionClass.h
//  TQReflectionClass
//
//  Created by qfu on 9/16/15.
//  Copyright (c) 2015 qfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (TQReflectionClass)

+ (NSArray *)tq_classes;

+ (NSString *)tq_className;

+ (NSString *)tq_superclassName;

+ (NSArray *)tq_properties;

+ (NSDictionary *)tq_protocols;

+ (NSArray *)tq_instanceVariables;

+ (NSArray *)tq_classMethods;

+ (NSArray *)tq_propertiesWithCodeFormat;

+ (NSArray *)tq_protocolsWithCodeFormat;

@end
