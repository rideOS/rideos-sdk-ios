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

import Foundation
import RideOsCommon

open class DefaultRiderDependencyFactory: RiderDependencyFactory {
    open var userProfileInteractor: UserProfileInteractor {
        return RiderUserProfileInteractor()
    }

    open var routeInteractor: RouteInteractor {
        return RideOsRouteInteractor()
    }

    open var fleetInteractor: FleetInteractor {
        return DefaultFleetInteractor()
    }

    open func preTripViewModel(withListener listener: PreTripListener) -> PreTripViewModel {
        return DefaultPreTripViewModel(listener: listener, enableSeatCountSelection: true)
    }

    open var pushNotificationManager: PushNofificationManager? {
        return pushNotificationManagerInstance
    }

    open var menuOptions: [MenuOption] {
        return [
            MenuOption(
                title: RideOsCommonResourceLoader.instance.getString(
                    "ai.rideos.common.settings.developer.edit-profile"
                ),
                icon: CommonImages.person(),
                viewControllerFactory: {
                    AccountSettingsFormViewController()
                }
            ),
            MenuOption(
                title: RideOsCommonResourceLoader.instance.getString("ai.rideos.common.settings.developer"),
                icon: CommonImages.gear(),
                viewControllerFactory: {
                    CommonDeveloperSettingsFormViewController(
                        fleetSelectionViewModel: DefaultFleetSelectionViewModel(),
                        userStorageReader: UserDefaultsUserStorageReader(),
                        userStorageWriter: UserDefaultsUserStorageWriter()
                    )
                }
            ),
        ]
    }

    private let pushNotificationManagerInstance: PushNofificationManager?

    public init(pushNotificationManager: PushNofificationManager? = nil) {
        pushNotificationManagerInstance = pushNotificationManager
    }
}
