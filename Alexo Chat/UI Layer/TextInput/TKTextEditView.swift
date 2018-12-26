//
//  IKTextEditView.swift
//  IKInterfaceSwift
//
//  Created by admin on 14.09.2018.
//  Copyright © 2018 TAXCOM. All rights reserved.
//

import UIKit

// MARK: - IKTextFieldEditViewDelegate
public protocol IKTextFieldEditViewDelegate: class {
    func textEditViewController(_ textEdit: IKTextEditView, textDidChange text: String?)
    func correctedEditViewController(_ textEdit: IKTextEditView, textDidChange text: String?, corrected: Bool)
    func textFieldShouldReturn(_ textEdit: IKTextEditView, textDidChange text: String?)
}

// MARK: - IKTextFieldEditViewDelegate default realization
public extension IKTextFieldEditViewDelegate {
    func correctedEditViewController(_ textEdit: IKTextEditView, textDidChange text: String?, corrected: Bool) { }
    func textFieldShouldReturn(_ textEdit: IKTextEditView, textDidChange text: String?) { }
}

// MARK: - IKTextEditViewStruct
struct IKTextEditViewStruct {
    static let animationDuration: TimeInterval = 0.15
}

// MARK: - IKTextEditView
/// Компонента ввода текста, без перехода на другой экран
///
/// - Parameter delegate: IKTextFieldEditViewDelegate, делегат возвращаемых значений при вводе
/// - Parameter validator: Валидатор текста, соответствующий протоколу IKTextEditViewValidator
/// - Parameter keyboardType: тип клавиатуры
/// - Parameter isSecureTextEntry: оотбражение текста: ABC или ***
/// - Parameter textAlignment: выравнивание текста
/// - Parameter flashInvalideText: подсвечивать невалидный текст в процессе ввода
///
/// Задать Заголовок
/// setTitle(_ title: String?)
/// setTitle(_ title: NSAttributedString?)
///
/// Задать значение
/// setValue(_ value: String?)
/// setValue(_ value: NSAttributedString?)
///
/// Задать единицу измерения
/// setUnit(_ unit: String)
/// setUnit(_ unit: NSAttributedString)
///
/// PalceHolder
/// setPlaceholder(_ placehodler: String?)
///
/// Задать шрифты
/// setTitleFont(_ font: UIFont)
/// setValueFont(_ font: UIFont)
/// setUnitFont(_ font: UIFont)
///
/// Конец ввода
/// endEditing()
///
/// Цвет каретки
/// setCarriageColor(_ color: UIColor)
///
/// Визуально отобразить с анимацией, что введенный текст неверный, окрашивается текст UItextField и линия "подчеркивания" всего элемента
/// setError(enabled: Bool, animation: Bool)
///
/// Убрать нижнюю линию "подчеркивания" всего элемента
/// setBottomLine(hidden: Bool)

public class IKTextEditView: IKBottomLinedView {

    public weak var delegate: IKTextFieldEditViewDelegate?
    public var validator: IKTextEditViewValidator?
    public var flashInvalideText: Bool = true

    public var keyboardType: UIKeyboardType = .default {
        didSet {
            self.textField.keyboardType = keyboardType
        }
    }
    public var isSecureTextEntry: Bool = false {
        didSet {
            self.textField.isSecureTextEntry = isSecureTextEntry
        }
    }
    public var textAlignment: NSTextAlignment = .right {
        didSet {
            self.textField.textAlignment = textAlignment
        }
    }

    private var titleLabel = UILabel.makeLabel(size: 13, weight: .regular, color: UIColor.RGB(r: 200, g: 199, b: 204))
    public var textField = UITextField()
    private var unitLabel = UILabel.makeLabel(size: 15)

    private var textFieldColor: UIColor! = nil
    private var errorEnabled: Bool = false

    // MARK: - Init
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public convenience init(title: String? = nil, value: String? = nil, unit: String? = nil, insets: UIEdgeInsets = .zero) {
        self.init(title: NSAttributedString(string: title ?? ""), value: NSAttributedString(string: value ?? ""), unit: NSAttributedString(string: unit ?? ""), insets: insets)
    }

    public init(title: NSAttributedString? = nil, value: NSAttributedString? = nil, unit: NSAttributedString? = nil, insets: UIEdgeInsets = .zero) {
        super.init(frame: .zero, insets: insets)
        self.titleLabel.attributedText = title
        self.titleLabel.textAlignment = .left
        self.textField.attributedText = value
        self.unitLabel.attributedText = unit
        self.unitLabel.textAlignment = .right

        self.createUI()

        if let unit = unit, !unit.string.isEmpty {
            self.createUnitLabel()
        }
    }
}

