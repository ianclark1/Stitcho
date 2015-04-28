=====================================================================
Stitcho API Library
Version: 1.0b
$Rev: 6 $

Author: Richard Davies (Richard@richarddavies.us)
=====================================================================

-------------
 DESCRIPTION
-------------

Stitcho is a desktop notification widget for websites, with support 
for Windows and Mac. With this component and the Stitcho widget, you 
can send desktop notifications to your web site users (even if they
are not currently browsing your web site).

You will need a Stitcho partner account in order to use their API. 


-------------
 BASIC INFO
-------------  

1.	Sign up for a Stitcho partner account at http://www.stitcho.com
2. Note your partner ID and sign key (http://www.stitcho.com/web/partner/settings)
3. There are two main methods in the stitcho component:
	a) signup()
		Sends an introductory signup email to a user to facilitate their Stitcho registration.
	b)	send()
		Sends a Stitcho notification to a specified recipient.


---------------
 EXAMPLE USAGE
---------------

<cfset partnerID = 13 />
<cfset signKey = "3DCAF217B71D7E52" />
<cfset email = "test@stitcho.com" />
<cfset iconID = 1 />
<cfset title =  "Test Stitcho CFC" />
<cfset message1 = "Get instant notifications by signing up for a free Stitcho account." />
<cfset message2 = "ColdFusion rocks." />
<cfset linkurl = "http://www.stitcho.com" />

<cfset stitcho = CreateObject("component", "stitcho").init(#partnerID#, #signKey#) />
<!--- Sent an invitation e-mail --->
<cfset result = stitcho.signup(#email#, #message2#) />
<!--- Sent a notification message --->
<cfset result = stitcho.send(#email#, #iconID#, #title#, #message1#, #linkurl#) />
 

-----------------
 VERSION HISTORY
-----------------

1.0b
	Initial release.