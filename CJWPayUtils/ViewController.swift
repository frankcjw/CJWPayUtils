//
//  ViewController.swift
//  CJWPayUtils
//
//  Created by Frank on 8/17/16.
//  Copyright © 2016 Frank. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		let pay = CJWPayUtils()
		let info = CJWPayAlipayInfo()
		// info.appID
		info.privateKey = "MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAKGrVXJpc3MbZBbBpbBFYZj8a6+Z3FYGH7CtjVKB8FvsTswMr8o4F0jsurWRcDMoVNgIh3+HilBDQSIfDxliAWbCENK0XMwJOriJE31L4FHbtTGLo5jf2hf9qMMhzCCqZTj/lRlnU9GPIBT39l4QSX34RUELrgp3U8ugCzB430yRAgMBAAECgYB0CQM1MRaZ4Wj/JFIFqGaaZWHtEWOhopeQOaCbPYQEliEgN2Lco1GjF7YSp6Z+MU5kGAsYr3HIldzj3qL5tuwFbs7PePhoSdQxLiM5b0fzX0+B2ABqZfllUfN+QEJdiqqWRhG11xoS0hOqHcJQKFKWLy5ADioMBh7k739NPTgPIQJBANGY1k2ubws17ssjSPTfy063eqzYPCjo6RcJUIcgGZtKthyDD9Vtu4H4RnV6jFUJ7qAylE9yyNkyWAwdebJRVMUCQQDFdiJNn/pBOtYo4+r2ad2DeROZyIIXSOWbJ2txfco6oZj9kG6veSmGBJJMS/WMxuYkDVLV18dptxypE5QHR41dAkEAyORD65rYZhdgdKWyRLrH4//qfgaXyuJKn0DXRVyYDocSe8uG/ps5kL5F0k4OeWeWp0czbd7n8X3WdG4/+ZEIvQJAaKikpeAVFF3LBQFImDKkZfrWmLvdt9m7WPEb0ZuKhGkCXeMfx4HAsHfb0vSvwV3qvVEShqVH3JBhcHwgCXuzQQJAGpAT0EZWdk2KYQHV2YriFVpMe5BtO9LAyble9eCAq8aEgFVNUmH216dlfLmMfMQ5/Sv5TDSGL2CJOWjjuLy6bg=="
		info.partner = "2088312938260884"
		info.seller = "mark@yangtai.com"
		info.appScheme = "VIPCardPool"
		info.notifyURL = "http://www.cardpool.cc:8080/vipmodule/payorder/alipay/api.do"
		print("\(info.privateKey) \(info.seller)")
		pay.setupAlipay(info)
		pay.pay("0.01", type: CJWPayType.Alipay, success: {
			//
		}) {
			//
		}

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}

