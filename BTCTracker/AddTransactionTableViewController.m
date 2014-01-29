//
//  AddTransactionTableViewController.m
//  BTCTracker
//
//  Created by Antonio Martinez on 13/12/2013.
//  Copyright (c) 2013 AMG. All rights reserved.
//

#import "AddTransactionTableViewController.h"
#import "TransactionCell.h"
#import "Transaction.h"
#import "AppDelegate.h"


@interface AddTransactionTableViewController ()

@end

@implementation AddTransactionTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

-(void)viewDidLoad
{
    UIButton *add = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [add setTitle:@"Add" forState:UIControlStateNormal];
    add.backgroundColor = [UIColor clearColor];
    add.frame = CGRectMake(0, 0, 150, 50);
    [add addTarget:self action:@selector(addTransaction) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = add;
}

-(void)addTransaction
{
    TransactionCell *cell1 = (TransactionCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    TransactionCell *cell2 = (TransactionCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    NSManagedObjectContext *moc = ((AppDelegate *)([UIApplication sharedApplication].delegate)).managedObjectContext;
    Transaction *tr1 = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:moc];
//    tr1.coins = [NSNumber numberWithFloat:[self getFloatValue:cell1]];
//    tr1.value = [NSNumber numberWithFloat:[self getFloatValue:cell2]];
    tr1.date = [NSDate date];
    [moc save:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TransactionCell *cell = (TransactionCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.fakeTextField becomeFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//- (float)getFloatValue:(TransactionCell *)cell
//{
//    float fullValue = [[cell.nonFormattedValue substringToIndex:1] floatValue];
//    float decimalValue = [[cell.nonFormattedValue substringFromIndex:1] floatValue];
//    
//    float value = fullValue + decimalValue/100;
//    return value;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TransactionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    
    
    float value;
//    value = [self getFloatValue:cell];
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [nf setNumberStyle: NSNumberFormatterCurrencyStyle];
    [nf setMaximumFractionDigits:2];
    if (indexPath.section == 1)
    {
        cell.tag = 1;
        [nf setCurrencySymbol:@"£ "];
//        cell.nonFormattedValue = @"000000";
    }
    else
    {
        [nf setCurrencySymbol:@"BTC "];
//        cell.nonFormattedValue = @"000";
    }
    
    cell.displayLabel.text = [nf stringFromNumber:[NSNumber numberWithFloat:value]];


    cell.fakeTextField.delegate = cell;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    if (section == 0)
    {
        label.textColor = [UIColor whiteColor];
        label.text = @" How many Bitcoins do you want to add?";
        label.font = [UIFont fontWithName:@"Verdana" size:16];
    }
    else
    {
        label.textColor = [UIColor whiteColor];
        label.text = @" How much do they cost (all together)?";
        label.font = [UIFont fontWithName:@"Verdana" size:16];
    }
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}






@end
