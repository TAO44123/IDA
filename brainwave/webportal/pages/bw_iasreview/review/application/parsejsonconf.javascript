import "../../../../../workflow/bw_portaluar_base/JSON.javascript";
import "../../../../../workflow/bw_portaluar_base/utils.javascript";

// Initial notifications content
function getMailContent() {
	var reviewdefmduid = dataset.reviewdefmduid.get();
	var /*Array*/ results = connector.executeView(null, "bwr_reviewdef", {
		uid: reviewdefmduid,
	});
	if (results.length == 0) {
		throw new java.lang.RuntimeException(
			"Could not find review configuration " + reviewdefmduid
		);
	}
	var /*String*/ jsConfig = results[0].get("cfg_json");
	var /*Object*/ cfg = JSON.parse(jsConfig);
	
	// EN
	var /*String*/ cfg_en = '';
	var /*String*/ cfgtitle_en = '';
	if ( null != cfg.schedule.notification.initialNotificationMessage.content.en ) {
		cfg_en = cfg.schedule.notification.initialNotificationMessage.content.en;
		cfgtitle_en = cfg.schedule.notification.initialNotificationMessage.title.en;
	}
	dataset.cfg_en.set( cfg_en );
	dataset.cfgtitle_en.set( cfgtitle_en );
	// FR
	var /*String*/ cfg_fr = '';
	var /*String*/ cfgtitle_fr = '';
	if ( null != cfg.schedule.notification.initialNotificationMessage.content.fr ) {
		cfg_fr = cfg.schedule.notification.initialNotificationMessage.content.fr;
		cfgtitle_fr = cfg.schedule.notification.initialNotificationMessage.title.fr;
	}
	dataset.cfg_fr.set( cfg_fr );
	dataset.cfgtitle_fr.set( cfgtitle_fr );
	// ES
	var /*String*/ cfg_es = '';
	var /*String*/ cfgtitle_es = '';
	if ( null != cfg.schedule.notification.initialNotificationMessage.content.es ) {
		cfg_es = cfg.schedule.notification.initialNotificationMessage.content.es;
		cfgtitle_es = cfg.schedule.notification.initialNotificationMessage.title.es;
	}
	dataset.cfg_es.set( cfg_es );
	dataset.cfgtitle_es.set( cfgtitle_es );
	// Default / previous (english)
	var /*String*/ cfg_def = '';
	var /*String*/ cfgtitle_def = '';
	dataset.cfg.set( cfg.schedule.notification.initialNotificationMessage.content.en );
	dataset.cfgtitle.set( cfg.schedule.notification.initialNotificationMessage.title.en );
	if ( null != cfg.schedule.notification.initialNotificationMessage.content.en ) {
		cfg_def = cfg.schedule.notification.initialNotificationMessage.content.en;
		cfgtitle_def = cfg.schedule.notification.initialNotificationMessage.title.en;
	}
	dataset.cfg.set( cfg_def );
	dataset.cfgtitle.set( cfgtitle_def );
	// To & CC
	dataset.cfgtocc.set( cfg.schedule.notification.initialNotificationMessage.cc );
	dataset.cfgtobcc.set( cfg.schedule.notification.initialNotificationMessage.bcc );    
}

// Reminder notifications content
function getReminderMailContent() {
	var reviewdefmduid = dataset.reviewdefmduid.get();
	var /*Array*/ results = connector.executeView(null, "bwr_reviewdef", {
		uid: reviewdefmduid,
	});
	if (results.length == 0) {
		throw new java.lang.RuntimeException(
			"Could not find review configuration " + reviewdefmduid
		);
	}
	var /*String*/ jsConfig = results[0].get("cfg_json");
	var /*Object*/ cfg = JSON.parse(jsConfig);
	
	// EN
	var /*String*/ cfg_en = '';
	var /*String*/ cfgtitle_en = '';
	if ( null != cfg.schedule.notification.reminderMessage.content.en ) {
		cfg_en = cfg.schedule.notification.reminderMessage.content.en;
		cfgtitle_en = cfg.schedule.notification.reminderMessage.title.en;
	}
	dataset.cfg_en.set( cfg_en );
	dataset.cfgtitle_en.set( cfgtitle_en );
	// FR
	var /*String*/ cfg_fr = '';
	var /*String*/ cfgtitle_fr = '';
	if ( null != cfg.schedule.notification.reminderMessage.content.fr ) {
		cfg_fr = cfg.schedule.notification.reminderMessage.content.fr;
		cfgtitle_fr = cfg.schedule.notification.reminderMessage.title.fr;
	}
	dataset.cfg_fr.set( cfg_fr );
	dataset.cfgtitle_fr.set( cfgtitle_fr );
	// ES
	var /*String*/ cfg_es = '';
	var /*String*/ cfgtitle_es = '';
	if ( null != cfg.schedule.notification.reminderMessage.content.es ) {
		cfg_es = cfg.schedule.notification.reminderMessage.content.es;
		cfgtitle_es = cfg.schedule.notification.reminderMessage.title.es;
	}
	dataset.cfg_es.set( cfg_es );
	dataset.cfgtitle_es.set( cfgtitle_es );
	// Default / previous (english)
	var /*String*/ cfg_def = '';
	var /*String*/ cfgtitle_def = '';
	dataset.cfg.set( cfg.schedule.notification.reminderMessage.content.en );
	dataset.cfgtitle.set( cfg.schedule.notification.reminderMessage.title.en );
	if ( null != cfg.schedule.notification.reminderMessage.content.en ) {
		cfg_def = cfg.schedule.notification.reminderMessage.content.en;
		cfgtitle_def = cfg.schedule.notification.reminderMessage.title.en;
	}
	dataset.cfg.set( cfg_def );
	dataset.cfgtitle.set( cfgtitle_def );
	// To & CC
	dataset.cfgtocc.set( cfg.schedule.notification.reminderMessage.cc );
	dataset.cfgtobcc.set( cfg.schedule.notification.reminderMessage.bcc );    
}