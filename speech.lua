Speech = Object:extend()

function Speech:new()
	self.speechRecog = luacom.CreateObject("SAPI.SpInprocRecognizer")
	self.cAudioInputs = self.speechRecog:GetAudioInputs()
	print(self.cAudioInputs.Get)
	self.speechRecog.AudioInput = self.cAudioInputs:Item(0)
	self.cContext = self.speechRecog:CreateRecoContext()
    self.cGrammar = self.cContext:CreateGrammar()
	self.cRules = self.cGrammar:Rules()
	self.cRule = self.cRules:Add("WordsRule", 33)
	
	--SpeechRecognizer.Contexts[self.cContext] = self
	--self.Prompting = False

	--ComObjConnect(self.cContext, "SpeechRecognizer_") ;connect the recognition context events to functions
end
--[[
function Speech:recognize(values)
	local values = values or true
        if values then
            self.Listen(True)
            If IsObject(Values) ;list of phrases to use
                self.Phrases(Values)
            Else ;recognize any phrase
                self.Dictate(True)
        else
            self.Listen(False)
        Return, self
end

function Speech:listen(state)
	local state = state or true
	assert()
			If State
                self.cListener.State := 1 ;SRSActive
            Else
                self.cListener.State := 0 ;SRSInactive
            throw Exception("Could not set listener state: " . e.Message)
        Return, self
end

function Speech:prompt(timeout)
    local timeout = timeout or -1
        self.Prompting := True
        self.SpokenText := ""
        If Timeout < 0 ;no timeout
        {
            While, self.Prompting
                Sleep, 0
        }
        Else
        {
            StartTime := A_TickCount
            While, self.Prompting && (A_TickCount - StartTime) > Timeout
                Sleep, 0
        }
        Return, self.SpokenText
end

function Speech:phrases(PhraseList)
        assert()
		self.cRule.Clear() ;reset rule to initial state
        throw Exception("Could not reset rule: " . e.Message)

        assert()
		cState := self.cRule.InitialState() ;obtain rule initial state (ISpeechGrammarRuleState object)
        throw Exception("Could not obtain rule initial state: " . e.Message)

        cNull := ComObjParameter(13,0) ;null IUnknown pointer
        For Index, Phrase In PhraseList
        {
            assert()
			cState.AddWordTransition(cNull, Phrase) ;add a no-op rule state transition triggered by a phrase
            throw Exception("Could not add rule """ . Phrase . """: " . e.Message)
        }

        assert()
		self.cRules.Commit() ;compile all rules in the rule collection
        throw Exception("Could not update rule: " . e.Message)

        self.Dictate(False) ;disable dictation mode
        Return, self
end

function Speech:dictate(enable)
    local enable = enable or true
		assert()
            If Enable
                self.cGrammar.DictationSetState(1) ;enable dictation mode (SGDSActive)
                self.cGrammar.CmdSetRuleState("WordsRule", 0) ;disable the rule (SGDSInactive)
            Else
                self.cGrammar.DictationSetState(0) ;disable dictation mode (SGDSInactive)
                self.cGrammar.CmdSetRuleState("WordsRule", 1) ;enable the rule (SGDSActive)
        throw Exception("Could not set grammar dictation state: " . e.Message)
        Return, self
end

function Speech:onRecognize(Text)
    {
        ;placeholder function meant to be overridden in subclasses
    }
end

function Speech:__delete()
    self.base.Contexts.Remove(&self.cContext, "")
end

SpeechRecognizer_Recognition(StreamNumber, StreamPosition, RecognitionType, cResult, cContext) ;speech recognition engine produced a recognition
{
    try
    {
       pPhrase := cResult.PhraseInfo() ;obtain detailed information about recognized phrase (ISpeechPhraseInfo object from ISpeechRecoResult object)
       Text := pPhrase.GetText() ;obtain the spoken text
    }
    catch e
        throw Exception("Could not obtain recognition result text: " . e.Message)

    Instance := Object(SpeechRecognizer.Contexts[&cContext]) ;obtain reference to the recognizer

    ;handle prompting mode
    If Instance.Prompting
    {
        Instance.SpokenText := Text
        Instance.Prompting := False
    }

    Instance.OnRecognize(Text) ;invoke callback in recognizer
}]]