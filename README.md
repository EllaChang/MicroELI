# MicroELI

Micro ELI (English Language Interpreter) takes in an input sentence and outputs its conceptual dependency (CD) form. BABEL takes in a CD form and outputs natural language sentences of the same meaning. Micro SAM (Script Applier Mechanism) matches stories to scripts (templates for stereotypical social situations).

## How to Run

Install clisp. To run Micro ELI, run clisp, and once in the interpreter, run this:

(load 'qa)

## Current Capabilities

<ul>
	<li>It can output the CD form of a simple statement. Given "jack got a red kite", it outputs: (ACTOR (JACK) <=> (*ATRANS*) OBJECT (KITE (COLOR (RED))) TO (JACK)).</li>
	<li>It can output the CD form of a simple question. Given "who went to the store", it outputs: (ACTOR (BOB) <=> (*PTRANS*) OBJECT (BOB) TO (*?*)).</li>
	<li>Combined with BABEL, it can produce natural language answers to a question given a simple story. If the story is ((jack went to the store) (bob went to the beach) (jack got a kite) (bob got a seashell)) and the question is "where did bob go", it outputs: (bob is going to beach) (bob is coming to beach).</li>
	<li>It can work with MicroSAM and answer questions given an input story.</li>
</ul>

## Current Limitations

<ul>
	<li>The current lexicon is small.</li>
	<li>More CD predicates need to be added.</li>
	<li>Distinguishing between word senses: To successfully parse "jack paid the check with a check", articles "the" and "a" must take on a different form of definition where they don't look for a noun to form a noun phrase. Otherwise, the control flow of the stack will not have given *predicted* a value by the time the program gets to the first "check". However, these alternative definitions will not correctly parse "jack got a red kite". In this scenario, "a" must look for an adjective to form a noun phrase so that the predicates defined in "red" can be appended to the final CD form.</li>
</ul>

## Conceptual Dependency Predicates

**ATRANS** - the transfer of an abstract relationship such as possession, ownership or control.

**PTRANS** - having physical movement.

**PSTAY** - PTRANS without location change.

**PBUILD** - the construction of a physical form.

**PREDUCTION** - the reduction of a physical form.

**PROPEL** - the application of a physical force to an object. If movement takes place as a result, a PTRANS has taken place too if it can be determined that the PROPEL was intended by the actor.

**MTRANS** - the transfer of information between animals or within an animal.

**MBUILD** - the construction within an animal of new information from old information.

**INGEST** - the taking in of an object by an animal into the inner workings of that animal.

**GRASP** - to grasp an object.

**ATTEND** - to focus a sense organ to an object.

**SPEAK** - to make a noise.

**MOVE** - to move a body part.

**EXPEL** - to push something out of the body.

**SEVER** - the division of something into separate parts.

**JOIN** - the joining of separate parts.