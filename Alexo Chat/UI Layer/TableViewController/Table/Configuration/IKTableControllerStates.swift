//
//  IKTableControllerStates.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

// MARK: - Data states
public enum IKTableContentState {
    case success                    //Успешно загрузилось
    case noContent                  //пришел пустой список
    case failedLoaded               //Ошибка загрузки
    case failedNextPageLoaded       //ошибка загрузки след. страницы
    case endFetching                //Конец постраничной загрузки
}

// MARK: - Process state
public enum IKTableProcessState {
    case loading                    //Процесс загрузки
    case stopped                    //Нет никаких процессов
}
