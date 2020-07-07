# MicroELI

Micro ELI (English Language Interpreter) takes in an input sentence and outputs its conceptual dependency (CD) form.

## How to Run

Install clisp. To run Micro ELI, run clisp, and once in the interpreter, run these lines:

(load 'micro-eli)

(process-text text)

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