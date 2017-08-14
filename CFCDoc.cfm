
 <html>
<head>
<title>Component HumanDetector</title>
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
	width: 90%;
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
	color: #000099 ;
}
</style>

</head>
<body style="padding-bottom : 800px;">

<font size="-2">Projects.HumanDetector.HumanDetector</font><br>
<font size="+1"><b>Component HumanDetector (Human Dector)
</b></font>

<br><br><br>
<table>

<tr><td>hierarchy:</td><td>
	WEB-INF.cftags.component<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Projects.HumanDetector.HumanDetector<br> 
</td></tr>

<tr><td>path:</td>
	<td>HumanDetector.cfc</td>
</tr>

<tr><td>serializable:</td>
	<td>Yes
			</td>
</tr>
<p>Utility functions to determine if the being completing a form is indeed human.</p>

<tr><td>properties:</td>

	<br>
	<td></td>
</tr>

<tr><td>methods:</td>

	
	<td> <a href="#method_addQuestion">addQuestion</a>, <a href="#method_checkAnswer">checkAnswer</a>, <a href="#method_convertToUnixTime">convertToUnixTime</a>*, <a href="#method_convertUnixTimeToDate">convertUnixTimeToDate</a>*, <a href="#method_getQuestionForForm">getQuestionForForm</a>, <a href="#method_getQuestions">getQuestions</a>, <a href="#method_init">init</a></td>
</tr>


</table>
<font size="-2">* - private method</font>

