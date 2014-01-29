//
//  TableViewController.m
//  BTCTracker
//
//  Created by Antonio Martinez on 13/12/2013.
//  Copyright (c) 2013 AMG. All rights reserved.
//

#import "TableViewController.h"
#import "Transaction.h"
#import "AppDelegate.h"

@interface TableViewController ()

@property (nonatomic, retain) NSArray *coins;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end

@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    [self loadTransactions];
}

- (void)loadTransactions
{
    NSManagedObjectContext *moc = ((AppDelegate *)([UIApplication sharedApplication].delegate)).managedObjectContext;
    NSFetchRequest *fr = [[NSFetchRequest alloc] initWithEntityName:@"Transaction"];
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    [fr setSortDescriptors:@[sd]];
    self.coins = [moc executeFetchRequest:fr error:nil];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fr managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil];
    [self.fetchedResultsController performFetch:nil];
    
    [self.tableView reloadData];
}

#pragma mark - UITableView Datasource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    
    //Load the transaction into the cell
    Transaction *tr = [self.coins objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%.1f BTC", [tr.coins doubleValue]];
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [nf setNumberStyle: NSNumberFormatterCurrencyStyle];
    [nf setMaximumFractionDigits:1];
    [nf setCurrencySymbol:@"£"];
    cell.detailTextLabel.text = [nf stringFromNumber:[NSNumber numberWithFloat:[tr.value doubleValue]]];
    return cell;
}


@end
