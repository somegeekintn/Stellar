//
//  ExDR.swift
//  Stellar
//
//  Created by Casey Fleser on 1/14/18.
//  Copyright © 2018 Quiet Spark. All rights reserved.
//

import Foundation

// See: https://github.com/stellar/js-xdr

protocol XDRDecodable {
	init?(xdr: ExDR, capacity: Int)
}

class ExDR {
	var xdr		= XDR()
	
	init(data: Data) {
		let bytesPtr = UnsafeMutableRawPointer.allocate(bytes: data.count, alignedTo: MemoryLayout<Int8>.alignment)
		let int8Ptr = bytesPtr.bindMemory(to: Int8.self, capacity: data.count)
		let bufPtr = UnsafeMutableBufferPointer<Int8>(start: int8Ptr, count: data.count)
	
		_ = data.copyBytes(to: bufPtr)
		xdrmem_create(&self.xdr, int8Ptr, UInt32(data.count), XDR_DECODE)
	}
	
	func decode<T: XDRDecodable>(capacity: Int = 1) -> T? {
		return T(xdr: self, capacity: capacity)
	}
	
	func decodeBool() -> Bool? {
		var xdrBool		: Bool? = nil
		var xdrValue	= Int32(0)

		if xdr_bool(&self.xdr, &xdrValue) != 0 {
			xdrBool = xdrValue != 0
		}

		return xdrBool
	}
	
	func decodeBytes(_ count: Int, variable: Bool = false) -> [Int8]? {
		var xdrBytes	: [Int8]? = nil
		var xdrValue	: [Int8]
		var xdrCount	= count

		if variable {
			guard let varCount = self.decodeInt32() else { return nil }
			
			xdrCount = Int(varCount)
		}
		
		xdrValue = [Int8](repeating: 0, count: xdrCount)
		if xdr_opaque(&self.xdr, &xdrValue, UInt32(xdrCount)) != 0 {
			xdrBytes = xdrValue
		}
	
		return xdrBytes
	}
	
	func decodeEnum() -> Int32? {
		var xdrEnum		: Int32? = nil
		var xdrValue	= Int32(0)

		if xdr_enum(&self.xdr, &xdrValue) != 0 {
			xdrEnum = xdrValue
		}
		
		return xdrEnum
	}

	func decodeInt32() -> Int32? {
		var xdrInt32	: Int32? = nil
		var xdrValue	= Int32(0)
		
		if xdr_int(&self.xdr, &xdrValue) != 0 {
			xdrInt32 = xdrValue
		}
		
		return xdrInt32
	}
	
	func decodeInt64() -> Int64? {
		var xdrInt64	: Int64? = nil
		var xdrValue	= Int64(0)
		
		if xdr_int64_t(&self.xdr, &xdrValue) != 0 {
			xdrInt64 = xdrValue
		}
		
		return xdrInt64
	}

	func decodeString(_ count: Int) -> String? {
		var xdrString	: String? = nil
		var xdrValue	: UnsafeMutablePointer<Int8>?

		if xdr_string(&self.xdr, &xdrValue, UInt32(count)) != 0 {
			if let utf8Str = xdrValue, let str = String(utf8String: utf8Str) {
				xdrString = str
			}
		}
	
		return xdrString
	}
	
	func decodeUInt32() -> UInt32? {
		var xdrUInt32	: UInt32? = nil
		var xdrValue	= UInt32(0)
		
		if xdr_u_int(&self.xdr, &xdrValue) != 0 {
			xdrUInt32 = xdrValue
		}
		
		return xdrUInt32
	}
	
	func decodeUInt64() -> UInt64? {
		var xdrUInt64	: UInt64? = nil
		var xdrValue	= UInt64(0)
		
		if xdr_u_int64_t(&self.xdr, &xdrValue) != 0 {
			xdrUInt64 = xdrValue
		}
		
		return xdrUInt64
	}
}

enum XDRTestData {
	case payment
	case manageOffer
	case paymentAndOffer
	case createAccount
	case manageData
	case setOptions
	
	// Use https://www.stellar.org/laboratory/#xdr-viewer to confirm that our results match
	
