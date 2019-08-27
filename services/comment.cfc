component rest="true" restpath="comments" produces="application/json" 
{
	
	//Default function - App Details
	//curl "http://localhost:8500/rest/postapp/comments/"
	remote string function sayHello() httpmethod="GET"{
		appDetails = {version="1.0" , name="postAppAPI-comments" , developer="Sourabh Sinha"};
		return serializeJSON(appDetails);
	}
	//Show All comments for a post????
	//curl "http://localhost:8500/rest/postapp/comments/show/1"
	remote string function show(required string postid restargsource="Path") httpmethod="GET" 
									returnformat="JSON" restpath="show/{postid}"{
		var post = entityLoadByPK("post",arguments.postid);
		if(isDefined("post")){
			var allCommentsForPost = EntityLoad("comment", {post=post});
			return serializeJSON(allCommentsForPost);
		}
		throw(type="post.notfound", errorcode="404");
	}
	
	//Show comments based on commentid
	//curl "http://localhost:8500/rest/postapp/comments/get/1"
	remote string function get(required string commentid restargsource="Path") httpmethod="GET"
								restpath="get/{commentid}"{
		var comment = EntityLoadByPK("comment", arguments.commentid);
		if(isDefined("comment")){
			comment.postid = comment.getPost().getId();
			return serializeJSON(comment);
		}
		throw(type="comment.notfound", errorcode="404");
	}
	//Add new comment
	// curl "http://localhost:8500/rest/postapp/comments/add" -H "Content-Type: application/x-www-form-urlencoded" --data "name=rrrr&body=more&email=sss@gf.com&postid=1"
	remote string function add(required string name restargsource="Form",
								required string body restargsource="Form",
								required string email restargsource="Form",
								required string postid restargsource="Form")
								 httpmethod="POST" restpath="add" returnformat="JSON"{
		
		var comment = EntityNew("comment");
		comment.setName(arguments.name);
		comment.setBody(arguments.body);
		comment.setEmail(arguments.email);
		comment.setPost(EntityLoadByPK("post", arguments.postid));
		
		EntitySave(comment);
				
		return serializeJSON({commentid:comment.getId()});
	}
	//Remove a comment //Not required // Add access control to this function
	// curl "http://localhost:8500/rest/postapp/comments/remove/17" -X DELETE
	remote boolean function remove(required string commentid restargsource="Path") 
									httpmethod="DELETE" restpath="remove/{commentid}" returnformat="JSON"{
		var commentToDelete = entityLoadByPK("comment", arguments.commentid);
		if(isDefined("commentToDelete")){
			entityDelete(commentToDelete);
			return true;
		}
		throw(type="comment.notfound", errorcode="404");
	}
	//Update a comment
	// curl "http://localhost:8500/rest/postapp/comments/update" -X PUT -d "commentid=3&name=First_Name&body=First_Body&email=sss@fff.ccc" -H "Content-Type: application/x-www-form-urlencoded"
	remote string function update(required string name restargsource="Form",
								required string body restargsource="Form",
								required string email restargsource="Form",
								required string commentid restargsource="Form")
								httpmethod="PUT" restpath="update"{
		var comment = EntityLoadByPK("comment",arguments.commentid);
		if(isDefined("comment")){
			if(structKeyExists(arguments,"name") and Len(arguments.name)){
				comment.setName(arguments.name);
			}
			if(structKeyExists(arguments,"body") and Len(arguments.body)){
				comment.setBody(arguments.body);
			}
			if(structKeyExists(arguments,"email") and Len(arguments.email)){
				comment.setEmail(arguments.email);
			}
			
			EntitySave(comment , true);
			return serializeJSON(EntityLoadByPK("comment", arguments.commentid));
		}
		throw(type="comment.notfound", errorcode="404");
	}
}