# writing-idempotent-backend-methods-in-salesforce

This code repository contains a sample salesforce app that was created along with this blog post:  
[https://tython.co/salesforce/apex/2021/03/25/writing-idempotent-backend-methods-in-salesforce.html](https://tython.co/salesforce/apex/2021/03/25/writing-idempotent-backend-methods-in-salesforce.html)

The code in the repo is in the Salesforce DX layout. More information on working with sfdx projects can be found here:  
[https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_source_file_format.htm](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_source_file_format.htm) 

After creating a salesforce org for testing, and pushing/deploying this code to your org, you will also want to assign the permission set to your user so you can access the app:

```
sfdx force:user:permset:assign --permsetname=MovieRatingPermissions --targetusername=<your_user_name>
```

Then if you navigate to the "Rate Movies" application, and create a Movie record, you will see our movie rating app at the bottom of the Movie page layout. 
