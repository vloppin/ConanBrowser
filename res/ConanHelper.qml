import QtQuick 2.0
import ConanHelperBinding 1.0

Item {

    ConanHelperBinding{
        id: binding
    }
    property string serverName: ""
    property string serveUrl: ""
    property string packageName: ""

    function populateRemotes(pModel)
    {
        console.debug("> Remote Listing : Start")
        pModel.clear()

        binding.getRemoteList(
            function(pRemoteList){
                console.debug("> Remote Listing : parsing")
                var remoteList = JSON.parse(pRemoteList);
                if (remoteList.errors !== undefined) {
                    console.log("Error reading remotes: " + remoteList.errors[0].message)
                } else {
                    for( var remote in remoteList )
                        pModel.append({ name: remoteList[remote].name, url: remoteList[remote].url })
                    pModel.append({ name: "Local-Cache", url: "" })
                }

                console.debug("> Remote Listing : Done")
            });
    }

    function populatePackageFromServer(pServerName,pModel)
    {
        console.debug("> Package Listing for " + pServerName + ": Start")
        pModel.clear()

        binding.getPackageList(pServerName,
            function(pPackageList){
                console.debug("> Package Listing : parsing")

                var packageList = JSON.parse(pPackageList);
                var pckList = packageList.results[0].items
                for( var pck in pckList )
                {
                    var pckName = pckList[pck].recipe.id
                    pModel.append({ "name": pckName })
                }
                console.debug("> Package Listing : Done")
            });

    }
    function populatePackageInfo(pPackageName, pServerName, pGrid)
    {
        console.debug("> Package Info " + pPackageName + " on " + pServerName);

        binding.getPackageInfo(pPackageName, pServerName,
            function(pPackageInfo){
                console.debug("> Package Info : parsing")

                var packageInfo = JSON.parse(pPackageInfo);
                var pckInfo = packageInfo.results[0].items[0].packages;
                for( var pck in pckInfo )
                {
                    var outDated = pckInfo[pck].outdated;
                    var id = pckInfo[pck].id;
                    var compiler = pckInfo[pck].settings.compiler;
                    console.log(" >> " + compiler + " // " + id + " -- " + outDated );
                }

                console.debug("> Package Info : Done");
            });
    }

}
