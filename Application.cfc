//TODO - Remove all absolute paths 
component 
{
	this.ormenabled = "true";
	this.ormsettings = {datasource="postapp", logsql="true"};
	
	function onApplicationStart(){
		restInitApplication(directory=expandPath("./services"), serviceMapping="postapp");
	}
	function onRequestStart(){
		//refreshAPI();
	}
	function onRequestEnd(){
		//refreshAPI();
	}
	function refreshAPI(){
	    createObject("component","cfide.adminapi.administrator").login("mindfire");
	    exts = createObject("component","cfide.adminapi.extensions");
	    exts.refreshRESTService("E:\ColdFusion2016\cfusion\wwwroot\cfapi\services");
	}
}