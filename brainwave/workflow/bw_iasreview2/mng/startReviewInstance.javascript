import "../../bw_portaluar_base/JSON.javascript";
import "../../bw_portaluar_base/utils.javascript";
import "customReview.javascript";

// compute review title, needed for creating the ticketlog
function init() {
  var /*Array*/ results;
  var /*String*/ reviewdefmduid = dataset.reviewdefmduid.get();
  results = workflow.executeView(null, "bwr_reviewdef", { uid: reviewdefmduid });
  if (results.length == 0) {
    throw new java.lang.RuntimeException("Could not find review configuration " + reviewdefmduid);
  }
  var /*String*/ title = results[0].get("label");
  dataset.reviewname.set(title);
  results = workflow.executeView(null, "bwr_reviewinstancemaxnum", { def_uid: reviewdefmduid });
  var nextNum = 1;
  if (results.length > 0) {
    var nb = results[0].get("num");
    if (nb) {
      nextNum = parseInt(nb) + 1;
    }
  }
  dataset.inst_num.set(nextNum);
}

function getPerimeterUids(/*String*/ reviewtype, /*Object*/ cfg) {
  var /*Object*/ perimeterCfg = cfg.perimeter;
  switch (reviewtype) {
    case "servers":
    case "right":
      var /*Array*/ applicationUids;
      if (perimeterCfg.mode === "static") {
        applicationUids = perimeterCfg.applications;
      } else {
        // resolve on passed timeslot
        var /*Array*/ appsInTags = workflow.executeView(dataset.timeslotuid.get(), "bwr_listapplicationintags", {
            tags: perimeterCfg.applicationsTags,
          });
        applicationUids = appsInTags.map(function (a) {
          return a.uid;
        });
      }
      return applicationUids;
    case "safe":
      var /*Array*/ safesUids;
      if (perimeterCfg.mode === "static") {
        safesUids = perimeterCfg.safes;
      } else {
        // resolve on passed timeslot
        var /*Array*/ safesInTags = workflow.executeView(dataset.timeslotuid.get(), "bwr_listsafeintags", {
            tags: perimeterCfg.safesTags,
          });
        safesUids = safesInTags.map(function (a) {
          return a.uid;
        });
      }
      return safesUids;
    case "account":
      var /*Array*/ accountUids;
      if (perimeterCfg.mode === "static") {
        accountUids = perimeterCfg.repositories;
      } else {
        // resolve on passed timeslot
        var /*Array*/ repositoriesInTags = workflow.executeView(dataset.timeslotuid.get(), "bwir_repositorytaglist", {
            tags: perimeterCfg.repositoriesTags,
          });
        accountUids = repositoriesInTags.map(function (a) {
          return a.uid;
        });
      }
      return accountUids;
    case "groupmembers":
      var /*Array*/ groupMembersUids;
      if (perimeterCfg.mode === "static") {
        groupMembersUids = perimeterCfg.repositories;
      } else {
        // resolve on passed timeslot
        var /*Array*/ repositoriesInTags = workflow.executeView(dataset.timeslotuid.get(), "bwir_repositorygrouptaglist", {
            tags: perimeterCfg.repositoriesTags,
          });
        groupMembersUids = repositoriesInTags.map(function (a) {
          return a.uid;
        });
      }
      return groupMembersUids;
    case "roles":
      var /*Array*/ rolesUids;
      var /*Array*/ applicationsUids;
      if (perimeterCfg.mode === "static") {
        rolesUids = perimeterCfg.roles;
        applicationsUids = perimeterCfg.applications;
      } else {
        // resolve on passed timeslot
        var /*Array*/ rolesInTags = workflow.executeView(dataset.timeslotuid.get(), "bwir_iamrolelistwithtags", {
            tags: perimeterCfg.rolesTags,
          });
        rolesUids = rolesInTags.map(function (a) {
          return a.uid;
        });
        var /*Array*/ applicationsInTags = workflow.executeView(dataset.timeslotuid.get(), "bwir_iamapplicationlistwithtags", {
            tags: perimeterCfg.applicationsTags,
          });
        applicationsUids = applicationsInTags.map(function (a) {
          return a.uid;
        });
      }
      return {
        roles: rolesUids,
        apps: applicationsUids,
      };
    default:
      return [];
  }
}

