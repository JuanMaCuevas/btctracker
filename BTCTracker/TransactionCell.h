//
//  TransactionCell.h
//  BTCTracker
//
//  Created by Antonio Martinez on 17/12/2013.
//  Copyright (c) 2013 AMG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UILabel *displayLabel;
@property (nonatomic, strong) IBOutlet UITextField *fakeTextField;

@end
