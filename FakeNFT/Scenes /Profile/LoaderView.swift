//
//  LoaderView.swift
//  FakeNFT
//
//  Created by Irina Deeva on 19/05/24.
//

import UIKit

final class LoaderView: UIView, LoadingView {

    internal let activityIndicator = UIActivityIndicatorView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(activityIndicator)
        activityIndicator.constraintCenters(to: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
