// Copyright 2019 rideOS, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import RideOsCommon
import RxCocoa
import RxSwift
import UIKit

public class WatingForPickupDialogView: BottomDialogStackView {
    private static let headerLabelTextColor =
        RideOsDriverResourceLoader.instance.getColor("ai.rideos.driver.dialog.header-label.text-color")
    private static let mainLabelTextColor =
        RideOsDriverResourceLoader.instance.getColor("ai.rideos.driver.dialog.main-label.text-color")
    private static let showDetailsIcon =
        RideOsDriverResourceLoader.instance.getImage("ai.rideos.driver.arrow-down")
    private static let confirmPickupButtonTitle =
        RideOsDriverResourceLoader.instance.getString("ai.rideos.driver.online.waiting-for-pickup.button.title")

    public var showDetailsTapEvents: ControlEvent<Void> {
        return showDetailsButton.rx.tap
    }

    public var confirmPickupTapEvents: ControlEvent<Void> {
        return confirmPickupButton.tapEvents
    }

    public var isConfirmPickupButtonEnabled: Bool {
        get {
            return confirmPickupButton.isButtonEnabled
        }
        set {
            confirmPickupButton.isButtonEnabled = newValue
        }
    }

    private let separatorView = BottomDialogStackView.separatorView()
    private let showDetailsButton = WatingForPickupDialogView.showDetailsButton()
    private let mainTextLabel = WatingForPickupDialogView.mainTextLabel()
    private let confirmPickupButton = StackedActionButtonContainerView(
        title: WatingForPickupDialogView.confirmPickupButtonTitle
    )
    private let disposeBag = DisposeBag()

    public init(headerText: String) {
        let headerView = WatingForPickupDialogView.headerView(
            labelText: headerText,
            showDetailsButton: showDetailsButton,
            disposeBag: disposeBag
        )

        super.init(stackedElements: [
            .view(view: headerView),
            .view(view: separatorView),
            .customSpacing(spacing: 20.0),
            .view(view: mainTextLabel),
            .customSpacing(spacing: 24.0),
            .view(view: confirmPickupButton),
            .customSpacing(spacing: 16.0),
        ])

        Shadows.enableShadows(onView: self)
    }

    required init?(coder _: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }

    public func set(mainText: String) {
        mainTextLabel.text = mainText
    }
}

extension WatingForPickupDialogView {
    private static func headerView(labelText: String,
                                   showDetailsButton: UIButton,
                                   disposeBag: DisposeBag) -> UIView {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .left
        label.textColor = WatingForPickupDialogView.headerLabelTextColor
        label.text = labelText

        let headerView = UIView(frame: .zero)
        headerView.heightAnchor.constraint(equalToConstant: 48.0).isActive = true

        headerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 16.0).isActive = true
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true

        headerView.addSubview(showDetailsButton)
        showDetailsButton.translatesAutoresizingMaskIntoConstraints = false
        showDetailsButton.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
        showDetailsButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true

        let tapGestureRecognizer = UITapGestureRecognizer(target: nil, action: nil)
        tapGestureRecognizer.rx.event.subscribe { _ in
            showDetailsButton.sendActions(for: .touchUpInside)
        }
        .disposed(by: disposeBag)

        label.addGestureRecognizer(tapGestureRecognizer)
        headerView.addGestureRecognizer(tapGestureRecognizer)

        return headerView
    }

    private static func showDetailsButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(WatingForPickupDialogView.showDetailsIcon, for: .normal)

        return button
    }

    private static func mainTextLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        label.textColor = WatingForPickupDialogView.mainLabelTextColor
        return label
    }
}
