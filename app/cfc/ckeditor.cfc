component {
    
    public string function encodeForDB(required string text) {
        local.encodeText = replace(arguments.text, Chr(10) & Chr(13), "<br>", "all");
        local.encodeText = replace(local.encodeText, " ", "&nbsp;", "all");
        return local.encodeText;
    }

}