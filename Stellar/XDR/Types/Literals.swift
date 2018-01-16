//
//  Literals.swift
//  Stellar
//
//  Created by Casey Fleser on 1/14/18.
//  Copyright © 2018 Quiet Spark. All rights reserved.
//

import Foundation

extension Bool: XDRDecodable {
	init?(xdr: ExDR, capacity: Int = 1) {
		guard let value = xdr.decodeBool() else { return nil }
		
		self = value
	}
}

extension Int32: XDRDecodable {
	init?(xdr: ExDR, capacity: Int = 1) {
		guard let value = xdr.decodeInt32() else { return nil }
		
		self = value
	}
}

extension Int64: XDRDecodable {
	init?(xdr: ExDR, capacity: Int = 1) {
		guard let value = xdr.decodeInt64() else { return nil }
		
		self = value
	}
}

extension UInt32: XDRDecodable {
	init?(xdr: ExDR, capacity: Int = 1) {
		guard let value = xdr.decodeUInt32() else { return nil }
		
		self = value
	}
}

extension UInt64: XDRDecodable {
	init?(xdr: ExDR, capacity: Int = 1) {
		guard let value = xdr.decodeUInt64() else { return nil }
		
		self = value
	}
}

extension String: XDRDecodable {
	init?(xdr: ExDR, capacity: Int) {
		guard let value = xdr.decodeString(capacity) else { return nil }

		self = value
	}
}

extension Optional where Wrapped: XDRDecodable {
	init?(xdr: ExDR, capacity: Int = 1) {
		guard let value = xdr.decodeBool() else { return nil }
		
		if value {
			guard let wrapped = Wrapped(xdr: xdr, capacity: capacity) else { return nil }
			
			self = Optional.some(wrapped)
		}
		else {
			self = Optional.none
		}
	}
}

extension Array where Element: XDRDecodable {
	init?(xdr: ExDR, capacity: Int) {
		guard let count	= xdr.decodeInt32(), count <= capacity  else { return nil }
		
		self.init()
		for _ in 0..<count {
			guard let element : Element = xdr.decode() else { return nil }
			
			self.append(element)
		}
	}
}

