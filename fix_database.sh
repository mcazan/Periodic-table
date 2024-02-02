#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# You should rename the weight column to atomic_mass
RENAME_WEIGHT=$($PSQL "ALTER TABLE properties RENAME COLUMN weight TO atomic_mass")
if [[ $RENAME_WEIGHT == "ALTER TABLE" ]]
then
  echo -e "\nRenamed column weight in properties table.\n"
else
  echo "Error"  
fi
 
# You should rename the melting_point column to melting_point_celsius and the boiling_point column to boiling_point_celsius
RENAME_MELTING_POINT=$($PSQL"ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius")
RENAME_BOILING_POINT=$($PSQL"ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius")
if [[ $RENAME_MELTING_POINT == "ALTER TABLE" ]]
then
  echo -e "\nRenamed column melting_point in properties table.\n"
else
  echo "Error"  
fi
if [[ $RENAME_BOILING_POINT == "ALTER TABLE" ]]
then
  echo -e "\nRenamed column boiling_point in properties table.\n"
else
  echo "Error"  
fi
  
# Your melting_point_celsius and boiling_point_celsius columns should not accept null values
ALTER_MELTING_POINT_NOT_NULL=$($PSQL"ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL")
ALTER_BOILING_POINT_NOT_NULL=$($PSQL "ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL")
if [[ $ALTER_MELTING_POINT_NOT_NULL == "ALTER TABLE" ]]
then
  echo -e "\nAdded constraint NOT NULL for column melting_point in properties table.\n"
else
  echo "Error"    
fi
if [[ $ALTER_BOILING_POINT_NOT_NULL == "ALTER TABLE" ]]
then
  echo -e "\nAdded constraint NOT NULL for column boiling_point in properties table.\n"
else
  echo "Error"    
fi
  
# You should add the UNIQUE constraint to the symbol and name columns from the elements table
ALTER_SYMBOL_UNIQUE=$($PSQL "ALTER TABLE elements ADD UNIQUE(symbol)")
ALTER_NAME_UNIQUE=$($PSQL "ALTER TABLE elements ADD UNIQUE(name)")
if [[ $ALTER_SYMBOL_UNIQUE == "ALTER TABLE" ]]
then
  echo -e "\nAdded constraint UNIQUE for column symbol in elements table.\n"
else
  echo "Error"  
fi
if [[ $ALTER_NAME_UNIQUE == "ALTER TABLE" ]]
then
  echo -e "\nAdded constraint UNIQUE for column name in elements table.\n"
else
  echo "Error"    
fi

# Your symbol and name columns should have the NOT NULL constraint
ALTER_SYMBOL_NOT_NULL=$($PSQL "ALTER TABLE elements ALTER COLUMN symbol SET NOT NULL")
ALTER_NAME_NOT_NULL=$($PSQL "ALTER TABLE elements ALTER COLUMN name SET NOT NULL")
if [[ $ALTER_SYMBOL_NOT_NULL == "ALTER TABLE" ]]
then
  echo -e "\nAdded constraint NOT NULL for column symbol in elements table.\n"
else
  echo "Error"    
fi
if [[ $ALTER_NAME_NOT_NULL == "ALTER TABLE" ]]
then
  echo -e "\nAdded constraint NOT NULL for column name in elements table.\n"
else
  echo "Error"    
fi

# You should set the atomic_number column from the properties table as a foreign key that references the column of the same name in the elements table
ALTER_ATOMIC_NUMBER_FOREIGN_KEY=$($PSQL "ALTER TABLE properties ADD FOREIGN KEY (atomic_number) REFERENCES elements(atomic_number)")
if [[ $ALTER_ATOMIC_NUMBER_FOREIGN_KEY == "ALTER TABLE" ]]
then
  echo -e "\nAdded atomic_number as foreign key for properties table to elements table.\n"
else
  echo "Error"    
fi

# You should create a types table that will store the three types of elements
CREATE_TABLE_TYPES=$($PSQL "CREATE TABLE types()")
if [[ $CREATE_TABLE_TYPES == "CREATE TABLE" ]]
then
  echo -e "\nCreated types table.\n"
else
  echo "Error"    
fi

# Your types table should have a type_id column that is an integer and the primary key
ADD_COLUMN_TYPE_ID=$($PSQL "ALTER TABLE types ADD COLUMN type_id SERIAL PRIMARY KEY")
if [[ $ADD_COLUMN_TYPE_ID == "ALTER TABLE" ]]
then
  echo -e "\nAdded column type_id in types table.\n"
else
  echo "Error"    
fi

# Your types table should have a type column that's a VARCHAR and cannot be null. It will store the different types from the type column in the properties table
ADD_COLUMN_TYPE=$($PSQL "ALTER TABLE types ADD COLUMN type VARCHAR(30) NOT NULL")
if [[ $ADD_COLUMN_TYPE == "ALTER TABLE" ]]
then
  echo -e "\nAdded column type in types table.\n"
else
  echo "Error"    
fi

# You should add three rows to your types table whose values are the three different types from the properties table
INSERT_COLUMN_TYPE=$($PSQL "INSERT INTO types(type) SELECT DISTINCT(type) FROM properties")
if [[ $INSERT_COLUMN_TYPE == "INSERT 0 3" ]]
then
  echo -e "\nInserted values in types table.\n"
else
  echo "Error"    
fi

# Your properties table should have a type_id foreign key column that references the type_id column from the types table. It should be an INT with the NOT NULL constraint
ADD_COLUMN_TYPE_ID=$($PSQL "ALTER TABLE properties ADD COLUMN type_id INT")
ADD_FOREIGN_KEY_TYPE_ID=$($PSQL "ALTER TABLE properties ADD FOREIGN KEY (type_id) REFERENCES types(type_id)")
if [[ $ADD_COLUMN_TYPE_ID == "ALTER TABLE" ]]
then
  echo -e "\nAdded column type_id in properties table.\n"
