function read() {
  return businessview.getNextRecord();
}

var /*jave.util.HashMap*/ identitycache = null;
var /*java.util.HashSet*/ unknownIdentityCache = null;
function getIdentityCache(hrcode) {
  if (identitycache == null) identitycache = new java.util.HashMap();
  if (unknownIdentityCache == null)
    unknownIdentityCache = new java.util.HashSet();

  var ret = identitycache.get(hrcode);
  if (ret != null)
    // already in cache
    return ret;

  if (unknownIdentityCache.contains(hrcode)) return null; // already not found

  var params = new java.util.HashMap(); // search for identity infos
  params.put("hrcode", hrcode);
  var res = businessview.executeView(null, "br_identity", params);
  ret = null;
  if (res != null && res.length > 0) {
    ret = {};
    ret.uid = res[0].get("uid");
    ret.hrcode = res[0].get("hrcode");
    ret.fullname = res[0].get("fullname");
    ret.mail = res[0].get("mail");
    identitycache.put(hrcode, ret); // store in cache
  } else {
    unknownIdentityCache.add(hrcode); // store search failed
  }

  return ret;
}

function advancedReviewerFinding(/*DataSet*/ record) {
  // Variables accessibles in the javascript
  var applicationowneruid = record.applicationowneruid.get();
  var applicationownerhrcode = record.applicationownerhrcode.get();
  var applicationownerfullname = record.applicationownerfullname.get();
  var applicationownermail = record.applicationownermail.get();
  var permissionowneruid = record.permissionowneruid.get();
  var permissionownerhrcode = record.permissionownerhrcode.get();
  var permissionownerfullname = record.permissionownerfullname.get();
  var permissionownermail = record.permissionownermail.get();
  var defaultrevieweruid = record.defaultrevieweruid.get();
  var defaultreviewerhrcode = record.defaultreviewerhrcode.get();
  var defaultreviewerfullname = record.defaultreviewerfullname.get();
  var defaultreviewermail = record.defaultreviewermail.get();
  var roleuid = record.role_uid.get();
  var rolecode = record.role_code.get();
  var roledisplayname = record.role_displayname.get();
  var permuid = record.perm_uid.get();
  var permcode = record.perm_code.get();
  var permdisplayname = record.perm_displayname.get();
  var appuid = record.app_uid.get();
  var appcode = record.app_code.get();
  var appdisplayname = record.app_displayname.get();
  var perimeteruid = record.perimeteruid.get();
  var perimetercode = record.perimetercode.get();
  var perimeterdisplayname = record.perimeterdisplayname.get();

  var rolecustom1 = record.role_custom1.get();
  var rolecustom2 = record.role_custom2.get();
  var rolecustom3 = record.role_custom3.get();
  var permcustom1 = record.perm_custom1.get();
  var permcustom2 = record.perm_custom2.get();
  var permcustom3 = record.perm_custom3.get();
  var appcustom1 = record.app_custom1.get();
  var appcustom2 = record.app_custom2.get();
  var appcustom3 = record.app_custom3.get();

  // will contain reviewer information for the current line
  var /*String*/ revieweruid = null;
  var /*String*/ reviewerhrcode = null;
  var /*String*/ reviewerfullname = null;
  var /*String*/ reviewermail = null;
  var /*String*/ reviewerorigin = "";

  // compute script
  var evalScript = dataset.reviewerscript.get();

  if (evalScript.indexOf("java.") != -1 || evalScript.indexOf("eval(") != -1) {
    // security check: It is forbidden to instanciate java classes or recursively call eval for security reasons
    print(
      "SECURITY ALERT - Reviewer script contains java classes or eval call"
    );
    return record;
  }

  var /*String*/ strategy = eval(evalScript);

  var strategies = strategy.split(",");

  for (var i = 0; i < strategies.length; i++) {
    strategy = strategies[i].trim();
    if ("applicationowner".equalsIgnoreCase(strategy)) {
      revieweruid = applicationowneruid;
      reviewerhrcode = applicationownerhrcode;
      reviewerfullname = applicationownerfullname;
      reviewermail = applicationownermail;
      reviewerorigin = "applicationowner";
    } else if ("permissionowner".equalsIgnoreCase(strategy)) {
      revieweruid = permissionowneruid;
      reviewerhrcode = permissionownerhrcode;
      reviewerfullname = permissionownerfullname;
      reviewermail = permissionownermail;
      reviewerorigin = "permissionowner";
    } else if ("default".equalsIgnoreCase(strategy)) {
      revieweruid = defaultrevieweruid;
      reviewerhrcode = defaultreviewerhrcode;
      reviewerfullname = defaultreviewerfullname;
      reviewermail = defaultreviewermail;
      reviewerorigin = "default";
    } else {
      // we assume that it is a hrcode instead of a strategy
      var id = getIdentityCache(strategy);
      if (id != null) {
        revieweruid = id.uid;
        reviewerhrcode = id.hrcode;
        reviewerfullname = id.fullname;
        reviewermail = id.mail;
        reviewerorigin = "default";
      }
    }
    // reviewer found
    if (revieweruid != null && reviewermail != null) break;
  }

  // ///////////////////////////////////////////////////////////////////////////////////////////

  // Set reviewer
  if (revieweruid != null && reviewermail != null) {
    record.revieweruid.set(revieweruid);
    record.reviewerhrcode.set(reviewerhrcode);
    record.reviewerfullname.set(reviewerfullname);
    record.reviewermail.set(reviewermail);
    record.reviewerorigin.set(reviewerorigin);
  }

  return record;
}

