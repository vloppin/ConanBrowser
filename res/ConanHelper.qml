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
/*
function onlyUnique(value, index, self) {
    return self.indexOf(value) === index;
}

// usage example:
var a = ['a', 1, 'a', 2, '1'];
var unique = a.filter( onlyUnique ); // returns ['a', 1, 2, '1']
*/


                var lCompilerMap = {}
                var lOptionsMap = {}

                var packageInfo = JSON.parse(pPackageInfo);
                var pckInfo = packageInfo.results[0].items[0].packages;
                for( var pck in pckInfo )
                {
                    var outDated = pckInfo[pck].outdated;
                    var compiler = pckInfo[pck].settings.compiler;
                    var os = pckInfo[pck].settings.os;
                    var compilerVersion = pckInfo[pck].settings["compiler.version"];
                    var compilerString = os + " " + compiler + " " + compilerVersion;
                    if( compiler === "Visual Studio" ){
                        compilerString += " (" + pckInfo[pck].settings["compiler.runtime"].substr(0,2) + ")";
                    }

                    var settings = pckInfo[pck].settings;
                    delete settings["os"]
                    delete settings["compiler.version"]
                    delete settings["compiler.runtime"]
                    delete settings["compiler"]

                    var extra = {
                        arch: pckInfo[pck].settings.arch,
                        build_type: pckInfo[pck].settings.build_type,
                        options: pckInfo[pck].options,
                        requires: pckInfo[pck].requires,
                        settings: settings
                    }

                    var optionString = JSON.stringify(extra.settings) + " " + JSON.stringify(extra.options);

                    var mapEntry = lCompilerMap[compilerString];
                    if( mapEntry === undefined){
                        mapEntry = [];
                    }
                    mapEntry.push({ outdated: outDated, extra: extra });
                    lCompilerMap[compilerString] = mapEntry;

                    mapEntry = lOptionsMap[optionString];
                    if( mapEntry === undefined){
                        mapEntry = []
                    }
                    mapEntry.push({ outdated: outDated, extra: extra });
                    lOptionsMap[optionString] = mapEntry;

                    console.log(" >> " + compilerString + " -- " + outDated );
                    console.log(">> " + optionString)
                }

                var lCompilerList = [];
                pGrid.model.append({ name: "", outdated: false, extra: {} });
                for(var lCompiler in lCompilerMap){
                    console.log(lCompiler)
                    pGrid.model.append({ name: lCompiler, outdated: false, extra: {} })
                    lCompilerList.push( lCompiler )
                }

                for(var lOptions in lOptionsMap){
                    console.log(lOptions)
                    pGrid.model.append({ name: lOptions, outdated: false, extra: {} });
                    for(var lCompilerIdx in lCompilerList)
                    {
                        var lCompilerName = lCompilerList[lCompilerIdx];
                        console.log(lCompilerName)
                        var lCompilerEntries = lCompilerMap[lCompilerName];
                        var lFound = false;
                        for(var lCmpIdx in lCompilerEntries){
                            var lCmpData = lCompilerEntries[lCmpIdx]
                            var lCmpOptionString = JSON.stringify(lCmpData.settings) + " " + JSON.stringify(lCmpData.options);
                            if( lCmpOptionString === lOptions)
                            {
                                pGrid.model.append({ name: "", outdated: lCmpData.outdated, extra: {} })
                                lFound = true;
                            }
                        }
                        if( !lFound ){
                            pGrid.model.append({ name: "", outdated: false, extra: {} });
                        }
                    }
                }

                pGrid.grid.columns = 4


                console.debug("> Package Info : Done");
            });
    }

}
