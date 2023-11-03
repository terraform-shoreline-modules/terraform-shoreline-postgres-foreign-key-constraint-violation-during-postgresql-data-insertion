bash

#!/bin/bash



# Define variables

DATABASE_NAME=${DATABASE_NAME}

FOREIGN_KEY_COLUMN=${FOREIGN_KEY_COLUMN}

PRIMARY_KEY_COLUMN=${PRIMARY_KEY_COLUMN}



# Check if the foreign key column data type matches the primary key column data type

if [[ $(psql $DATABASE_NAME -c "SELECT $FOREIGN_KEY_COLUMN FROM ${FOREIGN_KEY_TABLE_NAME}" | awk '{print $2}') != $(psql $DATABASE_NAME -c "SELECT $PRIMARY_KEY_COLUMN FROM ${TABLE_NAME}" | awk '{print $2}') ]]

then

    echo "Foreign key column data type does not match primary key column data type"

fi



# Check if the data format in the foreign key column matches the data format in the primary key column

if [[ $(psql $DATABASE_NAME -c "SELECT $FOREIGN_KEY_COLUMN FROM ${FOREIGN_KEY_TABLE_NAME}" | awk '{print $2}') != $(psql $DATABASE_NAME -c "SELECT $PRIMARY_KEY_COLUMN FROM ${TABLE_NAME}" | awk '{print $2}') ]]

then

    echo "Data format in foreign key column does not match data format in primary key column"

fi