import QtQuick 2.0
import ConanHelper 1.0

Item {
    property variant model: packages

    ConanHelper {
        id: conanHelper
    }

    ListModel {
        id: packages
    }

    function populate(pServer)
    {
        console.debug("> Package Listing : Start")

        conanHelper.getPackageList(pServer, function(pPackageList)
        {
            var packageList = JSON.parse(pPackageList);
            var toto = packageList.results[0].items
            for( var aaa in toto )
            {
                var pckName = toto[aaa].recipe.id
                packages.append({ "name": pckName })
            }

            console.debug("> Package Listing : Done")
        });
    }
}
