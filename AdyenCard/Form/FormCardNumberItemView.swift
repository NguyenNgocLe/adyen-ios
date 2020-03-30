//
// Copyright (c) 2020 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

/// A view representing a form card number item.
internal final class FormCardNumberItemView: FormTextItemView<FormCardNumberItem> {
    
    private static let cardSpacing: CGFloat = 4.0
    private static let cardSize = CGSize(width: 24.0, height: 16.0)
    
    /// Initializes the form card number item view.
    ///
    /// - Parameter item: The item represented by the view.
    internal required init(item: FormCardNumberItem) {
        super.init(item: item)
        setState(.customView(cardTypeLogosView))
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Card Type Logos View
    
    private lazy var cardTypeLogosView: UIView = {
        let cardLogos: [CardTypeLogoView] = item.cardTypeLogos.map { logo in
            let imageView = CardTypeLogoView(cardTypeLogo: logo, style: item.style.icon)
            imageView.backgroundColor = item.style.backgroundColor
            return imageView
        }
        
        let cardTypeLogosView = CardTypeLogosView(logos: cardLogos)
        cardTypeLogosView.accessibilityIdentifier = ViewIdentifierBuilder.build(scopeInstance: self, postfix: "cardTypeLogos")
        cardTypeLogosView.backgroundColor = item.style.backgroundColor
        
        return cardTypeLogosView
    }()
}

// MARK: - FormCardNumberItemView.CardTypeLogoView

private extension FormCardNumberItemView {
    
    private class CardTypeLogosView: UIStackView {
        
        init(logos: [CardTypeLogoView]) {
            super.init(frame: .zero)
            axis = .horizontal
            spacing = FormCardNumberItemView.cardSpacing
            logos.forEach(addArrangedSubview)
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            invalidateIntrinsicContentSize()
            super.layoutSubviews()
        }
        
        override var intrinsicContentSize: CGSize {
            let cardsCount = CGFloat(arrangedSubviews.filter { !$0.isHidden }.count)
            let width = FormCardNumberItemView.cardSize.width * cardsCount + FormCardNumberItemView.cardSpacing * max(cardsCount - 1, 0)
            return .init(width: max(width, FormCardNumberItemView.cardSpacing), height: FormCardNumberItemView.cardSize.height)
        }
        
    }
}

private extension FormCardNumberItemView {
    
    private class CardTypeLogoView: NetworkImageView, Observer {
        
        internal init(cardTypeLogo: FormCardNumberItem.CardTypeLogo, style: ImageStyle) {
            super.init(frame: .zero)
            
            imageURL = cardTypeLogo.url
            
            layer.masksToBounds = style.clipsToBounds
            layer.cornerRadius = style.cornerRadius
            layer.borderWidth = style.borderWidth
            layer.borderColor = style.borderColor?.cgColor
            backgroundColor = style.backgroundColor
            
            bind(cardTypeLogo.isHidden, to: self, at: \.isHidden)
        }
        
        internal required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        internal override var intrinsicContentSize: CGSize {
            return cardSize
        }
        
    }
    
}