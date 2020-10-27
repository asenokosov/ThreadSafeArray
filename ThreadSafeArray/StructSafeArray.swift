//
//  StructSafeArray.swift
//  ThreadSafeArray
//
//  Created by Uzver on 27.10.2020.
//

import Foundation

public class ThreadSafeArray<Element> {

	private var saveArray = [Element]()
	private let asyncQueue = DispatchQueue(label: "FokusStart.HomeWork2", attributes: .concurrent)
}

//MARK: Обязательные методы:

extension ThreadSafeArray {

	func appendTSA(_ element: Element){
		asyncQueue.async(flags: .barrier) {
			self.saveArray.append(element)
		}
	}

	func removeTSA(at index: Int){
		asyncQueue.async(flags: .barrier) {
			guard self.saveArray.isEmpty == false else { return print("Данный массив пуст и удалять просто нечего") }
			self.saveArray.remove(at: index)
		}
	}

	subscript(index: Int) -> Element? {
		get {
			var result: Element?
			asyncQueue.async {
				guard self.saveArray.indices.contains(index) else { return }
				result = self.saveArray[index]
			}
			return result
		}
		// В задании действие: "Возвращает элемент с указанным индексом. Про получение речи не было..."

		//		set {
		//			asyncQueue.async(flags: .barrier) {
		//				guard let newValue = newValue else { return }
		//				self.saveArray[index] = newValue
		//			}
		//		}
	}

	func contains(where A: (Element) -> Bool ) -> Bool {
		var result = false
		asyncQueue.sync {
			result = self.saveArray.contains(where: A)
		}
		return result
	}

	func contains2(_ element: Element) -> Bool {
		var result = false
		asyncQueue.sync {
			result = ((try? self.saveArray.contains(where: element as! (Element) throws -> Bool)) != nil)
		}
		return result
	}
}
//MARK: Обязательные свойства:

extension ThreadSafeArray {

	var isEmpty: Bool {
		var result = false
		asyncQueue.sync {
			result = self.saveArray.isEmpty
		}
		return result
	}

	var count: Int {
		var result = 0
		asyncQueue.sync {
			result = self.saveArray.count
		}
		return result
	}
}
