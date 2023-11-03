

#!/bin/bash



# Define variables

TABLE_NAME=${TABLE_NAME}

EXPECTED_DATA_TYPE=${DATA_TYPE}

EXPECTED_FORMAT=${DATA_FORMAT}



# Check data in table

if psql -d ${DATABASE_NAME} -c "SELECT COUNT(*) FROM $TABLE_NAME WHERE data_type != '$EXPECTED_DATA_TYPE' OR data_format != '$EXPECTED_FORMAT';" | grep -q "0"; then

  echo "Data in $TABLE_NAME matches expected data type and format."

else

  echo "Data in $TABLE_NAME does not match expected data type and format."

  # Remediate by correcting the data in the table

  psql -d ${DATABASE_NAME} -c "UPDATE $TABLE_NAME SET data_type='$EXPECTED_DATA_TYPE', data_format='$EXPECTED_FORMAT' WHERE data_type != '$EXPECTED_DATA_TYPE' OR data_format != '$EXPECTED_FORMAT';"

  echo "Data in $TABLE_NAME has been remediated."

fi