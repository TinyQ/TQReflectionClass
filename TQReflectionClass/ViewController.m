//
//  ViewController.m
//  TQReflectionClass
//
//  Created by qfu on 9/16/15.
//  Copyright (c) 2015 qfu. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+TQReflectionClass.h"

@interface ViewController ()
{
@private
    __strong NSString *_name;
}
@property (atomic,strong) NSString *name;

@end

@implementation ViewController
@dynamic name;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[self class] tq_classes];
//    
//    NSLog(@"%@",[[self class] tq_classes]);
    
    NSString *className = [[self class] tq_className];
    NSLog(@"tq_className : %@",className);
    
    NSString *superclassName = [[self class] tq_superclassName];
    NSLog(@"tq_superclassName : %@",superclassName);
    
    NSArray *propers = [[self class] tq_properties];
    NSLog(@"tq_properties : %@",propers);
//    
//    NSArray *propersFormat = [[[self class] superclass] tq_propertiesWithCodeFormat];
//    
//    NSLog(@"tq_propertiesWithCodeFormat : %@",propersFormat);
    
    NSDictionary *protocols = [[[self class] superclass] tq_protocols];
    NSLog(@"tq_protocols : %@",protocols);
    
//    NSArray *protocolsFormat = [[[self class] superclass] tq_protocolsWithCodeFormat];
//    
//    NSLog(@"tq_protocolsWithCodeFormat : %@",protocolsFormat);
    
    NSArray *instanceVariables = [[[self class] superclass] tq_instanceVariables];
    NSLog(@"instanceVariables : %@",instanceVariables);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
