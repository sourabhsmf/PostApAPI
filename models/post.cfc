component accessors="true" serializable="true" entityname="post" persistent="true" table="posts"{
	
	property name="id" column="postid" fieldtype="id" generator="increment";		
	property name="title" type="string" required="true" ;
	property name="body" type="string" required="true" ;
	property name="comments" fieldtype="one-to-many" fkcolumn="postid" required="false" cfc="comment" cascade="delete";
	     
}