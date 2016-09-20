//
//  CJWOrder.swift
//  CJWPayUtils
//
//  Created by Frank on 9/20/16.
//  Copyright © 2016 Frank. All rights reserved.
//

import UIKit

public class CJWOrder: Order {

	public var privateKey = "MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALgGxy4fGQj+g0WqC339yC+ANMU3H+/bgQCRQ95Md3lVkOe3q8+pUEgwrOtHCXO6e3Tir6pyqunawSsKSzthYyEdHeohiDgvEsTH0lqSefYQXa7L/xG23mxlCS4JT5pz6S2yNihdnk4sSObxNuQAv72Fjugds0FAjRHDBmYnMGkXAgMBAAECgYBZmkNFO7MO5A26z88Eq5rbNgt7sxmDylcHlbN7+7N4iqchjBbF5+TFIZ4weMgrZzNReEacMXTypKbFdB+pbAO9eTNVgQvOFPo+AGQfL/yrxxKeqXcJLpXb/Jnr8qXen62CI8jdkkZxJh0b/DyZ/Kp7zSIhxLzSp9CaPnPcc8essQJBAPIp5qU/CD7tGveOXMtWy61jGdsQxZ7LN/HUe8P11pMlovhQpB5+oklwY+6/HvcMV+qnn/SQdKbBk1umCAiyPzUCQQDCioLheNUNXNnIjAFWyl+sr9ydMZnyspOYC9M0/G+9sCktbe/6/vnghGLomTCcPLUUZc53rA3Z5rCVojnDhBSbAkB1iVLSR6q36BtbpnRxmToYeO42vog8j4Qi0zATJ8Iy/2R/Q5y01F/uZyeJ3Kep3wrY8O0ZJfgIbBIavJZPqjw1AkA9bm3L81MbyCFBceyOUpOJvXLl9J7Pg9KVpc5JIhnLBZDLNrccRF31pvhwyMcP3x+zVD6xjZRGJdHHPpYNBm1XAkEAi73K8OXI0DBsccI/wdqrzJs7PmTF7do/ojw/SaP/3mqdJg9IJpoymPhygZeuhXMnbKsBsFWhDTltPMjp6F+OjA=="
//    var

	public func send() {
		self.sendOrder("2088421831693683", seller: "apay@gdyueyun.com", productName: "粤运支付", productDescription: "买了个票", notifyURL: "http://120.77.9.24:8090/pay/alipay/notification", appScheme: "Yravel", amount: "0.01", privateKey: privateKey)
	}

}
