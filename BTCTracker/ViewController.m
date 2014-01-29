//
//  ViewController.m
//  BTCTracker
//
//  Created by Antonio Martinez on 06/12/2013.
//  Copyright (c) 2013 AMG. All rights reserved.
//

#import "ViewController.h"
#import "Transaction.h"
#import "AppDelegate.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *profitLabel;
@property (weak, nonatomic) IBOutlet UILabel *investedLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *btcGpbRate;
@property (weak, nonatomic) IBOutlet UILabel *btcTotal;
@property (weak, nonatomic) IBOutlet UILabel *lastInfoTime;

@property (nonatomic, strong) NSMutableData *urlData;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) CGFloat sellPrice;
@property (nonatomic, assign) CGFloat totalCoins;
@property (nonatomic, assign) CGFloat totalInvested;

@property (nonatomic, retain) NSArray *coins;

@end

@implementation ViewController

- (void)reloadCoins
{
    
    self.totalInvested = 0.0;
    self.totalCoins = 0.0;
    
    NSManagedObjectContext *moc = ((AppDelegate *)([UIApplication sharedApplication].delegate)).managedObjectContext;
    
    NSFetchRequest *fr = [[NSFetchRequest alloc] initWithEntityName:@"Transaction"];
    NSArray *transactions = [moc executeFetchRequest:fr error:nil];
    
    
    for (Transaction *tr in transactions)
    {
        self.totalInvested += [tr.value doubleValue];
        self.totalCoins += [tr.coins doubleValue];
    }
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self refreshValues];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    NSManagedObjectContext *moc = ((AppDelegate *)([UIApplication sharedApplication].delegate)).managedObjectContext;
//    Transaction *tr1 = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:moc];
//    tr1.coins = [NSNumber numberWithFloat:0.2];
//    tr1.value = [NSNumber numberWithFloat:145];
//    tr1.date = [NSDate date];
//    Transaction *tr2 = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:moc];
//    tr2.coins = [NSNumber numberWithFloat:1.6];
//    tr2.value = [NSNumber numberWithFloat:70];
//    tr2.date = [NSDate date];
//    [moc save:nil];

	
    [self reloadCoins];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self reloadCoins];
    
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(refreshValues) userInfo:nil repeats:YES];
}

- (void)refreshValues
{
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://blockchain.info/ticker"]];
    NSURLConnection *urlConnection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    [urlConnection start];
}

- (void)displayValues {
    
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [nf setNumberStyle: NSNumberFormatterCurrencyStyle];
    [nf setMaximumFractionDigits:0];
    [nf setCurrencySymbol:@"£"];
   
    self.valueLabel.text = [nf stringFromNumber:[NSNumber numberWithFloat:self.sellPrice*self.totalCoins]];
    CGFloat profit = self.sellPrice*self.totalCoins - self.totalInvested;
    self.profitLabel.text = [nf stringFromNumber:[NSNumber numberWithFloat:profit]];
    self.btcGpbRate.text = [nf stringFromNumber:[NSNumber numberWithFloat:self.sellPrice]];
    self.btcTotal.text = [NSString stringWithFormat:@"%.1f",self.totalCoins];
    self.investedLabel.text = [nf stringFromNumber:[NSNumber numberWithFloat:self.totalInvested]];
    
    if (profit < 0)
    {
        self.profitLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:0 blue:0 alpha:1];
    }
    else if (profit > 0)
    {
        self.profitLabel.textColor = [UIColor colorWithRed:0 green:204.0/255.0 blue:0 alpha:1];
    }
    else
    {
        self.profitLabel.textColor = [UIColor whiteColor];
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm:ss, dd MMM"];
    NSString *str_date = [dateFormat stringFromDate:[NSDate date]];
    self.lastInfoTime.text = str_date;
}

#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.urlData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.urlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *jsonParsingError = nil;
    NSDictionary *values = [NSJSONSerialization JSONObjectWithData:self.urlData options:0 error:&jsonParsingError];
    self.sellPrice = [[[values objectForKey:@"GBP"] objectForKey:@"sell"] floatValue];
    
    [self displayValues];
}

@end