function getReviewItems(/*String*/ reviewtype, perimeter, /*Object*/ cfg) {
  var /*Object*/ strategyCfg = cfg.reviewStrategy.strategy;
  var /*Object*/ decisionHistoryCfg = cfg.reviewStrategy.aiReview.decisionHistory;
  var AidaEnabled = cfg.reviewStrategy.aiReview.aidaEnabled;
  var /*Object*/ perimeterCfg = cfg.perimeter;
  // compute previous review date
  var minimumReviewDate = new Date();
  if (decisionHistoryCfg.enabled) {
    minimumReviewDate = minimumReviewDate.add("d", -decisionHistoryCfg.days);
  }
  var forcehimselfasreviewer = "0";
  var forcedefaultreviewerasreviewer = "0";
  var reviewerstrategyscript = null;
  var defaultReviewerUid = strategyCfg.defaultReviewer.uid;
  switch (reviewtype) {
    case "servers":
      var forcerepositoryownerasreviewer = "0";
      var forcerepositoryownerforallotheraccounts = "0";
      if (strategyCfg.mode === "normal") {
        switch (strategyCfg.type) {
          case "a":
            break;
          case "d":
            forcerepositoryownerforallotheraccounts = "1";
            break;
          case "e":
            forcehimselfasreviewer = "1";
            forcerepositoryownerforallotheraccounts = "1";
            break;
          case "b":
            forcerepositoryownerasreviewer = "1";
            break;
          case "c":
            forcedefaultreviewerasreviewer = "1";
            break;
          default:
            throw new java.lang.RuntimeException("Unknown reviewtype " + strategyCfg.type);
        }
      } else {
        //advanced
        reviewerstrategyscript = strategyCfg.reviewerScript;
      }

      var /*Array*/ reviewItems = workflow.executeView(dataset.timeslotuid.get(), "access360r_serverreviewbv", {
          applicationlist: perimeter,
          includeuseraccounts: perimeterCfg.includeUserAccounts ? "1" : "0",
          includeorphanaccounts: perimeterCfg.includeOrphanedAccounts ? "1" : "0",
          includetechaccounts: perimeterCfg.includeTechnicalAccounts ? "1" : "0",
          includeleaveraccounts: perimeterCfg.includeTerminatedAccounts ? "1" : "0",
          filterbyaccounttag: perimeterCfg.accountsTags,
          filterbypermissiontag: perimeterCfg.permissionsTags.length > 0 ? perimeterCfg.permissionsTags : undefined,
          includelatestreviewstatus: decisionHistoryCfg.enabled ? "1" : "0",
          filterminimumreviewdate: minimumReviewDate.toLDAPString(),
          forcehimselfasreviewer: forcehimselfasreviewer,
          forcerepositoryownerasreviewer: forcerepositoryownerasreviewer,
          forcerepositoryownerforallotheraccounts: forcerepositoryownerforallotheraccounts,
          forcedefaultreviewerasreviewer: forcedefaultreviewerasreviewer,
          defaultrevieweruid: defaultReviewerUid,
          reviewerscript: reviewerstrategyscript,
          computeclusters: AidaEnabled,
          filterifalreadyreviewed: decisionHistoryCfg.hideAlreadyReviewed ? "1" : "0",
          ruleuid: perimeterCfg.perimeterruleuid,
        });
      return reviewItems;
    case "right":
      var forceapplicationownerasreviewer = "0";
      var forceapplicationownerforallotheraccounts = "0";
      var forceaccountownerfortechaccount = "0";
      var forcepermissionowner = "0";
      if (strategyCfg.mode === "normal") {
        switch (strategyCfg.type) {
          case "a":
            break;
          case "f":
            forceaccountownerfortechaccount = "1";
            break;
          case "d":
            forceapplicationownerforallotheraccounts = "1";
            break;
          case "e":
            forcehimselfasreviewer = "1";
            forceapplicationownerforallotheraccounts = "1";
            break;
          case "b":
            forceapplicationownerasreviewer = "1";
            break;
          case "c":
            forcedefaultreviewerasreviewer = "1";
            break;
          case "g":
            forcepermissionowner = "1";
            break;
          default:
            throw new java.lang.RuntimeException("Unknown reviewtype " + strategyCfg.type);
        }
      } else {
        //advanced
        reviewerstrategyscript = strategyCfg.reviewerScript;
      }

      var /*Array*/ reviewItems = workflow.executeView(dataset.timeslotuid.get(), "access360r_applicationaccessrightsreviewbv", {
          applicationlist: perimeter,
          includeuseraccounts: perimeterCfg.includeUserAccounts ? "1" : "0",
          includeorphanaccounts: perimeterCfg.includeOrphanedAccounts ? "1" : "0",
          includetechaccounts: perimeterCfg.includeTechnicalAccounts ? "1" : "0",
          includeleaveraccounts: perimeterCfg.includeTerminatedAccounts ? "1" : "0",
          filterbyaccounttag: perimeterCfg.accountsTags,
          filterbypermissiontag: perimeterCfg.permissionsTags.length > 0 ? perimeterCfg.permissionsTags : undefined,
          includelatestreviewstatus: decisionHistoryCfg.enabled ? "1" : "0",
          filterminimumreviewdate: minimumReviewDate.toLDAPString(),
          forcehimselfasreviewer: forcehimselfasreviewer,
          forceapplicationownerasreviewer: forceapplicationownerasreviewer,
          forceapplicationownerforallotheraccounts: forceapplicationownerforallotheraccounts,
          forcedefaultreviewerasreviewer: forcedefaultreviewerasreviewer,
          forceaccountownerfortechaccount: forceaccountownerfortechaccount,
          forcepermissionowner: forcepermissionowner,
          defaultrevieweruid: defaultReviewerUid,
          reviewerscript: reviewerstrategyscript,
          computeclusters: AidaEnabled,
          filterifalreadyreviewed: decisionHistoryCfg.hideAlreadyReviewed ? "1" : "0",
          ruleuid: perimeterCfg.perimeterruleuid,
        });
      return reviewItems;
    case "safe":
      var forcesafeownerasreviewer = "0";
      var forcesafeownerforallotheraccounts = "0";
      switch (strategyCfg.type) {
        case "a":
          break;
        case "b":
          forcesafeownerasreviewer = "1";
          break;
        case "d":
          forcesafeownerforallotheraccounts = "1";
        case "e":
          forcehimselfasreviewer = "1";
          forcesafeownerforallotheraccounts = "1";
          break;
        case "c":
          forcedefaultreviewerasreviewer = "1";
          break;
        default:
          throw new java.lang.RuntimeException("Unknown reviewtype " + strategyCfg.type);
      }
      var /*Array*/ reviewItems = workflow.executeView(dataset.timeslotuid.get(), "bwir_safeaccessrightsreviewbv", {
          safelist: perimeter,
          includeuseraccounts: perimeterCfg.includeEPVUsers ? "1" : "0",
          includeorphanaccounts: perimeterCfg.includeOrphanedUsers ? "1" : "0",
          includetechaccounts: perimeterCfg.includeAIMAccounts ? "1" : "0",
          includeleaveraccounts: perimeterCfg.includeLeaverUsers ? "1" : "0",
          includebookingusers: perimeterCfg.includeBookingAccounts ? "1" : "0",
          includebuiltinusers: perimeterCfg.includeBuiltInUsers ? "1" : "0",
          filterbyaccounttag: perimeterCfg.userAccountsTags,
          includelatestreviewstatus: decisionHistoryCfg.enabled ? "1" : "0",
          filterminimumreviewdate: minimumReviewDate.toLDAPString(),
          forcehimselfasreviewer: forcehimselfasreviewer,
          forcesafeownerasreviewer: forcesafeownerasreviewer,
          forcesafeownerforallotheraccounts: forcesafeownerforallotheraccounts,
          forcedefaultreviewerasreviewer: forcedefaultreviewerasreviewer,
          defaultrevieweruid: defaultReviewerUid,
          filterifalreadyreviewed: decisionHistoryCfg.hideAlreadyReviewed ? "1" : "0",
          ruleuid: perimeterCfg.perimeterruleuid,
        });
      return reviewItems;
    case "account":
      var forcebusinessownerasreviewer = "0";
      var forcebusinessownerforallotheraccounts = "0";
      if (strategyCfg.mode === "normal") {
        switch (strategyCfg.type) {
          case "a":
            break;
          case "b":
            forcebusinessownerasreviewer = "1";
            break;
          case "d":
            forcebusinessownerforallotheraccounts = "1";
            break;
          case "e":
            forcehimselfasreviewer = "1";
            forcebusinessownerforallotheraccounts = "1";
            break;
          case "c":
            forcedefaultreviewerasreviewer = "1";
            break;
          default:
            throw new java.lang.RuntimeException("Unknown reviewtype " + strategyCfg.type);
        }
      } else {
        //advanced
        reviewerstrategyscript = strategyCfg.reviewerScript;
      }
      var /*Array*/ reviewItems = workflow.executeView(dataset.timeslotuid.get(), "access360r_repositoryaccountsreviewbv", {
          repositorylist: perimeter,
          defaultrevieweruid: defaultReviewerUid,
          includeleaveraccounts: perimeterCfg.includeTerminatedAccounts ? "1" : "0",
          includeorphanaccounts: perimeterCfg.includeOrphanedAccounts ? "1" : "0",
          includetechaccounts: perimeterCfg.includeTechnicalAccounts ? "1" : "0",
          includeuseraccounts: perimeterCfg.includeUserAccounts ? "1" : "0",
          reviewerscript: reviewerstrategyscript,
          filterbyaccounttag: perimeterCfg.accountsTags,
          forcehimselfasreviewer: forcehimselfasreviewer,
          forcebusinessownerasreviewer: forcebusinessownerasreviewer,
          forcebusinessownerforallotheraccounts: forcebusinessownerforallotheraccounts,
          forcedefaultreviewerasreviewer: forcedefaultreviewerasreviewer,
          filterminimumreviewdate: minimumReviewDate.toLDAPString(),
          includelatestreviewstatus: decisionHistoryCfg.enabled ? "1" : "0",
          filterifalreadyreviewed: decisionHistoryCfg.hideAlreadyReviewed ? "1" : "0",
          ruleuid: perimeterCfg.perimeterruleuid,
        });
      return reviewItems;
    case "groupmembers":
      var forcebusinessownerasreviewer = "0";
      var forcebusinessownerforallotheraccounts = "0";
      var forcegroupownerfortechaccounts = "0";
      var forcegroupownerforallotheraccounts = "0";
      var forcegroupownerasreviewer = "0";
      switch (strategyCfg.type) {
        case "a":
          break;
        case "b":
          forcebusinessownerasreviewer = "1";
          break;
        case "d":
          forcebusinessownerforallotheraccounts = "1";
        case "c":
          forcedefaultreviewerasreviewer = "1";
          break;
        case "e":
          forcehimselfasreviewer = "1";
          forcebusinessownerforallotheraccounts = "1";
          break;
        case "f":
          forcegroupownerfortechaccounts = "1";
          break;
        case "g":
          forcegroupownerforallotheraccounts = "1";
          break;
        case "h":
          forcehimselfasreviewer = "1";
          forcegroupownerforallotheraccounts = "1";
          break;
        case "i":
          forcegroupownerasreviewer = "1";
          break;
        default:
          throw new java.lang.RuntimeException("Unknown reviewtype " + strategyCfg.type);
      }
      var /*Array*/ reviewItems = workflow.executeView(dataset.timeslotuid.get(), "access360r_repositorygroupmembersreviewbv", {
          repositorylist: perimeter,
          defaultrevieweruid: defaultReviewerUid,
          filterbyaccounttag: perimeterCfg.accountsTags,
          filterbygrouptag: perimeterCfg.groupsTags,
          forcehimselfasreviewer: forcehimselfasreviewer,
          forcebusinessownerasreviewer: forcebusinessownerasreviewer,
          forcebusinessownerforallotheraccounts: forcebusinessownerforallotheraccounts,
          forcegroupownerfortechaccounts: forcegroupownerfortechaccounts,
          forcegroupownerforallotheraccounts: forcegroupownerforallotheraccounts,
          forcegroupownerasreviewer: forcegroupownerasreviewer,
          forcedefaultreviewerasreviewer: forcedefaultreviewerasreviewer,
          filterminimumreviewdate: minimumReviewDate.toLDAPString(),
          includelatestreviewstatus: decisionHistoryCfg.enabled ? "1" : "0",
          includedynamicgroups: perimeterCfg.includeDynamicGroups ? "1" : "0",
          includegroupswithoutowner: perimeterCfg.includeGroupsWithoutOwners ? "1" : "0",
          includeleaveraccounts: perimeterCfg.includeTerminatedAccounts ? "1" : "0",
          includeorphanaccounts: perimeterCfg.includeOrphanedAccounts ? "1" : "0",
          includetechaccounts: perimeterCfg.includeTechnicalAccounts ? "1" : "0",
          includeuseraccounts: perimeterCfg.includeUserAccounts ? "1" : "0",
          filterifalreadyreviewed: decisionHistoryCfg.hideAlreadyReviewed ? "1" : "0",
          ruleuid: perimeterCfg.perimeterruleuid,
        });
      return reviewItems;
    case "roles":
      var forceapplicationowner = "0";
      var forcepermissionowner = "0";
      switch (strategyCfg.type) {
        case "a":
          forceapplicationowner = "1";
          forcepermissionowner = "1";
          break;
        case "b":
          forceapplicationowner = "1";
          forcepermissionowner = "0";
          break;
        case "c":
          forcepermissionowner = "1";
          forceapplicationowner = "0";
          break;
        case "d":
          forceapplicationowner = "0";
          forcepermissionowner = "0";
          break;
        default:
          throw new java.lang.RuntimeException("Unknown reviewtype " + strategyCfg.type);
      }
      var /*Array*/ reviewItems = workflow.executeView(dataset.timeslotuid.get(), "access360r_rolereviewbv", {
          roles: perimeter.roles,
          iamapps: perimeter.apps,
          defaultrevieweruid: defaultReviewerUid,
          permtags: perimeterCfg.permissionsTags,
          iamapptags: perimeterCfg.applicationsTags,
          permsensitivity: perimeterCfg.permissionsSensitivityLevels,
          filterifalreadyreviewed: decisionHistoryCfg.hideAlreadyReviewed ? "1" : "0",
          includelatestreviewstatus: decisionHistoryCfg.enabled ? "1" : "0",
          filterminimumreviewdate: minimumReviewDate.toLDAPString(),
          rulename: perimeterCfg.perimeterruleuid,
          forceapplicationowner: forceapplicationowner,
          forcepermissionowner: forcepermissionowner,
          filteroutunclassifiedsensitivity: perimeterCfg.permissionsSensitivityLevels.length > 0 ? perimeterCfg.permissionsSensitivityLevels.indexOf(0) == -1 ? "1" : "0" : "0"
        });
      return reviewItems;
    default:
      return [];
  }
}

