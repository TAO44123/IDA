import "customReview.javascript";

function prepareNotReviewedItems() {
  var nrStatuses = ["to be reviewed", "reassign"];
  var /*Array*/ notReviewed = workflow.executeView(dataset.stickyTimeslot.get(), "bwr_reviewcampaignentriesbystatus", {
      campaignid: dataset.campaignId.get(),
      filterbyreviewstatus: nrStatuses,
      filterprocessed: true,
    });
  var defaultStatus = dataset.notReviewedStatus.get(0);
  var defautlComment = dataset.notReviewedComment.get(0);
  var defaultDate = dataset.processDate.get();
  notReviewed.forEach(function (row) {
    dataset.notReviewedRecorduids.add(row.recorduid);
    dataset.notReviewedActionDates.add(defaultDate);
    dataset.notReviewedStatuses.add(defaultStatus);
    dataset.notReviewedComments.add(defautlComment);
  });
}

function prepareRemovedItems() {
  if (dataset.stickyTimeslot.get() == null) {
    dataset.notReviewedRecorduids.clear();
    dataset.notReviewedActionDates.clear();
    dataset.notReviewedStatuses.clear();
    dataset.notReviewedComments.clear();
    // switch to correct view depending on reviewType
    var removedItemsViewId;
    var comment;
    switch (dataset.reviewType.get()) {
      case "right":
      case "servers":
      case "safe":
        removedItemsViewId = "bwaccess360_applicationaccessrightsremovedforcampaign";
        comment = "access rights removed during campaign";
        break;
      case "account":
        removedItemsViewId = "bwaccess360_repositoryaccountsremovedforcampaign";
        comment = "account removed during campaign";
        break;
      case "groupmembers":
        removedItemsViewId = "bwaccess360_repositorygroupmembersremovedforcampaign";
        comment = "group member removed during campaign";
        break;
      case "roles":
        removedItemsViewId = "bwaccess360_roleremovedforcampaign";
        comment = "role removed during campaign";
        break;
      default:
        var /*Array*/ resArray = prepareRemovedItemsCustom(dataset.reviewType.get());
        removedItemsViewId = resArray[0];
        comment = removedItemsViewId[1];
        break;
    }
    var /*Array*/ removedItems = workflow.executeView(null, removedItemsViewId, { campaignid: dataset.campaignId.get() });
    var defaultDate = dataset.processDate.get();
    removedItems.forEach(function (item) {
      dataset.notReviewedRecorduids.add(item.recorduid);
      dataset.notReviewedActionDates.add(defaultDate);
      dataset.notReviewedStatuses.add("revoke");
      dataset.notReviewedComments.add(comment);
    });
  }
}

function prepareRemediationTickets() {
  // the view is not generic because it needs to compute the remediation type and status based on application, account, etc...
  var ticketsToRemediateViewId;
  var remediationItemsViewId;
  switch (dataset.reviewType.get()) {
    case "right":
    case "servers":
    case "safe":
      ticketsToRemediateViewId = "bwaccess360_accessreviewcampaignsentries";
      remediationItemsViewId = "bwaccess360_accessreviewcampaignsentriestoremediate";
      break;
    case "account":
      ticketsToRemediateViewId = "bwaccess360_repositoryaccountsreviewcampaignsentries";
      remediationItemsViewId = "bwaccess360_repositoryaccountsreviewcampaignsentriestoremediate";
      break;
    case "groupmembers":
      ticketsToRemediateViewId = "bwaccess360_repositorygroupmembersreviewcampaignsentries";
      remediationItemsViewId = "bwaccess360_repositorygroupmembersreviewcampaignsentriestoremediate";
      break;
    case "roles":
      ticketsToRemediateViewId = "bwaccess360_rolereviewcampaignsentries";
      remediationItemsViewId = "bwaccess360_rolereviewcampaignsentriestoremediate";
      break;
    default:
      var /*Array*/ resArray = prepareRemediationTicketsCustom(dataset.reviewType.get());
      ticketsToRemediateViewId = resArray[0];
      remediationItemsViewId = resArray[1];
      break;
  }
  // compute the ticket recorduids to remediate
  var /*Array*/ reviewTickets = workflow.executeView(dataset.stickyTimeslot.get(), ticketsToRemediateViewId, {
      campaignid: dataset.campaignId.get(),
      status: ["revoke", "update"],
      filterprocessed: true,
    });
  var /*Array*/ recorduids = reviewTickets.map(function (e) {
      return e.recorduid;
    });

  var /*Array*/ remediationItems = new Array();
  for (var i = 0; i < recorduids.length; i += 1000) {
    var /*Array*/ blocRecorduids = recorduids.slice(i, Math.min(i + 1000, recorduids.length));
    var /*Array*/ blocItems = workflow.executeView(dataset.stickyTimeslot.get(), remediationItemsViewId, { ticketreviewrecorduids: blocRecorduids });
    remediationItems = remediationItems.concat(blocItems);
  }

  var /*Date*/ defaultDate = dataset.processDate.get();
  remediationItems.forEach(function (row) {
    dataset.rt_recorduid.add(row.recorduid);
    dataset.rt_remediationclosed.add(row.remediationclosed);
    dataset.rt_remediationcomment.add(row.remediationcomment);
    dataset.rt_remediationstatus.add(row.remediationstatus);
    dataset.rt_remediationtype.add(row.remediationtype);
    dataset.rt_label.add(row.label);
    dataset.rt_accountableuid.add("");
    dataset.rt_actionDate.add(defaultDate);
  });
  print("Remediations items: " + remediationItems.length);
}

function decrementStickyReviewUsageCounter() {
  if (!dataset.isEmpty("stickyTimeslot")) {
    print("StickyReview>Decrement after finalize:" + dataset.stickyTimeslot.get());
    workflow.decrementReviewCounter(dataset.stickyTimeslot.get());
  }
}
