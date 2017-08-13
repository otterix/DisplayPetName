/*  description:
    this file is to read JSON data from a URL and return the payload */

/* include any shared definitions */
{shared.i}

DEF INPUT PARAM cURL AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR ttPets.
DEF OUTPUT PARAM lRetOK AS LOG NO-UNDO.

/* define variables */
DEF VAR cSourceType AS CHAR.
DEF VAR lcJSON AS LONGCHAR.
DEF VAR cReadMode AS CHAR.

/* define dataset and bind to temp-table */
DEFINE DATASET dsPets FOR ttPets.

/* define handle for dataset */
DEFINE VARIABLE hdsPets AS HANDLE NO-UNDO.
hdsPets = DATASET dsPets:HANDLE.

/* core code to read data */
main:
  lRetOK = TRUE.
  RUN ipReadData.
  IF !lRetOK THEN RETURN.

  RUN ipDoChecks.
  IF !lRetOK THEN RETURN.
END.

/* internal procs */
PROCEDURE ipReadData (INPUT-OUTPUT lRetOK):
  ASSIGN
     cSourceType = "LONGCHAR"
     cReadMode   = "EMPTY".

     lRetOK = hdsPets:READ-JSON(cURL, cSourceType, lcJSON, cReadMode) NO-ERROR.

  IF NOT lRetOK THEN
  DO:
    RUN Common/writeLogMessage.p (INPUT "ER#### - Unable to read message").
    RETURN.
  END.
END PROCEDURE.

PROCEDURE ipDoChecks:
  /* do any relevant validations */
  FIND FIRST ttPets NO-ERROR.
  IF NOT AVAIL ttPets THEN
  DO:
    lRetOK = FALSE.
    RUN Common/writeLogMessage.p (INPUT "ER#### - Payload message not found").
    RETURN.
  END.
END.
