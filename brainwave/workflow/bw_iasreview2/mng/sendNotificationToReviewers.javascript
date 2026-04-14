import "../../bw_portaluar_base/JSON.javascript";
import "../../bw_portaluar_base/utils.javascript";

function computeReviewersAndNotifications() {
  var /*Number*/ campaignid = dataset.campaignId.get();
  // get campaign instance info
  var /*Array*/ results = workflow.executeView(null, "bwaccess360_accessreviewcampaignsbv", { campaignid: campaignid, includecounters: false });
  var inst = results[0];
  var /*Object*/ inst_info = JSON.parse(inst.campaigninstanceinfo);
  var /*Object */ infoCfg = inst_info.cfg.information;
  var /*Object*/ notifCfg = inst_info.cfg.schedule.notification;
  dataset.offlinemode.set(inst.get("offlinemode"));
  dataset.reviewtype.set(inst.get("reviewtype"));

  var name = infoCfg.reviewName;
  var offlineMode = infoCfg.offlineMode;
  var title = inst.title;
  var deadline = inst.duedate;

  //compute reviewers initialNotifications
  if (notifCfg.initialNotification) {
    var reviewerMail = notifCfg.initialNotificationMessage;
    // This is to ensure the dynamic body is correctly parsed if it contains variables.
    var reviewerMailContent = "{$''}" + reviewerMail.content.en;
    var reviewerMailContentFR = "{$''}" + reviewerMail.content.fr;
    var reviewerMailContentES = "{$''}" + reviewerMail.content.es;

    var /* Array */ reviewers = workflow.executeView(null, "bwaccess360_applicationreviewersforcampaignbv", { campaignid: campaignid, filternotsignedofonly: true });
    reviewers.forEach(function (reviewer) {
      dataset.nrReviewerUids.add(reviewer.uid);
      dataset.nrReviewerMails.add(reviewer.mail);
      dataset.nrCampaignIds.add(campaignid);
      dataset.nrCampaignNames.add(name);
      dataset.nrCampaignDescriptions.add(title);
      dataset.nrCampaignDeadlines.add(deadline);
      dataset.nrNotSignedoffOnly.add(false);
      dataset.nrOffline.add(offlineMode);
      dataset.nrMailSubjects.add(reviewerMail.title.en);
      dataset.nrMailSubjectsFR.add(reviewerMail.title.fr);
      dataset.nrMailSubjectsES.add(reviewerMail.title.es);
      dataset.nrMailCCs.add(reviewerMail.cc);
      dataset.nrMailBCCs.add(reviewerMail.bcc);
      dataset.nrMailContents.add(reviewerMailContent);
      dataset.nrMailContentsFR.add(reviewerMailContentFR);
      dataset.nrMailContentsES.add(reviewerMailContentES);
      dataset.nrDelegatorUids.add(reviewer.delegatoruid);
      dataset.nrDelegatorMails.add(reviewer.delegatormail);
      dataset.nrDelegatorHrCodes.add(reviewer.delegatorhrcode);
      dataset.nrDelegatorFullnames.add(reviewer.delegatorfullname);
      dataset.nrDelegatorPreferredLanguages.add(reviewer.delegatorpreferredlanguage);
      dataset.nrDelegatorActives.add(reviewer.isdelegated);
    });
  }
}