	var blob		: String {
		switch self {
			case .createAccount:
				return "AAAAAERmsKL73CyLV/HvjyQCERDXXpWE70Xhyb6MR5qPO3yQAAAAZAAIbkEAAD0SAAAAAAAAAAOzexCvBJMjKmz6of6SjESMmKtIggAAAAAAAAAAAAAAAAAAAAEAAAABAAAAAP1qe44j+i4uIT+arbD4QDQBt8ryEeJd7a0jskQ3nwDeAAAAAAAAAAATPJHeXCfgFR4lyXyXnsrXcrKOWkRViy8Rcpcd9K6jbQAAAAAMhFYeAAAAAAAAAAGPO3yQAAAAQICJ9+XvhMKK4ni32TswRPrH2HkjBOdPFlvtjmy176bGgMWTZrAXlTqCo06FXEkXDmk71PFroI7/JSOFZgM3Sws="
			case .manageData:
				return "AAAAAJUjgBl6sQVsxDwbt5K1x5t4nBrt6oHp4GeOmadd7PvRAAAAZABk13gAAAADAAAAAAAAAAAAAAABAAAAAAAAAAoAAAAEdGVzdAAAAAEAAABATG9yZW0gaXBzdW0gZG9sb3Igc2l0IGFtZXQsIGNvbnNlY3RldHVyIGFkaXBpc2NpbmcgZWxpdCBwb3N1ZXJlLgAAAAAAAAABXez70QAAAEA+eRHsgtUQxn2VZfp3CpgbrdMTfJ98b4mKgFlkYPaUnbHWNZPBsxjfIi0V/lej5I0p+5hoX246J0PEISQvzhUN"
			case .manageOffer:
				return "AAAAALRKCRGI5VZM3UG3f7U5faC7sTG9fRJQBdgW5WjPX4wvAAAAZACa35wAAH5BAAAAAAAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAUNOWQAAAAAAIkIugebRE9iAkIoVqPSIjMOTqC+vInyXGsAsHNE7ObgAAAAAFUo4PAAAEUEAAAPoAAAAAAAAAAAAAAAAAAAAAc9fjC8AAABAejsy2hf/T2ywYNZZVRI+tQ9G3o9Ox6rHHhd8DbB/+3CJzWcJ4/yK3Aaw1VqDbO0xr2tzV7jljjFnzkASwCGpBg=="
			case .payment:
				return "AAAAAJ2kP2xLaOVLj6DRwX1mMyA0mubYnYvu0g8OdoDqxXuFAAAAZADjfzAAASnUAAAAAAAAAAEAAAATYTVkZmNjYWFjYjZhNGE2N2IxNgAAAAABAAAAAAAAAAEAAAAAfYea3UlYx+oB1SUN7JS071XzM+onRosbwqtnJe/vxAYAAAAAAAAAC+p8h7AAAAAAAAAAAerFe4UAAABAKDztNBWHiXL568wCEcJUaxPbCX0Ixz3E8oJ2FojVe2x/nxlcEAFS6CfFuFI4aNZK26Fefa+b9NY5g1BZO/WyCQ=="
			case .paymentAndOffer:
				return "AAAAAKzv9/fXSZ4/MYBFIgr3eQQz4v5utp4WxVIo5Jik+yY6AAAAyADuV5gAAADTAAAAAAAAAAAAAAACAAAAAQAAAABaSx+NQbFWAINd6rBR6+Ysqe86VFfDq56LYSyxpI7pnQAAAAEAAAAA87a2hY9uVFDaIHqRPGCi6fM2zcIWvwuZJhEWYgmH3CMAAAAAAAAAAABMS0AAAAABAAAAAPO2toWPblRQ2iB6kTxgounzNs3CFr8LmSYRFmIJh9wjAAAAAwAAAAFYTE0AAAAAAGU4n5B07NlUHicOUkSTvzK5R2JFArV8F8IRr/3lSLgQAAAAAUVUSAAAAAAAZTifkHTs2VQeJw5SRJO/MrlHYkUCtXwXwhGv/eVIuBAAAAACEUoMAAAAASMACYloAAAAAAAAAAAAAAAAAAAAA6SO6Z0AAABAWhL5e4sXIJrXOxkSN6uTBdhWVsSxJCRa08rshMYz7tlf1d705BfvjJDGtQVQHRCILqg0zSqe4OOYeWDc40ncCAmH3CMAAABAlCudwa7+d0oaLjZy/lw4C+Ui6wu5dkYrgyEW0DGMVhgNOREnLLVElIgQ0iU0M+iTNvy/ceHI2VZ3qdsm2+SHDlEiycMAAABAH8sQw/6zfyI1XphRsotSx96uFptUI3C7NoQIJ9n5lEaGQjbUYn7NHRjHMY+8cL7YjgB/FWTrzagpylHd6ewnBQ=="
			case .setOptions:
				return "AAAAAJUjgBl6sQVsxDwbt5K1x5t4nBrt6oHp4GeOmadd7PvRAAAAZABk13gAAAABAAAAAAAAAAAAAAABAAAAAAAAAAUAAAABAAAAAJUjgBl6sQVsxDwbt5K1x5t4nBrt6oHp4GeOmadd7PvRAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAV3s+9EAAABAbW3XxL89WhsMpRVFNoT268bwtqQs96FcBtXSeo7IPsBTznxBWBFl3DxKIzNX618OtE0sIPvTPmoG0zaPijbICA=="
		}
	}
}