else
  echo "Error"    
fi
if [[ $ADD_FOREIGN_KEY_TYPE_ID == "ALTER TABLE" ]]
then
  echo -e "\nSet column type_id as foreign key.\n"
else
  echo "Error"    
fi

# Each row in your properties table should have a type_id value that links to the correct type from the types table
UPDATE_TYPE_ID=$($PSQL "UPDATE properties SET type_id = types.type_id FROM types WHERE properties.type=types.type")
ALTER_COLUMN_TYPE_ID_NOT_NULL=$($PSQL "ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL")
if [[ $UPDATE_TYPE_ID == "UPDATE 9" ]]
then
  echo -e "\nUpdated column type_id in properties table to correspond to the correct type from the types table.\n"
else
  echo "Error"    
fi
if [[ $ALTER_COLUMN_TYPE_ID_NOT_NULL == "ALTER TABLE" ]]
then
  echo -e "\nSet column type_id in properties table to NOT NULL.\n"
else
  echo "Error"    
fi

# You should capitalize the first letter of all the symbol values in the elements table. Be careful to only capitalize the letter and not change any others
UPDATE_SYMBOL=$($PSQL "UPDATE elements SET symbol=INITCAP(symbol)")
if [[ $UPDATE_SYMBOL == "UPDATE 9" ]]
then
  echo -e "\nCapitalized the first letter of all the symbol values in the elements table.\n"
else
  echo "Error"    
fi

# You should remove all the trailing zeros after the decimals from each row of the atomic_mass column. You may need to adjust a data type to DECIMAL for this. The final values they should be are in the atomic_mass.txt file
ALTER_ATOMIC_MASS_VARCHAR=$($PSQL "ALTER TABLE properties ALTER COLUMN atomic_mass TYPE DECIMAL")
REMOVE_TRAILING_ATOMIC_MASS=$($PSQL"UPDATE properties SET atomic_mass = (atomic_mass::REAL)::DECIMAL")
#ALTER_ATOMIC_MASS_DECIMAL=$($PSQL"ALTER TABLE properties ALTER COLUMN atomic_mass TYPE DECIMAL USING atomic_mass::NUMERIC;")
if [[ $ALTER_ATOMIC_MASS_VARCHAR == "ALTER TABLE" ]]
then
  echo -e "\nChanged atomic_mass column type to DECIMAL.\n"
else
  echo "Error"    
fi
if [[ $REMOVE_TRAILING_ATOMIC_MASS == "UPDATE 9" ]]
then
  echo -e "\nRemoved all the trailing zeros after the decimals from each row of the atomic_mass column.\n"
else
  echo "Error"    
fi

# You should add the element with atomic number 9 to your database. Its name is Fluorine, symbol is F, mass is 18.998, melting point is -220, boiling point is -188.1, and it's a nonmetal
INSERT_ELEMENT_F=$($PSQL "INSERT INTO elements VALUES (9,'F','Fluorine')")
INSERT_PROPERTIES_F=$($PSQL "INSERT INTO properties VALUES (9,'nonmetal', 18.998,-220,-188.1, 3)")
if [[ $INSERT_ELEMENT_F == "INSERT 0 1" ]]
then
  echo -e "\nAdded the element with atomic number 9 in elements table.\n"
else
  echo "Error"    
fi
if [[ $INSERT_PROPERTIES_F == "INSERT 0 1" ]]
then
  echo -e "\nAdded the element with atomic number 9 in properties table.\n"
else
  echo "Error"    
fi

# You should add the element with atomic number 10 to your database. Its name is Neon, symbol is Ne, mass is 20.18, melting point is -248.6, boiling point is -246.1, and it's a nonmetal
INSERT_ELEMENT_NE=$($PSQL "INSERT INTO elements VALUES (10,'Ne','Neon')")
INSERT_PROPERTIES_NE=$($PSQL "INSERT INTO properties VALUES (10,'nonmetal', 20.18, -248.6,-246.1, 3)")
if [[ $INSERT_ELEMENT_NE == "INSERT 0 1" ]]
then
  echo -e "\nAdded the element with atomic number 10 in elements table.\n"
else
  echo "Error"    
fi
if [[ $INSERT_PROPERTIES_NE == "INSERT 0 1" ]]
then
  echo -e "\nAdded the element with atomic number 10 in properties table.\n"
else
  echo "Error"    
fi

# You should delete the non existent element, whose atomic_number is 1000, from the two tables
DELETE_PROPERTIES_1000=$($PSQL "DELETE FROM properties WHERE atomic_number=1000")
DELETE_ELEMENTS_1000=$($PSQL "DELETE FROM elements WHERE atomic_number=1000")
if [[ $DELETE_PROPERTIES_1000 == "DELETE 1" ]]
then
  echo -e "\nDeleted the element with atomic_number 1000 from properties tables.\n"
else
  echo "Error"    
fi
if [[ $DELETE_ELEMENTS_1000 == "DELETE 1" ]]
then
  echo -e "\nDeleted the element with atomic_number 1000 from elements tables.\n"
else
  echo "Error"    
fi

# Your properties table should not have a type column
DELETE_COLUMN_TYPE=$($PSQL "ALTER TABLE properties DROP COLUMN type")
if [[ $DELETE_COLUMN_TYPE == "ALTER TABLE" ]]
then
  echo -e "\nDeleted column type from properties table.\n"
else
  echo "Error"    
fi
