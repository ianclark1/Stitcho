<!--- Stitcho API Component
		http://www.stitcho.com/documentation/Stitcho%20Integration%20Guide.pdf

		Version 1.0b
		$Rev: 6 $

		Author: Richard Davies (Richard@richarddavies.us)
 --->
<cfcomponent displayname="Stitcho" hint="Stitcho desktop notification widget API" output="false">

	<!--- init(partnerID, signKey)

		Description:
			Initialize component with partnerID and signKey.

		Params:
			partnerID - See http://stitcho.com/web/partner/settings for your Partner ID.
			signKey   - See http://stitcho.com/web/partner/settings for your SignKey.
	 --->
	<cffunction name="init" hint="." access="public" output="false" returntype="Any">
		<cfargument name="partnerID" type="numeric" required="true" hint="Your partner ID. Example: 221" />
		<cfargument name="signKey" type="string" required="true" hint="Your sign key. Example: 3DCAF217B71D7E52" />

		<cfset Variables.partnerID = Arguments.partnerID />
		<cfset Variables.signKey = Arguments.signKey />

		<cfreturn this />
	</cffunction>


	<!--- signup(partnerID, signKey, email, message)

		Description:
			The signup function triggers an email with instructions on how to sign up
			to Stitcho, including a link he or she can click to sign up.

		Params:
			email     - The email address to send the message to.
			message   - Add a message here explaining how your site uses Stitcho.

		Returns:
			200 - Success.
			401 - Unauthorized, your partnerID or signKey is incorrect.
			500 - Invalid request.
	 --->
	<cffunction name="signup" hint="Send an introductory signup email to your user to facilitate their Stitcho registration." access="public" output="false" returntype="numeric">
		<cfargument name="email" type="string" required="true" hint="The email address" />
		<cfargument name="message" type="string" required="true" hint="An intro message of arbitrary length describing how your site uses Stitcho.com" />

		<cfset var Local = StructNew() />

		<!--- Encode email and message --->
		<cfset Local.email = UrlencodedFormat(Arguments.email) />
		<cfset Local.message = UrlencodedFormat(Arguments.message) />

		<!--- Build and sign the query string --->
		<cfset Local.qs = "p=#Variables.partnerID#&e=#Local.email#&m=#Local.message#">
		<cfset Local.signature = sign(Local.qs) />
		<cfset Local.apiUrl = "http://api.stitcho.com/api/partner/signup?#Local.qs#&s=#Local.signature#" />

		<!--- Request URL and return status code --->
		<cfhttp url="#Local.apiUrl#" method="get" result="Local.cfhttp" />
		<cfreturn Local.cfhttp.ResponseHeader.Status_Code />
	</cffunction>


	<!---	send(partnerID, signKey, email, iconID, title, message, url)

		Description:
			The send function sends a Stitcho notification to a user.

		Params:
			email     - The email address of the user to alert.
			iconID    - An integer specifying the icon to use to brand the message. See
			            http://stitcho.com/web/partner/icons, or customize at
			            http://stitcho.com/web/partner/settings#iconpath
			title     - The title of the notification. 50 chars or less.
			message   - The body of the notification. 150 chars or less.
			url       - The clickthrough URL of the notification.

	 	Returns:
			200 - Success, the notification was sent.
			202 - Success, but the user was not connected, so the notification was dropped.
			401 - Unauthorized, your partnerID or signKey is incorrect.
			500 - Invalid request.
	 --->
	<cffunction name="send" hint="Send a Stitcho notification to the specified recipient." access="public" output="false" returntype="numeric">
		<cfargument name="email" type="string" required="true" hint="The email address of the recipient" />
		<cfargument name="iconID" type="numeric" required="true" hint="An icon id. Example: 15" />
		<cfargument name="title" type="string" required="true" hint="The title of the message. 50 characters or less." />
		<cfargument name="message" type="string" required="true" hint="The message to send the user. 150 characters or less." />
		<cfargument name="url" type="string" required="true" hint="The url that will be opened when the message is clicked." />

		<cfset var Local = StructNew() />

		<!--- Encode email, message, and URL --->
		<cfset Local.email = Hash(LCase(Trim(Arguments.email)), "md5") />
		<cfset Local.title = UrlencodedFormat(Arguments.title) />
		<cfset Local.message = UrlencodedFormat(Arguments.message) />
		<cfset Local.url = UrlencodedFormat(Arguments.url) />
		<cfset Local.url = Arguments.url />

		<!--- Build and sign the query string --->
		<cfset Local.qs = "p=#Variables.partnerID#&i=#Arguments.iconID#&md5=#Local.email#&t=#Local.title#&m=#Local.message#&u=#Local.url#">
		<cfset Local.signature = sign(Local.qs) />
		<cfset Local.apiUrl = "http://api.stitcho.com/api/partner/send?#Local.qs#&s=#Local.signature#" />

		<!--- Request URL and return status code --->
		<cfhttp url="#Local.apiUrl#" method="get" result="Local.cfhttp" />
		<cfreturn Local.cfhttp.ResponseHeader.Status_Code />
	</cffunction>


	<cffunction name="sign" hint="Signs an API method call." access="package" output="false" returntype="string">
		<cfargument name="qs" type="string" required="true" hint="Query string to sign" />

		<!--- Return method signature --->
		<cfreturn Hash(Arguments.qs & Variables.signKey, "md5") />
	</cffunction>
</cfcomponent>