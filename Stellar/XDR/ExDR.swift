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
	init?(xdr: ExDR)
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
	
	func decode<T: XDRDecodable>() -> T? {
		return T(xdr: self)
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


