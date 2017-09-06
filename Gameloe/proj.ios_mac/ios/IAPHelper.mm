//
//  IAPHelper.m
//  Gameloe
//
//  Created by Rainy on 3/24/15.
//

#import "IAPHelper.h"
#import <StoreKit/StoreKit.h>
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#include "GlobalVariable.h"
#include "CMDErrorData.h"
#define kGameloePaymentURL       @"https://bank.gameloe.com/api/iap"

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";

@interface IAPHelper () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@end

@implementation IAPHelper {
    SKProductsRequest * _productsRequest;
    RequestProductsCompletionHandler _completionHandler;

    NSSet * _productIdentifiers;
    NSMutableSet * _purchasedProductIdentifiers;
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {

    if ((self = [super init])) {

        // Store product identifiers
        _productIdentifiers = productIdentifiers;

        // Check for previously purchased products
        _purchasedProductIdentifiers = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [_purchasedProductIdentifiers addObject:productIdentifier];
                NSLog(@"Previously purchased: %@", productIdentifier);
            } else {
                NSLog(@"Not purchased: %@", productIdentifier);
            }
        }

        // Add self as transaction observer
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

    }
    return self;

}

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
    NSLog(@"requestProductsWithCompletionHandler");
    if (!_completionHandler)
    {
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"prod_pack_01",
                                      @"prod_pack_02",
                                      @"prod_pack_03",
                                      @"prod_pack_04",
                                      @"prod_pack_05",
                                      @"prod_pack_06",
                                      @"prod_pack_07",
                                      nil];
        // 1
        _completionHandler = [completionHandler copy];

        // 2
        _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
        _productsRequest.delegate = self;
        [_productsRequest start];
    }

}

- (BOOL)productPurchased:(NSString *)productIdentifier {
    return [_purchasedProductIdentifiers containsObject:productIdentifier];
}

- (void)buyProduct:(SKProduct *)product {

    NSLog(@"Buying %@...", product.productIdentifier);

    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];

}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {

    NSLog(@"Loaded list of products...");
    _productsRequest = nil;

    NSArray * skProducts = response.products;
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }
    for (SKProduct * skProduct in skProducts) {
        NSLog(@"Found product: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }

    _completionHandler(YES, skProducts);
    _completionHandler = nil;

}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {

    NSLog(@"Failed to load list of products.");
    _productsRequest = nil;

    _completionHandler(NO, nil);
    _completionHandler = nil;

}

#pragma mark SKPaymentTransactionOBserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    };
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"completeTransaction...");
    // Load the receipt from the app bundle.
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
    if (receipt)
    {
        /* No local receipt -- handle the error. */
        sendPayment(receipt);
        /* ... Send the receipt data to your server ... */
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}


void sendPayment(NSData *receipt)
{
    ASIFormDataRequest* requestValidateReceipt = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kGameloePaymentURL]];
    NSString* sid = [NSString stringWithFormat:@"%s", GlobalVariable::m_sSID.c_str()];
    [requestValidateReceipt setPostValue:sid forKey:@"token"];
    NSLog(@"requestValidateReceipt: %@", [receipt base64EncodedStringWithOptions:0]);
    [requestValidateReceipt setPostValue:[receipt base64EncodedStringWithOptions:0] forKey:@"receipt"];
    [requestValidateReceipt setPostValue:@"0" forKey:@"sandbox"];
    [requestValidateReceipt setPostValue:@"38" forKey:@"app_id"];
    [requestValidateReceipt setPostValue:@"ios" forKey:@"platform"];
    [requestValidateReceipt setCompletionBlock:^{
        NSData* data = [requestValidateReceipt responseData];
        NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"requestValidateReceipt: %@", returnString);
        NSDictionary *jsonDataDict = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: nil];
        NSString* code = nil;
        NSString* message = nil;
        double balance = 0;
        code = [jsonDataDict objectForKey:@"code"];
        message = [jsonDataDict objectForKey:@"message"];
        NSLog(@"code: %@", code);
        NSLog(@"message: %@", message);
        if ([code isEqualToString:@"completed"])
        {
            char* end;
            NSString* strBalance = [jsonDataDict objectForKey:@"balance"];
            std::string _strBalance = std::string([strBalance UTF8String]);
            balance = std::strtod(_strBalance.c_str(), &end);
            NSLog(@"balance: %f", balance);
            CMDDoubleData* data = new CMDDoubleData(balance);
            data->autorelease();
            NotificationCenter::getInstance()->postNotification("UPDATE_USER_MONEY", data);
        }
        else
        {
            NSLog(@"requestValidateReceipt Fail!!!!!");
        }
    }];
    [requestValidateReceipt setFailedBlock:^{
        NSLog(@"requestValidateReceipt Fail!!!!! 1");
        NSError *error = [requestValidateReceipt error];
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [requestValidateReceipt startAsynchronous];
    });
}


- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"restoreTransaction...");

    //[self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {

    NSLog(@"failedTransaction...");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }

    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {

    //[_purchasedProductIdentifiers addObject:productIdentifier];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
    
}

- (void)restoreCompletedTransactions {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

@end