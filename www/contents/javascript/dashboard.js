document.addEventListener("DOMContentLoaded", function(){
	C4.subscribeToDataToUi(false);
    C4.subscribeToVariable("PRODUCTION_KW");
    C4.subscribeToVariable("CONSUMPTION_KW");
    C4.subscribeToVariable("GRID_POWER_KW");
    C4.subscribeToVariable("DAILY_ENERGY_PRODUCTION_KWH");
    C4.subscribeToVariable("DAILY_ENERGY_CONSUMPTION_KWH");
    C4.subscribeToVariable("EXCESS_SOLAR_KW");
});

function updateData(variable, value) {
	console.log("updateData: " + variable + value)
	document.getElementById(variable).textContent=value;
}

function onVariable(variable, value) {
	console.log("Received variable: " + variable + value);
	updateData(variable, value);
}

function onSubscribeToVariableError(variable, message) {
	alert("Error subscribing to variable: " + variable + "," + message);
}