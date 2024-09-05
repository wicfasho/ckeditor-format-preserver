<cfset db = new cfc.db()>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CKEditor 5</title>
		<link rel="stylesheet" href="https://cdn.ckeditor.com/ckeditor5/43.0.0/ckeditor5.css">
        <style>
            .main-container {
                width: 795px;
                margin-left: auto;
                margin-right: auto;
            }

            button {
                margin-top: 2px;
                background-color: blue;
                padding: 5px;
                border: none;
                color: white;
                width: 100%;
                cursor: pointer;
            }

            .ck-editor__editable_inline {
                min-height: 100px;
            }
        </style>
    </head>
    <body>
        <cfif structKeyExists(form, "submitForm")>
            <cfcontent reset="true">
            <cfset saved = db.saveContent(form.textContent)>
        
            <cfif saved>
                <p>Content saved successfully!</p>
            <cfelse>
                <p>Error saving content!</p>
            </cfif>
        </cfif>
        
        <div class="main-container">
            <h2>Enter your text below</h2>

            <form name="formCKEditor" action="" method="post">
                <div id="editor">
                    <p>Hello from CKEditor 5!</p>
                </div>

                <button type="button" id="submitForm" name="submitForm">Submit</button>
            </form>

            <h2>CKEditor Text from DB</h2>
            
            <cfscript>
                contentQuery = db.getAllContent();
            
                if (contentQuery.recordCount > 0) {
                    for (i = 1; i <= contentQuery.recordCount; i++) {
                        writeOutput("<h3>Entry " & i & ":</h3>");
                        writeOutput(contentQuery.content[i] & "<br>");
                    }
                } else {
                    writeOutput("<p>No content available.</p>");
                }
            </cfscript>
		</div>

        <script type="importmap">
            {
                "imports": {
                    "ckeditor5": "https://cdn.ckeditor.com/ckeditor5/43.0.0/ckeditor5.js",
                    "ckeditor5/": "https://cdn.ckeditor.com/ckeditor5/43.0.0/"
                }
            }
        </script>
        <script type="module">
            import {
                ClassicEditor,
                Essentials,
                Paragraph,
                Bold,
                Italic,
                Font
            } from 'ckeditor5';

            ClassicEditor
                .create( document.querySelector( '#editor' ), {
                    plugins: [ Essentials, Paragraph, Bold, Italic, Font ],
                    toolbar: [
						'undo', 'redo', '|', 'bold', 'italic', '|',
						'fontSize', 'fontFamily', 'fontColor', 'fontBackgroundColor'
                    ]
                } )
                .then( editor => {
                    window.editor = editor;
                } )
                .catch( error => {
                    console.error( error );
                } );
        </script>
        <script>
            window.onload = function() {
                if ( window.location.protocol === "file:" ) {
                    alert( "This sample requires an HTTP server. Please serve this file with a web server." );
                }
            };

            document.getElementById('submitForm').addEventListener('click', async function() {
                let editorContent = editor.getData();

                let data = new URLSearchParams();
                data.append('submitForm', true);
                data.append('textContent', editorContent);

                try {
                    let response = await fetch('test.cfm', {
                        method: 'POST',
                        body: data,
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                        }
                    });

                    if (response.ok) {
                        let result = await response.text();
                        console.log('Success:', result);
                        alert('Content saved successfully!');
                        window.location.reload()
                    } else {
                        console.error('Failed:', response.statusText);
                        alert('Error saving content!');
                    }
                } catch (error) {
                    console.error('Error:', error);
                    alert('An error occurred while submitting the form.');
                }
            });
		</script>
    </body>
</html>