import QtQuick 2.0
import ConanHelperBinding 1.0

Item {

    ConanHelperBinding{
        id: binding
    }
    property string serverName: ""
    property string serveUrl: ""
    property string packageName: ""
    property variant busyIndicator: ({})

    function replaceAllInString(target, search, replacement) {
        return target.split(search).join(replacement);
    }

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
                    pModel.append({ name: "", url: "" })
                }

                console.debug("> Remote Listing : Done")
                busyIndicator.visible = false;
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
                if(!packageList.error)
                {
                    if( packageList.results.length > 0)
                    {
                        var pckList = packageList.results[0].items
                        for( var pck in pckList )
                        {
                            var pckName = pckList[pck].recipe.id
                            console.debug(pckName);
                            pModel.append({ "name": pckName })
                        }
                    }
                    console.debug("> Package Listing : Done")
                }
                else
                {
                    console.log("> Package Listing : Error")
                }
                busyIndicator.visible = false;
            });

    }
    function populatePackageInfo(pPackageName, pServerName, pPackageView)
    {
        console.debug("> Package Info " + pPackageName + " on " + pServerName);

        pPackageView.listModel.clear()
        pPackageView.model.clear()

        pPackageView.packageName.text = pPackageName

        var fullyFinished = false

        binding.getPackageInfo(pPackageName, pServerName,
            function(pPackageInfo){
                console.debug("> Package Info : parsing")

                var packageInfo = JSON.parse(pPackageInfo);
                pPackageView.remoteName.text = packageInfo[0].remote.name
                pPackageView.creationTime.text = packageInfo[0].creation_date

                console.debug("> Package Info : Done")

                if(fullyFinished)
                {
                    busyIndicator.visible = false;
                }
                else
                {
                    fullyFinished = true;
                }
            });

        binding.getPackageMatrix(pPackageName, pServerName,
            function(pPackageMatrix){
                console.debug("> Package Matrix : parsing")

                var lCompilerMap = {}
                var lOptionsMap = {}

                var packageInfo = JSON.parse(pPackageMatrix);
                var pckInfo = packageInfo.results[0].items[0].packages;
                for( var pck in pckInfo )
                {
                    var outDated = pckInfo[pck].outdated;
                    var compiler = pckInfo[pck].settings.compiler;
                    var os = pckInfo[pck].settings.os;
                    var compilerVersion = pckInfo[pck].settings["compiler.version"];
                    var compilerString = os + " " + compiler + " " + compilerVersion;
                    if( compiler === "Visual Studio" && pckInfo[pck].settings["compiler.runtime"] !== undefined ){
                        compilerString += " (" + pckInfo[pck].settings["compiler.runtime"].substr(0,2) + ")";
                    }

                    pPackageView.listModel.append({
                        compiler: compilerString,
                        outdated: outDated,
                        build_type: pckInfo[pck].settings.build_type + " " + pckInfo[pck].settings.arch,
                        optionString: JSON.stringify(pckInfo[pck].options)
                    });

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

                    var optionString = JSON.stringify( Object.assign(extra.settings, extra.options) );

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
                }

                var lOptionsList = [];
                pPackageView.model.append({ name: "", outdated: 0, extra: {} });
                for(var lOptions in lOptionsMap){
                    var lOptionString = replaceAllInString(lOptions,",","\n")
                    lOptionString = replaceAllInString(lOptionString,'"',"")
                    lOptionString = replaceAllInString(lOptionString,':'," = ")
                    lOptionString = lOptionString.substr(1, lOptionString.length-2)
                    pPackageView.model.append({ name: lOptionString, outdated: 0, extra: {} });
                    lOptionsList.push( lOptions )
                }

                for(var lCompiler in lCompilerMap){
                    pPackageView.model.append({ name: lCompiler, outdated: 0, extra: {} })

                    var lOptList = lCompilerMap[lCompiler];
                    for(var lOptionString in lOptionsMap){
                        var lFound = false;
                        for(var lOptIdx in lOptList){
                            var lCmpData = lOptList[lOptIdx]
                            var lCmpOptionString = JSON.stringify(  Object.assign(lCmpData.extra.settings,lCmpData.extra.options) );
                            console.log(lCmpOptionString)
                            if( lOptionString === lCmpOptionString ){
                                pPackageView.model.append({ name: "", outdated: (lCmpData.outdated ? 1 : 2), extra: {} })
                                lFound = true;

                            }
                        }
                        if( !lFound ){
                            pPackageView.model.append({ name: "", outdated: 0, extra: {} });
                        }
                    }
                }

                pPackageView.grid.columns = lOptionsList.length + 1;

                console.debug("> Package Matrix : Done");

                if(fullyFinished)
                {
                    busyIndicator.visible = false;
                }
                else
                {
                    fullyFinished = true;
                }
            });
    }

}
