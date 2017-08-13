/* description:
   this stores all shared declarations of definitions */

/* Define temp-table for datastore */
DEFINE TEMP-TABLE ttPets NO-UNDO
  FIELD ownername AS CHAR
  FIELD gender AS CHAR
  FIELD age AS INT
  FIELD petname AS CHAR
  FIELD pettype AS CHAR.