function standardReviewerFinding(/*DataSet*/ record) {
  // will contain reviewer information for the current line
  var /*String*/ revieweruid = null;
  var /*String*/ reviewerhrcode = null;
  var /*String*/ reviewerfullname = null;
  var /*String*/ reviewermail = null;
  var /*String*/ reviewerorigin = "";

  // ///////////////////////////////////////////////////////////////////////////////////////////

  // precomputing phase: get application owner infos
  var /*String*/ applicationowneruid = null;
  var /*String*/ applicationownerhrcode = null;
  var /*String*/ applicationownerfullname = null;
  var /*String*/ applicationownermail = null;
  if (!record.isEmpty("applicationownermail")) {
    applicationowneruid = record.applicationowneruid.get();
    applicationownerhrcode = record.applicationownerhrcode.get();
    applicationownerfullname = record.applicationownerfullname.get();
    applicationownermail = record.applicationownermail.get();
  }
  
  // precomputing phase: get IAM application owner infos
  var /*String*/ iamapplicationowneruid = null;
  var /*String*/ iamapplicationownerhrcode = null;
  var /*String*/ iamapplicationownerfullname = null;
  var /*String*/ iamapplicationownermail = null;
  if (!record.isEmpty("iamapplicationownermail")) {
    iamapplicationowneruid = record.iamapplicationowneruid.get();
    iamapplicationownerhrcode = record.iamapplicationownerhrcode.get();
    iamapplicationownerfullname = record.iamapplicationownerfullname.get();
    iamapplicationownermail = record.iamapplicationownermail.get();
  }

  // precomputing phase: get default reviewer infos
  var /*String*/ defaultrevieweruid = null;
  var /*String*/ defaultreviewerhrcode = null;
  var /*String*/ defaultreviewerfullname = null;
  var /*String*/ defaultreviewermail = null;
  if (!record.isEmpty("defaultreviewermail")) {
    defaultrevieweruid = record.defaultrevieweruid.get();
    defaultreviewerhrcode = record.defaultreviewerhrcode.get();
    defaultreviewerfullname = record.defaultreviewerfullname.get();
    defaultreviewermail = record.defaultreviewermail.get();
  }

  // precomputing phase: get permission owner infos
  var permissionowneruid = null;
  var permissionownerhrcode = null;
  var permissionownerfullname = null;
  var permissionownermail = null;
  if (!record.isEmpty("permissionownermail")) {
    permissionowneruid = record.permissionowneruid.get();
    permissionownerhrcode = record.permissionownerhrcode.get();
    permissionownerfullname = record.permissionownerfullname.get();
    permissionownermail = record.permissionownermail.get();
  }

  // ///////////////////////////////////////////////////////////////////////////////////////////

  // STEP 1: Option: All accounts are reviewed by the app owner
  if (dataset.forceapplicationowner.get().equals("1") && applicationownermail != null ) {
  	/* PICK ONLY ONE of the two options below*/
  	// Target application owner
    revieweruid = applicationowneruid;
    reviewerhrcode = applicationownerhrcode;
    reviewerfullname = applicationownerfullname;
    reviewermail = applicationownermail;
    reviewerorigin = "applicationowner";
    // IAM/role application owner
    //revieweruid = iamapplicationowneruid;
    //reviewerhrcode = iamapplicationownerhrcode;
    //reviewerfullname = iamapplicationownerfullname;
    //reviewermail = iamapplicationownermail;
    //reviewerorigin = "applicationowner";
  }

  // STEP 2: Option: All accounts are reviewed by the permission owner
  if (dataset.forcepermissionowner.get().equals("1") && permissionownermail != null ) {
    revieweruid = permissionowneruid;
    reviewerhrcode = permissionownerhrcode;
    reviewerfullname = permissionownerfullname;
    reviewermail = permissionownermail;
    reviewerorigin = "permissionowner";
  }
  
  // STEP 3: All remaining accounts are reviewed by the default reviewer
  if (revieweruid == null && defaultreviewermail != null ) {
    revieweruid = defaultrevieweruid;
    reviewerhrcode = defaultreviewerhrcode;
    reviewerfullname = defaultreviewerfullname;
    reviewermail = defaultreviewermail;
    reviewerorigin = "default";
  }

  // ///////////////////////////////////////////////////////////////////////////////////////////

  // Set reviewer
  if (revieweruid != null) {
    record.revieweruid.set(revieweruid);
    record.reviewerhrcode.set(reviewerhrcode);
    record.reviewerfullname.set(reviewerfullname);
    record.reviewermail.set(reviewermail);
    record.reviewerorigin.set(reviewerorigin);
  }

  return record;
}

function setreviewer() {
  var record = businessview.getNextRecord();
  if (record == null) return null;

  if (!dataset.isEmpty("reviewerscript"))
    // advanced mode
    return advancedReviewerFinding(record);
  // standard mode
  else return standardReviewerFinding(record);
}
