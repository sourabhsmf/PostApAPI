component accessors="true" serializable="true" entityname="comment" persistent="true" table="comments"{
	property name="id" column="commentid" fieldtype="id" generator="increment";		
	property name="name" type="string" required="true" ;
	property name="email" type="string" required="true" ;
	property name="body" type="string" required="true" ;	
	property name="post" fieldtype="many-to-one" cfc="post" required="true";	
}