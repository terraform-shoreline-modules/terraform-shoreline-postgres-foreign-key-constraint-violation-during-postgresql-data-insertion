
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Foreign Key Constraint Violation During PostgreSQL Data Insertion
---

This incident type involves the violation of a foreign key constraint during data insertion into a PostgreSQL database. A foreign key constraint is a mechanism used to ensure data integrity by requiring that a value in one table matches a value in another table. When this constraint is violated during data insertion, it can cause errors and potentially corrupt the database. This type of incident is typically caused by issues with data mapping or inconsistencies in the database schema.

### Parameters
```shell
export DATABASE_NAME="PLACEHOLDER"

export TABLE_NAME="PLACEHOLDER"

export PORT_NUMBER="PLACEHOLDER"

export PRIMARY_KEY_COLUMN="PLACEHOLDER"

export FOREIGN_KEY_TABLE_NAME="PLACEHOLDER"

export FOREIGN_KEY_COLUMN="PLACEHOLDER"

export DATA_FORMAT="PLACEHOLDER"

export DATA_TYPE="PLACEHOLDER"
```

## Debug

### Check if the PostgreSQL service is running
```shell
systemctl status postgresql.service
```

### Connect to the database and list all tables to check if foreign key constraints exist
```shell
sudo -u postgres psql -d ${DATABASE_NAME} -c "\d"
```

### Check the table schema to verify that foreign key constraints exist
```shell
sudo -u postgres psql -d ${DATABASE_NAME} -c "\d ${TABLE_NAME}"
```

### Check the data being inserted to verify that foreign key constraints are being satisfied
```shell
sudo -u postgres psql -d ${DATABASE_NAME} -c "SELECT * FROM ${TABLE_NAME}"
```

### Check if any other processes are accessing the database and causing conflicts
```shell
sudo lsof -i tcp:${PORT_NUMBER}
```

### Check if there are any pending transactions that could be causing conflicts
```shell
sudo -u postgres psql -d ${DATABASE_NAME} -c "SELECT * FROM pg_stat_activity WHERE datname = '${DATABASE_NAME}' AND state = 'idle in transaction'"
```

### Incorrect data type or format: If the foreign key column data type is not the same as the primary key column data type or if the data format in the foreign key column does not match the data format in the primary key column, it can cause a foreign key constraint violation error during data insertion.
```shell
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


```

## Repair

### Check the data being inserted into the tables. Ensure that the data matches the expected data type and format.
```shell


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


```