// MARK: - Public
extension IKTextEditView {

    //Заголовок
    public func setTitle(_ title: String?) {
        self.titleLabel.text = title
    }

    public func setTitle(_ title: NSAttributedString?) {
        self.titleLabel.attributedText = title
    }

    //Значение
    public func setValue(_ value: String?) {
        self.textField.text = value
    }

    public func setValue(_ value: NSAttributedString?) {
        self.textField.attributedText = value
    }

    //Единица измерения
    public func setUnit(_ unit: String) {
        self.setUnit(NSAttributedString(string: unit))
    }

    public func setUnit(_ unit: NSAttributedString) {
        self.unitLabel.attributedText = unit

        if !unit.string.isEmpty {
            self.createUnitLabel()
        }
    }

    //Placeholder
    public func setPlaceholder(_ placehodler: String?) {
        self.textField.placeholder = placehodler
    }

    //Шрифт
    public func setTitleFont(_ font: UIFont) {
        self.titleLabel.font = font
    }

    public func setValueFont(_ font: UIFont) {
        self.textField.font = font
    }

    public func setUnitFont(_ font: UIFont) {
        self.unitLabel.font = font
    }

    //Конец ввода текста
    public func startEditing() {
        self.textField.becomeFirstResponder()
    }

    public func endEditing() {
        self.textField.resignFirstResponder()
    }

    //Цвет каретки
    public func setCarriageColor(_ color: UIColor) {
        self.textField.tintColor = color
    }

    //Показ ошибочного ввода
    public func setError(enabled: Bool, animation: Bool) {
        if enabled != self.errorEnabled {
            self.errorEnabled = enabled
            self.animateError(enabled: enabled, animation: animation, completion: {_ in })
        }
    }
}

// MARK: - Private
extension IKTextEditView {

    //Дефолтное создание
    private func createUI() {
        self.setCarriageColor(.black)
        self.textFieldColor = self.textField.textColor

        self.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(44)
        }

        self.textField.textAlignment = .right
        self.titleLabel.numberOfLines = 0
        self.textField.delegate = self

        self.addSubview(self.titleLabel)
        self.addSubview(self.textField)

        self.makeConstraints()
    }

    private func makeConstraints() {
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-2)
            $0.left.equalToSuperview()
            $0.width.equalTo(self.titleLabel.text?.width(withConstrainedHeight: 24, font: self.titleLabel.font) ?? 100)
        }

        self.textField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-2)
            $0.left.equalTo(self.titleLabel.snp.right).offset(8)
            $0.right.equalToSuperview()
        }
    }

    //Добавление единицы измерения
    private func createUnitLabel() {
        //Если уже содержится вьюшка, не создается заново
        if self.subviews.contains(self.unitLabel) {
            return
        }

        self.addSubview(self.unitLabel)

        self.unitLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-2)
            $0.right.equalToSuperview()
        }

        self.textField.snp.remakeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-2)
            $0.left.equalTo(self.titleLabel.snp.right).offset(8)
            $0.right.equalTo(self.unitLabel.snp.left).offset(-4)
        }
    }

    //дефолтная анимация подчеркивания ошибки
    private func animateError(enabled: Bool, animation: Bool, completion: @escaping (Bool?) -> Void) {
        UIView.transition(with: self.textField, duration: animation ? IKTextEditViewStruct.animationDuration : 0, options: .transitionCrossDissolve, animations: {
            self.setError(enabled: enabled)
        }) { (completed) in
            completion(completed)
        }
    }
}

// MARK: - UITextFieldDelegate
extension IKTextEditView: UITextFieldDelegate {

    public func textFieldDidEndEditing(_ textField: UITextField) {
        if self.validator?.shouldEnableDoneButtonBy(text: textField.text) ?? true {
            self.delegate?.correctedEditViewController(self, textDidChange: textField.text, corrected: true)
        } else {
            self.delegate?.correctedEditViewController(self, textDidChange: textField.text, corrected: false)
        }
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldValue = (textField.text ?? "") as NSString
        let newValue = oldValue.replacingCharacters(in: range, with: string)
        self.delegate?.textEditViewController(self, textDidChange: newValue)

        if self.flashInvalideText && self.validator != nil {
            self.setError(enabled: !(self.validator?.shouldEnableDoneButtonBy(text: newValue) ?? true), animation: true)
        }

        return self.validator?.shouldChangeTextTo(newValue, oldLength: oldValue.length) ?? true
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.delegate?.textFieldShouldReturn(self, textDidChange: textField.text)
        return true
    }
}
