//
//  Helpers.swift
//  composing-playground
//
//  Created by Василий Клецкин on 10.05.2023.
//

import Foundation

typealias Cancellable = () -> Void
typealias LoaderResult<T> = Result<T, Error>
typealias LoaderCompletion<T> = (LoaderResult<T>) -> Void

typealias Loader<Output> = (@escaping LoaderCompletion<Output>) -> Cancellable
