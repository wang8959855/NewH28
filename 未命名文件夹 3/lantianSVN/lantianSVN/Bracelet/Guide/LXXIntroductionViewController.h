//
//  LXXIntroductionViewController.h
//  
//
//  Created by 刘晓霞 on 15/4/23.
//
//

#import <UIKit/UIKit.h>

typedef void(^DidSeclectEnterBlock)();

@interface LXXIntroductionViewController : UIViewController

@property(nonatomic,copy)void(^DidSeclectEnterBlock)();

-(void)setEnterBlock:(DidSeclectEnterBlock)didSeclectEnterBlock;

@end
