//
//  CJWPayUtils.h
//  CJWPayUtils
//
//  Created by Frank on 8/17/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WXApi.h"



typedef void (^CJWPaySuccessBlock)(id response);
typedef void (^CJWPayFailBlock)();
typedef void (^CJWPayBlock)();



@interface CJWPayAlipayInfo : NSObject

@property (copy, nonatomic) NSString *privateKey;
@property (copy, nonatomic) NSString *partner;
@property (copy, nonatomic) NSString *seller;

@property (copy, nonatomic) NSString *notifyURL;
@property (copy, nonatomic) NSString *appScheme;

@property (copy, nonatomic) NSString *rsaDate;//可选
@property (copy, nonatomic) NSString *appID;//可选

//@property (strong, nonatomic) NSString *appScheme;
//@property (strong, nonatomic) NSString *appScheme;
//@property (strong, nonatomic) NSString *appScheme;
//@property (strong, nonatomic) NSString *appScheme;

@end


@interface CJWWXPayInfo : NSObject

@property (copy, nonatomic) NSString *wxid;//可选

//@property (strong, nonatomic) NSString *appScheme;
//@property (strong, nonatomic) NSString *appScheme;
//@property (strong, nonatomic) NSString *appScheme;
//@property (strong, nonatomic) NSString *appScheme;

@end

@interface CJWPayUtils : NSObject <WXApiDelegate>


@property (nonatomic, strong) CJWPayAlipayInfo *alipayInfo;

typedef void (^CJWBlock)();

typedef NS_ENUM (NSInteger,CJWPayType){
    CJWPayTypeAlipay=0,//支付宝
    CJWPayTypeWeChat=1//微信
};


-(void)setupAlipay:(CJWPayAlipayInfo *)info;
-(void)setupWXPay:(CJWWXPayInfo *)info;

-(void)pay:(NSString*)amount type:(CJWPayType)type success:(CJWBlock)success fail:(CJWBlock)fail;

-(void)initPay;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation ;

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options;

+(instancetype)manager;

@end


