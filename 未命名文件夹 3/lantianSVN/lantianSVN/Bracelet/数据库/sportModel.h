//
//  sportModel.h
//  Bracelet
//
//  Created by 潘峥的MacBook on 2017/2/21.
//  Copyright © 2017年 xiaoxia liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface sportModel : NSObject

@property (retain, nonatomic) NSMutableArray *heartArray;

@property (retain, nonatomic) NSMutableArray *stepArray;

@property (retain, nonatomic) NSMutableArray *BPLArray;

@property (retain, nonatomic) NSMutableArray *BPHArray;

@property (retain, nonatomic) NSMutableArray *statuArray;

@property (retain, nonatomic) NSMutableArray *calmHRArray;

@end
