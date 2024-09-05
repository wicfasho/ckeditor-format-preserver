component {

    public boolean function saveContent(required string content) {
        var result = false;
        local.CK = new ckeditor()

        try {
            queryExecute("
                INSERT INTO user_content (user_id, content) VALUES (1, :content)
            ", {
                content: {cfsqltype="cf_sql_clob", value=local.CK.encodeForDB(arguments.content)}
            },{
                datasource: "ckeditor_test"
            })
            result = true;
        } catch (any e) {
            writeDump(e);
            result = false;
        }

        return result;
    }

    public query function getAllContent() {
        local.result = new query();

        try {
            local.result = queryExecute("
                SELECT * FROM user_content ORDER BY created_at DESC
            ", [], {
                datasource: "ckeditor_test"
            })
        } catch (any e) {
            writeDump(e);
        }

        return result;
    }

}