<br><br><table>



	

	<tr><th align="left" colspan="1">
		<a name="method_addQuestion">addQuestion</a> 
		</th></tr>
	<tr><td>

	

	<code>
	
		<i>public</i>
	
		<i>void</i>
	
	<b>addQuestion</b>
	
	(
 	
		<i>
		required string
		</i>
		Question, 
		<i>
		required string
		</i>
		Answer 
	)
	</i>
	</code>
	<br><br>
	

	Add a single question to the list of questions.<br><br> 

	Output: suppressed<br>

	
	
		Parameters:<br>
		
			&nbsp;&nbsp; <b>Question:</b>
			string, required, Question - The question to ask the user.
			<br>
		
			&nbsp;&nbsp; <b>Answer:</b>
			string, required, Answer - The answer to the question.
			<br>
		
	<br>
	</td></tr>



	

	<tr><th align="left" colspan="1">
		<a name="method_checkAnswer">checkAnswer</a> 
		</th></tr>
	<tr><td>

	

	<code>
	
		<i>public</i>
	
		<i>Struct</i>
	
	<b>checkAnswer</b>
	
	(
 	
		<i>
		required string
		</i>
		ConfirmValue, 
		<i>
		required string
		</i>
		Answer 
	)
	</i>
	</code>
	<br><br>
	

	Confirms the answer for a question. You must supply the ConfirmValue string returned from getQuestionForForm, as well as the Answer to the question. A struct will be returned with Success and Reasons nodes.<br /><br />Success: true or false<br />Reasons: an array of reasons the check failed, if there are any<br><br> 

	Output: suppressed<br>

	
	
		Parameters:<br>
		
			&nbsp;&nbsp; <b>ConfirmValue:</b>
			string, required, ConfirmValue - The ConfirmValue generated using getQuestionForForm.
			<br>
		
			&nbsp;&nbsp; <b>Answer:</b>
			string, required, Answer - The answer to the question.
			<br>
		
	<br>
	</td></tr>



	

	<tr><th align="left" colspan="1">
		<a name="method_convertToUnixTime">convertToUnixTime</a>* 
		</th></tr>
	<tr><td>

	

	<code>
	
		<i>private</i>
	
		<i>numeric</i>
	
	<b>convertToUnixTime</b>
	
	(
 	
		<i>
		date
		</i>
		Date="[runtime expression]" 
	)
	</i>
	</code>
	<br><br>
	

	Converts a date string to UnixTime.<br><br> 

	Output: suppressed<br>

	
	
		Parameters:<br>
		
			&nbsp;&nbsp; <b>Date:</b>
			date, optional, Date - The date (to the second) to be converted to UnixTime. If no date is supplied, then Now() will be used.
			<br>
		
	<br>
	</td></tr>



	

	<tr><th align="left" colspan="1">
		<a name="method_convertUnixTimeToDate">convertUnixTimeToDate</a>* 
		</th></tr>
	<tr><td>

	

	<code>
	
		<i>private</i>
	
		<i>date</i>
	
	<b>convertUnixTimeToDate</b>
	
	(
 	
		<i>
		required numeric
		</i>
		UnixTime 
	)
	</i>
	</code>
	<br><br>
	

	Converts a UnixTime string to a valid date.<br><br> 

	Output: suppressed<br>

	
	
		Parameters:<br>
		
			&nbsp;&nbsp; <b>UnixTime:</b>
			numeric, required, UnixTime - The UnixTime to be converted to a Date.
			<br>
		
	<br>
	</td></tr>



	

	<tr><th align="left" colspan="1">
		<a name="method_getQuestionForForm">getQuestionForForm</a> 
		</th></tr>
	<tr><td>

	

	<code>
	
		<i>public</i>
	
		<i>Struct</i>
	
	<b>getQuestionForForm</b>
	
	(
 	
	)
	</i>
	</code>
	<br><br>
	

	Returns a structure containing a 'ConfirmValue' and 'Question'. The ConfirmValue is URLEncoded, and should be placed in a hidden form field and passed to the checkAnswer function after the answer has been collected from the user.<br><br> 

	Output: suppressed<br>

	
	
	<br>
	</td></tr>



	

	<tr><th align="left" colspan="1">
		<a name="method_getQuestions">getQuestions</a> 
		</th></tr>
	<tr><td>

	

	<code>
	
		<i>public</i>
	
		<i>array</i>
	
	<b>getQuestions</b>
	
	(
 	
	)
	</i>
	</code>
	<br><br>
	

	Returns an array of possible questions.<br><br> 

	Output: suppressed<br>

	
	
	<br>
	</td></tr>



	

	<tr><th align="left" colspan="1">
		<a name="method_init">init</a> 
		</th></tr>
	<tr><td>

	

	<code>
	
		<i>public</i>
	
		<i>HumanDetector</i>
	
	<b>init</b>
	
	(
 	
		<i>
		required string
		</i>
		Key, 
		<i>
		numeric
		</i>
		MinimumTime="20", 
		<i>
		numeric
		</i>
		MaximumTime="1200", 
		<i>
		array
		</i>
		AdditionalQuestions 
	)
	</i>
	</code>
	<br><br>
	

	Initializes the object and returns an instance.<br><br> 

	Output: suppressed<br>

	
	
		Parameters:<br>
		
			&nbsp;&nbsp; <b>Key:</b>
			string, required, Key - Key to use for Encrypting and Decrypting confirmation values.
			<br>
		
			&nbsp;&nbsp; <b>MinimumTime:</b>
			numeric, optional, MinimumTime - The minimum amount of time it should take a user to complete the form (in seconds). Submissions faster than this will be rejected when calling 'VerifyQuestion'. The default is 20 seconds
			<br>
		
			&nbsp;&nbsp; <b>MaximumTime:</b>
			numeric, optional, MaximumTime - The maximum amount of time it should take a user to complete the form. Submissions slower than this will be rejected when calling 'VerifyQuestion'. The default is 20 minutes
			<br>
		
			&nbsp;&nbsp; <b>AdditionalQuestions:</b>
			array, optional, AdditionalQuestions - Provide an array of Question structs ({Question = 'TheQuestion', Answer = 'The Answer'}) to append to the list of questions defined in the object.
			<br>
		
	<br>
	</td></tr>



</table>

</body></html>
