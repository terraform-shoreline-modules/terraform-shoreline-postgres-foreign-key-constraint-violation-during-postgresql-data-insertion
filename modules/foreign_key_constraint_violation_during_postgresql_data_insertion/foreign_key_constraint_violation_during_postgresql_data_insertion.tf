resource "shoreline_notebook" "foreign_key_constraint_violation_during_postgresql_data_insertion" {
  name       = "foreign_key_constraint_violation_during_postgresql_data_insertion"
  data       = file("${path.module}/data/foreign_key_constraint_violation_during_postgresql_data_insertion.json")
  depends_on = [shoreline_action.invoke_check_foreign_key_format,shoreline_action.invoke_validate_table_data]
}

resource "shoreline_file" "check_foreign_key_format" {
  name             = "check_foreign_key_format"
  input_file       = "${path.module}/data/check_foreign_key_format.sh"
  md5              = filemd5("${path.module}/data/check_foreign_key_format.sh")
  description      = "Incorrect data type or format: If the foreign key column data type is not the same as the primary key column data type or if the data format in the foreign key column does not match the data format in the primary key column, it can cause a foreign key constraint violation error during data insertion."
  destination_path = "/tmp/check_foreign_key_format.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "validate_table_data" {
  name             = "validate_table_data"
  input_file       = "${path.module}/data/validate_table_data.sh"
  md5              = filemd5("${path.module}/data/validate_table_data.sh")
  description      = "Check the data being inserted into the tables. Ensure that the data matches the expected data type and format."
  destination_path = "/tmp/validate_table_data.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_check_foreign_key_format" {
  name        = "invoke_check_foreign_key_format"
  description = "Incorrect data type or format: If the foreign key column data type is not the same as the primary key column data type or if the data format in the foreign key column does not match the data format in the primary key column, it can cause a foreign key constraint violation error during data insertion."
  command     = "`chmod +x /tmp/check_foreign_key_format.sh && /tmp/check_foreign_key_format.sh`"
  params      = ["PRIMARY_KEY_COLUMN","FOREIGN_KEY_COLUMN","FOREIGN_KEY_TABLE_NAME","DATABASE_NAME","TABLE_NAME"]
  file_deps   = ["check_foreign_key_format"]
  enabled     = true
  depends_on  = [shoreline_file.check_foreign_key_format]
}

resource "shoreline_action" "invoke_validate_table_data" {
  name        = "invoke_validate_table_data"
  description = "Check the data being inserted into the tables. Ensure that the data matches the expected data type and format."
  command     = "`chmod +x /tmp/validate_table_data.sh && /tmp/validate_table_data.sh`"
  params      = ["DATA_TYPE","DATABASE_NAME","TABLE_NAME","DATA_FORMAT"]
  file_deps   = ["validate_table_data"]
  enabled     = true
  depends_on  = [shoreline_file.validate_table_data]
}

