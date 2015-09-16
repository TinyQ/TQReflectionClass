//
//  TQReflectionClassHelper.h
//  TQReflectionClass
//
//  Created by qfu on 9/16/15.
//  Copyright (c) 2015 qfu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface TQReflectionClassHelper : NSObject

+ (NSDictionary *)dictionaryWithProperty:(objc_property_t)property;

@end
