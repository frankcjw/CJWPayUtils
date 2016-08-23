//
//  CJWPayUtils.m
//  CJWPayUtils
//
//  Created by Frank on 8/17/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "CJWPayUtils.h"
#import <AlipaySDK/AlipaySDK.h>
#import "CJWPayOrder.h"

#import "OpenSSL/rsa.h"
#import "OpenSSL/md5.h"
#import "OpenSSL/pem.h"
#import "OpenSSL/bio.h"
#import "OpenSSL/sha.h"
 
//#include <string.h>
#import "DataSigner.h" 


@implementation CJWPayAlipayInfo


@end

@implementation CJWPayUtils


-(void)setupAlipay:(CJWPayAlipayInfo *)info{
//    NSLog(@"key %@ %@",info.privateKey,info.partner);
    self.alipayInfo = info;
//    NSLog(@"key %@",_alipayInfo.privateKey);
}


-(void)payByAliay{
    CJWPayOrder* order = [CJWPayOrder new];
    
    NSString *tradeNO = [self generateTradeNO];
    NSString *notifyURL = _alipayInfo.notifyURL;
    // NOTE: app_id设置
    order.app_id = _alipayInfo.appID;
    //-----------------旧版本信息-----------------------------------
    order.partner = _alipayInfo.partner;
    order.seller = _alipayInfo.seller;
    order.tradeNO = tradeNO;
    order.productName = @"CJWPay Testing";
    order.productDescription = @"Pay Description";
    order.amount = @"0.01";
    order.notifyURL = notifyURL;
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";// 支付类型， 固定值
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m"; //交易超时
    order.showUrl = @"m.alipay.com";
    //-------------------------------------------------------------

    NSString *appScheme = _alipayInfo.appScheme;

    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type设置
    order.sign_type = @"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = @"我是测试数据";
    order.biz_content.subject = @"1";
    order.biz_content.out_trade_no = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f",0.01]; //商品价格
    order.biz_content.seller_id = _alipayInfo.seller;
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSString *orderSpec = [order description];
    
    
    NSLog(@"orderSpec = %@",orderSpec);
    NSLog(@"orderInfo = %@",orderInfo);

    
    if (orderInfo == NULL) {
        NSLog(@"order info null");
        return ;
    }
//    if (orderInfo == NULL) {
//        orderInfo = orderSpec;
//    }
//    orderInfo = orderSpec;
//    orderInfoEncoded = orderSpec;
    

    
    id<DataSigner> signer = CreateRSADataSigner(_alipayInfo.privateKey);
    NSString *signedString = [signer signString:orderInfo];
    
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
//        NSString *appScheme = @"alisdkdemo";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        /**
         *  从旧方法里周到的
         */
//        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                       orderSpec, signedString, @"RSA"];
        NSLog(@"orderString %@",orderString);
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
    
}

-(void)pay:(NSString*)amount type:(CJWPayType)type success:(CJWBlock)success fail:(CJWBlock)fail{
//    CJWPayOrder* order = [CJWPayOrder new];

    switch (type) {
        case CJWPayTypeAlipay:
            [self payByAliay];
            break;
        default:
            break;
    }

}

-(void)initPay{
    //    alip
    [AlipaySDK defaultService];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}

+(instancetype)manager{
    static dispatch_once_t pred = 0;
    static id manager = nil;
    dispatch_once(&pred,
                  ^{
                      manager = [[self alloc] init];
                  });
    return manager;
    
}

- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}



@end
