/* PUBLIC API for sensitivity */

/* returns sensitivity categories as 
   an array of  {code: categoryCode(one letter) ,  label: categoryLabel (string),  content: array of string}
   HARD-CODED for now
 */

function getSensitivityCategories(){
   return [
    {code:"C", 
      label:"Corporate data" , 
      description : [ "Price/cost lists" ,"Target customer lists","New designs","Source code","Formulas","Process advantages","Pending patents","Intellectual property",
      "Unreleased merger acquisition plans and financial reports","Legal documents","Employee personal data" ]} ,
    {code:"T", 
      label:"Transaction data" , 
      description : [ "Bank payments" ,"B2B orders","Vendor data","Sales volumes","Purchase power","Revenue potential","Sales projections","Discount ratios" ]},
     {code:"U", 
      label:"Customer data" , 
      description : [ "Customer list" ,"Spending habits","Contact details","User preferences","Product customer profile","Payment status","Contact history"
        ,"Account balances","Purchase/transaction history","Payment/contract terms" ]},
      {code:"P", 
      label:"Personally identifiable data" , 
      description : [ "Person Full name" ,"Birthday, birthplace","Biometric data","Genetic information","Credit card numbers"
       ,"National identification number, passport numbers","Drivers license number, vehicle registration number"  ,"Associated demographics","Preferences" ]}

];     
}


/* PUBLIC API :
return sensitivity levels (0..4) from normalized cat string eg.  CT or PTU
*/

/*Number*/ function getSensitivityLevelFromCategories( /* String  */ catCodes  ){
   // print("catCodes="+catCodes);
   var level = 0;
   
   if (catCodes == null ) { return null; }
   
   if ((catCodes != "_")&&(catCodes != "&"))  {
      level = catCodes.length;
   }
   
    return level;  
}
