// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

// Based on https://swiftrocks.com/avoiding-callback-hell-in-swift.html

import Foundation

// swiftlint:disable:next type_name
typealias Op<Input, Output> = ((Input, @escaping ((Output) -> Void)) -> Void)

infix operator ->>: LogicalConjunctionPrecedence // Precedence of &&

// Both operations has output as `Result`.
func ->> <T, U, V, ErrorT>(_ lhs: @escaping Op<T, Result<U, ErrorT>>, _ rhs: @escaping Op<U, Result<V, ErrorT>>) -> Op<T, Result<V, ErrorT>> where ErrorT: Error {
    return { (input, completion) in
        lhs(input) { outputResult in
            switch outputResult {
            case .success(let output): rhs(output, completion)
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}

// Only lhs operation has `Result`.
func ->> <T, U, V, ErrorT>(_ lhs: @escaping Op<T, Result<U, ErrorT>>, _ rhs: @escaping Op<U, V>) -> Op<T, Result<V, ErrorT>> where ErrorT: Error {
    return { (input, completion) in
        lhs(input) { outputResult in
            switch outputResult {
            case .success(let output): rhs(output) { completion(.success($0)) }
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}

// Only rhs operation has `Result`.
func ->> <T, U, V, ErrorT>(_ lhs: @escaping Op<T, U>, _ rhs: @escaping Op<U, Result<V, ErrorT>>) -> Op<T, Result<V, ErrorT>> where ErrorT: Error {
    return { (input, completion) in
        lhs(input) { output in
            rhs(output, completion)
        }
    }
}
