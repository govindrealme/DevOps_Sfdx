/* 
Apex Class: GetProductsFromNavision 
Operation : This is used to Upsert the Products in salesforce get the Items from Navision through JAVA REST Api
*/

 global class NavtoSfProduct {
    public String accessToken;
    public String username;
    public String password;
    public String responseData;
    
    public void getAccessToken(){
        username='salesforce-admin';
        password='salesforce@123';
        Http p = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://api.citizensparking.com/cppc-gateway/reef/products/access/token';
        endpoint = endpoint+'?grant_type=client_credentials';
        endpoint = endpoint+'&username='+username;
        endpoint = endpoint+='&password='+password;
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('API-KEY', '4b90ucfd0-765f-489f-ad6d-808c8007da7df');
        HttpResponse response = p.send(request);
        System.debug('Respose : '+response.getBody());
        System.JSONParser jp = JSON.createParser(response.getBody());
        while(jp.nextToken()!=null){
            if(jp.getText()=='access_token'){
                jp.nextToken();
                accessToken = jp.getText();
            }
        }
        // Calling "getProducts()" method To get the Products in JSON Form
        getProducts();
        createProductRecords();
    }
    //To get the Products in JSON Form
    public void getProducts(){
        String productEndpointURL='https://api.citizensparking.com/cppc-gateway/reef/products/getList';
        Http p = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(productEndpointURL);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('API-KEY', '4b90ucfd0-765f-489f-ad6d-808c8007da7df');
        request.setHeader('Authorization','Bearer '+accessToken);
        HttpResponse response = p.send(request);
        System.debug('Response in JSON'+ response.getBody());
        responseData = response.getBody();
        // Deserialize the JSON and create/Update Products in Salesfornce
        
    }
	
    // Insert the Navision  Items to salesforce Product Object 
    public void createProductRecords(){
        System.JSONParser jpProduct = JSON.createParser(responseData);
        while(jpProduct.nextToken()!= null){
            if(jpProduct.getText()=='error'){
                System.debug('Error in Endpoint');
            }else{
                if(jpProduct.getText()=='number'){
                    jpProduct.nextToken();                        
                    System.debug('Number of Item'+jpProduct.getText());
                }
                if(jpProduct.getText()=='description'){
                    jpProduct.nextToken();
                    
                    System.debug('description : '+jpProduct.getText());
                }
                if(jpProduct.getText()=='unitCost'){
                    jpProduct.nextToken();
                    System.debug('unitCost : '+jpProduct.getText());            
                }
                if(jpProduct.getText()=='unitPrice'){
                    jpProduct.nextToken();
                    System.debug('unitPrice :'+jpProduct.getText());
                }
                if(jpProduct.getText()=='inventory'){
                    jpProduct.nextToken();
                    System.debug('inventory :'+jpProduct.getText());
                }
            }
        }
    }
    
    
    // Wrapper Class to store the Item Fields
    public class ItemWrapper{
        public String Itemnumber;
        public String description;
        public Decimal unitCost;
        public Decimal unitPrice;
        public Integer inventory;
    }
 }