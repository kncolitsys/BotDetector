<cfsilent>
	<cfset Questions = [
		{
			Question = "What is the capital of Texas?"
			, Answer = "Austin"
		}
	] />

	<cfset HumanDetector = CreateObject("component", "HumanDetector").init(Key = "foobarmonkey", MinimumTime = 20, MaximumTime = 60) />

	<cfif StructKeyExists(FORM, "fieldnames")>
		<!--- Check the results of the humanDetector --->
		<cfset Result = HumanDetector.checkAnswer(FORM.confirmValue, FORM.question) />
	</cfif>

	<cfset theQuestion = HumanDetector.getQuestionForForm() />
	<cfparam name="FORM.Contact_Name" default="" />

</cfsilent>
<html>
<head>
	<title>HumanDetector Demo</title>
	<style>
	body  {
		font-family: verdana, arial, helvetica, sans-serif;
		background-color: #FFFFFF;
		font-size: 12px;
		margin-top: 10px;
		margin-left: 10px;
	}
	
	table	{
		font-size: 11px;
		font-family: Verdana, arial, helvetica, sans-serif;
	}
	
	th {
		padding: 6px;
		font-size: 12px;
		background-color: #cccccc;
	}
	
	td {
		padding: 6px;
		background-color: #eeeeee;
		vertical-align : top;
	}
	
	code {
		display: block;
		color: #000099 ;
		white-space: pre;
		font-family: monospace;
		border: 1px solid #333;
		background-color: #EEE;
		padding: 1em;
	}
	</style>
</head>
<body>
	<h1>Human Detector</h1>
	<p><strong>CFC Download: </strong> <a href="HumanDetector.zip">HumanDetector.zip</a><br />
	<a href="CFCDoc.cfm">CFC Documentation</a></p>
	<p>This CFC will allow you to pose plain English questions to a user. In order to pass the test, the user must answer the question correctly within a specific timeframe.</p>
	<h2>How to use</h2>
	<p>First, instantiate the object:</p>
	<code>&lt;cfset HumanDetector = CreateObject("component", "HumanDetector").init(Key = "YourKey", MinimumTime = 20, MaximumTime = 60) /&gt;</code>
	<p>Next, get a question to display to the user:</p>
	<code>&lt;cfset theQuestion = HumanDetector.getQuestionForForm() /&gt;</code>
	<p>Now, show the question to the user. Make sure you put the confirmValue returned from the getQuestionForForm() method in a hidden field. This is required to check the answer:</p>
	<code>
&lt;cfoutput&gt;#theQuestion.Question# &lt;cfinput type="text" name="question" style="width: 75px;"&gt;&lt;/cfoutput&gt;
&lt;cfinput type="hidden" name="confirmvalue" value="#theQuestion.confirmValue#" /&gt;
	</code>
	<p>Next, you need to check the user's answer on the server after the form has been submitted:</p>
	<code>
&lt;cfif StructKeyExists(FORM, "fieldnames")&gt;
	&lt;!--- Check the results of the humanDetector ---&gt;
	&lt;cfset Result = HumanDetector.checkAnswer(FORM.confirmValue, FORM.question) /&gt;
&lt;/cfif&gt;
	</code>
	<p>Finally, show the user the result of their submission, or just continue processing the form:</p>
	<code>
&lt;cfif StructKeyExists(Variables, "Result")&gt;
	&lt;cfif NOT Result.Success&gt;
		&lt;h1&gt;ROBOT!&lt;/h1&gt;
		&lt;p&gt;I'm sorry, but you're a robot... that was a simple question dude...&lt;/p&gt;

		&lt;p&gt;Here are the reasons the submission failed:&lt;/p&gt;
		&lt;cfdump var="#Result#"&gt;

	&lt;cfelse&gt;
		&lt;h1&gt;Human!&lt;/h1&gt;
		&lt;p&gt;Congrats, you must be a human...&lt;/p&gt;
	&lt;/cfif&gt;
&lt;/cfif&gt;
	</code>
	<h1>Human Detector Demo</h1>
	<cfif StructKeyExists(Variables, "Result")>
		<cfif NOT Result.Success>
			<h1>ROBOT!</h1>
			<p>I'm sorry, but you're a robot... that was a simple question dude...</p>
	
			<p>Here are the reasons the submission failed:</p>
			<cfdump var="#Result#">
	
		<cfelse>
			<h1>Human!</h1>
			<p>Congrats, you must be a human...</p>
		</cfif>
	</cfif>
	<cfform>
		<h2>Answer these simple questions</h2>
		What's your name?: <cfinput type="text" name="Contact_Name" value="#FORM.Contact_Name#" /><br />
		<h3>In order to prevent spam, please answer the following question:</h3>
		<cfoutput>#theQuestion.Question# <cfinput type="text" name="question" style="width: 75px;"></cfoutput>
		<cfinput type="hidden" name="confirmvalue" value="#theQuestion.confirmValue#" />
	
		<p><cfinput type="submit" name="Send Data" /></p>
	
	</cfform>

	<h1>Available Questions</h1>
	<p>Below is a list of all of the questions currently in the Human Detector. You can adjust these questions (and their answers) however you want.</p>
	<cfdump var="#HumanDetector.getQuestions()#">

</body>
</html>