function isReviewFull(/*String*/ reviewtype, /*Object*/ cfg) {
  var /*Object*/ perimeterCfg = cfg.perimeter;
  switch (reviewtype) {
    case "servers":
    case "right":
      return (
        perimeterCfg.includeUserAccounts &&
        perimeterCfg.includeOrphanedAccounts &&
        perimeterCfg.includeTechnicalAccounts &&
        perimeterCfg.includeTerminatedAccounts &&
        perimeterCfg.accountsTags.length == 0 &&
        perimeterCfg.permissionsTags.length == 0 &&
        perimeterCfg.perimeterruleuid == null
      );
    case "safe":
      return (
        perimeterCfg.includeEPVUsers &&
        perimeterCfg.includeAIMAccounts &&
        perimeterCfg.includeBookingAccounts &&
        perimeterCfg.includeOrphanedUsers &&
        perimeterCfg.includeLeaverUsers &&
        perimeterCfg.includeBuiltInUsers &&
        perimeterCfg.userAccountsTags.length == 0 &&
        perimeterCfg.perimeterruleuid == null
      );
    case "account":
      return (
        perimeterCfg.includeUserAccounts &&
        perimeterCfg.includeOrphanedAccounts &&
        perimeterCfg.includeTechnicalAccounts &&
        perimeterCfg.includeTerminatedAccounts &&
        perimeterCfg.accountsTags.length == 0 &&
        perimeterCfg.perimeterruleuid == null
      );
    case "groupmembers":
      return (
        perimeterCfg.includeUserAccounts &&
        perimeterCfg.includeOrphanedAccounts &&
        perimeterCfg.includeTechnicalAccounts &&
        perimeterCfg.includeTerminatedAccounts &&
        perimeterCfg.includeDynamicGroups &&
        perimeterCfg.includeGroupsWithoutOwners &&
        perimeterCfg.accountsTags.length == 0 &&
        perimeterCfg.groupsTags.length == 0 &&
        perimeterCfg.perimeterruleuid == null
      );
    case "roles":
      return (
        perimeterCfg.permissionsTags.length == 0 &&
        perimeterCfg.perimeterruleuid == null &&
        perimeterCfg.permissionsSensitivityLevels.length == 0
      );
    default:
      return true;
  }
}

