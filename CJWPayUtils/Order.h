//
//  Order.h
//  AlixPayDemo
//
//  Created by 方彬 on 11/2/13.
//
//

#import <Foundation/Foundation.h>

typedef void (^CJWPayBlock)();

@interface Order : NSObject

@property(nonatomic, copy) NSString * partner;
@property(nonatomic, copy) NSString * seller;
@property(nonatomic, copy) NSString * tradeNO;
@property(nonatomic, copy) NSString * productName;
@property(nonatomic, copy) NSString * productDescription;
@property(nonatomic, copy) NSString * amount;
@property(nonatomic, copy) NSString * notifyURL;

@property(nonatomic, copy) NSString * service;
@property(nonatomic, copy) NSString * paymentType;
@property(nonatomic, copy) NSString * inputCharset;
@property(nonatomic, copy) NSString * itBPay;
@property(nonatomic, copy) NSString * showUrl;


@property(nonatomic, copy) NSString * rsaDate;//可选
@property(nonatomic, copy) NSString * appID;//可选

@property(nonatomic, readonly) NSMutableDictionary * extraParams;

-(void)newOrder;

+ (void)checkAccount;

+ (NSString *)generateTradeNO;

-(void)sendOrder:(NSString *)parnter seller:(NSString *)seller productName:(NSString *)productName productDescription:(NSString *)productDescription notifyURL:(NSString *)notifyURL appScheme:(NSString *)appScheme amount:(NSString *)amount privateKey:(NSString *)privateKey success:(CJWPayBlock)success fail:(CJWPayBlock)fail;
-(void)sendOrder:(NSString *)parnter seller:(NSString *)seller productName:(NSString *)productName productDescription:(NSString *)productDescription notifyURL:(NSString *)notifyURL appScheme:(NSString *)appScheme amount:(NSString *)amount privateKey:(NSString *)privateKey;

@end
