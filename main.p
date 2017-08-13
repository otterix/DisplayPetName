/* description:
   This is the starting file
   This is the front end and will display results

   steps:
   It calls JSONread.p to get data and returns with payload
   It calls buslogic.p to apply any relevant business logic
   finally displaying results

   This is written in Progress language
   */
{shared.i}

/* variable definitions */
DEF VAR cURL AS CHAR NO-UNDO.
DEF VAR lRetOK AS LOG NO-UNDO.

main: DO WHILE TRUE ON ENDKEY UNDO,LEAVE:

  /* hardcode a default link for now */
  /* could be an input or read from config/db */
  cURL = "http://agl-developer-test.azurewebsites.net/people.json".
  /* fetch data */
  RUN JSONread.p (INPUT cURL, INPUT-OUTPUT TABLE ttPets, OUTPUT lRetOK).
  IF !lRetOK THEN
  DO:
    /* if error display to let user know */
    DISPLAY "Error in reading from data source."
    RETURN.
  END.

  /* it is usually good practice to separate business rules and display layer */
  RUN buslogic.p (INPUT-OUTPUT TABLE ttPets, OUTPUT lRetOK).
  IF !lRetOK THEN
  DO:
    /* if error display to let user know */
    DISPLAY "Error in applying data logic."
    RETURN.
  END.

  /* I will apply direct display manipulation thru
  the use of internal temp-table sorting mechanism
  to achieve descending gender and asending petname */
  FOR EACH ttPets
    WHERE ttPets.pettype = "Cat"
    BREAK BY ttPets.gender DESC
          BY ttPets.petname ASC
    :
    DISPLAY ttPets.gender
            ttPets.petname.
  END.
END.
