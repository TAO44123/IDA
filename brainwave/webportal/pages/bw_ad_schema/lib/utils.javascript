
function getNbDaysSince1970() {
	var currentMilli = dataset.currentDate.get().getTime();
	var seconds = currentMilli / 1000;
	var minutes = seconds / 60;
	var hours = minutes / 60;
	var days = ((hours / 24) + 0.5 ) | 0;
	
	dataset.nbdays.set(days);

	dataset.d30.set(days-30);
	dataset.d45.set(days-45);
	dataset.d60.set(days-60);
	dataset.d90.set(days-90);
	dataset.d120.set(days-120);
	dataset.d150.set(days-150);
	dataset.d180.set(days-180);

	dataset.dd30.set(days+30);
	dataset.dd45.set(days+45);
	dataset.dd60.set(days+60);
	dataset.dd90.set(days+90);
	dataset.dd120.set(days+120);
	dataset.dd150.set(days+150);
	dataset.dd180.set(days+180);
}
