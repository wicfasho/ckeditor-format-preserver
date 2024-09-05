component {

    public void function onApplicationStart(){
        structClear(application)
        application.name = "CK_Test";

        createDatabaseSchema();
    }

    private void function createDatabaseSchema() {
        schemaFilePath = expandPath("/mysql/schema.sql");
        schemaSQL = fileRead(schemaFilePath);
        
        sqlStatements = listToArray(schemaSQL, ";");

        for (statement in sqlStatements) {
            if (trim(statement) neq "") {
                try {
                    executeSQL(statement & ";");
                } catch (any e) {
                    writeOutput("Error executing SQL statement: " & e.message);
                }
            }
        }
    }

    private function executeSQL(required string sql) {
        var queryResult = "";
        try {
            queryResult = queryExecute(sql, [], {datasource: "ckeditor_test"});
        } catch (any e) {
            writeOutput("Error executing SQL: " & e.message);
        }
        return queryResult;
    }

}