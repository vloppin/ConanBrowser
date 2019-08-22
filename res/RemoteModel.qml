import QtQuick 2.0
import ConanHelper 1.0

Item {
    property variant model: remotes

    ConanHelper {
        id: conanHelper
    }

    ListModel {
        id: remotes
    }

    Component.onCompleted: {
        populate()
    }

    function populate()
    {
        console.debug("> Remote Listing : Start")

        conanHelper.getRemoteList(
            function(pRemoteList){
                var remoteList = JSON.parse(pRemoteList);
                if (remoteList.errors !== undefined) {
                    console.log("Error reading remotes: " + remoteList.errors[0].message)
                } else {
                    for( var remote in remoteList )
                        remotes.append({ name: remoteList[remote].name, url: remoteList[remote].url })
                    remotes.append({ name: "Local-Cache", url: "" })
                }

                console.debug("> Remote Listing : Done")
            });
    }
}
