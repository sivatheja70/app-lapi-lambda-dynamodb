terraform_api-lambda-dynamodb-modules

Validation using POSTMAN

#GET /example
-copy the output url
-select GET method
-select Params and click send for output

#POST /example
-copy the output url
-select POST method.
-Select "Body" under that "raw" and select Json from the dropdown.
-Give input for example
 {
        "id": "01",
        "name": "John"
    }

 {
        "id": "02",
        "name": "sansa"
    }

#PUT /example
-copy the output url
-select POST method.
-Select "Body" under that "raw" and select Json from the dropdown.
-Give input for example
 {
        "id": "01",
        "name": "stark"
    }

#DELETE /example
-copy the output url
-select DELETE method.
-Select "Body" under that "raw" and select Json from the dropdown.
-Give input for example
 {
        "id": "01",
        "name": "stark"
    }