function setDatasetCampaignValues(/*String*/ reviewtype) {
  switch (reviewtype) {
    case "servers":
      dataset.statuspage.set("bwaccess360_accessreviewmanagementdetailserver");
      dataset.reviewpage.set("bwaccess360_serverreviewpage");
      break;
    case "right":
      dataset.statuspage.set("bwaccess360_accessreviewmanagementdetailright");
      dataset.finalizepage.set("bwaccess360_accessrightsreviewcampaignfinalize");
      dataset.reviewpage.set("bwaccess360_accessrightsreviewpage");
      break;
    case "safe":
      dataset.statuspage.set("bwir_safeaccessreviewmanagementdetailright");
      dataset.finalizepage.set("bwir_safeaccessreviewcampaignfinalize");
      dataset.reviewpage.set("bwir_safeaccessrightsreviewpage");
      break;
    case "account":
      dataset.statuspage.set("bwaccess360_accessreviewmanagementdetailaccount");
      dataset.finalizepage.set("bwaccess360_accountsreviewcampaignfinalize");
      dataset.reviewpage.set("bwaccess360_accountsreviewpage");
      break;
    case "groupmembers":
      dataset.statuspage.set("bwaccess360_groupmembersreviewmanagementdetail");
      dataset.finalizepage.set("bwaccess360_groupmembersreviewcampaignfinalize");
      dataset.reviewpage.set("bwaccess360_groupmembersreviewpage");
      break;
    case "roles":
      dataset.statuspage.set("bwaccess360_rolereviewmanagementdetail");
      dataset.finalizepage.set("bwaccess360_rolereviewcampaignfinalize");
      dataset.reviewpage.set("bwaccess360_rolereviewpage");
      break;
    default:
      setDatasetCustomCampaignValues(reviewtype);
      break;
  }
}

