<cfcomponent displayname="Human Dector" hint="Utility functions to determine if the being completing a form is indeed human." output="false">

	<cfset Variables.Instance = {
		Questions = [
			{
				Question = "What year is it (use 4 digits)?"
				, Answer = Year(Now())
			}
			, {
				Question = "What month number is it (ex: October is 10)?"
				, Answer = Month(Now())
			}
			, {
				Question = "What day of the month is it?"
				, Answer = Day(Now())
			}
			, {
				Question = "What is 5 multiplied by 3?"
				, Answer = 15
			}
			, {
				Question = "What is half of 50?"
				, Answer = 25
			}
			, {
				Question = "How many quarters are in a dollar?"
				, Answer = 4
			}
			, {
				Question = "How many pennies are in a quarter?"
				, Answer = 25
			}
			, {
				Question = "Is grass green, blue, or purple?"
				, Answer = "green"
			}
			, {
				Question = "What do you add to 2 to get 4?"
				, Answer = "2"
			}
			, {
				Question = "The US Flag is red, white, and what color?"
				, Answer = "blue"
			}
			, {
				Question = "What number minus 5 equals 5?"
				, Answer = "10"
			}
		]
	} />

	<cffunction name="init" output="false" returntype="HumanDetector" access="public" hint="Initializes the object and returns an instance.">
		<cfargument name="Key" type="string" required="true" hint="Key to use for Encrypting and Decrypting confirmation values." />
		<cfargument name="MinimumTime" type="numeric" required="false" default="20" hint="The minimum amount of time it should take a user to complete the form (in seconds). Submissions faster than this will be rejected when calling 'VerifyQuestion'. The default is 20 seconds" />
		<cfargument name="MaximumTime" type="numeric" required="false" default="1200" hint="The maximum amount of time it should take a user to complete the form. Submissions slower than this will be rejected when calling 'VerifyQuestion'. The default is 20 minutes" />
		<cfargument name="AdditionalQuestions" type="array" required="false" hint="Provide an array of Question structs ({Question = 'TheQuestion', Answer = 'The Answer'}) to append to the list of questions defined in the object." />

		<cfif StructKeyExists(Arguments, "AdditionalQuestions")>
			<cfloop array="#AdditionalQuestions#" index="curQuestion">
				<cfset ArrayAppend(Variables.Instance.Questions, curQuestion) />
			</cfloop>
		</cfif>

		<cfset Variables.Instance.Key = Arguments.Key />
		<cfset Variables.Instance.MinimumTime = Arguments.MinimumTime />
		<cfset Variables.Instance.MaximumTime = Arguments.MaximumTime />

		<cfreturn this />

	</cffunction>

	<cffunction name="addQuestion" output="false" returntype="void" access="public" hint="Add a single question to the list of questions.">
		<cfargument name="Question" type="string" required="true" hint="The question to ask the user." />
		<cfargument name="Answer" type="string" required="true" hint="The answer to the question." />

		<cfset var theQuestion = {Question = Arguments.Question, Answer = Arguments.Answer} />
		<cfset ArrayAppend(Variables.Instance.Questions, theQuestion) />

	</cffunction>

	<cffunction name="getQuestionForForm" output="false" returntype="Struct" access="public" hint="Returns a structure containing a 'ConfirmValue' and 'Question'. The ConfirmValue is URLEncoded, and should be placed in a hidden form field and passed to the checkAnswer function after the answer has been collected from the user.">
		<!--- First, randomly pick a question from the list of available questions --->
		<cfset var arrayIndex = RandRange(1, ArrayLen(Variables.Instance.Questions)) />
		<cfset var theQuestion = Variables.Instance.Questions[arrayIndex].Question />

		<!--- Now that we have the text of the question, create the return values. Encrpyt the arrayIndex, the Question text, and the UnixTime at the time the question was requested --->
		<cfset var retVal = {
			Question = theQuestion
			, ConfirmValue = URLEncodedFormat(Encrypt(arrayIndex & "~" & theQuestion & "~" & convertToUnixTime(Now()), Variables.Instance.Key))
		} />

		<cfreturn retVal />

	</cffunction>

	<cffunction name="checkAnswer" output="false" returntype="Struct" access="public" hint="Confirms the answer for a question. You must supply the ConfirmValue string returned from getQuestionForForm, as well as the Answer to the question. A struct will be returned with Success and Reasons nodes.<br /><br />Success: true or false<br />Reasons: an array of reasons the check failed, if there are any">
		<cfargument name="ConfirmValue" type="string" required="true" hint="The ConfirmValue generated using getQuestionForForm." />
		<cfargument name="Answer" type="string" required="true" hint="The answer to the question." />

		<!--- Create a local structure --->
		<cfset var LOCAL = {} />
		<cfset var retVal = {Success = False, Reasons = ArrayNew(1)} />

		<!--- Check for a valid confirmValue. If it doesn't exist, then the form was submitted incorrectly --->
		<cfif Arguments.ConfirmValue EQ "">
			<cfset ArrayAppend(retVal.Reasons, "The form was modified from its original state.") />
			<cfreturn retVal />
		</cfif>

		<!--- Decrypt the ConfirmValue --->
		<cfset Arguments.ConfirmValue = Decrypt(URLDecode(Arguments.ConfirmValue), Variables.Instance.Key) />
		<cfset LOCAL.arIndex = Val(ListFirst(Arguments.ConfirmValue, "~")) />

		<!--- First, check to make sure that the form was submitted within the proper time frame --->
		<cfset LOCAL.AnswerSpeed = DateDiff("s", convertUnixTimeToDate(Val(ListLast(Arguments.ConfirmValue, "~"))), Now()) />

		<cfif LOCAL.AnswerSpeed LT Variables.Instance.MinimumTime>
			<cfset ArrayAppend(retVal.Reasons, "Form submitted in less than #Variables.Instance.MinimumTime# seconds.") />

		<cfelseif LOCAL.AnswerSpeed GT Variables.Instance.MaximumTime>
			<cfset ArrayAppend(retVal.Reasons, "Form submitted slower than #Variables.Instance.MaximumTime# seconds.") />

		</cfif>

		<!--- Make sure that the ArrayIndex from the confirm value is actually within the array range --->
		<cfif LOCAL.arIndex LTE 0 OR ArrayLen(Variables.Instance.Questions) LT LOCAL.arIndex>
			<cfset ArrayAppend(retVal.Reasons, "The question answered is not in the list of available questions.") />
		</cfif>

		<!--- If we made it past the previous checks, then verify that the answer is correct --->
		<cfif ArrayIsEmpty(retVal.Reasons)>
			<!--- Check the answer --->
			<cfset LOCAL.theQuestion = Variables.Instance.Questions[ListFirst(Arguments.ConfirmValue, "~")] />

			<cfif LOCAL.theQuestion.Question NEQ ListGetAt(Arguments.ConfirmValue, 2, "~")>
				<!--- It's possible that there are two questions with the same answer. Make sure that the user is answering the question they were asked --->
				<cfset ArrayAppend(retVal.Reasons, "The question answered isn't the same as the question asked.") />

			<cfelseif Arguments.Answer NEQ LOCAL.theQuestion.Answer>
				<!--- The user's answer wasn't correct... --->
				<cfset ArrayAppend(retVal.Reasons, "The answer is incorrect.") />

			<cfelse>
				<!--- No errors happened, and the user answer their question correctly, they're human! --->
				<cfset retVal.Success = True />
			</cfif>
		</cfif>

		<cfreturn retVal />

	</cffunction>

	<cffunction name="getQuestions" output="false" returntype="array" access="public" hint="Returns an array of possible questions.">
		<cfreturn Variables.Instance.Questions />
	</cffunction>

	<cffunction name="convertToUnixTime" access="private" output="false" returntype="numeric" hint="Converts a date string to UnixTime.">
		<cfargument name="Date" type="date" required="false" default="#Now()#" hint="The date (to the second) to be converted to UnixTime. If no date is supplied, then Now() will be used." />
		<cfreturn DateDiff("s", "1970-01-01", Arguments.Date) />
	</cffunction>

	<cffunction name="convertUnixTimeToDate" access="private" output="false" returntype="date" hint="Converts a UnixTime string to a valid date.">
		<cfargument name="UnixTime" type="numeric" required="true" hint="The UnixTime to be converted to a Date." />
		<cfreturn DateAdd("s", Arguments.UnixTime, "1970-01-01") />
	</cffunction>

</cfcomponent>