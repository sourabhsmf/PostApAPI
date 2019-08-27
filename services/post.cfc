component rest="true" restpath="posts" produces="application/json" 
{
	
	//Default function - App Details
	//curl "http://localhost:8500/rest/postapp/posts/"
	remote string function sayHello() httpmethod="GET"{
		appDetails = {version="1.0" , name="postAppAPI" , developer="Sourabh Sinha"};
		return serializeJSON(appDetails);
	}
	
	//Show All posts
	//curl "http://localhost:8500/rest/postapp/posts/show"
	remote string function show() httpmethod="GET" restpath="show" returnformat="JSON"{
		var allPosts = EntityLoad("post");
		for(post in allPosts){
			post.comments = post.getComments();
		}
		return serializeJSON(allPosts);
	}
	
	//Show post base on postid
	//curl "http://localhost:8500/rest/postapp/posts/get/7"
	remote string function get(required string postid restargsource="Path") httpmethod="GET"
								restpath="get/{postid}"{
		var post = EntityLoadByPK("post", arguments.postid);
		if(isDefined("post")){
			post.comments = post.getComments();
			return serializeJSON(post);
		}
		throw(type="post.notfound", errorcode="404");
	}
	
	//Add new post
	// curl "http://localhost:8500/rest/postapp/posts/add" -H "Content-Type: application/x-www-form-urlencoded" --data "title=Agile&body=more"
	remote string function add(required string title restargsource="Form",required string body restargsource="Form")
								 httpmethod="POST" restpath="add" returnformat="JSON"{
		var post = EntityNew("post");
		post.setTitle(arguments.title);
		post.setBody(arguments.body);
		EntitySave(post);		
		return serializeJSON({postid:post.getId()});
	}
	
	//Remove a post
	// curl "http://localhost:8500/rest/postapp/posts/remove/17" -X DELETE
	remote boolean function remove(required string postid restargsource="Path") 
									httpmethod="DELETE" restpath="remove/{postid}" returnformat="JSON"{
		var postToDelete = entityLoadByPK("post", arguments.postid);
		if(isDefined("postToDelete")){
			entityDelete(postToDelete);
			return true;
		}
		throw(type="post.notfound", errorcode="404");
	}
	
	//Update a post
	// curl "http://localhost:8500/rest/postapp/posts/update" -X PUT -d "postid=3&title=First_Title&body=First_Body" -H "Content-Type: application/x-www-form-urlencoded"
	remote string function update(string title restargsource="Form" , string body restargsource="Form" , 
									required string postid restargsource="Form") httpmethod="PUT" restpath="update"{
		var post = EntityLoadByPK("post",arguments.postid);
		if(isDefined("post")){
			if(structKeyExists(arguments,"title") and Len(arguments.title)){
				post.setTitle(arguments.title);
			}
			if(structKeyExists(arguments,"body") and Len(arguments.body)){
				post.setBody(arguments.body);
			}
			EntitySave(post , true);
			return serializeJSON(EntityLoadByPK("post", arguments.postid));
		}
		throw(type="post.notfound", errorcode="404");
	}
}