function saveInstanceCfgJson(/*String*/ reviewtype, /*Object*/ cfg, /*Array*/ perimeter, /*Array*/ reminderDates, /*String*/ previousTimeslot) {
  var /*Object*/ inst_cfg_json;
  inst_cfg_json = {
    cfg: cfg,
    instance: {
      previousTimeslot: previousTimeslot,
      reminderDates: reminderDates,
      perimeter: {
        applications: perimeter,
      },
    },
  };
  var /*String*/ inst_info = JSON.stringify(inst_cfg_json, function (key, value) {
      // date is already a string, because of Date.toJSON
      // so first convert back to Date, before reformatting
      if (key == "startDate") {
        var /*Date*/ date = Date.fromISOString(value);
        return toISODateString(date);
      }
      if (key == "reminderDates") {
        return value.map(function (date) {
          return toISODateString(date);
        });
      }
      return value;
    });
  dataset.inst_info.set(inst_info);
}

//TODO resolve depending on 4 review types

function computeReviewParams() {
  /* add dummy delay to slowdown workflow
  var  delay = dataset.delay.get();
  if (delay > 0) {
  	 java.lang.Thread.sleep(delay*1000);
  }*/

  var /*String*/ campaignid = dataset.ticketlogrecorduid.toString();

  var /*Array*/ results;

  /*parse review config*/
  var /*String*/ reviewdefmduid = dataset.reviewdefmduid.get();
  var /*String*/ timeslotUid = dataset.timeslotuid.get();
  results = workflow.executeView(null, "bwr_reviewdef", { uid: reviewdefmduid });
  if (results.length == 0) {
    throw new java.lang.RuntimeException("Could not find review configuration " + reviewdefmduid);
  }
  var /*String*/ reviewtype = results[0].get("reviewType").toString();
  dataset.reviewtype.set(reviewtype);
  dataset.remediationtype.set(reviewtype);
  var /*String*/ jsConfig = results[0].get("cfg_json");
  var /*Object*/ cfg = JSON.parse(jsConfig);
  var /*Object*/ perimeterCfg = cfg.perimeter;
  var /*Object*/ informationCfg = cfg.information;
  var /*Object*/ strategyCfg = cfg.reviewStrategy.strategy;
  var /*Object*/ decisionHistoryCfg = cfg.reviewStrategy.aiReview.decisionHistory;
  var /*Object*/ schedulingCfg = cfg.schedule.scheduling;
  var /*Object*/ notifCfg = cfg.schedule.notification;
  var AidaEnabled = cfg.reviewStrategy.aiReview.aidaEnabled;

  /*resolve review config*/
  var /*Array*/ perimeter = getPerimeterUids(reviewtype, cfg);

  /*compute review items*/

  var /*Array*/ reviewItems = getReviewItems(reviewtype, perimeter, cfg);

  /*Set workflow local vars for creating the tickets and metadata*/

  var /*boolean*/ isFullReview = isReviewFull(reviewtype, cfg);

  /* warning API doc is not correct, task vars must be the 3rd arg and workflow.executeProcess does not work, 
   so we merge the script into the subprocess instead of calling it */

  /*fill mv variables for review tickets from view result*/
  dataset.reviewers.clear();
  dataset.reviewersorigin.clear();
  dataset.accounts.clear();
  dataset.permissions.clear();
  dataset.perimeters.clear();
  dataset.status.clear();
  dataset.comment.clear();
  dataset.identitypositionkeys.clear();
  dataset.rightlabels.clear();
  dataset.signoffstate.clear();
  dataset.ai_preapproved.clear();
  dataset.ai_anomalous.clear();
  dataset.ai_firstclusterid.clear();
  dataset.ai_clustersid.clear();
  dataset.ai_maxclusterid.clear();

  var demoMode = config.aida_demo_mode == "true";

  reviewItems.forEach(function (/*java.util.Map*/ a) {
    var /*String*/ reviewstatus = a.reviewstatus;

    if (AidaEnabled) {
      // anomalous
      var account_leaver = a.reconnoownercode == "leave";
      var account_dormant = demoMode ? a.accountunused_demo : a.accountunused;
      var account_orphan = a.identityuid == null && a.reconnoownercode == null;
      var /*String*/ ai_anomalous = account_leaver ? "L" : account_orphan ? "O" : account_dormant ? "D" : "";
      // preapproved
      var /*String*/ ai_preapproved;
      if (reviewstatus == "ok") {
        if (!ai_anomalous.isEmpty()) {
          ai_preapproved = "A";
        } else ai_preapproved = "P";
      } else {
        ai_preapproved = "";
      }

      // isolated means anything else, so won't be set

      dataset.ai_anomalous.add(ai_anomalous);
      dataset.ai_preapproved.add(ai_preapproved);
      dataset.ai_firstclusterid.add(a.ai_firstclusterid);
      dataset.ai_clustersid.add(a.ai_clusterids);
      dataset.ai_maxclusterid.add(a.ai_maxclusterid);
      dataset.status.add("to be reviewed");
      dataset.comment.add(null); // always clear comment
    } else {
      dataset.status.add(reviewstatus == null || reviewstatus.isEmpty() ? "to be reviewed" : reviewstatus);
      dataset.comment.add(a.reviewcomment);
      dataset.ai_anomalous.add(null);
      dataset.ai_preapproved.add(null);
      dataset.ai_firstclusterid.add(null);
      dataset.ai_clustersid.add(null);
      dataset.ai_maxclusterid.add(null);
    }
    dataset.reviewers.add(a.revieweruid);
    dataset.reviewersorigin.add(a.reviewerorigin);

    /* we need to set all review-specific fields for all reviews 
      so that the structure variables are always of the same size
      non-provided values will be set to null */
    dataset.accounts.add(a.accountuid); //safe, right, groupmembers, account
    dataset.groups.add(a.groupuid); //groupmembers
    if (reviewtype == "roles") {
      dataset.perimeters.add(a.perimeteruid);
      dataset.permissions.add(a.perm_uid);
      dataset.parent_permissions.add(a.role_uid);
    } else {
      dataset.permissions.add(a.permissionuid); // safe , right
      dataset.perimeters.add(a.rightperimeteruid); // safe, right
    }

    // if AIDA is enabled don't  pre-approuve. we already have the flags
    dataset.identitypositionkeys.add(a.identitypositionkey);
    switch (reviewtype) {
      case "servers":
      case "right":
      case "safe":
        dataset.rightlabels.add(a.rightlabel);
        break;
      case "account":
        dataset.rightlabels.add(a.accountlabel);
        break;
      case "groupmembers":
        dataset.rightlabels.add(a.grouplabel);
        break;
      case "roles":
        dataset.rightlabels.add(a.rolelabel);
        break;
      default:
        throw new java.lang.RuntimeException("Unknown reviewtype " + reviewtype);
    }
    dataset.signoffstate.add("0"); // not signedoff
  });

  /*set other local vars*/
  setDatasetCampaignValues(reviewtype);
  dataset.reviewdescription.set(informationCfg.reviewDescription);
  dataset.prioritylevel.set(informationCfg.reviewPriority);
  var /*Date*/ deadline = dataset.startDate.get().add("day", schedulingCfg.duration);
  dataset.deadline.set(deadline);
  dataset.offlinemode.set(informationCfg.offlineMode ? "1" : "0");
  if (informationCfg.stickyReview) {
    var /*String*/ timeslotuid = dataset.timeslotuid.get();
    dataset.stickyTimeslot.set(timeslotuid);
    dataset.stickyTimeslotLabel.set(computeTimeslotLabel(timeslotuid));
  }
  var authorizedActions = cfg.reviewUI.actions;
  dataset.selfdelegation.set(authorizedActions.askForHelp ? "1" : "0");
  dataset.isafullreview.set(isFullReview);

  //compute reminder dates
  var /*Array*/ reminderDates = computeReminderDates(schedulingCfg, notifCfg);
  var previousTimeslot = computePreviousTimeslot();

  // store instance json config
  saveInstanceCfgJson(reviewtype, cfg, perimeter, reminderDates, previousTimeslot);

  //we send notif after startup if enabled and not on hold at startup
  var /*Boolean*/ startOnHold = schedulingCfg.startOnHold == true;
  dataset.sendNotifications.set(notifCfg.initialNotification && !startOnHold);
  //update current status ( we be set later)
  dataset.currentstatus.set(startOnHold ? "onhold" : "active");
}

