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
#import "Order.h"


#define PRIVATE_KEY @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAKGrVXJpc3MbZBbBpbBFYZj8a6+Z3FYGH7CtjVKB8FvsTswMr8o4F0jsurWRcDMoVNgIh3+HilBDQSIfDxliAWbCENK0XMwJOriJE31L4FHbtTGLo5jf2hf9qMMhzCCqZTj/lRlnU9GPIBT39l4QSX34RUELrgp3U8ugCzB430yRAgMBAAECgYB0CQM1MRaZ4Wj/JFIFqGaaZWHtEWOhopeQOaCbPYQEliEgN2Lco1GjF7YSp6Z+MU5kGAsYr3HIldzj3qL5tuwFbs7PePhoSdQxLiM5b0fzX0+B2ABqZfllUfN+QEJdiqqWRhG11xoS0hOqHcJQKFKWLy5ADioMBh7k739NPTgPIQJBANGY1k2ubws17ssjSPTfy063eqzYPCjo6RcJUIcgGZtKthyDD9Vtu4H4RnV6jFUJ7qAylE9yyNkyWAwdebJRVMUCQQDFdiJNn/pBOtYo4+r2ad2DeROZyIIXSOWbJ2txfco6oZj9kG6veSmGBJJMS/WMxuYkDVLV18dptxypE5QHR41dAkEAyORD65rYZhdgdKWyRLrH4//qfgaXyuJKn0DXRVyYDocSe8uG/ps5kL5F0k4OeWeWp0czbd7n8X3WdG4/+ZEIvQJAaKikpeAVFF3LBQFImDKkZfrWmLvdt9m7WPEb0ZuKhGkCXeMfx4HAsHfb0vSvwV3qvVEShqVH3JBhcHwgCXuzQQJAGpAT0EZWdk2KYQHV2YriFVpMe5BtO9LAyble9eCAq8aEgFVNUmH216dlfLmMfMQ5/Sv5TDSGL2CJOWjjuLy6bg=="



@implementation CJWPayAlipayInfo


@end

@implementation CJWWXPayInfo


@end


@interface CJWPayUtils()

@property CJWPayBlock success;
@property CJWPayBlock fail;
@property CJWPayBlock cancel;

@end
@implementation CJWPayUtils


//-(void)setupAlipay:(CJWPayAlipayInfo *)info{
//     self.alipayInfo = info;
// }
//
//
//-(void)setupWXPay:(CJWWXPayInfo *)info{
//    [WXApi registerApp:info.wxid withDescription:@"2.0"];
//}


-(void)payByWeChat:(NSString *)appid noncestr:(NSString *)noncestr package:(NSString *)package partnerid:(NSString *)partnerid prepayid:(NSString *)prepayid sign:(NSString *)sign timestamp:(NSString *)timestamp {
    UInt32 time = [[NSNumber alloc] initWithInt:timestamp.intValue].unsignedIntValue;
    PayReq *req = [[PayReq alloc] init];
    req.partnerId = partnerid;
    req.prepayId = prepayid;
    req.nonceStr = noncestr;
    req.timeStamp = time;
    req.package = package;
    req.sign = sign;
    BOOL flag = [WXApi sendReq:req];
    if (flag) {
        NSLog(@"paying");
    }else{
        NSLog(@"pay fail");
    }
    
}

-(void)payByAli:(NSString *)parnter seller:(NSString *)seller productName:(NSString *)productName productDescription:(NSString *)productDescription notifyURL:(NSString *)notifyURL appScheme:(NSString *)appScheme amount:(NSString *)amount privateKey:(NSString *)privateKey tradeNO:(NSString *)tradeNO{
    Order *order = [[Order alloc]init];
    order.tradeNO = tradeNO;
    [order sendOrder:parnter seller:seller productName:productName productDescription:productDescription notifyURL:notifyURL appScheme:appScheme amount:amount privateKey:privateKey callback:^(NSDictionary *resultDic) {
        [self processAliBlock:resultDic];
    }];
    
}

-(void)payByWechat:(NSString *)appid partnerId:(NSString *)partnerId prepayId:(NSString *)prepayId nonceStr:(NSString *)nonceStr  timeStamp:(NSString *)timeStamp  package:(NSString *)package  sign:(NSString *)sign{
    [WXApi registerApp:appid];
    PayReq *req = [[PayReq alloc] init];
    req.partnerId = partnerId;
    req.prepayId = prepayId;
    req.nonceStr = nonceStr;
    unsigned int time = [[NSNumber numberWithInteger:[timeStamp integerValue]] unsignedIntValue];
    req.timeStamp = time;
    req.package = package;
    req.sign = sign;
    if ([WXApi sendReq:req]) {
    } else{
        [self payFail];
    };
}
 
-(void)setupCallBack:(CJWPayBlock)success cancel:(CJWPayBlock)cancel fail:(CJWPayBlock)fail{
    self.success = success;
    self.fail = fail;
    self.cancel = cancel;
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
    
    [WXApi handleOpenURL:url delegate:self];
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [self processAliBlock:resultDic];
        }];
    }
    return YES;
}

/**
 *  处理支付宝支付回调
 *
 *  @param resultDic resultDic description
 */
-(void)processAliBlock:(NSDictionary *)resultDic{
    NSString *resultStatus = resultDic[@"resultStatus"];
    NSLog(@"reslut = %@-%@",resultDic,resultStatus);
    if ([resultStatus isEqualToString:@"9000"]) {
        [self paySuccess];
    }else if ([resultStatus isEqualToString:@"6001"]) {
        [self payCancel];
    }else{
        [self payFail];
    }
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

-(void)processURL:(NSURL *)url{
    BOOL flag = [WXApi handleOpenURL:url delegate:self];
    NSLog(@"wechat pay %s",flag?"suc":"fai");
}

// MARK: - 微信支付回调
-(void)onReq:(BaseReq *)req{
    NSLog(@"on req");
 }


-(void)paySuccess{
    NSLog(@"paySuccess");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OnPaySuccess" object:NULL];
    if (self.success != NULL) {
        _success();
    }
}

-(void)payCancel{
    NSLog(@"payCancel");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OnPayCancel" object:NULL];
    if (self.cancel != NULL) {
        _cancel();
    }
 }

-(void)payFail{
    NSLog(@"payFail");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OnPayFail" object:NULL];
    if (self.fail != NULL) {
        _fail();
    }
 }


/**
 *  微信支付回调
 *
 *  @param resp resp description
 */
-(void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *reponse = (PayResp*)resp;
        switch (reponse.errCode) {
            case WXSuccess:
                 [self paySuccess];
                break;
            case WXErrCodeUserCancel:
                 [self payCancel];
                break;
            default:
                 [self payFail];
                break;
        }
    }
}

@end

