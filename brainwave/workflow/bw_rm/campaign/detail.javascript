
function onInitialize() {
	
 //  var /*Number*/  nb =  workflow.countView(null, "bwpm_bvprofilesminingperorg", { organisation: dataset.org_uid.get()});
 //  print("[DEBUG] total_progress = "+nb); 
  // dataset.mining_totalprogress.set(nb);
    var /*Number*/ nb = workflow.countView(null, "bvprofilesminingperorg_md_full", { processIdentifier: dataset.processIdentifier.get(), organisation: dataset.org_uid.get(), roleOnly: '1'});   
   //print("[DEBUG] current_progress = "+nb);  
     dataset.mining_currentprogress.set(nb);  
}
