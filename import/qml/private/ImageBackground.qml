/*
 * Copyright 2018 by Marco Martin <mart@kde.org>
 * Copyright 2018 David Edmundson <davidedmundson@kde.org>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

import QtQuick 2.4
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.4 as Controls
import org.kde.kirigami 2.4 as Kirigami


Item {
    id: backgroundImage
    anchors {
        top: parent.top
        bottom: parent.bottom
    }
    width: height * (currentImage.sourceSize.width / currentImage.sourceSize.height)
    x: -delegatesView.visibleArea.xPosition * 1.5 * parent.width

    property string source
    property Image currentImage: image1
    onSourceChanged: {
        if (backgroundImage.currentImage == image1) {
            image2.opacity = 0;
            image2.source = source;
            if (image2.status == Image.Ready) {
                backgroundImage.setCurrent(image2);
            }
        } else {
            image1.opacity = 0;
            image1.source = source;
            if (image1.status == Image.Ready) {
                backgroundImage.setCurrent(image1);
            }
        }
    }

    function setCurrent(image) {
        backgroundImage.currentImage = image;
        fadeAnim.restart();
    }
    
    Image {
        id: image1
        anchors.fill: parent
        z: backgroundImage.currentImage == image1 ? 1 : 0
        onStatusChanged: {
            if (backgroundImage.currentImage == image2 && status == Image.Ready) {
                backgroundImage.setCurrent(image1);
            }
        }
    }
    Image {
        id: image2
        anchors.fill: parent
        z: backgroundImage.currentImage == image2 ? 1 : 0
        onStatusChanged: {
            if (backgroundImage.currentImage == image1 && status == Image.Ready) {
                backgroundImage.setCurrent(image2);
            }
        }
    }
    SequentialAnimation {
        id: fadeAnim
        OpacityAnimator {
            target: backgroundImage.currentImage
            from: 0
            to: 1
            duration: 1000
            easing.type: Easing.InOutQuad
        }
    }
}