function computePreviousTimeslot() {
  var /*String*/ reviewdefmduid = dataset.reviewdefmduid.get();
  var /*Array*/ results = workflow.executeView(null, "bwr_reviewpreviewtimeslot", { def_uid: reviewdefmduid });
  if (results.length > 0) return results[0].get("timeslotuid");
  else return null;
}

function computeTimeslotLabel(timeslotuid) {
  var results = workflow.executeView(null, "bwr_timeslotlabel", { uid: timeslotuid });
  if (results.length > 0) {
    return results[0].displayname;
  } else return null;
}

function computeReminderDates(/*Object*/ schedulingCfg, /*Object*/ notifCfg) {
  var /*Array*/ reminderDates = [];
  if (notifCfg.reminderStrategy) {
    var /*Number*/ duration = schedulingCfg.duration;
    var /*Date*/ startDate = dataset.startDate.get();
    truncateDate(startDate);
    var /*Date*/ reminderDate;
    var n = notifCfg.reminderStartAfter;
    var inc = notifCfg.reminderFrequency;
    while (n < duration) {
      reminderDate = startDate.add("d", n);
      reminderDates.push(reminderDate);
      n += inc;
    }
  }
  return reminderDates;
}

function incrementStickyCampaignUsageCounter() {
  if (!dataset.isEmpty("stickyTimeslot")) {
    print("StickyReview>Increment after launch:" + dataset.stickyTimeslot.get());
    workflow.incrementReviewCounter(dataset.stickyTimeslot.get());
  }
}
