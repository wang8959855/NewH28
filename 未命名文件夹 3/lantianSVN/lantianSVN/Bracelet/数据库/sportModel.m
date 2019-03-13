//
//  sportModel.m
//  Bracelet
//
//  Created by 潘峥的MacBook on 2017/2/21.
//  Copyright © 2017年 xiaoxia liu. All rights reserved.
//

#import "sportModel.h"
#import <objc/runtime.h>


@implementation sportModel

- (NSMutableArray *)calmHRArray
{
    if (!_calmHRArray)
    {
        _calmHRArray  = [[NSMutableArray alloc] init];
    }
    return _calmHRArray;
}

- (NSMutableArray *)stepArray
{
    if (!_stepArray)
    {
        _stepArray  = [[NSMutableArray alloc] init];
    }
    return _stepArray;
}

- (NSMutableArray *)heartArray
{
    if (!_heartArray)
    {
        _heartArray  = [[NSMutableArray alloc] init];
    }
    return _heartArray;
}

- (NSMutableArray *)BPHArray
{
    if (!_BPHArray)
    {
        _BPHArray  = [[NSMutableArray alloc] init];
    }
    return _BPHArray;
}

- (NSMutableArray *)BPLArray
{
    if (!_BPLArray)
    {
        _BPLArray  = [[NSMutableArray alloc] init];
    }
    return _BPLArray;
}

- (NSMutableArray *)statuArray
{
    if (!_statuArray)
    {
        _statuArray  = [[NSMutableArray alloc] init];
    }
    return _statuArray;
}






static NSMutableArray *ivars;
+(void)load{ 
    ivars = [NSMutableArray array]; 
    unsigned int numIvars; 
    Ivar *vars = class_copyIvarList(self, &numIvars); 
    for(int i = 0; i < numIvars; i++) { 
        Ivar thisIvar = vars[i]; 
        NSString *name = [NSString stringWithUTF8String:ivar_getName(thisIvar)]; 
        NSString *key = [name substringFromIndex:1]; 
        [ivars addObject:key]; 
    } 
    free(vars); 
} 
- (void)encodeWithCoder:(NSCoder *)enCoder{ 
    for (NSString *propertyName in ivars) { 
        SEL getSel = NSSelectorFromString(propertyName); 
        [enCoder encodeObject:[self performSelector:getSel] forKey:propertyName]; 
    } 
} 
- (id)initWithCoder:(NSCoder *)aDecoder{ 
    for (NSString *propertyName in ivars) { 
        NSString *firstCharater = [propertyName substringToIndex:1].uppercaseString; 
        NSString *setPropertyName = [NSString stringWithFormat:@"set%@%@:",firstCharater,[propertyName substringFromIndex:1]]; 
        SEL setSel = NSSelectorFromString(setPropertyName); 
        [self performSelector:setSel withObject:[aDecoder decodeObjectForKey:propertyName]]; 
    } 
    return  self; 
}

@end
